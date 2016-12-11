/*************************************************
 * MorIARTy - Morphological Image Analysis and Recognition Toolbox
 * Copyright (C) 2016  MorIARTy Team
 *
 * Authors:
 *  Andrey Zubyuk
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 ************************************************/

#include <algorithm>
#include <vector>
#include "api_scilab.h"
#include "sciprint.h"
#include "Scierror.h"
#include "common.h"

using namespace std;

extern "C" int grmos_quantize(char *fname, unsigned long fname_len) {
    CheckInputArgument(pvApiCtx, 2, 2);
    int nargin = nbInputArgument(pvApiCtx);
    int nargout = nbOutputArgument(pvApiCtx);

    // Get the 1-st argument - data array
    int *p_data;
    TEST_ERROR(getVarAddressFromPosition(pvApiCtx, 1, &p_data));
    int *dims, ndims, numel;
    double *data;
    getSciRealArray(p_data, &dims, &ndims, &numel, &data);

    // Get the 2-nd argument - vector of brightnesses
    int *p_v;
    TEST_ERROR(getVarAddressFromPosition(pvApiCtx, 2, &p_v));
    int v_rows, v_cols;
    double *v0;
    TEST_ERROR(getMatrixOfDouble(pvApiCtx, p_v, &v_rows, &v_cols, &v0));
    if(min(v_rows, v_cols) != 1) {
        PRINT_ERROR("The 2-nd argument must be a vector.");
    }
    int len = max(v_rows, v_cols);
    vector<double> v(len);
    for (int i = 0; i < len; i++) v[i] = v0[i];

    // Prepare the output - mark the regions
    double *regions = new double[numel];
    for (int i = 0; i < numel; i++) {
        vector<double>::iterator it = lower_bound(v.begin(), v.end(), data[i]);
        regions[i] = it - v.begin() + 1;
    }

    // Return the output
    createSciRealArray(nargin + 1, dims, ndims, regions);
    delete [] regions;
    AssignOutputVariable(pvApiCtx, 1) = nargin + 1;
    return 0;
}

extern "C" int grmos_set_region_values(char *fname, unsigned long fname_len) {
    CheckInputArgument(pvApiCtx, 2, 2);
    int nargin = nbInputArgument(pvApiCtx);

    // Get the 1-st argument - shape regions
    int *p_regions;
    TEST_ERROR(getVarAddressFromPosition(pvApiCtx, 1, &p_regions));
    int *dims, ndims, numel;
    double *regions;
    getSciRealArray(p_regions, &dims, &ndims, &numel, &regions);

    // Get the 2-nd argument - vector of brightnesses
    int *p_v;
    TEST_ERROR(getVarAddressFromPosition(pvApiCtx, 2, &p_v));
    int v_rows, v_cols;
    double *v;
    TEST_ERROR(getMatrixOfDouble(pvApiCtx, p_v, &v_rows, &v_cols, &v));
    if(min(v_rows, v_cols) != 1) {
        PRINT_ERROR("The 2-nd argument must be a vector.");
    }
    int len = max(v_rows, v_cols);

    // Set brightnesses of the regions
    double *data = new double[numel];
    for (int i = 0; i < numel; i++) {
        int r = floor(regions[i]) - 1;
        if (r >= 0) data[i] = v[r];
    }

    // Return the output
    createSciRealArray(nargin + 1, dims, ndims, data);
    delete [] data;
    AssignOutputVariable(pvApiCtx, 1) = nargin + 1;
    return 0;
}

extern "C" int grmos_measure_region_areas(char *fname, unsigned long fname_len) {
    CheckInputArgument(pvApiCtx, 1, 2);
    int nargin = nbInputArgument(pvApiCtx);
    int nargout = nbOutputArgument(pvApiCtx);

    // Get the 1-st argument - shape regions
    int *p_regions;
    TEST_ERROR(getVarAddressFromPosition(pvApiCtx, 1, &p_regions));
    int *dims, ndims, numel;
    double *regions;
    getSciRealArray(p_regions, &dims, &ndims, &numel, &regions);

    double number_of_regions = 0;
    if (nargin >= 2) {
        // Get the 2-nd argument - number of regions
        int *p_number_of_regions;
        TEST_ERROR(getVarAddressFromPosition(pvApiCtx, 2, &p_number_of_regions));
        if (getScalarDouble(pvApiCtx, p_number_of_regions, &number_of_regions)) {
            PRINT_ERROR("The 2-nd argument must be an integer scalar.");
        }
        number_of_regions = floor(number_of_regions);
    } else {
        // Calculate number of regions
        for (int i = 0; i < numel; i++) {
            if (regions[i] > number_of_regions) number_of_regions = regions[i];
        }
    }

    // Measure the region areas
    double *areas;
    TEST_ERROR(allocMatrixOfDouble(pvApiCtx, nargin + 1, 1, number_of_regions, &areas));
    bzero(areas, sizeof(double) * number_of_regions);

    for (int i = 0; i < numel; i++) {
        int r = floor(regions[i]) - 1;
        if (r >= 0) areas[r] += 1;
    }

    // Return the output - areas
    AssignOutputVariable(pvApiCtx, 1) = nargin + 1;
    return 0;
}

extern "C" int grmos_sum_over_regions(char *fname, unsigned long fname_len) {
    CheckInputArgument(pvApiCtx, 2, 3);
    int nargin = nbInputArgument(pvApiCtx);

    // Get the 1-st argument - data array
    int *p_data;
    TEST_ERROR(getVarAddressFromPosition(pvApiCtx, 1, &p_data));
    int *dims, ndims, numel;
    double *data;
    getSciRealArray(p_data, &dims, &ndims, &numel, &data);
    int nargout = nbOutputArgument(pvApiCtx);

    // Get the 2-nd argument - shape regions
    int *p_regions;
    TEST_ERROR(getVarAddressFromPosition(pvApiCtx, 2, &p_regions));
    int *rgn_dims, rgn_ndims, rgn_numel;
    double *regions;
    getSciRealArray(p_regions, &rgn_dims, &rgn_ndims, &rgn_numel, &regions);

    bool inconsistent_dims = false;
    if (ndims != rgn_ndims || numel != rgn_numel) inconsistent_dims = true;
    for (int i = 0; !inconsistent_dims && i < ndims; i++) {
        if (dims[i] != rgn_dims[i]) inconsistent_dims = true;
    }
    if (inconsistent_dims) PRINT_ERROR("Inconsistent data and shape sizes.");

    double number_of_regions = 0;
    if (nargin >= 3) {
        // Get the 3-rd argument - number of regions
        int *p_number_of_regions;
        TEST_ERROR(getVarAddressFromPosition(pvApiCtx, 3, &p_number_of_regions));
        if (getScalarDouble(pvApiCtx, p_number_of_regions, &number_of_regions)) {
            PRINT_ERROR("The 3-rd argument must be an integer scalar.");
        }
        number_of_regions = floor(number_of_regions);
    } else {
        // Calculate number of regions
        for (int i = 0; i < numel; i++) {
            if (regions[i] > number_of_regions) number_of_regions = regions[i];
        }
    }

    // Sum over the regions
    double *sums;
    TEST_ERROR(allocMatrixOfDouble(pvApiCtx, nargin + 1, 1, (int)number_of_regions, &sums));
    bzero(sums, sizeof(double) * number_of_regions);
    for (int i = 0; i < numel; i++) {
        int r = floor(regions[i]) - 1;
        if (r >= 0) sums[r] += data[i];
    }

    // Return the output - sums
    AssignOutputVariable(pvApiCtx, 1) = nargin + 1;
    return 0;
}


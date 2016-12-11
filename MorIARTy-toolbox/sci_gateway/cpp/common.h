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

#ifndef _MORIARTY_CPP_COMMON_H_
#define _MORIARTY_CPP_COMMON_H_

#include <stdlib.h>
#include <string.h>
#include "api_scilab.h"
#include "sciprint.h"
#include "Scierror.h"

#ifndef __GNUC__
#define bzero(memArea, len) memset((memArea), 0, (len))
#endif

#define PRINT_ERROR(message) Scierror(10000, "%s: %d - %s\n", __FILE__, __LINE__, message);

#define TEST_ERROR(err) \
{ \
    if(err.iErr) { \
        PRINT_ERROR("Scilab routine failure."); \
    } \
}

void getSciRealArray(
    int *sciVarPtr,
    int **dims, int *ndims, int *numel,
    double **pReal);
void createSciRealArray(int varNum, int dims[], int ndims, const double *pReal);

#endif

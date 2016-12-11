//////////////////////////////////////////////////
// MorIARTy - Morphological Image Analysis and Recognition Toolbox
// Copyright (C) 2016  MorIARTy Team
//
// Authors:
//  Andrey Zubyuk
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//////////////////////////////////////////////////

function proj_norm_calc = _MGrMosPrepProjNorm(projection, options)
// Helper function.
//
// Parameters
//  projection: Projection.
//  options: Required parameters of a calculation process.
//  proj_norm_calc: A structure containing the prepared data.

    // Fill in the common fields
    proj_norm_calc = struct();
    proj_norm_calc.obj_name = "projection norm calculator";

    select options.translation
//////////////////////////////////////////////////
    case "no" then
        proj_norm_calc.proj_norm_type = [ ...
            "grayscale", ...    // data
            "mosaic", ...       // shape
            "orthogonal", ...   // projection
            "no" ...            // translation
        ];
        proj_norm_calc.projection = projection;
//////////////////////////////////////////////////
    case "brute-force" then
        proj_norm_calc.proj_norm_type = [ ...
            "grayscale", ...    // data
            "mosaic", ...       // shape
            "orthogonal", ...   // projection
            "brute-force" ...   // translation
        ];
        proj_norm_calc.number_of_regions = projection.shape.number_of_regions;
        proj_norm_calc.regions = projection.shape.regions;
        proj_norm_calc.region_areas = projection.shape.region_areas;
//////////////////////////////////////////////////
    case "fft" then
        proj_norm_calc.proj_norm_type = [ ...
            "grayscale", ...    // data
            "mosaic", ...       // shape
            "orthogonal", ...   // projection
            "fft" ...           // translation
        ];

        proj_norm_calc.number_of_regions = projection.shape.number_of_regions;
        proj_norm_calc.data_size = options.data_size;
        proj_norm_calc.region_areas = projection.shape.region_areas;
        proj_norm_calc.window_size = projection.shape.data_size;

        // Sizes
        dt_size = options.data_size;
        sh_size = proj_norm_calc.window_size;
        dims = length(dt_size);
        if dims ~= length(sh_size) then
            error("Incorrect data size.");
        end

        // Prepare indices
        indicator_func_place = msprintf("%d : -1 : 1", sh_size(1));
        crop_place = msprintf("%d : $", sh_size(1));
        for i = 2 : dims
            indicator_func_place = indicator_func_place + ...
                msprintf(", %d : -1 : 1", sh_size(i));
            crop_place = crop_place + msprintf(", %d : $", sh_size(i));
        end
       
        // Prepare an array to hold the full indicator functions
        cmd_dt_size = msprintf("%d", dt_size(1));
        for i = 2 : dims
            cmd_dt_size = cmd_dt_size + msprintf(", %d", dt_size(i));
        end
        cmd = "indicator_func_full = zeros(" + cmd_dt_size + ");";
        execstr(cmd);

        // Fourier transform of the full indicator functions
        proj_norm_calc.basis_ft = list();
        fftw_forget_wisdom();
        for i = 1 : projection.shape.number_of_regions
            indicator_func_small = projection.shape.regions == i;
            cmd = "indicator_func_full(" + indicator_func_place + ...
                ") = indicator_func_small;";
            execstr(cmd);
            proj_norm_calc.basis_ft(i) = fft(indicator_func_full);
        end

        proj_norm_calc.fft_wisdom = get_fftw_wisdom();
        fftw_forget_wisdom();
        ifft(proj_norm_calc.basis_ft(1));
        proj_norm_calc.ifft_wisdom = get_fftw_wisdom();

        deff("y = _crop_func(x)", "y = x(" + crop_place + ");");
        proj_norm_calc.crop = _crop_func;
//////////////////////////////////////////////////
    else
        error("Incorrect translation.");
    end
endfunction

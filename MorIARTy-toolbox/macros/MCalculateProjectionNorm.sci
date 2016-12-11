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

function proj_norm = MCalculateProjectionNorm(proj_norm_calc, data)
// Calculate norm of the projection of the given image.
//
// Calling Sequence
//  proj_norm = MCalculateProjectionNorm(proj_norm_calc, data)
//
// Parameters
//  proj_norm_calc: A structure containing the data prepared to calculate projection norm.
//  data: An image which projection norm needs to be calculated
//  proj_norm: Norm of the projection of the given image.
//
// Description
//  <link linkend="MCalculateProjectionNorm">MCalculateProjectionNorm()</link>
//  returns norm of the projection of the given image.
//
// Examples
//  // Create a shape and a projection onto it
//  img1 = imread(fullpath(MorIARTyPath() + "/images/svo/airplane.png"));
//  img1 = im2double(img1(:, :, 1));
//  shape = MCreateMosaicShape(img1, "grayscale");
//  projection = MCreateProjection(shape);
//
//  // Read another image
//  img2 = imread(fullpath(MorIARTyPath() + "/images/svo/svo.png"));
//  img2 = im2double(img2(:, :, 1));
//
//  // Prepare to calculate a projection norm
//  options = struct();
//  options.translation = "fft";
//  options.data_size = size(img2);
//  proj_norm_calc = MPrepareProjectionNorm(projection, options);
//
//  // Calculate the norm of the projection
//  proj_norm = MCalculateProjectionNorm(proj_norm_calc, img2);
//  
// See also
//  MPrepareProjectionNorm
//  MCalculateNorm
//
// Authors
//  Andrey Zubyuk

    // Validate the arguments
    if argn(2) < 2 then
        _MError(2, 2);
    end

    // Dispatch
    select proj_norm_calc.proj_norm_type
//////////////////////////////////////////////////
    case ["grayscale", "mosaic", "orthogonal", "no"] then
        pdata = MProject(proj_norm_calc.projection, data);
        proj_norm = norm(pdata(:));
//////////////////////////////////////////////////
    case ["grayscale", "mosaic", "orthogonal", "brute-force"] then
        data_size = size(data);
        frag_size = size(proj_norm_calc.regions);
        if length(data_size) ~= length(frag_size) then
            error("Incorrect data size.");
        end
        sz = zeros(1, length(data_size))
        szl = list();
        cmd_ind_pat = "";
        for i = 1 : length(data_size)
            sz(i) = data_size(i) - frag_size(i) + 1;
            szl(i) = sz(i);
            if i ~= 1 then
                cmd_ind_pat = cmd_ind_pat + ", ";
            end
            cmd_ind_pat = cmd_ind_pat + "%d : %d";
        end
        proj_norm = zeros(szl(:));
        if proj_norm_calc.number_of_regions == 0 then
            return;
        end

        ind = zeros(1, 2 * length(data_size));
        for i = 1 : prod(sz)
            sub = ind2sub(sz, i);
            ind(1 : 2 : $) = sub;
            ind(2 : 2 : $) = sub + frag_size - 1;
            cmd_ind = msprintf(cmd_ind_pat, ind);
            cmd = "data_frag = data(" + cmd_ind + ");";
            execstr(cmd);
            v = _MGrMosSumOverRegions(data_frag, proj_norm_calc.regions, ...
                proj_norm_calc.number_of_regions);
            proj_norm(i) = sqrt(sum( (v.^2) ./ proj_norm_calc.region_areas ));
        end
//////////////////////////////////////////////////
    case ["grayscale", "mosaic", "orthogonal", "fft"] then
        proj_norm = zeros(data);
        set_fftw_wisdom(proj_norm_calc.fft_wisdom);
        data_ft = fft(data);
        set_fftw_wisdom(proj_norm_calc.ifft_wisdom);
        for i = 1 : proj_norm_calc.number_of_regions
            basis_func_ft = proj_norm_calc.basis_ft(i);
            ft = data_ft .* basis_func_ft;
            proj_norm = proj_norm + real(ifft(ft)).^2 / proj_norm_calc.region_areas(i);
        end
        proj_norm = sqrt(proj_norm_calc.crop(proj_norm));
//////////////////////////////////////////////////
    else
        error("Incorrect projection norm calculator.");
    end
endfunction

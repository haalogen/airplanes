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

function data_norm = MCalculateNorm(norm_calc, data)
// Calculate norm of the given image.
//
// Calling Sequence
//  data_norm = MCalculateNorm(norm_calc, data)
//
// Parameters
//  norm_calc: A structure containing the data prepared to calculate norm.
//  data: An image which norm needs to be calculated
//  data_norm: Norm of the given image.
//
// Description
//  <link linkend="MCalculateNorm">MCalculateNorm()</link>
//  returns norm of the given image.
//
// Examples
//  // Read an image
//  img = imread(fullpath(MorIARTyPath() + "/images/svo/svo.png"));
//  img = im2double(img(:, :, 1));
//
//  // Prepare to calculate a norm
//  options = struct();
//  options.translation = "fft";
//  options.window_size = [30, 30];
//  options.data_size = size(img);
//  norm_calc = MPrepareNorm(options, "grayscale");
//
//  // Calculate the norm
//  img_norm = MCalculateNorm(norm_calc, img);
//  
// See also
//  MPrepareNorm
//  MCalculateProjectionNorm
//
// Authors
//  Andrey Zubyuk

    // Validate the arguments
    if argn(2) < 2 then
        _MError(2, 2);
    end

    // Dispatch
    select norm_calc.norm_type
//////////////////////////////////////////////////
    case ["grayscale", "no"] then
        data_norm = norm(data(:));
//////////////////////////////////////////////////
    case ["grayscale", "brute-force"] then
        data_size = size(data);
        frag_size = norm_calc.window_size;
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
        data_norm = zeros(szl(:));

        ind = zeros(1, 2 * length(data_size));
        for i = 1 : prod(sz)
            sub = ind2sub(sz, i);
            ind(1 : 2 : $) = sub;
            ind(2 : 2 : $) = sub + frag_size - 1;
            cmd_ind = msprintf(cmd_ind_pat, ind);
            cmd = "data_frag = data(" + cmd_ind + ");";
            execstr(cmd);
            data_norm(i) = norm(data_frag(:));
        end
//////////////////////////////////////////////////
    case ["grayscale", "fft"] then
        data_norm = sqrt(MCalculateProjectionNorm(norm_calc, data.^2) * ...
            sqrt(norm_calc.region_areas));
//////////////////////////////////////////////////
    else
        error("Incorrect norm calculator.");
    end
endfunction

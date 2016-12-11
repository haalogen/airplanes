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

function norm_calc = MPrepareNorm(options, data_type)
// Prepare to calculate norm of an image.
//
// Calling Sequence
//  norm_calc = MPrepareNorm(options, data_type)
//
// Parameters
//  options: Required parameters of a calculation process.
//  data_type: Image type: "grayscale" (or simply "gray") or "color" (only "grayscale" is now implemented). May be omitted which means "grayscale".
//  norm_calc: A structure containing the prepared data.
//
// Description
//  <link linkend="MPrepareNorm">MPreareNorm()</link>
//  prepares all auxiliary data necessary to calculate norm of an image.
//  The returned structure norm_calc contains the prepared data and can be used
//  as an argument to
//  <link linkend="MCalculateNorm">MCalculateNorm()</link>.
//
//  Options must be a structure with the following fields:
//
//  ▶ translation — if translation is not "no", a sliding window algorithm
//  will be applied and image norm will be calculated for all positions
//  of that window inside an image. In such a case a sliding window size
//  must be specified using window_size field of options.
//
//  The possible values for translation are:
//  "no" — no sliding window applied,
//  "brute-force" — brute-force implementation of a sliding window (very slow,
//  implemented only for reference),
//  "fft" — a sliding window implementation via fast Fourier transform.
//  If translation is set to "fft", options must contain the field data_size.
//
//  ▶ window_size — size of a sliding window. The field window_size is
//  mandatory if translation is not "no".
//  
//  ▶ data_size — size of an image which norm has to be calculated, must
//  be not less than a sliding window size. The field data_size is mandatory
//  only if translation is "fft".
//
// Examples
//  options = struct();
//  options.translation = "fft"; // may be "no", "brute-force", or "fft"
//  options.window_size = [100, 100];
//  options.data_size = [1080, 1920];
//  norm_calc = MPrepareNorm(options, "grayscale");
//  
// See also
//  MCalculateNorm
//  MPrepareProjectionNorm
//  fft
//
// Authors
//  Andrey Zubyuk

    // Validate the arguments
    if argn(2) < 1 then
        _MError(2, 1);
    end
    if argn(2) >= 2 then
        if data_type == "gray" then
            data_type = "grayscale";
        end
        if ~isequal(data_type, "grayscale") then
            _MError(1);
        end
    end

    // Dispatch
    select options.translation
//////////////////////////////////////////////////
    case "no" then
        norm_calc = struct();
        norm_calc.obj_name = "norm calculator";
        norm_calc.norm_type = ["grayscale", "no"];
//////////////////////////////////////////////////
    case "brute-force" then
        norm_calc = struct();
        norm_calc.obj_name = "norm calculator";
        norm_calc.norm_type = ["grayscale", "brute-force"];
        norm_calc.window_size = options.window_size;
//////////////////////////////////////////////////
    case "fft" then
        sz = list();
        for i = 1 : length(options.window_size)
            sz(i) = options.window_size(i);
        end
        img = zeros(sz(:));
        shape = MCreateMosaicShape(img, "grayscale");
        projection = MCreateProjection(shape);
        norm_calc = MPrepareProjectionNorm(projection, options);
        norm_calc.obj_name = "norm calculator";
        norm_calc.norm_type = ["grayscale", "fft"];
//////////////////////////////////////////////////
    else
        error("Incorrect translation.");
    end
endfunction

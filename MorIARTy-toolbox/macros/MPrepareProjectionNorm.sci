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

function proj_norm_calc = MPrepareProjectionNorm(projection, options)
// Prepare to calculate norm of an image projection.
//
// Calling Sequence
//  proj_norm_calc = MPrepareProjectionNorm(projection, options)
//
// Parameters
//  projection: Projection.
//  options: Required parameters of a calculation process.
//  proj_norm_calc: A structure containing the prepared data.
//
// Description
//  <link linkend="MPrepareProjectionNorm">MPrepareProjectionNorm()</link>
//  prepares all auxiliary data necessary to calculate norm of an image projection.
//  The argument projection is a structure typically created using
//  <link linkend="MCreateProjection">MCreateProjection()</link>.
//  The returned structure proj_norm_calc contains the prepared data and can be used
//  as an argument to
//  <link linkend="MCalculateProjectionNorm">MCalculateProjectionNorm()</link>.
//
//  Options must be a structure with the following fields:
//
//  ▶ translation — if translation is not "no", a sliding window algorithm
//  will be applied and projection norm will be calculated for all positions
//  of that window inside an image. The size of a sliding window will be the
//  same as the size of the image shape associated with projection.
//  
//  The possible values for translation are:
//  "no" — no sliding window applied,
//  "brute-force" — brute-force implementation of a sliding window (very slow,
//  implemented only for reference),
//  "fft" — a sliding window implementation via fast Fourier transform.
//  If translation is set to "fft", options must contain the field data_size.
//
//  ▶ data_size — size of an image which projection norm has to be
//  calculated, must be not less than the size of the image shape. The field
//  data_size is mandatory only if translation is "fft".
//
// Examples
//  // Create a shape and a projection onto it
//  img = imread(fullpath(MorIARTyPath() + "/images/cube/cube-1.png"));
//  img = im2double(img(:, :, 1));
//  shape = MCreateMosaicShape(img, "grayscale");
//  projection = MCreateProjection(shape);
//
//  // Prepare to calculate a projection norm
//  options = struct();
//  options.translation = "fft"; // may be "no", "brute-force", or "fft"
//  options.data_size = [1080, 1920];
//  proj_norm_calc = MPrepareProjectionNorm(projection, options);
//  
// See also
//  MCreateProjection
//  MCalculateProjectionNorm
//  MPrepareNorm
//  fft
//
// Authors
//  Andrey Zubyuk

    if argn(2) < 2 then
        _MError(2, 2);
    end
    select projection.projection_type
    case ["grayscale", "mosaic", "orthogonal"] then
        proj_norm_calc = _MGrMosPrepProjNorm(projection, options);
    else
        error("Unsupported projection type.");
    end
endfunction

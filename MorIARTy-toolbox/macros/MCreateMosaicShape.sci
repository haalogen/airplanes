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

function shape = MCreateMosaicShape(data, data_type, method, options)
// Create a mosaic image shape.
//
// Calling Sequence
//  shape = MCreateMosaicShape(data, data_type)
//  shape = MCreateMosaicShape(data, data_type, method, options)
//
// Parameters
//  data: Input image which shape needs to be created.
//  data_type: Input image type: "grayscale" (or simply "gray") or "color" (only "grayscale" is now implemented).
//  method: Name of the method that shall be used to create the input image shape.
//  options: Parameters of the specified method.
//  shape: Structure representing the input image shape.
//
// Description
//  <link linkend="MCreateMosaicShape">MCreateMosaicShape()</link> returns a structure
//  representing the shape of the given image.
//
//  If data_type is "grayscale" (or simply "gray"), the shape is a subspace of piecewise
//  constant images that regions of constant brightness are defined based on the input one.
//  In this case the possible values for method are: "exact" (default value), "quantize", "k-means".
//
//  ▶ "exact" means that the regions of constant brightness are exactly the same
//  as those of the input image.
//
//  ▶ "quantize" means that the regions of constant brightness
//  are found using simple quantization performed with <link linkend="MQuantize">MQuantize()</link>.
//  In this case options must be a structure with the field "levels" — a vector
//  of quantization levels.
//
//  ▶ "k-means" means that the regions of constant brightness
//  are found using k-means clustering algorithm. In this case quantization levels are
//  calculated using heuristics implemented in <link linkend="nan_kmeans">nan_kmeans()</link>,
//  and options must be a structure with the field "number_of_regions" — required number of regions.
//
// Examples
//  // Exact
//  imgfile = fullpath(MorIARTyPath() + "/images/cube/cube-1.png");
//  cube = im2double(imread(imgfile));
//  cube = cube(:, :, 1);
//  shape1 = MCreateMosaicShape(cube, "grayscale");
//  
//  // Quantize
//  imgfile = fullpath(MorIARTyPath() + "/images/camera/petrozavodsk-marx_avenue-1.png");
//  img = im2double(imread(imgfile));
//  img = img(:, :, 1);
//  levels = linspace(min(img), max(img), 11);
//  levels = levels(2 : $ - 1);
//  shape2 = MCreateMosaicShape(img, "grayscale", "quantize", struct("levels", levels));
//  
//  // K-means
//  shape3 = MCreateMosaicShape(img, "grayscale", "k-means", struct("number_of_regions", 10));
//
// See also
//  MCreateProjection
//  MQuantize
//  nan_kmeans
//
// Authors
//  Andrey Zubyuk

    if data_type == "gray" then
        data_type = "grayscale";
    end

    select data_type
    case "grayscale" then
        select argn(2)
        case 2 then
            shape = _MGrMosCreateShape(data);
        case 3 then
            shape = _MGrMosCreateShape(data, method);
        case 4 then
            shape = _MGrMosCreateShape(data, method, options);
        else
            error("At least 2 arguments expected.");
        end
    else
        _MError(1);
    end
endfunction

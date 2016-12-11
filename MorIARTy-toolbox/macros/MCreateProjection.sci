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

function projection = MCreateProjection(shape)
// Create the projection onto the given image shape.
//
// Calling Sequence
//  projection = MCreateProjection(shape)
//
// Parameters
//  shape: Structure representing the image shape.
//  projection: Structure representing the created projection.
//
// Description
//  <link linkend="MCreateProjection">MCreateProjection()</link> returns a structure
//  representing the projection onto the given image shape. The argument shape must be a structure
//  representing the image shape. Such a stucture is typically created using one of the MorIARTy
//  shape creation functions like <link linkend="MCreateMosaicShape">MCreateMosaicShape()</link>.
//
// Examples
//  // Read an image
//  imgfile = fullpath(MorIARTyPath() + "/images/cube/cube-1.png");
//  cube = im2double(imread(imgfile));
//  cube = cube(:, :, 1);
//
//  // Create the image shape
//  shape = MCreateMosaicShape(cube, "grayscale");
//
//  // Create the projection onto the shape
//  projection = MCreateProjection(shape);
//
// See also
//  MCreateMosaicShape
//  MProject
//  MCreateProjectionNorm
//
// Authors
//  Andrey Zubyuk

    // Validate the arguments
    if argn(2) < 1 then
        _MError(2, 1);
    end

    // Dispatch
    select shape.shape_type
    case ["grayscale", "mosaic"] then
        projection = struct();
        projection.obj_name = "projection";
        projection.projection_type = ["grayscale", "mosaic", "orthogonal"];
        projection.shape = shape;
    else
        error("Unsupported shape type.");
    end
endfunction

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

function result = MProject(projection, data)
// Project an image onto the image shape using the specified projection.
//
// Calling Sequence
//  result = MProject(projection, data)
//
// Parameters
//  projection: Projection.
//  data: An image which needs to be projected.
//  result: Projection of the given image.
//
// Description
//  <link linkend="MProject">MProject()</link> projects
//  the given image onto the image shape being the range of the specified projection.
//  The argument projection must be a structure representing a projection. Such a
//  structure is typically created using <link linkend="MCreateProjection">MCreateProjection()</link>.
//
// Examples
//  // Read two images of a cube and an image of a circle
//  imgfile = fullpath(MorIARTyPath() + "/images/cube/cube-1.png");
//  cube1 = im2double(imread(imgfile));
//  cube1 = cube1(:, :, 1);
//  imgfile = fullpath(MorIARTyPath() + "/images/cube/cube-2.png");
//  cube2 = im2double(imread(imgfile));
//  cube2 = cube2(:, :, 1);
//  imgfile = fullpath(MorIARTyPath() + "/images/cube/circle.png");
//  circle = im2double(imread(imgfile));
//  circle = circle(:, :, 1);
//
//  // Create the shape of the 1-st cube image and projection onto it
//  shape_cube = MCreateMosaicShape(cube1, "grayscale");
//  projection_cube = MCreateProjection(shape_cube);
//
//  // Calculate projection of the 2-nd cube image
//  p_cube2 = MProject(projection_cube, cube2);
//  norm(cube2(:) - p_cube2(:)) // 0 expected
//
//  // Calculate projection of the circle image
//  p_circle = MProject(projection_cube, circle);
//  norm(circle(:) - p_circle(:)) // non-zero value expected
//
// See also
//  MCreateProjection
//
// Authors
//  Andrey Zubyuk

    // Validate the arguments
    if argn(2) < 2 then
        _MError(2, 2);
    end

    // Dispatch
    select projection.projection_type
    case ["grayscale", "mosaic", "orthogonal"] then
        result = _MGrMosProject(projection, data);
    else
        error("Unsupported projection type.");
    end
endfunction

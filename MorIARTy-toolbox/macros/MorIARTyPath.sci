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

function root_path = MorIARTyPath()
// Return a full path to the MorIARTy root directory.
//
// Calling Sequence
//  root_path = MorIARTyPath()
//
// Parameters
//  root_path: A full path to the MorIARTy root directory.
//
// Description
//  <link linkend="MorIARTyPath">MorIARTyPath()</link>
//  returns a full path to the MorIARTy root directory.
//
// Examples
//  // Read an image from MorIARTy images subdirectory
//  imgfile = fullpath(MorIARTyPath() + "/images/cube/cube-1.png");
//  cube = im2double(imread(imgfile));
//  cube = cube(:, :, 1);
//
// Authors
//  Andrey Zubyuk

    global MorIARTy_root_path
    root_path = MorIARTy_root_path;
endfunction

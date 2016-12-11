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

function result = _MGrMosProject(projection, data)
// Helper function for MProject().
//
// Parameters
//  projection: Projection.
//  data: An image which needs to be projected.
//  result: Projection of the given image.
//
// Description
//  _MGrMosProject() calculates projection of the given grayscale image
//  (or monochannel signal of another type) onto the mosaic shape.

    if projection.shape.number_of_regions == 0 then
        result = data;
    else
        v = _MGrMosSumOverRegions(data, ...
            projection.shape.regions, projection.shape.number_of_regions);
        v = v ./ projection.shape.region_areas;
        result = _MGrMosSetRegionValues(projection.shape.regions, v);
    end
endfunction

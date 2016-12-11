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

function shape = _MGrMosCreateShape(data, method, options)
// Helper function for MCreateMosaicShape().
//
// Parameters
//  data: Image (or signal of another type) which shape needs to be created.
//  method: Method to be used to perform segmentation: "exact", "quantize", "k-means".
//  options: Structure containing the parameters of the specified method.
//  shape: Structure representing the created shape.
//
// Description
//  _MGrMosCreateShape() creates the mosaic shape of the given grayscale image
//  (or monochannel signal of another type).

    // Default value for method
    if argn(2) == 1 then
        method = "exact";
    end
   
    // Dispatch
    select method
    case "exact" then
        shape = struct();
        shape.obj_name = "shape";
        shape.shape_type = ["grayscale", "mosaic"];
        shape.data_size = size(data);
        v = unique(data);
        shape.number_of_regions = length(v);
        shape.regions = zeros(data);
        shape.region_areas = zeros(1, shape.number_of_regions);
        shape.regions = MQuantize(data, v);
        shape.region_areas = _MGrMosMeasureRgnAreas(shape.regions, shape.number_of_regions);
    case "quantize" then
        qdata = MQuantize(data, options.levels);
        shape = _MGrMosCreateShape(qdata, "exact");
    case "k-means" then
        // Initial levels and centers
        numel = prod(size(data));
        dn = numel / options.number_of_regions;
        if dn < 1 then
            shape = _MGrMosCreateShape(data, "exact");
        end
        init_levels = linspace(min(data), max(data), options.number_of_regions + 1);
        init_centers = (init_levels(1 : $ - 1) + init_levels(2 : $)) / 2;
        
        // Call k-means heuristics
        model = nan_kmeans(data(:), options.number_of_regions, init_centers);
        centers = unique(model.X);
        levels = (centers(1 : $ - 1) + centers(2 : $)) / 2;
        
        // Quantize using the calculated levels
        shape = _MGrMosCreateShape(data, "quantize", struct("levels", levels));
    case "otsu" then
        error("Multilevel Otsu is not implemented.");
    else
        error("Unknown method.");
    end
endfunction

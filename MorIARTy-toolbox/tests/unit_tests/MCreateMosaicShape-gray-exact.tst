// Create a mosaic 2D data
data = zeros(10, 5);
brightness = [0 0.5 1 0.75 0.25];
for i = 1 : 5
    data((i-1) * 2 + 1 : i * 2, :) = brightness(i);
end

// Create a shape
shape = MCreateMosaicShape(data, "gray");
data
shape
shape.regions

// Create a mosaic 3D data
data = zeros(5, 5, 2);
brightness = [0 0.5 1 0.75 0.25];
for i = 1 : 5
    data((i-1) * 1 + 1 : i * 1, :, :) = brightness(i);
end

// Create a shape
shape = MCreateMosaicShape(data, "grayscale");
data
shape
shape.regions

imgfile = fullpath(MorIARTyPath() + "/images/camera/petrozavodsk-marx_avenue-1.png");
img = im2double(imread(imgfile));
img = img(:, :, 1);
levels = linspace(min(img), max(img), 11);
levels = levels(2 : $ - 1);
shape = MCreateMosaicShape(img, "grayscale", "quantize", struct("levels", levels))
P = MCreateProjection(shape);
pimg = MProject(P, img);
dev = img - pimg;
norm(dev(:))

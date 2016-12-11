imgfile = fullpath(MorIARTyPath() + "/images/camera/petrozavodsk-marx_avenue-1.png");
img = im2double(imread(imgfile));
img = img(:, :, 1);
levels = linspace(min(img), max(img), 11);
levels = levels(2 : $ - 1);
shape1 = MCreateMosaicShape(img, "grayscale", "quantize", struct("levels", levels))
shape2 = MCreateMosaicShape(img, "grayscale", "k-means", struct("number_of_regions", 10));
P1 = MCreateProjection(shape1);
P2 = MCreateProjection(shape2);
p1img = MProject(P1, img);
p2img = MProject(P2, img);
dev1 = img - p1img;
dev2 = img - p2img;
norm(dev1(:))
norm(dev2(:)) < norm(dev1(:))

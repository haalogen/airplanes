// Create a shape and a projection onto it
img1 = imread(fullpath(MorIARTyPath() + "/images/svo/airplane.png"));
img1 = im2double(img1(:, :, 1));
shape = MCreateMosaicShape(img1, "grayscale");
projection = MCreateProjection(shape);

// Read another image
img2 = imread(fullpath(MorIARTyPath() + "/images/svo/svo.png"));
img2 = im2double(img2(:, :, 1));

// Prepare to calculate a projection norm - brute-force
options = struct();
options.translation = "brute-force";
proj_norm_calc_bf = MPrepareProjectionNorm(projection, options);

// Prepare to calculate a projection norm - fft
options.translation = "fft";
options.data_size = size(img2);
proj_norm_calc_fft = MPrepareProjectionNorm(projection, options);

// Calculate the norm of the projection
tic();
proj_norm_bf = MCalculateProjectionNorm(proj_norm_calc_bf, img2);
t_bf = toc();
tic();
proj_norm_fft = MCalculateProjectionNorm(proj_norm_calc_fft, img2);
t_fft = toc();

// Difference
[ ...
    round(norm(proj_norm_bf(:))), ...
    round(norm(proj_norm_fft(:))), ...
    1e-9 * round(1e9 * norm(proj_norm_bf(:) - proj_norm_fft(:))) ...
]

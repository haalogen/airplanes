// Read an image
img = imread(fullpath(MorIARTyPath() + "/images/svo/svo.png"));
img = im2double(img(:, :, 1));

// Prepare to calculate a norm - brute-force
options = struct();
options.translation = "brute-force";
options.window_size = [30 30];
norm_calc_bf = MPrepareNorm(options, "gray");

// Prepare to calculate a norm - fft
options = struct();
options.translation = "fft";
options.window_size = [30 30];
options.data_size = size(img);
norm_calc_fft = MPrepareNorm(options, "grayscale");

// Calculate the norm
tic();
norm_bf = MCalculateNorm(norm_calc_bf, img);
t_bf = toc();
tic();
norm_fft = MCalculateNorm(norm_calc_fft, img);
t_fft = toc();

// Difference
[ ...
    round(norm(norm_bf(:))), ...
    round(norm(norm_fft(:))), ...
    1e-9 * round(1e9 * norm(norm_bf(:) - norm_fft(:))) ...
]

// Calculate norm - simple
options = struct();
options.translation = "no";
norm_calc = MPrepareNorm(options, "grayscale");
img_norm = MCalculateNorm(norm_calc, img);
[ ...
    round(img_norm), ...
    round(norm(img(:))), ...
    1e-9 * round(1e9 * abs(img_norm - norm(img(:)))) ...
]

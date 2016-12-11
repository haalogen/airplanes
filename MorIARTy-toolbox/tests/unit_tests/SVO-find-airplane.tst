f = imread(fullpath(MorIARTyPath() + "/images/svo/airplane.png"));
f = im2double(f(:, :, 1));
V = MCreateMosaicShape(f, "grayscale");
P = MCreateProjection(V);

V0 = MCreateMosaicShape(zeros(f), "grayscale");
E = MCreateProjection(V0);

g = imread(fullpath(MorIARTyPath() + "/images/svo/svo.png"));
g = im2double(g(:, :, 1));

options = struct();
options.translation = "fft";
options.window_size = size(f);
options.data_size = size(g);
PN = MPrepareProjectionNorm(P, options);
EN = MPrepareProjectionNorm(E, options);
N = MPrepareNorm(options, "grayscale");

PNg = MCalculateProjectionNorm(PN, g);
ENg = MCalculateProjectionNorm(EN, g);
Ng = MCalculateNorm(N, g);

func = (Ng.^2 - PNg.^2) ./ (PNg.^2 - ENg.^2);

//// Original image
//figure("background", -2, "color_map", graycolormap(32));
//subplot(1, 2, 1);
//Matplot(g * 32);
//set(gca(), "isoview", "on", "tight_limits", "on");
//
//// Pattern
//subplot(1, 2, 2);
//pattern = 0.5 * ones(g);
//corner = round((size(g) - size(f)) / 2);
//pattern( ...
//    corner(1) : corner(1) + size(f, 1) - 1, ...
//    corner(2) : corner(2) + size(f, 2) - 1 ...
//) = f;
//Matplot(pattern * 32);
//set(gca(), "isoview", "on", "tight_limits", "on");
//
//// Result
//subplot(1, 2, 1);
//// Matplot(g * 32);
//set(gca(), "isoview", "on", "tight_limits", "on");
mask = func < 4 * min(func);
blobs = SearchBlobs(mask);
[x, y] = meshgrid(1 : size(mask, 2), 1 : size(mask, 1));
y = y($ : -1 : 1, :);
pos = zeros(2, max(blobs));
for i = 1 : max(blobs)
    blob = blobs == i;
    pos(1, i) = mean(x(blob));
    pos(2, i) = mean(y(blob));
//    x0 = pos(1, i);
//    y0 = pos(2, i);
//    plot( ...
//        [x0 x0+size(f,1) x0+size(f,1) x0 x0], ...
//        [y0 y0 y0+size(f,2) y0+size(f,2) y0], ...
//        "r", "linewidth", 2 ...
//    );
end

// Print the positions
round(pos / 5) * 5

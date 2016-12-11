clear all;
//0. Load MorIARTy-toolbox
exec("MorIARTy-toolbox/loader.sce");

TIMES = 3;
av = 0;
MAX_STD = 1;
STD_LEN = 20;
stds = linspace(0.05, MAX_STD, STD_LEN);
  
for s = 1 : length(stds)
  for t = 1 : TIMES
    std = stds(s)

    //1. Load image of airport and image of plane 
    f = imread(fullpath(MorIARTyPath() + "/images/svo/airplane.png"));
    f = im2double(rgb2gray(f));

    // Add noise to f
    f = imnoise(f, "salt & pepper", std);

    V = MCreateMosaicShape(f, "grayscale");
    V
    P = MCreateProjection(V);
    V0 = MCreateMosaicShape(zeros(f), "grayscale");
    E = MCreateProjection(V0);


    g = imread(fullpath(MorIARTyPath() + "/images/svo/svo.png"));
    g = im2double(g);

    // Add noise to g
    g = imnoise(g, "gaussian", av, std.^2);

    options = struct();
    options.translation = "fft";
    options.window_size = size(f);
    options.data_size = size(g);
    options
    PN = MPrepareProjectionNorm(P, options);
    EN = MPrepareProjectionNorm(E, options);
    N = MPrepareNorm(options, "grayscale");


    PNg = MCalculateProjectionNorm(PN, g);
    ENg = MCalculateProjectionNorm(EN, g);
    Ng = MCalculateNorm(N, g);

    func = ones(Ng) * 2.^100;

    if (PNg.^2 - ENg.^2) ~= 0 then
      func = (Ng.^2 - PNg.^2) ./ (PNg.^2 - ENg.^2);
    else
      
    end
    


    // imshow(f);
    // tmp = input("Enter smth");
    // imshow(g);
    // tmp = input("Enter smth");
    // imshow(func < 4 * min(func));
    // tmp = input("Enter smth");

    imwrite(func < 4 * min(func), "results/air_denstd" + string(std) + ..
            "_time" + string(t) + ".jpg");
  end
end
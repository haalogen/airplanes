//0. Load MorIARTy-toolbox
exec("MorIARTy-toolbox/loader.sce");

BIG_VAL = 2 ^ 100;
TIMES = 30;
av = 0;
MIN_STD = 0.05;
MAX_STD = 0.5;
STD_LEN = 10;
stds = linspace(MIN_STD, MAX_STD, STD_LEN);

// x, y coordinates
plane_coords = [ ..
  144, 446; ..
  197, 430; ..
  365, 398; ..
  486, 366];


radius = 5; // radius 3px
file_num_err = mopen("num_errors.txt", "w");


for s = 1 : length(stds)
  num_errors = 0;
  bad_times = 0;
  for t = 1 : TIMES
    std = stds(s);
    if t == 1
      std
    end
    t

    //1. Load image of airport and image of plane 
    f = imread(fullpath(MorIARTyPath() + "/images/svo/airplane.png"));
    f = im2double(rgb2gray(f));

    // Add noise to f
    f = imnoise(f, "salt & pepper", std);

    V = MCreateMosaicShape(f, "grayscale");
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
    options;
    PN = MPrepareProjectionNorm(P, options);
    EN = MPrepareProjectionNorm(E, options);
    N = MPrepareNorm(options, "grayscale");


    PNg = MCalculateProjectionNorm(PN, g);
    ENg = MCalculateProjectionNorm(EN, g);
    Ng = MCalculateNorm(N, g);

    func = ones(Ng) * BIG_VAL;

    if (PNg.^2 - ENg.^2) ~= 0 then
      func = (Ng.^2 - PNg.^2) ./ (PNg.^2 - ENg.^2);
    else
      
    end
    
    if t == 1 then
      imwrite(func < 4 * min(func), "results/air_denstd" + string(std) + ..
              "_time" + string(t) + ".jpg");
    end

    plane_val = max( ..
      min(func(plane_coords(1, 2) - radius : plane_coords(1, 2) + radius, ..
               plane_coords(1, 1) - radius : plane_coords(1, 1) + radius)), ..
      min(func(plane_coords(2, 2) - radius : plane_coords(2, 2) + radius, ..
               plane_coords(2, 1) - radius : plane_coords(2, 1) + radius)), ..
      min(func(plane_coords(3, 2) - radius : plane_coords(3, 2) + radius, ..
               plane_coords(3, 1) - radius : plane_coords(3, 1) + radius)), ..
      min(func(plane_coords(4, 2) - radius : plane_coords(4, 2) + radius, ..
               plane_coords(4, 1) - radius : plane_coords(4, 1) + radius)) ..
      );

    if t == 1 then
      imwrite(func <= plane_val, "results/air_denstd" + string(std) + ..
              "_time" + string(t) + ".jpg");
    end

    func(plane_coords(1, 2) - radius : plane_coords(1, 2) + radius, ..
         plane_coords(1, 1) - radius : plane_coords(1, 1) + radius) = ..
    ones(2 * radius + 1, 2 * radius + 1) * BIG_VAL;

    func(plane_coords(2, 2) - radius : plane_coords(2, 2) + radius, ..
         plane_coords(2, 1) - radius : plane_coords(2, 1) + radius) = ..
    ones(2 * radius + 1, 2 * radius + 1) * BIG_VAL;

    func(plane_coords(3, 2) - radius : plane_coords(3, 2) + radius, ..
         plane_coords(3, 1) - radius : plane_coords(3, 1) + radius) = ..
    ones(2 * radius + 1, 2 * radius + 1) * BIG_VAL;

    func(plane_coords(4, 2) - radius : plane_coords(4, 2) + radius, ..
         plane_coords(4, 1) - radius : plane_coords(4, 1) + radius) = ..
    ones(2 * radius + 1, 2 * radius + 1) * BIG_VAL;





    failure_mask = func();
    failure_mask = failure_mask(func <= plane_val);
    if length(failure_mask) == length(func) then
      disp("length(failure_mask) == length(func)");
      bad_times = bad_times + 1;
    else
      num_errors = num_errors + length(failure_mask);
    end

    // imshow(f);
    // tmp = input("Enter smth");
    // imshow(g);
    // tmp = input("Enter smth");
    // imshow(func < 4 * min(func));
    // tmp = input("Enter smth");

    
  end // for t 
  num_errors = num_errors / (TIMES - bad_times)
  mputl(string(num_errors), file_num_err);

end // for s
mclose(file_num_err);
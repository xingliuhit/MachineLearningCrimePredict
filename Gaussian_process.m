function Gaussian_process()

[train_datas, test_datas] = split_datas('STREET CRIMES');
[mean_train, std_train] = cal_grid_mean_std(train_datas);

%%%%%%%%%%%%% used for debug, in order to save time
%train_datas = train_datas(1:40000, :);
%test_datas = test_datas(1:10000, :);
%%%%%%%%%%%%%

% train data
x_train = train_datas(:, 1:4);
crime_number_train = train_datas(:, 5);
% get y_train
y_train = get_y_train(x_train, crime_number_train, mean_train, std_train); 

% test data
x_test = test_datas(:, 1:4);
crime_number_test = test_datas(:, 5);

%%%%%%%%%%%%%%%%%% get gprMdl
%gprMdl = fitrgp(x_train, y_train, 'KernelFunction','squaredexponential');
%save gprMdl_GP_Anscombe_transform.mat gprMdl
%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% load gprMdl
load('gprMdl_GP_Anscombe_transform.mat');
%%%%%%%%%%%%%%%%%%

y_predict = predict(gprMdl, x_test);

%>>>>>>> master
crime_number_predict = get_crime_number_predict(x_test, y_predict, mean_train, std_train);
for i = 1:size(y_predict, 1) 
    fprintf('real = %f, predict = %f\n',crime_number_test(i), crime_number_predict(i));
end

% print judege criteria
[result_PAI, result_PEI] = judge_criteria(x_test, crime_number_test, y_predict)
end

function y_train = get_y_train(x_train, crime_number_train, mean_train, std_train)
    %%%%%%
    %y_train = zeros(size(crime_number_train, 1), 1);
    %for i = 1:size(x_train, 1)
    %    x = x_train(i, 3);
    %    y = x_train(i, 4);
    %    y_train(i) = log(crime_number_train(i) / (mean_train(x, y)));
    %end
    %%%%%%
    
    %%%%%%%%%%
    %%%%%%%%%% it is ok
%     y_train = zeros(size(crime_number_train, 1), 1);
%     for i = 1:size(x_train, 1)
%         x = x_train(i, 3);
%         y = x_train(i, 4);
%         y_train(i) = (crime_number_train(i) - mean_train(x, y))/std_train(x, y);
%     end
    %%%%%%%%%%
    %%%%%%%%%%
    
    %%%%%%%%%% Anscombe transform x -> 2sqrt(x), ok but not that good
%     y_train = zeros(size(crime_number_train, 1), 1);
%     for i = 1:size(x_train, 1)
%         y_train(i) = 2*sqrt(crime_number_train(i));
%     end
    %%%%%%%%%%
    
    %%%%%%%%%% Anscombe transform x -> sqrt(x) + sqrt(x+1), works ok
     y_train = zeros(size(crime_number_train, 1), 1);
     for i = 1:size(x_train, 1)
         y_train(i) = sqrt(crime_number_train(i)) + sqrt(crime_number_train(i)+1);
     end
    %%%%%%%%%%
    
end

function crime_number_predict = get_crime_number_predict(x_test, y_predict, mean_train, std_train)
    %%%%%%
    %crime_number_predict = zeros(size(y_predict, 1), 1);
    %for i = 1:size(y_predict, 1)
    %    x = x_test(i, 3);
    %    y = x_test(i, 4);
    %    crime_number_predict(i) = mean(x, y)*(exp(y_predict(i)));
    %end
    %%%%%%
    
    %%%%%%%%%%
    %%%%%%%%%% it is ok
%     crime_number_predict = zeros(size(y_predict, 1), 1);
%     for i = 1:size(y_predict, 1)
%         x = x_test(i, 3);
%         y = x_test(i, 4);
%         crime_number_predict(i) = y_predict(i)*std_train(x, y) + mean_train(x, y);
%     end
    %%%%%%%%%%
    %%%%%%%%%%
    
    %%%%%%%%%% Anscombe transform, ok but not that good
%     crime_number_predict = zeros(size(y_predict, 1), 1);
%     for i = 1:size(y_predict, 1)
%         crime_number_predict(i) = (y_predict(i)/2)^2;
%     end
    %%%%%%%%%%
    
    %%%%%%%%%% Anscombe transform, x -> sqrt(x) + sqrt(x+1), work sok
     crime_number_predict = zeros(size(y_predict, 1), 1);
     for i = 1:size(y_predict, 1)
         crime_number_predict(i) = get_Anscombe_transform_x(y_predict(i));
     end
    %%%%%%%%%%
end
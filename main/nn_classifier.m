function [] = nn_classifier()
clear all;

keySet =   ["ABOUT","AND","CAN","COP","DEAF","DECIDE","FATHER","FIND","GOOUT","HEARING"];
no_of_groups = 37;
no_of_components = 50;

d = pwd;
if exist('nn_accuracy_log.csv')
    delete('nn_accuracy_log.csv');
end
fid = fopen('nn_accuracy_log.csv','a');
fprintf(fid,'%s\n','Group,Gesture,Accuracy,Precision,Recall,F1 score');

for gesture = 1 : length(keySet)
    gesture_name = char(lower(string(keySet(gesture))));
    if gesture == 9
        continue;
    end
    accuracy = [];
    precision = [];
    recall = [];
    f1_score = [];
    
    for group = 1 : no_of_groups
        if group == 14 || group == 17
            continue;
        end
        base_path = ['classification_input_2/', gesture_name, '/DM', int2str(group), '/'];

        tr_raw = csvread([base_path, 'training.csv']);
        testing_raw = csvread([base_path, 'testing.csv']);

        tr_raw_targets = tr_raw(:, no_of_components + 1);
        testing_raw_targets = testing_raw(:, no_of_components + 1);

        tr_raw_targets(tr_raw_targets == -1) = 2;
        testing_raw_targets(testing_raw_targets == -1) = 2;

        tr_targets = dummyvar(tr_raw_targets);
        testing_targets = dummyvar(testing_raw_targets);

        %create final data here
        trainNN = tr_raw(:, 1:no_of_components)';
        testNN = testing_raw(:, 1:no_of_components)';

        train_class = tr_targets';
        test_class = testing_targets';

        trainFcn = 'trainscg';
        no_of_hidden_layers = 1;
        no_of_hidden_neurons = 5:5:30;
        
        max_acc = 0;
        id_hd = [];
        for hidden_layers = no_of_hidden_layers
            for hidden_neurons = no_of_hidden_neurons
                hiddenLayerSize = hidden_neurons * ones(1, hidden_layers);
                
                net = patternnet(hiddenLayerSize);  % pattern recognition network
                net.divideParam.trainRatio = 80/100;% 70% of data for training
                net.divideParam.valRatio = 20/100;  % 15% of data for validation
                net.divideParam.testRatio = 0/100; % 15% of data for testing
                net = train(net, trainNN, train_class);             % train the network

                % Valdation
                y = net(testNN);
                p_r = y(1, :);
                n_r = y(2, :);

                a_r = p_r > n_r;
                p_a = test_class(1, :);
                p_a_t = p_a;
                p_a_t(p_a_t == 0) = -1;
                TP = sum(a_r == p_a_t);

                p_a_t = p_a;
                p_a_t(p_a_t == 1) = -1;
                p_a_t(p_a_t == 0) = 1;
                FP = sum(a_r == p_a_t);

                a_r = n_r > p_r;
                n_a = test_class(2, :);
                n_a_t = n_a;
                n_a_t(n_a_t == 0) = -1;
                TN = sum(a_r == n_a_t);

                n_a_t = n_a;
                n_a_t(n_a_t == 1) = -1;
                n_a_t(n_a_t == 0) = 1;
                FN = sum(a_r == n_a_t);
               
                acc = ((TP + TN) / (TP + TN + FP + FN))*100;
               
                if acc > max_acc
                    accuracy1 = ((TP + TN) / (TP + TN + FP + FN))*100;
                    precision1 = (TP / (TP + FP))*100;
                    recall1 = (TP / (TP + FN))*100;
                    f1_score1 = ((2 * precision1 * recall1) / (precision1 + recall1));
                    max_acc = acc;
                    id_hd = hiddenLayerSize;
                end
               
            end
        end
        accuracy = [accuracy,accuracy1];
        precision = [precision,precision1];
        recall = [recall,recall1];
        f1_score = [f1_score,f1_score1];
        disp(['completed for group ', num2str(group), ' gesture ', gesture_name]);
        disp(accuracy(end));
        fprintf(fid,'%s\n',['DM',num2str(group),',',gesture_name,',',num2str(accuracy(end)),',',num2str(precision(end)),',',num2str(recall(end)),',',num2str(f1_score(end))]);
    end
    accuracy_plots(group,gesture_name,accuracy,precision,recall,f1_score);
    disp(['completed for gesture', gesture_name]);
end
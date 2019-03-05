function [] = neural_network_classifier()
    clear all;

    keyset = ["about","and","can","cop","deaf","decide","father","find","hearing"];

    test_groups = [11:13,15,16,18:37];
    no_of_components = 50;

    d = pwd;
    base_path = [d, '\ass4_input\'];

    if exist('nn_accuracy_log.csv')
        delete('nn_accuracy_log.csv');
    end

    fid = fopen([d, 'nn_ass4_log.csv'],'a');
    fprintf(fid,'%s\n','Group,Gesture,Accuracy,Precision,Recall,F1 score');



    for gesture = 1 : length(keyset)
        gesture_name = keyset(gesture);

        %first train an nn
        train_path = [base_path, 'training\', char(gesture_name), '.csv'];
        tr_raw = csvread(train_path);
        tr_raw_targets = tr_raw(:, no_of_components + 1);
        tr_raw_targets(tr_raw_targets == -1) = 2;
        tr_targets = dummyvar(tr_raw_targets);
        trainNN = tr_raw(:, 1:no_of_components)';
        train_class = tr_targets';

        trainFcn = 'trainscg';
        no_of_hidden_layers = 1;
        no_of_hidden_neurons = 5:5:30;

        max_acc = 0;
        final_net = nan;

        for hidden_layers = no_of_hidden_layers
            for hidden_neurons = no_of_hidden_neurons
                hiddenLayerSize = hidden_neurons * ones(1, hidden_layers);
                net = patternnet(hiddenLayerSize);  % pattern recognition network
                net.divideParam.trainRatio = 70/100;% 70% of data for training
                net.divideParam.valRatio = 15/100;  % 15% of data for validation
                net.divideParam.testRatio = 15/100; % 15% of data for testing
                [net, rx] = train(net, trainNN, train_class);             % train the network
                outputs = net(trainNN);
                testTargets = train_class.* rx.testMask{1};
                testPerformance = perform(net,testTargets,outputs);
                if testPerformance > max_acc
                    final_net = net;
                    max_acc = testPerformance;
                end
            end
        end
        

        accuracy = [];
        precision = [];
        recall = [];
        f1_score = [];

        for group = test_groups

            test_path = [base_path, 'testing\DM', int2str(group), '\', char(gesture_name), '.csv'];

            testing_raw = csvread(test_path);

            testing_raw_targets = testing_raw(:, no_of_components + 1);

            testing_raw_targets(testing_raw_targets == -1) = 2;

            testing_targets = dummyvar(testing_raw_targets);

            testNN = testing_raw(:, 1:no_of_components)';

            test_class = testing_targets';


            y = final_net(testNN);
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

            
            accuracy1 = ((TP + TN) / (TP + TN + FP + FN))*100;
            precision1 = (TP / (TP + FP))*100;
            recall1 = (TP / (TP + FN))*100;
            f1_score1 = ((2 * precision1 * recall1) / (precision1 + recall1));
            
            accuracy = [accuracy,accuracy1];
            precision = [precision,precision1];
            recall = [recall,recall1];
            f1_score = [f1_score,f1_score1];
            
            disp(['completed for group ', char(num2str(group)), ' gesture ', char(gesture_name)]);
            fprintf(fid,'%s\n',['DM', char(num2str(group)),',',char(gesture_name),',',char(num2str(accuracy(end))),',',char(num2str(precision(end))),',',char(num2str(recall(end))),',',char(num2str(f1_score(end)))]);   
        end
        accuracy_plots4(gesture_name,accuracy,precision,recall,f1_score);
        disp(['completed for gesture ', char(gesture_name)]);
    end      
end
    
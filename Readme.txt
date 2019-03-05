The main code is present in the folder main
Steps:
1. Create 2 folders in the directory - 'ass2_output', 'ass3_input' and run 'assignment3.m' script to generate csv for each gesture for all the groups as per task1 of assignment 2 and transformed feature matrix for each gesture for all the users as per task2 of assignment 2.
2. Create a folder 'pca_output' in the directory and run 'create_pca_matrix.m' which applies pca to the transformed data in step 1 and put them in 'pca_output' folder.
3. Create a folder 'classification_input' in the directory and run 'create_classification_input' to create the final input feature matrix that has to be fed to the classifier with class imbalance problem.
	OR
   Create a folder 'classification_input_2' in the directory and run 'create_classification_input' to create the final input feature matrix that has to be fed to the classifier without class imbalance problem.
4. Run 'classifiers.m' that runs 3 scrips 'tree_classifier()','svmClassifier()' and 'nn_classifier()'creates and tests all the models (decision tree, support vector machine and neural network) and generated the accuracy plots and log csv files for accuracies for different classifiers different gestures and groups - 'tree_accuracy_log.csv', 'svm_accuracy_log.csv' and 'nn_accuracy_log.csv' respectively.
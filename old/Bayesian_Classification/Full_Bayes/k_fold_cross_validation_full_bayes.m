% Function to use k-fold crossvalidation on the dataset and return the 
% confusion matrix
%
% Input
%   dataset   - The matrix containing vectors of dataset
%   nClasses  - The number of classes in the dataset
%

function cumulativeConfusionMatrix = k_fold_cross_validation_full_bayes (dataset, nClasses, k)
  [nRows nCols] = size(dataset);
  step = floor (nRows / k);
  sets = zeros(step, nCols, k);
  
  % Divide into k parts
  for i = 1 : k    
    sets( : , : , i) = dataset( step * (i - 1) + 1 : step * i, : );
  end

  testSetSize  = step;
  trainSetSize = step * k;
  cumulativeConfusionMatrix = zeros (nClasses, nClasses);
  for i = 1 : k
    testSet  = sets( : , 1 : end - 1, i);
    correctClassification = sets( : , end, i);     
    trainSet = [];
    for j = 1 : k
      if j != i
        trainSet = [trainSet; sets( : , : , j)];      
      end
    end
    [prior meanVectors covarianceMatrix] = learn_full_naive (trainSet, nClasses);
    classified = classify_Full_Bayes(prior, meanVectors, covarianceMatrix, testSet);
    tmpConfusionMatrix = confusion_matrix (classified', correctClassification, nClasses);
    cumulativeConfusionMatrix .+= tmpConfusionMatrix;
  end
end

function [dir, offset] = bestFit (points)
    
    offset = mean(points);                  %Mean-center points                
    adj = points - offset;
    
    [eigs, ~] = eig(adj' * adj);                %Find eigenvectors
    dir = eigs(:, size(eigs, 2))';               %Take the most significant one
        
end
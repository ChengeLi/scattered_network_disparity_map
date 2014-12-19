function [row_disparity, flow] = graph_cut_by_line(matching_err, contrast_left, contrast_right)

% build a graph using two corresponding lines of pixels and find disparity 
% map by using graph cut method.
%     input: 
%             matching_err:  result of comparing two blocks of images by 
%                            scattered networks
%             contrast_left: lookup table of contrast between adjacent
%                            pixels of left image 
%             contrast_right:lookup table of contrast between adjacent
%                            pixels of right image 
%     output:
%             row_disparity: disparity map of one row
%             flow:          maxflow of the generated graph
            
    nPixel = size(matching_err, 1); % nPixel is the width of matching_err matrix
    graph_size = nPixel ^ 2 * 2; % nPixel ^ 2 of u and nPixel ^ 2 of v nodes.
    
%% Edges inside graph
    A = sparse(graph_size, graph_size);
    % Scatter error (little black edges in figure)
    for i = 1 : nPixel
        for j = 1 : nPixel
            idx_u = uv2node('u', i, j, nPixel, nPixel);
            idx_v = uv2node('v', i, j, nPixel, nPixel);
            A(idx_u, idx_v) = matching_err(i, j);
        end
    end
    % Smooth term (little gray edges in figure)
    % mu = 1e-4;
    mu_left = little_gray_left(matching_err, contrast_left);
    mu_right = little_gray_right(matching_err, contrast_right);
    % from Us to Vs
    for i = 1 : nPixel - 1
        for j = 1 : nPixel
            idx_u = uv2node('u', i, j, nPixel, nPixel);
            idx_v = uv2node('v', i + 1, j, nPixel, nPixel);
            A(idx_u, idx_v) = mu_left(i);
            A(idx_v, idx_u) = mu_left(i);
        end
    end
    % from Vs to Us
    for i = 1 : nPixel
        for j = 1 : nPixel - 1
            idx_u = uv2node('u', i, j + 1, nPixel, nPixel);
            idx_v = uv2node('v', i, j, nPixel, nPixel);
            A(idx_u, idx_v) = mu_right(j);
            A(idx_v, idx_u) = mu_right(j);
        end
    end
    % restriction term which forces min-cut on the right directions
    % (dash lines in figure)
    restrict_inf = inf;
    % Horizontal dash lines
    for i = 1 : nPixel - 1
        for j = 2 : nPixel
            idx_u1 = uv2node('u', i, j, nPixel, nPixel);
            idx_u2 = uv2node('u', i + 1, j, nPixel, nPixel);
            A(idx_u1, idx_u2) = restrict_inf;
        end
    end
    for i = 1 : nPixel - 1
        for j = 1 : nPixel - 1
            idx_v1 = uv2node('v', i, j, nPixel, nPixel);
            idx_v2 = uv2node('v', i + 1, j, nPixel, nPixel);
            A(idx_v1, idx_v2) = restrict_inf;
        end
    end
    % Vertical dash lines
    for i = 1 : nPixel - 1
        for j = nPixel : -1 : 2
            idx_u1 = uv2node('u', i, j, nPixel, nPixel);
            idx_u2 = uv2node('u', i, j - 1, nPixel, nPixel);
            A(idx_u1, idx_u2) = restrict_inf;
        end
    end
    for i = 2 : nPixel
        for j = nPixel : -1 : 2
            idx_v1 = uv2node('v', i, j, nPixel, nPixel);
            idx_v2 = uv2node('v', i, j - 1, nPixel, nPixel);
            A(idx_v1, idx_v2) = restrict_inf;
        end
    end
    
%% Edges between graph and Source/Sink
    T = sparse(graph_size, 2);
    % 1st col of T represents Source
    % 2nd col of T represents Sink
    % left most column of V
    for j = 1 : nPixel
        idx_v = uv2node('v', 1, j, nPixel, nPixel);
        T(idx_v, 2) = restrict_inf;
    end
    % upper most row of V
    for i = 1 : nPixel
        idx_v = uv2node('v', i, nPixel, nPixel, nPixel);
        T(idx_v, 2) = restrict_inf;
    end
    % bottom row of U
    for i = 1 : nPixel
        idx_u = uv2node('u', i, 1, nPixel, nPixel);
        T(idx_u, 1) = restrict_inf;
    end
    % right most col of U
    for j = 1 : nPixel
        idx_u = uv2node('u', nPixel, j, nPixel, nPixel);
        T(idx_u, 1) = restrict_inf;
    end

%% Do MaxFlow MinCut Calculation using Boykov's alg

    [flow, labels] = maxflow(A, T);
    row_disparity = path2disparity(labels);
    
end
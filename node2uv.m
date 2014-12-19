function [UorV, x, y] = node2uv(nodeLabel, ncols, nrows)  
% Convert node index to U_label and V_label
%   input: 
%         nodeLabel:  node label in graph
%         ncols:      width of graph
%         nrows:      height of graph
%   output: 
%         UorV:  'u' if u node, 'v' if v node
%         x:     horizontal value
%         y:     vertical value
%   For example a 2*3 graph can be converted into
%     v -->    10 11 12
%     v -->    7  8  9
%     u -->    4  5  6
%     u -->    1  2  3
%
    if nodeLabel > ncols * nrows
        nodeLabel = nodeLabel - ncols * nrows;
        UorV = 'v';
    else
        UorV = 'u';
    end
    x = rem(nodeLabel, ncols);
    y = floor(nodeLabel / cols);
end

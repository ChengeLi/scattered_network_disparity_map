function  [MaxFlow, FlowMatrix, Cut] = matlab_builtin_maxflow(A,T)
G=sparse(N+2,N+2);

G(size(A,1)+1,1:size(A,1))=T(:,1)'; % source
G(1:size(A,1),end)=T(:,2);    %sink

G(1:size(A,1),1:size(A,2))=A;

 [MaxFlow, FlowMatrix, Cut] = graphmaxflow(G, size(A,1)+1, size(A,1)+2);


[row,col,val]=find(G);
datatmp = [row, col, val];

save -ascii Graph_matrix.txt datatmp;


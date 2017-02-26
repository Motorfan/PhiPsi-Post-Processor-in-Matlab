% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function [DOMAIN_Outline,Domain_El] = Cal_Support_Domain_of_Node(iNode,i_Elem)
% This function calculates the support domain of node.

global Elem_Node 
global Num_Elem
% iNode
% Get elements which contain iNode.
Domain_El=[];
for i = 1:Num_Elem
	NODES_iElem = [Elem_Node(i,1) Elem_Node(i,2) ...
		           Elem_Node(i,3) Elem_Node(i,4)];             % Four nodes of the current element.
	if any(NODES_iElem==iNode) ==1
	    Domain_El = [Domain_El i];
	end
end

% Find outline of the support domain.
tem = sort([Elem_Node(Domain_El,1) Elem_Node(Domain_El,2); Elem_Node(Domain_El,2) Elem_Node(Domain_El,3); 
          Elem_Node(Domain_El,3) Elem_Node(Domain_El,4); Elem_Node(Domain_El,4) Elem_Node(Domain_El,1) ]')';
[u,m,n] = unique(tem,'rows','stable');        % Determine uniqueness of edges.
counts  = accumarray(n(:), 1);     % Determine counts for each unique edge.
DOMAIN_Outline = u(counts==1,:);   % Extract edges that only occurred once and store as a public value.

% Sort DOMAIN_Outline by end to end.
[New_DOMAIN_Outline] = Tools_Srot_by_End_to_End(DOMAIN_Outline);
DOMAIN_Outline = New_DOMAIN_Outline;
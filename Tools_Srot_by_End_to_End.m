% Written By: Shi Fang, 2014% Website: phipsi.top% Email: phipsi@sina.cnfunction [New_Outline] = Tools_Srot_by_End_to_End(Outline)% This function sorts Outline by end to end.New_Outline = Outline(1,:);c_Outline   =1;Sorted_Nodes = [];for i = 1:size(Outline,1);    if i==1	    c_Outline = 1;		c_node_num_2 = Outline(1,2);	end    for j = 1:size(Outline,1)	    if j ~= c_Outline		    if c_node_num_2 == Outline(j,1)				if ismember([Outline(j,1) Outline(j,2)],New_Outline,'rows') ==0					New_Outline = [New_Outline; [Outline(j,1) Outline(j,2)]];					c_Outline = j;					c_node_num_2 = Outline(j,2);					continue				end		    elseif c_node_num_2 == Outline(j,2)				if ismember([Outline(j,2) Outline(j,1)],New_Outline,'rows') ==0					New_Outline = [New_Outline; [Outline(j,2) Outline(j,1)]];					c_Outline = j;					c_node_num_2 = Outline(j,1);					continue				end			end		end	endend
% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function Plot_Gauss_Disp(DISP,isub,Crack_X,Crack_Y,POS,Enriched_Node_Type,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
					      Coors_Vertex,Coors_Junction,Coors_Tip,Crack_Tip_Type,Shaped_Crack_Points)
% This function plots the displacement contours of all Gauss points.

global Node_Coor Elem_Node Num_Elem
global Min_X_Coor Max_X_Coor Min_Y_Coor Max_Y_Coor
global Key_PLOT Num_Node
global Size_Font num_Crack Outline Inline
global Num_Contourlevel Full_Pathname Key_Integral_Sol Key_Contour_Metd
global Color_Crack Width_Crack Num_Gauss_Points aveg_area_ele Num_Accuracy_Contour
global Color_Contourlevel Color_Mesh Key_Flipped_Gray
global Na_Crack_X Na_Crack_Y num_Na_Crack Key_HF_Analysis
global Yes_has_FZ frac_zone_min_x frac_zone_max_x frac_zone_min_y frac_zone_max_y
global num_Hole Hole_Coor
global num_Circ_Inclusion Circ_Inclu_Coor
global Color_Inclusion
global num_Poly_Inclusion Poly_Incl_Coor_x Poly_Incl_Coor_y

disp('    > Plotting displacement contours of all Gauss points....') 

scale = Key_PLOT(4,6);

% Get the new coordinates of all nodes.
New_Node_Coor(:,1) = Node_Coor(:,1) + scale*DISP(1:Num_Node,2);
New_Node_Coor(:,2) = Node_Coor(:,2) + scale*DISP(1:Num_Node,3);

% Get the maximum and minimum value of the new coordinates of all nodes.
Min_X_Coor_New = min(min(New_Node_Coor(:,1)));
Max_X_Coor_New = max(max(New_Node_Coor(:,1)));
Min_Y_Coor_New = min(min(New_Node_Coor(:,2)));
Max_Y_Coor_New = max(max(New_Node_Coor(:,2)));

% Read gauss disp.
tem_Gauss_dis = load([Full_Pathname,'.disg_',num2str(isub)]);
Total_Gauss = size(tem_Gauss_dis,1);   %总的Gauss点数目

dis_x(1:Total_Gauss) = tem_Gauss_dis(1:Total_Gauss,2);
dis_y(1:Total_Gauss) = tem_Gauss_dis(1:Total_Gauss,3);

% Read gauss 坐标
Read_Gauss_Coor = load([Full_Pathname,'.gcor_',num2str(isub)]);
Gauss_Coor(:,1) = Read_Gauss_Coor(:,2);
Gauss_Coor(:,2) = Read_Gauss_Coor(:,3);
New_Gauss_Coor(:,1) = Gauss_Coor(:,1) + scale*dis_x(:);
New_Gauss_Coor(:,2) = Gauss_Coor(:,2) + scale*dis_y(:);	


% Find all points inside the mesh, THIS IS VERY SLOW if Node_Coor is large.	
% if Key_PLOT(4,8)==0		
    % IN = inpolygon(X,Y,Node_Coor(Outline,1),Node_Coor(Outline,2));
% elseif Key_PLOT(4,8)==1
    % IN = inpolygon(X,Y,New_Node_Coor(Outline,1),New_Node_Coor(Outline,2));
% end

% Don't draw points outside the mesh.
% Ux(~IN) = NaN;
% Uy(~IN) = NaN;

% Get resample coors.
delta = sqrt(aveg_area_ele)/Num_Accuracy_Contour;
if Key_PLOT(4,8)==0
	gx    = Min_X_Coor:delta:Max_X_Coor; 
	gy    = Min_Y_Coor:delta:Max_Y_Coor;
elseif Key_PLOT(4,8)==1
	gx    = Min_X_Coor_New:delta:Max_X_Coor_New; 
	gy    = Min_Y_Coor_New:delta:Max_Y_Coor_New;
end

% Plot the contours.
for i = 1:2
    % New figure.
    Tools_New_Figure
	hold on;
	if i == 1
	    if Key_PLOT(4,8)==0
			disp('      Resample Ux....') 
			if 	Key_Contour_Metd==1
				[X,Y,Ux] = griddata(Gauss_Coor(:,1),Gauss_Coor(:,2),dis_x(:),...
			                    unique(Gauss_Coor(:,1)),unique(Gauss_Coor(:,2))');
			elseif 	Key_Contour_Metd==2
			    [Ux,X,Y] = Tools_gridfit(Gauss_Coor(:,1),Gauss_Coor(:,2),dis_x(:),gx,gy);
            end				
		elseif Key_PLOT(4,8)==1
		    disp('      Resample Ux....') 
			if 	Key_Contour_Metd==1
         	    [X,Y,Ux] = griddata(New_Gauss_Coor(:,1),New_Gauss_Coor(:,2),dis_x(:), ...
	                              unique(New_Gauss_Coor(:,1)),unique(New_Gauss_Coor(:,2))');				
			elseif 	Key_Contour_Metd==2
				[Ux,X,Y] = Tools_gridfit(New_Gauss_Coor(:,1),New_Gauss_Coor(:,2),dis_x(:),gx,gy);
            end	
		end
	    disp('      Contouring Ux....') 
		%如果是快速云图绘制法,那么有可能网格化之后的数据范围会发生变化,因此绘图时需要将云图范围修正回真实的
		%范围
		% if Key_Contour_Metd==2
		    % caxis([min(dis_x), max(dis_x)]); 
		% end
		contourf(X,Y,Ux,Num_Contourlevel,'LineStyle','none')
		title('\it Displacement x','FontName','Times New Roman','FontSize',Size_Font)
		clear Ux
	elseif i == 2
	    if Key_PLOT(4,8)==0
			disp('      Resample Uy....') 
			if 	Key_Contour_Metd==1
				[X,Y,Uy] = griddata(Gauss_Coor(:,1),Gauss_Coor(:,2),dis_y(:),...
			                    unique(Gauss_Coor(:,1)),unique(Gauss_Coor(:,2))');
			elseif 	Key_Contour_Metd==2
				[Uy,X,Y] = Tools_gridfit(Gauss_Coor(:,1),Gauss_Coor(:,2),dis_y(:),gx,gy);
            end				
								
		elseif Key_PLOT(4,8)==1
			disp('      Resample Uy....') 
			if 	Key_Contour_Metd==1
			    [X,Y,Uy] = griddata(New_Gauss_Coor(:,1),New_Gauss_Coor(:,2),dis_y(:), ...
	                              unique(New_Gauss_Coor(:,1)),unique(New_Gauss_Coor(:,2))');	
			elseif 	Key_Contour_Metd==2
                [Uy,X,Y] = Tools_gridfit(New_Gauss_Coor(:,1),New_Gauss_Coor(:,2),dis_y(:),gx,gy);
			end	
		end
	    disp('      Contouring Uy....') 
		%如果是快速云图绘制法,那么有可能网格化之后的数据范围会发生变化,因此绘图时需要将云图范围修正回真实的
		%范围
		% if Key_Contour_Metd==2
		    % caxis([min(dis_y), max(dis_y)]); 
		% end
		contourf(X,Y,Uy,Num_Contourlevel,'LineStyle','none')
		title('\it Displacement y','FontName','Times New Roman','FontSize',Size_Font)
		clear Uy
	end
	% Set colormap.
	if Key_Flipped_Gray==0
		colormap(Color_Contourlevel)
	elseif Key_Flipped_Gray==1
		colormap(flipud(gray))
	end	
	% Plot the outline of the mesh.
	if Key_PLOT(4,8)==0
		line([Node_Coor(Outline(:,1),1) Node_Coor(Outline(:,2),1)]', ...
			 [Node_Coor(Outline(:,1),2) Node_Coor(Outline(:,2),2)]','LineWidth',1,'Color','black')
	elseif Key_PLOT(4,8)==1
		line([New_Node_Coor(Outline(:,1),1) New_Node_Coor(Outline(:,2),1)]', ...
			 [New_Node_Coor(Outline(:,1),2) New_Node_Coor(Outline(:,2),2)]','LineWidth',1,'Color','black')
	end
	
	% The range of the plot.
	if Key_PLOT(4,8)==0
	    min_x = Min_X_Coor; max_x = Max_X_Coor; min_y = Min_Y_Coor; max_y = Max_Y_Coor;
	elseif Key_PLOT(4,8)==1
	    min_x = Min_X_Coor_New; max_x = Max_X_Coor_New;
		min_y = Min_Y_Coor_New; max_y = Max_Y_Coor_New;
	end
	axis([min_x max_x min_y max_y]);	
	
	% Fill the outside of the domain by white color.
	if Key_PLOT(4,8)==0
	    Tools_Fillout(Node_Coor(Outline(:,1),1),Node_Coor(Outline(:,1),2),[min_x max_x min_y max_y],'w'); 
	elseif Key_PLOT(4,8)==1
	    Tools_Fillout(New_Node_Coor(Outline(:,1),1),New_Node_Coor(Outline(:,1),2),[min_x max_x min_y max_y],'w'); 
	end
	
	% Fill the inside of the domain by white color, holes, for example.
	if isempty(Inline)==0
		if Key_PLOT(4,8)==0
			fill(Node_Coor(Inline(:,1),1),Node_Coor(Inline(:,1),2),'w');
		elseif Key_PLOT(4,8)==1 
			fill(New_Node_Coor(Inline(:,1),1),New_Node_Coor(Inline(:,1),2),'w')	
		end
	end
	
	% Plot the mesh.
    if Key_PLOT(4,9) ==1
		if Key_PLOT(4,8)==0
			for iElem =1:Num_Elem
				NN = [Elem_Node(iElem,1) Elem_Node(iElem,2) ...
					  Elem_Node(iElem,3) Elem_Node(iElem,4) Elem_Node(iElem,1)]; % Nodes for current element
				xi = Node_Coor(NN',1);                                           % Deformed x-coordinates of nodes
				yi = Node_Coor(NN',2);                                           % Deformed y-coordinates of nodes
				plot(xi,yi,'LineWidth',1,'Color',Color_Mesh)
			end
		elseif Key_PLOT(4,8)==1
			for iElem =1:Num_Elem
				NN = [Elem_Node(iElem,1) Elem_Node(iElem,2) ...
					  Elem_Node(iElem,3) Elem_Node(iElem,4) Elem_Node(iElem,1)];     % Nodes for current element
				xi = New_Node_Coor(NN',1);                                           % Deformed x-coordinates of nodes
				yi = New_Node_Coor(NN',2);                                           % Deformed y-coordinates of nodes
				plot(xi,yi,'LineWidth',1,'Color',Color_Mesh)
			end
		end
	end
	%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	% 绘制天然裂缝.
	%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	if Key_PLOT(4,12) == 1
		disp(['      ----- Plotting natural crack line...'])
		if isempty(Na_Crack_X)==0
			for tt_i = 1:num_Na_Crack
				nPt = size(Na_Crack_X{tt_i},2);
				for iPt = 2:nPt
					x = [Na_Crack_X{tt_i}(iPt-1) Na_Crack_X{tt_i}(iPt)];
					y = [Na_Crack_Y{tt_i}(iPt-1) Na_Crack_Y{tt_i}(iPt)]; 
					for jj =1:2
						% Get the local coordinates of the points of the crack. 
						[Kesi,Yita] = Cal_KesiYita_by_Coors(x(jj),y(jj));
						% Get the element number which contains the points of the crack. 
						[c_Elem_Num] = Cal_Ele_Num_by_Coors(x(jj),y(jj));
						% Calculate the displacement of the points of the crack. 
						N1  = Elem_Node(c_Elem_Num,1);                                                  
						N2  = Elem_Node(c_Elem_Num,2);                                                  
						N3  = Elem_Node(c_Elem_Num,3);                                                  
						N4  = Elem_Node(c_Elem_Num,4);                                                
						U = [DISP(N1,2) DISP(N1,3) DISP(N2,2) DISP(N2,3)...
							 DISP(N3,2) DISP(N3,3) DISP(N4,2) DISP(N4,3)];
						% Calculates N, dNdkesi, J and the determinant of Jacobian matrix.
						[N,~,~,~]  = Cal_N_dNdkesi_J_detJ(Kesi,Yita,[],[]);
						dis_x(jj) = U(1)*N(1,1) + U(3)*N(1,3) + U(5)*N(1,5) + U(7)*N(1,7);  
						dis_y(jj) = U(2)*N(1,1) + U(4)*N(1,3) + U(6)*N(1,5) + U(8)*N(1,7);  
					end
					
					last_x = [ x(1)+dis_x(1)*scale x(2)+dis_x(2)*scale];
					last_y = [ y(1)+dis_y(1)*scale y(2)+dis_y(2)*scale];
					
					% plot(last_x,last_y,'w','LineWidth',Width_Crack,'Color',Color_Crack)   
					plot(last_x,last_y,'w','LineWidth',1,'Color','White')   
					% plot(x,y,'--','Color',Color_Crack,'LineWidth',Width_Crack)  
				end
			end	
		end
	end
			
	if Key_PLOT(4,5) == 1
	%%%%Plot cracks line if necessary.
		if num_Crack(isub)~=0
			for iii = 1:num_Crack(isub)
				nPt = size(Crack_X{iii},2);
				for iPt = 2:nPt
					x = [Crack_X{iii}(iPt-1) Crack_X{iii}(iPt)];
					y = [Crack_Y{iii}(iPt-1) Crack_Y{iii}(iPt)];
					for j =1:2
						%%% Get the local coordinates of the points of the crack. 
						[cKesi,cYita] = Cal_KesiYita_by_Coors(x(j),y(j));
						%%% Get the element number which contains the points of the crack. 
						[c_Elem_Num] = Cal_Ele_Num_by_Coors(x(j),y(j));
						%%% Calculate the displacement of the points of the crack. 
						N1  = Elem_Node(c_Elem_Num,1);                                                  
						N2  = Elem_Node(c_Elem_Num,2);                                                  
						N3  = Elem_Node(c_Elem_Num,3);                                                  
						N4  = Elem_Node(c_Elem_Num,4);                                                
						cU = [DISP(N1,2) DISP(N1,3) DISP(N2,2) DISP(N2,3)...
							  DISP(N3,2) DISP(N3,3) DISP(N4,2) DISP(N4,3)];
						%%% Calculates N, dNdkesi, J and the determinant of Jacobian matrix.
						[N,~,~,~]  = Cal_N_dNdkesi_J_detJ(cKesi,cYita,[],[]);
						cdis_x(j) = cU(1)*N(1,1) + cU(3)*N(1,3) + cU(5)*N(1,5) + cU(7)*N(1,7);  
						cdis_y(j) = cU(2)*N(1,1) + cU(4)*N(1,3) + cU(6)*N(1,5) + cU(8)*N(1,7);  
					end
					
					last_x = [ x(1)+cdis_x(1)*scale x(2)+cdis_x(2)*scale];
					last_y = [ y(1)+cdis_y(1)*scale y(2)+cdis_y(2)*scale];
					
					plot(last_x,last_y,'w','LineWidth',Width_Crack,'Color',Color_Crack)   
				end
			end	
		end
	end
	% Plot shaped cracks if necessary.
	if Key_PLOT(4,5) == 2 & num_Crack(isub)~=0
	    disp(['      > Plotting shaped cracks......'])
		Plot_Shaped_Cracks(Shaped_Crack_Points)
	end
	% Plot holes.
	disp(['      ----- Plotting hole...'])
	if num_Hole ~=0
		for iHole= 1:num_Hole
			Coor_x  = Hole_Coor(iHole,1);
			Coor_y  = Hole_Coor(iHole,2);
			c_R  = Hole_Coor(iHole,3);
			num_fineness = 100;
			for j_P = 1:num_fineness+1
				alpha = 2*pi/num_fineness*(j_P-1);
				t_x(j_P) = Coor_x + c_R*cos(alpha);
				t_y(j_P) = Coor_y + c_R*sin(alpha);
				[Kesi,Yita] = Cal_KesiYita_by_Coors(t_x(j_P),t_y(j_P));
				[c_Elem_Num] = Cal_Ele_Num_by_Coors(t_x(j_P),t_y(j_P));
				[t_dis_x(j_P),t_dis_y(j_P)] = Cal_Anypoint_Disp(c_Elem_Num,Enriched_Node_Type,POS,isub,DISP,Kesi,Yita...
																 ,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
																  Coors_Vertex,Coors_Junction,Coors_Tip,Crack_X,Crack_Y); 
			end
			x_new = t_x + t_dis_x*Key_PLOT(4,6);
			y_new = t_y + t_dis_y*Key_PLOT(4,6);
			% plot(x_new,y_new,'-')
			patch(x_new,y_new,'white','edgecolor','black','LineWidth',0.1)	
		end	
	end
	%%% 绘制圆形夹杂.
	disp(['      ----- Plotting circle inclusion...'])
	if num_Circ_Inclusion ~=0
		for i_Inclusion = 1:num_Circ_Inclusion
			Coor_x  = Circ_Inclu_Coor(i_Inclusion,1);
			Coor_y  = Circ_Inclu_Coor(i_Inclusion,2);
			c_R  = Circ_Inclu_Coor(i_Inclusion,3);
			num_fineness = 100;
			for j_P = 1:num_fineness+1
				alpha = 2*pi/num_fineness*(j_P-1);
				t_x(j_P) = Coor_x + c_R*cos(alpha);
				t_y(j_P) = Coor_y + c_R*sin(alpha);
				[Kesi,Yita] = Cal_KesiYita_by_Coors(t_x(j_P),t_y(j_P));
				[c_Elem_Num] = Cal_Ele_Num_by_Coors(t_x(j_P),t_y(j_P));
				[t_dis_x(j_P),t_dis_y(j_P)] = Cal_Anypoint_Disp(c_Elem_Num,Enriched_Node_Type,POS,isub,DISP,Kesi,Yita...
																 ,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
																  Coors_Vertex,Coors_Junction,Coors_Tip,Crack_X,Crack_Y); 
			end
			x_new = t_x + t_dis_x*Key_PLOT(4,6);
			y_new = t_y + t_dis_y*Key_PLOT(4,6);
			% 绘制
			% plot(x_new,y_new,'-','color','black')
			% 填充
			patch(x_new,y_new,Color_Inclusion,'facealpha',0.3,'edgecolor','black','LineWidth',0.1)	 %透明度'facealpha'
		end	
	end
	%<<<<<<<<<<<<<<<<<<<<<<<<<<<
	% 绘制多边形夹杂,2016-10-04
	%<<<<<<<<<<<<<<<<<<<<<<<<<<<
	if num_Poly_Inclusion ~=0
		disp(['      ----- Plotting poly inclusion...'])
		for iii = 1:num_Poly_Inclusion
			nEdge = size(Poly_Incl_Coor_x{iii},2);
			Num_Diversion = 5;    %多边形的每条边拆分成5份
			k = 0;
			for iEdge = 1:nEdge
				%获取边线的起点和终点
				if iEdge==nEdge
					Line_Edge(1,1) = Poly_Incl_Coor_x{iii}(iEdge); %边线的起点
					Line_Edge(1,2) = Poly_Incl_Coor_y{iii}(iEdge);
					Line_Edge(2,1) = Poly_Incl_Coor_x{iii}(1);     %边线的终点
					Line_Edge(2,2) = Poly_Incl_Coor_y{iii}(1);
				else
					Line_Edge(1,1) = Poly_Incl_Coor_x{iii}(iEdge);   %边线的起点
					Line_Edge(1,2) = Poly_Incl_Coor_y{iii}(iEdge);
					Line_Edge(2,1) = Poly_Incl_Coor_x{iii}(iEdge+1); %边线的终点
					Line_Edge(2,2) = Poly_Incl_Coor_y{iii}(iEdge+1);
				end
				% 等分点.
				a_x = Line_Edge(1,1);
				a_y = Line_Edge(1,2);
				b_x = Line_Edge(2,1);
				b_y = Line_Edge(2,2);
				%计算边线起点的位移
				k =k+1;
				t_x(k) = a_x;
				t_y(k) = a_y;
				[Kesi,Yita] = Cal_KesiYita_by_Coors(t_x(k),t_y(k));
				[c_Elem_Num] = Cal_Ele_Num_by_Coors(t_x(k),t_y(k));
				[t_dis_x(k),t_dis_y(k)] = Cal_Anypoint_Disp(c_Elem_Num,Enriched_Node_Type,POS,isub,DISP,Kesi,Yita...
																 ,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
																  Coors_Vertex,Coors_Junction,Coors_Tip,Crack_X,Crack_Y); 
				%计算等分点的位移
				for jjj =  1:Num_Diversion-1
					k=k+1;
					t_x(k) = (jjj*b_x+(Num_Diversion-jjj)*a_x)/Num_Diversion;
					t_y(k) = (jjj*b_y+(Num_Diversion-jjj)*a_y)/Num_Diversion;
					[Kesi,Yita] = Cal_KesiYita_by_Coors(t_x(k),t_y(k));
					[c_Elem_Num] = Cal_Ele_Num_by_Coors(t_x(k),t_y(k));
					[t_dis_x(k),t_dis_y(k)] = Cal_Anypoint_Disp(c_Elem_Num,Enriched_Node_Type,POS,isub,DISP,Kesi,Yita...
																 ,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
																  Coors_Vertex,Coors_Junction,Coors_Tip,Crack_X,Crack_Y); 
				end												      
			end
			x_new = t_x + t_dis_x*Key_PLOT(4,6);
			y_new = t_y + t_dis_y*Key_PLOT(4,6);
			................
			% option1:填充
			%................
			patch(x_new,y_new,Color_Inclusion,'facealpha',0.3,'edgecolor','black','LineWidth',0.1)	 %透明度'facealpha'
			................
			% option2:绘制边线
			%................
			% x_new(k+1) = x_new(1);
			% y_new(k+1) = y_new(1);
			% plot(x_new,y_new,'-','color','black')
		end	
	end	
	%绘制支撑剂的圆球
	if Key_PLOT(4,10)==1 
		%如果支撑剂直径和坐标文件存在：
		if exist([Full_Pathname,'.epcr_',num2str(isub)], 'file') ==2 
			disp(['      ----- Plotting proppant......'])  
			%读取文件		
			c_D_Coors=load([Full_Pathname,'.epcr_',num2str(isub)]);
			num_Proppant = size(c_D_Coors,1);
			for i=1:num_Proppant
				%绘制实心圆
				alpha=0:pi/20:2*pi;
				c_Elem_Num = c_D_Coors(i,1);
				R = c_D_Coors(i,2)/2*Key_PLOT(4,6);
				old_Coor_x = c_D_Coors(i,3);
				old_Coor_y = c_D_Coors(i,4);
				omega = c_D_Coors(i,5);  %对应裂纹片段的倾角
				l_elem= sqrt(aveg_area_ele);
				offset_delta = 0.001*l_elem;
				%原支撑剂所在点的上裂纹偏置微小量之后的点
				old_Coor_x_Up  = old_Coor_x - offset_delta*sin(omega);
				old_Coor_y_Up  = old_Coor_y + offset_delta*cos(omega);
				%原支撑剂所在点的上裂纹偏置微小量之后下偏置点
				old_Coor_x_Low = old_Coor_x + offset_delta*sin(omega);
				old_Coor_y_Low = old_Coor_y - offset_delta*cos(omega);
				%计算支撑剂中心坐标变形后的坐标
				[Kesi_Up,Yita_Up] = Cal_KesiYita_by_Coors(old_Coor_x_Up,old_Coor_y_Up);
				[dis_x_Up,dis_y_Up] = Cal_Anypoint_Disp(c_Elem_Num,Enriched_Node_Type,POS,isub,DISP,Kesi_Up,Yita_Up...
																 ,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
																  Coors_Vertex,Coors_Junction,Coors_Tip,Crack_X,Crack_Y);
				[Kesi_Low,Yita_Low] = Cal_KesiYita_by_Coors(old_Coor_x_Low,old_Coor_y_Low);
				[dis_x_Low,dis_y_Low] = Cal_Anypoint_Disp(c_Elem_Num,Enriched_Node_Type,POS,isub,DISP,Kesi_Low,Yita_Low...
																 ,Elem_Type,Coors_Element_Crack,Node_Jun_elem,...
																  Coors_Vertex,Coors_Junction,Coors_Tip,Crack_X,Crack_Y);
				%真实的支撑剂所在点的位移											  
				c_dis_x = (dis_x_Up + dis_x_Low)/2;			
				c_dis_y = (dis_y_Up + dis_y_Low)/2;	
				
				c_Coor_x = old_Coor_x  + c_dis_x*Key_PLOT(4,6);
				c_Coor_y = old_Coor_y  + c_dis_y*Key_PLOT(4,6);
				
				c_x = c_Coor_x + R*cos(alpha);
				c_y = c_Coor_y + R*sin(alpha);
				plot(c_x,c_y,'-')
				axis equal
				fill(c_x,c_y,[128/255,138/255,135/255])
			end
		end
	end
	%绘制破裂区
	if Key_PLOT(4,15)==1 
		%如果定义了破裂区
		if Yes_has_FZ ==1
			disp(['      ----- Plotting fracture zone......'])  
			for i_line = 1:4
				if i_line ==1
					x = [frac_zone_min_x,frac_zone_max_x];
					y = [frac_zone_min_y,frac_zone_min_y];
				elseif i_line ==2
					x = [frac_zone_max_x,frac_zone_max_x];
					y = [frac_zone_min_y,frac_zone_max_y];
				elseif i_line ==3
					x = [frac_zone_max_x,frac_zone_min_x];
					y = [frac_zone_max_y,frac_zone_max_y];
				elseif i_line ==4
					x = [frac_zone_min_x,frac_zone_min_x];
					y = [frac_zone_max_y,frac_zone_min_y];
				end
				for j =1:2
					%%% Get the local coordinates of the points of the crack. 
					[cKesi,cYita] = Cal_KesiYita_by_Coors(x(j),y(j));
					%%% Get the element number which contains the points of the crack. 
					[c_Elem_Num] = Cal_Ele_Num_by_Coors(x(j),y(j));
					%%% Calculate the displacement of the points of the crack. 
					N1  = Elem_Node(c_Elem_Num,1);                                                  
					N2  = Elem_Node(c_Elem_Num,2);                                                  
					N3  = Elem_Node(c_Elem_Num,3);                                                  
					N4  = Elem_Node(c_Elem_Num,4);                                                
					cU = [DISP(N1,2) DISP(N1,3) DISP(N2,2) DISP(N2,3)...
						  DISP(N3,2) DISP(N3,3) DISP(N4,2) DISP(N4,3)];
					%%% Calculates N, dNdkesi, J and the determinant of Jacobian matrix.
					[N,~,~,~]  = Cal_N_dNdkesi_J_detJ(cKesi,cYita,[],[]);
					cdis_x(j) = cU(1)*N(1,1) + cU(3)*N(1,3) + cU(5)*N(1,5) + cU(7)*N(1,7);  
					cdis_y(j) = cU(2)*N(1,1) + cU(4)*N(1,3) + cU(6)*N(1,5) + cU(8)*N(1,7);  
				end
				
				last_x = [ x(1)+cdis_x(1)*scale x(2)+cdis_x(2)*scale];
				last_y = [ y(1)+cdis_y(1)*scale y(2)+cdis_y(2)*scale];
				
				plot(last_x,last_y,'w','LineWidth',1.5,'Color','green')   
			end
		end
	end

	axis equal; 
	%colorbar('FontAngle','italic','FontName','Times New Roman','FontSize',Size_Font);
	colorbar('FontName','Times New Roman','FontSize',Size_Font);
    set(gca,'XTick',[],'YTick',[],'XColor','w','YColor','w')

	% Save pictures.
    if i == 1
	    Save_Picture(c_figure,Full_Pathname,'dpxs')
	elseif i ==2
	    Save_Picture(c_figure,Full_Pathname,'dpys')
	end		
end



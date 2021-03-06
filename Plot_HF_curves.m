% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function Plot_HF_curves(POST_Substep)

global Key_PLOT Full_Pathname Num_Node Num_Foc_x Num_Foc_y Foc_x Foc_y
global num_Crack Key_Dynamic Real_Iteras Real_Sub Key_Contour_Metd
global Output_Freq num_Output_Sub Key_Crush Num_Crack_HF_Curves Size_Font 
global Plot_Aperture_Curves Plot_Pressure_Curves Num_Step_to_Plot 
global Plot_Velocity_Curves Plot_Quantity_Curves Plot_Concentr_Curves
global Plot_Tan_Aper_Curves  Plot_Wpnp_Curves Plot_Wphp_Curves

%按行读取文件（适用于多条裂纹）
if Plot_Pressure_Curves==1
    if exist([Full_Pathname,'.cpre_',num2str(Num_Step_to_Plot)], 'file') ==2 
		disp('    > 读取水压....') 
		namefile= [Full_Pathname,'.cpre_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Pressure(lineNum,1:c_num)  = str2num(TemData);   
			average_pres=sum(Pressure(lineNum,1:c_num))/c_num;  %平均水压
			num_CalP_each_Crack(lineNum) = c_num;  %每条裂纹的计算点数目
		end
		fclose(data); 
	end
end
if Plot_Tan_Aper_Curves==1
    if exist([Full_Pathname,'.ctap_',num2str(Num_Step_to_Plot)], 'file') ==2 
		disp('    > 读取切向开度....'); 
		namefile= [Full_Pathname,'.ctap_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Tan_Aperture(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %每条裂纹的计算点数目
		end
		fclose(data); 
	end
end
if Plot_Velocity_Curves==1
    if exist([Full_Pathname,'.cvel_',num2str(Num_Step_to_Plot)], 'file') ==2  
		disp('    > 读取流速....'); 
		namefile= [Full_Pathname,'.cvel_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Velocity(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %每条裂纹的计算点数目
		end
		fclose(data); 
	end
end

if Plot_Quantity_Curves==1
	if exist([Full_Pathname,'.cqua_',num2str(Num_Step_to_Plot)], 'file') ==2  
		disp('    > 读取流量....'); 
		namefile= [Full_Pathname,'.cqua_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Quantity(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %每条裂纹的计算点数目
		end
		fclose(data); 
	end
end

if Plot_Concentr_Curves==1
	if exist([Full_Pathname,'.ccon_',num2str(Num_Step_to_Plot)], 'file') ==2  
		disp('    > 读取支撑剂浓度....'); 
		namefile= [Full_Pathname,'.ccon_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Concentr(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %每条裂纹的计算点数目
		end
		fclose(data); 
	end
end

if Plot_Wpnp_Curves==1
	if exist([Full_Pathname,'.wpnp_',num2str(Num_Step_to_Plot)], 'file') ==2  
		disp('    > 读取wpnp....'); 
		namefile= [Full_Pathname,'.wpnp_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			wpnp(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %每条裂纹的计算点数目
		end
		fclose(data); 
	end
end

if exist([Full_Pathname,'.apex_',num2str(Num_Step_to_Plot)], 'file') ==2  
	disp('    > 读取计算点x坐标....') 
	namefile= [Full_Pathname,'.apex_',num2str(POST_Substep)];
	data=fopen(namefile,'r'); 
	lineNum = 0;
	while ~feof(data)
		lineNum = lineNum+1;
		TemData = fgetl(data);              
		c_num   = size(str2num(TemData),2); 
		x(lineNum,1:c_num)  = str2num(TemData); 
	end
	fclose(data); 
end

if exist([Full_Pathname,'.apey_',num2str(Num_Step_to_Plot)], 'file') ==2  
	disp('    > 读取计算点y坐标....') 
	namefile= [Full_Pathname,'.apey_',num2str(POST_Substep)];
	data=fopen(namefile,'r'); 
	lineNum = 0;
	while ~feof(data)
		lineNum = lineNum+1;
		TemData = fgetl(data);              
		c_num   = size(str2num(TemData),2); 
		y(lineNum,1:c_num)  = str2num(TemData); 
	end
	fclose(data); 
end

if Plot_Aperture_Curves==1
    if exist([Full_Pathname,'.cape_',num2str(Num_Step_to_Plot)], 'file') ==2 
		disp('    > 读取开度....'); 
		namefile= [Full_Pathname,'.cape_',num2str(POST_Substep)];
		data=fopen(namefile,'r'); 
		lineNum = 0;
		while ~feof(data)
			lineNum = lineNum+1;
			TemData = fgetl(data);              
			c_num   = size(str2num(TemData),2); 
			Aperture(lineNum,1:c_num)  = str2num(TemData);  
			num_CalP_each_Crack(lineNum) = c_num;  %每条裂纹的计算点数目
		end
		fclose(data); 
	end
end
%计算计算点对应的裂纹长度

for i= 1:num_Crack(Num_Step_to_Plot)
	for j=1:num_CalP_each_Crack(i)
	    for k=1:j
		    if k==1
			    L(i,j)=0;
			else
		        L(i,j) = L(i,j) + sqrt((x(i,k)-x(i,k-1))^2+(y(i,k)-y(i,k-1))^2);
			end 
		end
	end
end

if exist([Full_Pathname,'.cpre_',num2str(Num_Step_to_Plot)], 'file') ==2 
	% -----------------------------------
	% 绘制各条裂纹的曲线(水力压裂相关)
	% -----------------------------------
	for i=1:num_Crack(Num_Step_to_Plot)
		%检查当前裂纹是否需要绘制
		if ismember(i,Num_Crack_HF_Curves)==1
			%--------------------------------------
			%        绘制水压
			%--------------------------------------
			if Plot_Pressure_Curves==1
				disp(['    > 绘制裂纹 ',num2str(i),' 水压曲线...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Net pressure of crack 1 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Net pressure of crack 2 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Net pressure of crack 3 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Net pressure of crack 4 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Net pressure of crack 5 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Net pressure of crack 6 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Net pressure of crack 7 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Net pressure of crack 8 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Net pressure of crack 9 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Net pressure of crack 10 (MPa)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Pressure(i,1:num_CalP_each_Crack(i))/1.0E6,'b-+')
				%保存文件
				% c_Length = (L(2,1:num_CalP_each_Crack(2)))';
				% c_Pressure = (Pressure(2,1:num_CalP_each_Crack(2))/1.0e6)';
				% save D:\paper02_crack2_c_Length.txt c_Length -ascii
				% save D:\paper02_crack2_c_Pressure.txt c_Pressure -ascii
			end
			%--------------------------------------
			%        绘制开度
			%--------------------------------------
			if Plot_Aperture_Curves==1
				disp(['    > 绘制裂纹 ',num2str(i),' 开度曲线...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Aperture of crack 1 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Aperture of crack 2 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Aperture of crack 3 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Aperture of crack 4 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Aperture of crack 5 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Aperture of crack 6 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Aperture of crack 7 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Aperture of crack 8 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Aperture of crack 9 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Aperture of crack 10 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Aperture(i,1:num_CalP_each_Crack(i))*1000.0,'b-+')
			end
			%--------------------------------------
			%        绘制切向开度
			%--------------------------------------
			if Plot_Tan_Aper_Curves==1
			  if exist([Full_Pathname,'.ctap_',num2str(Num_Step_to_Plot)], 'file') ==2 
				disp(['    > 绘制切向裂纹 ',num2str(i),' 开度曲线...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Tangential aperture of crack 1 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Tangential aperture of crack 2 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Tangential aperture of crack 3 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Tangential aperture of crack 4 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Tangential aperture of crack 5 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Tangential aperture of crack 6 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Tangential aperture of crack 7 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Tangential aperture of crack 8 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Tangential aperture of crack 9 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Tangential aperture of crack 10 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Tan_Aperture(i,1:num_CalP_each_Crack(i))*1000.0,'b-+')
			  end
			end
			%--------------------------------------
			%        绘制流速
			%--------------------------------------
			if Plot_Velocity_Curves==1 && exist([Full_Pathname,'.cvel_',num2str(Num_Step_to_Plot)], 'file') ==2  
				disp(['    > 绘制裂纹 ',num2str(i),' 流速曲线...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Velocity of crack 1 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Velocity of crack 2 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Velocity of crack 3 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Velocity of crack 4 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Velocity of crack 5 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Velocity of crack 6 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Velocity of crack 7 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Velocity of crack 8 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Velocity of crack 9 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Velocity of crack 10 (m/s)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Velocity(i,1:num_CalP_each_Crack(i)),'b-+')
			end
			%--------------------------------------
			%        绘制流量
			%--------------------------------------
			if Plot_Quantity_Curves==1 && exist([Full_Pathname,'.cqua_',num2str(Num_Step_to_Plot)], 'file') ==2  
				disp(['    > 绘制裂纹 ',num2str(i),' 流量曲线...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Quantity of crack 1 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Quantity of crack 2 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Quantity of crack 3 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Quantity of crack 4 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Quantity of crack 5 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Quantity of crack 6 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Quantity of crack 7 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Quantity of crack 8 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Quantity of crack 9 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Quantity of crack 10 (m^2/s)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Quantity(i,1:num_CalP_each_Crack(i)),'b-+')
			end
			%--------------------------------------
			%        绘制支撑剂浓度曲线
			%--------------------------------------
			if Plot_Concentr_Curves==1 && exist([Full_Pathname,'.ccon_',num2str(Num_Step_to_Plot)], 'file') ==2  
				disp(['    > 绘制支撑剂 ',num2str(i),' 浓度曲线...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it Proppant concentration of crack 1','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it Proppant concentration of crack 2','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it Proppant concentration of crack 3','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it Proppant concentration of crack 4','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it Proppant concentration of crack 5','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it Proppant concentration of crack 6','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it Proppant concentration of crack 7','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it Proppant concentration of crack 8','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it Proppant concentration of crack 9','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it Proppant concentration of crack 10','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),Concentr(i,1:num_CalP_each_Crack(i)),'b-+')
			end
			%--------------------------------------
			%        绘制wpnp文件
			%--------------------------------------
			if Plot_Wpnp_Curves==1 && exist([Full_Pathname,'.wpnp_',num2str(Num_Step_to_Plot)], 'file') ==2  
				disp(['    > 绘制支撑剂 ',num2str(i),' 支撑裂缝开度(闭合压力为0)...']) 
				c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
				hold on;
				if i==1 
					title('\it wpnp of crack 1 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==2
					title('\it wpnp of crack 2 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==3
					title('\it wpnp of crack 3 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==4
					title('\it wpnp of crack 4 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==5
					title('\it wpnp of crack 5 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==6
					title('\it wpnp of crack 6 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==7
					title('\it wpnp of crack 7 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==8
					title('\it wpnp of crack 8 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==9
					title('\it wpnp of crack 9 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				elseif i==10
					title('\it wpnp of crack 10 (mm)','FontName','Times New Roman','FontSize',Size_Font)
				end	
				plot(L(i,1:num_CalP_each_Crack(i)),wpnp(i,1:num_CalP_each_Crack(i))*1000,'b-+')
			end
		end
	end
end
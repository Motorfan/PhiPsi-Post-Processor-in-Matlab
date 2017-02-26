% Written By: Shi Fang, 2014
% Website: phipsi.top
% Email: phipsi@sina.cn

function Plot_Injection_Pressure_curves(POST_Substep,Key_InjP_Curves_x)

global Key_PLOT Full_Pathname Num_Node Num_Foc_x Num_Foc_y Foc_x Foc_y
global num_Crack Key_Dynamic Real_Iteras Real_Sub Key_Contour_Metd
global Output_Freq num_Output_Sub Key_Crush Num_Crack_HF_Curves Size_Font 
global Plot_Aperture_Curves Plot_Pressure_Curves Num_Step_to_Plot 
global Plot_Velocity_Curves Plot_Quantity_Curves Plot_Concentr_Curves

%***********
%读取数据
%***********
disp('    > 读取各破裂步对应的注水时间和水压(injp文件)....') 
namefile= [Full_Pathname,'.injp'];
data=fopen(namefile,'r'); 
lineNum = 0;
num_frac = 0;
while ~feof(data)
	lineNum = lineNum+1;
	TemData = fgetl(data);    
	if lineNum>=2   %第一行是文件标识行,不予读取
	    num_frac = num_frac+1;                     %总的破裂步数	   
	    ttt_DATA(num_frac,1:3)  = str2num(TemData);
	end
end
fclose(data); 

% -----------------------------------
% 绘制各条裂纹的曲线(水力压裂相关)
% -----------------------------------
disp(['    > 绘制注水点水压变化曲线...']) 
c_figure = figure('units','normalized','position',[0.2,0.2,0.6,0.6],'Visible','on');
hold on;
title('\it Injection pressure (MPa)','FontName','Times New Roman','FontSize',Size_Font)
%以注水时间为x轴
if Key_InjP_Curves_x==1
    plot(ttt_DATA(1:num_frac,2)/60.0,ttt_DATA(1:num_frac,3)/1.0e6,'black-o','LineWidth',1)
    xlabel('Injection time (min)','FontName','Times New Roman','FontSize',Size_Font) 
%以压裂步数为x轴
elseif Key_InjP_Curves_x==2
    plot(ttt_DATA(1:num_frac,1),ttt_DATA(1:num_frac,3)/1.0e6,'black-o','LineWidth',1)
    xlabel('Fracturing step','FontName','Times New Roman','FontSize',Size_Font)     
	set(gca,'xtick',1:1:num_frac)     
end
ylabel('Injection pressure (MPa)','FontName','Times New Roman','FontSize',Size_Font) 
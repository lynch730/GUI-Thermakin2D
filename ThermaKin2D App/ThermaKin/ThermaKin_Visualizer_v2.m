% Program Name: Thermakin2Ds GUI

function Thermakin2DsVisualizer

%
close all;
clc;
%


f1 = figure('Visible','off','NumberTitle', 'off','Position',[360,900,1350,700],'units', 'normalized');
set(f1,'MenuBar', 'none','ToolBar','none','units', 'normalized');
f1.Name = 'Thermakin2Ds Output Visualizer';
movegui(f1,'center');

%Input panel
uipanel('Parent',f1,'Title','Inputs','Position',[.001 .001 .125 .999],'units', 'normalized');
popup = uicontrol('Style','popup','String',{'TGA/DSC','MCC','Cone','---'},'Position', ...
    [15,590,140,80],'Callback',@popup_CB, 'units', 'normalized');
uicontrol('Style','text','String','Experimental Data Input',...
    'Position',[15,590,130,15],'units', 'normalized');
browsein1 = uicontrol('Style','pushbutton','String','Browse','Position', ...
    [15,535,135,45],'Callback',@browseexp_CB, 'units', 'normalized');
datacursor1 = uicontrol('Style','togglebutton','String','Data Cursor','Position', ...
    [50,320,75,30],'Callback',@datacursor, 'units', 'normalized');

uicontrol('Style','text','String','Thermakin Output',...
    'Position',[20,455,120,20],'units', 'normalized');
uicontrol('Style','pushbutton','String','Browse','Position', ...
    [15,411,135,45],'Callback',@browsetk_CB, 'units', 'normalized');
uicontrol('Style','pushbutton','String','Plot','Position', ...
    [10,211,150,70],'Callback',@plot_CB, 'units', 'normalized');
uicontrol('Style','pushbutton','String','Save Thermakin Output As','Position', ...
    [10,100,150,30],'Callback',@save, 'units', 'normalized');

	% Legend  change to experiment from experiemntal 
	
	% simulation plots overlay experimental 
	
	% both experimental and sim
	% filename loaded
	% error messages: filename load error 
expchk = uicontrol('Style','text','String','',...
    'Position',[20,490,120,40],'units', 'normalized');
tkchk = uicontrol('Style','text','String','',...
    'Position',[20,360,120,40],'units', 'normalized');
savechk = uicontrol('Style','text','String',''...
    ,'Position',[20,30,120,55],'units','normalized');
datacursorchk = uicontrol('Style','text','String','',...
    'Position',[20,280,120,40],'units', 'normalized');
set(browsein1,'ToolTip','Temp | Time | Normal Mass | MLR | Heat Flow | Integral Heat Flow');

%Graphs
hsp1 = uipanel('Parent',f1,'Title','Graphs','Position',[.127 .001 .873 .999],'units', 'normalized');
tabgp = uitabgroup(hsp1,'Position',[.001 .001 1.04 1.005]);

%TGA/DSC graphs
tgatab = uitab(tabgp,'Title','TGA/DSC');
massloss = axes('Parent',tgatab,'Position',[0.06 0.57 0.41 0.4],'Tag','ax','LineWidth',1);
massloss.Title.String = 'Mass Loss Rate';
massloss.YLabel.String ='Mass Loss Rate [1/s]';
massloss.XLabel.String = 'Temperature [K]';
set(gca,'NextPlot','replacechildren') ;
totmass = axes('Parent',tgatab,'Position',[0.54 0.57 0.41 0.4],'Tag','ax','LineWidth',1);
totmass.Title.String = 'Total Mass Normalized by Initial Mass';
totmass.YLabel.String ='Mass / Initial Mass';
totmass.XLabel.String = 'Temperature [K]';
set(gca,'NextPlot','replacechildren') ;
heatflow = axes('Parent',tgatab,'Position',[0.06 0.065 0.41 0.4],'Tag','ax','LineWidth',1);
heatflow.Title.String = 'Heat Flow (endotherm is positive)';
heatflow.YLabel.String ='Heat Flow [W/g]';
heatflow.XLabel.String = 'Temperature [K]';
set(gca,'NextPlot','replacechildren') ;
intheatflow = axes('Parent',tgatab,'Position',[0.54 0.065 0.41 0.4],'Tag','ax','LineWidth',1);
intheatflow.Title.String = 'Integral Heat Flow (endotherm is positive)';
intheatflow.YLabel.String ='Integral Heat Flow [J/g]';
intheatflow.XLabel.String = 'Temperature [K]';
set(gca,'NextPlot','replacechildren') ;

%MCC graphs
mcctab = uitab(tabgp,'Title','MCC');
hrr = axes('Parent',mcctab,'Position',[0.04 0.57 0.44 0.4],'Tag','hrr','LineWidth',1);
hrr.Title.String = 'Heat Release Rate';
hrr.YLabel.String = 'Heat Release Rate [W/g]';
hrr.XLabel.String = 'Temperature [K]';
set(gca,'NextPlot','replacechildren') ;
hrrint = axes('Parent',mcctab,'Position',[0.54 0.57 0.41 0.4],'Tag','hrrint','LineWidth',1);
hrrint.Title.String = 'Integral Heat Release Rate';
hrrint.YLabel.String = 'Integral Heat Release Rate [kJ/g]';
hrrint.XLabel.String = 'Temperature [K]' ;
set(gca,'NextPlot','replacechildren') ;
hctable = uitable(mcctab,'Data',(0),'ColumnEditable',true,'Position', ...
    [5 5 200 320],'ColumnWidth', {100},'ColumnName',{'Heat[kJ/g]'},'units','normalized');

%Cone Graphs
conetab = uitab(tabgp,'Title','Cone');
conemlr = axes('Parent',conetab,'Position',[0.63 0.58 0.32 0.35],'Tag','conemlr','LineWidth',1);
conemlr.Title.String = 'Mass Loss Rate';
conemlr.YLabel.String = 'Mass Loss Rate [kg/m^2/s]';
conemlr.XLabel.String = 'Time [s]';
set(gca,'NextPlot','replacechildren') ;

conehrr = axes('Parent',conetab,'Position',[0.25 0.58 0.32 0.35],'Tag','conehrr','LineWidth',1);
conehrr.Title.String = {'Heat Release Rate','Ignition is assumed to occur when virtual HRR exceeds 21 kW/m^2'};
conehrr.YLabel.String ='Heat Release Rate [kW/m^2]';
conehrr.XLabel.String = 'Time [s]';
set(gca,'NextPlot','replacechildren') ;

conehctable = uitable(conetab,'Data',(0),'ColumnEditable',true,'Position', ...
    [5 405 170 220],'ColumnWidth', {70},'ColumnName',{'dHc [kJ/g]'},'units','normalized');

conett = axes('Parent',conetab,'Position',[0.25 0.12 0.32 0.35],'Tag','conett','LineWidth',1);
conett.Title.String = 'In-depth Temperatures';
conett.YLabel.String = 'Temperature [K]';
conett.XLabel.String = 'Time [s]';
set(gca,'NextPlot','replacechildren') ;


conedepth = axes('Parent',conetab,'Position',[0.63 0.12 0.32 0.35],'Tag','conett','LineWidth',1);
conedepth.Title.String = 'Thickness';
conedepth.YLabel.String = 'Thickness [m]';
conedepth.XLabel.String = 'Time [s]';
set(gca, 'NextPlot', 'replacechildren');

%cone position table
names={'Model TC1'; 'Model TC2';'Model TC3'; 'Model TC4';'Model TC5'};
%checkbox1={false;false;false;false};
interplens = {0;0;0;0;0};
yourdata =[interplens];
conepostable = uitable(conetab,'Data',yourdata,'ColumnEditable',true,'Position', ...
    [5 120 250 190],'ColumnWidth',{65},'ColumnName',{'Position from Bottom [m]'},'units','normalized');
conepostable.RowName = names;


output = {}; %output to file as string
mcctab.Parent = []; %Use to "hide" a tab
conetab.Parent = [];
file_strings = ''; %String to process file input
expdata = []; %Current loaded experimental data
f1.Visible = 'on'; %Set figure visible when all graphics done

%initialize global variables
compnames = "";
HRR = 0;
HRR_tot = 0;
Position = 0;
intHRR =0;
AMassFl = 0 ;
MassFl = 0;
Area = 0;
Thickness = 0;
MassFl_tot = 0;
Mass = 0 ;
intHRR_tot = 0;
HeatFl_int = 0;
HeatFl = 0;
Temp = 0;
Time = 0;
cnt = 0;
expactive = 0;
tkactive = 0;
tc1plot = 0;
tc2plot = 0;
tc3plot = 0;
tc4plot = 0;
tc5plot = 0;
Index_top = 0;
Index_bottom = 0;
Num_position = 0;
Temp_top = 0;
Temp_bottom = 0;

    function browseexp_CB(~,~)
        file = sprintf('Select experimental input excel file');
        [fn,pn] = uigetfile('*.xlsx*',file); %Excel input by default
        if (fn ==0) %Do nothing if can't load
            return;
        else %Experimental input successfully loaded
            expactive = 1;
        end
        [~,~, raw] = xlsread(fullfile(pn,fn)); %Read excel input
        expdata = cell2mat(raw(2:end,:));
        expchk.String = strcat(fn," was loaded");
    end

    function browsetk_CB(~,~)
        file = sprintf('Select input file');
        [fn,pn] = uigetfile('*.txt',file); %.txt default format
        if (fn ==0)
            return;
        else
            tkactive = 1;
        end
        file = fopen(fullfile(pn,fn));
        file_strings=textscan(file,'%s','delimiter','\t');
        fclose(file);
        tkchk.String = strcat(fn," was loaded");
        readtk(); %Read and process input tk
    end

    cursor=-1; %this is needed to make it a switch
    function datacursor(~,~)
      datacursormode toggle  
      cursor=-cursor;  
      if cursor >0
        datacursorchk.String = strcat("Data cursor now on");
      else
          datacursorchk.String = strcat("Data cursor now off");
      end
       
        
    end
    function popup_CB(~, ~)
        %Clear all graphs and vars
        v = popup.Value;
        cla(heatflow);
        tkactive = 0;
        expactive = 0;
        cla(massloss);
        cla(totmass);
        cla(intheatflow);
        cla(hrr);
        cla(hrrint);
        cla(conehrr);
        cla(conemlr);
        cla(conett);
        cla(conedepth);
        file_strings = '';
        expchk.String = '';
        output = {};
        runchk.String = '';
        savechk.String = '';
        tkchk.String = '';
        expdata = [];
        
        delete(conehctable)
        delete(hctable);
        delete(conepostable);
        tgatab.Parent = [];
        conetab.Parent = [];
        mcctab.Parent = [];
        
        switch v
            case 1
                legend(totmass,'hide');
                legend(massloss,'hide');
                legend(heatflow,'hide');
                legend(intheatflow,'hide');
                set(browsein1,'ToolTip','Time | Temp | Normal Mass | MLR | Heat Flow | Integral Heat Flow');
                tgatab.Parent = tabgp;
            case 2
                legend(hrr,'hide');
                legend(hrrint,'hide');
                set(browsein1,'ToolTip','Time | Temp | HRR | Total HRR');
                mcctab.Parent = tabgp;
                hctable = uitable(mcctab,'Data',(0),'ColumnEditable',true,'Position', ...
                    [5 5 200 320],'ColumnWidth', {100},'ColumnName',{'dHc [kJ/g]'},'units','normalized');
            case 3
                set(browsein1,'ToolTip','Time | MLR | HRR | Temptop | Tempbottom | TCs');
                conetab.Parent = tabgp;
                conehctable = uitable(conetab,'Data',(0),'ColumnEditable',true,'Position', ...
                    [5 415 170 220],'ColumnWidth', {70},'ColumnName',{'dHc [kJ/g]'},'units','normalized');
                conepostable = uitable(conetab,'Data',yourdata,'ColumnEditable',true,'Position', ...
                    [5 120 250 190],'ColumnWidth', {146},'ColumnName',{'Position from bottom [m]'},'units','normalized');
                conepostable.RowName = names;
            case 4
                set(browsein1,'ToolTip','');
        end
    end

    function readtk()
%         tkactive = 0;
%         cla(heatflow);
%         cla(massloss);
%         cla(totmass);
%         cla(intheatflow);
%         cla(hrr);
%         cla(hrrint);
%         cla(conehrr);
%         cla(conemlr);
%         cla(conett);
%         cla(conedepth);
%         expchk.String = '';
%         output = {};
%         savechk.String = '';
%         tkchk.String = '';
        
        if strcmp(file_strings{1}{1}(1:9),'ThermaKin')&&strcmp(file_strings{1}{7},'Object type:  1D')
            numcomp=sscanf(file_strings{1}{4},'%*s %*s %*s %u');
            AMassFl = 0;
            MassFl = 0;
            MassFl_tot =0;
            Mass = 0;
            HeatFl = 0;
            HeatFl_int = 0;
            HeatRt = zeros(size(Time,1), 1);
            HRR = 0;
            Thickness = 0;
            Position = 0;
            HRR_tot = 0;
            intHRR = 0;
            intHRR_tot = 0;
            Temp = 0;
            Time = 0;
            Mass = 0;
            Area = 0;
            file_strings_ix = 0;
            time_ix = 0;
            Index_top = 0;
            Index_bottom = 0;
            Num_position = 0;
            Temp_top = 0;
            Temp_bottom = 0;
            
            if (popup.Value == 3)
                while file_strings_ix<size(file_strings{1},1)
                    file_strings_ix=file_strings_ix+1;
                    if strcmp(file_strings{1}{file_strings_ix},'Time [s] =')
                        file_strings_ix=file_strings_ix+1;
                        time_ix=time_ix+1;
                        Time(time_ix,1)=str2double(file_strings{1}{file_strings_ix});
                        Area = str2double(file_strings{1}{file_strings_ix+6+numcomp});
                        file_strings_ix=file_strings_ix+numcomp+7;
                        HeatFl(time_ix,1)=str2double(file_strings{1}{file_strings_ix});
                        file_strings_ix=file_strings_ix+1;
                        for c=1:1:numcomp
                            file_strings_ix=file_strings_ix+1;
                            MassFl(time_ix,c)=str2double(file_strings{1}{file_strings_ix});
                        end
                        file_strings_ix=file_strings_ix+3;
                        HeatFl(time_ix,1)=HeatFl(time_ix,1)+str2double(file_strings{1}{file_strings_ix});
                        file_strings_ix=file_strings_ix+1;
                        for c=1:1:numcomp
                            file_strings_ix=file_strings_ix+1;
                            MassFl(time_ix,c)=MassFl(time_ix,c)+str2double(file_strings{1}{file_strings_ix});
                        end
                        
                        while ~strcmp(file_strings{1}{file_strings_ix},'FROM TOP [m]')
                            file_strings_ix=file_strings_ix+1;
                        end
                        file_strings_ix=file_strings_ix+numcomp+3;  
                        Index_top(time_ix,1) = file_strings_ix;%find top position index
                        file_strings_ix=file_strings_ix+1;
                        Temp_top(time_ix,1) = str2double(file_strings{1}{file_strings_ix});
                        while ~strcmp(file_strings{1}{file_strings_ix},'Total thickness [m] =')
                            file_strings_ix = file_strings_ix+1;
                        end
                        file_strings_ix=file_strings_ix-numcomp-3;
                        Index_bottom(time_ix,1) = file_strings_ix;%find bottom position index
                        file_strings_ix=file_strings_ix+1;
                        Temp_bottom(time_ix,1) = str2double(file_strings{1}{file_strings_ix});
                        Num_position(time_ix,1) = (Index_bottom(time_ix,1)-Index_top(time_ix,1))/(3+numcomp)+1;%total rows of position
                        file_strings_ix = Index_top(time_ix,1);
                        for pvb = 1:Num_position(time_ix,1)
                            Position(pvb,time_ix) = str2double(file_strings{1}{file_strings_ix});
                            file_strings_ix = file_strings_ix+1;
                            Temp(pvb, time_ix)=str2double(file_strings{1}{file_strings_ix});
                            file_strings_ix = file_strings_ix+numcomp+2;
                        end
                        
                        while ~strcmp(file_strings{1}{file_strings_ix},'Total thickness [m] =')
                            file_strings_ix = file_strings_ix+1;
                        end
                        file_strings_ix = file_strings_ix+1;
                        Thickness(time_ix,1) = str2double(file_strings{1}{file_strings_ix}); %total thickness
                        file_strings_ix=file_strings_ix+2;
                        Mass(time_ix,1)=str2double(file_strings{1}{file_strings_ix}); %total mass
                        
                    end
                end
            else
                while file_strings_ix<size(file_strings{1},1)
                    file_strings_ix=file_strings_ix+1;
                    if strcmp(file_strings{1}{file_strings_ix},'Time [s] =')
                        file_strings_ix=file_strings_ix+1;
                        time_ix=time_ix+1;
                        Time(time_ix,1)=str2double(file_strings{1}{file_strings_ix});
                        file_strings_ix=file_strings_ix+numcomp+7;
                        HeatFl(time_ix,1)=str2double(file_strings{1}{file_strings_ix});
                        file_strings_ix=file_strings_ix+1;
                        for c=1:1:numcomp
                            file_strings_ix=file_strings_ix+1;
                            MassFl(time_ix,c)=str2double(file_strings{1}{file_strings_ix});
                        end
                        file_strings_ix=file_strings_ix+3;
                        HeatFl(time_ix,1)=HeatFl(time_ix,1)+str2double(file_strings{1}{file_strings_ix});
                        file_strings_ix=file_strings_ix+1;
                        for c=1:1:numcomp
                            file_strings_ix=file_strings_ix+1;
                            MassFl(time_ix,c)=MassFl(time_ix,c)+str2double(file_strings{1}{file_strings_ix});
                        end
                        file_strings_ix=file_strings_ix+numcomp+5;
                        Temp(time_ix,1)=str2double(file_strings{1}{file_strings_ix});
                        file_strings_ix=file_strings_ix+1;
                        while ~strcmp(file_strings{1}{file_strings_ix},'Total mass [kg/m^2] =')
                            file_strings_ix=file_strings_ix+1;
                        end
                        file_strings_ix=file_strings_ix+1;
                        Mass(time_ix,1)=str2double(file_strings{1}{file_strings_ix}); %total mass
                    end
                end
            end
            
            % Get component names as string
            compnames = ""; %string arr
            cnt = 1; %number of nonzero components
            AMassFl  = []; %The nonzero masses that will be plotted
            for iii=1:numcomp %checks each number of components
                if(any(MassFl(:,iii))) %if there is a nonzero element, true
                    AMassFl = horzcat(AMassFl, MassFl(:,iii)); %horizontally concatenate the nonzero masses
                    compnames(cnt) = file_strings{1}{24+iii-1}; %takes in the component name that is nonzero
                    cnt = cnt+1;
                end                                                              
            end
        end
        
        if (popup.Value == 2 ) %Reset table and input comp names/rows
            hctable.Data = zeros(cnt-1,1);
            for c = 1:cnt-1
                compnames(c) = char(compnames(c));
            end
            hctable.RowName = compnames;
        end
        
        if(popup.Value ==3) %reset Cone hc table and input stuff
            tc1plot = 0;
            tc2plot = 0;
            tc3plot = 0;
            tc4plot = 0;
            tc5plot = 0;
            conehctable.Data = zeros(cnt-1,1);
            for c = 1:cnt-1
                compnames(c) = char(compnames(c));
            end
            conehctable.RowName = compnames;
            
            %             dt = Thickness(1,1);
            
            %             interval = Thickness(1,1)/6;
            
            
            %             interprange = [interval, interval*2, interval*3, interval*4, interval*5];
            %             interparr =  zeros(size(Time,1), 5); %matrix that stores index as time and the 5 positions
            %             interprange = Position(1,1):interval:Position(29, 1); %interpolation range based off 1st time
            
            %             for ttime = 1:size(Time,1)
            %                 %positions 1-5 are from top to bottom.
            %                 Position(isnan(Position)) = 0;
            %                 interparr(ttime, :) = interp1(Position(:,ttime), Temp(:,ttime), interprange);
            %             end
            %             interparr(isnan(interparr)) = 0; %getting nans for simulation 1
            
            %             conepostable.Data(1,2) = num2cell(Position(1,1));
            %             conepostable.Data(2,2) = num2cell(Position(29,1));
            %             conepostable.Data(3:7,2) = num2cell(interprange);
        end
        
        %First assignment of plotting/output variables
        Mass_init=Mass(1,1);
        for i=1:size(Time,1)
            Mass(i,1)=Mass(i,1)/Mass_init;
            MassFl_tot(i,1)=0;
            for c=1:cnt-1
                if (popup.Value ==3)
                    AMassFl(i,c) = AMassFl(i,c)/Area;
                else
                    AMassFl(i,c)=AMassFl(i,c)/Mass_init;
                end
                MassFl_tot(i,1)=MassFl_tot(i,1)+AMassFl(i,c);
            end
            if(popup.Value ~=3)
                HeatFl(i,1)=HeatFl(i,1)/(Mass_init*1000.0);
                if i>1
                    HeatRt(i,1)=(Temp(i,1)-Temp(i-1,1))/(Time(i,1)-Time(i-1,1));
                end
            end
        end
        if (popup.Value ~=3)
            HeatFl_int = cumtrapz(Time, HeatFl); % Time
        end
        tkactive = 1;
    end

    function plot_CB(~,~)
        if (tkactive ==0 && expactive ==0)
            % no files loaded notification
            return;
        end
        
        opval = popup.Value;
%         compnames = strrep(compnames,'_','\_');
        intHRR =0;
        intHRR_tot = 0;
        
        %Second assignment of variables for HRR output since dependent on
        %table inputs
        if (opval == 2 && tkactive == 1)
            cnst = hctable.Data * 1000; % Since Hc has the unit of kJ/g. and HRR is W/g
            Mass_init=Mass(1,1);
            for i=1:size(Time,1)
                HRR(i,1)= 0;
                HRR_tot(i,1)=0;
                for c=1:cnt-1
                    AMassFl(i,c)=AMassFl(i,c)/Mass_init;
                    HRR(i,c) = AMassFl(i,c) * cnst(c,1);
                    HRR_tot(i,1)=HRR_tot(i,1)+HRR(i,c);
                end
            end
            intHRR = cumtrapz(Time, HRR);
            intHRR_tot = cumtrapz(Time, HRR_tot)/1000;%since HRR_tot has the unit of W/g and IntHRR has the unit of kJ/g
        end
        
        if (opval == 3 && tkactive == 1)
            cnst = conehctable.Data*1000;
            for i=1:size(Time,1)
                HRR(i,1)= 0;
                HRR_tot(i,1)=0;
                for c=1:cnt-1
                    AMassFl(i,c) = AMassFl(i,c)/Area;
                    HRR(i,c) = AMassFl(i,c) * cnst(c,1);
                    HRR_tot(i,1)=HRR_tot(i,1)+HRR(i,c);
                end
                if HRR_tot(i,1)< 21 %set an ignition criteria less than 21kW/m2, no ignition
                   HRR(i,:)=0;
                   HRR_tot(i,1)=0;
                end
            end
            
            tc1 = conepostable.Data(1,1);
            tc2 = conepostable.Data(2,1);
            tc3 = conepostable.Data(3,1);
            tc4 = conepostable.Data(4,1);
            tc5 = conepostable.Data(5,1);
            
            Position(isnan(Position)) = 0;
            for i=1:size (Time,1)
                if (Thickness(i,1)-cell2mat(tc1) > Position(Num_position(i,1),i))||((Thickness(i,1)-cell2mat(tc1)) == Position(Num_position(i,1),i))
                    tc1plot(i,1) = Temp(Num_position(i,1),i);% Num_position represents the total output number of positions
                elseif  (Thickness(i,1) - cell2mat(tc1) < Position(1,i))||((Thickness(i,1)-cell2mat(tc1)) == Position(1,i))
                    tc1plot(i,1) = Temp(1,i);
                else
                    [~,index]=unique(Position(:,i));
                    tc1plot(i,1) = interp1 (Position(index,i), ...
                        Temp(index,i), Thickness(i,1) - cell2mat(tc1));
                end
                if (Thickness(i,1) - cell2mat(tc2) > Position(Num_position(i,1),i))||(Thickness(i,1) - cell2mat(tc2) == Position(Num_position(i,1),i))
                    tc2plot(i,1) = Temp(Num_position(i,1),i);
                elseif (Thickness(i,1) - cell2mat(tc2) < Position(1,i))||(Thickness(i,1) - cell2mat(tc2) == Position(1,i))
                    tc2plot(i,1) = Temp(1,i);
                else
                    [~,index]=unique(Position(:,i));
                    tc2plot(i,1) = interp1 (Position(index,i), ...
                        Temp(index,i), Thickness(i,1) - cell2mat(tc2));
                end
                if (Thickness(i,1) - cell2mat(tc3) > Position(Num_position(i,1),i))||(Thickness(i,1) - cell2mat(tc3) == Position(Num_position(i,1),i))
                    tc3plot(i,1) = Temp(Num_position(i,1),i);
                elseif (Thickness(i,1) - cell2mat(tc3) < Position(1,i))||(Thickness(i,1)-cell2mat(tc3) == Position(1,i))
                    tc3plot(i,1) = Temp(1,i);
                else
                    [~,index]=unique(Position(:,i));
                    tc3plot(i,1) = interp1 (Position(index,i), ...
                        Temp(index,i), Thickness(i,1) - cell2mat(tc3));
                end
                if (Thickness(i,1) - cell2mat(tc4) > Position(Num_position(i,1),i))||(Thickness(i,1) - cell2mat(tc4) == Position(Num_position(i,1),i))
                    tc4plot(i,1) = Temp(Num_position(i,1),i);
                elseif (Thickness(i,1) - cell2mat(tc4) < Position(1,i))||(Thickness(i,1)-cell2mat(tc4) == Position(1,i))
                    tc4plot(i,1) = Temp(1,i);
                else
                    [~,index]=unique(Position(:,i));
                    tc4plot(i,1) = interp1 (Position(index,i), ...
                        Temp(index,i), Thickness(i,1) - cell2mat(tc4));
                end
                if (Thickness(i,1) - cell2mat(tc5) > Position(Num_position(i,1),i))||(Thickness(i,1) - cell2mat(tc5) == Position(Num_position(i,1),i))
                    tc5plot(i,1) = Temp(Num_position(i,1),i);
                elseif (Thickness(i,1) - cell2mat(tc5) < Position(1,i))||(Thickness(i,1)-cell2mat(tc5) == Position(1,i))
                    tc5plot(i,1) = Temp(1,i);
                else
                    [~,index]=unique(Position(:,i));
                    tc5plot(i,1) = interp1 (Position(index,i), ...
                        Temp(index,i), Thickness(i,1) - cell2mat(tc5));
                end
                
            end
        end
        switch opval
            case 1
                
                %reset the graphs so doesn't repeat
                cla(heatflow);
                cla(massloss);
                cla(totmass);
                cla(intheatflow);
                
                %If either tk input or experimental input is loaded plot
                %either or both if both are loaded.
                if(tkactive)
                    for compplot = 1:cnt-1
                        if cnt ==2
                            plot(massloss,Temp,MassFl_tot,'-','Color','Red','DisplayName','Simulation Total','LineWidth',2.5);
                            hold(massloss,'on');
%                            plot(massloss, Temp,AMassFl(:,compplot), '--','DisplayName',strrep(compnames(compplot),'_','\_'));
                            break;
                        end
                        plot(massloss, Temp,AMassFl(:,compplot), '--','DisplayName', strrep(compnames(compplot),'_','\_'));
                        hold(massloss,'on');
                    end
                    if (cnt > 2)
                        plot(massloss,Temp,MassFl_tot,'-','Color','Red','DisplayName','Simulation Total','LineWidth',2.5);
                    end
                    plot(heatflow,Temp,HeatFl,'-','Color','Red','DisplayName','Simulation','LineWidth',2.5);
                    hold (heatflow,'on');
                    plot(intheatflow,Temp,HeatFl_int,'-','Color','Red','DisplayName','Simulation','LineWidth',2.5);
                    hold(intheatflow,'on');
                    plot(totmass,Temp,Mass,'-','Color','Red','DisplayName','Simulation','LineWidth',2.5);
                    hold(totmass,'on');
                end
                
                if (expactive)
                    plot(massloss,expdata(:,2), expdata(:,4),'--','Color','black', 'DisplayName','Experimental','LineWidth',2.5);
                    plot(heatflow,expdata(:,2),expdata(:,5),'--','Color','black','DisplayName','Experimental','LineWidth',2.5);
                    plot(intheatflow,expdata(:,2),expdata(:,6),'--','Color','black','DisplayName','Experimental','LineWidth',2.5);
                    plot(totmass,expdata(:,2), expdata(:,3),'--','Color','black','DisplayName','Experimental','LineWidth',2.5);
                end
                legend(massloss, 'show','Location','northwest');
                legend(totmass,'show','Location','northeast');
                legend(heatflow,'show','Location','northwest');
                legend(intheatflow,'show','Location','northwest');
                
            case 2
                cla(hrr);
                cla(hrrint);
                
                if (tkactive)
                    
                    for compplot = 1:cnt-1
                        if cnt == 2
                            %plot(hrr, Temp, HRR(:,compplot), '--','DisplayName',strrep(compnames(compplot),'_','\_'),'LineWidth',2.5);
                            plot(hrr, Temp, HRR_tot, '-','Color','Red','DisplayName','Simulation Total','LineWidth',2.5);
                            hold(hrr,'on');
                            break;
                        end
                        plot(hrr, Temp, HRR(:,compplot), '--','DisplayName',strrep(compnames(compplot),'_','\_'));
                        hold(hrr,'on');
                    end
                    
                    if cnt>2
                        plot(hrr, Temp, HRR_tot, '-','Color','Red','DisplayName','Simulation Total','LineWidth',2.5);
                    end
                    plot(hrrint,Temp,intHRR_tot, '-','Color','Red','DisplayName', 'Simulation Total','LineWidth',2.5);
                    hold(hrrint,'on');
                end
                
                if (expactive)
                    plot(hrr,expdata(:,2), expdata(:,3),'--','Color','black','DisplayName','Experimental','LineWidth',2.5);
                    plot(hrrint,expdata(:,2), expdata(:,4)/1000,'--','Color','black','DisplayName','Experimental','LineWidth',2.5);
                end
                
                legend(hrr,'show','Location','northwest');
                legend(hrrint,'show','Location','southeast');
                                
            case 3
                
                cla(conemlr);
                cla(conehrr);
                cla(conett);
                cla(conedepth);
                
                if (tkactive)
                    hold(conemlr,'on');
                    hold(conehrr,'on');
                    hold(conett,'on');
                    hold(conedepth,'on');
                    for compplot = 1:cnt-1
                        if cnt == 2
                            %plot(conemlr,Time,AMassFl(:,compplot), '--','DisplayName', strrep(compnames(compplot),'_','\_'),'LineWidth',2.5);
                            plot(conemlr,Time,MassFl_tot,'-','Color','Red','DisplayName','Simulation Total','LineWidth',2.5);
                            hold(conemlr,'on');
                            break;
                        end
                        plot(conemlr, Time,AMassFl(:,compplot), '--','DisplayName', strrep(compnames(compplot),'_','\_'));
                        hold(conemlr,'on');
                    end
                    if (cnt > 2)
                        plot(conemlr,Time,MassFl_tot,'-','Color','Red','DisplayName','Simulation Total','LineWidth',2.5);
                        hold(conemlr,'on');
                    end
                    
                    for compplot = 1:cnt-1
                        if cnt == 2
                            %plot(conehrr, Time, HRR(:,compplot), '--','DisplayName',strrep(compnames(compplot),'_','\_'),'LineWidth',2.5);
                            plot(conehrr, Time, HRR_tot, '-','Color','Red','DisplayName','Simulation Total','LineWidth',2.5);
                            hold(conehrr,'on');
                            break;
                        end
                        plot(conehrr, Time, HRR(:,compplot), '--','DisplayName',strrep(compnames(compplot),'_','\_'));
                        hold(conehrr,'on');
                    end
                    if cnt>2
                        plot(conehrr, Time, HRR_tot, '-','Color','Red','DisplayName','Simulation Total','LineWidth',2.5);
                        hold(conehrr,'on');
                    end
                    plot(conedepth, Time, Thickness, '-','Color','Red','DisplayName', 'Simulation','LineWidth',2.5);
                    hold(conedepth,'on');
                    plot(conett,Time, tc1plot(:,1) ,'-', 'Color','red','DisplayName','Model TC1','LineWidth', 2.5);
                    hold(conett,'on');
                    plot(conett,Time, tc2plot(:,1), '-', 'Color','black','DisplayName','Model TC2','LineWidth', 2.5);
                    hold(conett,'on');
                    plot(conett,Time, tc3plot(:,1), '-', 'Color','blue','DisplayName','Model TC3','LineWidth', 2.5);
                    hold(conett,'on');
                    plot(conett,Time, tc4plot(:,1), '-', 'Color','green','DisplayName','Model TC4','LineWidth', 2.5);
                    hold(conett,'on');
                    plot(conett,Time, tc5plot(:,1), '-', 'Color','magenta','DisplayName','Model TC5','LineWidth', 2.5);
                    hold(conett,'on');
                end
                    
                    
                    %The depth temp plot
                    
%                     plot(conett,Time, Temp_top, '-', 'Color','red','DisplayName','Sim Top','LineWidth', 2.5);
%                     plot(conett,Time, Temp_bottom, '-', 'Color','black','DisplayName','Sim Bot','LineWidth', 2.5);
                    
                
                if (expactive)
                    hold(conett,'on');
                    plot(conemlr, expdata(:,1), expdata(:,2),'--','Color','black','DisplayName','Experimental','LineWidth',2.5);
                    plot(conehrr, expdata(:,1), expdata(:,3),'--','Color','black','DisplayName','Experimental','LineWidth',2.5);
%                     if (cell2mat(conepostable.Data(1)))
                        plot(conett, expdata(:,1), expdata(:,4), '--','Color','red','DisplayName','Exp TC1','LineWidth',1.5);
%                     end
%                     if (cell2mat(conepostable.Data(2)))
                        plot(conett, expdata(:,1), expdata(:,5), '--','Color','black','DisplayName','Exp TC2','LineWidth',1.5);
%                     end
%                     if (cell2mat(conepostable.Data(3)))
                        plot(conett, expdata(:,1), expdata(:,6), '--','Color','blue','DisplayName', 'Exp TC3','LineWidth',1.5);
%                     end
%                     if (cell2mat(conepostable.Data(4)))
                        plot(conett, expdata(:,1), expdata(:,7), '--','Color','green','DisplayName', 'Exp TC4', 'LineWidth',1.5);
%                     end
%                     if (cell2mat(conepostable.Data(5)))
                        plot(conett, expdata(:,1), expdata(:,8), '--','Color','magenta','DisplayName', 'Exp TC5','LineWidth',1.5);
%                     end
%                     if (cell2mat(conepostable.Data(6)))
                        plot(conedepth, expdata(:,1), expdata(:,9), '--','Color','black','DisplayName', 'Experimental','LineWidth',2.5);
%                     end
%                     if (cell2mat(conepostable.Data(7)))
                      
                end
                
                legend(conemlr,'show','Location','northwest');
                legend(conehrr,'show','Location','northwest');
                legend(conett,'show','Location','northwest');
                legend(conedepth,'show','Location','northeast');
            case 4
                
                
        end
       % runchk.String = "Plots updated";
    end

    function save(~,~)
        
        output = {};
        savefile = sprintf('Select output file');
        [fn,~] = uiputfile('*.xlsx',savefile); %Excel output
        if (fn ==0)
            return;
        end
        
        %Overwrite existing excel output by deleting original file and
        %writing output to a new file with same name
        if (exist(fn, 'file'))
            delete(fn);
        end
        opval = popup.Value;
        
        switch opval
            case 1
                output{1,1} = 'Time [s]';
                output{1,2} = 'Temperature [K]';
                output{1,3} = 'Mass/Initial Mass';
                output{1,4} = 'Normalized Total MLR [1/s]';
                output{1,5} = 'Heat Flow [W/g]';
                output{1,6} = 'Heat Flow Integral [J/g]';
                
                for c = 1:cnt-1
                    output{1,6+c} = char(strcat(compnames(c), ' MLR [1/s]'));
                end
                
                for i=1:size(Time,1) %excel only outputs strings properly
                    output{1+i,1} = num2str(Time(i,1), '%e');
                    output{1+i,2} = num2str(Temp(i,1), '%e');
                    output{1+i,3} = num2str(Mass(i,1), '%e');
                    output{1+i,4} = num2str(MassFl_tot(i,1), '%e');
                    output{1+i,5} = num2str(HeatFl(i,1), '%e');
                    output{1+i,6} = num2str(HeatFl_int(i,1), '%e');
                    
                    for c=1:cnt-1
                        output{1+i,6+c} = num2str(AMassFl(i,c), '%e');
                    end
                end
                
            case 2
                cnst = hctable.Data;
                output{1,1} = 'Time [s]';
                output{1,2} = 'Temperature [K]';
                output{1,3} = 'Normalized Total HRR [W/g]';
                output{1,4} = 'Normalized Total HRR Integral [kJ/g]';
                
                for c = 1:cnt-1
                    output{1,4+c} = char(strcat(compnames(c), ' HRR [W/g]'));
                end
                
                for c = 1:cnt-1
                    output{1,3+cnt+c} = char(strcat(compnames(c), ' dHc [kJ/g]'));
                    output{2,3+cnt+c} = cnst(c,1);
                end
                
                for i=1:size(Time,1)
                    output{1+i,1} = num2str(Time(i,1), '%e');
                    output{1+i,2} = num2str(Temp(i,1), '%e');
                    output{1+i,3} = num2str(HRR_tot(i,1), '%e');
                    output{1+i,4} = num2str(intHRR_tot(i,1), '%e');
                    for c=1:cnt-1
                        output{1+i, 4+c} = num2str(HRR(i,c),'%e');
                    end
                    
                end
                
            case 3
                cnst = conehctable.Data;
                output{1,1} = 'Time [s]';
                output{1,2} = 'MLR [kg/m2/s]';
                output{1,3} = 'HRR [kW/m^2]';
                output{1,4} = 'TC1 [K]';
                output{1,5} = 'TC2 [K]';
                output{1,6} = 'TC3 [K]';
                output{1,7} = 'TC4 [K]';
                output{1,8} = 'TC5 [K]';
                output{1,9} = 'Thickness [m]';
                
                for c = 1:cnt-1
                    output{1, 9+c} = [char(compnames(c)), ' HRR [kW/m2]'];
                end
                for c = 1:cnt-1
                    output{1, 8+cnt+c} = [char(compnames(c)), ' dHc [kJ/g]'];
                    output{2, 8+cnt+c} = cnst(c,1);
                end
                
                for i=1:size(Time,1)
                    output{1+i,1} = num2str(Time(i,1), '%e');
                    output{1+i,2} = num2str(MassFl_tot(i,1), '%e');
                    output{1+i,3} = num2str(HRR_tot(i,1), '%e');
                    output{1+i,4} = tc1plot(i,1);
                    output{1+i,5} = tc2plot(i,1);
                    output{1+i,6} = tc3plot(i,1);
                    output{1+i,7} = tc4plot(i,1);
                    output{1+i,8} = tc5plot(i,1);
                    output{1+i,9} = Thickness(i,1);
                    for c=1:cnt-1
                        output{1+i, 9+c} = num2str(HRR(i,c),'%e');
                    end

                end
                
        end
        
        xlswrite(fn,output);
        savechk.String = strcat("Output successfully written to ", fn);
    end

end

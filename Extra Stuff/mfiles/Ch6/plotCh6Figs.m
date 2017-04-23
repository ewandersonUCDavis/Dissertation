close all
%FASTOut  = loadFASTOutData('primary_SFunc.out_FAST_DR_Verification')
FASTOut  = loadFASTOutData('primary.out')
SOWFAOut = loadFASTOutData('primary0.out_SOWFA_DR_Verification')

xAxisLimits = [50 250];
LEGEND = {'FAST' 'SOWFA'}

%%Figure 1: rotor speed
figure('position', [0.25 2.5 1000 400])
%plot(FASTOut.data(:,1),FASTOut.data(:,6),'r',SOWFAOut.data(:,1),SOWFAOut.data(:,3),'b')
plot(FASTOut.data(:,1)-200,FASTOut.data(:,6),'r',SOWFAOut.data(:,1),SOWFAOut.data(:,3),'b')

legend(LEGEND)
ylabel('Rotor Speed (RPM )');
xlabel('Time (s) ');
ylim([9 13])
xlim(xAxisLimits)
% set the text sizes and plot size
set(findall(gcf,'type','axes'),'fontsize',15)
set(findall(gcf,'type','text'),'fontSize',20) 

%%Figure 2: blade pitch
figure('position', [0.25 2.5 1000 400])
%plot(FASTOut.data(:,1),FASTOut.data(:,6),'r',SOWFAOut.data(:,1),SOWFAOut.data(:,3),'b')
plot(FASTOut.data(:,1)-200,FASTOut.data(:,24),'r',SOWFAOut.data(:,1),SOWFAOut.data(:,22),'b')
legend(LEGEND)
s = sprintf('Blade Pitch (%c)', char(176));
ylabel(s);
xlabel('Time (s) ');
ylim([11 16])
xlim(xAxisLimits)
% set the text sizes and plot size
set(findall(gcf,'type','axes'),'fontsize',15)
set(findall(gcf,'type','text'),'fontSize',20) 

%%Figure 3: Tower Moment
figure('position', [0.25 2.5 1000 400])
%plot(FASTOut.data(:,1),FASTOut.data(:,40)./1000,'r',SOWFAOut.data(:,1),SOWFAOut.data(:,37)./1000,'b')
plot(FASTOut.data(:,1)-200,FASTOut.data(:,39)./1000,'r',SOWFAOut.data(:,1),SOWFAOut.data(:,37)./1000,'b')
legend(LEGEND)
ylabel('Tower Base Bending Moment (MNm)');
xlabel('Time (s) ');
%ylim([9 13])
xlim(xAxisLimits)
% set the text sizes and plot size
set(findall(gcf,'type','axes'),'fontsize',15)
set(findall(gcf,'type','text'),'fontSize',20) 

%%Figure 3: Tower Moment
figure('position', [0.25 2.5 1000 400])
%FASTBRM = hypot(FASTOut.data(:,31),FASTOut.data(:,32))./1000;
FASTBRM = hypot(FASTOut.data(:,30),FASTOut.data(:,31))./1000;
SOWFABRM = hypot(SOWFAOut.data(:,28),SOWFAOut.data(:,29))./1000;
%plot(FASTOut.data(:,1),FASTBRM,'r',SOWFAOut.data(:,1),SOWFABRM,'b')
plot(FASTOut.data(:,1)-200,FASTBRM,'r',SOWFAOut.data(:,1),SOWFABRM,'b')
legend(LEGEND)
ylabel('Blade Root Bending Moment (MNm)');
xlabel('Time (s) ');
%ylim([9 13])
xlim(xAxisLimits)
% set the text sizes and plot size
set(findall(gcf,'type','axes'),'fontsize',15)
set(findall(gcf,'type','text'),'fontSize',20) 
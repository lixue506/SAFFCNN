%Example2DrawPhase,绘制Example2中的驱动响应曲线，不带有控制器的情况下
clear,clc

D1=load('Example2Drive.mat');
D2=load('Example2Response.mat');
h=0.005;
plot(D1.x1result,D1.x2result,'k-','LineWidth',2);
xlabel('x_1(t)')
ylabel('x_2(t)')
% hold on
% plot(D2.x1result,D2.x2result,'r--','LineWidth',1);
% xlabel('x_{1}(t)(x_{2}(t))');
% ylabel('y_{1}(t)(y_{2}(t))')
%legend('the drive system phase diagram','the response system phase diagram')
figure
plot(h*(1:size(D1.x1result,2)),D1.x1result,'r--','LineWidth',2); 
hold on
plot(h*(1:size(D2.x1result,2)),D2.x1result,'k-','LineWidth',2);
xlim([0,14]);
xlabel('t');
ylabel('x_{1}(t) & y_{1}(t)')
legend('x_{1}(t)','y_{1}(t)');
figure
plot(h*(1:size(D1.x2result,2)),D1.x2result,'r--','LineWidth',2); 
hold on
plot(h*(1:size(D2.x2result,2)),D2.x2result,'k-','LineWidth',2);
xlim([0,14]);
xlabel('t');
ylabel('x_{2}(t) & y_{2}(t)')
legend('x_{2}(t)','y_{2}(t)');
hold off

figure
plot(h*(1:size(D1.x2result,2)),D1.x1result-D2.x1result,'r--','LineWidth',2); 
hold on
plot(h*(1:size(D2.x2result,2)),D1.x2result-D2.x2result,'k-','LineWidth',2);
xlim([0,14]);
xlabel('t')
ylabel('e_i(t),i=1,2')
legend('e_{1}(t)','e_{2}(t)');


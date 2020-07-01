%Example2DrawPhase
clear,clc
%D=load('Example2NoControl.mat');  %Ã»ÓÐ¿ØÖÆ
D=load('Example2Control2.mat');

h=0.005;
plot(D.x1result,D.x2result,'b-','LineWidth',2);
hold on
plot(D.x3result,D.x4result,'r--','LineWidth',2);
xlabel('x_{1}(t)(x_{2}(t))');
ylabel('y_{1}(t)(y_{2}(t))')
legend('the drive system phase diagram','the response system phase diagram')
figure
plot(h*(1:size(D.x1result,2)),D.x1result,'r--','LineWidth',2); 
hold on
plot(h*(1:size(D.x3result,2)),D.x3result,'k-','LineWidth',2);
xlim([0,14]);
xlabel('t');
ylabel('x_{1}(t) & y_{1}(t)')
legend('x_{1}(t)','y_{1}(t)');
figure
plot(h*(1:size(D.x2result,2)),D.x2result,'r--','LineWidth',2); 
hold on
plot(h*(1:size(D.x4result,2)),D.x4result,'k-','LineWidth',2);
xlim([0,14]);
xlabel('t');
ylabel('x_{2}(t) & y_{2}(t)')
legend('x_{2}(t)','y_{2}(t)');
hold off

figure
plot(h*(1:size(D.x2result,2)),D.x3result-D.x1result,'r--','LineWidth',2); 
hold on
plot(h*(1:size(D.x4result,2)),D.x4result-D.x2result,'k-','LineWidth',2);
xlim([0,14]);
xlabel('t')
ylabel('e_i(t),i=1,2')
legend('e_{1}(t)','e_{2}(t)');


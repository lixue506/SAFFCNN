
%Exmaple 3的同步仿真程序（该仿真用于论文中的例3！！！）
clear,clc

tspan=[0,20];

X0=[0.2;0.6;-0.6;-0.2];
sol=ddesd(@Paper0951,@delay095,X0,tspan);

plot(sol.y(1,:),sol.y(2,:),'r-');
hold on
plot(sol.y(3,:),sol.y(4,:),'b--');
legend('the drive system', 'the response system')

figure
subplot(2,1,1)
plot(sol.x,sol.y(3,:)-sol.y(1,:),'k-','LineWidth',2);
xlabel('t')
ylabel('e_1(t)')
subplot(2,1,2)
plot(sol.x,sol.y(4,:)-sol.y(2,:),'k-','LineWidth',2);
xlabel('t')
ylabel('e_2(t)')

figure
subplot(2,1,1)
plot(sol.x,sol.y(1,:),'r-',sol.x,sol.y(3,:),'b--','LineWidth',2)
xlabel('t');
ylabel('x_1(t),y_1(t)')
legend('x_1(t)','y_1(t)')
subplot(2,1,2)
plot(sol.x,sol.y(2,:),'r-',sol.x,sol.y(4,:),'b--','LineWidth',2)
xlabel('t');
ylabel('x_2(t),y_2(t)')
legend('x_2(t)','y_2(t)')

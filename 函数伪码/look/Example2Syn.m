%%MFFCNN的驱动响应同步程序，对应论文中的Example2
% 结果正确！

%当适定函数中不含有sin(t)的时候能够达到稳定的状态，在使用第一组数据的情况下
%%
clear,clc
close all

h=0.005; % 步长   
N=3000; %从0开始的时间点的个数，0之前还有k个，-k,-k+1....-1 0,总的个数是N+1+k个，此值不能取的太小
q1=0.95; %分数阶，该值对程序的影响较大
tau=0.4; %时延
Ndelay=tau/h;  % 需要计算的延时项的个数

d1=4;%自反馈连接权值
d2=2;
I1=0;%外部输入
I2=0;
%控制增益
k1=4;
k2=2;

alpha=3;  %alpha=0时，响应系统能够达到稳定。

%记录预测器的近似值x1^p(t)的值
x1(Ndelay+N+1)=[0]; %表示响应系统中的x1
x2(Ndelay+N+1)=[0];  %表示响应系统中的x1
x3(Ndelay+N+1)=[0]; %表示驱动系统中的y1
x4(Ndelay+N+1)=[0]; %表示驱动系统中的y2

%记录普通项x(t)近似值 y
x11(Ndelay+N+1)=[0];
x22(Ndelay+N+1)=[0];
x33(Ndelay+N+1)=[0];
x44(Ndelay+N+1)=[0];
   
for i=1:Ndelay
   x11(i)=1.5;  %延时项赋初始值 x(t)=phi(t)
   x22(i)=-0.8;
   x33(i)=-1.5;  %延时项赋初始值 x(t)=phi(t)
   x44(i)=0.8;
end

x01=x11(Ndelay); %t0时刻的值，对应算法中的g(0)
x02=x22(Ndelay);
x03=x33(Ndelay); %t0时刻的值，对应算法中的g(0)
x04=x44(Ndelay);

%% 第一组 该组数值能够保证稳定且同步,但是不希望每个都稳定，只要同步即可。
% a011=0.18;a012=-0.15;a021=-0.8;a022=0.45;
% b011=-0.15;b012=0.05; b021=-0.2;b022=-0.25;
%%
%%第二组数据
% a011=2.2;a012=-2.0;a021=-0.6;a022=2.5;
% b011=-4.0;b012=-2.5; b021=-1.5;b022=-3.5;

%此组数据能够产生一个极限环
a011=2.2;a012=-2.0;a021=-0.6;a022=2.5;
b011=-4.0;b012=-2.5; b021=-1.5;b022=-3.8;


% a011=1.2;a012=-0.15;a021=1.6;a022=4.5;
% b011=-0.95;b012=-2.5; b021=-0.8;b022=-2.5;

%使用该组数据能达到投影同步，但是系统处于稳定状态。（Data Test1）
% a011=0.9;a012=-2.8;a021=-0.5;a022=2.5;
% b011=-3.2;b012=-3.0; b021=-1.6;b022=-3.6;
%%

%对应算法公式中的n=0,t1时刻的情况，预测值yp,根据论文中的方程（10）和公式（11）
F1=-d1*x01+a011*Fun(x01)+a012*Fun(x02)+b011*Fun(x11(1))+b012*Fun(x22(1));
x1(Ndelay+1)=x01+h^q1*F1/(q1*gamma(q1)); %初值t1时刻预测器yp的值(用近似值做预测值)

F2=-d2*x02+a021*Fun(x01)+a022*Fun(x02)+b021*Fun(x11(1))+b022*Fun(x22(1));
x2(Ndelay+1)=x02+h^q1*F2/(q1*gamma(q1)); %初值t1时刻预测器yp的值(用近似值做预测值)

F3=-d1*x03+a011*Fun(x03)+a012*Fun(x04)+b011*Fun(x33(1))+b012*Fun(x44(1))-k1*(x03-x01);
x3(Ndelay+1)=x03+h^q1*F3/(q1*gamma(q1));

F4=-d2*x04+a021*Fun(x03)+a022*Fun(x04)+b021*Fun(x33(1))+b022*Fun(x44(1))-k2*(x04-x02);
x4(Ndelay+1)=x04+h^q1*F4/(q1*gamma(q1));


%t1时刻的y的近似值，
x11(Ndelay+1)=x01+h^q1*(d1*x11(Ndelay+1)+a011*Fun(x11(Ndelay+1))+a012*Fun(x22(Ndelay+1))+b011*Fun(x11(2))+b012*Fun(x22(2))+...
    q1*F1)/gamma(q1+2);

x22(Ndelay+1)=x02+h^q1*(-d2*x22(Ndelay+1)+a021*Fun(x11(Ndelay+1))+a022*Fun(x22(Ndelay+1))+b021*Fun(x11(2))+b022*Fun(x22(2))+...
    q1*F2)/gamma(q1+2);

x33(Ndelay+1)=x03+h^q1*((-d1*x33(Ndelay+1)+a011*Fun(x33(Ndelay+1))+a012*Fun(x44(Ndelay+1))+b011*Fun(x33(2))+b012*Fun(x44(2)))-k1*(x33(Ndelay+1)-alpha*x11(Ndelay+1))+...
    q1*F3)/gamma(q1+2);

x44(Ndelay+1)=x04+h^q1*((-d2*x44(Ndelay+1)+a021*Fun(x33(Ndelay+1))+a022*Fun(x44(Ndelay+1))+b021*Fun(x33(2))+b022*Fun(x44(2)))-k2*(x44(Ndelay+1)-alpha*x22(Ndelay+1))+...
    q1*F4)/gamma(q1+2);

for n=1:N  
    %%第一组，该组数值能够保证稳定且同步。
%     if abs(x11(Ndelay+n))<=1
%         a11=1.2;
%         a12=-0.15;
%         b11=-0.95;
%         b12=0.05;
%     else
%         a11=2.8;
%         a12=1.2;
%         b11=-1.5;
%         b12=0.15;
%     end
%     if abs(x22(Ndelay+n))<=1
%         a21=1.6;
%         a22=4.5;
%         b21=-0.8;
%         b22=-2.5;
%     else
%         a21=2.8;
%         a22=3.2;
%         b21=-0.1;
%         b22=-1.2;
%     end  
    %%
    %%第二组数据,不能同步
%     if abs(x11(Ndelay+n))<=1
%         a11=2.2;
%         a12=-2.0;
%         b11=-4.0;
%         b12=-2.5;
%     else
%         a11=2.0;
%         a12=-3.0;
%         b11=-3.5;
%         b12=-2.8;
%     end
%     if abs(x22(Ndelay+n))<=1
%         a21=-0.6;
%         a22=2.5;
%         b21=-1.5;
%         b22=-3.5;
%     else
%         a21=-0.5;
%         a22=2.8;
%         b21=-1.8;
%         b22=-3.8;
%     end 


    a11=2.2*(abs(x11(Ndelay+n))<=1)+2.0*(abs(x11(Ndelay+n))>1);
    a12=-2.0*(abs(x11(Ndelay+n))<=1)-3.0*(abs(x11(Ndelay+n))>1);
    a21=-0.6*(abs(x22(Ndelay+n))<=1)-0.5*(abs(x22(Ndelay+n))>1);
    a22=2.5*(abs(x22(Ndelay+n))<=1)+2.8*(abs(x22(Ndelay+n))>1);
    b11=-4.0*(abs(x11(Ndelay+n))<=1)-3.5*(abs(x11(Ndelay+n))>1);
    b12=-2.5*(abs(x11(Ndelay+n))<=1)-2.8*(abs(x11(Ndelay+n))>1);
    b21=-1.5*(abs(x22(Ndelay+n))<=1)-1.8*(abs(x22(Ndelay+n))>1);  % 第一项的正负关系影响极大
    b22=-3.5*(abs(x22(Ndelay+n))<=1)-3.8*(abs(x22(Ndelay+n))>1);


%使用该组数据能达到投影同步，但是系统处于稳定状态。（Data Test1）
%     if abs(x11(Ndelay+n))<=1
%         a11=2.1;
%         a12=-2.2;
%         b11=-3.8;
%         b12=-2.4;
%     else
%         a11=1.9;
%         a12=-2.8;
%         b11=-3.2;
%         b12=-3.0;
%     end
%     if abs(x22(Ndelay+n))<=1
%         a21=-0.5;
%         a22=2.5;
%         b21=-1.6;
%         b22=-3.6;
%     else
%         a21=-0.4;
%         a22=2.9;
%         b21=-2.0;
%         b22=-4.0;
%     end  
%%
    F11=-d1*x01+a11*Fun(x01)+a12*Fun(x02)+b11*Fun(x11(1))+b12*Fun(x22(1));   
    M1=(n^(q1+1)-(n-q1)*(n+1)^q1)*F11;%近似值y的求和项，j=0的情况
    
    F22=-d2*x02+a21*Fun(x01)+a22*Fun(x02)+b21*Fun(x11(1))+b22*Fun(x22(1));
    M2=(n^(q1+1)-(n-q1)*(n+1)^q1)*F22;
    
    F33=-d1*x03+a11*Fun(x03)+a12*Fun(x04)+b11*Fun(x33(1))+b12*Fun(x44(1))-k1*(x03-alpha*x01);
    M3=(n^(q1+1)-(n-q1)*(n+1)^q1)*F33;
    
    F44=-d2*x04+a21*Fun(x03)+a22*Fun(x04)+b21*Fun(x33(1))+b22*Fun(x44(1))-k2*(x04-alpha*x02);
    M4=(n^(q1+1)-(n-q1)*(n+1)^q1)*F44;

    
    N1=((n+1)^q1-n^q1)*F11; %预测器yp中的求和项,不包含前面的h^q1/h项
    N2=((n+1)^q1-n^q1)*F22;
    N3=((n+1)^q1-n^q1)*F33;
    N4=((n+1)^q1-n^q1)*F44;

    for j=1:n    %计算卷积项，两个求和部分，j从1开始
        F111=-d1*x11(Ndelay+j)+a11*Fun(x11(Ndelay+j))+a12*Fun(x22(Ndelay+j))+b11*Fun(x11(j))+b12*Fun(x22(j));
        M1=M1+((n-j+2)^(q1+1)+(n-j)^(q1+1)-2*(n-j+1)^(q1+1))*F111;
        
        F222=-d2*x22(Ndelay+j)+a21*Fun(x11(Ndelay+j))+a22*Fun(x22(Ndelay+j))+b21*Fun(x11(j))+b22*Fun(x22(j));
        M2=M2+((n-j+2)^(q1+1)+(n-j)^(q1+1)-2*(n-j+1)^(q1+1))*F222;
        
        F333=-d1*x33(Ndelay+j)+a11*Fun(x33(Ndelay+j))+a12*Fun(x44(Ndelay+j))+b11*Fun(x33(j))+b12*Fun(x44(j))-k1*(x33(Ndelay+j)-alpha*x11(Ndelay+j));
        M3=M3+((n-j+2)^(q1+1)+(n-j)^(q1+1)-2*(n-j+1)^(q1+1))*F333;
        
        F444=-d2*x44(Ndelay+j)+a21*Fun(x33(Ndelay+j))+a22*Fun(x44(Ndelay+j))+b21*Fun(x33(j))+b22*Fun(x44(j))-k2*(x44(Ndelay+j)-alpha*x22(Ndelay+j));
        M4=M4+((n-j+2)^(q1+1)+(n-j)^(q1+1)-2*(n-j+1)^(q1+1))*F444;
        
        N1=N1+((n-j+1)^q1-(n-j)^q1)*F111;
        N2=N2+((n-j+1)^q1-(n-j)^q1)*F222;
        N3=N3+((n-j+1)^q1-(n-j)^q1)*F333;
        N4=N4+((n-j+1)^q1-(n-j)^q1)*F444;
  
    end
    x1(Ndelay+n+1)=x01+h^q1*N1/(gamma(q1)*q1);  %预测器的结果，j=n+1的情况
    x2(Ndelay+n+1)=x02+h^q1*N2/(gamma(q1)*q1);
    x3(Ndelay+n+1)=x03+h^q1*N3/(gamma(q1)*q1);
    x4(Ndelay+n+1)=x04+h^q1*N4/(gamma(q1)*q1);

    
    x11(Ndelay+n+1)=x01+h^q1*(-d1*x1(Ndelay+n+1)+a11*Fun(x1(Ndelay+n+1))+a12*Fun(x2(Ndelay+n+1))+b11*Fun(x11(j+1))+b12*Fun(x22(j+1))+M1)/gamma(q1+2);  %每一个近似值y的结果
    x22(Ndelay+n+1)=x02+h^q1*(-d2*x2(Ndelay+n+1)+a21*Fun(x1(Ndelay+n+1))+a22*Fun(x2(Ndelay+n+1))+b21*Fun(x11(j+1))+b22*Fun(x22(j+1))+M2)/gamma(q1+2);
    x33(Ndelay+n+1)=x03+h^q1*(-d1*x3(Ndelay+n+1)+a11*Fun(x3(Ndelay+n+1))+a12*Fun(x4(Ndelay+n+1))+b11*Fun(x33(j+1))+b12*Fun(x44(j+1))-k1*(x3(Ndelay+n+1)-alpha*x1(Ndelay+n+1))+M3)/gamma(q1+2);
    x44(Ndelay+n+1)=x04+h^q1*(-d2*x4(Ndelay+n+1)+a21*Fun(x3(Ndelay+n+1))+a22*Fun(x4(Ndelay+n+1))+b21*Fun(x33(j+1))+b22*Fun(x44(j+1))-k2*(x4(Ndelay+n+1)-alpha*x2(Ndelay+n+1))+M4)/gamma(q1+2);
  
end

x1result(N-Ndelay+1)=[0]; %记录x(t)
x2result(N-Ndelay+1)=[0];
x3result(N-Ndelay+1)=[0];
x4result(N-Ndelay+1)=[0];

y1result(N-Ndelay+1)=[0]; %记录x1(t-tau),x1时延项
y2result(N-Ndelay+1)=[0]; %记录x2(t-tau),x2时延项
y3result(N-Ndelay+1)=[0]; %记录1(t-tau),x1时延项
y4result(N-Ndelay+1)=[0]; %记录x2(t-tau),x2时延项

for n=2*Ndelay+1:N+Ndelay+1   %计算N-Ndelay对应的结果
   x1result(n-2*Ndelay)=x11(n); %计算的xresult是从1到N-Ndelay+1
   x2result(n-2*Ndelay)=x22(n);
   x3result(n-2*Ndelay)=x33(n); %计算的xresult是从1到N-Ndelay+1
   x4result(n-2*Ndelay)=x44(n);
   
   y1result(n-2*Ndelay)=x11(n-Ndelay);%计算的yresult是从Ndelay+1到N+1总共也是N-delay+1个，
   y2result(n-2*Ndelay)=x22(n-Ndelay);
   y3result(n-2*Ndelay)=x33(n-Ndelay);
   y4result(n-2*Ndelay)=x44(n-Ndelay);
end

plot(x1result,x2result,'b-','LineWidth',1);
hold on
plot(x3result,x4result,'r--','LineWidth',1);
xlabel('x_{1}(t)(x_{2}(t))');
ylabel('y_{1}(t)(y_{2}(t))')
legend('the drive system phase diagram','the response system phase diagram')
figure
subplot(2,1,1)
plot(h*(1:size(x1result,2)),x1result,'r--','LineWidth',1); 
hold on
plot(h*(1:size(x3result,2)),x3result,'k-','LineWidth',1);
% xlim([0,14]);
xlabel('t');
ylabel('x_{1}(t) & y_{1}(t)')
legend('x_{1}(t)','y_{1}(t)');
hold off
subplot(2,1,2)
plot(h*(1:size(x2result,2)),x2result,'r--','LineWidth',1); 
hold on
plot(h*(1:size(x4result,2)),x4result,'k-','LineWidth',1);
% xlim([0,14]);
xlabel('t');
ylabel('x_{2}(t) & y_{2}(t)')
legend('x_{2}(t)','y_{2}(t)');
hold off
%%
% 
%   for x = 1:10
%       disp(x)
%   end
% 

% figure
% subplot(2,1,1)
% plot(h*(1:size(x1result,2)),x3result-x1result,'k--','LineWidth',1);
% xlabel('t');
% ylabel('e_{1}(t)');
% subplot(2,1,2)
% plot(h*(1:size(x2result,2)),x4result-x2result,'r--','LineWidth',1)
% xlabel('t');
% ylabel('e_{2}(t)');
% hold off

% figure
% plot(h*(1:size(x2result,2)),x4result-x2result,'k-','LineWidth',2)
% xlabel('t');
% ylabel('e_{2}(t)');
function dxdt=Paper0951(t,x,Z)
dxdt=zeros(4,1);
c1=2;
c2=2;
I1=0;I2=0;

%该组参数可以使用，产生稳定的极限环
if abs(x(1))<1
   a11=-1.8;
   a12=2.8;
else
    a11=-1.5;
    a12=2.5;
end

if abs(x(2))<1
    a21=1;
    a22=-1;
else
    a21=0.8;
    a22=-0.8;
end

if abs(Z(1,1))<1
   b11=-3.5;
   b12=-1.2;
else
    b11=-3.2;
    b12=-1.5;
end
if abs(Z(2,2))<1
    b21=-0.1;
    b22=-1.6;
else
    b21=-0.2;
    b22=-1.2;
end

dxdt(1)=-c1*x(1)+a11*Fun(x(1))+a12*Fun(x(2))+b11*Fun(Z(1,1))+b12*Fun(Z(2,2))+I1;
dxdt(2)=-c2*x(2)+a21*Fun(x(1))+a22*Fun(x(2))+b21*Fun(Z(1,1))+b22*Fun(Z(2,2))+I2;

%控制器参数设置
k1=2;k2=4;
nu1=1;nu2=1;
mu1=6;mu2=6;
vr1=1;vr2=1;
er=1.2; %指数

%%%%%%控制器设置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

e1=x(3)-x(1);
e2=x(4)-x(2);
% % % % 
% u1=-k1*e1-nu1*sign(e1)-mu1*sign(e1)*abs(Z(4,1)-Z(1,1))-vr1*sign(e1)*abs(e1)^er;
% u2=-k2*e2-nu2*sign(e2)-mu2*sign(e2)*abs(Z(5,1)-Z(2,1))-vr2*sign(e2)*abs(e2)^er;
% u3=-k3*e3-nu3*sign(e3)-mu3*sign(e3)*abs(Z(6,1)-Z(3,1))-vr3*sign(e3)*abs(e3)^er;
u1=-k1*e1-tanh(e1)*(nu1+mu1*abs(Z(3,3)-Z(1,1))+vr1*abs(e1)^er);  % 为什么只用反馈控制就OK了呢？
u2=-k2*e2-tanh(e2)*(nu2+mu2*abs(Z(4,4)-Z(2,2))+vr2*abs(e2)^er);   %使用tanh(t)很快就达到了同步

% u1=0;
% u2=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dxdt(3)=-c1*x(3)+a11*Fun(x(3))+a12*Fun(x(4))+b11*Fun(Z(3,3))+b12*Fun(Z(4,4))+I1+u1;
dxdt(4)=-c2*x(4)+a21*Fun(x(3))+a22*Fun(x(4))+b21*Fun(Z(3,3))+b22*Fun(Z(4,4))+I2+u2;




end


%%%% 激活函数 %%%%
function y=Fun(x)
y=0.5*abs((abs(x+1)-abs(x-1)))-1;
end
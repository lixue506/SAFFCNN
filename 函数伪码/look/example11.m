global h;h = 0.005; %% 步长 %%
global N;N = 1000;
global alpha;alpha = 0.7;
global dta;dta = 0.5;  %% [0,1) %%
%%初始值%%
global YPx;YPx = [0.35,0.42,0.36,0.72];
global Yx;Yx = [0.28,0.61,0.22,0.19]; 
global Vx;Vx = [0.85,0.45,0.76,0.47];


global YPx1;YPx1 = [];
global YPx2;YPx2 = [];
global YPy1;YPy1 = [];
global YPy2;YPy2 = [];

global Yx1;Yx1 = [];
global Yx2;Yx2 = [];
global Yy1;Yy1 = [];
global Yy2;Yy2 = [];

global Vx1;Vx1 = [];
global Vx2;Vx2 = [];
global Vy1;Vy1 = [];
global Vy2;Vy2 = [];

%% 容器,数组初始化 %%
for i=1:N+10
    YPx1(i) = YPx(1);
    YPx2(i) = YPx(2);
    YPy1(i) = YPx(3);
    YPy2(i) = YPx(4);

    Yx1(i) = Yx(1);
    Yx2(i) = Yx(2);
    Yy1(i) = Yx(3);
    Yy2(i) = Yx(4);

    Vx1(i) = Vx(1);
    Vx2(i) = Vx(2);
    Vy1(i) = Vx(3);
    Vy2(i) = Vx(4);
end
%% 参数设置 %%
global d;d = [0.24, 1];
global I;I = [0,0];

global a;a = [0.756, -0.11, -0.76, 2.2];     

global b;b = [-0.29,-0.1,-0.18,4.823]; 

c = [0.1, 0, 0.1, 0];   
t = [0.1, 0, 0, 0.1]; 
s = [0.1, 0, 0, 0.1];
v = [1, 1];  

global afa;afa = [0.02, 0, 0, 0.25]; 

global bta;bta = [0.02, 0.01, 0, 0.39]; 

global cv;cv = reshape(c,2,2).*v;

global tv1;tv1 = min(t(1) * v(1), t(2) * v(2));
global tv2;tv2 = min(t(3) * v(1), t(4) * v(2));

global sv1;sv1 = max(s(1) * v(1), s(2) * v(2));
global sv2;sv2 = max(s(3) * v(1), s(4) * v(2));

%控制器参数设置%
global yta; yta = [0.5, 0.004];
global ybu; ybu = [0.006,0.003]; 

%% 调用-绘图 %%
for i=1:N
    yp(i);
    vn(i);
    y(i);
end
%% 绘制关于x1,x2的相图 %%
plot(Yx1,Yx2);
xlabel('x1')
ylabel('x2')
hold on;

%% 绘制误差图 %%
err1 = [];
err2 = [];
tn = [];
for i=1:N
    err1(i) = Yy1(i) - Yx1(i);
    err2(i) = Yy2(i) - Yx2(i);
    tn(i) = i * h;
end
% plot(tn, err1, 'r-')
% hold on;
% plot(tn, err2, 'b--')

%% 绘制x1\y1: x2\y2 %%
%%
% figure
% subplot(2,1,1)
% plot(tn, Yx1(1:N),'r-');
% hold on
% plot(tn,Yy1(1:N),'b--');
% xlabel('t');
% ylabel('x1,y1');
% legend('the drive system', 'the response system');

% subplot(2,1,2);
% plot(tn, Yx2(1:N),'r-');
% hold on
% plot(tn,Yy2(1:N),'b--');
% xlabel('t');
% ylabel('x2,y2');
% legend('the drive system', 'the response system')


%% 开普诺函数计算 %%
function tmp = f(t, yp, v)
    global h;
    global d;        
    global I;        
    global a;     
    global b;     
    global afa;    
    global bta;   
    global yta;      
    global ybu;     
    global cv;
    global tv1;
    global tv2;
    global sv1;
    global sv2;
    global Yx1;
    global Yx2;
    global Yy1;
    global Yy2;
    t = fix(t/h)-1;
   
    x11=-d(1)*yp(1)+a(1)*Fun(yp(1))+a(2)*Fun(yp(2))+cv(1)+tv1+sv1+b(1)*Fun(v(1))+b(2)*Fun(v(2))+min(afa(1)*Fun(v(1)),afa(2)*Fun(v(2)))+max(bta(1)*Fun(v(1)),bta(2)*Fun(v(2)))+I(1);
    x22=-d(2)*yp(2)+a(3)*Fun(yp(1))+a(4)*Fun(yp(2))+cv(2)+tv2+sv2+b(3)*Fun(v(1))+b(4)*Fun(v(2))+min(afa(3)*Fun(v(1)),afa(4)*Fun(v(2)))+max(bta(3)*Fun(v(1)),bta(3)*Fun(v(2)))+I(2);

    e1=Yy1(t)-Yx1(t);
    e2=Yy2(t)-Yx2(t);

    u1 = -ybu(1) * power(e1,3) - yta(1)*power(e1,2);
    u1 = u1 * exp(2*ybu(1)*t);
    u2 = -ybu(2) * power(e2,3) - yta(2)*power(e2,2);
    u2 = u2 * exp(2* ybu(2) *t);
    
    y11=-d(1)*yp(3)+a(1)*Fun(yp(3))+a(2)*Fun(yp(4))+cv(1)+tv1+sv1+b(1)*Fun(v(3))+b(2)*Fun(v(4))+min(afa(1)*Fun(v(3)),afa(2)*Fun(v(4)))+max(bta(1)*Fun(v(3)),bta(2)*Fun(v(4)))+I(1)+u1;
    y22=-d(2)*yp(4)+a(3)*Fun(yp(3))+a(4)*Fun(yp(4))+cv(2)+tv2+sv2+b(3)*Fun(v(3))+b(4)*Fun(v(4))+min(afa(3)*Fun(v(3)),afa(4)*Fun(v(4)))+max(bta(3)*Fun(v(3)),bta(4)*Fun(v(4)))+I(2)+u2;
    
    tmp = [x11,x22,y11,y22];
end
%% x1,x2,y1,y2的函数 %%
function x1 = xs1(t)
    x1 = asin(t);
end

function x2 = xs2(t)
    x2 = t*t;
end

function y1 = ys1(t)
    y1 = t;
end

function y2 = ys2(t)
    y2 = sin(t);
end

%%% 激活函数 %%%
function tx=Fun(x)
    tx=0.5*abs((abs(x+1)-abs(x-1)));
end

%%% 时延函数 %%%
function d=delay(t)
    d = 1.38 * abs(sin(t));
end

function bjnn = bjn(j,n)
 global h;
 global alpha;
    bjnn = power(h,alpha)*(power(n-j+1,alpha) - power(n-j,alpha))/alpha;
end

function ajnn = ajn(j,n)
 global h;
 global alpha;
    ajnn = power(h, alpha) / (alpha * (alpha + 1));  
    if j == 0
        t = power(n,alpha+1) - ((n - alpha) * power(n+1, alpha));
        ajnn =  t * ajnn;
    elseif j == n+1
        ajnn = ajnn;
    else
        t = power(n-j+2, alpha + 1) + power(n-j, alpha + 1) - 2 * power(n-j+1, alpha + 1);
        ajnn =  ajnn * t;
    end
end

%% 模拟y_n+1 %%
function ypp = yp(n)
    global h;
    global alpha;
    global Yx;
    global Yx1;
    global Yx2;
    global Yy1;
    global Yy2;
    global YPx1;
    global YPx2;
    global YPy1;
    global YPy2;
    tn = (n+1)*h;
    m = fix(delay(tn)/h);
    x11 = 0;
    x22 = 0;
    y11 = 0;
    y22 = 0; 
    
    KK = 1;
    for k = 0:m-1
        if k>0
            KK = KK*k;
        end
        x11 = x11 + xs1(k*h)*power(tn,k)/KK;
        x22 = x22 + xs2(k*h)*power(tn,k)/KK;
        y11 = y11 + ys1(k*h)*power(tn,k)/KK;
        y22 = y22 + ys2(k*h)*power(tn,k)/KK;
    end
 
    tx1 = bjn(0,n) * Yx(1);
    tx2 = bjn(0,n) * Yx(2);
    ty1 = bjn(0,n) * Yx(3);
    ty2 = bjn(0,n) * Yx(4);
    
    for j=1:n
        tx1 = tx1 + bjn(j,n)*Yx1(j);
        tx2 = tx2 + bjn(j,n)*Yx2(j);
        ty1 = ty1 + bjn(j,n)*Yy1(j);
        ty2 = ty2 + bjn(j,n)*Yy2(j);
    end
    
    x11 = x11 + tx1/gamma(alpha);
    x22 = x22 + tx2/gamma(alpha);
    y11 = y11 + ty1/gamma(alpha);
    y22 = y22 + ty2/gamma(alpha);
  
    YPx1(n+1) = x11;
    YPx2(n+1) = x22;
    YPy1(n+1) = y11;
    YPy2(n+1) = y22;
    
    ypp = [x11,x22,y11,y22];
    
end

%% 模拟xi(t-tau(t)) %%
function vnn = vn(n)
    global h;
    global Vx1;
    global Vx2;
    global Vy1;
    global Vy2;
    global Yx1;
    global Yx2;
    global Yy1;
    global Yy2;
    global YPx1;
    global YPx2;
    global YPy1;
    global YPy2;
    global Yx;
    
    global dta;
   tn = (n+1)*h;
   m = fix(delay(tn)/h); 
   if n-m+2 <= 0
       tx1 = Yx(1);
       tx2 = Yx(2);
       ty1 = Yx(3);
       ty2 = Yx(4);
   else
       tx1 = Yx1(n-m+2);
       tx2 = Yx2(n-m+2);
       ty1 = Yy1(n-m+2);
       ty2 = Yy2(n-m+2);
   end
   
   if n-m+1 <= 0
       tx11 = Yx(1);
       tx22 = Yx(2);
       ty11 = Yx(3);
       ty22 = Yx(4);
   else
       tx11 = Yx1(n-m+1);
       tx22 = Yx2(n-m+1);
       ty11 = Yy1(n-m+1);
       ty22 = Yy2(n-m+1);
   end
   
   if m > 1
        x11 = dta*tx1+(1-dta)*tx11; 
        x22 = dta*tx2+(1-dta)*tx22; 
        y11 = dta*ty1+(1-dta)*ty11; 
        y22 = dta*ty2+(1-dta)*ty22; 
   else
        x11 = dta*YPx1(n+1)+(1-dta)*Yx1(n); 
        x22 = dta*YPx2(n+1)+(1-dta)*Yx2(n); 
        y11 = dta*YPy1(n+1)+(1-dta)*Yy1(n); 
        y22 = dta*YPy2(n+1)+(1-dta)*Yy2(n); 
   end
   
    Vx1(n+1) = x11;
    Vx2(n+1) = x22;
    Vy1(n+1) = y11;
    Vy2(n+1) = y22;
   
      vnn = [x11,x22,y11,y22]; 
end
%% 模拟计算分数阶xi,yi %%
function yn = y(n)
    h;
    global alpha;
    global Yx;
    global Yx1;
    global Yx2;
    global Yy1;
    global Yy2;
    global Vx1;
    global Vx2;
    global Vy1;
    global Vy2;
    tn = (n+1)*h;
    m = fix(delay(tn)/h); 
   
    x11 = 0;
    x22 = 0;
    y11 = 0;
    y22 = 0; 
    
    KK = 1;
    for k = 0:m-1
        if k>0
            KK = KK*k;
        end
        x11 = x11 + xs1(k*h)*power(tn,k)/KK;
        x22 = x22 + xs2(k*h)*power(tn,k)/KK;
        y11 = y11 + ys1(k*h)*power(tn,k)/KK;
        y22 = y22 + ys2(k*h)*power(tn,k)/KK;
    end
    
    tx1 = ajn(0,n) * Yx(1);
    tx2 = ajn(0,n) * Yx(2);
    ty1 = ajn(0,n) * Yx(3);
    ty2 = ajn(0,n) * Yx(4);
    
    for j=1:n
        tx1 = tx1 + ajn(j,n)*Yx1(j);
        tx2 = tx2 + ajn(j,n)*Yx2(j);
        ty1 = ty1 + ajn(j,n)*Yy1(j);
        ty2 = ty2 + ajn(j,n)*Yy2(j);
    end
    
    ypp = [Yx1(n+1),Yx2(n+1),Yy1(n+1),Yy2(n+1)];
    vnn = [Vx1(n+1),Vx2(n+1),Vy1(n+1),Vy2(n+1)];
   
    tmp = f(tn, ypp, vnn);
    x11 = x11 + tx1/gamma(alpha) + power(h,alpha)*tmp(1)/gamma(alpha+2);
    x22 = x22 + tx2/gamma(alpha) + power(h,alpha)*tmp(2)/gamma(alpha+2);
    y11 = y11 + ty1/gamma(alpha) + power(h,alpha)*tmp(3)/gamma(alpha+2);
    y22 = y22 + ty2/gamma(alpha) + power(h,alpha)*tmp(4)/gamma(alpha+2);
    
    Yx1(n+1) = x11;
    Yx2(n+1) = x22;
    Yy1(n+1) = y11;
    Yy2(n+1) = y11;
    
   yn = [x11,x22,y11,y22];
end





    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
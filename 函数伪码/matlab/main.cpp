#include <iostream>
#include<cmath>
using namespace std;
float ynt[100];
float y[2][10000];

float f(float tn, float yn)//初始函数的导数
{
    return 2*tn-1;
}

float ynp(float tn,float yn, float h)
{
    return yn + h*f(tn,yn);
}

float yn(float t0, float y0, float h,int n)
{
    float tn,ynn;
    for (int i=0;i<=n;i++)
    {
        if (i==0)
        {
            tn = t0;
            ynn = y0;
            y[0][i] = tn;
            y[1][i] = ynn;
        }
        else{
            float yn1 = ynn + h * ( f(tn,ynn) + f(tn+h, ynp(tn,ynn,h)) )/2;
            tn = tn + h;
            ynn = yn1;
            y[0][i] = tn;
            y[1][i] = yn1;
            //cout<<yn1<<endl;
        }
    }
    return y[1][n];
}
float fai_k(float tn)// 初始值函数
{
    return tn*tn-tn;
}

float contest(float x0,float y0,float h,float tall,int n,float xgm)//固定时延
{
    int m = tall/h;
    int tn = x0;
    if (xgm==0)
    {
        yn(x0,y0,h,n);
        for(int i=0;i<=n;i++)
        {
         if (i<=m)
            {
                ynt[i] = fai_k(tn);
            }
         else{
            ynt[i] = y[1][i-m];
         }
         tn = tn + h;
        }
        //cout<<ynt[n]<<endl;
    }
    else{
        ynt[0] = 0; // ¿ÉÐÞ¸Ä
        if(m==1)
        {
            for(int i=1;i<=n;i++)
            {
                //ynt[i] = xgm*ynp(tn,yn,h) + (1-xgm)*y[1][n-m+1];
                tn = tn + h;
            }
        }
        else{
            for(int i=1;i<=n;i++)
            {
                ynt[i] = xgm*y[1][n-m+2] + (1-xgm)*y[1][n-m+1];
            }
        }
    }
    return ynt[n];
}
void F()
{
    int T = 50;
    float h = 0.1;
    int n = T/h;
    float alpha = 0.2;
    float tall = 0.1;
    float t = T;
    float xgm = 0;
    float r1 = 2*pow(t,2-alpha)/tgammaf(3-alpha);
    cout<<r1<<endl;
    float r2 = pow(t,1-alpha)/tgammaf(2-alpha);
    cout<<r2<<endl;
    float r3 = 2*tall*t-tall*tall-tall;
    cout<<r3<<endl;
    cout<<contest(0,0,h,tall,n,xgm)<<endl;
    float r4 = contest(0,0,h,tall,n,xgm);
    cout<<r4<<endl;
    float r = r1 - r2 + r3 - fai_k(t) + r4;
    cout<<r<<endl;
    //cout<<tgammaf(3-alpha)<<endl;
}

float a[10000];
void a(n,h,alpha)  // 直接算出所有，后期调用
{
    float tmp = pow(h,alpha)/(alpha*(alpha+1));
    for (int i=0;i==n+1;i++)
    {
        if (i==0)
        {
            float r = pow(n,alpha+1)-(n-alpha)*pow(n+1,alpha);
            a[i] = tmp*r;
        }
        if (i == n+1)
        {
            a[i] = tmp;
        }
        if(i>=1 && i<=n)
        {
            float r = pow(n-i+2,alpha+1) + pow(n-i,alpha+1) - 2 * pow(n-i+1,alpha+1);
            a[i] = tmp * r;
        }
    }
}
float b[10000];
void b(n,h,alpha) // 直接算出所有，后期调用
{
    float tmp = pow(h,alpha)/alpha;
    for(int i=0;i<=n+1;i++)
    {
        float r = pow(n-i+1,alpha)-pow(n-i,alpha);
        b[i] = tmp*r;
    }
}
float y_save[10000];
float vn_save[10000];
float ynp_save[10000];
float f[10000];
int index = 0；
int ind
float ynp_varying(n,h,alpha,tn)// 时变时延，只计算一个值，迭代调用
{
    float tmp = 0,temp = 0;
    int tk = 1;
    for(int k=0;k<=m-1;k++)
    {
        if(k>1)
            tk = tk*k;
        tmp += fai_(k)*pow(tn+h,k)/tk;
    }
    for(int j=0;j<=n;j++)
    {
        temp += b(n+1,h,alpha)*f_varying();// 待补充
    }
    ynp_save[index++] = tmp + temp/tgammaf(alpha);
    return tmp;
}
float vn_varying(int n, int m, float xgm) // 只返回一个值，迭代调用
{
    if(m==1)
    {
       vn_save[n+1] = xgm*ynp_save[n+1] + (1-xgm)*y_save[n];
    }
    else{
        vn_save[n+1] = xgm*y_save[n-m+2] + (1-xgm)*y_save[n-m+1];
    }
    return vn_save[n+1];
}

float y_varying()// 调用以上函数
{
    yn1
    float tmp = 0,temp = 0;
    int tk = 1;
    for(int k=0;k<=m-1;k++)
    {
        if(k>1)
            tk = tk*k;
        tmp += fai_(k)*pow(tn+h,k)/tk;
    }
    for(int j=0;j<=n;j++)
    {
        temp += a(n+1,h,alpha)*f_varying();// 待补充
    }
    tmp = tmp + temp + pow(h,alpha)*f_varying()/tgammaf(alpha+2);
    y_save[ind++] = tmp;
    return tmp;
    return 0;
}
}
void F_varying()
{

}

int main()
{
    F();
    return 0;
}

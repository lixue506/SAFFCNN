#include <iostream>
#include<cmath>
using namespace std;
/*float ynt[10000];
float y[2][10000];

float fai_k(float tn)// 初始值函数
{
    return tn*tn-tn;
}
float f(float tn, float yn)//初始函数的导数
{
    return 2*tn-1;
}

float ynp(float tn,float yn, float h)
{
    return yn + h*f(tn,yn);
}

float yn(float t0, float y0, float h,int n)// 提前调用，返回所有值
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
            float ynn = ynn + h * ( f(tn,ynn) + f(tn+h, ynp(tn,ynn,h)) )/2;
            tn = tn + h;
            y[0][i] = tn;
            y[1][i] = ynn;
            //cout<<yn1<<endl;
        }
    }
    return y[1][n];
}

float contest(float x0,float y0,float h,float tall,int n,float xgm)//固定时延
{
    int m;
    float tn = x0 + n*h;
    if (xgm==0)
    {
        m = tall/h;
        yn(x0,y0,h,n);
        //for(int i=0;i<=n;i++)
        //{
         if (n<=m)
            {
                ynt[n] = fai_k(tn);
            }
         else{
            ynt[n] = y[1][n-m];
         }
        //}
        //cout<<ynt[n]<<endl;
    }
    else{
        m = ceil(xgm);
        ynt[0] = 0; // ¿ÉÐÞ¸Ä
        if(m==1)
        {
            //for(int i=1;i<=n;i++)
            //{

            ynt[n] = xgm*ynp(tn,y[1][n],h) + (1-xgm)*y[1][n];
                //tn = tn + h;
            //}
        }
        else{
                ynt[n] = xgm*y[1][n-m+2] + (1-xgm)*y[1][n-m+1];
            }
        }
    return ynt[n];
}
void F()
{
    int T = 5;
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
    float r5 = fai_k(t-tall);
    float r = r1 - r2 + r3 - fai_k(t) + r4;
    cout<<"预测值："<<r<<endl;
    float re = r1 - r2 + r3 - fai_k(t) + r5;
    cout<<"实际值： "<<re<<endl;
    cout<<r-re<<endl;
    cout<<(r-re)/re<<endl;
    //cout<<tgammaf(3-alpha)<<endl;
}
*/
float yn_save[10000];//
float vn_save[10000];//矫正预测值
float ynp_save[10000];//预测值
float f_save[10000];// 预测函数值
int index = 0;
int ind = 0;
float fai_k(float tn)// 初始值函数
{
    return tn*tn-tn;
}
float f(float tn, float yn)//初始函数的导数
{
    return 2*tn-1;
}
float ynp_varying(int n,int m, float h,float alpha,float tn)// 时变时延，只计算一个值，迭代调用
{
    float tmp = 0,temp = 0;
    int tk = 1;
    for(int k=0;k<=m-1;k++)
    {
        if(k>1)
            tk = tk*k;
        tmp += fai_k(k)*pow(tn+h,k)/tk;
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
float a[10000];
void A(int n,float h,float alpha)  // 直接算出所有，后期调用
{
    float tmp = pow(h,alpha)/(alpha*(alpha+1));
    for (int i=0;i<=n+1;i++)
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
void B(int n,float h,float alpha) // 直接算出所有，后期调用
{
    float tmp = pow(h,alpha)/alpha;
    for(int i=0;i<=n+1;i++)
    {
        float r = pow(n-i+1,alpha)-pow(n-i,alpha);
        b[i] = tmp*r;
    }
}
float yn(float t0, float y0, float h,int n)// 提前调用，返回所有值
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
            float ynn = ynn + h * ( f(tn,ynn) + f(tn+h, ynp(tn,ynn,h)) )/2;
            tn = tn + h;
            y[0][i] = tn;
            y[1][i] = ynn;
            //cout<<yn1<<endl;
        }
    }
    return y[1][n];
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

void F_varying()
{

}


int main()
{
    F();
    return 0;
}

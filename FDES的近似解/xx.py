'''
2020-05-27
对函数求分数阶导数
'''
from scipy.special import gamma
import matplotlib.pyplot as plt
import numpy as np
import math

class cDt():

    N = 56
    T = 0.25
    h = T/N

    alpha = 0.72
    m = math.ceil(alpha)

    deerta = 0.434

    vn = yn = ynp = yt = [0] * 560
    #yn = [0] * N
    vn[0] = 0.76
    yn[0] = 0.35 

    #sum_fai = 0

    # 与n有关，不受限
    def bjn(self, n, j):
        result = (pow(self.h, self.alpha) / self.alpha) * (pow(n-j+1, self.alpha) - pow(n-j, self.alpha))
        return result
    # 与n有关，不受限
    def ajn(self, n, j):
        result = pow(self.h,self.alpha) / (self.alpha*(self.alpha+1))
        
        if j == 0:
            t = pow(n,self.alpha+1) - pow(n+1,self.alpha)*(n-self.alpha)
            return t * result
        elif j == n+1:
            return result
        else:
            t = pow(n-j+2,self.alpha+1) + pow(n-j,self.alpha+1) - 2 * pow(n-j+1, self.alpha+1)
            return result * t
    # 含f()函数调用
    def Ynp(self, n, e):
        
        Tnk = (n+1) * self.h
        K = 1
        result = 0

        for k in range(self.m):
            if k > 0:
                K = K * k
            if k*self.h <= 0:
                result += self.yn[0] / K
            else:
                result += self.fai( k*self.h, e) * pow(Tnk, k) / K
            print(result)
        t = 0
        for j in range(n+1):
            # 有待补充内容
            tj = j * self.h
            yj = self.yn[j]
            vj = self.vn[j]
            # print('yj',yj)
            # print('vj',vj)
            # print("self.f(x)", self.f(tj, yj, vj, j))
            t += self.bjn(n+1, j) * self.f(tj, yj, vj, j, e)
        
        result += t / gamma(self.alpha)
        # print("  YNP:  ", result)
        self.ynp[n+1] = result

        return result

    def Vn(self, n):

        result = 0

        if self.m == 1:
            result = self.deerta * self.ynp[n+1] - (1 - self.deerta) * self.yn[n]
        else:
            result = self.deerta * self.yn[n-self.m+2] + (1 - self.deerta) * self.yn[n-self.m+1]
        # print("  VN:  ", result)
        self.vn[n+1] = result

        return result

    def Tool_Function(self,t):
        return pow(t,2)

    def fai(self, t, e):
        xx = [math.cos, math.sin]
        print("e       ", e)
        print("t       ", t)
        print("xx[e](t)", xx[e])
        return xx[e]((e+3)*t)

    def Tao(self, t):
        result = 1.38 * abs(math.sin(t))
        return result 

    def Activation(self, x):
        # sigmoid函数
        #result = 1 / (1 + np.exp(-x))
        result = abs(math.cos(x))
        return result

    def f(self, t, y, v, n, i):
        '''
        t ，自变量
        y, 原函数y = f(t)
        v, 时延函数
        '''
        D = [1, 1]
        A = np.array([[2,-0.11],[-5,2.2]])
        B = np.array([[-1.6, -0.1],[-0.18,-2.4]])
        I = np.array([0, 0]).T
        Alpha = np.array([[0.02, 0.58],[0.74, 0.8]])
        Beita = np.array([[0.02, 0.01], [0.96, 0.9]])
        Tt = np.array([[0.1, 0.82],[0.56, 0.1]])
        Ss = np.array([[0.1, 0.7],[0.16, 0.1]])
        Yita = np.array([0.2, 0.4])
        C = np.array([[0.1, 0.02],[0.1, 0.27]])
        V = np.array([1, 1])
        xs = np.array([0.1, 0.4])
        # X = [np.sin, np.cos] 

        result = 0.0
        # x[i]每次修改更换
        result += I[i] - D[i] * self.Activation(t)
        temp = 0
        TV = float("inf") # 交集取最小
        AlphaF = float("inf") # 交集取最小
        SV = float("-inf") # 并集取最大
        BeitaF = float("-inf") # 并集取最大
        for j in range(2):
            temp += A[i][j] * self.Activation(t)
            temp += C[i][j] * V[j]
            temp += B[i][j]* self.Activation(t)
            a = v #self.Activation(self.fai(t-Tao(t)))
            TV = min(TV, Tt[i][j] * V[j])
            AlphaF = min(AlphaF, Alpha[i][j] * a)
            SV = max(SV, Ss[i][j] * V[j])
            BeitaF = max(BeitaF, Beita[i][j] * a)
        # 暂且循环一次
        result += temp + TV + AlphaF + SV + BeitaF
        # print("Result", result)
        return result
    # Aim
    def Yn(self, n, e):
        # 初始化
        self.Ynp(n, e)
        self.Vn(n)

        # print("FDGFDG")
        Tnk = (n+1) * self.h
        K = 1
        result = 0

        for k in range(self.m):
            if k > 0:
                K = K * k
            t = k*self.h
            if k*self.h <= 0:
                result += self.yn[0] / K
            else:
                result += self.fai( k*self.h, e) * pow(Tnk, k) / K

        # 有待补充内容
        tn = (n+1) * self.h
        y = self.ynp[n+1]
        v = self.vn[n+1]

        result += pow(self.h, self.alpha) / gamma(self.alpha+2) * self.f(tn, y, v, n+1, e)

        t = 0
        for j in range(n+1):
            # 有待补充内容
            tj = j * self.h
            yj = self.yn[j]
            vj = self.vn[j]

            t += self.ajn(n, j) * self.f(tj, yj, vj, j, e)
        
        result += t / gamma(self.alpha)
        self.yn[n+1] = result

    def Dt_yt(self,i):
        '''
        t ，自变量
        y, 原函数y = f(t)
        v, 时延函数
        '''
        D = [1, 1]
        A = np.array([[2,-0.11],[-5,2.2]])
        B = np.array([[-1.6, -0.1],[-0.18,-2.4]])
        I = np.array([0, 0]).T
        Alpha = np.array([[0.02, 0.58],[0.74, 0.8]])
        Beita = np.array([[0.02, 0.01], [0.96, 0.9]])
        Tt = np.array([[0.1, 0.82],[0.56, 0.1]])
        Ss = np.array([[0.1, 0.7],[0.16, 0.1]])
        Yita = np.array([0.2, 0.4])
        C = np.array([[0.1, 0.02],[0.1, 0.27]])
        V = np.array([1, 1])
        xs = np.array([0.1, 0.4])
        # X = [np.sin, np.cos] 

        # x[i]每次修改更换
        for r in range(self.N+1):
            result = I[i] - D[i] * self.yn[r]
            temp = 0
            TV = float("inf") # 交集取最小
            AlphaF = float("inf") # 交集取最小
            SV = float("-inf") # 并集取最大
            BeitaF = float("-inf") # 并集取最大
            for j in range(2):
                temp += A[i][j] * self.Activation(self.yn[r])
                temp += C[i][j] * V[j]
                temp += B[i][j]* self.Activation(self.vn[r])
                a = self.Activation(self.vn[r])
                TV = min(TV, Tt[i][j] * V[j])
                AlphaF = min(AlphaF, Alpha[i][j] * a)
                SV = max(SV, Ss[i][j] * V[j])
                BeitaF = max(BeitaF, Beita[i][j] * a)
            # 暂且循环一次
            result += temp + TV + AlphaF + SV + BeitaF
            self.yt[r] = (result)
            print("Result", result)
        return self.yt

if __name__ == "__main__":
    Temp = cDt()
    YY = []
    for e in range(1):
        print("预备工作...", e)
        for n in range(0,Temp.N+1):
            # print("n: ", n)
            Temp.Yn(n, e)

        print("开始计算分数阶导数...")
        yt = Temp.Dt_yt(e)
        YY.append(yt)

    print("开始绘图...")
    # xt = [math.sin(i*Temp.h) for i in range(Temp.N+1)]
    t = [i * Temp.h for i in range(Temp.N+1)]
    plt.title('alpha = 0.725')
    plt.xlabel('t')
    plt.ylabel('Y')
    plt.plot(t, YY[0][0:len(t)], label = "Y0") # 绘制曲线 y1
    # plt.plot(t, YY[1][0:len(t)], label = "Y1")
    # print(YY)
    # plt.savefig('./xt_t2.jpg')
    plt.show()
    
   
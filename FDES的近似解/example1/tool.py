'''
2020-05-27
对函数求分数阶导数
相图
'''
from scipy.special import gamma
import matplotlib.pyplot as plt
import numpy as np
import math

class cDt():

    N = 100
    T = 0.825
    h = T/N

    alpha = 0.725
    m = math.ceil(alpha)

    vn = yn = ynp = yt = [0] * 560
    #yn = [0] * N
    vn[0] = 0.4
    yn[0] = 0.35 
    fai = [math.cos,math.sin]

    # √与n有关，不受限
    def bjn(self, n, j):
        result = (pow(self.h, self.alpha) / self.alpha) * (pow(n-j+1, self.alpha) - pow(n-j, self.alpha))
        return result
    # √与n有关，不受限
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
    '''
    含f()函数调用
    '''
    def Ynp(self, n, i):
        
        Tnk = (n+1) * self.h
        K = 1
        result = 0

        for k in range(self.m):
            if k > 0:
                K = K * k
            result += self.fai[i]( k*self.h ) * pow(Tnk, k) / K
        
        t = 0
        for j in range(n+1):
            # 有待补充内容
            tj = j * self.h
            yj = self.yn[j]
            vj = self.vn[j]
            # print('yj',yj)
            # print('vj',vj)
            # print("self.f(x)", self.f(tj, yj, vj, j))
            t += self.bjn(n+1, j) * self.f(tj, yj, vj, i)
        
        result += t / gamma(self.alpha)
        # print("  YNP:  ", result)
        self.ynp[n+1] = result

        return result

    def Vn(self, n):
        
        t = (n+1) * self.h
        deerta = self.m - self.Tao(t)/self.h

        result = 0

        if self.m == 1:
            result = deerta * self.ynp[n+1] - (1 - deerta) * self.yn[n]
        else:
            result = deerta * self.yn[n-self.m+2] + (1 - deerta) * self.yn[n-self.m+1]
        # print("  VN:  ", result)
        self.vn[n+1] = result

        return result

    def Tao(self, t):
        result = 1.38 * abs(math.sin(t))
        return result 
    # 激活函数
    def Activation(self, x):
        # sigmoid函数
        result = 1 / (1 + np.exp(-x))
        # result = abs(math.cos(x))
        return result

    def f(self, t, y, v, i):
        '''
        t ，自变量
        y, 原函数y = f(t)
        v, 时延函数
        '''
        D = [1, 1]
        A = np.array([[2,-0.11],[-5,2.2]])
        B = np.array([[-1.6, -0.1],[-0.18,-2.4]])
        I = np.array([0, 0]).T
        Alpha = np.array([[0.02, 0],[0, 0.8]])
        Beita = np.array([[0.02, 0.01], [0, 0.9]])
        Tt = np.array([[0.1, 0],[0, 0.1]])
        Ss = np.array([[0.1, 0],[0, 0.1]])
        C = np.array([[0.1, 0],[0.1, 0]])
        V = np.array([1, 1])
        if t<=0:
            return self.yn[0]
        # X = [np.sin, np.cos] 

        result = 0.0
        # x[i]每次修改更换
        
        result += I[i] - D[i] * y #self.fai(t)
        temp = 0
        TV = float("inf") # 交集取最小
        AlphaF = float("inf") # 交集取最小
        SV = float("-inf") # 并集取最大
        BeitaF = float("-inf") # 并集取最大
        for j in range(len(D)):
            temp += A[i][j] * self.Activation(y)
            temp += C[i][j] * V[j]
            temp += B[i][j]* self.Activation(v)
            a = self.Activation(v) #self.Activation(self.fai(t-Tao(t)))
            TV = min(TV, Tt[i][j] * V[j])
            AlphaF = min(AlphaF, Alpha[i][j] * a)
            SV = max(SV, Ss[i][j] * V[j])
            BeitaF = max(BeitaF, Beita[i][j] * a)
        # 暂且循环一次
        result += temp + TV + AlphaF + SV + BeitaF
        # print("Result", result)
        return result
    # Aim
    def Yn(self, n, l):
        # 初始化
        self.Ynp(n, l)
        self.Vn(n)
    
        Tnk = (n+1) * self.h
        K = 1
        result = 0

        for k in range(self.m):
            if k > 0:
                K = K * k
            result += self.fai[l]( k*self.h ) * pow(Tnk, k) / K

        # 有待补充内容
        tn = Tnk
        y = self.ynp[n+1]
        v = self.vn[n+1]

        result += pow(self.h, self.alpha) / gamma(self.alpha+2) * self.f(tn, y, v, l)

        t = 0
        for j in range(n+1):
            # 有待补充内容
            tj = j * self.h
            yj = self.yn[j]
            vj = self.vn[j]

            t += self.ajn(n, j) * self.f(tj, yj, vj, l)
        
        result += t / gamma(self.alpha)
        self.yn[n+1] = result


if __name__ == "__main__":
    Temp = cDt()
    Y = []
    print("预备工作...")
    for l in range(len(Temp.fai)):
        for n in range(0,Temp.N+1):
            Temp.Yn(n,l)
        print(Temp.vn[0:100])
        Y.append(Temp.yn[0:Temp.N])
    # print("开始计算分数阶导数...")
    # yt = Temp.Dt_yt()
    print("开始绘图...")
    plt.title('alpha = 0.725')
    plt.xlabel('y1')
    plt.ylabel('y2')
    plt.plot(Y[0], Y[1]) # 绘制曲线 y1
    # plt.savefig('./xt_t2.jpg')
    plt.show()
   
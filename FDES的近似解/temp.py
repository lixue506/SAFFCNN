'''
事例二
确切解
完成
'''
from scipy.special import gamma
import matplotlib.pyplot as plt
import numpy as np
import math

D = [0.786, 1]
A = np.array([[-0.56,-0.11],[-0.17,2.2]])
B = np.array([[-1.6, -0.1],[-0.18,0]])
I = np.array([0, -1.62])
Alpha = np.array([[0.5, 0],[0, 0.5]])
Beita = np.array([[0.52, 0], [0, 0.12]])
Tt = np.array([[0.1, 0.82],[0.56, 0.1]])
Ss = np.array([[0.37, 0.7],[0.16, 0.1]])
Yita = np.array([0.2, 0.4])
C = np.array([[0.1, 0.02],[0.1, 0.27]])
V = np.array([1, 1])
xs = np.array([0.64, 0.4])


def fai1(t):
    # print(t, "    :",math.cos(10*t*Alpha[0][0])/(np.exp(t)+3))
    return math.cos(10*t*Alpha[0][0])/(np.exp(t)+3)
    #              t*3.14
    # return math.cos(t)/(3*t+0.31)

def fai2(t):
    # print(t, "    :", math.sin(10*t*Alpha[1][1])/(np.exp(t)+0.314))
    return math.sin(10*t*Alpha[1][1])/(np.exp(t)+0.314)
    #              t*5.26
    # return math.sin(t)/(t+0.356)

def Tao(t):
    result = 6.38 * abs(np.cos(t))
    return result 

def Activation(x):

    result = 1 / (1 + np.exp(-x))
    
    return result

X = [fai1, fai2]
def Lung(s, i):
    result = I[i] - D[i] * X[i](s)
    t = 0
    TV = float("inf") # 交集取最小
    AlphaF = float("inf") # 交集取最小
    SV = float("-inf") # 并集取最大
    BeitaF = float("-inf") # 并集取最大
    for j in range(2):
        t += A[i][j] * Activation(X[j](s))
        t += C[i][j] * V[j]
        a = Activation(X[j](s-Tao(s)))
        t += B[i][j]* a
        TV = TV if (TV < Tt[i][j] * V[j]) else Tt[i][j] * V[j]
        AlphaF = AlphaF if (AlphaF < Alpha[i][j] * a) else Alpha[i][j] * a
        SV = SV if (SV > Ss[i][j] * V[j]) else Ss[i][j] * V[j]
        BeitaF = BeitaF if (BeitaF > Beita[i][j] * a) else Beita[i][j] * a
    result += t + TV + AlphaF + SV + BeitaF
    # print(result)
    return result

# def Show():
    Y = []
    s = np.linspace(0, 30, 10000, endpoint=True)
    for i in range(2):
        y1 = [Lung(k,i) for k in s]      # 曲线 y1
        Y.append(y1)
        plt.xlabel('Time/second')
        plt.ylabel('Y')
        plt.plot(s, y1) # 绘制曲线 y1
        # plt.savefig('./y%s.jpg' % i)
        plt.show()

    err = [abs(Y[0][i]-Y[1][i]) for i in range(len(Y[0]))]
    # # print(err)
    # # x1,x2的函数图像
    
    plt.plot(s,Y[0], label="$y1$", color='green', ls='-.')
    plt.plot(s,Y[1], label="$y2$", color='red', ls=':')
    plt.xlabel('Time')
    plt.ylabel('y1、y2')
    plt.legend()
    # plt.savefig('./Compare.jpg')
    plt.show()

    # 显示误差
    plt.xlabel('Time/second')
    plt.ylabel('Error')
    plt.plot(s,err)
    # plt.savefig('./Error.jpg')
    plt.show()
    # 显示误差
    plt.title("α = 0.55")
    plt.xlabel('x1')
    plt.ylabel('x2')
    plt.plot(Y[0],Y[1])
    # plt.savefig('./xx图α=055.jpg' )
    plt.show()

if __name__ == "__main__":

    Y = []
    s = np.linspace(0, 30, 100, endpoint=True)
    for i in range(2):
        y1 = [Lung(k,i) for k in s]      # 曲线 y1
        Y.append(y1)
        # plt.xlabel('Time/second')
        # plt.ylabel('Y')
        # plt.plot(s, y1) # 绘制曲线 y1
        # # plt.savefig('./y%s.jpg' % i)
        # plt.show()
    # # x1,x2的函数图像

    err = [abs(Y[0][i]-Y[1][i]) for i in range(len(Y[0]))]
    # print(err)
    plt.plot(s,Y[0], label="$y1$", color='green', ls='-.')
    plt.plot(s,Y[1], label="$y2$", color='red', ls=':')
    plt.xlabel('Time')
    plt.ylabel('y1,y2')
    
    plt.plot(13.42, 0, 'om')
    plt.annotate("Time", (13.42,0), 
             xytext=(13,0.05),arrowprops=dict(arrowstyle='->'))
    plt.legend()
    plt.savefig('./Compare1.jpg')
    plt.show()
    # 显示误差
    plt.xlabel('Time')
    plt.ylabel('Error')
    plt.plot(s,err)
    plt.plot(13.42, 0, 'om')
    plt.annotate("Time", (13.42,0), 
             xytext=(13,0.025),arrowprops=dict(arrowstyle='->'))
    plt.savefig('./Error1.jpg')
    plt.show()

    # plt.title("α = %s" % Alpha[0][0])
    # plt.xlabel('x1')
    # plt.ylabel('x2')
    # plt.plot(Y[0],Y[1])
    # plt.savefig('./x2α=%d.jpg' %  (Alpha[0][0]*100))
    # plt.show()

        


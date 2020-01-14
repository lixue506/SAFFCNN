# 固定时延

class Numerical():
    # 通用函数
    def function(self,x):
        return x*x*x
    # 通用函数的导数
    def function_derivative(self,x):
        '''
        例如 x^3
        :param x:
        :return:
        '''
        return 3*x*x
    # 一般欧拉法求解
    def Euler(self,h,x0,y0,n):
        '''
        :param h: 步长
        :param x0: 初始点
        :param n: 迭代次数
        :param y0: 初始值
        :return:
        '''
        save = [[], []]
        save[0].append(x0)
        save[1].append(y0)
        for i in range(1, n+1):
            x = save[0][-1]
            y = save[1][-1]

            y = y + h*self.function(x)
            x = x + h

            save[0].append(x)
            save[1].append(y)
        return save[1]
    # 改进欧拉法 梯形格式
    def Euler_Update(self,h,x0,y0,n):
        '''
        各符号变量同Euler
        梯形格式
        '''
        save = [[],[]]
        save[0].append(x0)
        save[1].append(y0)
        for i in range(1, n + 1):
            x = save[0][-1]
            y = save[1][-1]
            # 计算迭代值
            y = y + h * (self.function(x) + self.function(x+h))/2
            x = x + h
            # 保存每一次迭代值
            save[0].append(x)
            save[1].append(y)

        return save[1]
    # Adams-Bashforth-Moulton
    def ABM(self, h,x0,y0,n):
        save = [[], []]
        save[0].append(x0)
        save[1].append(y0)
        for i in range(1, n + 1):
            x = save[0][-1]
            y = save[1][-1]
            # 计算迭代值
            y = y + h * (self.function(x) + self.function(x + h)) / 2
            x = x + h
            # 保存每一次迭代值
            save[0].append(x)
            save[1].append(y)

    # tao is constant
    def t_constant(self, h, x0, y0, tao, xgm, m, n):
        '''
        :param tao:
        :param xgm:
        :param m:
        :param n:
        :return:
        '''
        if xgm == 0:
            save_y = []
            save_y.append(y0)
            for i in range(1, m+2):
                if i > m:
                    # 粗糙计算
                    # result = self.Euler(h,x0,y0,n-m)
                    # 逼近调用
                    result = self.v_to_y(h, x0, y0, xgm, m, n)

                    for j in result:
                        save_y.append(j)
                else:
                    y = y0
                save_y.append(y)
        else:
            y = self.Euler(h-tao,x0,y0,n)
    # v_approxmation_to_y
    def v_to_y(self, h, x0, y0, xgm, m, n):

        yp = self.Euler_Update(h,x0,y0,n)
        y = self.Euler(h,x0,y0,n)
        v = []
        v.append(y0)
        if m==1:
            for i in len(yp-1):
                v.append(xgm*yp[i+1]+(1-xgm)*y[i])
            return v
        else:
            for i in len(m+1,n+1):
                v.append(xgm*yp[i-m+2]+(1-xgm)*y[i-m+1])
            return v

    # tao is varying
    def tao(self,t):
        # τ是关于t的函数
        # 例如τ=t^2
        return t*t
        

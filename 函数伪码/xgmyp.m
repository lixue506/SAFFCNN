function xgmyp = xgmyp(yn,x,xgm)
xgmyp = yn+(f(x,yn)+f(x+h,xgm*yp(x,yn))+(1-xgm)*yn)/2
end
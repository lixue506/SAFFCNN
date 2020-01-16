function y = func()
yn_lisst = []
if xgm == 0
    m = tall/h
    if n <= m
        for i=0:n
            if i==0
                ytn = y0
                x = x0
            else
                x=x+h
                ytn = fai(x)
            yn_list(end+1) = ytn
            end
        end
    else
        yn_list(end+1) = y0
        ytn = contest_tall(ytn,x+h,h,n-m) 
        for i=0:n-m
            yn_list(end+1) = ytn[i]
        end
    end
else
    if m==1
        ytn = xgmyp(xgm,x,yn)
    else
        yn = contest_tall(y0,x+h,h,n-m+2)
        ytn = 
end
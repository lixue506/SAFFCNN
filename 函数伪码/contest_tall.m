function contest_tall = contest_tall(yn,x,h,nm)
contest_tall = []
for i=0:nm
    yn = yn + h*(f(x,yn)+f(x+h,yp(x,yn)))
    x = x+h
    contest_tall(end+1) = yn
end
end
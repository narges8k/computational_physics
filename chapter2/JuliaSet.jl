using Plots
f(z, c,n)=z^2 + c
res=zeros((401,401))
num=1
#c_list=[-0.4-0.6im, -1im, -0.12-0.75im, -0.6, -0.8+0.16im, -0.4+0.6im]

c=-0.4+0.6im
xpixel=0
for x in -1.0:0.005:1.0
    xpixel+=1
    ypixel=0
    for y=-1.0:0.005:1.0
        z=x+y*im
        ypixel+=1
        for n in 1:10
            z=z^2 + c
            if abs(z)> ((1+sqrt(1+4*sqrt(abs(c))))/2)
                res[xpixel,ypixel]=(abs(z)%num)
                break
            else
                res[xpixel,ypixel]=0.6
            end
        end
    end
end

heatmap( res, c = cgrad(:berlin, scale = :log),dpi=200, legend = false, border=:none, title="c=-0.4+0.6im")
savefig("C:\\Users\\Narges\\Documents\\GitHub\\computational_physics\\chapter2\\Fig\\JuliaSetc6.png")

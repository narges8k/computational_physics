using Plots
f(z, c)=z^2 + c

c_list=[-0.4-0.6im, -1im, -0.12-0.75im, -0.6, -0.8+0.16im, -0.4+0.6im]
greaterlist=[[],[],[],[],[],[]]

for c in c_list
    for x in -1:0.01:1, y=-1:0.01:1
        for n in 1:10
            new_z=(x+y*im)^2 + c
            if abs(new_z)> 1
                push!(greaterlist[indexin(c,c_list)], [real(new_z),imag(new_z)])
            end
        end
    end
end

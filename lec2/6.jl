ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots

include("robot_operations.jl")
pygui(true) 

#           up  down   right left
#sides = (Nord, Sud, Ost, West)

function mark_innerrectangle_perimetr(r::Robot)
    num_steps=fill(0,3) # - вектор-столбец из 3-х нулей
    for (i,side) in enumerate((Sud,West,Sud))
        num_steps[i]=moveSide!(r,side)
    end
    #УТВ: Робот - в Юго-западном углу внешней рамки

    side = find_border!(r,Ost,side)
    #УТВ: Робот - у западной границы внутренней перегородки

    mark_innerrectangle_perimetr!(r,side)
    #УТВ: Робот - снова у западной границы внутренней прямоугольной перегородки

    moveSide!(r,Sud)
    moveSide!(r,West)
    #УТВ: Робот - в Юго-западном улу внешней рамки

    for (i,side) in enumerate((Nord,Ost,Nord))
        followByCount!(r,side, num_steps[i])
    end
    #УТВ: Робот - в исходном положении
end

function mark_innerrectangle_perimetr!(r::Robot, side::HorizonSide)
    direction_of_movement, direction_to_border = get_directions(side)
    for i ∈ 1:4
        putmarkers!(r, direction_of_movement[i], direction_to_border[i]) 
    end
end

get_directions(side::HorizonSide) = 
    if side == Nord  
    # - обход будет по часовой стрелке      
        return (Nord,Ost,Sud, West), (Ost,Sud,West,Nord)
    else # - обход будет против часовой стрелки
        return (Sud,Ost,Nord,West), (Ost,Nord,West,Sud) 
    end

r=Robot(animate=true)
mark_innerrectangle_perimetr(r)
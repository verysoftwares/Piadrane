cam={x=0,y=0}
function mapscreen()
    general_update()
    local spd=2.5
    if press('left') then cam.x=cam.x-spd end
    if press('right') then cam.x=cam.x+spd end
    if press('up') then cam.y=cam.y-spd end
    if press('down') then cam.y=cam.y+spd end
    t=t+1
end

function mapdraw()
    yellow(1)
    love.graphics.rectangle('fill',0,0,320,200)

    yellow(0)
    for rx=0,320-16,16 do for ry=0,200,16 do
        if ((rx/16)+(ry/16))%2==0 or ((rx/16)+(ry/16))%4==1 then
            rect('fill',rx,ry,16,16)
        end
    end end

    for id,lvl in pairs(levels) do
        local lx,ly=math.floor(-cam.x+320/2-3*10+levelpos[id][1]*(3*20+6+4)),math.floor(-cam.y+200/2-3*6+levelpos[id][2]*(3*12+6+16*2+10+4))
        if not lvl.canvas then
        lvl.canvas=lg.newCanvas(3*20+4,3*12+4+16*2+10)
        lg.setCanvas(lvl.canvas)
        yellow(-1)
        rect('line',0,0,3*20+4,3*12+4+16*2+10)
        yellow(2)
        rect('fill',1,1,3*20+2,3*12+2+16*2+10)
        lg.draw(minidraw(lvl,0,0),2,2+10)
        local gem_total=0
        local gem_collect=0
        local exit_total=0
        local exit_collect=0
        for k,b in pairs(lvl.bg_tiles) do
            if b.id==14 then gem_collect=gem_collect+1; gem_total=gem_total+1 end
        end
        for i,s in ipairs(lvl.sprites) do
            if s.id==14 then gem_total=gem_total+1 end
            if s.id==18 and s.tgt and not s.flip then
                if levels[s.tgt] then
                    exit_collect=exit_collect+1
                end
                exit_total=exit_total+1
            end
        end
        yellow(3)
        local msg=string.format('%d/%d',gem_collect,gem_total)
        love.graphics.print(msg,0+3*20/2-(fn:getWidth(msg)+16+4)/2+16+4,0+3*12+4-1+1+10)
        draw_id(14,0+3*20/2-(fn:getWidth('0/0')+16+4)/2,0+3*12+4-2-1-1+1+10,true,lvl.canvas)
        msg=string.format('%d/%d',exit_collect,exit_total)
        love.graphics.print(msg,0+3*20/2-(fn:getWidth(msg)+16+4)/2+16+4,0+3*12+4+16-1+1+10)
        draw_id(18,0+3*20/2-(fn:getWidth('0/0')+16+4)/2,0+3*12+4+16-4+1+10,true,lvl.canvas)
        
        fg(0.95*255,0.95*255,0.95*255)
        rect('fill',1,2,3*20+2,9)
        purple(2)
        lg.print(leveltitles[id],0+3*20/2+4/2-fn:getWidth(leveltitles[id])/2,2)
        end
        lg.setCanvas(lvl.canvas)
        if id==cur_level then
        fg((0.8-(t*0.6)%12*0.02)*255,(0.2+(t*0.6)%12*0.04)*255,(0.4)*255)
        rect('line',0,0,3*20+4,3*12+4+16*2+10)
        end
        draw_id(14,0+3*20/2-(fn:getWidth('0/0')+16+4)/2,0+3*12+4-2-1-1+1+10,true,lvl.canvas)
        lg.setCanvas()
        lg.draw(lvl.canvas,lx,ly)
    end
    for id,lvl in pairs(levels) do
        local lx,ly=math.floor(-cam.x+320/2-3*10+levelpos[id][1]*(3*20+6+4)),math.floor(-cam.y+200/2-3*6+levelpos[id][2]*(3*12+6+16*2+10+4))
        for i,con in ipairs(levelpos[id].connects) do
            if levels[con[3]] then
                if con[1]==0 then
                    if con[2]==-1 then love.graphics.draw(sprsheet,ar_quad2,lx+3*20/2-16+2,ly-6-1); love.graphics.draw(sprsheet,ar_quad2,lx+3*20/2+2,ly-6-1); --[[yellow(2); line(lx+3*20/2-16/2+2,ly-6-1,lx+3*20/2-16/2+2+16,ly-6-1)]] end
                    if con[2]== 1 then love.graphics.draw(sprsheet,ar_quad2,lx+3*20/2-16+2,ly+3*12+2+16*2+10+2-1); love.graphics.draw(sprsheet,ar_quad2,lx+3*20/2+2,ly+3*12+2+16*2+10+2-1) end
                else
                    if con[1]==-1 then love.graphics.draw(sprsheet,ar_quad1,lx-6-1,ly+(3*12+2+16*2+10+2)/2-16); love.graphics.draw(sprsheet,ar_quad1,lx-6-1,ly+(3*12+2+16*2+10+2)/2) end
                    if con[1]== 1 then love.graphics.draw(sprsheet,ar_quad1,lx+3*20+4-1,ly+(3*12+2+16*2+10+2)/2-16); love.graphics.draw(sprsheet,ar_quad1,lx+3*20+4-1,ly+(3*12+2+16*2+10+2)/2) end
                end
            end
        end
    end

    while love.timer.getTime()/100-dt<1/90 do
    end
end

function minidraw(lvl,lx,ly)
    lvl_canvas=lg.newCanvas(3*20,3*12)
    lg.setCanvas(lvl_canvas)
    fg(0.1*255,0.1*255,0.1*255)
    rect('fill',lx,ly,3*20,3*12)
    for k,tile in pairs(lvl.tiles) do
        if tile.id>=1 and tile.id<=12 then
        local color
        local cid=math.floor((tile.id-1)/3)+1
        if cid==1 then color=green end
        if cid==2 then color=purple end
        if cid==3 then color=blue end
        if cid==4 then color=yellow end
        color(2)
        rect('fill',lx+3*tile.x/16,ly+3*tile.y/16,3,3)
        color(1)
        if (tile.id-1)%3==0 then
        line(lx+3*tile.x/16,ly+3*tile.y/16+3-1,lx+3*tile.x/16+3,ly+3*tile.y/16-1)
        elseif (tile.id-1)%3==1 then
        --line(lx+3*tile.x/16,ly+3*tile.y/16+3-1,lx+3*tile.x/16+3,ly+3*tile.y/16-1)
        --line(lx+3*tile.x/16+3,ly+3*tile.y/16+3,lx+3*tile.x/16,ly+3*tile.y/16)
        for rx=0,3-1 do for ry=0,3-1 do
            if math.floor((lx+3*tile.x/16+rx)+(ly+3*tile.y/16+ry))%2==0 then
                love.graphics.point((lx+3*tile.x/16+rx),(ly+3*tile.y/16+ry))
            end
        end end
        elseif (tile.id-1)%3==2 then
        love.graphics.point(lx+3*tile.x/16+2,ly+3*tile.y/16)
        love.graphics.point(lx+3*tile.x/16+1,ly+3*tile.y/16+1)
        love.graphics.point(lx+3*tile.x/16+2,ly+3*tile.y/16+2)
        end
        elseif tile.id==13 then
        blue(0)
        rect('fill',lx+3*tile.x/16,ly+3*tile.y/16,3,3)
        blue(3)
        line(lx+3*tile.x/16,ly+3*tile.y/16+2,lx+3*tile.x/16+3,ly+3*tile.y/16+2)
        end
    end
    for i,s in ipairs(lvl.sprites) do
    end
    lg.setCanvas(lvl.canvas)
    return lvl_canvas
end

levelpos={
    ['PIADRANE.LVL']={0,0,connects={{1,0,'OPTIONS.LVL'},{0,1,'CREDITS.LVL'},{0,-1,'LEVEL0.LVL'}}},
    ['LEVEL0.LVL']={0,-1,connects={{0,-1,'LEVEL5.LVL'},{1,0,'LEVEL1.LVL'}}},
    ['LEVEL1.LVL']={1,-1,connects={{0,-1,'LEVEL3.LVL'},{1,0,'LEVEL2.LVL'}}},
    ['LEVEL2.LVL']={2,-1,connects={}},
    ['LEVEL3.LVL']={1,-2,connects={{1,0,'LEVEL6.LVL'}}},
    ['LEVEL4.LVL']={3,-3,connects={}},
    ['LEVEL5.LVL']={0,-2,connects={}},
    ['LEVEL6.LVL']={2,-2,connects={{0,-1,'LEVEL7.LVL'}}},
    ['LEVEL7.LVL']={2,-3,connects={{1,0,'LEVEL4.LVL'}}},
    ['OPTIONS.LVL']={1,0,connects={}},
    ['CREDITS.LVL']={0,1,connects={}},
}

leveltitles={
    ['PIADRANE.LVL']='Title',
    ['OPTIONS.LVL']='Options',
    ['CREDITS.LVL']='Credits',
    ['LEVEL0.LVL']='First Touch',
    ['LEVEL1.LVL']='The Pit',
    ['LEVEL2.LVL']='Overwatch',
    ['LEVEL3.LVL']='Not A Drill',
    ['LEVEL4.LVL']='Victory',
    ['LEVEL5.LVL']='Flip Flop',
    ['LEVEL6.LVL']='Ziggurat',
    ['LEVEL7.LVL']='Narrow Patrol'
}
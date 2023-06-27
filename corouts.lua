function co_water(x,y)
    local tile={x=x,y=y,id=13,i=tile_i}
    tiles[posstr(x/16,y/16)]=tile
    tile_i=tile_i+1
    tile.co= coroutine.create(function()
    --love.graphics.draw(sprsheet,wf_quad,0,-16+math.floor((t*0.4))%16)
    --love.graphics.draw(sprsheet,wf_quad,0,0+math.floor((t*0.4))%16)
    for i=0,3-1 do
        blue(i+1)
        line(0,(i+1)*2,16,(i+1)*2)
        coroutine.yield()
        for p=0,16,2 do
            blue(i+1)
            love.graphics.point(p,(i+1)*2-1)
            if ((not switch[6]) and p%4==0) then coroutine.yield() end
        end
        for p=1,16,2 do
            blue(i+1)
            love.graphics.point(p,(i+1)*2+1)
            if ((not switch[6]) and p%4==1) then coroutine.yield() end
        end
    end
    coroutine.yield()
    if not tiles[posstr(x/16,y/16+1)] and y+16<200-16 then
        co_water(x,y+16,color,id)
    end

    end)
end

tile_i=0
function co_tile(x,y,color,id)
    --[[local id
    if color==green then id=1 end
    if color==purple then id=4 end
    if color==blue then id=7 end
    if color==yellow then id=10 end
    id=id+tid-1]]
    local tile={x=x,y=y,color=color,id=id,i=tile_i}
    tile_i=tile_i+1
    tiles[posstr(x/16,y/16)]=tile
    tile.co= coroutine.create(function()
    -- base
    for i=0,16-1 do
        color(2)
        lg.line(0,i,16,i)
        coroutine.yield()
    end

    if (id-1)%3==0 then
        -- large stripes
        for i=0,8-1 do
            coroutine.yield()
            color(1)
            lg.line(i-16+8+6-1,-1,i-16+8+6-16-1,16-1)
            coroutine.yield()
            color(1)
            lg.line(i+16+8+6-1,-1,i+16+8+6-16-1,16-1)
            coroutine.yield()
            color(1)
            lg.line(i+8+6-1,-1,i+8+6-16-1,16-1)
        end
    end

    if (id-1)%3==1 then
        -- checkerboard
        for s=1,4 do
        for rx=0,16-1,4 do for ry=0,16-1,4 do
        if (rx/4+ry/4)%2==0 then
        color(1)
        rect('fill',rx,ry,s,s)
        coroutine.yield()
        end end
        end end
    end
    
    if (id-1)%3==2 then
        -- zig-zag
        for i=0,3 do
            color(1)
            lg.line(16-i,-1,8-i-1,8)
            coroutine.yield()
            color(1)
            lg.line(8-i-1,8,16-i-1,16)
            coroutine.yield()
            color(1)
            lg.line(16-i+8,-1,8-i-1+8,8)
            coroutine.yield()
            color(1)
            lg.line(8-i-1+8,8,16-i-1+8,16)
            coroutine.yield()
            color(1)
            lg.line(16-i-8,-1,8-i-1-8,8)
            coroutine.yield()
            color(1)
            lg.line(8-i-1-8,8,16-i-1-8,16)
            coroutine.yield()
        end
    end

    if (id-1)%3==1 then return end

    coroutine.yield()
    
    -- inner edges
    if not tiles[posstr(x/16,y/16-1)] or tiles[posstr(x/16,y/16-1)].id~=id then
        color(1)
        lg.line(0,3,16,3)
        coroutine.yield()
        color(1)
        lg.line(0,2,16,2)
        coroutine.yield()
    end
    if not tiles[posstr(x/16-1,y/16)] or tiles[posstr(x/16-1,y/16)].id~=id then
        color(1)
        lg.line(3,0,3,16)
        coroutine.yield()
        color(1)
        lg.line(2,0,2,16)
        coroutine.yield()
    end
    if not tiles[posstr(x/16+1,y/16)] or tiles[posstr(x/16+1,y/16)].id~=id then
        color(1)
        lg.line(16-4,0,16-4,16)
        coroutine.yield()
        color(1)
        lg.line(16-3,0,16-3,16)
        coroutine.yield()
    end
    if not tiles[posstr(x/16,y/16+1)] or tiles[posstr(x/16,y/16+1)].id~=id then
        color(1)
        lg.line(0,16-3,16,16-3)
        coroutine.yield()
        color(1)
        lg.line(0,16-4,16,16-4)
        coroutine.yield()
    end

    -- outer edges
    if not tiles[posstr(x/16,y/16-1)] or tiles[posstr(x/16,y/16-1)].id~=id then
        color(3)
        lg.line(0,0,16,0)
        coroutine.yield()
        color(3)
        lg.line(1,1,15,1)
        coroutine.yield()
    end
    if not tiles[posstr(x/16,y/16+1)] or tiles[posstr(x/16,y/16+1)].id~=id then
        color(0)
        lg.line(0,16-1,16,16-1)
        coroutine.yield()
        color(0)
        lg.line(1,16-2,15,16-2)
        coroutine.yield()
    end
    if not tiles[posstr(x/16-1,y/16)] or tiles[posstr(x/16-1,y/16)].id~=id then
        color(3)
        lg.line(1,1,1,15)
        coroutine.yield()
        color(3)
        lg.line(0,0,0,16)
        coroutine.yield()
    end
    if not tiles[posstr(x/16+1,y/16)] or tiles[posstr(x/16+1,y/16)].id~=id then
        color(0)
        lg.line(16-2,1,16-2,15)
        coroutine.yield()
        color(0)
        lg.line(16-1,0,16-1,16)
        coroutine.yield()
    end
    end)
end

function tile_refresh()
    if not test_co then
        for i,v in ipairs(newtiles) do tiles[posstr(v[1]/16,v[2]/16)]={id=v[3]} end
        test_co=coroutine.create(function()
            for i,v in ipairs(newtiles) do
                --[[local color=green
                if i>13 then color=purple end
                if i>13+5 then color=blue end
                if i>13+5+5 then color=yellow end]]
                if v[3]>=1 and v[3]<=3 then color=green end
                if v[3]>=4 and v[3]<=6 then color=purple end
                if v[3]>=7 and v[3]<=9 then color=blue end
                if v[3]>=10 and v[3]<=12 then color=yellow end
                co_tile(v[1],v[2],color,v[3])
                coroutine.yield()
            end
        end)
    end
    
    if ((not switch[6]) and t%3==0) then
    coroutine.resume(test_co)
    end
    if switch[6] then
        for i=1,3 do coroutine.resume(test_co) end
    end

    local stopped=true
    for k,tile in pairs(tiles) do
        if not tile.co then stopped=false; break end
        if tile.id and tile.co and coroutine.status(tile.co)~='dead' then stopped=false; break end
    end
    if stopped then loaded=true end
end

function water_refresh()
--love.graphics.setCanvas(wf_canvas2)
    if not wf_coroutine then
    --[[wf_canvas=love.graphics.newCanvas(16,16)
    wf_canvas2=love.graphics.newCanvas(16,16)
    blue(0)
    love.graphics.setCanvas(wf_canvas2)
    rect('fill',0,0,16,16)
    love.graphics.setCanvas()]]
    wf_coroutine=coroutine.create(function()
    for i,v in ipairs(water_tiles) do
    co_water(v[1],v[2],blue,13)
    coroutine.yield()
    end
    end)
    end
    if ((not switch[6]) and t%3==0) or switch[6] then wf_succ=coroutine.resume(wf_coroutine) end
    --[[love.graphics.setCanvas()
    if not wf_succ then
    love.graphics.setCanvas(wf_canvas)
    love.graphics.draw(wf_canvas2,0,-16+math.floor((t*0.4))%16)
    love.graphics.draw(wf_canvas2,0,0+math.floor((t*0.4))%16)
    love.graphics.setCanvas()
    else
    love.graphics.setCanvas(wf_canvas)
    love.graphics.draw(wf_canvas2,0,0)
    love.graphics.setCanvas()
    end]]
end
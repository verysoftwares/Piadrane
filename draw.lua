fn=lg.getFont()

function maindraw()
    --bg(0.95*255,0.95*255,0.95*255)
    --yellow(3)
    --lg.rectangle('fill',0,0,320,240)
    --bg((0.45+3*0.15)*255,(0.45+3*0.15)*255,(0.3+3*0.15)*255)
    bg(0.1*255,0.1*255,0.1*255)
    --fg(0.2*255,0.15*255,0.125*255)
    --[[for rx=0,320,16 do for ry=0,200,16 do
        if ((rx/16)+(ry/16))%2==0 or ((rx/16)+(ry/16))%4==1 then
            rect('fill',rx,ry,16,16)
        end
    end end]]

    --palette_test()
    
    draw_bg_tiles()

    draw_tiles()

    draw_sprites()

    render_sidebar()
    
    draw_fuel()

    draw_cursor()

    --draw_player()

    --purple(3)
    --love.graphics.print('Hello world!',320-fn:getWidth('Hello world!'),0)

    spec_draw()
    
    while love.timer.getTime()/100-dt<1/90 do
    end
end

local temp_canvas=lg.newCanvas(16,16)
function draw_id(id,ix,iy,trans)
    lg.setCanvas(temp_canvas)
    if id==0 then
        --fg(0.95*255,0.95*255,0.95*255)
        fg(0.1*255,0.1*255,0.1*255)
        rect('fill',0,0,16,16)
        lg.setCanvas()
        lg.draw(temp_canvas,ix,iy)
    end
    if id>=1 and id<=12 then
        local color
        if id>=1 and id<=3 then color=green end
        if id>=4 and id<=6 then color=purple end
        if id>=7 and id<=9 then color=blue end
        if id>=10 and id<=12 then color=yellow end
        for i=0,16-1 do
            color(2)
            lg.line(0,i,16,i)
        end
        if (id-1)%3==0 then
            color(1)
            for i=0,8-1 do
                lg.line(i-16+8+6-1,-1,i-16+8+6-16-1,16-1)
                lg.line(i+16+8+6-1,-1,i+16+8+6-16-1,16-1)
                lg.line(i+8+6-1,-1,i+8+6-16-1,16-1)
            end
        end
        if (id-1)%3==1 then
            color(1)
            for s=1,4 do
            for rx=0,16-1,4 do for ry=0,16-1,4 do
            if (rx/4+ry/4)%2==0 then
            rect('fill',rx,ry,s,s)
            end end
            end end
        end
        if (id-1)%3==2 then
            color(1)
            for i=0,3 do
                lg.line(16-i,-1,8-i-1,8)
                lg.line(8-i-1,8,16-i-1,16)
                lg.line(16-i+8,-1,8-i-1+8,8)
                lg.line(8-i-1+8,8,16-i-1+8,16)
                lg.line(16-i-8,-1,8-i-1-8,8)
                lg.line(8-i-1-8,8,16-i-1-8,16)
            end
        end

        lg.setCanvas()
        lg.draw(temp_canvas,ix,iy)
    end
    if id==13 then
        --[[for i,tile in pairs(tiles) do
            if tile.canvas2 and tile.id==13 then 
                lg.draw(tile.canvas2,0,0); break 
            end
        end]]
        lg.draw(sprsheet,wf_quad,0,-16+math.floor(((t+12)*0.4))%16)
        lg.draw(sprsheet,wf_quad,0,0+math.floor(((t+12)*0.4))%16)
        lg.setCanvas()
        lg.draw(temp_canvas,ix,iy)
    end
    if (id>=14 and id<=16) or (id>=18 and id<=21) then
        if not trans then 
            --fg(0.95*255,0.95*255,0.95*255)
            fg(0.1*255,0.1*255,0.1*255)
            rect('fill',0,0,16,16)
        end
        local s_quad
        if id==14 then
        if (t*0.2)%12<8 then s_quad=gem_quad1
        else s_quad=_G['gem_quad'..tostring(math.floor((t*0.2)%12)-8+1)] end
        end
        if id==15 then s_quad=jp_quad end
        if id==16 then s_quad=dr_quad end
        if id==18 then s_quad=ex_quad end
        if id==19 then s_quad=fu_quad end
        if id==20 then 
            s_quad=_G['fi_quad'..tostring(math.floor((t*0.2)%2)+1)] 
        end
        if id==21 then
            local color=switch_col--math.floor((t*0.08)%4)+1
            if switch[color] then status='_on' else status='_off' end
            s_quad=_G['sw_'..tostring(color)..status]
        end
        if trans then 
            lg.setCanvas() 
            love.graphics.draw(sprsheet,s_quad,ix,iy)
        end
        if not trans then 
            love.graphics.draw(sprsheet,s_quad,0,0)
            lg.setCanvas()
            lg.draw(temp_canvas,ix,iy)
        end
    end
    if id==17 then
        if trans then
            lg.setCanvas()
            draw_player(ix,iy)
        end
        if not trans then
            fg(0.1*255,0.1*255,0.1*255)
            rect('fill',0,0,16,16)
            draw_player(0,0)
            lg.setCanvas()
            lg.draw(temp_canvas,ix,iy)
        end
    end
    lg.setCanvas()
end

function draw_sprites()
    if loaded then
        spriteloaded=true
        --green(0)
        for i,s in ipairs(sprites) do
            if not s.visible then
            spriteloaded=false
            if t%2==0 then s.visible=true end
            break
            end
            local s_quad
            if s.id==14 then
            --s_quad=_G['gem_quad'..tostring(math.floor(t*0.2%4)+1)]
            if switch[1] then
                if (t*0.2)%12<8 then s_quad=gem_quad1
                else s_quad=_G['gem_quad'..tostring(math.floor((t*0.2)%12)-8+1)] end
            else
                s_quad=tile_1_off
            end
            end
            if s.id==15 then if switch[1] then s_quad=jp_quad else s_quad=tile_1_off end end
            if s.id==16 then if switch[4] then s_quad=dr_quad else s_quad=tile_4_off end end
            if s.id==18 then if switch[2] then s_quad=ex_quad else s_quad=tile_2_off end end
            if s.id==19 then if switch[2] then s_quad=fu_quad else s_quad=tile_2_off end end
            if s.id==20 then 
                if switch[2] then
                s_quad=_G['fi_quad'..tostring(math.floor((t*0.2)%2)+1)] 
                else
                s_quad=tile_2_off
                end
            end
            if s.id==21 then
                local status
                if switch[s.color] then status='_on' else status='_off' end
                s_quad=_G['sw_'..tostring(s.color)..status]
            end
            if s.id~=17 then love.graphics.draw(sprsheet,s_quad,s.x,s.y,s.flip)
            else 
                if not s.dead then
                    local flip=false
                    if s.dx<0 then flip=true end
                    s_quad=dn_quad1
                    if math.abs(s.dx)>0.08 then s_quad=_G['dn_quad'..tostring(math.floor(t*0.2%4+1))] end
                    
                    if not s.dummy then
                    local unread=unread_ideas()
                    for i=1,unread do
                    if unread==#idea_order and t%24<12 then
                    purple(3)
                    lg.print('F1',s.x+1,s.y-i*16)
                    else
                    lg.draw(sprsheet,lb_quad,s.x-2,s.y-4-i*16)
                    end
                    end
                    end
                    
                    if not s.exited then
                    lg.draw(dinosheet,s_quad,s.x-2,s.y-4,flip) 
                    end
                    
                    if (drill and s.drill_tile and (press('lctrl') or press('rctrl')) and t%24<12) then
                    if s.tgt_tile and s.tgt_tile.id>=1 and s.tgt_tile.id<=12 and (s.tgt_tile.id-1)%3==1 then
                    lg.draw(sprsheet,dr_quad,s.drill_tile[1],s.drill_tile[2])
                    else
                    lg.draw(sprsheet,dr_quad2,s.drill_tile[1],s.drill_tile[2])
                    end
                    end
                else 
                    for i=#s.pixels,1,-1 do
                        local px=s.pixels[i]
                        love.graphics.draw(dinosolo,px.quad,px.x,px.y)
                        px.x=px.x+px.dx
                        px.y=px.y+px.dy
                        px.dy=px.dy+0.1
                        if px.y>=200 then table.remove(s.pixels,i) end
                    end
                end
            end
        end
        if spriteloaded and not saved then
            save_state()
            saved=true
        end
    end
end

function draw_cursor()
    if not sel then
    --fg((0.8-8*0.02)*255,(0.2+8*0.04)*255,(0.4)*255)
    --rect('fill',mox,moy,16,16)
    if scroll_hover then love.graphics.draw(sprsheet,m2_quad,mox,moy)
    else love.graphics.draw(sprsheet,m1_quad,mox,moy) end
    end
    if sel then 
        if scroll_hover then love.graphics.draw(sprsheet,m2_quad,mox,moy)
        else
        draw_id(sel,mox,moy,true)
        fg((0.8-(t*0.6)%12*0.02)*255,(0.2+(t*0.6)%12*0.04)*255,(0.4)*255)
        rect('line',mox-1,moy-1,18,18) 
        end
    end
end

function draw_bg_tiles()
    for k,bgtile in pairs(bg_tiles) do
        bgtile.color(0)
        rect('fill',bgtile.x,bgtile.y,16,16)
        for rx=0,16-1,4 do for ry=0,16-1,4 do
        if (rx/4+ry/4)%2==0 then
        bgtile.color(-1)
        rect('fill',bgtile.x+rx,bgtile.y+ry,4,4)
        end end
        end 
    end
end

function draw_tiles()
    for k,tile in pairs(tiles) do
        tile_render(tile)
    end
end

function tile_render(tile)
    if not tile.co then return end

    if tile.id<13 then
    if not tile.canvas then
        tile.canvas=lg.newCanvas(16,16)
        lg.setCanvas(tile.canvas)
        --tile.color(0)
        --rect('fill',0,0,16,16)
        bg(0.95*255,0.95*255,0.95*255)
        lg.setCanvas()
    end

    lg.setCanvas(tile.canvas)
    coroutine.resume(tile.co)
    lg.setCanvas()
    fg(1,1,1)
    
    local color=math.floor((tile.id-1)/3)+1
    if (tile.id-1)%3>0 or switch[color] then
    lg.draw(tile.canvas,tile.x,tile.y)    
    else
    lg.draw(sprsheet,_G['tile_'..tostring(color)..'_off'],tile.x,tile.y)
    end

    elseif tile.id==13 then
    if not tile.canvas then
        tile.canvas=lg.newCanvas(16,16)
        tile.canvas2=lg.newCanvas(16,16)
        lg.setCanvas(tile.canvas)
        --tile.color(0)
        --rect('fill',0,0,16,16)
        blue(0)
        rect('fill',0,0,16,16)
        lg.setCanvas()
    end
    lg.setCanvas(tile.canvas)
    local succ=coroutine.resume(tile.co)
    lg.setCanvas()
    fg(1,1,1)
    if not succ then
    lg.setCanvas(tile.canvas2)
    lg.draw(tile.canvas,0,-16+math.floor(((t+12)*0.4))%16)
    lg.draw(tile.canvas,0,0+math.floor(((t+12)*0.4))%16)    
    lg.setCanvas()
    lg.draw(tile.canvas2,tile.x,tile.y)
    else
    lg.draw(tile.canvas,tile.x,tile.y)
    end
    end
end

function draw_player(plrx,plry)
    --[[purple(2)
    lg.circle('fill',plrx+6+2,plry+4+4,7)
    purple(3)
    lg.circle('fill',plrx+6-3+2,plry+4-2+4,3)
    lg.circle('fill',plrx+6+3+2,plry+4-2+4,3)
    purple(1)
    lg.point(plrx+6-2+2,plry+4-2+4)
    lg.point(plrx+6+2-1+2,plry+4-2+4)]]
    lg.draw(dinosheet,_G['dn_quad'..tostring(math.floor(t*0.05%4+1))],plrx,plry)
end

function palette_test()
    for i=0,4-1 do
        fg((0.45+i*0.15)*255,(0.3+i*0.15)*255,(0.4+i*0.15)*255)
        rect('fill',i*16,0,16,16)
    end
    for i=0,4-1 do
        fg((0.3+i*0.15)*255,(0.45+i*0.15)*255,(0.4+i*0.15)*255)
        rect('fill',0,16+i*16,16,16)
    end
    for i=0,4-1 do
        fg((0.3+i*0.15)*255,(0.4+i*0.15)*255,(0.45+i*0.15)*255)
        rect('fill',16,16+i*16,16,16)
    end
    for i=0,4-1 do
        fg((0.45+i*0.15)*255,(0.45+i*0.15)*255,(0.3+i*0.15)*255)
        rect('fill',16*2,16+i*16,16,16)
    end
    --[[for rx=0,320,16 do for ry=0,200,16 do
        if ((rx/16)+(ry/16))%2==0 or ((rx/16)+(ry/16))%4==1 then
            rect('fill',rx,ry,16,16)
        end
    end end]]
    
    --green(1)
    --rect('fill',plr.x,plr.y,plr.w,plr.h)
end

function draw_fuel()
    fg(0.75*255,0.75*255,0.75*255)
    rect('fill',0,200-8,320,8)
    fg(0.25*255,0.25*255,0.25*255)
    rect('fill',0,200-6,320,4)
    if fuel>0 then
    local rectw=320*fuel
    local j=0
    for i=0,rectw-1,16 do
        fg((0.8-j*0.02)*255,(0.2+j*0.04)*255,(0.4)*255)
        rect('fill',i,200-6,16,4)
        j=j+1
    end
    end
end

function spec_draw()
    if love.update==namefile then
        local msg
        if file_io==save_level then msg='Save level as:' 
        elseif file_io==load_level then msg='Load level:'
        else msg='Exit to:' end
        blue(0)
        rect('fill',0,200/2-5-12,320,10)
        purple(3)
        love.graphics.print(msg,320/2-fn:getWidth(msg)/2,200/2-4-1-12)
        blue(0)
        rect('fill',0,200/2-5,320,10)
        purple(3)
        love.graphics.print(savefile..'.LVL',320/2-fn:getWidth(savefile..'.LVL')/2,200/2-4-1)
    end

    if love.update==YNmodal then
        blue(0)
        rect('fill',0,200/2-5,320,10)
        purple(3)
        love.graphics.print(YNmsg,320/2-fn:getWidth(YNmsg)/2,200/2-4-1)
    end

    if cur_level=='CREDITS.LVL' and loaded then
        local msg='Game by'
        local tx=0
        for i=1,#msg do
            yellow(math.floor((i*0.2+t*0.06)%4))
            local char=string.sub(msg,i,i)
            love.graphics.print(char,320/2-8-fn:getWidth(msg)/2+tx+1,32+math.sin(i*0.6+t*0.2)*3)
            tx=tx+fn:getWidth(char)
        end
        local msg='Leonard Somero'
        local tx=0
        for i=1,#msg do
            green(math.floor((i*0.2+t*0.06)%4))
            local char=string.sub(msg,i,i)
            love.graphics.print(char,320/2-8-fn:getWidth(msg)/2+tx+1,32+24+math.sin(i*0.6+t*0.2)*3)
            tx=tx+fn:getWidth(char)
        end
        purple(3)
        msg='Greets to:'
        love.graphics.print(msg,320/2-8-fn:getWidth(msg)/2+1,32+24+42)
        msg='rxi, BORB, thp, SuperIlu, Foxmanrox'
        love.graphics.print(msg,320/2-8-fn:getWidth(msg)/2+1,32+24+42+24)
        msg='SindriAlvanis, Odysseus McBorg'
        love.graphics.print(msg,320/2-8-fn:getWidth(msg)/2+1,32+24+42+24+8)
        msg='@ttackshark, Bi Bi McBep, Rachel'
        love.graphics.print(msg,320/2-8-fn:getWidth(msg)/2+1,32+24+42+24+8+8)
        msg='Corvidae, Pachydad, TacoSauceDev'
        love.graphics.print(msg,320/2-8-fn:getWidth(msg)/2+1,32+24+42+24+8+8+8)
    end

    if cur_level=='LEVEL4.LVL' then
        local msg='Congratulations!'
        local tx=0
        for i=1,#msg do
            yellow(math.floor((i*0.2+t*0.06)%4))
            local char=string.sub(msg,i,i)
            love.graphics.print(char,320/2-8-fn:getWidth(msg)/2+tx+1,32+math.sin(i*0.6+t*0.2)*3)
            tx=tx+fn:getWidth(char)
        end
        local msg='You\'ve won the game!'
        local tx=0
        for i=1,#msg do
            green(math.floor((i*0.2+t*0.06)%4))
            local char=string.sub(msg,i,i)
            love.graphics.print(char,320/2-8-fn:getWidth(msg)/2+tx+1,32+24+math.sin(i*0.6+t*0.2)*3)
            tx=tx+fn:getWidth(char)
        end
        purple(3)
        msg='Time taken: '..string.format('%.2d:%.2d',math.floor((end_t-start_t)/60),math.floor(end_t-start_t)%60)
        love.graphics.print(msg,320/2-8-fn:getWidth(msg)/2+1,32+24+42)
        msg='Gems collected: '..string.format('%d',total_gems)
        love.graphics.print(msg,320/2-8-fn:getWidth(msg)/2+1,32+24+42+8)
        msg='This was version 1D'
        love.graphics.print(msg,320/2-8-fn:getWidth(msg)/2+1,32+24+42+24+8)
        msg='(first public playtest build).'
        love.graphics.print(msg,320/2-8-fn:getWidth(msg)/2+1,32+24+42+24+8+8)
        msg='Stay tuned for more content'
        love.graphics.print(msg,320/2-8-fn:getWidth(msg)/2+1,32+24+42+24+8+24+8)
        msg='in the near future!'
        love.graphics.print(msg,320/2-8-fn:getWidth(msg)/2+1,32+24+42+24+8+24+8+8)
    end

    for i,s in ipairs(sprites) do
        if s.id==17 and s.dead and not s.dummy then
            local msg='Game over!'
            local tx=0
            for i=1,#msg do
                yellow(math.floor((i*0.2+t*0.06)%4))
                local char=string.sub(msg,i,i)
                love.graphics.print(char,320/2-fn:getWidth(msg)/2+tx+1,32+math.sin(i*0.6+t*0.2)*3)
                tx=tx+fn:getWidth(char)
            end
            purple(3)
            msg='Ctrl+Z to reset to previous checkpoint.'
            love.graphics.print(msg,320/2-fn:getWidth(msg)/2+1,32+24+42+8+8+8+8)
            break
        end
    end
    --[[if idea_db['walk'].canvas then
        love.graphics.draw(idea_db['walk'].canvas,320/2,200/2)
    end
    if idea_db['jump'].canvas then
        love.graphics.draw(idea_db['jump'].canvas,320/2+16*3,200/2)
    end]]
end
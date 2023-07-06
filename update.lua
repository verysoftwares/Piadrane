function general_update()
    dt=love.timer.getTime()/100

    loop_music()
end

function mainupdate()
    general_update()

    if zhold and not press('z') then zhold=false end    
    if spriteloaded then
        if (press('lctrl') or press('rctrl')) and tapped('z') then
            load_state()
            zhold=true
        end
        idea_events()
        if not levels[cur_level] then cache_level(cur_level) end 
    end

    leftheld=left
    left=love.mouse.isDown(1)
    right=love.mouse.isDown(2)
    mox,moy=love.mouse.getPosition()
    if sel and --[[not AABB(320-19,17,19,200-16-17+1,mox,moy,1,1)]] mox<320-20 then mox,moy=mox-mox%16,moy-moy%16 end

    if spriteloaded and not editmode then
        local enter=tapped('return')
        local down=tapped('down')
        local up=tapped('up')
        jetpack_consume=false
        drill_consume=false
        for i,sp in ipairs(sprites) do
            if sp.id==23 then 
                if sp.mode==nil then
                sp.x=sp.x+sp.dx 
                elseif sp.mode=='hit' then
                    if t-sp.hit_t>20 then
                        sp.dx=-sp.dx
                        sp.mode=nil
                    end
                end
                if sp.x<0 then sp.mode='hit'; sp.align='left'; sp.hit_t=t+1; sp.x=0 end
                if sp.x>=320-16 then sp.mode='hit'; sp.align='right'; sp.hit_t=t+1; sp.x=320-16-1 end
                for k,tile in pairs(tiles) do
                    if AABB(tile.x,tile.y,16,16,sp.x,sp.y+4,16,8) then
                        sp.mode='hit'
                        if tile.x<sp.x then sp.x=tile.x+16; sp.align='left'
                        else sp.x=tile.x-16; sp.align='right' end
                        sp.hit_t=t+1
                        break
                    end
                end
                for i2,sp2 in ipairs(sprites) do
                    if sp2.id==21 and sp2~=sp.immune and AABB(sp2.x,sp2.y,16,16,sp.x,sp.y,16,16) then
                        switch[sp2.color]=not switch[sp2.color]
                        sp.immune=sp2
                    elseif sp2.id==21 and sp2==sp.immune and not AABB(sp2.x,sp2.y,16,16,sp.x,sp.y,16,16) then
                        sp.immune=nil
                    end
                end
            end
        end
        for i,sp in ipairs(sprites) do if sp.id==17 and not sp.dead then
            local plr=sp

            if not plr.exited then
            if press('left') and not drill_active() then if plr.dx>0 then plr.dx=0 end; plr.dx=plr.dx-0.3 end
            if press('right') and not drill_active() then if plr.dx<0 then plr.dx=0 end; plr.dx=plr.dx+0.3 end

            plr.swimming=false
            if not water_coll(plr) then
                move_x(plr)
                move_y(plr)
                if not jetpack then jump(plr)
                else fly(plr) end
                if drill then use_drill(plr) end
            else
                move_x(plr)
                swim_y(plr)
            end
            end

            sprite_coll(plr,enter,down,up)

        end end
        if jetpack_consume then fuel=fuel-fuel_consume end
        if drill_consume then fuel=fuel-fuel_consume end
        if fuel<0 then fuel=0 end
    end
    if editmode and tapped('p') then
        --plr.x=mox-mox%16+2; plr.y=moy-moy%16+4
        editmode=false
        suq_i=1
        sel=nil
    end
    
    if DEBUG then
    if spriteloaded and (press('lctrl') or press('rctrl')) and tapped('l') then
        love.update=namefile
        file_io=load_level
    end
    if spriteloaded and editmode and (press('lctrl') or press('rctrl')) and tapped('s') then
        love.update=namefile
        file_io=save_level
    end
    end
    
    if spriteloaded and (editmode or gems>0) then
        edit()
        if DEBUG then clear_objs() end
    end

    tile_refresh()
    water_refresh()
    fizzle_refresh()

    t=t+1
end

function die(plr)
    plr.dead=t
    plr.pixels={}
    for px=0,16-1 do for py=0,16-1 do
        table.insert(plr.pixels,{quad=love.graphics.newQuad(px,py,1,1),x=plr.x-2+px,y=plr.y-4+py,dx=-(8-px)*0.2,dy=-(16-py)*0.2})
    end end
end

function YNmodal()
    general_update()
end
function general_update()
    start_t=love.timer.getTime()/100

    loop_music()
end

function mainupdate()
    general_update()

    if spriteloaded then
    if (press('lctrl') or press('rctrl')) and tapped('z') then
        load_state()
    end
    new_idea('walk')
    if cur_level=='LEVEL3.LVL' then new_idea('drillwant') end
    if not find(idea_order,'flames') then
    for i,s in ipairs(sprites) do
        if s.id==17 and s.dummy and s.dead then
            new_idea('flames')
            break
        end
    end
    end
    if return_idea then new_idea('return') end
    if not find(idea_order,'backdoor') then
    if backdoor_idea then 
        local plr=sprites[#sprites]
        for i,s in ipairs(sprites) do
            if s.id==18 and s.flip and not AABB(plr.x,plr.y,plr.w,plr.h,s.x,s.y,16,16) then
            new_idea('backdoor')
            break
            end
        end
    end
    end
    if not find(idea_order,'switchfar') then
        if cur_level~='LEVEL5.LVL' then
        for k,tile in pairs(tiles) do
            if tile.id>=1 and tile.id<=12 and (tile.id-1)%3==0 and not switch[math.floor((tile.id-1)/3)+1] then
            new_idea('switchfar')
            break
            end
        end
        end
    end
    end

    leftheld=left
    left=love.mouse.isDown(1)
    right=love.mouse.isDown(2)
    mox,moy=love.mouse.getPosition()
    if sel and --[[not AABB(320-19,17,19,200-16-17+1,mox,moy,1,1)]] mox<320-20 then mox,moy=mox-mox%16,moy-moy%16 end

    if spriteloaded and not editmode then
        for i,sp in ipairs(sprites) do if sp.id==17 and not sp.dead then
            local plr=sp
            if press('left') and not (drill and (press('lctrl') or press('rctrl'))) then if plr.dx>0 then plr.dx=0 end; plr.dx=plr.dx-0.3 end
            if press('right') and not (drill and (press('lctrl') or press('rctrl'))) then if plr.dx<0 then plr.dx=0 end; plr.dx=plr.dx+0.3 end

            if not water_coll(plr) then
                move_x(plr)
                move_y(plr)
                if not jetpack then jump(plr)
                else fly(plr) end
                if drill then use_drill(plr) end
                if jetpack_consume then fuel=fuel-fuel_consume end
                if drill_consume then fuel=fuel-fuel_consume end
                if fuel<0 then fuel=0 end
            else
                move_x(plr)
                swim_y(plr)
            end

            sprite_coll(plr)
        end end
    end
    if tapped('p') then
        --plr.x=mox-mox%16+2; plr.y=moy-moy%16+4
        editmode=false
        suq_i=1
        sel=nil
    end
    if spriteloaded and (press('lctrl') or press('rctrl')) and tapped('l') then
        love.update=namefile
        file_io=load_level
    end
    if spriteloaded and editmode and (press('lctrl') or press('rctrl')) and tapped('s') then
        love.update=namefile
        file_io=save_level
    end
    if spriteloaded and (editmode or gems>0) then
        edit()
        clear_objs()
    end

    tile_refresh()
    water_refresh()

    t=t+1
end

function move_x(plr)
    plr.x=plr.x+plr.dx
    plr.dx=plr.dx*0.85
    xcoll(plr)
end

function xcoll(plr)
    for i,dir in ipairs({-1,0,1}) do
        local below=tiles[posstr((plr.x-plr.x%16)/16+1,(plr.y-plr.y%16)/16+dir)]
        if below and below.id<13 and ((below.id-1)%3>0 or switch[math.floor((below.id-1)/3)+1]) and AABB(below.x,below.y,16,16,plr.x,plr.y,plr.w,plr.h) then
            if cur_level=='LEVEL0.LVL' and below.x==11*16 and below.y==7*16 then
                if not find(idea_order,'undo') then new_idea('toohigh') end
            end
            plr.x=below.x-plr.w
            break
        end
        local above=tiles[posstr((plr.x-plr.x%16)/16,(plr.y-plr.y%16)/16+dir)]
        if above and above.id<13 and ((above.id-1)%3>0 or switch[math.floor((above.id-1)/3)+1]) and AABB(above.x,above.y,16,16,plr.x,plr.y,plr.w,plr.h) then
            plr.x=above.x+16
            break
        end
    end    
    if plr.x<0 then plr.x=0 end
    if plr.x>=320-plr.w then
        plr.x=320-plr.w
    end
end

function move_y(plr)
    plr.y=plr.y+plr.dy
    if not (jetpack and ((press('lalt') or press('ralt')) and press('down'))) and not (drill and (press('lctrl') or press('rctrl'))) then
    plr.dy=plr.dy+0.2
    end
    plr.onground=false
    ycoll(plr)
end

function ycoll(plr)
    for i,dir in ipairs({-1,0,1}) do
        local below=tiles[posstr((plr.x-plr.x%16)/16+dir,(plr.y-plr.y%16)/16+1)]
        if below and below.id<13 and ((below.id-1)%3>0 or switch[math.floor((below.id-1)/3)+1]) and AABB(below.x,below.y,16,16,plr.x,plr.y,plr.w,plr.h) then
            plr.y=below.y-plr.h
            if plr.dy>0.4 and not plr.onground then
            new_idea('jump')
            end
            plr.dy=0
            plr.onground=true
            break
        end
        local above=tiles[posstr((plr.x-plr.x%16)/16+dir,(plr.y-plr.y%16)/16)]
        if above and above.id<13 and ((above.id-1)%3>0 or switch[math.floor((above.id-1)/3)+1]) and AABB(above.x,above.y,16,16,plr.x,plr.y,plr.w,plr.h) then
            plr.y=above.y+16
            break
        end
    end
    if plr.y<0 then plr.y=0 end
    if plr.y>=200-8-plr.h then
        plr.y=200-8-plr.h
        plr.dy=0
        plr.onground=true
    end
end

function swim_y(plr)
    if press('up') then
        plr.dy=plr.dy-0.2
    end
    if press('down') then
        plr.dy=plr.dy+0.2
    end
    plr.y=plr.y+plr.dy
    plr.dy=plr.dy*0.89
    ycoll(plr)
end

function fly(plr)
    jetpack_consume=false
    if press('lalt') or press('ralt') then
        if fuel>0 then
            if press('down') then 
                plr.dy=plr.dy*0.4 
            else
                plr.dy=plr.dy-0.6
                plr.dy=plr.dy*0.89
            end
            jetpack_consume=true
        else
            jump(plr)
        end
    end
end

function use_drill(plr)
    drill_consume=false
    if (press('lctrl') or press('rctrl')) and fuel>0 then
        --plr.dy=plr.dy*0.4
        if not plr.drill_hold then plr.drill_hold={(plr.x+6)-(plr.x+6)%16+2,(plr.y+6)-(plr.y+6)%16+4} end
        plr.y=plr.y+((plr.drill_hold[2])-plr.y)*0.4
        plr.x=plr.x+((plr.drill_hold[1])-plr.x)*0.4
        if press('left') and (not plr.drill_tile or not (plr.drill_tile[1]==plr.drill_hold[1]-16 and plr.drill_tile[2]==plr.drill_hold[2])) then plr.dx=-0.00001; plr.drill_tile={plr.drill_hold[1]-plr.drill_hold[1]%16-16,plr.drill_hold[2]-plr.drill_hold[2]%16} end
        if press('right') and (not plr.drill_tile or not (plr.drill_tile[1]==plr.drill_hold[1]+16 and plr.drill_tile[2]==plr.drill_hold[2]))then plr.dx=0.00001; plr.drill_tile={plr.drill_hold[1]-plr.drill_hold[1]%16+16,plr.drill_hold[2]-plr.drill_hold[2]%16} end
        if press('up') and (not plr.drill_tile or not (plr.drill_tile[1]==plr.drill_hold[1] and plr.drill_tile[2]==plr.drill_hold[2]-16)) then plr.drill_tile={plr.drill_hold[1]-plr.drill_hold[1]%16,plr.drill_hold[2]-plr.drill_hold[2]%16-16} end
        if press('down') and (not plr.drill_tile or not (plr.drill_tile[1]==plr.drill_hold[1] and plr.drill_tile[2]==plr.drill_hold[2]+16)) then plr.drill_tile={plr.drill_hold[1]-plr.drill_hold[1]%16,plr.drill_hold[2]-plr.drill_hold[2]%16+16} end
        if not plr.drill_tile then 
            if plr.dx<0 then plr.drill_tile={plr.drill_hold[1]-plr.drill_hold[1]%16-16,plr.drill_hold[2]-plr.drill_hold[2]%16} end
            if plr.dx>=0 then plr.drill_tile={plr.drill_hold[1]-plr.drill_hold[1]%16+16,plr.drill_hold[2]-plr.drill_hold[2]%16} end
            if jetpack and (press('lalt') or press('ralt')) then plr.drill_tile={plr.drill_hold[1]-plr.drill_hold[1]%16,plr.drill_hold[2]-plr.drill_hold[2]%16-16} end
        end
        if plr.drill_tile then
        if not plr.tgt_tile or not (plr.tgt_tile.x==plr.drill_tile[1] and plr.tgt_tile.y==plr.drill_tile[2]) then plr.tgt_tile=tiles[posstr(plr.drill_tile[1]/16,plr.drill_tile[2]/16)] end
        if plr.tgt_tile and plr.tgt_tile.id>=1 and plr.tgt_tile.id<=12 and (plr.tgt_tile.id-1)%3==1 then
            if not plr.tgt_weaken then
                plr.tgt_weaken=1
            end
            plr.tgt_weaken=plr.tgt_weaken-drill_spd
            drill_consume=true
            if plr.tgt_weaken<=0 then
                local drilled=tiles[posstr(plr.drill_tile[1]/16,plr.drill_tile[2]/16)]
                tiles[posstr(plr.drill_tile[1]/16,plr.drill_tile[2]/16)]=nil
                local color
                local cid=math.floor((drilled.id-1)/3)
                if cid==0 then color=green end
                if cid==1 then color=purple end
                if cid==2 then color=blue end
                if cid==3 then color=yellow end
                bg_tiles[posstr(plr.drill_tile[1]/16,plr.drill_tile[2]/16)]={x=drilled.x,y=drilled.y,id=drilled.id,color=color}
                plr.drill_hold=nil
                plr.drill_tile=nil
                plr.tgt_tile=nil
                plr.tgt_weaken=nil
            end
        end
        end
    else
        plr.drill_hold=nil
        plr.drill_tile=nil
        plr.tgt_tile=nil
        plr.tgt_weaken=nil
    end
end

function water_coll(plr)
    for k,tile in pairs(tiles) do
        if tile.id==13 and AABB(tile.x,tile.y,16,16,plr.x,plr.y,plr.w,plr.h) then
            plr.dy=plr.dy+0.085
            new_idea('waterfall')
            return true
        end
    end
    return false
end

function sprite_coll(plr)
    local enter=tapped('return')
    local up=tapped('up')
    for i=#sprites,1,-1 do
        local s=sprites[i]
        if s.id==14 and AABB(s.x+3,s.y+3,16-6,16-6,plr.x,plr.y,plr.w,plr.h) then
            new_idea('gem')
            gems=gems+1
            table.remove(sprites,i)
        end
        if s.id==18 and AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) then
            if s.flip then backdoor_idea=true
            else new_idea('exit') end
        end
        if s.id==18 and (not s.flip or (s.flip and enter)) and s.tgt and (plr.immune~=s.tgt or enter) and AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) then
            plr.immune=s.tgt
            if cur_level=='PIADRANE.LVL' then
                love.update=YNmodal
                YNtgt=s.tgt
                YNplr=plr
                if YNtgt=='LEVEL0.LVL' then
                    YNmsg='Want to start a new game? Y/N'
                    if levels['LEVEL0.LVL'] then
                        love.update=mainupdate
                        load_level(YNtgt,true)
                    end
                end
                if YNtgt=='CREDITS.LVL' then
                    YNmsg='Want to view the credits? Y/N'
                end
                if YNtgt=='OPTIONS.LVL' then
                    YNmsg='Want to change game options? Y/N'
                end
                if YNtgt=='QUIT.LVL' then
                    YNmsg='Want to quit to DOS? Y/N'
                end
            else
            load_level(s.tgt,true)
            end
            return
        end
        if s.id==20 then
            if AABB(plr.x,plr.y,plr.w,plr.h,s.x,s.y+10,16,6) then
                die(plr)
            end
        end
        if s.id==15 then
            if AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) then
                table.remove(sprites,i)
                jetpack=true
                new_idea('jetpack')
                fuel=fuel+0.5
                if fuel>1 then fuel=1 end
            end
        end
        if s.id==16 then
            if AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) then
                table.remove(sprites,i)
                drill=true
                new_idea('drill')
                fuel=fuel+0.5
                if fuel>1 then fuel=1 end
            end
        end
        if s.id==19 then
            if AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) then
                table.remove(sprites,i)
                new_idea('fuel')
                fuel=fuel+0.5
                if fuel>1 then fuel=1 end
            end
        end
        if s.id==21 then
            if AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) then
                new_idea('switch')
                if up then
                    switch[s.color]=not switch[s.color]
                end
            end
        end
    end

    if plr.immune then
        local immune={}
        for i,s in ipairs(sprites) do
            if s.id==18 and s.tgt==plr.immune then
                table.insert(immune,s)
            end
        end
        local found=false
        for i,s in ipairs(immune) do
            if AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) then
                found=true
                break
            end
        end
        if not found then plr.immune=nil end
    end
end

function die(plr)
    plr.dead=true
    plr.pixels={}
    for px=0,16-1 do for py=0,16-1 do
        table.insert(plr.pixels,{quad=love.graphics.newQuad(px,py,1,1),x=plr.x-2+px,y=plr.y-4+py,dx=-(8-px)*0.2,dy=-(16-py)*0.2})
    end end
end

function YNmodal()
    general_update()
end

function jump(plr)
    if (press('lalt') or press('ralt')) and plr.onground then
        plr.dy=plr.dy-3
    end
end

function clear_objs()
    if not loaded or not right then return end

    for k,tile in pairs(tiles) do
        if AABB(mox,moy,1,1,tile.x,tile.y,16,16) then
            tiles[posstr(tile.x/16,tile.y/16)]=nil
            if tile.id>=1 and tile.id<=12 then
            if tiles[posstr(tile.x/16+1,tile.y/16)] and tiles[posstr(tile.x/16+1,tile.y/16)].id==tile.id then co_tile(tile.x+16,tile.y,tiles[posstr(tile.x/16+1,tile.y/16)].color,tiles[posstr(tile.x/16+1,tile.y/16)].id) end
            if tiles[posstr(tile.x/16-1,tile.y/16)] and tiles[posstr(tile.x/16-1,tile.y/16)].id==tile.id then co_tile(tile.x-16,tile.y,tiles[posstr(tile.x/16-1,tile.y/16)].color,tiles[posstr(tile.x/16-1,tile.y/16)].id) end
            if tiles[posstr(tile.x/16,tile.y/16+1)] and tiles[posstr(tile.x/16,tile.y/16+1)].id==tile.id then co_tile(tile.x,tile.y+16,tiles[posstr(tile.x/16,tile.y/16+1)].color,tiles[posstr(tile.x/16,tile.y/16+1)].id) end
            if tiles[posstr(tile.x/16,tile.y/16-1)] and tiles[posstr(tile.x/16,tile.y/16-1)].id==tile.id then co_tile(tile.x,tile.y-16,tiles[posstr(tile.x/16,tile.y/16-1)].color,tiles[posstr(tile.x/16,tile.y/16-1)].id) end
            elseif tile.id==13 then
                for i,w in ipairs(water_tiles) do
                    if w.x==tile.x and w.y==tile.y then table.remove(water_tiles,i); break end
                end
            end
            if not editmode then gems=gems-1 end
        end
    end
    
    local found=false
    for i,s in ipairs(sprites) do
        if (s.id~=17 and s.x==mox and s.y==moy) or (s.id==17 and s.x==mox+2 and s.y==moy+4) then found=i; break end
    end
    if found then table.remove(sprites,found); if not editmode then gems=gems-1 end end
end
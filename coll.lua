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

function water_coll(plr)
    for k,tile in pairs(tiles) do
        if tile.id==13 and AABB(tile.x+4,tile.y+6,8,8,plr.x,plr.y,plr.w,plr.h) then
            waterfall_idea=true
            plr.swimming=true
            break
        end
    end
    for k,tile in pairs(tiles) do
        if tile.id==13 and AABB(tile.x,tile.y,16,16,plr.x,plr.y,plr.w,plr.h) then
            plr.dy=plr.dy+0.085
            --new_idea('waterfall')
            return true
        end
    end
    return false
end

function sprite_coll(plr,enter,down,up)
    for i=#sprites,1,-1 do
        local s=sprites[i]
        if s.id==14 and switch[1] and AABB(s.x+3,s.y+3,16-6,16-6,plr.x,plr.y,plr.w,plr.h) then
            new_idea('gem')
            gems=gems+1
            if not end_t then--cur_level~='LEVEL4.LVL' then
            total_gems=total_gems+1
            end
            table.remove(sprites,i)
        end
        if s.id==18 and switch[2] and AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) and s.flip then
            backdoor_idea=true
        end
        if s.id==18 and switch[2] and AABB(plr.x-2-8,plr.y-4-8,16*2,16*2,s.x+8,s.y+8,1,1) then
            new_idea('exit') 
        end
        if s.id==18 and switch[2] and not s.tgt and (enter or up) and AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) then
            new_idea('noexit')
        end
        --if s.id==18 and (not s.flip or (s.flip and (enter or plr.exited))) and AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) and not plr.onground then
        --    new_idea('gndexit')
        --end
        if s.id==18 and switch[2] and (enter or up or plr.exited) and s.tgt --[[and plr.onground]] and AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) then
            for i2,s2 in ipairs(sprites) do
                if s2.id==17 and s2~=plr and s2.exited~=s and (not s2.dead or (s2.dead and t-s2.dead<30)) then
                    if not plr.exited then
                        save_state()
                    end
                    multiexit=true
                    plr.exited=s
                    plr.x=s.x+2; plr.y=s.y+4
                    return
                end
            end

            --plr.immune=s.tgt

            if multiexit then
                for i2,s2 in ipairs(sprites) do
                    if s2.id==17 then s2.exited=nil end
                end
            end

            if cur_level=='PIADRANE.LVL' then
                love.update=YNmodal
                YNtgt=s.tgt
                YNplr=plr
                if YNtgt=='LEVEL0.LVL' then
                    YNmsg='Want to start a new game? Y/N'
                    -- if has been visited already
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
        if s.id==20 and switch[2] then
            if AABB(plr.x,plr.y,plr.w,plr.h,s.x,s.y+10,16,6) then
                die(plr)
            end
        end
        if s.id==15 and switch[1] then
            if AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) then
                table.remove(sprites,i)
                jetpack=true
                new_idea('jetpack')
                fuel=fuel+0.5
                if fuel>1 then fuel=1 end
            end
        end
        if s.id==16 and switch[4] then
            if AABB(s.x,s.y,16,16,plr.x,plr.y,plr.w,plr.h) then
                table.remove(sprites,i)
                drill=true
                new_idea('drill')
                fuel=fuel+0.5
                if fuel>1 then fuel=1 end
            end
        end
        if s.id==19 and switch[2] then
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
                if down or up then
                    switch[s.color]=not switch[s.color]
                end
            end
        end
    end

    --[[if plr.immune then
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
    end]]
end

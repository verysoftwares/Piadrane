tiles={}
newtiles={}
sprites={}
water_tiles={}
editmode=true
switch_col=1

function edit()
    if sel==21 and tapped('r') then switch_col=switch_col+1; if switch_col>4 then switch_col=1 end end

    if sel and left and --[[not AABB(320-19,17,19,200-16-17+1,mox,moy,1,1)]] mox<320-20 and moy<200-8 then
        if sel==0 then
            local tile=tiles[posstr(mox/16,moy/16)]
            if tile then
                if not editmode then save_state(); gems=gems-1; new_idea('undo'); sel=nil end

                tiles[posstr(mox/16,moy/16)]=nil
                if tile.id>=1 and tile.id<=12 then
                if tiles[posstr(mox/16+1,moy/16)] and tiles[posstr(mox/16+1,moy/16)].id==tile.id then co_tile(mox+16,moy,tiles[posstr(mox/16+1,moy/16)].color,tiles[posstr(mox/16+1,moy/16)].id) end
                if tiles[posstr(mox/16-1,moy/16)] and tiles[posstr(mox/16-1,moy/16)].id==tile.id then co_tile(mox-16,moy,tiles[posstr(mox/16-1,moy/16)].color,tiles[posstr(mox/16-1,moy/16)].id) end
                if tiles[posstr(mox/16,moy/16+1)] and tiles[posstr(mox/16,moy/16+1)].id==tile.id then co_tile(mox,moy+16,tiles[posstr(mox/16,moy/16+1)].color,tiles[posstr(mox/16,moy/16+1)].id) end
                if tiles[posstr(mox/16,moy/16-1)] and tiles[posstr(mox/16,moy/16-1)].id==tile.id then co_tile(mox,moy-16,tiles[posstr(mox/16,moy/16-1)].color,tiles[posstr(mox/16,moy/16-1)].id) end
                elseif tile.id==13 then
                    for i,w in ipairs(water_tiles) do
                        if w.x==tile.x and w.y==tile.y then table.remove(water_tiles,i); break end
                    end
                end
            else
                local found=false
                for i,s in ipairs(sprites) do
                    if (s.id~=17 and s.x==mox and s.y==moy) or (s.id==17 and s.x==mox+2 and s.y==moy+4) then found=i; break end
                end
                if found then if not editmode then save_state(); gems=gems-1; new_idea('undo'); sel=nil end; 
                table.remove(sprites,found) 
                end
            end
        elseif sel>=1 and sel<=12 and (not tiles[posstr(mox/16,moy/16)]) then
            if not editmode then save_state(); gems=gems-1; new_idea('undo') end

            local color
            if sel>=1 and sel<=3 then color=green end
            if sel>=4 and sel<=6 then color=purple end
            if sel>=7 and sel<=9 then color=blue end
            if sel>=10 and sel<=12 then color=yellow end
            --local tid=(sel-1)%3+1
            co_tile(mox,moy,color,sel)

            if tiles[posstr(mox/16,moy/16-1)] and tiles[posstr(mox/16,moy/16-1)].id==sel and coroutine.status(tiles[posstr(mox/16,moy/16-1)].co)=='dead' then co_tile(mox,moy-16,color,tiles[posstr(mox/16,moy/16-1)].id) end
            if tiles[posstr(mox/16,moy/16+1)] and tiles[posstr(mox/16,moy/16+1)].id==sel and coroutine.status(tiles[posstr(mox/16,moy/16+1)].co)=='dead' then co_tile(mox,moy+16,color,tiles[posstr(mox/16,moy/16+1)].id) end
            if tiles[posstr(mox/16-1,moy/16)] and tiles[posstr(mox/16-1,moy/16)].id==sel and coroutine.status(tiles[posstr(mox/16-1,moy/16)].co)=='dead' then co_tile(mox-16,moy,color,tiles[posstr(mox/16-1,moy/16)].id) end
            if tiles[posstr(mox/16+1,moy/16)] and tiles[posstr(mox/16+1,moy/16)].id==sel and coroutine.status(tiles[posstr(mox/16+1,moy/16)].co)=='dead' then co_tile(mox+16,moy,color,tiles[posstr(mox/16+1,moy/16)].id) end

            if not editmode then sel=nil end
        elseif sel==13 then
            local tile=tiles[posstr(mox/16,moy/16)]
            if not tile then
                if not editmode then save_state(); gems=gems-1; new_idea('undo'); sel=nil end
                table.insert(water_tiles,{mox,moy})
                co_water(mox,moy)
            end
        elseif sel>13 then
            local found=false
            for i,s in ipairs(sprites) do
                if (s.id~=17 and s.x==mox and s.y==moy) or (s.id==17 and s.x==mox+2 and s.y==moy+4) then found=i; break end
            end
            if editmode and sel==18 and found and sprites[found].id==18 then
                love.update=namefile
                file_io=function(savefile)
                    sprites[found].tgt=savefile
                end
            end
            if not found then
                if not editmode then save_state(); gems=gems-1; new_idea('undo') end
                local offx,offy=0,0
                if sel==17 then offx,offy=2,4 end
                if sel~=21 then table.insert(sprites,{x=mox+offx,y=moy+offy,id=sel,visible=true})
                else table.insert(sprites,{x=mox+offx,y=moy+offy,id=sel,visible=true,color=switch_col}) end
                if sel==17 then
                    sprites[#sprites].w=12
                    sprites[#sprites].h=12
                    sprites[#sprites].dx=0
                    sprites[#sprites].dy=0
                    for i2,s2 in ipairs(sprites) do
                        if s2.id==17 and i2~=#sprites then
                            sprites[#sprites].dummy=true
                            break
                        end
                    end
                end
                if not editmode then sel=nil end
            end
        end
    end
    for k,tile in pairs(tiles) do
        --tile_render(tile)
    end
    if not editmode and gems==0 then sel=nil end
end

function render_sidebar()
    offx=offx or 18
    if not editmode and gems==0 then offx=offx+(18-offx)*0.1
    else offx=offx+(0-offx)*0.1 end
    
    purple(3)
    local amt=gems
    if editmode then
        amt=99
    end
    love.graphics.print(amt,offx+320-9-fn:getWidth(amt)/2,4)

    purple(0)
    line(offx+320,16,offx+320-19,16)
    line(offx+320-20,17,offx+320-20,200-16+1)
    line(offx+320,200-16+1,offx+320-19,200-16+1)
    purple(1)
    rect('fill',offx+320-19,17,19,200-16-17+1)
    local i=0
    local uq=unique_objs()
    local sort_uq={}
    for k,tru in pairs(uq) do
        table.insert(sort_uq,k)
    end
    table.sort(sort_uq,function(a,b) return a<b end)
    suq_i=suq_i or 1
    local hilight
    for j=suq_i,suq_i+8 do
        local u=sort_uq[j]
        if not u then break end
        purple(0)
        rect('line',offx+320-19+1,17+6+1+i*17,18,18)
        --love.graphics.print(u,320-19+1,17+1+i*17)
        draw_id(u,offx+320-19+1+1,17+6+1+i*17+1)
        if AABB(mox,moy,1,1,offx+320-19+1+1,17+6+1+i*17+1,18-2,18-2) then
            hilight=i
            if left and not leftheld then sel=u end
        end
        i=i+1
    end
    scroll_hover=false
    if suq_i>1 then 
        purple(3)
        rect('fill',offx+320-19,17,19,6)
        if AABB(offx+320-19,17,19,6,mox,moy,1,1) then
            scroll_hover=true
            if left and not leftheld then
                suq_i=suq_i-1
            end
        end
        purple(2)
        line(offx+320-19+6-2-1+1,17+6-1,offx+320-19+12-2-1,17)
        line(offx+320-19+6-2-1+12,17+6,offx+320-19+12-2-1,17)
    end
    if #sort_uq>suq_i+8 then 
        purple(3)
        rect('fill',offx+320-19,200-16-17+11+1,19,6)
        if AABB(offx+320-19,200-16-17+11+1,19,6,mox,moy,1,1) then
            scroll_hover=true
            if left and not leftheld then
                suq_i=suq_i+1
            end
        end
        purple(2)
        line(offx+320-19+6-2-1+1,200-16-17+11+1,offx+320-19+12-2-1+1,200-16-17+11+1+6)
        line(offx+320-19+6-2-1+12,200-16-17+11+1-1,offx+320-19+12-2-1,200-16-17+11+1+6-1)
    end
    if hilight then 
        purple(3)
        rect('line',offx+320-19+1,17+6+1+hilight*17,18,18)
    end
end

function unique_objs()
    local out={[0]=true}
    if editmode then
        for i=1,21 do out[i]=true end
        return out
    end

    for k,tile in pairs(tiles) do
        if tile.id then
        out[tile.id]=true
        end
    end
    if loaded then
    for i,s in ipairs(sprites) do
        if s.visible and not s.dead then out[s.id]=true end
    end
    end
    return out
end


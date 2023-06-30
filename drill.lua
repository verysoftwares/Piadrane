function drill_active()
    return drill and (not switch[7] and (press('lctrl') or press('rctrl')) or (switch[7] and press('x')))
end

function use_drill(plr)
    if ((not switch[7] and (press('lctrl') or press('rctrl'))) or (switch[7] and press('x'))) and fuel>0 then
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
                local cid=math.floor((drilled.id-1-1)/3)
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

function fly(plr)
    if ((not switch[7] and (press('lalt') or press('ralt'))) or (switch[7] and press('z') and not zhold)) then
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

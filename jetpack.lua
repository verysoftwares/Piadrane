function jetpack_hover()
    return jetpack and (press('lalt') or press('ralt')) and press('down')
end

function jetpack_active()
    return jetpack and (not switch[7] and (press('lalt') or press('ralt')) or (switch[7] and press('z') and not zhold))
end

function fly(plr)
    if jetpack_active() then
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

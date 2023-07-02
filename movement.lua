function move_x(plr)
    plr.x=plr.x+plr.dx
    plr.dx=plr.dx*0.85
    xcoll(plr)
end

function move_y(plr)
    plr.y=plr.y+plr.dy
    if not jetpack_hover() and not drill_active() then
    plr.dy=plr.dy+0.2
    end
    plr.onground=false
    ycoll(plr)
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

function jump_input()
    return (not switch[7] and (press('lalt') or press('ralt'))) or (switch[7] and press('z') and not zhold)
end

function jump(plr)
    if jump_input() and plr.onground then
        plr.dy=plr.dy-4
    end
end
function vgm(filename)
    love.vgm.VgmLoad('MUSIC/'..filename..'.vgm')
    play_t=love.timer.getTime()/100
    playing=filename..'.vgm'
    love.vgm.VgmPlay()
end

function playmusic(filename,ingame)
    if filename=='PIADRANE.LVL' then
        vgm('piadrane')
        play_len=4.28*2
    end
    if filename=='CREDITS.LVL' then
        vgm('credits')
        play_len=4.28
    end
    if playing~='lvlearly.vgm' and string.sub(filename,1,5)=='LEVEL' and string.sub(filename,6,6)~='4' then
        vgm('lvlearly')
        play_len=4.28*4
    end
    if filename=='LEVEL4.LVL' then
        vgm('congrats')
        play_len=4.28*2
    end
end

function loop_music()
    if play_t and love.timer.getTime()/100-play_t>=play_len then
        play_t=love.timer.getTime()/100
        --love.vgm.VgmStop()
        love.vgm.VgmPlay()
    end
end
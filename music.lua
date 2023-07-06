function vgm(filename)
    if filename..'.vgm'==playing then return end
    love.vgm.VgmLoad('MUSIC/'..filename..'.vgm')
    play_t=love.timer.getTime()/100
    playing=filename..'.vgm'
    love.vgm.VgmPlay()
end

function playmusic(filename)
    if filename=='PIADRANE.LVL' then
        vgm('piadrane')
        play_len=4.28*2*2
    end
    if filename=='CREDITS.LVL' then
        vgm('credits')
        play_len=4.28*2
    end
    if filename=='OPTIONS.LVL' then
        vgm('congrats')
        play_len=4.28*2*2
    end
    if string.sub(filename,1,5)=='LEVEL' and tonumber(string.sub(filename,6,6))<3 then
        vgm('lvlearly')
        play_len=4.28*4*2
    end
    if filename=='LEVEL5.LVL' or filename=='LEVEL3.LVL' or filename=='LEVEL6.LVL' or filename=='LEVEL7.LVL' then
        vgm('lvlmid')
        play_len=4.28*5*2
    end
    if filename=='LEVEL8.LVL' then
        vgm('dapfall3')
        play_len=3.58*6*2
    end
    if filename=='NEWIDEA' then
        vgm('newidea')
        play_len=4.28*2*2
    end
    if filename=='MAP' then
        vgm('map')
        play_len=4.28*2*2
    end
    if filename=='LEVEL4.LVL' then
        vgm('piaswing')
        play_len=3.57*2*2
    end
end

function loop_music()
    if play_t and love.timer.getTime()/100-play_t>=play_len then
        play_t=love.timer.getTime()/100
        --love.vgm.VgmStop()
        love.vgm.VgmPlay()
    end
end
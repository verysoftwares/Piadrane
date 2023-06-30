DEBUG=true

require 'alias'
require 'utility'
require 'init'
require 'file-io'
require 'edit'
require 'draw'
require 'update'
require 'corouts'
require 'idea'
require 'music'
require 'color'

function love.keypressed(key)
    if key == "escape" then
        if love.update==mainupdate then
            love.event.quit()
        elseif love.update==ideascreen then
            love.update=mainupdate
            love.draw=maindraw
            playmusic(cur_level)
        end
    end
    if key=='f1' and #idea_order>0 and not switch[5] then
        if love.update==mainupdate then
            love.update=ideascreen
            love.draw=ideadraw
            -- skip to first unread
            for i,v in ipairs(idea_order) do if not idea_db[v].read then idea_order.i=i; break end end
            playmusic('NEWIDEA')
        elseif love.update==ideascreen then
            love.update=mainupdate
            love.draw=maindraw
            playmusic(cur_level)
        end
    end
    if love.update==namefile then
        if #key==1 and #savefile<8 then
            savefile=savefile..string.upper(key)
        end
        if key=='backspace' and #savefile>0 then
            savefile=string.sub(savefile,1,#savefile-1)
        end
        if key=='return' and #savefile>0 then
            file_io(savefile..'.LVL')
            love.update=mainupdate
        end
    end
    if love.update==YNmodal then
        if YNmsg=='Too bad, because there aren\'t any!' then 
            if key=='y' or key=='n' or key=='up' or key=='down' or key=='left' or key=='right' then YNplr.immune=YNtgt; love.update=mainupdate end
        end
        if key=='y' then
            if YNtgt=='LEVEL0.LVL' then start_t=t end
            if YNtgt=='QUIT.LVL' then love.event.quit(); return end
            --if YNtgt=='OPTIONS.LVL' then YNmsg='Too bad, because there aren\'t any!'; return end 
            YNplr.immune=YNtgt
            load_level(YNtgt,true) 
            love.update=mainupdate
        end
        if key=='n' then YNplr.immune=YNtgt; love.update=mainupdate end
    end
end

love.update=mainupdate
love.draw=maindraw
--idea_i=1

idea_order={i=1}

function new_idea(name)
    if idea_db[name].canvas then return end

    idea_db[name].canvas=lg.newCanvas(16*3,16*3)
    --idea_db[name].i=idea_i
    --idea_i=idea_i+1
    table.insert(idea_order,name)

    local screen=love.graphics.getCanvas()
    love.graphics.setCanvas(idea_db[name].canvas)
    if name~='flames' then
        love.graphics.draw(screen,-sprites[#sprites].x+16+2,-sprites[#sprites].y+16+4) 
    elseif name=='flames' then
        for i,s in ipairs(sprites) do
        if s.id==17 and s.dummy and s.dead then
        love.graphics.draw(screen,-s.x+16+2,-s.y+16+4) 
        end
        end
    end
    love.graphics.setCanvas()
end

function ideascreen()
    general_update()

    if tapped('left')  then idea_order.i=idea_order.i-1; if idea_order.i<1 then idea_order.i=#idea_order end end
    if tapped('right') then idea_order.i=idea_order.i+1; if idea_order.i>#idea_order then idea_order.i=1 end end

    t=t+1
end

function ideadraw()
    blue(1)
    love.graphics.rectangle('fill',0,0,320,200)

    blue(0)
    for rx=0,320-16,16 do for ry=0,200,16 do
        if ((rx/16)+(ry/16))%2==0 or ((rx/16)+(ry/16))%4==1 then
            rect('fill',rx,ry,16,16)
        end
    end end

    fg(0.75*255,0.75*255,0.75*255)
    rect('fill',0,0,320,12)
    rect('fill',0,200-12,320,12)
    
    fg(0.95*255,0.95*255,0.95*255)
    local msg=string.format('Pia\'s Ideas (%d of %d)',idea_order.i,#idea_order)
    love.graphics.print(msg,320/2-fn:getWidth(msg)/2,0-1+2)
    local msg='Left/Right to navigate, F1 to return to game.'
    love.graphics.print(msg,320/2-fn:getWidth(msg)/2,200-8-1-2)

    local cur_idea=idea_db[idea_order[idea_order.i]]
    love.graphics.setCanvas()
    fg(0.95*255,0.95*255,0.95*255)
    love.graphics.rectangle('line',24-2,24-2+12,16*3+2*2,16*3+2*2)
    love.graphics.draw(cur_idea.canvas,24,24+12)
    local words={}
    for w in cur_idea.msg:gmatch('%S+') do table.insert(words,w) end
    cur_idea.wordi=cur_idea.wordi or 1
    cur_idea.wordt=cur_idea.wordt or t
    local tx,ty=0,0
    for i=1,math.min(cur_idea.wordi,#words) do
        if i==cur_idea.wordi and cur_idea.wordi<=#words then
            purple(math.floor((t-cur_idea.wordt)/2))
            love.graphics.print(words[i],24+16*3+12+tx,24+12+12+ty+8-(t-cur_idea.wordt))
            if t-cur_idea.wordt>=8 then
                cur_idea.wordt=t
                cur_idea.wordi=cur_idea.wordi+1
                if cur_idea.wordi>#words then
                    cur_idea.read=true
                end
            end
        else
            purple(3)
            love.graphics.print(words[i],24+16*3+12+tx,24+12+ty+12)
        end
        tx=tx+fn:getWidth(words[i]..' ')
        if i<#words and tx+fn:getWidth(words[i+1])>=320-16*3-12-24*2 --[[or words[i]=='\n']] then tx=0; ty=ty+10 end
    end

    while love.timer.getTime()/100-start_t<1/90 do
    end
end

function unread_ideas()
    local out=0
    for k,v in pairs(idea_db) do
        if v.canvas and not v.read then
            out=out+1
        end
    end
    return out
end

idea_db={
    ['walk']={msg='This is me, Pia! I can use the arrow keys to move around!'},
    ['jump']={msg='The Alt key makes me all jumpy!'},
    ['waterfall']={msg='I can swim up waterfalls with the Up key! Or travel really fast down, like nyyooomm'},
    ['exit']={msg='That\'s a level exit! These will take me to new and interesting places.'},
    ['backdoor']={msg='I can use this flipped exit to backtrack to the previous level, by pressing Enter on top of it.'},
    ['return']={msg='So if I return to a previous level, I will continue from where I left off.'},
    ['toohigh']={msg='Hmm, this wall is too high to jump over. There\'s gotta be another way...'},
    ['gem']={msg='I\'ve collected a gem! It is a magical artifact allowing me to place or remove tiles. But be careful, it\'s one-use only! Just use the mouse to select a tile from the sidebar and click anywhere to place it.'},
    ['undo']={msg='Press Ctrl+Z to undo a tile placement.'},
    ['flames']={msg='Whoa, that other dino just fell into the flames below! I must be careful not to do the same, I want my pixels to stay intact.'},
    ['jetpack']={msg='I got the jetpack! Now I can fly with Alt. But I\'d better be mindful of the fuel meter at the bottom of the screen.'},
    ['drillwant']={msg='If only I had the drill, I would be able to remove these checkerboard tiles. But I can\'t reach it... What do I do now?'},
    ['drill']={msg='There we go, drill unlocked! Ctrl+arrows to use. It consumes fuel just like the jetpack.'},
    ['fuel']={msg='That\'s a fuel cell, replenishing half of the fuel meter. I should keep track of fuel cell locations so I can pick them up when I need them.'},
}
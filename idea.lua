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
    if 1 then
    love.graphics.draw(screen,-sprites[#sprites].x+16+2,-sprites[#sprites].y+16+4) 
    else end
    love.graphics.setCanvas()
end

idea_db={
    ['walk']={msg='This is me, Pia! I can use the arrow keys to move around!'},
    ['jump']={msg='The Alt key makes me all jumpy!'},
    ['waterfall']={msg='I can swim up waterfalls with the Up key! Or travel really fast down, like nyyooomm'},
}

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
    rect('fill',0,0,320,8)
    rect('fill',0,200-8,320,8)
    
    fg(0.95*255,0.95*255,0.95*255)
    local msg='Pia\'s Ideas'
    love.graphics.print(msg,320/2-fn:getWidth(msg)/2,0-1)
    local msg='Left/Right to navigate, F1 to return to game.'
    love.graphics.print(msg,320/2-fn:getWidth(msg)/2,200-8-1)

    local cur_idea=idea_db[idea_order[idea_order.i]]
    love.graphics.setCanvas()
    fg(0.95*255,0.95*255,0.95*255)
    love.graphics.rectangle('line',24-2,24-2+8,16*3+2*2,16*3+2*2)
    love.graphics.draw(cur_idea.canvas,24,24+8)
    local words={}
    for w in cur_idea.msg:gmatch('%S+') do table.insert(words,w) end
    cur_idea.wordi=cur_idea.wordi or 1
    cur_idea.wordt=cur_idea.wordt or t
    local tx,ty=0,0
    for i=1,math.min(cur_idea.wordi,#words) do
        if i==cur_idea.wordi and cur_idea.wordi<=#words then
            purple(math.floor((t-cur_idea.wordt)/2))
            love.graphics.print(words[i],24+16*3+12+tx,24+8+12+ty+8-(t-cur_idea.wordt))
            if t-cur_idea.wordt>=8 then
                cur_idea.wordt=t
                cur_idea.wordi=cur_idea.wordi+1
                if cur_idea.wordi>#words then
                    cur_idea.read=true
                end
            end
        else
            purple(3)
            love.graphics.print(words[i],24+16*3+12+tx,24+12+ty+8)
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
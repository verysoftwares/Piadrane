savefile=''
function namefile()
    general_update()
end

function save_level(filename)
    local sort_tiles={}
    for k,tile in pairs(tiles) do table.insert(sort_tiles,tile) end
    table.sort(sort_tiles,function(a,b) return a.i<b.i end)

    local out=''
    out=out..'newtiles={\n'
    for i,tile in ipairs(sort_tiles) do
        if tile.id~=13 then
        out=out..string.format('{%d,%d,%d},',tile.x,tile.y,tile.id)
        end
    end
    out=string.sub(out,1,#out-1)
    out=out..'\n}\n'

    out=out..'water_tiles={\n'
    for i,tile in ipairs(water_tiles) do
        out=out..string.format('{%d,%d},',tile[1],tile[2])
    end
    out=string.sub(out,1,#out-1)
    out=out..'\n}\n'

    out=out..'sprites={\n'
    for i,sp in ipairs(sprites) do
        if sp.id~=21 and sp.id~=17 and (sp.id~=18 or (sp.id==18 and not sp.tgt)) then
        out=out..string.format('{x=%d,y=%d,id=%d},',sp.x,sp.y,sp.id)
        elseif sp.id==18 and sp.tgt then
        out=out..string.format('{x=%d,y=%d,id=%d,tgt=\'%s\'},',sp.x,sp.y,sp.id,sp.tgt)
        elseif sp.id==17 then
        out=out..string.format('{x=%d,y=%d,id=%d,w=12,h=12,dx=0,dy=0},',sp.x,sp.y,sp.id)
        elseif sp.id==21 then
        out=out..string.format('{x=%d,y=%d,id=%d,color=%d},',sp.x,sp.y,sp.id,sp.color)
        end
    end
    out=string.sub(out,1,#out-1)
    out=out..'\n}\n'

    --out=out..string.format('plr.x=%d; plr.y=%d',plr.x,plr.y)

    love.filesystem.write(filename,out)
end

function load_level(filename,ingame)
    if not love.filesystem.exists(filename) then
        return
    end
    
    if cur_level then
        cache_level(cur_level)
    end
    
    states={}
    saved=false
    if levels[filename] then
        uncache_level(filename)
        return_idea=true
    else
        loadstring(love.filesystem.read(filename))()
        if filename~='PIADRANE.LVL' and ingame then
            local toadd={}
            for i,sp in ipairs(sprites) do
                if sp.id==17 and not sp.dummy then
                table.insert(toadd,{x=sp.x-2,y=sp.y-4,id=18,tgt=cur_level,flip=true})
                end
            end
            for i,v in ipairs(toadd) do
                local avail=true
                for i,sp in ipairs(sprites) do
                    if sp.id==18 and sp.flip and sp.x==v.x and sp.y==v.y then
                        avail=false
                        break
                    end
                end
                if avail then
                table.insert(sprites,1,v)
                end
            end
        end
        test_co=nil
        wf_coroutine=nil
        loaded=false
        spriteloaded=false
        tiles={}
    end

    playmusic(filename)

    editmode=not ingame
    suq_i=nil
    cur_level=filename
end

levels={}
function cache_level(filename)
    levels[filename]={tiles={},sprites={},water_tiles={}}
    for k,tile in pairs(tiles) do
        local out={}
        for l,v in pairs(tile) do
            out[l]=v
        end
        levels[filename].tiles[k]=out
    end
    for i,wt in ipairs(water_tiles) do
        local out={}
        for l,v in pairs(wt) do
            out[l]=v
        end
        levels[filename].water_tiles[i]=out
    end
    for i,sp in ipairs(sprites) do
        local out={}
        for l,v in pairs(sp) do
            out[l]=v
        end
        levels[filename].sprites[i]=out
    end
end

function uncache_level(filename)
    tiles=levels[filename].tiles
    sprites=levels[filename].sprites
    water_tiles=levels[filename].water_tiles
end

states={}

function save_state()
    table.insert(states,{tiles={},sprites={}})
    local state=states[#states]
    for k,tile in pairs(tiles) do
        local out={}
        for l,v in pairs(tile) do
            out[l]=v
        end
        state.tiles[k]=out
    end
    for i,sp in ipairs(sprites) do
        local out={}
        for l,v in pairs(sp) do
            out[l]=v
        end
        state.sprites[i]=out
    end
    state.cur_level=cur_level
    state.fuel=fuel
    state.gems=gems
end

function load_state()
    if #states==0 then return end
    local state=states[#states]
    --newtiles=state.newtiles
    tiles=state.tiles
    sprites=state.sprites
    cur_level=state.cur_level
    playmusic(cur_level)
    fuel=state.fuel
    gems=state.gems
    newtiles={}
    water_tiles={}
    test_co=nil
    wf_coroutine=nil
    loaded=false
    spriteloaded=false

    table.remove(states,#states)
    if #states==0 then save_state() end
    --saved=false
end
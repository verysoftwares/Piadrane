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
        if sp.id~=17 and (sp.id~=18 or (sp.id==18 and not sp.tgt)) then
        out=out..string.format('{x=%d,y=%d,id=%d},',sp.x,sp.y,sp.id)
        elseif sp.id==18 and sp.tgt then
        out=out..string.format('{x=%d,y=%d,id=%d,tgt=\'%s\'},',sp.x,sp.y,sp.id,sp.tgt)
        elseif sp.id==17 then
        out=out..string.format('{x=%d,y=%d,id=%d,w=12,h=12,dx=0,dy=0},',sp.x,sp.y,sp.id)
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
    
    if levels[filename] then
        uncache_level(filename)
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
        editmode=not ingame
        tiles={}
    end
    
    playmusic(filename,ingame)

    cur_level=filename    
    suq_i=nil
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
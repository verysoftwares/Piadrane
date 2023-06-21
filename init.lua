t=0
gems=0

tiles={}

loaded=false

function love.load()
    sprsheet=love.graphics.newImage('jetedits.png')
    jp_quad=love.graphics.newQuad(2*16,0,16,16)
    dr_quad=love.graphics.newQuad(1*16,0,16,16)
    wf_quad=love.graphics.newQuad(5*16,0,16,16)
    ex_quad=love.graphics.newQuad(8*16,0,16,16)
    m1_quad=love.graphics.newQuad(5*16,1*16,16,16)
    m2_quad=love.graphics.newQuad(6*16,1*16,16,16)
    fu_quad=love.graphics.newQuad(3*16,0,16,16)
    fi_quad1=love.graphics.newQuad(6*16,0,16,16)
    fi_quad2=love.graphics.newQuad(6*16,2*16,16,16)
    dr_quad2=love.graphics.newQuad(5*16,2*16,16,16)

    dinosheet=love.graphics.newImage('dino.png')
    dinosolo=love.graphics.newImage('dinosolo.png')
    dn_quad1=love.graphics.newQuad(0*16,1*16,16,16)
    dn_quad2=love.graphics.newQuad(1*16,1*16,16,16)
    dn_quad3=love.graphics.newQuad(2*16,1*16,16,16)
    dn_quad4=love.graphics.newQuad(3*16,1*16,16,16)

    for i=1,4 do
    _G['gem_quad'..tostring(i)]=love.graphics.newQuad(4*16,(i-1)*16,16,16)
    end
end

--plr={x=16*6,y=16*7-16*6+4,w=12,h=12,dx=0,dy=0}
sprites={
    {x=16*8-16,y=16*2},
    {x=16*8-16+16,y=16*2+16},
    {x=16*5,y=16*2},
    {x=16*5-16,y=16*2+16},
    {x=16*9,y=16},
    {x=16*11,y=16},
    {x=16*10,y=0},
    {x=16*13,y=16*8},
    {x=16*15,y=16*8},
    {x=16*14,y=16*7},

    {x=16*6,y=16*7,id=15},
    {x=16*14,y=16*3,id=16},
    {x=16*6+2,y=16*7-16*6+4,id=17,w=12,h=12,dx=0,dy=0},
}
for i,s in ipairs(sprites) do if not s.id then s.id=14 end; s.visible=false end
newtiles={{16*8,16*4,1},{16*7,16*4,1},{16*6,16*4,1},{16*5,16*4,1},{16*7,16*5,1},{16*6,16*5,1},{16*6,16*6,1},{16*5,16*5,1},{16*7,16*3,1},{16*6,16*3,1},{16*6,16*2,1},{16*5,16*3,1},{16*4,16*4,1},{16*9,16*2,1},{16*10,16*2,1},{16*11,16*2,1},{16*10,16*1,1},{16*10,16*3,1},{16*9,16*6,1},{16*10,16*6,1},{16*11,16*6,1},{16*10,16*5,1},{16*10,16*7,1},{16*6,16*8,1},{16*5,16*8,1},{16*4,16*8,1},{16*7,16*8,1},{16*8,16*8,1},{16*6,16*9,1},{16*5,16*9,1},{16*7,16*9,1},{16*6,16*10,1},{16*13,16*5,2},{16*14,16*5,2},{16*15,16*5,2},{16*14,16*4,2},{16*14,16*6,2},{16*15,16*6,2},{16*14,16*9,3},{16*15,16*9,3},{16*13,16*9,3},{16*14,16*8,3},{16*14,16*10,3}}

water_tiles={{16*8,16*5},{16*8,16*1},{16*13,16*1},{16*12,16*4},{16*9,16*3}}

--jetpack=true
fuel=1
fuel_consume=0.00125
--drill=true
drill_spd=0.04
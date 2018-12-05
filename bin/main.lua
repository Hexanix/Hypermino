-- Package.Path edit
package.path = package.path .. ';scripts/?.lua' 
package.path = package.path .. ';scripts/externalLibs/?.lua'

require("mobdebug").start()

module = {}

-- Module requiring and inserting

    -- Map module
    module["mapModule"] = require("mapscript")
    
    -- Graphics Module
    module["graphModule"] = require("graphicscript")

    -- Player Module
    module["playerModule"] = require("playerscript")

    -- Block Module
    module["multiminoModule"] = require("multiminoscript")


    -- EXTERNAL LIBRARIES

    -- Button Module (Dabutton)
    module["buttonModule"] = require("dabutton")
    


-- Some general tables
gameStates = { [1] = "menu", [2] = "game", [0] = "exit"}
currentGameStateID = 1

timerTable = {}
timerTable.blockSpawnTimer = 3

--player = {tilemap_x = 1, tilemap_y = 1, map, grid_x = 0, grid_y = 0, real_x = 0, real_y = 0, img = nil, playerID = 1}
playersTable = {}

-- Idea for multiple tilemaps to serve different functions
tilemapTable = {}
tilemapTable.tilemapGraphics = {}
tilemapTable.tilemapCollision = {}

controlTable_1 = {["up"] = "up", ["left"] = "left", ["down"] = "down", ["right"] = "right"}
--controlTable_2 = {["up"] = "w", ["left"] = "a", ["down"] = "s", ["right"] = "d"} -- 2 player character


-- Control handling

function love.keypressed(key)

    for i = 1, #playersTable do
        if key == playersTable[i].controlTable["down"] and playersTable[i].tilemap_collision_y ~= module["mapModule"].vars.dims.rows  then
            if module["mapModule"].colTable.down[tilemapTable.tilemapCollision[playersTable[i].tilemap_collision_x][playersTable[i].tilemap_collision_y + 1].type]~= true then
                module["playerModule"].player_tilemapPos_update(playersTable[i], 0, 1, tilemapTable.tilemapCollision)
            end 
        end 

        if key == playersTable[i].controlTable["up"] and playersTable[i].tilemap_collision_y ~= 1 then
            if module["mapModule"].colTable.up[tilemapTable.tilemapCollision[playersTable[i].tilemap_collision_x][playersTable[i].tilemap_collision_y - 1].type] ~= true then
                module["playerModule"].player_tilemapPos_update(playersTable[i], 0, -1, tilemapTable.tilemapCollision)
            end
        end

        if key == playersTable[i].controlTable["left"] and playersTable[i].tilemap_collision_x ~= 1 then
            if module["mapModule"].colTable.left[tilemapTable.tilemapCollision[playersTable[i].tilemap_collision_x - 1][playersTable[i].tilemap_collision_y].type] ~= true then
                module["playerModule"].player_tilemapPos_update(playersTable[i], -1, 0, tilemapTable.tilemapCollision)
            end
        end

        if key == playersTable[i].controlTable["right"] and playersTable[i].tilemap_collision_x ~= module["mapModule"].vars.dims.columns then
            if module["mapModule"].colTable.right[tilemapTable.tilemapCollision[playersTable[i].tilemap_collision_x + 1][playersTable[i].tilemap_collision_y].type] ~= true then
                module["playerModule"].player_tilemapPos_update(playersTable[i], 1, 0, tilemapTable.tilemapCollision)
            end
        end
    end
end 


function love.load( ... )      
    module["graphModule"].sprites.characters.player_1 = love.graphics.newImage("assets/player1.png")
    module["graphModule"].sprites.characters.player_2 = love.graphics.newImage("assets/player2.png")

    module["graphModule"].sprites.map_tiles.Corner = love.graphics.newImage("assets/tile-corner.png")
    module["graphModule"].sprites.map_tiles.Wall = love.graphics.newImage("assets/tile-wall.png")
    module["graphModule"].sprites.map_tiles.Center = love.graphics.newImage("assets/tile-center.png")

    module["graphModule"].sprites.blocks.Standard = love.graphics.newImage("assets/block.png")
    -- Debug helpers below
    module["graphModule"].sprites.blocks.StandardLead = love.graphics.newImage("assets/blockLead.png")
    module["graphModule"].sprites.blocks.StandardPassed = love.graphics.newImage("assets/blockPassed.png")

     
    -- Multimino Test setup
    --module["multiminoModule"].multimino_generate(4, nil, 2, 4, nil, module["mapModule"].vars,  module["graphModule"].sprites.blocks.Standard, module["graphModule"].sprites.blocks.StandardLead)
    --module["multiminoModule"].multimino_generate(4, nil, 2, 1, nil, module["mapModule"].vars,  module["graphModule"].sprites.blocks.Standard, module["graphModule"].sprites.blocks.StandardLead)

    -- Map Generation
    module["mapModule"].tilemap_generate_graphics(tilemapTable.tilemapGraphics, module["mapModule"].vars)
    module["mapModule"].tilemap_generate_collision(tilemapTable.tilemapCollision, module["mapModule"].vars)


    -- Player Setup
    playersTable[1] = module["playerModule"].new_player(1, 1, tilemapTable,   0, 0, module["graphModule"].sprites.characters.player_1, 1, controlTable_1)
    -- playersTable[2] = module["playerModule"].new_player(2, 2, tilemapTable,  64, 64, module["graphModule"].sprites.characters.player_2, 2, controlTable_2) - 2 player character


end 

function love.update(dt)
    module["mapModule"].tilemap_generate_collision(tilemapTable.tilemapCollision, module["mapModule"].vars)



    for i = 1, #playersTable do
        playersTable[i].real_x = playersTable[i].real_x - (playersTable[i].real_x - ( playersTable[i].tilemap_graphic_x - 1 )*64)*dt*30
        playersTable[i].real_y = playersTable[i].real_y - (playersTable[i].real_y - ( playersTable[i].tilemap_graphic_y - 1 )*64)*dt*30

        --Player position refresh.

        tilemapTable.tilemapCollision[playersTable[i].tilemap_collision_x][playersTable[i].tilemap_collision_y].type= "@"

        -- Multimino position refresh?
        module["multiminoModule"].multimino_tilemapPos_update(tilemapTable.tilemapCollision, module["mapModule"].vars.dims) 
        
    end

    module["multiminoModule"].lineCheck(tilemapTable.tilemapCollision, module["multiminoModule"].multiminoList, module["mapModule"].vars, playersTable) -- If LineCheck is under Update, score is added twice.
    module["multiminoModule"].multimino_update(dt, module["mapModule"].vars.dims, module["mapModule"].colTable, tilemapTable.tilemapCollision)
    

    if math.ceil( timerTable.blockSpawnTimer )  == 0 then
    randDir = love.math.random(1, 4)
    module["multiminoModule"].multimino_generate(4, 3, randDir, module["mapModule"].vars,
        module["graphModule"].sprites.blocks.Standard, module["graphModule"].sprites.blocks.StandardLead, module["graphModule"].sprites.blocks.StandardPassed)

          
    timerTable.blockSpawnTimer = 10
    end

    timerTable.blockSpawnTimer = timerTable.blockSpawnTimer - dt*3

end



function love.draw()
-- Test prints

    for i = 1, module["mapModule"].vars.dims.columns do
        for j = 1, module["mapModule"].vars.dims.rows do
            love.graphics.print(tilemapTable.tilemapGraphics[i][j], i*10, j*20)
        end
    end

    
    love.graphics.print("Number of multiminos: " .. #module["multiminoModule"].multiminoList, 600, 100)
   

    for i = 1, module["mapModule"].vars.dims.columns do
        for j = 1, module["mapModule"].vars.dims.rows do
            love.graphics.print(tilemapTable.tilemapCollision[i][j].type, i*10, j*20 + 300)
        end
    end

    love.graphics.print(tilemapTable.tilemapGraphics[playersTable[1].tilemap_graphic_y][playersTable[1].tilemap_graphic_x], 200, 200)
    love.graphics.print("Score: " .. playersTable[1].score, 300, 100 ) -- mock ScoreBoard 
    love.graphics.print(timerTable.blockSpawnTimer, 300, 300)

    -- Renders

    module["graphModule"].player_render(playersTable, module["mapModule"].vars)
    module["graphModule"].map_render(tilemapTable.tilemapGraphics, module["mapModule"].vars) -- Ive switched map and multimino to more precisely work on multimino
    module["graphModule"].multimino_render(module["multiminoModule"], module["mapModule"].vars)


    
end

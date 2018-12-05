-- Modules 
    module["multiminoModule"] = require("multiminoscript")


-- Table to return
graphModule = {}

-- Table to manage the types of sprites
graphModule.sprites = {}
    -- Map_Tiles
    graphModule.sprites.map_tiles = {Center, Wall, Corner}

    -- Blocks
    graphModule.sprites.blocks = {Standard, StandardLead, StandardPassed}
        
        
    -- Characters
    graphModule.sprites.characters = {player_1, player_2}



function graphModule.map_render(tilemap, tilemapVars)
    for i = 1, tilemapVars.dims.rows do
        for j = 1, tilemapVars.dims.columns do
            if tilemap[i][j] == 0 then
                  love.graphics.draw(graphModule.sprites.map_tiles.Center, tilemapVars.x_start + (j-1)*64, tilemapVars.y_start + (i-1)*64)
            elseif tilemap[i][j]%2 == 0 then
                    love.graphics.draw(graphModule.sprites.map_tiles.Wall, tilemapVars.x_start + (j-1)*64 + 32, tilemapVars.y_start + (i-1)*64 + 32, math.pi*(tilemap[i][j]/4), 1, 1, graphModule.sprites.map_tiles.Wall:getWidth()/2, graphModule.sprites.map_tiles.Wall:getHeight()/2)
            else 
                love.graphics.draw(graphModule.sprites.map_tiles.Corner, tilemapVars.x_start + (j-1)*64 + 32, tilemapVars.y_start + (i-1)*64 + 32, math.pi*((tilemap[i][j]+1)/4), 1, 1, graphModule.sprites.map_tiles.Corner:getWidth()/2, graphModule.sprites.map_tiles.Corner:getHeight()/2)
            end  
        end
    end
end

function graphModule.player_render(playersTable, tilemapVars)
    for i = 1, #playersTable do
        love.graphics.draw(playersTable[i].img, playersTable[i].real_x + tilemapVars.x_start + 1, playersTable[i].real_y + tilemapVars.y_start + 1)
    end
end

-- T

function graphModule.multimino_render(multiminoModule, tilemapVars)
    for i = 1, #multiminoModule.multiminoList do
        for j = 1, multiminoModule.multiminoList[i].properties.tileNum do
            love.graphics.print("x " .. multiminoModule.multiminoList[i].blocks[j].tilemap_x .. "  y " .. multiminoModule.multiminoList[i].blocks[j].tilemap_y,
                60*i, 10*j) 

                
            direction = multiminoModule.multiminoList[i].properties.direction
            dirMod = multiminoModule.directionModifiers[direction]
            block = multiminoModule.multiminoList[i].blocks[j]
            spawn_distance = (multiminoModule.multiminoList[i].properties.spawn_distance)

            -- left - alt y needs to be 0, x is 1
            -- up - alt x needs t be 0, y is 1

            if direction%2 ~= 0 then
                -- Vertical - direction works, spawn is fixed but I have no idea why it is I need all this weird subtraction. I think the starting position
                -- is a block down-right, idk tho. It's working, but it's botch af.
            love.graphics.draw(block.img,
            (block.x - 1)*64 - 4*dirMod.mx + tilemapVars.x_start + (tilemapVars.dims.columns)*64*dirMod.alt_x,
            (block.y - 2)*dirMod.my*64 - dirMod.alt_y*64 + tilemapVars.y_start  + (tilemapVars.dims.rows)*64*dirMod.alt_y)
            else
                -- Horizontal
            love.graphics.draw(block.img,
            (block.x - 2)*dirMod.mx*64 - dirMod.alt_x*64 + tilemapVars.x_start + (tilemapVars.dims.columns)*64*dirMod.alt_x,
            (block.y - 1)*64 - 4*dirMod.my + tilemapVars.y_start + (tilemapVars.dims.rows)*64*dirMod.alt_y )
            end

        end
    end
end

return graphModule
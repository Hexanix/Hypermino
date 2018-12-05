-- Module to take care of map generation and collision rules.

mapModule = {}

mapModule.vars = {}

mapModule.vars.dims = {rows = 4, columns = 4}

-- isRows/ColumnsOdd -  true = 32, false = 0

mapModule.vars.isRowsOdd = 0
mapModule.vars.isColumnsOdd = 0

-- graphic rows (col rows are same but +2 each dim)

mapModule.vars.x_start = (love.graphics.getWidth() - mapModule.vars.dims.columns*64)/2
mapModule.vars.y_start = (love.graphics.getHeight() - mapModule.vars.dims.rows*64)/2

function mapModule.updateDims(new_rows, new_cols)
    mapModule.vars.dims.rows = new_rows
    mapModule.vars.dims.columns = new_cols

    mapModule.vars.x_start = (love.graphics.getWidth() - new_cols*64)/2
    mapModule.vars.y_start = (love.graphics.getHeight() - new_rows*64)/2

    if mapModule.vars.dims.rows%2 ~= 0 then
        mapModule.vars.isRowsOdd = 32 
    else 
        mapModule.vars.isRowsOdd = 0
    end 

    if mapModule.vars.dims.columns%2 ~= 0 then
        mapModule.vars.isColumnsOdd = 32 
    else 
        mapModule.vars.isColumnsOdd = 0
    end 


end

-- Tile Legend:
    --[[
        Sprites:
            Walls:
                0 - n/a
                1 - Top-Left
                2 - Top
                3 - Top-Right
                4 - Right
                5 - Bottom-Right
                6 - Bottom
                7 - Bottom-Left
                8 - Left

        
        Collision:
            0 - Walkable
            1 - Wall/Normal Cube


    ]]

    -- Tables of tiles and collisions
        -- Directions of valid colision and types of tiles it applies to
mapModule.colTable = {}
-- This table is used to determine what is solid in what direction.
--[[
    @ = Player block.
    1 = Block in movement.
    2 = Block in stop.

]]

mapModule.colTable.down = {[1] = true, [2] = true, ["@"] = true}
mapModule.colTable.left = {[1] = true, [2] = true, ["@"] = true}
mapModule.colTable.up = {[1] = true, [2] = true, ["@"] = true}
mapModule.colTable.right = {[1] = true, [2] = true, ["@"] = true}

-- colTable Codes
-- References to these tables to be used by multiminoscript

mapModule.colTable.directionCode = {
    [3] = mapModule.colTable.up, 
    [4] = mapModule.colTable.right, 
    [1] = mapModule.colTable.down, 
    [2] = mapModule.colTable.left}

-- The tilemap consists of blank blocks.
function mapModule.tilemap_generate_collision(tilemapCollision, tilemapVars)
    for i = 1, tilemapVars.dims.rows  do
        tilemapCollision[i] = {}
        for j = 1, tilemapVars.dims.columns do 
            block = {type = 0, multimino_ID = 0}    
            tilemapCollision[i][j] = block
        end
    end
end

function mapModule.tilemap_generate_graphics(tilemapGraphics, tilemapVars)
    for i = 1, tilemapVars.dims.rows do
        tilemapGraphics[i] = {}
        for j = 1, tilemapVars.dims.columns do
            if i == 1 then
                if j == 1 then
                    tilemapGraphics[i][j] = 1
                elseif j == tilemapVars.dims.columns then
                    tilemapGraphics[i][j] = 3
                else 
                    tilemapGraphics[i][j] = 2
                end
            elseif i == tilemapVars.dims.rows then
                if j == 1 then
                    tilemapGraphics[i][j] = 7 
                elseif j == tilemapVars.dims.columns then
                    tilemapGraphics[i][j] = 5
                else
                    tilemapGraphics[i][j] = 6
                end
            else 
                if j == 1 then
                    tilemapGraphics[i][j] = 8 
                elseif j == tilemapVars.dims.columns then
                    tilemapGraphics[i][j] = 4
                else
                    tilemapGraphics[i][j] = 0
                end
            end
        end
    end
end

return mapModule
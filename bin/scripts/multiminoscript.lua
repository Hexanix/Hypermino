-- Table to return

multiminoModule = {}

-- A list of directions and their x, y modifiers
--[[
    1  = "down"
    2 = "right"
    3 = "up"
    4 = "left"
]]

-- NEW IDEA: Alt to differentiate between opposite directions (0 = not, 1 = is)
-- Alt directions are towards + sides of x, y

multiminoModule.directionModifiers = {
[1] = {mx = 0, my = 1, alt_x = 0, alt_y = 0},
[2] = {mx = 1, my = 0, alt_x = 0, alt_y = 0}, 
[3] = {mx = 0, my = -1, alt_x = 0, alt_y = 1}, 
[4] = {mx = -1, my = 0, alt_x = 1, alt_y = 0}
}

--[[ directionCode= {
    [1] = "down",
    [2] = "right",
    [3] = "up",
    [4] = "left"
} ]]

-- Block to form multimino example.
multiminoModule.block = {hasPassed = false, type = 1}
multiminoModule.multimino_ID = 0 -- Self_explanatory.

-- Actual multimino
multiminoModule.multiminoList = {}


 -- NOT TESTED/WORKING
function multiminoModule.blockFinder(x, y)
    for i = 1, #multiminoModule.multiminoList do
        multimino = multiminoModule.multiminoList[i]

        for j = 1, multimino.properties.tileNum do
            block = multimino.blocks[j] 

            if block.tilemap_x == x and block.tilemap_y == y then
                return block
            end
        end
    end
end

 -- NOT TESTED/WORKING
function multiminoModule.multiminoFinder(id)
    for i = 1, #multiminoModule.multiminoList do
        if multiminoModule.multiminoList[i].properties.multimino_ID ==  id then
            return multiminoModule.multiminoList[i]
        end
    end
end

-- Function to create multiminos
-- Img placeholders for now, all normal would blocks share the same image
function multiminoModule.multimino_generate(tileNum, speed, direction, tilemapVars, img, imgLead, imgPassed)

    -- Add a resetting if in case multimino_ID grows too big?

    multiminoModule.multimino_ID = multiminoModule.multimino_ID + 1

    multimino = {}
    multimino.blocks = {}
    multimino.properties = {speed = speed, direction = direction, tileNum = tileNum,
     spawn_distance = -8, isResting = false, isOutside = true, multimino_ID = multiminoModule.multimino_ID} 
    --[[
        Properties:
        Speed: Speed of multimino. Has a bug where if speed is 1.3 or less, any outside collision with border boxes crashes the game. (null multimino?)
        Direction: Direction code of multimino (1 - 4).
        TileNum: Number of blocks inside.
        Spawn_distance: Distance from grid when spawning multiminos. Has to be negative.
        isResting: Is the multimino at rest?
        isOutside: Does the multimino have no blocks inside the grid?
        Multimino_ID = unique ID of multimino.
    ]]


    startPos_x = 1
    startPos_y = 1

    if direction%2 ~= 0 then
        startPos_x = love.math.random(1, tilemapVars.dims.columns)
        startPos_y = multimino.properties.spawn_distance
    else 
        startPos_x = multimino.properties.spawn_distance
        startPos_y = love.math.random(1, tilemapVars.dims.rows)
    end

    -- Block property generating
    block = { y = startPos_y, x = startPos_x, tilemap_x = 1, tilemap_y = 1, speedModifier = 1,
    hasPassed = false, toDelete = false, img = imgLead, multimino_ID = multimino.properties.multimino_ID, type = 1}
    

    --[[
        Multimino-ID is here for easier access.
        Properties:
        y / x : Detailed x / y coordinates. 
        tilemap_y / x :  Rounded down x / y coordinates.
        hasPassed: Has the block passed?
        toDelete: Should the block be deleted when Delete Function is reached?
        img: The image of the block
        multimino_ID = the ID of parent multimino.
        type: Block type. Collision and etc.

    ]]

    table.insert(multimino.blocks, block)


    -- This is to prevent spawning multi-s overlapping when spawning, but it looks shady as hell, so it's out for now.

 --[[   for i = 1, #multiminoModule.multiminoList do
        if ( block.x == math.floor(multiminoModule.multiminoList[i].blocks[1].x) and block.y == math.floor(multiminoModule.multiminoList[i].blocks[1].y) ) 
        or ( block.x == math.ceil(multiminoModule.multiminoList[i].blocks[1].x) and block.y == math.ceil(multiminoModule.multiminoList[i].blocks[1].y) ) then

            multimino.properties.spawn_distance = multimino.properties.spawn_distance + 2
            if direction%2 ~= 0 then
                startPos_y = spawn_distance
            else 
                startPos_x = spawn_distance
            end
        
            -- Block property generating

            block = {x = startPos_x, y = startPos_y, tilemap_x = 1, tilemap_y = 1, hasPassed = false, img = imgLead, multimino_ID = multimino.properties.multimino_ID, type = 1}
            table.insert(multimino.blocks, block)


            i = 1
        end 

    end ]]
    
    
    for i = 1, tileNum do
       randDir = love.math.random(1, 4)
       block = {
           x = multimino.blocks[i].x + multiminoModule.directionModifiers[randDir].mx,
           tilemap_x = 1,

           y = multimino.blocks[i].y + multiminoModule.directionModifiers[randDir].my,
           tilemap_y = 1,

           speedModifier = 1,
           hasPassed = false, toDelete = false, img = img, multimino_ID = multimino.properties.multimino_ID,
           type = 1}

        for j = 1, i do
            while (block.x == multimino.blocks[j].x and block.y == multimino.blocks[j].y) do 
                randDir = love.math.random(1, 4)

                block = {
                    x = multimino.blocks[i].x + multiminoModule.directionModifiers[randDir].mx,
                    tilemap_x = 1,

                    y = multimino.blocks[i].y + multiminoModule.directionModifiers[randDir].my,
                    tilemap_y = 1,

                    speedModifier = 1,
                    hasPassed = false, toDelete = false, img = img, multimino_ID = multimino.properties.multimino_ID,
                    type = 1}
            end
        end 

        table.insert( multimino.blocks, block)
    end 

    table.insert(multiminoModule.multiminoList, multimino)
end


-- Function to update multimino position (not draw)

function multiminoModule.multimino_update(dt, dims, colTable, colTilemap)
    pre_tilemap_x = nil
    pre_tilemap_y = nil

    for i = 1, #multiminoModule.multiminoList do

        multimino = multiminoModule.multiminoList[i]
        if (multimino == nil) then
            break -- This fixes the outside-edge issue...? 
        end
        dirMod = multiminoModule.directionModifiers[multimino.properties.direction]
        dirColValues = colTable.directionCode[multimino.properties.direction]
  
        if multimino.properties.isResting == false then  -- New IF, this finally solves the extra Y issue, its experimental, dunno if it has any side-effects

            for j = 1, multimino.properties.tileNum do 
    
                block = multimino.blocks[j]

                pre_tilemap_x = block.tilemap_x
                pre_tilemap_y = block.tilemap_y --Experimental, to reduce the times it checks collision.

                -- Changed it to add up to the counters, not subtract   

                block.x = block.x +
                multimino.properties.speed*block.speedModifier*dt*math.abs(dirMod.mx)

                block.y = block.y +
                multimino.properties.speed*block.speedModifier*dt*math.abs(dirMod.my)


                block.tilemap_x = math.floor(block.x)
                block.tilemap_y = math.floor(block.y)
                        
            end
        end

        for k = 1, multimino.properties.tileNum do 

            block = multimino.blocks[k]

            if multimino.properties.isResting == false then     
                if multimino.properties.direction%2 ~= 0 then 
                   if 
                     block.tilemap_y >= 0 and
                     block.tilemap_y <= dims.rows + 1 and 
                     block.tilemap_x <= dims.columns and 
                     block.tilemap_x > 0 then 

                        if block.tilemap_y >= 1 then
                            block.hasPassed = true
                            -- Debug image below
                            block.img = love.graphics.newImage("assets/blockPassed.png")

                        else
                            block.hasPassed = false
                        end

                         
                        if block.hasPassed == true then

                            if (block.tilemap_y == dims.rows + 1) then 
                                for l = 1, multimino.properties.tileNum do
                                    multimino.blocks[l].tilemap_y = multimino.blocks[l].tilemap_y - 1
                                    multimino.blocks[l].img = love.graphics.newImage("assets/blockStopped.png")
                                    multimino.blocks[l].y = math.floor(multimino.blocks[l].y)

                                end

                                multimino.properties.speed = 0 -- unnecessary, but I'll keep it for now
                                multimino.properties.isResting = true

                                for p = 1, multimino.properties.tileNum do
                                    multimino.blocks[p].type = 2
                                end
                                
                                -- Below is collision detection for multimino - multimino. They need to be separate for it to not throw out-of-bounds error. It also will ONLY work for vertical collision.
                            
                            elseif dirColValues[colTilemap[math.abs( (dims.columns + 1)*dirMod.alt_x - block.tilemap_x)][math.abs( (dims.rows + 1)*dirMod.alt_y - block.tilemap_y)].type] == true --this also has issues for some reason
                                and block.multimino_ID ~= colTilemap[math.abs( (dims.columns + 1)*dirMod.alt_x - block.tilemap_x)][math.abs( (dims.rows + 1)*dirMod.alt_y - block.tilemap_y)].multimino_ID then --block.multimino_ID comes out as null, it seems rather broken...

                                    if block.tilemap_y <= 1 then
                                        block.speedModifier = 0
                                        block.toDelete = true
                                    else

                                        for l = 1, multimino.properties.tileNum do 
                                            multimino.blocks[l].tilemap_y = multimino.blocks[l].tilemap_y - 1
                                            multimino.blocks[l].img = love.graphics.newImage("assets/blockStopped.png") -- (When bugged, all block stop. Reached.)
                                            multimino.blocks[l].y = math.floor(multimino.blocks[l].y)

                                            if  multimino.blocks[l].tilemap_y <= 0 then -- used to be block, now is blocks[l] for inner loop. This fixed the outsider blocks.
                                                multimino.blocks[l].hasPassed = false  
                                            end
        
                                        end
        
                                        multimino.properties.speed = 0 -- unnecessary, but I'll keep it for now
                                        multimino.properties.isResting = true
                                        for p = 1, multimino.properties.tileNum do
                                            multimino.blocks[p].type = 2
                                        end
                                    end
                            end
                        end
                    end
                else -- HORIZONTAL COL
                    if 
                    block.tilemap_x >= 0 and
                    block.tilemap_x <= dims.columns + 1 and 
                    block.tilemap_y <= dims.rows and 
                    block.tilemap_y > 0 then 

                       if block.tilemap_x >= 1 then
                           block.hasPassed = true
                           -- Debug image below
                           block.img = love.graphics.newImage("assets/blockPassed.png")
                       else
                           block.hasPassed = false
                       end

                        
                       if block.hasPassed == true then

                           if (block.tilemap_x == dims.columns + 1) then 
                               for l = 1, multimino.properties.tileNum do
                                   multimino.blocks[l].tilemap_x = multimino.blocks[l].tilemap_x - 1
                                   multimino.blocks[l].img = love.graphics.newImage("assets/blockStopped.png")
                                   multimino.blocks[l].x = math.floor(multimino.blocks[l].x)

                               end

                               multimino.properties.speed = 0 -- unnecessary, but I'll keep it for now
                               multimino.properties.isResting = true
                                for p = 1, multimino.properties.tileNum do
                                  multimino.blocks[p].type = 2
                                end
                               
                               -- Below is collision detection for multimino - multimino. They need to be separate for it to not throw out-of-bounds error. It also will ONLY work for vertical collision.
                           
                           elseif dirColValues[colTilemap[math.abs( (dims.columns + 1)*dirMod.alt_x - block.tilemap_x)][math.abs( (dims.rows + 1)*dirMod.alt_y - block.tilemap_y)].type] == true --this also has issues for some reason
                               and block.multimino_ID ~= colTilemap[math.abs( (dims.columns + 1)*dirMod.alt_x - block.tilemap_x)][math.abs( (dims.rows + 1)*dirMod.alt_y - block.tilemap_y)].multimino_ID then --block.multimino_ID comes out as null, it seems rather broken...
                                
                                if block.tilemap_x <= 1 then
                                    block.speedModifier = 0
                                    block.toDelete = true
                                else
                                    for l = 1, multimino.properties.tileNum do 
                                        multimino.blocks[l].tilemap_x = multimino.blocks[l].tilemap_x - 1
                                        multimino.blocks[l].img = love.graphics.newImage("assets/blockStopped.png") -- (When bugged, all block stop. Reached.)
                                        multimino.blocks[l].x = math.floor(multimino.blocks[l].x)
                                        if  multimino.blocks[l].tilemap_x <= 0 then -- used to be block, now is blocks[l] for inner loop. This fixed the outsider blocks.
                                            multimino.blocks[l].hasPassed = false  
                                        end
                                    end

                                    multimino.properties.speed = 0 -- unnecessary, but I'll keep it for now
                                    multimino.properties.isResting = true       
                                    for p = 1, multimino.properties.tileNum do
                                        multimino.blocks[p].type = 2
                                    end   
                                end                    
                           end
                       end
                   end
                end
            end 

        end

        -- Sets all the outside blocks' flags toDelete
        for n = multimino.properties.tileNum, 1, -1 do 
            if multimino.blocks[n].hasPassed == false and ( multimino.properties.isResting == true
                                                         or multimino.blocks[n].speedModifier == 0 
                                                         or (multimino.blocks[n].tilemap_y > dims.rows + 6 or multimino.blocks[n].tilemap_x > dims.columns + 6) ) then
                multiminoModule.block_toDeleteFlagger(multimino.blocks[n])
            end
        end

 
        multiminoModule.block_delete(multimino)
        if multimino.properties.tileNum == 0 then
            table.remove(multiminoModule.multiminoList, i)
        end



    end
   
end



function multiminoModule.lineCheck(tilemapCollision, multiminoList, tilemapVars, playerTable)

    emptyBlocksList = {}
    -- VERTICAL
    for f = 1, tilemapVars.dims.rows do  
        currLineEmptyBlocksCount = 0
        for g = 1, tilemapVars.dims.columns do
            if tilemapCollision[f][g].type == 0 or tilemapCollision[f][g].type == "@" or tilemapCollision[f][g].type == 1 then 

                duplicate = false
                for k = 1, #emptyBlocksList do 
                    if emptyBlocksList[k] == g then
                        duplicate = true
                        break
                    end
                end

                currLineEmptyBlocksCount = currLineEmptyBlocksCount + 1
                if duplicate == false then
                    table.insert( emptyBlocksList, g)
                end

            end            
        end

        if currLineEmptyBlocksCount == 0 then
            for e = 1, tilemapVars.dims.columns do
                tilemapCollision[f][e].toDelete = true
            end

            for e = 1, #playerTable do
                playerTable[e].score = playerTable[e].score + 100 -- MOCK SCORE
            end
        end 

    end

    -- HORIZONTAL
    for f = 1, tilemapVars.dims.columns do
        isValid = true

        for g = 1, #emptyBlocksList do
            if f == emptyBlocksList[g] then
                isValid = false
                break
            end
        end
        
        if isValid == true then
            for h = 1, tilemapVars.dims.rows do
                tilemapCollision[h][f].toDelete = true
            end

            for e = 1, #playerTable do
                playerTable[e].score = playerTable[e].score + 100 -- MOCK SCORE
            end
        end
    end

end


function multiminoModule.block_toDeleteFlagger(block)   
   block.toDelete = true
end

function multiminoModule.block_delete(multimino)

   tileNumOff = 0 
  for n = multimino.properties.tileNum, 1, -1 do 
      if multimino.blocks[n].toDelete == true then
         table.remove( multimino.blocks, n)
         tileNumOff = tileNumOff + 1
      end
 end
 multimino.properties.tileNum = multimino.properties.tileNum - tileNumOff

end

function multiminoModule.multimino_tilemapPos_update(colTilemap, dims)   
    for q = 1, #multiminoModule.multiminoList do

        multimino = multiminoModule.multiminoList[q]
        dirMod = multiminoModule.directionModifiers[multimino.properties.direction]

        for w = 1, multimino.properties.tileNum do
            block = multimino.blocks[w]

            if block.hasPassed == true then
                colTilemap[math.abs( (dims.columns + 1)*dirMod.alt_x - block.tilemap_x) ][math.abs( (dims.rows + 1)*dirMod.alt_y - block.tilemap_y) ] = block
            end
        end
    end
end 

return multiminoModule
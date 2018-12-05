playerModule = {}

-- Function for quick player setup
-- player first argument possibly
-- Removed Grid x and y

function playerModule.new_player( tilemap_x, tilemap_y, tilemapTable, real_x, real_y,   img, ID, controlTable)
    playerModule.player = {}

    -- Tile value holder. (Used for testing I guess)
    -- tileCurrent = "@"

    playerModule.player.tilemap_graphic_x = tilemap_x
    playerModule.player.tilemap_graphic_y = tilemap_y

    playerModule.player.tilemap_collision_x = tilemap_x
    playerModule.player.tilemap_collision_y = tilemap_y

    playerModule.player.tileCurrent = tilemapTable.tilemapCollision[tilemap_x][tilemap_y ]
    tilemapTable.tilemapCollision[tilemap_x][tilemap_y] = "@"

    playerModule.player.real_x = real_x
    playerModule.player.real_y = real_y

    playerModule.player.img = img
    

    playerModule.player.ID = ID

    playerModule.player.controlTable = controlTable

    playerModule.player.isActive = true 
    playerModule.player.isAlive = true

    playerModule.player.score = 0


    return playerModule.player
end

function playerModule.player_tilemapPos_update(player, add_x, add_y, tilemapCollision)

  player.tilemap_graphic_x = player.tilemap_graphic_x  + add_x
  player.tilemap_graphic_y = player.tilemap_graphic_y + add_y

  player.tilemap_collision_x = player.tilemap_collision_x + add_x
  player.tilemap_collision_y = player.tilemap_collision_y + add_y

end


return playerModule
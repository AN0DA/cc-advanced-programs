-- Configurations
local width = 10  -- Width of the area to mine
local height = 6  -- Height of the area to mine
local depth = 10  -- Depth of the area to mine
local torchInterval = 8  -- How often to place a torch
local chestSlot = 16  -- Slot where the chest is placed

-- Helper Functions
local function refuel()
    for i = 1, 16 do
        turtle.select(i)
        if turtle.refuel(0) then
            turtle.refuel(1)
        end
    end
end

local function dropOffItems()
    turtle.select(chestSlot)
    turtle.placeDown()
    for i = 1, 15 do
        turtle.select(i)
        turtle.dropDown()
    end
end

local function placeTorch()
    for i = 1, 16 do
        if turtle.getItemDetail(i) and turtle.getItemDetail(i).name == "minecraft:torch" then
            turtle.select(i)
            turtle.placeDown()
            break
        end
    end
end

local function mineVein()
    while turtle.detect() do
        turtle.dig()
        turtle.forward()
        mineVein()
        turtle.back()
    end
    
    turtle.turnLeft()
    if turtle.detect() then
        mineVein()
    end
    turtle.turnRight()
    turtle.turnRight()
    if turtle.detect() then
        mineVein()
    end
    turtle.turnLeft()
end

-- Main Mining Function
local function mineArea()
    for y = 1, height do
        for z = 1, depth do
            for x = 1, width do
                refuel()
                if turtle.detect() then
                    mineVein()
                else
                    turtle.dig()
                    turtle.forward()
                end

                if (z-1) % torchInterval == 0 and x == 1 then
                    placeTorch()
                end
            end

            if z ~= depth then
                if z % 2 == 1 then
                    turtle.turnRight()
                    turtle.dig()
                    turtle.forward()
                    turtle.turnRight()
                else
                    turtle.turnLeft()
                    turtle.dig()
                    turtle.forward()
                    turtle.turnLeft()
                end
            end
        end

        if y ~= height then
            turtle.digUp()
            turtle.up()
            if y % 2 == 1 then
                turtle.turnLeft()
                turtle.turnLeft()
            end
        end
    end
end

-- Return to Start Position and Drop Off Items
local function returnToStart()
    for i = 1, height-1 do
        turtle.down()
    end
    turtle.turnRight()
    for i = 1, depth-1 do
        turtle.back()
    end
    turtle.turnLeft()
    for i = 1, width-1 do
        turtle.back()
    end
    dropOffItems()
end

-- Main Program Execution
mineArea()
returnToStart()

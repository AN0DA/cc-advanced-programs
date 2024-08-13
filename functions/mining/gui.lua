-- gui.lua
local helper = require("helper")
local ui = require("ui")
local shapes = require("shapes")
local TurtleWrapper = require("turtle_wrapper")

local gui = {}

--- Displays the main menu to the user.
-- Allows the user to choose between configuring the turtle, starting an operation, or exiting.
function gui.showMainMenu()
    while true do
        term.clear()
        term.setCursorPos(1, 1)
        print("=== Turtle Control Interface ===")
        print("1. Configure Turtle")
        print("2. Start Mining Operation")
        print("3. Monitor Status")
        print("4. Exit")
        write("Choose an option: ")
        
        local choice = read()
        if choice == "1" then
            gui.configureTurtle()
        elseif choice == "2" then
            gui.startMiningOperation()
        elseif choice == "3" then
            gui.showStatus()
        elseif choice == "4" then
            break
        else
            print("Invalid option, please try again.")
            sleep(1)
        end
    end
end

--- Allows the user to configure the turtle's settings.
function gui.configureTurtle()
    term.clear()
    term.setCursorPos(1, 1)
    print("=== Configure Turtle ===")
    print("Current Configuration:")
    local config = require("config").localConfig
    for key, value in pairs(config) do
        print(key .. ": " .. tostring(value))
    end
    print("Enter the field you want to change or 'exit' to return:")
    
    while true do
        write("> ")
        local input = read()
        if input == "exit" then
            break
        elseif config[input] ~= nil then
            write("Enter new value for " .. input .. ": ")
            local newValue = read()
            if tonumber(newValue) then
                newValue = tonumber(newValue)
            elseif newValue == "true" or newValue == "false" then
                newValue = (newValue == "true")
            end
            config[input] = newValue
            print(input .. " set to " .. tostring(newValue))
        else
            print("Invalid field, please try again.")
        end
    end
end

--- Starts a mining operation based on user input.
function gui.startMiningOperation()
    term.clear()
    term.setCursorPos(1, 1)
    print("=== Start Mining Operation ===")
    local shapeData = ui.promptForShape()
    if shapeData then
        -- Perform shape-based mining...
        print("Starting mining operation with shape: " .. shapeData.shape.command)
        -- Insert code to start the mining operation here...
    else
        print("Failed to start mining operation.")
    end
end

--- Displays the turtle's current status.
function gui.showStatus()
    term.clear()
    term.setCursorPos(1, 1)
    print("=== Turtle Status ===")
    print("Fuel Level: " .. turtle.getFuelLevel())
    print("Position: (" .. TurtleWrapper.getX() .. ", " .. TurtleWrapper.getY() .. ", " .. TurtleWrapper.getZ() .. ")")
    print("Direction: " .. TurtleWrapper.getDirection())
    print("Press Enter to return to the main menu.")
    read()
end

return gui

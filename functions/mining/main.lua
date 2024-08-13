-- main.lua
local config = require("config")
local helper = require("helper")
local TurtleWrapper = require("turtle_wrapper")
local ui = require("ui")
local region = require("region")
local shapes = require("shapes")
local pathfinding = require("pathfinding")
local gui = require("gui")
local remote = require("remote")

--- Main function that initializes the turtle and starts the selected operation.
-- @param ... Command-line arguments.
local function main(...)
    local args = {...}
    local configData = helper.safeCall(config.processConfig)
    if not configData then return end

    TurtleWrapper.init()

    -- Initialize modem for remote communication if specified
    if args[1] == "remote" then
        print("Initializing remote communication...")
        remote.init(123)  -- Use default channel 123
        parallel.waitForAny(
            function() remote.listenForCommands(123) end,
            function() remote.sendStatus(123) end
        )
        return
    end

    -- Show the user-friendly interface
    gui.showMainMenu()
end

main(...)

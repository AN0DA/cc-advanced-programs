-- remote.lua
local TurtleWrapper = require("turtle_wrapper")
local config = require("config")
local helper = require("helper")

local remote = {}

--- Initializes the wireless modem for communication.
-- Opens a channel for receiving commands and sending status updates.
-- @param channel The channel number to use for communication (default: 123).
function remote.init(channel)
    channel = channel or 123
    local modem = peripheral.find("modem")
    if not modem then
        error("Wireless modem not found! Please attach a wireless modem to the turtle.")
    end
    modem.open(channel)
    print("Modem initialized on channel " .. channel)
end

--- Sends a status update over the wireless modem.
-- @param channel The channel number to use for sending the status.
function remote.sendStatus(channel)
    channel = channel or 123
    local modem = peripheral.find("modem")
    if modem then
        local status = {
            fuelLevel = turtle.getFuelLevel(),
            position = {x = TurtleWrapper.getX(), y = TurtleWrapper.getY(), z = TurtleWrapper.getZ()},
            direction = TurtleWrapper.getDirection(),
            config = config.localConfig
        }
        modem.transmit(channel, channel, status)
        print("Status sent on channel " .. channel)
    end
end

--- Listens for remote commands via the wireless modem.
-- Executes received commands and sends back the result.
-- @param channel The channel number to listen on (default: 123).
function remote.listenForCommands(channel)
    channel = channel or 123
    local modem = peripheral.find("modem")
    if not modem then
        error("Wireless modem not found! Please attach a wireless modem to the turtle.")
    end

    print("Listening for commands on channel " .. channel .. "...")
    while true do
        local event, side, receiveChannel, replyChannel, message, distance = os.pullEvent("modem_message")
        if receiveChannel == channel then
            print("Received command: " .. tostring(message))
            local success, result = helper.safeCall(loadstring(message))
            if success then
                modem.transmit(replyChannel, receiveChannel, "Command executed successfully.")
            else
                modem.transmit(replyChannel, receiveChannel, "Error: " .. tostring(result))
            end
        end
    end
end

return remote

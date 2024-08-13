-- ui.lua
local helper = require("helper")
local shapes = require("shapes")

local ui = {}

--- Prints general information about the turtle's current state.
function ui.printInfo()
	helper.print("Current fuel level is", turtle.getFuelLevel())
	helper.print("Available item slots:")
	-- Slot management code...
end

--- Prints available programs (shapes) for the user to choose from.
function ui.printProgramsInfo()
	helper.print("Select a program:")
	helper.print("\thelp <program>")
	for _, value in pairs(shapes) do
		helper.print("\t" .. value.shortDesc)
	end
end

--- Attempts to show help information for a given input.
-- @param input The input string provided by the user.
-- @return boolean True if help was shown, otherwise false.
function ui.tryShowHelp(input)
	if not input then return false end
	local split = helper.splitString(input)
	if split[1] ~= "help" then return false end
	if #split == 1 then
		ui.printProgramsInfo()
		return true
	end

	if #split ~= 2 then return false end

	local program = split[2]
	local shape = shapes.getShape(program)

	if not shape then
		helper.printError("Unknown program")
		return true
	end

	helper.print("Usage:", shape.shortDesc)
	helper.print("\t" .. shape.longDesc)
	return true
end

--- Parses a command input and returns the corresponding shape and arguments.
-- @param input The input command string.
-- @return table A table containing the shape and its arguments or nil if parsing fails.
function ui.parseProgram(input)
	local split = helper.splitString(input)
	if not split or #split == 0 then return nil end

	local program = split[1]
	local shape = shapes.getShape(program)
	if not shape then return nil end

	local args = {table.unpack(split, 2)}
	-- Argument validation can be added here if needed...
	return {shape = shape, args = args}
end

--- Prompts the user to input a shape command and returns the parsed shape and arguments.
-- Loops until a valid shape is provided or help is requested.
-- @return table The shape and arguments selected by the user.
function ui.promptForShape()
	while true do
		helper.write("> ")
		local input = helper.read()
		local shape = ui.parseProgram(input)
		if not shape then
			if not ui.tryShowHelp(input) then
				helper.printError("Invalid program")
			end
		else
			return shape
		end
	end
end

--- Displays a validation error message to the user.
-- @param validationResult The validation result bitmask.
function ui.showValidationError(validationResult)
	local error = "Invalid mining volume:"
	if bit32.band(validationResult, 4) ~= 0 then
		helper.printError("Invalid mining volume: \n\tVolume is empty")
		return
	end
	if bit32.band(validationResult, 1) ~= 0 then
		error = error .. "\n\tVolume has multiple disconnected parts"
	end
	if bit32.band(validationResult, 2) ~= 0 then
		error = error .. "\n\tTurtle (pos(0,0,0)) not in volume"
	end
	helper.printError(error)
end

return ui

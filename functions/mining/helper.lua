-- helper.lua
local helper = {}

--- Logs a message to a log file with a timestamp.
-- @param message The message to log.
function helper.log(message)
	local logFile = fs.open("turtle_log.txt", "a")
	logFile.writeLine(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message)
	logFile.close()
end

--- Logs an error message and prints it to the console.
-- @param message The error message to log and print.
function helper.logError(message)
	helper.log("ERROR: " .. message)
	print("[ERROR]: " .. message)
end

--- Logs a warning message and prints it to the console.
-- @param message The warning message to log and print.
function helper.logWarning(message)
	helper.log("WARNING: " .. message)
	print("[WARNING]: " .. message)
end

--- Safely calls a function and logs any errors that occur.
-- @param func The function to call.
-- @param ... The arguments to pass to the function.
-- @return any The return value of the function or nil in case of an error.
-- @return string An error message if the function call fails.
function helper.safeCall(func, ...)
	local status, result = pcall(func, ...)
	if not status then
		helper.logError(tostring(result))
		return nil, result
	end
	return result, nil
end

--- Generates a unique index string for 3D coordinates.
-- @param x The X coordinate.
-- @param y The Y coordinate.
-- @param z The Z coordinate.
-- @return string The unique index string.
function helper.getIndex(x, y, z)
	return tostring(x) .. "," .. tostring(y) .. "," .. tostring(z)
end

--- Compares two positions for equality.
-- @param pos1 The first position (table with x, y, z fields).
-- @param pos2 The second position (table with x, y, z fields).
-- @return boolean True if the positions are equal, otherwise false.
function helper.isPosEqual(pos1, pos2)
	return pos1.x == pos2.x and pos1.y == pos2.y and pos1.z == pos2.z
end

--- Calculates the direction based on X and Z deltas.
-- @param dX The delta X.
-- @param dZ The delta Z.
-- @return number The direction as an integer.
function helper.deltaToDirection(dX, dZ)
	if dX > 0 then
		return 3 -- EAST
	elseif dX < 0 then
		return 1 -- WEST
	elseif dZ > 0 then
		return 0 -- SOUTH
	elseif dZ < 0 then
		return 2 -- NORTH
	end
	error("Invalid delta", 2)
end

return helper

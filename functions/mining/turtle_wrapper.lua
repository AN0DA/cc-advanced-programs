-- turtle_wrapper.lua
local helper = require("helper")

local TurtleWrapper = {}
local self = {
	selectedSlot = 1,
	direction = 0, -- SOUTH
	x = 0,
	y = 0,
	z = 0
}

--- Initializes the turtle's selected slot.
function TurtleWrapper.init()
	turtle.select(self.selectedSlot)
	helper.log("Turtle initialized with selected slot " .. self.selectedSlot)
end

--- Selects the given slot.
-- @param slot The slot number to select.
function TurtleWrapper.select(slot)
	if self.selectedSlot ~= slot then
		turtle.select(slot)
		self.selectedSlot = slot
		helper.log("Selected slot " .. slot)
	end
end

--- Moves the turtle forward and updates its position.
-- @return boolean True if successful, false otherwise.
function TurtleWrapper.forward()
	if turtle.forward() then
		if self.direction == 3 then self.x = self.x + 1
		elseif self.direction == 1 then self.x = self.x - 1
		elseif self.direction == 0 then self.z = self.z + 1
		elseif self.direction == 2 then self.z = self.z - 1
		end
		helper.log("Moved forward to (" .. self.x .. ", " .. self.y .. ", " .. self.z .. ")")
		return true
	end
	helper.logWarning("Failed to move forward")
	return false
end

--- Moves the turtle up and updates its position.
-- @return boolean True if successful, false otherwise.
function TurtleWrapper.up()
	if turtle.up() then
		self.y = self.y + 1
		helper.log("Moved up to (" .. self.x .. ", " .. self.y .. ", " .. self.z .. ")")
		return true
	end
	helper.logWarning("Failed to move up")
	return false
end

--- Moves the turtle down and updates its position.
-- @return boolean True if successful, false otherwise.
function TurtleWrapper.down()
	if turtle.down() then
		self.y = self.y - 1
		helper.log("Moved down to (" .. self.x .. ", " .. self.y .. ", " .. self.z .. ")")
		return true
	end
	helper.logWarning("Failed to move down")
	return false
end

--- Turns the turtle right and updates its direction.
-- @return boolean True if successful, false otherwise.
function TurtleWrapper.turnRight()
	if turtle.turnRight() then
		self.direction = (self.direction + 1) % 4
		helper.log("Turned right, new direction: " .. self.direction)
		return true
	end
	helper.logWarning("Failed to turn right")
	return false
end

--- Turns the turtle left and updates its direction.
-- @return boolean True if successful, false otherwise.
function TurtleWrapper.turnLeft()
	if turtle.turnLeft() then
		self.direction = (self.direction - 1) % 4
		if self.direction < 0 then self.direction = 3 end
		helper.log("Turned left, new direction: " .. self.direction)
		return true
	end
	helper.logWarning("Failed to turn left")
	return false
end

--- Gets the turtle's current X coordinate.
-- @return number The X coordinate.
function TurtleWrapper.getX() return self.x end

--- Gets the turtle's current Y coordinate.
-- @return number The Y coordinate.
function TurtleWrapper.getY() return self.y end

--- Gets the turtle's current Z coordinate.
-- @return number The Z coordinate.
function TurtleWrapper.getZ() return self.z end

--- Gets the turtle's current direction.
-- @return number The direction.
function TurtleWrapper.getDirection() return self.direction end

--- Gets the turtle's current position.
-- @return table The position as a table with x, y, z, and direction fields.
function TurtleWrapper.getPosition()
	return {x = self.x, y = self.y, z = self.z, direction = self.direction}
end

return TurtleWrapper

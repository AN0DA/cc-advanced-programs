-- shapes.lua
local helper = require("helper")

local shapes = {}

--- Registers a shape with the given name.
-- @param name The name of the shape.
-- @param shape The shape definition table.
function shapes.registerShape(name, shape)
	shapes[name] = shape
end

--- Retrieves a registered shape by name.
-- @param name The name of the shape to retrieve.
-- @return table The shape definition table or nil if not found.
function shapes.getShape(name)
	return shapes[name]
end

-- Example shape registration
shapes.registerShape("sphere", {
	command = "sphere",
	shortDesc = "sphere <diameter>",
	longDesc = "Mine a sphere of diameter <diameter>, starting from its bottom center",
	args = {"2.."},
	generate = function(diameter)
		local radius = math.ceil(diameter / 2.0)
		local radiusSq = (diameter / 2.0) * (diameter / 2.0)
		local blocks = {}
		local first = nil
		for j = -radius, radius do
			for i = -radius, radius do
				for k = -radius, radius do
					if diameter % 2 == 0 then
						if math.pow(i + 0.5, 2) + math.pow(j + 0.5, 2) + math.pow(k + 0.5, 2) < radiusSq then
							if not first then first = j end
							blocks[helper.getIndex(i, j - first, k)] = {x = i, y = j - first, z = k}
						end
					else
						if math.pow(i, 2) + math.pow(j, 2) + math.pow(k, 2) < radiusSq then
							if not first then first = j end
							blocks[helper.getIndex(i, j - first, k)] = {x = i, y = j - first, z = k}
						end
					end
				end
			end
			helper.osYield()
		end
		return blocks
	end
})

shapes.registerShape("cube", {
	command = "cube",
	shortDesc = "cube <left> <up> <forward>",
	longDesc = "Mine a cuboid of a specified size. Use negative values to dig in an opposite direction",
	args = {"..-2 2..", "..-2 2..", "..-2 2.."},
	generate = function(x, y, z)
		local blocks = {}
		local sX = helper.sign(x)
		local sY = helper.sign(y)
		local sZ = helper.sign(z)
		local tX = sX * (math.abs(x) - 1)
		local tY = sY * (math.abs(y) - 1)
		local tZ = sZ * (math.abs(z) - 1)
		for i = 0, tX, sX do
			for j = 0, tY, sY do
				for k = 0, tZ, sZ do
					blocks[helper.getIndex(i, j, k)] = {x = i, y = j, z = k}
				end
			end
			helper.osYield()
		end
		return blocks
	end
})

-- Additional shapes can be registered here...

return shapes

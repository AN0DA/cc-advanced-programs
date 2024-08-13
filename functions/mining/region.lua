-- region.lua
local helper = require("helper")

local region = {}

--- Validates the given region of blocks.
-- Checks for multiple connected components, empty regions, and whether the turtle is within the region.
-- @param blocks The region of blocks to validate.
-- @return number The validation result bitmask (0 for success).
function region.validateRegion(blocks)
	local result = 0 -- SUCCESS
	local components = region.findConnectedComponents(blocks)

	if helper.tableLength(components) == 0 then
		result = result + 4 -- FAILED_REGION_EMPTY
	end
	if helper.tableLength(components) > 1 then
		result = result + 1 -- FAILED_NONONE_COMPONENTCOUNT
	end
	if not blocks[helper.getIndex(0, 0, 0)] then
		result = result + 2 -- FAILED_TURTLE_NOTINREGION
	end

	return result
end

--- Creates a sample shape in the region for testing.
-- @return table The generated shape as a table of blocks.
function region.createShape()
	local blocks = {}
	for i = -7, 7 do
		for j = 0, 7 do
			for k = -7, 7 do
				if i * i + j * j + k * k < 2.5 * 2.5 then
					blocks[helper.getIndex(i, j, k)] = {x = i, y = j, z = k}
				end
			end
		end
	end
	return blocks
end

--- Finds connected components within a region of blocks.
-- @param blocks The region of blocks to analyze.
-- @return table A table containing each connected component as a separate subtable.
function region.findConnectedComponents(blocks)
	local visited = {}
	local components = {}

	for key, value in pairs(blocks) do
		if not visited[key] then
			local component = {}
			local toVisit = {[key] = value}

			while true do
				local newToVisit = {}
				local didSomething = false
				for currentKey, current in pairs(toVisit) do
					didSomething = true
					visited[currentKey] = true
					component[currentKey] = current

					local neighbors = {
						helper.getIndex(current.x - 1, current.y, current.z),
						helper.getIndex(current.x + 1, current.y, current.z),
						helper.getIndex(current.x, current.y - 1, current.z),
						helper.getIndex(current.x, current.y + 1, current.z),
						helper.getIndex(current.x, current.y, current.z - 1),
						helper.getIndex(current.x, current.y, current.z + 1)
					}

					for _, neighborIndex in ipairs(neighbors) do
						if blocks[neighborIndex] and not visited[neighborIndex] then
							newToVisit[neighborIndex] = blocks[neighborIndex]
						end
					end
				end

				toVisit = newToVisit
				if not didSomething then break end
			end

			table.insert(components, component)
		end
	end

	return components
end

return region

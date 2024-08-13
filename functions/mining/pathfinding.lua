-- pathfinding.lua
local helper = require("helper")

local pathfinding = {}

--- Heuristic function for A* pathfinding (Manhattan distance).
-- @param a The start position.
-- @param b The goal position.
-- @return number The estimated cost from a to b.
local function heuristic(a, b)
	return math.abs(a.x - b.x) + math.abs(a.y - b.y) + math.abs(a.z - b.z)
end

--- Implements the A* pathfinding algorithm.
-- @param start The starting position.
-- @param goal The goal position.
-- @param neighborsFunc Function to generate neighbor nodes.
-- @return table The path from start to goal, or nil if no path found.
function pathfinding.aStar(start, goal, neighborsFunc)
	local openSet = {[helper.getIndex(start.x, start.y, start.z)] = start}
	local cameFrom = {}
	local gScore = {[helper.getIndex(start.x, start.y, start.z)] = 0}
	local fScore = {[helper.getIndex(start.x, start.y, start.z)] = heuristic(start, goal)}

	while next(openSet) do
		local current
		for _, node in pairs(openSet) do
			if not current or fScore[helper.getIndex(node.x, node.y, node.z)] < fScore[helper.getIndex(current.x, current.y, current.z)] then
				current = node
			end
		end

		if helper.isPosEqual(current, goal) then
			local path = {}
			while current do
				table.insert(path, 1, current)
				current = cameFrom[helper.getIndex(current.x, current.y, current.z)]
			end
			return path
		end

		openSet[helper.getIndex(current.x, current.y, current.z)] = nil

		for _, neighbor in pairs(neighborsFunc(current)) do
			local tentativeGScore = gScore[helper.getIndex(current.x, current.y, current.z)] + 1
			local neighborIndex = helper.getIndex(neighbor.x, neighbor.y, neighbor.z)
			if tentativeGScore < (gScore[neighborIndex] or math.huge) then
				cameFrom[neighborIndex] = current
				gScore[neighborIndex] = tentativeGScore
				fScore[neighborIndex] = tentativeGScore + heuristic(neighbor, goal)
				openSet[neighborIndex] = neighbor
			end
		end
	end

	return nil -- No path found
end

return pathfinding

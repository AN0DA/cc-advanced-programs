-- config.lua
local helper = require("helper")

local config = {}

config.localConfig = {
	useRemoteConfig = false,
	remoteConfigPath = "http://localhost:33344/config.lua",
	defaultCommand = "cube 3 3 8",
	plugFluidsOnly = true,
	oreTraversalRadius = 0,
	layerSeparationAxis = "y",
	useEntangledChests = false,
	useFuelEntangledChest = false,
	mineLoop = false,
	mineLoopOffset = {x = 0, y = 0, z = 8},
	mineLoopCommand = "rcube 1 1 1"
}

--- Retrieves the remote configuration if enabled in the local configuration.
-- @param remotePath The URL to fetch the remote configuration.
-- @return table The deserialized remote configuration or nil in case of failure.
-- @return string An error message if the retrieval fails.
function config.getRemoteConfig(remotePath)
	local handle, err = http.get(remotePath)
	if not handle then
		return nil, "Server not responding, using local configuration."
	end

	local data = handle.readAll()
	handle.close()

	local deser = textutils.unserialise(data)
	if not deser then
		return nil, "Couldn't parse remote configuration, using local."
	end

	for key in pairs(config.localConfig) do
		if deser[key] == nil then
			return nil, "Missing key '" .. key .. "' in remote configuration, using local."
		end
	end

	return deser
end

--- Validates the configuration data.
-- Ensures all required fields are present and valid.
-- @param configData The configuration data to validate.
-- @return boolean True if the configuration is valid, otherwise false.
-- @return string An error message if the validation fails.
function config.validate(configData)
	local requiredFields = {
		"useRemoteConfig", "defaultCommand", "plugFluidsOnly",
		"oreTraversalRadius", "layerSeparationAxis", "useEntangledChests",
		"useFuelEntangledChest", "mineLoop", "mineLoopOffset", "mineLoopCommand"
	}

	for _, field in ipairs(requiredFields) do
		if configData[field] == nil then
			return false, "Missing configuration field: " .. field
		end
		if field == "layerSeparationAxis" and not (configData[field] == "y" or configData[field] == "z") then
			return false, "Invalid value for 'layerSeparationAxis': " .. tostring(configData[field])
		end
	end

	return true, nil
end

--- Processes the configuration, validating and optionally fetching a remote config.
-- @return table The processed and validated configuration data.
function config.processConfig()
	local configData = config.localConfig
	if configData.useRemoteConfig then
		local remoteConfig, error = config.getRemoteConfig(configData.remoteConfigPath)
		if remoteConfig then
			configData = remoteConfig
		else
			helper.logError(error)
			print(error)
		end
	end

	local isValid, errorMsg = config.validate(configData)
	if not isValid then
		error(errorMsg)
	end

	return configData
end

return config

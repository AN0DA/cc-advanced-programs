-- Main interface for downloading, launching, updating, and managing functional code from GitHub

-- Configuration
local repoUrl = "https://github.com/AN0DA/cc-advanced-programs/raw/development/functions/"  -- Base URL for the GitHub repository
local basePath = "scripts/"  -- Base path for downloading folders
local programVersion = "v0.1"

local functionsList = {
    {name = "Mining", folder = "mining", mainScript = "main.lua", versionFile = "version.txt"},
    -- Add more functions as needed
}

-- Function to get the installed version of a program
local function getInstalledVersion(folder)
    local versionFilePath = fs.combine(basePath, fs.combine(folder, "version.txt"))
    if fs.exists(versionFilePath) then
        local file = fs.open(versionFilePath, "r")
        local version = file.readAll()
        file.close()
        return version
    else
        return nil
    end
end

-- Function to get the latest version from GitHub
local function getLatestVersion(folder)
    local versionUrl = repoUrl .. folder .. "/version.txt"
    local response = http.get(versionUrl)
    if response then
        local version = response.readAll()
        response.close()
        return version
    else
        return nil
    end
end

-- Function to check for updates
local function checkForUpdates(functionName, currentVersion, folder)
    local latestVersion = getLatestVersion(folder)
    if latestVersion and latestVersion ~= currentVersion then
        print("Update available for " .. functionName)
        print("Installed version: " .. currentVersion)
        print("Latest version: " .. latestVersion)
        print("1. Update now")
        print("0. Cancel")
        local choice = tonumber(read())
        return choice == 1
    else
        print("No updates available for " .. functionName)
        return false
    end
end

-- Function to uninstall a program
local function uninstallProgram(folder)
    local targetFolder = fs.combine(basePath, folder)
    if fs.exists(targetFolder) then
        fs.delete(targetFolder)
        print(folder .. " has been uninstalled.")
    else
        print(folder .. " is not installed.")
    end
end

-- Function to launch a program
local function launchProgram(folder, mainScript)
    local scriptPath = fs.combine(basePath, fs.combine(folder, mainScript))
    if fs.exists(scriptPath) then
        shell.run(scriptPath)
    else
        print("Main script not found: " .. scriptPath)
    end
end

-- Function to display the graphical interface
local function displayMenu()
    term.clear()
    term.setCursorPos(1, 1)

    local width, height = term.getSize()
    local title = "[DIQ] Dynamic Installation Qualifier [DIQ]"

    -- Draw title
    term.setCursorPos(math.floor((width - #title) / 2), 2)
    term.setTextColor(colors.yellow)
    print(title)

    -- Display Program Version
    term.setCursorPos(math.floor((width - #programVersion) / 2), 3)
    term.setTextColor(colors.cyan)
    print("Version: " .. programVersion)

    -- Draw options
    term.setTextColor(colors.white)
    local y = 6
    for i, func in ipairs(functionsList) do
        local installedVersion = getInstalledVersion(func.folder)
        term.setCursorPos(math.floor((width - #func.name - 3) / 2), y)
        print("[" .. i .. "] " .. func.name .. (installedVersion and " (Installed: " .. installedVersion .. ")" or ""))
        y = y + 2
    end

    -- Draw exit option
    term.setCursorPos(math.floor((width - 9) / 2), y)
    print("[0] Exit")

    -- Prompt
    term.setCursorPos(1, height)
    term.setTextColor(colors.lime)
    write("Select an option: ")
    term.setTextColor(colors.white)
end

-- Function to display a progress bar
local function displayProgressBar(percentage, width)
    local filledWidth = math.floor(width * percentage)
    local emptyWidth = width - filledWidth

    term.write("[")
    term.write(string.rep("=", filledWidth))
    term.write(string.rep(" ", emptyWidth))
    term.write("] " .. math.floor(percentage * 100) .. "%")
end

-- Function to download a folder recursively from the GitHub repo
local function downloadFolder(baseUrl, folder, targetPath, version)
    local url = baseUrl .. folder .. "/"
    local response = http.get(url .. "list.txt")  -- Assuming you have a list.txt in each folder that lists all files
    if response then
        local files = response.readAll()
        response.close()
        local fileCount = select(2, files:gsub('\n', '\n')) + 1
        local downloadedFiles = 0

        for file in files:gmatch("[^\r\n]+") do
            local fileUrl = url .. file
            local fileResponse = http.get(fileUrl)
            if fileResponse then
                local filePath = fs.combine(targetPath, file)
                fs.makeDir(fs.getDir(filePath))
                local fileHandle = fs.open(filePath, "w")
                fileHandle.write(fileResponse.readAll())
                fileHandle.close()
                fileResponse.close()

                downloadedFiles = downloadedFiles + 1
                local progress = downloadedFiles / fileCount
                term.clearLine()
                term.setCursorPos(1, 4)
                displayProgressBar(progress, 20)
            else
                print("Failed to download " .. file .. ". Please check your connection or the URL and try again.")
                return false
            end
        end

        -- Write the version file
        local versionFile = fs.open(fs.combine(targetPath, "version.txt"), "w")
        versionFile.write(version)
        versionFile.close()

        print("\nDownload completed successfully.")
        return true
    else
        print("Failed to retrieve file list for folder " .. folder .. ". Please check the repository URL.")
        return false
    end
end

-- Function to display error message in the center of the screen
local function displayError(message)
    term.clear()
    local width, height = term.getSize()
    local xPos = math.floor((width - #message) / 2)
    local yPos = math.floor(height / 2)

    term.setCursorPos(xPos, yPos)
    term.setTextColor(colors.red)
    print(message)
    term.setTextColor(colors.white)
end

-- Main loop
while true do
    displayMenu()
    local choice = tonumber(read())

    if choice == 0 then
        print("Exiting...")
        break
    elseif choice and functionsList[choice] then
        local selectedFunction = functionsList[choice]
        local targetFolder = fs.combine(basePath, selectedFunction.folder)
        fs.makeDir(targetFolder)

        local installedVersion = getInstalledVersion(selectedFunction.folder)
        if not installedVersion then
            -- If installation is incomplete or corrupted
            displayError("Installation Incomplete or Corrupted")
            print("\n1. Reinstall " .. selectedFunction.name)
            print("2. Uninstall " .. selectedFunction.name)
            print("0. Back")
            local action = tonumber(read())

            if action == 1 then
                print("Reinstalling " .. selectedFunction.name .. "...")
                local success = downloadFolder(repoUrl, selectedFunction.folder, targetFolder, selectedFunction.version)
                if not success then
                    print("Reinstallation failed.")
                end
            elseif action == 2 then
                print("Uninstalling " .. selectedFunction.name .. "...")
                uninstallProgram(selectedFunction.folder)
            end
        else
            -- If installation is complete
            term.clear()
            term.setCursorPos(1, 1)
            print("[" .. selectedFunction.name .. " is already installed.]")
            print("Version: " .. installedVersion)
            print("1. Reinstall " .. selectedFunction.name)
            print("2. Launch " .. selectedFunction.name)
            print("3. Check for updates")
            print("4. Uninstall " .. selectedFunction.name)
            print("0. Back")
            local action = tonumber(read())

            if action == 1 then
                print("Reinstalling " .. selectedFunction.name .. "...")
                local success = downloadFolder(repoUrl, selectedFunction.folder, targetFolder, selectedFunction.version)
                if not success then
                    print("Reinstallation failed.")
                end
            elseif action == 2 then
                print("Launching " .. selectedFunction.name .. "...")
                launchProgram(selectedFunction.folder, selectedFunction.mainScript)
            elseif action == 3 then
                print("Checking for updates for " .. selectedFunction.name .. "...")
                if checkForUpdates(selectedFunction.name, installedVersion, selectedFunction.folder) then
                    print("Updating " .. selectedFunction.name .. "...")
                    local success = downloadFolder(repoUrl, selectedFunction.folder, targetFolder, selectedFunction.version)
                    if not success then
                        print("Update failed.")
                    end
                end
            elseif action == 4 then
                print("Uninstalling " .. selectedFunction.name .. "...")
                uninstallProgram(selectedFunction.folder)
            end
        end

        print("Press any key to continue...")
        os.pullEvent("key")
    else
        print("Invalid choice, please try again.")
        sleep(2)
    end
end

term.clear()
term.setCursorPos(1, 1)
print("Program ended.")

# Dynamic Installation Qualifier

## Overview

The **Dynamic Installation Qualifier** is a versatile and user-friendly program designed for ComputerCraft, a mod for Minecraft. This program serves as a central hub for downloading, installing, managing, and updating various functional scripts from a GitHub repository. It allows users to easily access and manage different functionalities, such as mining automation, farming, and more, directly from their in-game ComputerCraft terminals.

## Features

- **Download and Install Functional Scripts**: Easily download and install various scripts from a GitHub repository.
- **Launch Installed Programs**: Quickly launch installed scripts directly from the interface.
- **Check for Updates**: Automatically check for and install updates for installed scripts.
- **Uninstall Programs**: Uninstall scripts you no longer need with a simple option.
- **Error Handling**: Detects incomplete or corrupted installations and provides clear instructions for resolving the issue.
- **Graphical User Interface**: A user-friendly interface that makes managing scripts straightforward, with features like progress bars and centered error messages.

## Installation

### Prerequisites

- **ComputerCraft**: Ensure you have the ComputerCraft mod installed in your Minecraft setup.
- **HTTP API**: The HTTP API must be enabled in ComputerCraft. You can enable it by setting `enableAPI_http` to `true` in the `ComputerCraft.cfg` file.

### Installation Steps

1. **Clone the Repository**: Clone this repository to your local machine.
2. **Copy the Main Program**: Copy the main script `main.lua` to your ComputerCraft computer.

3. **Run the Program**:
   - Place the script in your ComputerCraft computer's root directory.
   - Run the script using the command:

     ```bash
     lua main.lua
     ```

   - Follow the on-screen instructions to download, install, and manage your scripts.

## Usage

### Main Menu

When you run the program, you’ll be presented with a list of available functions that you can download and manage. The main menu options include:

- **[Number] Function Name**: Displays the function name and whether it is installed or not.
- **[0] Exit**: Exit the program.

### Managing Installed Programs

When a function is selected, you will be provided with options:

- **Reinstall**: Re-download and reinstall the script.
- **Launch**: Launch the script (if installed).
- **Check for Updates**: Check if there is a newer version available on GitHub.
- **Uninstall**: Remove the script from your computer.
- **Back**: Return to the main menu.

### Error Handling

If an installation is incomplete or corrupted, the program will display a large red error message at the center of the screen. In this state, you can only:

- **Reinstall**: Attempt to reinstall the program.
- **Uninstall**: Remove the incomplete installation.
- **Back**: Return to the main menu.

## Development Guide

### Adding New Functions

You can expand the functionality of the **Dynamic Installation Qualifier** by adding new scripts to the GitHub repository and modifying the program to include these new functions.

#### Step 1: Prepare Your Script

1. **Create a New Directory**: Create a new directory for your function in the GitHub repository (e.g., `farming`).
2. **Add Your Scripts**: Place your Lua scripts in this directory. Ensure the main entry point of your function is named appropriately (e.g., `main.lua`).

3. **Create a `list.txt` File**:

   - This file should contain a list of all scripts in the directory that need to be downloaded.
   - Example `list.txt`:

     ```txt
     main.lua
     config.lua
     helper.lua
     ```

4. **Create a `version.txt` File**:
   - This file should contain the version number of the script. For example:

     ```txt
     1.0
     ```

#### Step 2: Update the Main Program

1. **Add the Function to `functionsList`**:

   - Open `main.lua` in your preferred text editor.
   - Add your new function to the `functionsList` array. For example:

     ```lua
     local functionsList = {
         {name = "Mining", folder = "mining", mainScript = "main.lua", versionFile = "version.txt", versionUrl = "https://raw.githubusercontent.com/AN0DA/cc-advanced-programs/main/mining/version.txt"},
         {name = "Farming", folder = "farming", mainScript = "main.lua", versionFile = "version.txt", versionUrl = "https://raw.githubusercontent.com/AN0DA/cc-advanced-programs/main/farming/version.txt"},
         -- Add more functions as needed
     }
     ```

   - Replace the `versionUrl` with the correct URL pointing to the `version.txt` file in the new function’s GitHub directory.

2. **Test Your Script**:
   - Run the main program and ensure your new function appears in the list.
   - Test downloading, launching, updating, and uninstalling your function to make sure everything works correctly.

### Debugging

If you encounter issues while developing:

- **Check HTTP Connections**: Ensure the HTTP API is enabled and that your ComputerCraft computer has internet access.
- **File Paths**: Verify that all file paths in `list.txt` and the main script are correct.
- **Error Messages**: Read the error messages carefully; they will guide you to the issue. If the installation is incomplete, the program will alert you and provide options to reinstall or uninstall.

## Contributing

Contributions are welcome! If you’d like to contribute to this project, please fork the repository and submit a pull request. Before submitting, please make sure to:

- Test your changes thoroughly.
- Follow the coding style used in the project.
- Update the README if necessary.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

![Quicky Icon](icon/monster.ico)

# Quicky - Fast SSH Connections with PuTTY

**Quicky** is a simple, open-source graphical user interface (GUI) for quickly establishing SSH connections using PuTTY. With Quicky, users can save connection settings and avoid repeatedly entering IP addresses, usernames, and passwords, all from an easy-to-use interface.

## Features

- Quick and straightforward SSH connections via PuTTY
- Save default IP address, username, password, and PuTTY executable path
- Editable connection settings
- Suppresses PowerShell windows to keep the interface clean
- Works on Windows using .NET and Windows Forms

## How to Use

1. **Download the executable**:
   - You can find the compiled `.exe` file in `/final/quicky.exe`.
2. **Launch Quicky**:
   - Run `quicky.exe` to start the application. 
3. **Enter connection details**:
   - Input the target IP address, username, and password.
4. **Click "Connect"**:
   - Once you’ve entered the required details, click the "Connect" button to initiate the SSH session using PuTTY.
5. **Adjust settings**:
   - Click the "Settings" button to modify the default connection details (IP address, username, password) or the path to PuTTY.

## Installation

1. Ensure you have PuTTY installed. You can download it from [here](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).
2. Download `quicky.exe` from this repository and place it in your desired location.
3. Run the executable to start using Quicky!

## Configuration

Quicky stores the following configuration details in `settings.txt`:
- Default IP address
- PuTTY executable path
- Username
- Password

These settings can be edited directly from the "Settings" menu within the GUI.

## License

This project is licensed under the MIT License.

---

Enjoy fast and convenient SSH connections with Quicky!

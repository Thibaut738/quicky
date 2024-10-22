# Suppress PowerShell window
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    public const int SW_HIDE = 0;
    public const int SW_SHOW = 5;
}
"@
$consolePtr = [Win32]::GetConsoleWindow()
[Win32]::ShowWindow($consolePtr, 0)  # Hide the console window

# Preload Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Path to the settings file
$configFilePath = ".\settings.txt"

# Function to load the settings (default IP, PuTTY path, username, and password)
function Load-Settings {
    if (Test-Path $configFilePath) {
        return Get-Content $configFilePath
    } else {
        # Default settings if the file doesn't exist
        return @("192.168.10.1", "C:\Program Files\PuTTY\putty.exe", "", "")
    }
}

# Function to save settings to the file
function Save-Settings {
    param ($ip, $puttyPath, $username, $password)
    "$ip`n$puttyPath`n$username`n$password" | Set-Content -Path $configFilePath
}

# Cache the settings to reduce file system calls
$settings = Load-Settings
$defaultIP = $settings[0]
$puttyPath = $settings[1]
$username = $settings[2]
$password = $settings[3]

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.SuspendLayout()  # Suspend layout while adding controls to improve performance
$form.Text = "PuTTY Login"
$form.Size = New-Object System.Drawing.Size(300,300)
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen  # Center the form

# Create a label for IP address input
$labelIP = New-Object System.Windows.Forms.Label
$labelIP.Text = "Enter IP Address:"
$labelIP.Location = New-Object System.Drawing.Point(10,20)
$form.Controls.Add($labelIP)

# Create a textbox for IP address input
$textboxIP = New-Object System.Windows.Forms.TextBox
$textboxIP.Text = $defaultIP  # Load the default IP
$textboxIP.Location = New-Object System.Drawing.Point(10,50)
$textboxIP.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textboxIP)

# Create a label for username input
$labelUsername = New-Object System.Windows.Forms.Label
$labelUsername.Text = "Enter Username:"
$labelUsername.Location = New-Object System.Drawing.Point(10,80)
$form.Controls.Add($labelUsername)

# Create a textbox for username input
$textboxUsername = New-Object System.Windows.Forms.TextBox
$textboxUsername.Text = $username  # Load the default username
$textboxUsername.Location = New-Object System.Drawing.Point(10,110)
$textboxUsername.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textboxUsername)

# Create a label for password input
$labelPassword = New-Object System.Windows.Forms.Label
$labelPassword.Text = "Enter Password:"
$labelPassword.Location = New-Object System.Drawing.Point(10,140)
$form.Controls.Add($labelPassword)

# Create a textbox for password input
$textboxPassword = New-Object System.Windows.Forms.TextBox
$textboxPassword.Text = $password  # Load the saved password if any
$textboxPassword.Location = New-Object System.Drawing.Point(10,170)
$textboxPassword.Size = New-Object System.Drawing.Size(260,20)
$textboxPassword.UseSystemPasswordChar = $true  # Hide password input
$form.Controls.Add($textboxPassword)

# Create a "Connect" button
$buttonConnect = New-Object System.Windows.Forms.Button
$buttonConnect.Text = "Connect"
$buttonConnect.Location = New-Object System.Drawing.Point(200,200)
$form.Controls.Add($buttonConnect)

# Create a "Settings" button
$buttonSettings = New-Object System.Windows.Forms.Button
$buttonSettings.Text = "Settings"
$buttonSettings.Location = New-Object System.Drawing.Point(10,200)
$form.Controls.Add($buttonSettings)

$form.ResumeLayout()  # Resume layout after adding controls

# Function to handle login action
function Invoke-Login {
    $ip = $textboxIP.Text
    $user = $textboxUsername.Text
    $pw = $textboxPassword.Text
    if ($ip -ne "" -and (Test-Path $puttyPath) -and $user -ne "" -and $pw -ne "") {
        Start-Process -FilePath $puttyPath -ArgumentList "-ssh $user@$ip -pw $pw"
        $form.Close()
    } else {
        [System.Windows.Forms.MessageBox]::Show("Invalid IP, Username, Password, or PuTTY path.")
    }
}

# Add button click event for "Connect"
$buttonConnect.Add_Click({
    Invoke-Login
})

# Handle pressing Enter in the textbox
$textboxIP.Add_KeyDown({
    if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {
        Invoke-Login
    }
})
$textboxUsername.Add_KeyDown({
    if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {
        Invoke-Login
    }
})
$textboxPassword.Add_KeyDown({
    if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {
        Invoke-Login
    }
})

# Function to open settings dialog
function Open-SettingsDialog {
    $settingsForm = New-Object System.Windows.Forms.Form
    $settingsForm.SuspendLayout()  # Suspend layout during control creation
    $settingsForm.Text = "Settings"
    $settingsForm.Size = New-Object System.Drawing.Size(300,350)
    $settingsForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent  # Center the settings form relative to the parent

    # Label for default IP
    $settingsLabelIP = New-Object System.Windows.Forms.Label
    $settingsLabelIP.Text = "Default IP Address:"
    $settingsLabelIP.Location = New-Object System.Drawing.Point(10,20)
    $settingsForm.Controls.Add($settingsLabelIP)

    # Textbox for default IP input
    $settingsTextboxIP = New-Object System.Windows.Forms.TextBox
    $settingsTextboxIP.Text = $defaultIP
    $settingsTextboxIP.Location = New-Object System.Drawing.Point(10,50)
    $settingsTextboxIP.Size = New-Object System.Drawing.Size(260,20)
    $settingsForm.Controls.Add($settingsTextboxIP)

    # Label for PuTTY path
    $settingsLabelPutty = New-Object System.Windows.Forms.Label
    $settingsLabelPutty.Text = "PuTTY Executable Path:"
    $settingsLabelPutty.Location = New-Object System.Drawing.Point(10,80)
    $settingsForm.Controls.Add($settingsLabelPutty)

    # Textbox for PuTTY path input
    $settingsTextboxPutty = New-Object System.Windows.Forms.TextBox
    $settingsTextboxPutty.Text = $puttyPath
    $settingsTextboxPutty.Location = New-Object System.Drawing.Point(10,110)
    $settingsTextboxPutty.Size = New-Object System.Drawing.Size(260,20)
    $settingsForm.Controls.Add($settingsTextboxPutty)

    # Label for default username
    $settingsLabelUsername = New-Object System.Windows.Forms.Label
    $settingsLabelUsername.Text = "Default Username:"
    $settingsLabelUsername.Location = New-Object System.Drawing.Point(10,140)
    $settingsForm.Controls.Add($settingsLabelUsername)

    # Textbox for default username input
    $settingsTextboxUsername = New-Object System.Windows.Forms.TextBox
    $settingsTextboxUsername.Text = $username
    $settingsTextboxUsername.Location = New-Object System.Drawing.Point(10,170)
    $settingsTextboxUsername.Size = New-Object System.Drawing.Size(260,20)
    $settingsForm.Controls.Add($settingsTextboxUsername)

    # Label for default password
    $settingsLabelPassword = New-Object System.Windows.Forms.Label
    $settingsLabelPassword.Text = "Default Password:"
    $settingsLabelPassword.Location = New-Object System.Drawing.Point(10,200)
    $settingsForm.Controls.Add($settingsLabelPassword)

    # Textbox for default password input
    $settingsTextboxPassword = New-Object System.Windows.Forms.TextBox
    $settingsTextboxPassword.Text = $password
    $settingsTextboxPassword.Location = New-Object System.Drawing.Point(10,230)
    $settingsTextboxPassword.Size = New-Object System.Drawing.Size(260,20)
    $settingsTextboxPassword.UseSystemPasswordChar = $true  # Hide password input
    $settingsForm.Controls.Add($settingsTextboxPassword)

    # Save button
    $saveButton = New-Object System.Windows.Forms.Button
    $saveButton.Text = "Save"
    $saveButton.Location = New-Object System.Drawing.Point(200,260)
    $settingsForm.Controls.Add($saveButton)

    $settingsForm.ResumeLayout()  # Resume layout after controls are added

    # Event handler for saving the default IP, PuTTY path, username, and password
    $saveButton.Add_Click({
        $newIP = $settingsTextboxIP.Text
        $newPuttyPath = $settingsTextboxPutty.Text
        $newUsername = $settingsTextboxUsername.Text
        $newPassword = $settingsTextboxPassword.Text
        if ($newIP -ne "" -and (Test-Path $newPuttyPath) -and $newUsername -ne "" -and $newPassword -ne "") {
            Save-Settings $newIP $newPuttyPath $newUsername $newPassword
            $defaultIP = $newIP  # Update the default IP in the main form
            $puttyPath = $newPuttyPath  # Update the PuTTY path
            $username = $newUsername  # Update the username
            $password = $newPassword  # Update the password
            $textboxIP.Text = $defaultIP  # Update the main form's textbox
            $textboxUsername.Text = $username  # Update the main form's username textbox
            $textboxPassword.Text = $password  # Update the main form's password textbox
            $settingsForm.Close()
        } else {
            [System.Windows.Forms.MessageBox]::Show("Invalid IP, Username, Password, or PuTTY path.")
        }
    })

    # Show settings dialog modally
    $settingsForm.ShowDialog($form)
}

# Add button click event for "Settings"
$buttonSettings.Add_Click({
    Open-SettingsDialog
})

# Show the main form
$form.Topmost = $true
$form.ShowDialog()

import tkinter as tk
from tkinter import messagebox
import os
import subprocess
import ctypes

#build command: & "C:\Users\Gebruiker\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.11_qbz5n2kfra8p0\LocalCache\local-packages\Python311\Scripts\pyinstaller.exe" --noconsole --icon="C:\Users\Gebruiker\Documents\test\putty\icon\monster.ico" "C:\Users\Gebruiker\Documents\test\python scripts\quicky.py"

# Hide console window
ctypes.windll.kernel32.FreeConsole()

# Settings file path
config_file_path = "settings.txt"

# Function to load settings (default IP, PuTTY path, username, and password)
def load_settings():
    if os.path.exists(config_file_path):
        with open(config_file_path, "r") as f:
            lines = f.read().splitlines()
            return lines if len(lines) == 4 else ["192.168.10.1", "C:\\Program Files\\PuTTY\\putty.exe", "", ""]
    else:
        return ["192.168.10.1", "C:\\Program Files\\PuTTY\\putty.exe", "", ""]

# Function to save settings to the file
def save_settings(ip, putty_path, username, password):
    with open(config_file_path, "w") as f:
        f.write(f"{ip}\n{putty_path}\n{username}\n{password}\n")

# Load cached settings
settings = load_settings()
default_ip, putty_path, default_username, default_password = settings

# Function to handle login action
def invoke_login():
    ip = ip_entry.get().strip()
    username = username_entry.get().strip()
    password = password_entry.get().strip()

    if ip and os.path.exists(putty_path) and username and password:
        subprocess.Popen([putty_path, f"{username}@{ip}", "-pw", f"{password}"])
        root.destroy()  # Close the main window
    else:
        messagebox.showerror("Error", "Invalid IP, Username, Password, or PuTTY path.")

# Function to update the main form with new settings
def update_main_form():
    global default_ip, putty_path, default_username, default_password
    settings = load_settings()  # Reload the latest saved settings
    default_ip, putty_path, default_username, default_password = settings

    # Update the fields in the main form
    ip_entry.delete(0, tk.END)
    ip_entry.insert(0, default_ip)
    username_entry.delete(0, tk.END)
    username_entry.insert(0, default_username)
    password_entry.delete(0, tk.END)
    password_entry.insert(0, default_password)
    
# Function to open settings dialog
def open_settings_dialog():
    settings_window = tk.Toplevel(root)
    settings_window.title("Settings")
    settings_window.geometry("300x300")
    settings_window.transient(root)
    settings_window.grab_set()

    # Center the settings window relative to the main window
    root_x = root.winfo_x()
    root_y = root.winfo_y()
    root_width = root.winfo_width()
    root_height = root.winfo_height()

    settings_width = 300
    settings_height = 300

    center_x = root_x + (root_width - settings_width) // 2
    center_y = root_y + (root_height - settings_height) // 2
    settings_window.geometry(f"{settings_width}x{settings_height}+{center_x}+{center_y}")

    # Settings fields
    tk.Label(settings_window, text="Default IP Address:", anchor="w").pack(fill="x", pady=5)
    settings_ip_entry = tk.Entry(settings_window)
    settings_ip_entry.insert(0, default_ip)
    settings_ip_entry.pack(fill="x", padx=5, pady=5)

    tk.Label(settings_window, text="PuTTY Executable Path:", anchor="w").pack(fill="x", pady=5)
    settings_putty_entry = tk.Entry(settings_window)
    settings_putty_entry.insert(0, putty_path)
    settings_putty_entry.pack(fill="x", padx=5, pady=5)

    tk.Label(settings_window, text="Default Username:", anchor="w").pack(fill="x", pady=5)
    settings_username_entry = tk.Entry(settings_window)
    settings_username_entry.insert(0, default_username)
    settings_username_entry.pack(fill="x", padx=5, pady=5)

    tk.Label(settings_window, text="Default Password:", anchor="w").pack(fill="x", pady=5)
    settings_password_entry = tk.Entry(settings_window, show="*")
    settings_password_entry.insert(0, default_password)
    settings_password_entry.pack(fill="x", padx=5, pady=5)

    def save_and_close():
        new_ip = settings_ip_entry.get().strip()
        new_putty_path = settings_putty_entry.get().strip()
        new_username = settings_username_entry.get().strip()
        new_password = settings_password_entry.get().strip()

        if new_ip and os.path.exists(new_putty_path) and new_username and new_password:
            save_settings(new_ip, new_putty_path, new_username, new_password)
            settings[:] = [new_ip, new_putty_path, new_username, new_password]
            settings_window.destroy()
            update_main_form()  # Reload the main form with updated settings
        else:
            messagebox.showerror("Error", "Invalid IP, Username, Password, or PuTTY path.")

    # Save button with larger size
    save_button = tk.Button(settings_window, text="Save", command=save_and_close, width=10, height=8)
    save_button.pack(pady=10, padx=10, ipadx=10, ipady=10)



# Main GUI window
root = tk.Tk()
root.title("PuTTY Login")
root.geometry("300x250")
root.resizable(False, False)
root.eval('tk::PlaceWindow . center')

# Layout for the main form
padding_x = 10

# Make columns expandable
root.grid_columnconfigure(0, weight=1)

# IP Address Input
tk.Label(root, text="Enter IP Address:", anchor="w").grid(row=0, column=0, sticky="w", padx=padding_x, pady=5)
ip_entry = tk.Entry(root)
ip_entry.insert(0, default_ip)
ip_entry.grid(row=1, column=0, padx=padding_x, pady=5, sticky="ew")  # Sticky east-west for full width

# Username Input
tk.Label(root, text="Enter Username:", anchor="w").grid(row=2, column=0, sticky="w", padx=padding_x, pady=5)
username_entry = tk.Entry(root)
username_entry.insert(0, default_username)
username_entry.grid(row=3, column=0, padx=padding_x, pady=5, sticky="ew")

# Password Input
tk.Label(root, text="Enter Password:", anchor="w").grid(row=4, column=0, sticky="w", padx=padding_x, pady=5)
password_entry = tk.Entry(root, show="*")
password_entry.insert(0, default_password)
password_entry.grid(row=5, column=0, padx=padding_x, pady=5, sticky="ew")

# Buttons in the same row
button_frame = tk.Frame(root)
button_frame.grid(row=6, column=0, pady=10, sticky="ew")
button_frame.grid_columnconfigure(0, weight=1)  # Expand buttons horizontally
button_frame.grid_columnconfigure(1, weight=1)

connect_button = tk.Button(button_frame, text="Connect", command=invoke_login)
connect_button.grid(row=0, column=1, padx=5)

settings_button = tk.Button(button_frame, text="Settings", command=open_settings_dialog)
settings_button.grid(row=0, column=0, padx=5)

# Bind Enter key to login
root.bind("<Return>", lambda event: invoke_login())

# Show the main GUI
root.mainloop()
# BlizzAPIs - PowerShell Modules for World of Warcraft API

![PowerShell](https://img.shields.io/badge/PowerShell-7+-blue)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

**Author**: Strandmaus / Jana Baldszun

---

## 🚀 What These PowerShell Modules Do

- **Simplified API Requests**: Easily authenticate and query World of Warcraft API endpoints.
- **Data Processing**: Convert JSON responses into structured PowerShell objects for easy handling.
- **MySQL Integration**: Import API data into existing MySQL tables.
- **Automation**: Schedule API requests with cron jobs (Linux) or Task Scheduler (Windows).
- **Cross-Platform Support**: Fully compatible with **PowerShell 7+** for both **Windows** and **Linux**.

---

## ✨ Why PowerShell?

While many developers use Python or Node.js for API work, PowerShell is often overlooked despite its capabilities.  
It's an excellent choice for admins and script enthusiasts who prefer efficient scripting over full-scale development.  
Thanks to PowerShell 7, cross-platform scripting (Windows and Linux) is now smoother than ever!

---

## 📦 Available Modules

| Module Name                  | Description |
| ----------------------------- | ----------- |
| **BlizzWoWRetailGameData**     | Interact with general game data like Mounts, Achievements, Professions, Quests, and more. |
| **BlizzWoWRetailProfile**      | Fetch character and guild profiles, achievements, collections, PvP stats, dungeon progress, etc. |
| **BlizzMySQLHelper**           | Import PowerShell objects into existing MySQL tables. The table structure must be created manually, and primary keys must be set up in advance. |

---

## 📚 Getting Started

### 1. Install the Modules from PowerShell Gallery

```powershell
Install-Module -Name BlizzWoWRetailGameData
Install-Module -Name BlizzWoWRetailProfile
Install-Module -Name BlizzMySQLHelper
```

> ⚡ **Note**:  
> If prompted to trust the repository, choose `Yes` to proceed.

---

### 2. Create a Blizzard API Account

To access the World of Warcraft API, you need to register as a developer and create API credentials.  
Follow the guide here:  
👉 [Get Started with Blizzard API](https://develop.battle.net/documentation/guides/getting-started)

Once registered, you'll receive a **Client ID** and a **Client Secret**.

---

### 3. Authenticate with Blizzard API

Use your credentials to request an access token:

```powershell
Set-WoWApiAccessToken -ClientId 'your-client-id' -ClientSecret 'your-client-secret'
```

---

### 4. Start Using the API

#### Fetch All Mounts
```powershell
Get-MountIndex
```

#### Fetch Character Profile
```powershell
Get-CharacterProfile -Realm 'blackhand' -Name 'yourcharacter'
```

---

### 5. Import Data into MySQL

#### Example for Importing a Character Object

```powershell
# Step 1: Open a MySQL connection
Open-MySqlConnection -Credential $MySQLCreds -ConnectionName 'MyDatabase' -Server 'localhost' -Database 'wow'

# Step 2: Create a PowerShell object matching your table structure
$CharacterObject = [PSCustomObject]@{
    Name  = 'Strandmaus'
    Realm = 'Azshara'
    Level = 60
}

# Step 3: Import the object into the MySQL table
Import-BlizzObject -Table 'characters' -Object $CharacterObject -ConnectionName 'MyDatabase'
```

> ⚡ **Important:**  
> - The MySQL table must be created manually before importing.  
> - Column names must exactly match the PowerShell object properties.  
> - A primary key must be set for `ON DUPLICATE KEY UPDATE` behavior to work.

---

## 📝 Requirements

- PowerShell 7 or higher
- Blizzard Developer Credentials (Client ID and Secret)
- SimplySql PowerShell module
- Optional: MySQL Server (if using BlizzMySQLHelper)

---

## 🔗 Where to Find the Modules

You can check out my modules at the [PowerShell Gallery Profile](https://www.powershellgallery.com/profiles/JanaBaldszun).

---

## 💬 Feedback

I would love to hear your feedback!  
If you're using the World of Warcraft API with PowerShell, feel free to share your thoughts, suggestions, or show how you are using these modules in your own projects!

---

## ⚖️ License

This project is licensed under the **MIT License**.

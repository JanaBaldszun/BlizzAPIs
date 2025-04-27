# BlizzAPIs - PowerShell Modules for World of Warcraft API

## 📚 Table of Contents

- [What These PowerShell Modules Do](#-what-these-powershell-modules-do)
- [Why PowerShell](#-why-powershell)
- [Available Modules](#-available-modules)
- [Requirements](#-requirements)
- [Getting Started](#-getting-started)
- [Updates and Maintenance](#-updates-and-maintenance)
- [Where to Find the Modules](#-where-to-find-the-modules)
- [Feedback](#-feedback)
- [License](#-license)
- [Example: Fetching a Single Character and Importing it into MySQL](#-example-fetching-a-single-character-and-importing-it-into-mysql)
- [Example: Fetching All Mounts and Importing them into MySQL](#-example-fetching-all-mounts-and-importing-them-into-mysql)

---

## 🚀 What These PowerShell Modules Do

- **Simplified API Requests**: Easily authenticate and query World of Warcraft API endpoints.
- **Data Processing**: Convert JSON responses into structured PowerShell objects for easy handling.
- **MySQL Integration**: Import API data into existing MySQL tables.
- **Automation**: Schedule API requests with cron jobs (Linux) or Task Scheduler (Windows).
- **Cross-Platform Support**: Fully compatible with **PowerShell 7+** for both **Windows** and **Linux**.

---

## ✨ Why PowerShell?

While many developers use Python or Node.js for API work, PowerShell is often overlooked despite its capabilities. It's an excellent choice for admins and script enthusiasts who prefer efficient scripting over full-scale development. Thanks to PowerShell 7, cross-platform scripting (Windows and Linux) is now smoother than ever!

---

## 📦 Available Modules

| Module Name                | Description                                                                                                                                     |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| **BlizzWoWRetailGameData** | Interact with general game data like Mounts, Achievements, Professions, Quests, and more.                                                       |
| **BlizzWoWRetailProfile**  | Fetch character and guild profiles, achievements, collections, PvP stats, dungeon progress, etc.                                                |
| **BlizzMySQLHelper**       | Import PowerShell objects into existing MySQL tables. The table structure must be created manually, and primary keys must be set up in advance. |

---

## 🚧 Requirements

- **PowerShell 7 or higher**  
  👉 [Install Guide](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- **Blizzard Developer Credentials**  
  👉 [Blizzard Developer Portal](https://develop.battle.net/access/)
- If using **BlizzMySQLHelper**:
  - MySQL Server
  - SimplySql module  
    👉 [SimplySql on PowerShell Gallery](https://www.powershellgallery.com/packages/SimplySql)

---

## 🛠️ Getting Started

### 📌 1. Install Modules from PowerShell Gallery

```powershell
Install-Module -Name BlizzWoWRetailGameData
Install-Module -Name BlizzWoWRetailProfile
Install-Module -Name BlizzMySQLHelper
```
> ⚡ **Note**: If prompted to trust the repository, choose `Yes` to proceed.

### 📌 2. Create Blizzard API Account

To access the World of Warcraft API, register as a developer and create API credentials.  
👉 [Get Started with Blizzard API](https://develop.battle.net/documentation/guides/getting-started)

Once registered, you'll receive a **Client ID** and a **Client Secret**.  
👉 [Blizzard Developer Portal](https://develop.battle.net/access/)

### 📌 3. Authenticate with Blizzard API

```powershell
Set-WoWApiAccessToken -ClientId 'your-client-id' -ClientSecret 'your-client-secret'
```

### 📌 4. Start Using the API

Set the region and preferred language before making API requests:

```powershell
Set-WoWRegion -Region Europe -Language German
```

Then use the API commands:

- Fetch all mounts:
  ```powershell
  Get-MountIndex
  ```

- Fetch character profile:
  ```powershell
  Get-CharacterProfile -Realm 'blackhand' -Name 'yourcharacter'
  ```

---

## 🔄 Updates and Maintenance

World of Warcraft is continuously evolving. Although I strive to keep these modules updated, please note there may be occasional delays due to private maintenance. Feel free to open an issue or contact me through GitHub.

---

## 🔗 Where to Find the Modules

Modules are available at my [PowerShell Gallery Profile](https://www.powershellgallery.com/profiles/JanaBaldszun).

---

## 💬 Feedback

I appreciate your feedback! Share your thoughts, suggestions, or usage examples!

---

## ⚖️ License

This project is licensed under the **MIT License**.

---

## 📥 Example: Fetching a Single Character and Importing it into MySQL

This example shows how to fetch a single character profile from the Blizzard API and insert the relevant data into a MySQL table.

> ℹ️ **Note:** The `realmSlug` is the realm name, all lowercase, with special characters like apostrophes removed.  
> Example: `Krag'jin` ➔ `kragjin`

```powershell
# Define database connection details
$Server = 'localhost'
$Database = 'wow'
$User = 'root'
$Password = 'yourpassword'
$ConnectionName = 'MyDatabase'

# Open MySQL connection (requires SimplySql module)
Open-MySqlConnection -Server $Server -Database $Database -Username $User -Password $Password -ConnectionName $ConnectionName

# Define Blizzard API credentials
$clientId = '+++'
$clientSecret = '+++'

# Set API region and language
Set-WoWRegion -Region Europe -Language German

# Authenticate with Blizzard API
Set-WoWApiAccessToken -ClientId $clientId -ClientSecret $clientSecret

# Define table name and character info
$TargetTable = 'characters'
$RealmSlug = 'blackhand'
$CharacterName = 'Strandmaus'

# Fetch character data from Blizzard API
$Character = Get-CharacterProfile -realmSlug $RealmSlug -characterName $CharacterName

if ($Character) {
    $Date = Get-Date -Format 'yyyy.MM.dd HH:mm:ss'
    $LastLogin = (Get-Date -Date 01.01.1970).AddMilliseconds($Character.last_login_timestamp).ToLocalTime()
    $LastLogin = Get-Date -Date $LastLogin -Format 'yyyy.MM.dd HH:mm:ss'

    $Object = [PSCustomObject]@{
        characterID             = $Character.id
        lastModified            = $Date
        lastLogin               = $LastLogin
        name                    = $Character.name
        realm                   = $Character.realm.name
        class                   = $Character.character_class.id
        classname               = $Character.character_class.name
        spec                    = $Character.active_spec.id
        specname                = $Character.active_spec.name
        race                    = $Character.race.id
        racename                = $Character.race.name
        gender                  = if ($Character.gender.type -eq 'MALE') { 0 } else { 1 }
        level                   = $Character.level
        experience              = $Character.experience
        achievementPoints       = $Character.achievement_points
        faction                 = $Character.faction.name
        averageItemLevel        = $Character.average_item_level
        averageItemLevelEquipped= $Character.equipped_item_level
        title                   = if ($Character.active_title) { ($Character.active_title.display_string -replace '{name}', '') } else { '' }
        image                   = ('{0}/{1}/{2}-inset.jpg' -f $RealmSlug.ToLower(), '{0:x}' -f $Character.id -replace '^.*(..)$', '0x$1', $Character.id)
        profilepic              = ('{0}/{1}/{2}-main-raw.png' -f $RealmSlug.ToLower(), '{0:x}' -f $Character.id -replace '^.*(..)$', '0x$1', $Character.id)
        covenant                = $Character.covenant_progress.chosen_covenant.id
        renown                  = $Character.covenant_progress.renown_level
        rested                  = 0
        allied                  = 0
    }

    # Insert into MySQL
    Import-BlizzObject -Table $TargetTable -Object $Object -ConnectionName $ConnectionName
}

# Optional: update timestamps or close connection
Set-UpdatesDate -ConnectionName $ConnectionName -Filename $MyInvocation.MyCommand.Name
Close-SqlConnection -ConnectionName $ConnectionName
```

> ⚡ **Important:** Ensure the `characters` table already exists in MySQL and has columns matching the property names in the object.

---

## 🐎 Example: Fetching All Mounts and Importing them into MySQL

This example shows how to fetch all mounts from the Blizzard API and insert them into a MySQL table.

```powershell
# Define database connection details
$Server = 'localhost'
$Database = 'wow'
$User = 'root'
$Password = 'yourpassword'
$ConnectionName = 'MyDatabase'

# Open MySQL connection (requires SimplySql module)
Open-MySqlConnection -Server $Server -Database $Database -Username $User -Password $Password -ConnectionName $ConnectionName

# Define Blizzard API credentials
$clientId = '+++'
$clientSecret = '+++'

# Set API region and language
Set-WoWRegion -Region Europe -Language German

# Authenticate with Blizzard API
Set-WoWApiAccessToken -ClientId $clientId -ClientSecret $clientSecret

# Define table name
$TargetTable = 'mounts'

# Fetch all mounts
$Mounts = Get-MountIndex

# Loop through each mount and fetch details
foreach ($Mount in $Mounts) {
    $DataMount = Get-Mount -Id $Mount.id

    $Object = [PSCustomObject]@{
        igno      = if ($DataMount.should_exclude_if_uncollected) { 1 } else { 0 }
        id        = $Mount.id
        name      = $Mount.name
        displayid = $DataMount.creature_displays[0].id
        faction   = if ($DataMount.faction) { $DataMount.faction.name } else { '' }
        source    = if ($DataMount.source) { $DataMount.source.name } else { '' }
    }

    # Insert into MySQL
    Import-BlizzObject -Table $TargetTable -Object $Object -ConnectionName $ConnectionName
}

# Optional: update timestamps or close connection
Set-UpdatesDate -ConnectionName $ConnectionName -Filename $MyInvocation.MyCommand.Name
Close-SqlConnection -ConnectionName $ConnectionName
```

> ⚡ **Important:** Ensure the `mounts` table already exists in MySQL and has columns matching the property names in the object.
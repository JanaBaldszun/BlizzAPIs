# Examples - BlizzAPIs

Welcome to the Examples Section! 🚀

Here you will find practical examples of how to use the BlizzAPIs modules to interact with the World of Warcraft API and optionally import data into MySQL.

---

## 📥 Importing a Single Character into MySQL

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

## 🐉 Importing All Mounts into MySQL

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

---

function Set-WoWRegion
{
  <#
      .SYNOPSIS
      Sets the World of Warcraft API region and language for API requests.

      .DESCRIPTION
      The `Set-WoWRegion` function sets the region and language for World of Warcraft API requests by defining several global variables such as `WoWBaseURL`, `WoWRegion`, and `WoWLocalization`. 
      It supports regions like China, Europe, Korea, North America, and Taiwan, and dynamically assigns a language depending on the chosen region.

      The function takes the region as a mandatory parameter, and based on the region, it dynamically generates a list of valid languages for that region. It then sets the corresponding base URL, region code, and localization settings that are used in World of Warcraft API requests.

      .PARAMETER Region
      Specifies the World of Warcraft region for which to set the API base URL. The available regions are:
      - China
      - Europe
      - Korea
      - North America
      - Taiwan

      .PARAMETER Language
      Specifies the language for the World of Warcraft API requests. The available languages depend on the region. For example:
      - Europe: English, French, German, Italian, Russian, Spanish (Spain)
      - North America: English (United States), Portuguese, Spanish (Mexico)
      - China: Chinese (Simplified)

      This parameter is dynamically generated based on the selected region.

      .EXAMPLE
      Set-WoWRegion -Region Europe -Language German

      Sets the API region to Europe and the language to German. This updates the global variables for the base URL, region code, and localization settings for API requests.

      .EXAMPLE
      Set-WoWRegion -Region North America -Language English

      Sets the API region to North America and the language to English (United States).

      .NOTES
      This function dynamically defines the available languages based on the chosen region and sets the corresponding global variables used for World of Warcraft API queries.

      The global variables that are updated by this function are:
      - `$Global:WoWBaseURL`: The base URL for the selected region's API.
      - `$Global:WoWRegion`: The two-letter region code (e.g., US, EU).
      - `$Global:WoWLocalization`: The localization code for the selected language (e.g., en_GB, de_DE).

      The function also supports verbose output for debugging purposes, which prints the set values for the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft      
  #>

  param
  (
    [Parameter(Mandatory,HelpMessage = 'Specify the World of Warcraft region. Available options: China, Europe, Korea, North America, Taiwan.')][ValidateSet('China','Europe','Korea','North America','Taiwan')][String] 
    $Region  # The region to set (e.g., Europe, North America, etc.)
  )

  dynamicparam
  {
    # Define available languages based on the selected region
    $data = @{
      'China'       = 'Chinese (Simplified)'
      'Europe'      = 'English (Great Britain)', 'French', 'German', 'Italian', 'Russian', 'Spanish (Spain)'
      'Korea'       = 'Korean'
      'North America' = 'English (United States)', 'Portuguese', 'Spanish (Mexico)'
      'Taiwan'      = 'Chinese (Traditional)'
    }

    # Create dynamic parameter for Language based on the region
    $paramDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
    $attributeCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
    
    # Add the mandatory attribute to the dynamic parameter
    $attribute = New-Object -TypeName System.Management.Automation.ParameterAttribute
    $attribute.Mandatory = $true
    $attributeCollection.Add($attribute)
    
    # Validate the dynamic parameter with the correct set of languages based on region
    $attribute = New-Object -TypeName System.Management.Automation.ValidateSetAttribute -ArgumentList ($data.$Region)
    $attributeCollection.Add($attribute)
    
    # Create the dynamic Language parameter
    $attributeName = 'Language'
    $dynParam = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ($attributeName, [string], $attributeCollection)
    $paramDictionary.Add($attributeName, $dynParam)
    $paramDictionary
  }

  end
  {
    # Mapping language names to localization codes
    $regionLanguage = @{
      'Chinese (Simplified)'  = 'zh_CN'
      'Chinese (Traditional)' = 'zh_TW'
      'English (Great Britain)' = 'en_GB'
      'English (United States)' = 'en_US'
      'French'                = 'fr_FR'
      'German'                = 'de_DE'
      'Italian'               = 'it_IT'
      'Korean'                = 'ko_KR'
      'Portuguese'            = 'pt_BR'
      'Russian'               = 'ru_RU'
      'Spanish (Mexico)'      = 'es_MX'
      'Spanish (Spain)'       = 'es_ES'
    }

    # Mapping region names to base URLs
    $regionHost = @{
      'China'       = 'https://gateway.battlenet.com.cn/'
      'Europe'      = 'https://eu.api.blizzard.com/'
      'Korea'       = 'https://kr.api.blizzard.com/'
      'North America' = 'https://us.api.blizzard.com/'
      'Taiwan'      = 'https://tw.api.blizzard.com/'
    }

    # Mapping region names to two-letter codes
    $regionTwoLetter = @{
      'China'       = 'CN'
      'Europe'      = 'EU'
      'Korea'       = 'KR'
      'North America' = 'US'
      'Taiwan'      = 'TW'
    }

    # Set global variables based on the selected region and language
    $Global:WoWBaseURL = $regionHost.$Region
    $Global:WoWRegion = $regionTwoLetter.$Region
    $Global:WoWLocalization = $regionLanguage.$($PSBoundParameters.Language)
    
    # Verbose output if requested
    if($PSBoundParameters.Verbose)
    {
      Write-Verbose -Message ("The global variable WoWBaseURL has been set to '{0}'." -f ($Global:WoWBaseURL))
      Write-Verbose -Message ("The global variable WoWRegion has been set to '{0}'." -f ($Global:WoWRegion))
      Write-Verbose -Message ("The global variable WoWLocalization has been set to '{0}'." -f ($Global:WoWLocalization))
    }
  }
}

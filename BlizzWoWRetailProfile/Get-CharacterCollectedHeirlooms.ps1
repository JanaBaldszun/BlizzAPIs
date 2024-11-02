function Get-CharacterCollectedHeirlooms
{
  <#
      .SYNOPSIS
      Retrieves a World of Warcraft character's collected heirlooms.
  
      .DESCRIPTION
      This function connects to the World of Warcraft API to retrieve the collected heirlooms of a specified character from a specified realm. It uses global variables for API authentication and localization settings, and offers an option to return raw JSON data.
  
      .PARAMETER realmSlug
      The slug of the realm where the character resides. The slug is typically a lowercase, hyphenated version of the realm name (e.g., 'azshara').
  
      .PARAMETER characterName
      The name of the character to retrieve information for. This is case-insensitive and will be converted to lowercase.
  
      .PARAMETER Raw
      Switch parameter to indicate if the function should return the raw JSON data from the API. If this switch is omitted, the function will return a formatted list of collected heirlooms.
  
      .EXAMPLE
      Get-CharacterCollectedHeirlooms -realmSlug 'azshara' -characterName 'strandmaus'
      Retrieves and formats the collected heirlooms for the character "Strandmaus" from the "Azshara" realm.
  
      .EXAMPLE
      Get-CharacterCollectedHeirlooms -realmSlug 'azshara' -characterName 'strandmaus' -Raw
      Retrieves the raw JSON heirloom data for "Strandmaus" on the "Azshara" realm.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.

      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/profile-apis
  #>

  param (
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The slug of the realm.')]
    [ValidateNotNullOrEmpty()]
    [String]$realmSlug,

    [Parameter(Mandatory, Position = 1, HelpMessage = 'The character name.')]
    [ValidateNotNullOrEmpty()]
    [String]$characterName,

    [Parameter(Position = 2, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  $realmSlug = $realmSlug.ToLower()
  $characterName = $characterName.ToLower()

  if(Test-WoWApiConnection)
  {
    $URL = '{0}profile/wow/character/{1}/{2}/collections/heirlooms?namespace=profile-{3}&locale={4}' -f $Global:WoWBaseURL, $realmSlug, $characterName, $Global:WoWRegion, $Global:WoWLocalization

    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5

      if($result)
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty heirlooms |
          Sort-Object -Property id
        }
      }
    }
    catch 
    {
      $statusCode = $_.Exception.Response.StatusCode.value__
      $status = $_.Exception.Response.StatusCode
      Write-Verbose -Message ('Bad status code ({0}) {1}' -f $statusCode, $status)
    }
  }
}

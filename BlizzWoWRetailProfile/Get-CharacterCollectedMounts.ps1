function Get-CharacterCollectedMounts
{
  <#
      .SYNOPSIS
      Retrieves a list of mounts collected by a specified character in World of Warcraft.

      .DESCRIPTION
      This function connects to the World of Warcraft API to retrieve the collection of mounts 
      associated with a character. It requires the realm and character name and can return either 
      formatted or raw JSON data. The function relies on a global API connection and localization settings.

      .PARAMETER realmSlug
      The slug of the realm. This is required and must not be empty.

      .PARAMETER characterName
      The name of the character. This is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-CharacterCollectedMounts -realmSlug 'azshara' -characterName 'strandmaus'
      Retrieves a formatted list of mounts collected by Strandmaus on the Azshara realm.

      .EXAMPLE
      Get-CharacterCollectedMounts -realmSlug 'azshara' -characterName 'strandmaus' -Raw
      Retrieves the raw JSON response of mounts collected by Strandmaus on the Azshara realm.

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
    $URL = '{0}profile/wow/character/{1}/{2}/collections/mounts?namespace=profile-{3}&locale={4}' -f $Global:WoWBaseURL, $realmSlug, $characterName, $Global:WoWRegion, $Global:WoWLocalization
  
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      
      if($result -and $result.PSobject.Properties.name -contains 'mounts')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty mounts |
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

function Get-CharacterAchievementStatistics
{
  <#
      .SYNOPSIS
      Retrieves the achievement statistics of a specified character in World of Warcraft.

      .DESCRIPTION
      The function fetches a list of achievement statistics for a given character using the World of Warcraft API. The realm slug and character name are required parameters. An optional switch is available to return raw JSON data.

      .PARAMETER realmSlug
      The slug of the realm. This is required and must not be empty.

      .PARAMETER characterName
      The name of the character. This is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-CharacterAchievementStatistics -realmSlug 'azshara' -characterName 'strandmaus'
      Retrieves the achievement statistics for the character named Strandmaus on the Azshara realm.

      .EXAMPLE
      Get-CharacterAchievementStatistics -realmSlug 'azshara' -characterName 'strandmaus' -Raw
      Retrieves the raw JSON response of the achievement statistics for the character named Strandmaus on the Azshara realm.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.

      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/profile-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = "The slug of the character's realm.")]
    [ValidateNotNullOrEmpty()]
    [String]$realmSlug,

    [Parameter(Mandatory, Position = 1, HelpMessage = 'The name of the character.')]
    [ValidateNotNullOrEmpty()]
    [String]$characterName,

    [Parameter(Position = 2, HelpMessage = 'If set, returns the raw API response.')]
    [Switch]$Raw
  )

  $realmSlug = $realmSlug.ToLower()
  $characterName = $characterName.ToLower()

  if(Test-WoWApiConnection) 
  {
    $URL = '{0}profile/wow/character/{1}/{2}/achievements/statistics?namespace=profile-{3}&locale={4}' -f $Global:WoWBaseUrl, $realmSlug, $characterName, $Global:WoWRegion, $Global:WoWLocale    

    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSObject.Properties.name -contains 'categories') 
      {
        if($Raw) 
        {
          return $result
        }
        else 
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty categories |
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

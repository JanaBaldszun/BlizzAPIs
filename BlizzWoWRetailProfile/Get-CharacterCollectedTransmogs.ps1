function Get-CharacterCollectedTransmogs
{
  <#
      .SYNOPSIS
      Retrieves a list of transmog appearances collected by a World of Warcraft character.
  
      .DESCRIPTION
      The function uses the World of Warcraft API to fetch all transmog appearances that a specific character has collected.
      It requires a valid realm slug and character name as inputs. The transmog appearances can be returned in a formatted list or in raw JSON format.
  
      .PARAMETER realmSlug
      The realm slug of the character. Must be in lowercase (e.g., 'azshara').
  
      .PARAMETER characterName
      The name of the character. Must be in lowercase.
  
      .PARAMETER Raw
      Optional switch to output the raw JSON result from the API.
  
      .EXAMPLE
      Get-CharacterCollectedTransmogs -realmSlug 'azshara' -characterName 'strandmaus'
      Retrieves and displays the collected transmog appearances for the character Strandmaus on the realm Azshara.
  
      .EXAMPLE
      Get-CharacterCollectedTransmogs -realmSlug 'azshara' -characterName 'strandmaus' -Raw
      Retrieves the raw JSON response of collected transmog appearances for the character Strandmaus on the realm Azshara.
  
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
    $URL = '{0}profile/wow/character/{1}/{2}/collections/transmogs?namespace=profile-{3}&locale={4}' -f $Global:WoWBaseURL, $realmSlug, $characterName, $Global:WoWRegion, $Global:WoWLocalization
  
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
          $result.PSObject.Properties.Remove('_links')
          return $result
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

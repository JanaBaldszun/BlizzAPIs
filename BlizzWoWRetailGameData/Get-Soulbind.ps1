function Get-Soulbind 
{
  <#
      .SYNOPSIS
      Retrieves the Soulbind information of a specified character in World of Warcraft.

      .DESCRIPTION
      The function fetches the Soulbind details for a given character using the World of Warcraft API. The realm slug and character name are required parameters. An optional switch is available to return raw JSON data.

      .PARAMETER realmSlug
      The slug of the realm. This is required and must not be empty.

      .PARAMETER characterName
      The name of the character. This is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-Soulbind -realmSlug 'azshara' -characterName 'strandmaus'
      Retrieves the Soulbind information for the character named Strandmaus on the Azshara realm.

      .EXAMPLE
      Get-Soulbind -realmSlug 'azshara' -characterName 'strandmaus' -Raw
      Retrieves the raw JSON response of the Soulbind information for the character named Strandmaus on the Azshara realm.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param (
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The unique identifier for the soulbind.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection) 
  {
    $URL = '{0}data/wow/covenant/soulbind/{1}?namespace=static-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization

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

          if($result.PSObject.Properties['_links']) 
          {
            $result.PSObject.Properties.Remove('_links')
          }
          if($result.PSObject.Properties['character']) 
          {
            $result.PSObject.Properties.Remove('character')
          }
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
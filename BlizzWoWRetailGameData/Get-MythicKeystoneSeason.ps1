function Get-MythicKeystoneSeason
{
  <#
      .SYNOPSIS
      Retrieves information about a specific Mythic Keystone season in World of Warcraft.

      .DESCRIPTION
      This function fetches data for a given Mythic Keystone season using the World of Warcraft API. It requires a valid season ID and optionally returns the raw JSON response if the -Raw switch is provided.

      .PARAMETER Id
      The ID of the Mythic Keystone season. This parameter is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-MythicKeystoneSeason -Id '1'
      Retrieves information about Mythic Keystone season 1.

      .EXAMPLE
      Get-MythicKeystoneSeason -Id '1' -Raw
      Retrieves the raw JSON response for Mythic Keystone season 1.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the Mythic Keystone season.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/mythic-keystone/season/{1}?namespace=dynamic-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization
    
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

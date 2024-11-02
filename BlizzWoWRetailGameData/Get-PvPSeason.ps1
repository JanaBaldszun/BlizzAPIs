function Get-PvPSeason 
{
  <#
      .SYNOPSIS
      Retrieves details about a specific PvP season in World of Warcraft.

      .DESCRIPTION
      The function fetches information about a specified PvP season using the World of Warcraft API. The season ID is required, and an optional switch is available to return raw JSON data.

      .PARAMETER Id
      The ID of the PvP season. This is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-PvPSeason -Id '30'
      Retrieves the details of PvP season with ID 30.

      .EXAMPLE
      Get-PvPSeason -Id '30' -Raw
      Retrieves the raw JSON response for PvP season with ID 30.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>
  
  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the PvP season.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection) 
  {
    $URL = '{0}data/wow/pvp-season/{1}?namespace=dynamic-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization
    
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

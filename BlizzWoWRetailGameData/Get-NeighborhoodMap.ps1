function Get-NeighborhoodMap
{
  <#
      .SYNOPSIS
      Retrieves information about a specified neighborhood map in World of Warcraft.
  
      .DESCRIPTION
      The function fetches details of a neighborhood map using the World of Warcraft API. The neighborhood map ID is required. An optional switch is available to return the raw JSON data.
  
      .PARAMETER Id
      The ID of the neighborhood map. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-NeighborhoodMap -Id 1
      Retrieves information about the neighborhood map with ID 1.
  
      .EXAMPLE
      Get-NeighborhoodMap -Id 1 -Raw
      Retrieves the raw JSON response for the neighborhood map with ID 1.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the neighborhood map.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1)]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/neighborhood-map/{1}?namespace=dynamic-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization

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
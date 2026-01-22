function Get-Neighborhood
{
  <#
      .SYNOPSIS
      Retrieves information about a specified neighborhood in World of Warcraft.
  
      .DESCRIPTION
      The function fetches details of a neighborhood using the World of Warcraft API. The neighborhood map ID and the neighborhood ID are required. An optional switch is available to return the raw JSON data.

      .PARAMETER NeighborhoodMapID
      The ID of the NeighborhoodMap. This is required and must not be empty.

      .PARAMETER NeighborhoodID
      The ID of the Neighborhood. This is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-Neighborhood -NeighborhoodMapID 2 -NeighborhoodID 3632
      Retrieves Neighborhood information for NeighborhoodMaps ID 2 and skill tier ID 3632.

      .EXAMPLE
      Get-Neighborhood -NeighborhoodMapID 2 -NeighborhoodID 3632 -Raw
      Retrieves the raw JSON response of the Neighborhood information for NeighborhoodMaps ID 2 and skill tier ID 3632.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the NeighborhoodMap.')]
    [ValidateNotNullOrEmpty()]
    [String]$NeighborhoodMapID,

    [Parameter(Mandatory, Position = 1, HelpMessage = 'The ID of the Neighborhood.')]
    [ValidateNotNullOrEmpty()]
    [String]$NeighborhoodID,

    [Parameter(Position = 2)]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/neighborhood-map/{1}/neighborhood/{2}?namespace=dynamic-{3}&locale={4}' -f $Global:WoWBaseURL, $NeighborhoodMapID, $NeighborhoodID, $Global:WoWRegion, $Global:WoWLocalization

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
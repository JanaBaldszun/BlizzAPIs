function Get-NeighborhoodMapIndex
{
  <#
      .SYNOPSIS
      Retrieves the neighborhood map index in World of Warcraft.

      .DESCRIPTION
      The function fetches a list of all neighborhood maps available in World of Warcraft using the WoW API. An optional switch is available to return the raw JSON data.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-RoomIndex
      Retrieves the formatted list of neighborhood maps.

      .EXAMPLE
      Get-RoomIndex -Raw
      Retrieves the raw JSON response of the neighborhood map index.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Position = 0)]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/neighborhood-map/index?namespace=dynamic-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization

    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      
      if($result -and $result.PSobject.Properties.name -contains 'maps')
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

          return $result |
          Select-Object -ExpandProperty maps |
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
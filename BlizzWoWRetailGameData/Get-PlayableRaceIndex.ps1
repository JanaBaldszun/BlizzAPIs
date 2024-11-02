function Get-PlayableRaceIndex
{
  <#
      .SYNOPSIS
      Retrieves a list of playable races in World of Warcraft.

      .DESCRIPTION
      This function fetches an index of playable races using the World of Warcraft API. The information is retrieved for the specified region and localization settings as configured globally. An optional switch is available to return raw JSON data.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-PlayableRaceIndex
      Retrieves a formatted list of playable races in World of Warcraft.

      .EXAMPLE
      Get-PlayableRaceIndex -Raw
      Retrieves the raw JSON response of playable races in World of Warcraft.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Position = 0, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/playable-race/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization
    
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'races')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty races |
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

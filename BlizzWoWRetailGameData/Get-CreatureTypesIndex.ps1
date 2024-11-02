function Get-CreatureTypesIndex
{
  <#
      .SYNOPSIS
      Retrieves the creature types index from the World of Warcraft API.

      .DESCRIPTION
      The function fetches an index of creature types from the World of Warcraft API. The -Raw switch can be used to return the unformatted response.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-CreatureTypesIndex
      Retrieves the formatted list of creature types from the World of Warcraft API.

      .EXAMPLE
      Get-CreatureTypesIndex -Raw
      Retrieves the raw JSON response of creature types from the World of Warcraft API.

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
    $URL = '{0}data/wow/creature-type/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization

    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'creature_types')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty creature_types |
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

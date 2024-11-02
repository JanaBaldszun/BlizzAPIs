﻿function Get-MythicKeystoneDungeonIndex
{
  <#
      .SYNOPSIS
      Retrieves the index of Mythic Keystone dungeons in World of Warcraft.

      .DESCRIPTION
      The function fetches an index of Mythic Keystone dungeons using the World of Warcraft API. An optional switch is available to return raw JSON data.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-MythicKeystoneDungeonIndex
      Retrieves the index of Mythic Keystone dungeons and returns a formatted list.

      .EXAMPLE
      Get-MythicKeystoneDungeonIndex -Raw
      Retrieves the raw JSON response of Mythic Keystone dungeons.

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
    $URL = '{0}data/wow/mythic-keystone/dungeon/index?namespace=dynamic-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization

    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'dungeons')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty dungeons |
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

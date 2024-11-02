function Get-PetIndex
{
  <#
      .SYNOPSIS
      Retrieves the index of battle pets available in World of Warcraft.

      .DESCRIPTION
      The function fetches a list of all battle pets available in the World of Warcraft game using the Blizzard API. If the -Raw switch is specified, it returns the raw JSON response.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-PetIndex
      Retrieves a formatted list of all battle pets available in the game.

      .EXAMPLE
      Get-PetIndex -Raw
      Retrieves the raw JSON response of all battle pets available in the game.

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
    $URL = '{0}data/wow/pet/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization

    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'pets')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'
          return $result |
          Select-Object -ExpandProperty pets |
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

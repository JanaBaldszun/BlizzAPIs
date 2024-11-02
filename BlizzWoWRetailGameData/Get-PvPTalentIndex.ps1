function Get-PvPTalentIndex
{
  <#
      .SYNOPSIS
      Retrieves the PvP talent index from the World of Warcraft API.
  
      .DESCRIPTION
      This function fetches the PvP talent index for World of Warcraft using the specified API endpoint. It can return the formatted data or the raw JSON response. The WoW API credentials must be set globally.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-PvPTalentIndex
      Retrieves the formatted PvP talent index.
  
      .EXAMPLE
      Get-PvPTalentIndex -Raw
      Retrieves the raw JSON response of the PvP talent index.
  
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
    $URL = '{0}data/wow/pvp-talent/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization
  
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'pvp_talents')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'
          return $result |
          Select-Object -ExpandProperty pvp_talents |
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

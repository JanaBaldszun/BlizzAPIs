function Get-AzeriteEssenceIndex 
{
  <#
      .SYNOPSIS
      Retrieves the Azerite Essences index for World of Warcraft.
  
      .DESCRIPTION
      The function fetches the Azerite Essences index using the World of Warcraft API. Optionally, the response can be returned in raw JSON format for more detailed information.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-AzeriteEssenceIndex
      Retrieves the Azerite Essences index for World of Warcraft in a formatted way.
  
      .EXAMPLE
      Get-AzeriteEssenceIndex -Raw
      Retrieves the Azerite Essences index in raw JSON format.
  
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
    $URL = '{0}data/wow/azerite-essence/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization
    
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'azerite_essences')
      {
        if($Raw)
        {
          return $result
        }
        else 
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'
          return $result |
          Select-Object -ExpandProperty azerite_essences |
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

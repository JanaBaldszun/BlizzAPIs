function Get-ToyIndex
{
  <#
      .SYNOPSIS
      Retrieves the index of toys in World of Warcraft.

      .DESCRIPTION
      This function fetches the list of toys from the World of Warcraft API. It connects to the API endpoint and retrieves all available toys, with an option to return raw JSON data.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API instead of a formatted output.

      .EXAMPLE
      Get-ToyIndex
      Retrieves the list of toys available in the World of Warcraft API.

      .EXAMPLE
      Get-ToyIndex -Raw
      Retrieves the raw JSON response of the list of toys available in the World of Warcraft API.

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
    $URL = '{0}data/wow/toy/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization

    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'toys')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty toys |
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

function Get-WoWTokenIndex
{
  <#
      .SYNOPSIS
      Retrieves the WoW token index information for the current region.

      .DESCRIPTION
      The function fetches the WoW token index for the specified region using the World of Warcraft API. 
      This includes information like the current token price and its status. The optional Raw parameter can be used to get the native JSON result.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-WoWTokenIndex
      Retrieves the WoW token index information in a formatted manner.

      .EXAMPLE
      Get-WoWTokenIndex -Raw
      Retrieves the raw JSON response of the WoW token index.

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
    $URL = '{0}data/wow/token/index?namespace=dynamic-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization

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

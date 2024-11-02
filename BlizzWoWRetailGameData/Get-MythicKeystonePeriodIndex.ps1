function Get-MythicKeystonePeriodIndex
{
  <#
      .SYNOPSIS
      Retrieves the current Mythic Keystone period index in World of Warcraft.
  
      .DESCRIPTION
      The function fetches the current Mythic Keystone period index using the World of Warcraft API. This function does not require any realm or character-specific information. An optional switch is available to return the raw JSON data.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-MythicKeystonePeriodIndex
      Retrieves the current Mythic Keystone period index in a formatted way.
  
      .EXAMPLE
      Get-MythicKeystonePeriodIndex -Raw
      Retrieves the raw JSON response for the current Mythic Keystone period index.
  
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
    $URL = '{0}data/wow/mythic-keystone/period/index?namespace=dynamic-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization
  
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

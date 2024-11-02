function Get-MythicKeystoneSeasonIndex
{
  <#
      .SYNOPSIS
      Retrieves the Mythic Keystone season index for World of Warcraft.

      .DESCRIPTION
      This function fetches the Mythic Keystone season index using the World of Warcraft API. An optional switch is available to return raw JSON data.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-MythicKeystoneSeasonIndex
      Retrieves the Mythic Keystone season index for the current World of Warcraft region.

      .EXAMPLE
      Get-MythicKeystoneSeasonIndex -Raw
      Retrieves the raw JSON response of the Mythic Keystone season index for the current World of Warcraft region.

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
    $URL = '{0}data/wow/mythic-keystone/season/index?namespace=dynamic-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization
    
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

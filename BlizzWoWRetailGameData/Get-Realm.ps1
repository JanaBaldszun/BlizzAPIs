function Get-Realm 
{
  <#
      .SYNOPSIS
      Retrieves information about a specified realm in World of Warcraft.
  
      .DESCRIPTION
      The function fetches information about a given realm using the World of Warcraft API. The realm slug is a required parameter, and an optional switch is available to return raw JSON data.
  
      .PARAMETER realmSlug
      The slug of the realm. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-Realm -realmSlug 'azshara'
      Retrieves the information for the realm named Azshara.
  
      .EXAMPLE
      Get-Realm -realmSlug 'azshara' -Raw
      Retrieves the raw JSON response for the realm named Azshara.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param (
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The slug of the realm.')]
    [ValidateNotNullOrEmpty()]
    [String]$realmSlug,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection) 
  {
    $URL = '{0}data/wow/realm/{1}?namespace=dynamic-{2}&locale={3}' -f $Global:WoWBaseURL, $realmSlug, $Global:WoWRegion, $Global:WoWLocalization

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

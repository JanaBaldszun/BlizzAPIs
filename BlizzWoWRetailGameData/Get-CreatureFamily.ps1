function Get-CreatureFamily
{
  <#
      .SYNOPSIS
      Retrieves the creature family information for a given ID in World of Warcraft.
  
      .DESCRIPTION
      The function fetches details of a creature family using the World of Warcraft API. A creature family ID is required. An optional switch is available to return raw JSON data.
  
      .PARAMETER Id
      The ID of the creature family. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-CreatureFamily -Id 1
      Retrieves the creature family details for the specified ID.
  
      .EXAMPLE
      Get-CreatureFamily -Id 1 -Raw
      Retrieves the raw JSON response for the specified creature family ID.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the creature family.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/creature-family/{1}?namespace=static-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization
    
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

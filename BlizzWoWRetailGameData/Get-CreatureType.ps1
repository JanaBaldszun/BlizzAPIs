function Get-CreatureType 
{
  <#
      .SYNOPSIS
      Retrieves the creature type information for a specified ID in World of Warcraft.

      .DESCRIPTION
      This function fetches creature type details from the World of Warcraft API using the provided ID. It optionally returns the raw JSON response if the -Raw parameter is specified.

      .PARAMETER Id
      The ID of the creature type. This is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-CreatureType -Id '12345'
      Retrieves the creature type details for the creature with ID 12345.

      .EXAMPLE
      Get-CreatureType -Id '12345' -Raw
      Retrieves the raw JSON response for the creature type with ID 12345.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>
  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the creature type.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection) 
  {
    $URL = '{0}data/wow/creature-type/{1}?namespace=static-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization

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

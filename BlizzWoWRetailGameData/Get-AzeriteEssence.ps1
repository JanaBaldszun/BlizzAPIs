function Get-AzeriteEssence
{
  <#
      .SYNOPSIS
      Retrieves the details of an Azerite Essence in World of Warcraft.
  
      .DESCRIPTION
      This function fetches the information for a specified Azerite Essence using the World of Warcraft API. The Azerite Essence ID is required to proceed, and the response can either be formatted or returned as raw JSON data.
  
      .PARAMETER Id
      The ID of the Azerite Essence to be fetched. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-AzeriteEssence -Id '15'
      Retrieves the details of the Azerite Essence with ID 15 in a formatted output.
  
      .EXAMPLE
      Get-AzeriteEssence -Id '15' -Raw
      Retrieves the raw JSON response of the Azerite Essence with ID 15.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the Azerite Essence.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/azerite-essence/{1}?namespace=static-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization

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

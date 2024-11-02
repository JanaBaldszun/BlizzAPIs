﻿function Get-MythicKeystonePeriod
{
  <#
      .SYNOPSIS
      Retrieves the details of a specific Mythic Keystone period in World of Warcraft.
  
      .DESCRIPTION
      This function fetches information about a given Mythic Keystone period using the World of Warcraft API. The period ID is a required parameter. An optional switch is available to return raw JSON data instead of a formatted response.
  
      .PARAMETER Id
      The ID of the Mythic Keystone period. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-MythicKeystonePeriod -Id '678'
      Retrieves the details of Mythic Keystone period with ID 678.
  
      .EXAMPLE
      Get-MythicKeystonePeriod -Id '678' -Raw
      Retrieves the raw JSON response of Mythic Keystone period with ID 678.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>
  
  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the Mythic Keystone period.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/mythic-keystone/period/{1}?namespace=dynamic-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization
    
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

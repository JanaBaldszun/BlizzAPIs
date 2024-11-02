﻿function Get-JournalEncounter
{
  <#
      .SYNOPSIS
      Retrieves details of a journal encounter in World of Warcraft.
  
      .DESCRIPTION
      The function fetches information about a specific journal encounter using the World of Warcraft API. The encounter ID is required to retrieve data, and there is an optional switch to return the raw JSON data.
  
      .PARAMETER Id
      The ID of the journal encounter. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-JournalEncounter -Id '200'
      Retrieves details for the journal encounter with ID 200 in a formatted result.
  
      .EXAMPLE
      Get-JournalEncounter -Id '200' -Raw
      Retrieves the raw JSON response for the journal encounter with ID 200.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the journal encounter.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/journal-encounter/{1}?namespace=static-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization
    
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
          if($result.PSObject.Properties['character'])
          {
            $result.PSObject.Properties.Remove('character')
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

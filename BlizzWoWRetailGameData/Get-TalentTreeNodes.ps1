function Get-TalentTreeNodes
{
  <#
      .SYNOPSIS
      Retrieves the talent tree nodes of a specified character in World of Warcraft.
  
      .DESCRIPTION
      The function fetches a list of talent tree nodes for a given character using the World of Warcraft API. The character ID is required. An optional switch is available to return raw JSON data.
  
      .PARAMETER Id
      The talent tree ID. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-TalentTreeNodes -Id '12345'
      Retrieves the talent tree nodes for the given talent tree ID '12345'.
  
      .EXAMPLE
      Get-TalentTreeNodes -Id '12345' -Raw
      Retrieves the raw JSON response for the given talent tree ID '12345'.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>
  
  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the talent tree.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/talent-tree/{1}?namespace=static-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization
    
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

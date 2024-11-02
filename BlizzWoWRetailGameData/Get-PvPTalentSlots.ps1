function Get-PvPTalentSlots
{
  <#
      .SYNOPSIS
      Retrieves the PvP talent slots of a specified playable class in World of Warcraft.
  
      .DESCRIPTION
      The function fetches the PvP talent slots for a given class using the World of Warcraft API. The class ID is a required parameter. An optional switch is available to return raw JSON data.
  
      .PARAMETER Id
      The ID of the playable class. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-PvPTalentSlots -Id '1'
      Retrieves the PvP talent slots for the class with ID 1.
  
      .EXAMPLE
      Get-PvPTalentSlots -Id '1' -Raw
      Retrieves the raw JSON response of PvP talent slots for the class with ID 1.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the playable class.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/playable-class/{1}/pvp-talent-slots?namespace=static-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization
    
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'talent_slots')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result | 
          Select-Object -ExpandProperty talent_slots
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

function Get-TalentTree
{
  <#
      .SYNOPSIS
      Retrieves the talent tree for a specified specialization in World of Warcraft.
  
      .DESCRIPTION
      The function fetches the talent tree for a given specialization using the World of Warcraft API. The talent tree ID and specialization ID are required parameters. An optional switch is available to return raw JSON data.
  
      .PARAMETER TalentTreeID
      The ID of the talent tree. This is required and must not be empty.
  
      .PARAMETER SpecID
      The ID of the specialization. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-TalentTree -TalentTreeID '123' -SpecID '456'
      Retrieves the talent tree for the specialization with ID 456 in the talent tree 123.
  
      .EXAMPLE
      Get-TalentTree -TalentTreeID '123' -SpecID '456' -Raw
      Retrieves the raw JSON response of the talent tree for the specialization with ID 456 in the talent tree 123.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the talent tree.')]
    [ValidateNotNullOrEmpty()]
    [String]$TalentTreeID,

    [Parameter(Mandatory, Position = 1, HelpMessage = 'The ID of the specialization.')]
    [ValidateNotNullOrEmpty()]
    [String]$SpecID,

    [Parameter(Position = 2, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/talent-tree/{1}/playable-specialization/{2}?namespace=static-{3}&locale={4}' -f $Global:WoWBaseURL, $TalentTreeID, $SpecID, $Global:WoWRegion, $Global:WoWLocalization
    
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

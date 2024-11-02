function Get-ProfessionSkillTier
{
  <#
      .SYNOPSIS
      Retrieves the skill tier information of a specified profession in World of Warcraft.

      .DESCRIPTION
      The function fetches the skill tier details for a given profession using the World of Warcraft API. The ProfessionID and SkillTierID are required parameters. An optional switch is available to return raw JSON data.

      .PARAMETER ProfessionID
      The ID of the profession. This is required and must not be empty.

      .PARAMETER SkillTierID
      The ID of the skill tier. This is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-ProfessionSkillTier -ProfessionID '164' -SkillTierID '2751'
      Retrieves the skill tier information for profession ID 164 and skill tier ID 2751.

      .EXAMPLE
      Get-ProfessionSkillTier -ProfessionID '164' -SkillTierID '2751' -Raw
      Retrieves the raw JSON response of the skill tier information for profession ID 164 and skill tier ID 2751.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the profession.')]
    [ValidateNotNullOrEmpty()]
    [String]$ProfessionID,

    [Parameter(Mandatory, Position = 1, HelpMessage = 'The ID of the skill tier.')]
    [ValidateNotNullOrEmpty()]
    [String]$SkillTierID,

    [Parameter(Position = 2, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/profession/{1}/skill-tier/{2}?namespace=static-{3}&locale={4}' -f $Global:WoWBaseURL, $ProfessionID, $SkillTierID, $Global:WoWRegion, $Global:WoWLocalization

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

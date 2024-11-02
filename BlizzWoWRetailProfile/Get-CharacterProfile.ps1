function Get-CharacterProfile
{
  <#
      .SYNOPSIS
      Retrieves the profile of a specified character in World of Warcraft.
  
      .DESCRIPTION
      The function fetches the profile details for a given character using the World of Warcraft API. The realm slug and character name are required parameters. An optional switch is available to return raw JSON data.
  
      .PARAMETER realmSlug
      The slug of the realm. This is required and must not be empty.
  
      .PARAMETER characterName
      The name of the character. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-CharacterProfile -realmSlug 'azshara' -characterName 'strandmaus'
      Retrieves the profile details for the character named Strandmaus on the Azshara realm.
  
      .EXAMPLE
      Get-CharacterProfile -realmSlug 'azshara' -characterName 'strandmaus' -Raw
      Retrieves the raw JSON response of the profile details for the character named Strandmaus on the Azshara realm.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.

      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/profile-apis
  #>

  param (
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The slug of the realm.')]
    [ValidateNotNullOrEmpty()]
    [String]$realmSlug,

    [Parameter(Mandatory, Position = 1, HelpMessage = 'The character name.')]
    [ValidateNotNullOrEmpty()]
    [String]$characterName,

    [Parameter(Position = 2, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  $realmSlug = $realmSlug.ToLower()
  $characterName = $characterName.ToLower()
  
  if(Test-WoWApiConnection)
  {
    $URL = '{0}profile/wow/character/{1}/{2}?namespace=profile-{3}&locale={4}' -f $Global:WoWBaseURL, $realmSlug, $characterName, $Global:WoWRegion, $Global:WoWLocalization
  
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
          if($result.PSObject.Properties['achievements'])
          {
            $result.PSObject.Properties.Remove('achievements')
          }
          if($result.PSObject.Properties['achievements_statistics'])
          {
            $result.PSObject.Properties.Remove('achievements_statistics')
          }
          if($result.PSObject.Properties['appearance'])
          {
            $result.PSObject.Properties.Remove('appearance')
          }
          if($result.PSObject.Properties['collections'])
          {
            $result.PSObject.Properties.Remove('collections')
          }
          if($result.PSObject.Properties['encounters'])
          {
            $result.PSObject.Properties.Remove('encounters')
          }
          if($result.PSObject.Properties['equipment'])
          {
            $result.PSObject.Properties.Remove('equipment')
          }
          if($result.PSObject.Properties['media'])
          {
            $result.PSObject.Properties.Remove('media')
          }
          if($result.PSObject.Properties['mythic_keystone_profile'])
          {
            $result.PSObject.Properties.Remove('mythic_keystone_profile')
          }
          if($result.PSObject.Properties['name_search'])
          {
            $result.PSObject.Properties.Remove('name_search')
          }
          if($result.PSObject.Properties['professions'])
          {
            $result.PSObject.Properties.Remove('professions')
          }
          if($result.PSObject.Properties['pvp_summary'])
          {
            $result.PSObject.Properties.Remove('pvp_summary')
          }
          if($result.PSObject.Properties['quests'])
          {
            $result.PSObject.Properties.Remove('quests')
          }
          if($result.PSObject.Properties['reputations'])
          {
            $result.PSObject.Properties.Remove('reputations')
          }
          if($result.PSObject.Properties['specializations'])
          {
            $result.PSObject.Properties.Remove('specializations')
          }
          if($result.PSObject.Properties['statistics'])
          {
            $result.PSObject.Properties.Remove('statistics')
          }
          if($result.PSObject.Properties['titles'])
          {
            $result.PSObject.Properties.Remove('titles')
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

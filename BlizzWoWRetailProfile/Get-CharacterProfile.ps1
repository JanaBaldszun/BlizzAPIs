function Get-CharacterProfile
{
  param(
    [Parameter(Mandatory, Position = 0)][String]$realmSlug,
    [Parameter(Mandatory, Position = 1)][String]$characterName,
    [Parameter(Position = 2)][Switch]$Raw
  )

  $realmSlug = $realmSlug.ToLower()
  $characterName = $characterName.ToLower()
  
  if(Test-WoWApiConnection)
  {
    $EndpointPath = "profile/wow/character/$realmSlug/$characterName"
    $Namespace = -join('?namespace=profile-', $Global:WoWRegion, '&locale=', $Global:WoWLocalization, '&')
    $URL = -join($Global:WoWBaseURL, $EndpointPath, $Namespace, 'access_token=', $Global:WoWAccessToken)    
  
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -TimeoutSec 5
      if($result) 
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          $result.PSObject.Properties.Remove('_links')
          $result.PSObject.Properties.Remove('achievements')
          $result.PSObject.Properties.Remove('achievements_statistics')
          $result.PSObject.Properties.Remove('appearance')
          $result.PSObject.Properties.Remove('collections')
          $result.PSObject.Properties.Remove('encounters')
          $result.PSObject.Properties.Remove('equipment')
          $result.PSObject.Properties.Remove('media')
          $result.PSObject.Properties.Remove('mythic_keystone_profile')
          $result.PSObject.Properties.Remove('name_search')
          $result.PSObject.Properties.Remove('professions')
          $result.PSObject.Properties.Remove('pvp_summary')
          $result.PSObject.Properties.Remove('quests')
          $result.PSObject.Properties.Remove('reputations')
          $result.PSObject.Properties.Remove('specializations')
          $result.PSObject.Properties.Remove('statistics')
          $result.PSObject.Properties.Remove('titles')

          return $result
        }
      }
    }
    catch 
    {
      $statusCode = $_.Exception.Response.StatusCode.value__
      $status = $_.Exception.Response.StatusCode
      Write-Verbose -Message "Bad status code ($statusCode) $status"
    }
  }
}
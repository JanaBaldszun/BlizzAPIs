﻿function Request-CharacterMythicKeystoneSeasonDetails
{
  param(
    [Parameter(Mandatory, Position=0)][String]
    $realmSlug,
    [Parameter(Mandatory, Position=0)][String]
    $characterName,
    [Parameter(Mandatory, Position=0)][String]
    $seasonId
  )

  $realmSlug = $realmSlug.ToLower()
  $characterName = $characterName.ToLower()

  $EndpointPath = "profile/wow/character/$realmSlug/$characterName/mythic-keystone-profile/season/$seasonId"
  $Namespace = -join('?namespace=profile-',$Global:WoWRegion,'&locale=',$Global:WoWLocalization,'&')
  $URL = -join($Global:WoWBaseURL,$EndpointPath,$Namespace,'access_token=',$Global:WoWAccessToken)    
  
  try 
  {
    $result = Invoke-RestMethod -Uri $URL -TimeoutSec 5
    if($result) 
    {
      return $result
    }
  }
  catch 
  {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $status = $_.Exception.Response.StatusCode
    return "Bad status code ($statusCode) $status"
  }
}
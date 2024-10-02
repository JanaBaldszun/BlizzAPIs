function Get-CharacterMythicKeystoneProfile
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
    $EndpointPath = "profile/wow/character/$realmSlug/$characterName/mythic-keystone-profile"
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
          $result.PSObject.Properties.Remove('character')
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
function Get-CharacterRaids
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
    $EndpointPath = "profile/wow/character/$realmSlug/$characterName/encounters/raids"
    $Namespace = -join('?namespace=profile-', $Global:WoWRegion, '&locale=', $Global:WoWLocalization, '&')
    $URL = -join($Global:WoWBaseURL, $EndpointPath, $Namespace, 'access_token=', $Global:WoWAccessToken)    
  
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'expansions')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty expansions |
          Sort-Object -Property id
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
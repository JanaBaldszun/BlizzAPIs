﻿function Get-CharacterEquipment
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
    $EndpointPath = "profile/wow/character/$realmSlug/$characterName/equipment"
    $Namespace = -join('?namespace=profile-', $Global:WoWRegion, '&locale=', $Global:WoWLocalization, '&')
    $URL = -join($Global:WoWBaseURL, $EndpointPath, $Namespace, 'access_token=', $Global:WoWAccessToken)    
  
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'equipped_items')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty equipped_items |
          Sort-Object -Property slot
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
function Get-PvPTalentSlots
{
  param(
    [Parameter(Mandatory, Position = 0)][String]$Id,
    [Parameter(Position = 1)][Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $EndpointPath = ('data/wow/playable-class/{0}/pvp-talent-slots' -f $Id)
    $Namespace = -join('?namespace=static-', $Global:WoWRegion, '&locale=', $Global:WoWLocalization, '&')
    $URL = -join($Global:WoWBaseURL, $EndpointPath, $Namespace, 'access_token=', $Global:WoWAccessToken)    
  
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -TimeoutSec 5
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
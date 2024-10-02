function Get-ItemAppearanceSlotIndex
{
  param(
    [Parameter(Mandatory, Position = 0)][String]$Slot,
    [Parameter(Position = 1)][Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $EndpointPath = ('data/wow/item-appearance/slot/{0}' -f $Slot)
    $Namespace = -join('?namespace=static-', $Global:WoWRegion, '&locale=', $Global:WoWLocalization, '&')
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

          return $result | Select-Object -ExpandProperty appearances | Select-Object -ExpandProperty id
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
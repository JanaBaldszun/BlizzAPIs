﻿function Get-ConduitByID
{
  param(
    [Parameter(Mandatory, Position=0)][String]
    $ID
  )

  $EndpointPath = "data/wow/covenant/conduit/$ID"
  $Namespace = -join('?namespace=static-',$Global:WoWRegion,'&locale=',$Global:WoWLocalization,'&')
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
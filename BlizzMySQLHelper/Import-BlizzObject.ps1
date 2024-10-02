function Import-BlizzObject
{
  param
  (
    [Parameter(Mandatory, Position = 0)][string]$Table,
    [Parameter(Mandatory, Position = 1)][psobject]$Object,
    [Parameter(Mandatory, Position = 2)][string]$ConnectionName
  ) 
  foreach($Property in $Object.PSObject.Properties)
  {
    if($null -eq $Property.Value)
    {
      $Property.Value = 'NULL'
    }
  }

  $columns = $Object.PSObject.Properties | Select-Object -ExpandProperty Name
  $values = $Object.PSObject.Properties | Select-Object -ExpandProperty Value

  $values = $values | ForEach-Object -Process { -join('"', $_, '"') }
  $hash = @{}
  $Object.psobject.properties | Where-Object -FilterScript { $_.value -ne 'NULL' } | ForEach-Object -Process { $hash[$_.Name] = -join('"', $_.Value, '"') }
  $Object.psobject.properties | Where-Object -FilterScript { $_.value -eq 'NULL' } | ForEach-Object -Process { $hash[$_.Name] = $_.Value }

  $Query = "INSERT INTO $($Table) ($($columns -join ',')) VALUES ($($values -join ',')) ON DUPLICATE KEY UPDATE $($hash.GetEnumerator().ForEach({"$($_.Name)=$($_.Value)"}) -join ',')"
  $null = Invoke-SqlUpdate -ConnectionName $ConnectionName -Query $Query
}
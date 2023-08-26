[CmdletBinding()]
param(
  $serverName,
  $databaseName,
  $adminUserName,
  $adminPassword,
  $svcAccountUserName,
  $svcAccountPassword,
  $dataPopulationScript
)
Write-Host "Beginning Powershell SQL Commands..."

# Create LOGIN
Write-Host "...Create LOGIN"
Invoke-Sqlcmd -ServerInstance "$serverName.database.windows.net" -Database "master" -Username $adminUserName -Password $adminPassword "CREATE LOGIN [$svcAccountUserName] WITH PASSWORD=N'$svcAccountPassword';"

# Create DB User & Roles
Write-Host "...Create DB User & Roles"
Invoke-Sqlcmd -ServerInstance "$serverName.database.windows.net" -Database "$databaseName" -Username $adminUserName -Password $adminPassword -Query "CREATE USER [$svcAccountUserName] FOR LOGIN [$svcAccountUserName] WITH DEFAULT_SCHEMA = dbo;"
Invoke-Sqlcmd -ServerInstance "$serverName.database.windows.net" -Database "$databaseName" -Username $adminUserName -Password $adminPassword -Query "ALTER ROLE db_datareader ADD MEMBER [$svcAccountUserName];ALTER ROLE db_datawriter ADD MEMBER [$svcAccountUserName];GRANT EXEC TO [$svcAccountUserName]"

# Execute Data Population Script
Write-Host "...Execute Data Population Script"
Invoke-Sqlcmd -ServerInstance "$serverName.database.windows.net" -Database "$databaseName" -Username $adminUserName -Password $adminPassword -InputFile $dataPopulationScript

Write-Host "..Completed Powershell SQL Commands..."
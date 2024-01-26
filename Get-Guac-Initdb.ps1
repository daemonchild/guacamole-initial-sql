

#      _                                       _     _ _     _ 
#   __| | __ _  ___ _ __ ___   ___  _ __   ___| |__ (_) | __| |
#  / _` |/ _` |/ _ \ '_ ` _ \ / _ \| '_ \ / __| '_ \| | |/ _` |
# | (_| | (_| |  __/ | | | | | (_) | | | | (__| | | | | | (_| |
#  \__,_|\__,_|\___|_| |_| |_|\___/|_| |_|\___|_| |_|_|_|\__,_|
#                                                           

# Collects initial SQL Database files for Apache Guacamole
# Releases: https://guacamole.apache.org/releases/

$GuacVersions = ("1.5.0", "1.5.1", "1.5.2", "1.5.3", "1.5.4")
$Latest = $GuacVersions[-1]

# Is docker installed?
Function Test-DockerInPath() {
    Return ($null -ne (Get-Command "docker" -ErrorAction SilentlyContinue))    
}

Function Get-GuacSQL ($Version) {

    $TemplateFilename   = "guacamole-initdb-DB-vVER.sql"
    $MySQLPath      = "mysql\"+$TemplateFilename.Replace("DB","mysql").Replace("VER",$Version)
    $PostgresPath   = "postgres\"+$TemplateFilename.Replace("DB","postgres").Replace("VER",$Version)

    If (Test-DockerInPath) {
        
        Write-Host "Working: " -NoNewline -ForegroundColor Blue
        Write-Host "fetching $Version docker image" -ForegroundColor Yellow

        # Collect Guacamole Client, generate SQL using built in script
        (docker pull guacamole/guacamole:$Version) *> $null
        (docker run --rm guacamole/guacamole:$Version /opt/guacamole/bin/initdb.sh --postgresql | Set-Content -Path $MySQLPath) *> $null
        (docker run --rm guacamole/guacamole:$Version /opt/guacamole/bin/initdb.sh --mysql | Set-Content -Path $PostgresPath) *> $null


        If (Test-Path $MySQLPath) {
            Write-Host "OK: " -NoNewline -ForegroundColor Green
            Write-Host "MySQL :)" -ForegroundColor White
            # Create the 'latest' file
            If ($Version -eq $Latest) {
                Write-Host "-- Latest Version" -ForegroundColor Cyan
                Copy-Item $MySQLPath $MySQLPath.Replace("v$Version", "latest")
            }

        } Else {
            Write-Host "FAIL: " -NoNewline -ForegroundColor Green
            Write-Host "MySQL :(" -ForegroundColor Red
        }

        If (Test-Path $PostgresPath) {
            Write-Host "OK: " -NoNewline -ForegroundColor Green
            Write-Host "Postgres :)" -ForegroundColor White
            # Create the 'latest' file
            If ($Version -eq $Latest) {
                Write-Host "-- Latest Version" -ForegroundColor Cyan
                Copy-Item $PostgresPath $PostgresPath.Replace($Version, "latest")
            }
        } Else {
            Write-Host "FAIL: " -NoNewline -ForegroundColor Green
            Write-Host "Postgres :(" -ForegroundColor Red
        }

        # Delete The Image 
        #(docker image rm guacamole/guacamole:$Version) *> $null

    } else {
        Write-Host "Error! " -NoNewline -ForegroundColor Red
        Write-Host "Could not run 'docker'. Is it installed?" -ForegroundColor White
    }

}

# Get All in a List
Function Get-GuacSQLAll ($Versions) {

    Foreach ($Version in $Versions) {
        Get-GuacSQL -Version $Version
    }
}


# Welcome Note
Write-Host "Guacamole Initial SQL" -ForegroundColor Blue
Write-Host "Known Versions: " -NoNewline -ForegroundColor Green
Write-Host $GuacVersions -ForegroundColor White
Write-Host
Write-Host "Quick start: " -NoNewline -ForegroundColor Green
Write-Host "Get-GuacSQLAll -Versions `$GuacVersions" -ForegroundColor White
    


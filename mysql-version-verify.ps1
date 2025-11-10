[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ServerName
)

function Get-MySQLVersion{
    try{
        $mysqlVersion = Invoke-Command -ComputerName $ServerName -ScriptBlock {
           $version = & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --version

            return @{
                Success = $true
                Version = $version
                Error = $null
            }
        }

        return $mysqlVersion
    }catch{
        return @{
            Success = $false
            Version = $null
            Error = "MySQL is not installed or not in PATH on $using:ServerName"
        }
    }
}

Write-Host "Checking MySQL version on server: $ServerName" -ForegroundColor Cyan

$result = Get-MySQLVersion

if($result.Success){
    Write-Host "MySQL Version Information:" -ForegroundColor Green
    Write-Host $result.Version
}else{
    Write-Host "Error: $($result.Error)" -ForegroundColor Red
}

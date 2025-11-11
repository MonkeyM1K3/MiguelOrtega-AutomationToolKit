# **MiguelOrtega-AutomationToolKit**

# Powershell Automation Script

## **mysql-version-verify.ps1 -- MySQL Verify checker**


```powershell
param( 
    [Parameter(Mandatory=$true)]
    [string]$ServerName)
```

**<span style="color:#485387">$ServerName</span>** is the server we are going to verify for the version of MySQL. 

We use function ```Get-MySQLVersion```, which will be run using a Try/Catch where ```$mysqlVersion``` is called, this uses an ```Invoke-Command``` to the ```$ServerName``` and calls the ``` "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --version" ``` from the MySQL Shell commands for the version. 

```powershell
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

```

For each the Try and Catch, we have a return that will provide three pieces of information

```Success``` - It will show either ```$true``` or ```$false```   \
```Version``` - Shows the version collected at the initial Try using the MySQL Shell command ```& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --version ``` \
```Error```   - The error message we will show if it fails and the Catch is triggered, in this case ``` "MySQL is not installed or not in PATH on $using:ServerName" ```

```powershell
return @{
                Success = $true
                Version = $version
                Error = $null
            }

return @{
            Success = $false
            Version = $null
            Error = "MySQL is not installed or not in PATH on $using:ServerName"
        }

```

There is an informational message, that will just show that we are looking for the MySQL version on the specified servers. This is the start of the script when run.

```powershell
Write-Host "Checking MySQL version on server: $ServerName" -ForegroundColor Cyan
```

Line 31 is where we create the ```$result``` variable that will contain the whole function ```Get-MySQLVersion```.
```powershell
$result = Get-MySQLVersion
```


We start the script by doing an if/else statement. 
```powershell
if($result.Success){
    Write-Host "MySQL Version Information:" -ForegroundColor Green
    Write-Host $result.Version
}else{
    Write-Host "Error: $($result.Error)" -ForegroundColor Red
}
```

The output will look something like this:

```
Checking MySQL version on server: CSC2CWN00022532.CLOUD.KP.ORG
MySQL Version Information:
C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe  Ver 8.0.41 for Win64 on x86_64 (MySQL Community Server - GPL)
```



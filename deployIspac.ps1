<#
.DESCRIPTION
  Deploy an SSIS project (ispac) to a database server.
.PARAMETER dataSource
  The SQL server to which the ispac should be deployed.
.PARAMETER folderName
  The integration services catalog folder to which the ispac should be deployed.
.PARAMETER projectName
  The name of the project under which the ispac will be deployed.
.PARAMETER ispacPath
  The path to the ispac file.
.EXAMPLE
  C:\PS>.\deployIspac.ps1 -dataSource usrondivarson01\hrsd01 -folderName HRSDInternal -projectName SupportUserPropagation -ispacPath .\SupportUserPropagation.ispac 
  Example to deploy the ENW support user propagation project
#>
[CmdletBinding()]
param (
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$dataSource,
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$folderName,
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$projectName,
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$ispacPath
)

Begin {
    $isCatalog = 'SSISDB'
    $isNamespace = "Microsoft.SqlServer.Management.IntegrationServices"
    $isAssembly = [Reflection.Assembly]::LoadWithPartialName($isNamespace)

    # Write out an error message to the screen.
    function Write-HostError {
      param (
        [Parameter(Mandatory = $true)][string]$msg
      )

      Write-Host $msg -foregroundcolor "red" -backgroundcolor "black"
    }

    # Get the catalog to which the project will be deployed.
    function Get-Catalog {
      param (
        [Parameter(Mandatory = $true)][string]$catalogName
      )

      $integrationServices = New-Object "$isNamespace.IntegrationServices" $conn
      return $integrationServices.Catalogs[$catalogName]
    }

    # Get the absolute path to a file.
    function Get-FullPath {
      param (
        [Parameter(Mandatory = $true)][string]$path
      )

      if ([System.IO.Path]::IsPathRooted($path)) {
        return $path
      } else {
        return [System.IO.Path]::Combine($PWD, $path)
      }
    }

    # Deploy the project.
    function Deploy-Project {
      param (
        [Parameter(Mandatory = $true)][Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder]$folder,
        [Parameter(Mandatory = $true)][string]$projectName,
        [Parameter(Mandatory = $true)][string]$ispacPath
      )

      Write-Host "Deploying Project..."
      [byte[]] $ispacFile = [System.IO.File]::ReadAllBytes($ispacPath)
      $folder.DeployProject($projectName, $ispacFile)
    }
}

Process {
    $connectionString = "Data Source=$dataSource;Initial Catalog=master;Integrated Security=SSPI;"
    $conn= New-Object System.Data.SqlClient.SqlConnection $connectionString
    $catalog = Get-Catalog $isCatalog
    if ($catalog) {
        $folder = $catalog.Folders[$folderName]
        if ($folder) {
            $ispacPath = Get-FullPath $ispacPath
            Deploy-Project $folder $projectName $ispacPath
            Write-Host "$projectName deployed successfully."
        } else {
            Write-HostError "The folder ($folder) does not exist."
            Write-HostError "$projectName was not deployed."
        }        
    } else {
        Write-HostError "The integration services catalog ($isCatalog) does not exist."
        Write-HostError "$projectName was not deployed."
    }
}
########################################################################################################
# Title:    on-demand-snapshot.ps1
#Author: Parag Bhardwaj
# REQUIREMENTS:
# The token can be passed as an option or entered on the command line.
# USAGE: ./on-demand-snapshot.ps1
########################################################################################################

# The IP address or hostname of a node in the Rubrik cluster.
$cluster = Read-Host ('Enter the IP address or hostname of a node in the Rubrik Cluster: ')

# The API token of the user to authenticate.
#$token = Read-Host ('Enter the API token: ')

#If you want to use static token:
#$token = 'eyXXXXXXXXFo4--U'
$header = @{"Authorization" = "Bearer $token"}
$Content = "application/json"
###########################################################################################################
##########Use the below mentioned steps if you want to use the Rubrik Module for Powershell################
#Load Rubrik module and connect
##Import-Module Rubrik

# Connect to Rubrik cluster
##Connect-Rubrik -Server $rubrikNode -Credential (Import-Clixml $creds)
###########################################################################################################

#Enter the SLA you want to assign to the Backup
$SLA = Read-Host ('Enter the SLA ID which you want to assign to the snapshot: ')

$type = Read-Host ('Enter the object for which you want to take a snapshot (Example: vm, mssql, oracle) (CASE SENSITIVE): ')

$body = @{
    "slaId:" = $SLA
}
$body_Json = $body | ConvertTo-Json

if($type -eq "vm") {
#Create on-demand snapshot for VMware VM:
# Enter the VM ID for which you want to initiate a snapshot. EX: "VirtualMachine:::0XXXXXXXX" 
# YOU CAN FIND THE VM ID IN THE URL IN CDM UI WHEN YOU CLICK ON THE VIRTUAL MACHINE.
    $VM = Read-Host ('Enter the VIRTUAL MACHINE ID for which you want to initiate an on-demand backup (Example: VirtualMachine:::0XXXXXXXX): ')
    $vm_url = "https://$cluster/api/v1/vmware/vm/$VM/snapshot"
    $vmware = Invoke-RestMethod -Method POST -Uri $vm_url  -Body $body_Json -Headers $header -ContentType $Content -SkipCertificateCheck
    Write-Output $vmware
}
#Create on-demand snapshot FOR SQL DB
elseif($type -eq "mssql") {
    $mssql = Read-Host ('Enter the Database ID for which you want to initiate an on-demand backup. (Example: MssqlDatabase:::87db5cXXXa): ')
    $SQL_URL = "https://$cluster/api/v1/mssql/db/$mssql/snapshot"
    $SQL = Invoke-RestMethod -Method POST -Uri $SQL_URL -Body $body_Json -Headers $header -ContentType $Content -SkipCertificateCheck
    Write-Output $SQL
}

#create on-demand for Oracle DB
elseif($type -eq "oracle") {
    $oracle = Read-Host ('Enter the Database ID for which you want to initiate an on-demand backup. (Example: OracleDatabase:::3cfa2b75-XXXXXXXXXa): ')
    oracle_url = "https://$cluster/api/internal/oracle/db/$oracle/snapshot"
    $oracledb = Invoke-RestMethod -Method POST -Uri $oracle_url -Body $body_Json -Headers $header -ContentType $Content -SkipCertificateCheck
    Write-Output $oracledb
}

else {
    <# Action when all if and elseif conditions are false #>
    "Please enter a valid input"
}

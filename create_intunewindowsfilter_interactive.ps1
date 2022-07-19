#Required Modules
Install-Module -Name MSAL.PS -force

Clear-MsalTokenCache

$authParams = @{
   ClientId    = 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' ## Microsoft Intune Powershell Enterprise Application
   TenantId    = '<yourTenantID>'
   DeviceCode = $true
   }
   
$authToken = Get-MsalToken @authParams






$filter = @{
    displayName = 'Example Filter'
    description = 'This filter will select all virtual machines'
    platform    = 'Windows10AndLater'
    rule        = '(device.deviceOwnership -eq "Corporate") and (device.model -startsWith "Virtual Machine")'
} | ConvertTo-Json -Depth 10


$baseGraphUri = 'https://graph.microsoft.com/beta/deviceManagement/assignmentFilters'




$authHeader = @{
    'Authorization' = $authToken.CreateAuthorizationHeader()
}

$graphParams = @{
   Method          = 'Post'
   Uri             = $baseGraphUri
   Headers         = $authHeader
   ContentType     = 'Application/Json'
   Body            = $filter
}
Invoke-RestMethod @graphParams


#Required Modules
Install-Module -Name MSAL.PS -force

Clear-MsalTokenCache

$authParams = @{
   ClientId    = 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' ## Microsoft Intune Powershell Enterprise Application
   TenantId    = '<yourtenantID>'
   Devicecode = $true
   

}
$authToken = Get-MsalToken @authParams



$dynamicGroupProperties = @{
    "description" = "All Windows 10 Devices Graph Test"
    "displayName" = "All Windows 10 Devices Graph Test"
    "groupTypes" = @("DynamicMembership")
    "MailNickname" = "TestNickname"
    "mailEnabled" = $False
    "membershipRule" = "(device.deviceOSType -eq ""Windows"")-and(device.deviceOSVersion -startsWith ""10.0.1"")-and(device.managementType -eq ""MDM"")"
    "membershipRuleProcessingState" = "On"
    "securityEnabled" = $True
} | ConvertTo-Json -Depth 10
 





$baseGraphUri = 'https://graph.microsoft.com/beta/groups'

$authHeader = @{
    'Authorization' = $authToken.CreateAuthorizationHeader()
}

$graphParams = @{
   Method          = 'Post'
   Uri             = $baseGraphUri
   Headers         = $authHeader
   ContentType     = 'Application/Json'
   Body            = $dynamicGroupProperties
}
Invoke-RestMethod @graphParams

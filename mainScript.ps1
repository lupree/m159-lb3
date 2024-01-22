param(
  [Parameter(mandatory=$true, HelpMessage="Enter the Github Personal Access Token")]
  [ValidatePattern('^ghp_[a-zA-Z0-9]{36}$')]
  [string]$pat,
  [Parameter(mandatory=$true, HelpMessage="Enter the 2 Digit Groupcode")]
  [ValidateLength(2, 2)]
  [string]$groupCode
)

ssh vmadmin@192.168.110.30 "curl -O -L https://raw.githubusercontent.com/lupree/m159/master/script -s; chmod +x script; sudo ./script -g $groupCode -t $pat" | Write-Host

# Set-DnsClientServerAddress -InterfaceIndex 9 -ServerAddresses ("192.168.110.61")

# Add-Computer -DomainName $domain -Credential $credential
# 
Get-WindowsCapability -Name RSAT*GroupPolicy* -Online | Add-WindowsCapability -Online
Get-WindowsCapability -Name RSAT*Dns* -Online | Add-WindowsCapability -Online
Get-WindowsCapability -Name RSAT*ActiveDirectory.DS* -Online | Add-WindowsCapability -Online

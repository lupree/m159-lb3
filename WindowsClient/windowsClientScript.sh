Set-DnsClientServerAddress -InterfaceIndex 9 -ServerAddresses ("192.168.110.61")
Get-WindowsCapability -Name RSAT*GroupPolicy* -Online | Add-WindowsCapability
Get-WindowsCapability -Name RSAT*Dns* -Online | Add-WindowsCapability
Get-WindowsCapability -Name RSAT*ActiveDirectory.DS* -Online | Add-WindowsCapability
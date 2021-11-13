Set-ExecutionPolicy RemoteSigned -Force

$exchuri = "http://"
$exchuri += Read-Host -Prompt "Enter the on-prem server's FQDN"
$exchuri += "/PowerShell/"
Read-Host -Prompt "Press any key to connect to $exchuri"
$UserCredential = Get-Credential -UserName $upn -Message "Enter your exchange on-premises password"
	
#Set New line using OFS special Powershell variable
$OFS = "`n"
#Externally set input value as string
[string[]] $employees= @()
#Get the input from the user
$employees = READ-HOST "Enter problem usernames, seperated by commas"
#splitting the list of input as array by Comma & Empty Space
$employees = $employees.Split(',')
$OFS + $employees

$guids =@()

Connect-ExchangeOnline

For ($i=0; $i -lt $employees.Length; $i++) {
    echo $employees[$i]
    $guids += (Get-Mailbox $employees[$i] | Select-Object -ExpandProperty ExchangeGUID).toString()
    }

For ($i=0; $i -lt $guids.Length; $i++) {
    echo $guids[$i]
    }

Disconnect-ExchangeOnline -Confirm:$false
Read-Host -Prompt "Contine if GUIDs populated"

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $exchuri -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session -DisableNameChecking

For ($i=0; $i -lt $employees.Length; $i++) {
    echo $employees[$i]
    $remoterouting = ($employees[$i] + "@compasshealthcenter.mail.onmicrosoft.com")
    echo $remoterouting
    echo $guids[$i]
    Read-Host -Prompt "Does this look good?"
    Enable-RemoteMailbox -Identity $employees[$i] -RemoteRoutingAddress $remoterouting
    Set-RemoteMailbox -Identity $employees[$i] -ExchangeGUID $guids[$i]
    Get-RemoteMailbox -Identity $employees[$i] | fl ExchangeGUID
    }

Remove-PSSession $Session
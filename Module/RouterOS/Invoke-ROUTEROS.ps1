function Invoke-ROUTEROS {
    <#
        .SYNOPSIS
        Invokes a command using SSH on a RouterOS Router
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$command
    )

    Process {
        $RouterIP = Get-MICROConfigurationValue -Name EntranceRouterInternalIP

        $password = ConvertTo-SecureString (Get-MICROConfigurationValue -Name EntranceRouterPassword) -AsPlainText -Force
        $username = Get-MICROConfigurationValue -Name EntranceRouterUsername

        $RouterCredentials = New-Object System.Management.Automation.PSCredential ($username, $password)

        $session = New-SSHSession -ComputerName $RouterIP -Credential $RouterCredentials

        (Invoke-SSHCommand -SSHSession $session -Command $command).Output

        Remove-SSHSession $session | Out-Null
    }
}

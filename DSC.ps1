Configuration MattDSC
{
    node MATTG2012R2
    { 
        Registry EnableRdp
        {
        Key = "HKLM:SYSTEM\CurrentControlSet\Control\Terminal Server";
        ValueName = "fDenyTSConnections";
        ValueData = "0";
        ValueType = "DWord";
        }

        WindowsFeature EnablePrintServer
        {
        Name = "Print-Server"
        Ensure = "Present"
        IncludeAllSubFeature = $True
        DependsOn = "[Script]WindowsUpdateStatus"
        }

        Script WindowsUpdateStatus
        {
        SetScript = {
            $AUSettigns = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
            #1 = off, 4 = on
            $AUSettigns.NotificationLevel = 4
            $AUSettigns.save()
            }
        TestScript = {(((New-Object -com "Microsoft.Update.AutoUpdate").Settings).NotificationLevel -eq 4)}
        GetScript = {
            $NotificationLevel = ((New-Object -com "Microsoft.Update.AutoUpdate").Settings).NotificationLevel
            $Result = @{
                NotificationLevel = $NotificationLevel
                }
            return $Result
            }
        }

        Package AdobeReader
        {
        Ensure = "Present"
        Path = "$env:SystemDrive\Installs\AdbeRdr11004_en_US.exe"
        Arguments = '/spb /rs'
        Name = "Adobe Reader 11"
        ProductId = "AC76BA86-7AD7-1033-7B44-AB0000000001"
        }

        LocalConfigurationManager {
        RebootNodeIfNeeded = $True
        }

        File MarkerFile
        {
        Ensure = "Present"
        DestinationPath = 'C:\deployed.txt'
        Contents = ""
        }
    }
}

MattDSC -OutputPath C:\Script

<#
System - Remote Users

Control Panel - Windows Updates

Get-WindowsFeature Print-Server | ft -AutoSize

Control Panel - Uninstall a program


#Run this:

Start-DscConfiguration -Path C:\Script -Wait

#>
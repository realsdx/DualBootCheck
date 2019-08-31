Write-Host "`nChecking Dual-Boot compatibily of your device `n" -f Magenta;

#Before checking UEFI, we should check if it's Legacy BIOS or UEFI
$SecureBootStatus = Confirm-SecureBootUEFI -ErrorVariable ProcessError 
if ($ProcessError -eq $true) 
{ 
    Write-Host "System is booted in " -f Yellow -n; Write-Host "Lagecy BIOS Mode" -f Red;  
} 
else 
{ 
    Write-Host "System is booted in " -f Yellow -n; Write-Host "UEFI Mode" -f Cyan; 
    # Check secureboot status for UEFI systems
    #$SecureBootStatus = Confirm-SecureBootUEFI;
    $sbColor = if ($SecureBootStatus -eq $false) { "Cyan" } else { "Red" };
    Write-Host "SecureBoot Status: " -f Yellow -n; Write-Host "$SecureBootStatus" -f $sbColor;  
}
Write-Host " ";



# Check disk partion type
Write-Host "Disk Status: " -f Yellow;
$disks = Get-Disk | Select Number, Model, HealthStatus, Size, PartitionStyle;

foreach( $disk in $disks)
{
    $diskSize = [math]::Round($disk.Size/(1024*1024*1024), 2);
    $diskInterface = (Get-WMIObject -Class Win32_DiskDrive | Where-Object {$_.Index -eq $disk.Number}).InterfaceType;
    $partColor = if ($disk.PartitionStyle -eq 'GPT') { "Cyan" } else { "Red" };

    $parts = Get-Partition -DiskNumber $disk.Number;

    Write-Host "    Number: " -f DarkYellow -n; Write-Host $disk.Number;
    Write-Host "    Model: " -f DarkYellow -n; Write-Host $disk.Model;
    Write-Host "    HealthStatus: " -f DarkYellow -n; Write-Host $disk.HealthStatus;
    Write-Host "    TotalSize : " -f DarkYellow -n; Write-Host $diskSize -n; Write-Host " GB";
    Write-Host "    Interface Type: " -f Green -n; Write-Host $diskInterface -f $partColor;
    Write-Host "    PartitionStyle: " -f Green -n; Write-Host $disk.PartitionStyle -f Cyan;

    foreach( $part in $parts)
    {
        #take only  partitions which has a drive letter
        $out_part = $part | Select NoDefaultDriveLetter, DriveLetter, Size, Type
        $partSize = [math]::Round($out_part.Size/(1024*1024*1024), 2);
        $typeColor = if ($out_part.Type -eq 'Basic') { "Cyan" } else { "Red" };

        if($out_part.NoDefaultDriveLetter -eq $false)
        {   
            Write-Host "        Drive : " -f DarkYellow -n; Write-Host $out_part.DriveLetter -n;
            Write-Host "  Size : " -f DarkYellow -n; Write-Host "$partSize GB"-f DarkCyan -n;
            Write-Host "  Type : " -f Green -n; Write-Host $out_part.Type -f $typeColor;
        }
    }
    Write-Host " ";
}

# not required with the batch script
#$exits = Read-Host -Prompt 'Press Enter to exit'
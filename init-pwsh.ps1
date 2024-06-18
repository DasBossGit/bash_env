function Start-Remote() {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $File,
        [Parameter()]
        [bool]
        $Restore = $true,
        [Parameter()]
        [bool]
        $Keep = $true,
        [Parameter()]
        [String]
        $VMName = 'Alpine01',
        [Parameter()]
        [String]
        $VMSnapshot = '',
        [Parameter()]
        [String]
        $IP = '192.168.159.3',
        [Parameter()]
        [String]
        $User = 'root'
    )
    if ($Restore) {
        # Get VM
        $VMs = Get-VM
        if ($VMs.Name -contains $VMName) {
            $VM = :_ do {
                $VMs |  ForEach-Object {
                    if ($_.Name -match $VMName) {
                        $_
                        break :_
                    }
                }
            }until(1)
        }
        else {
            Write-Host -F Yellow 'Select one of the available Checkpoints: '
            $index = 0
            $VMs | ForEach-Object { $_ | Add-Member -MemberType NoteProperty -Name Index -Value ([Int]($index++)) }
            $VMs | Select-Object Index , Name, State | Format-Table
            While ($null -eq $VMIndex -or $VMIndex -notin $VMs.Index) {
                try {
                    $VMIndex = [Int]::Parse(([String]( Read-Host -Prompt 'Enter VM Index' )))
                    if ($VMIndex -notin $VMs.Index) { throw }
                }
                catch {
                    Write-Host -F Red 'Not a valid Index'
                }
            }
            $VM = $VMs | Where-Object { $_.Index -eq $VMIndex }
            Write-Host -F Cyan "Selected VM `"$($VM.Name)`""
            $VMName = $VM.Name
        }



        #Get Restore Point
        $VMSnapshots = (Get-VMSnapshot -VMName $VMName) ; [array]::Reverse($VMSnapshots)
        
        if ($VMSnapshot -in @('', $null, [String]::Empty, '*')) {
            $VMSnapshot = :_ do {
                $VMSnapshots |  ForEach-Object {
                    if ($_.Name -match $VMSnapshot) {
                        $_
                        break :_
                    }
                }
            }until(1)
        }
        if ($VMSnapshot -in @('', $null, [String]::Empty, '*') -or ($VMSnapshot -notmatch $VMSnapshots.Name)) {
            Write-Host -F Yellow 'Select one of the available Checkpoints: '
            $index = 0
            $VMSnapshots | ForEach-Object { $_ | Add-Member -MemberType NoteProperty -Name Index -Value ([Int]($index++)) }
            $VMSnapshots | Select-Object Index , Name, CreationTime, CheckpointType, ParentCheckpointName | Format-Table
            While ($null -eq $VMSnapshotIndex -or $VMSnapshotIndex -notin $VMSnapshots.Index) {
                try {
                    $VMSnapshotIndex = [Int]::Parse(([String]( Read-Host -Prompt 'Enter Checkpoint Index' )))
                    if ($VMSnapshotIndex -notin $VMSnapshots.Index) { throw }
                }
                catch {
                    Write-Host -F Red 'Not a valid Index'
                }
            }
            $VMSnapshot = $VMSnapshots | Where-Object { $_.Index -eq $VMSnapshotIndex }
            Write-Host -F Cyan "Selected Snapshot `"$($VMSnapshot.Name)`""
        }
        Write-Host -F Yellow "`nRestoring Checkpoint..."
        Restore-VMSnapshot -Name $VMSnapshot.Name -VMName $VM.Name -Confirm:$false
    }
    
    ssh -l $User $IP -t "wget -O https://git.mm-ger.com/markus/bash_env/archive/main.tar.gz $File
}
# Duplicate File Cleaner Script (PowerShell)
param (
    [string]$TargetFolder = "$env:USERPROFILE\Downloads",
    [switch]$AutoDelete = $false
)

function Get-FileHashMap {
    param (
        [string]$FolderPath
    )

    $files = Get-ChildItem -Path $FolderPath -File -Recurse:$Recurse
    $hashMap = @{}

    foreach ($file in $files) {
        try {
            $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256
            if ($hashMap.ContainsKey($hash.Hash)) {
                $hashMap[$hash.Hash] += $file.FullName
            } else {
                $hashMap[$hash.Hash] = @($file.FullName)
            }
        } catch {
            Write-Warning "Could not read $($file.FullName)"
        }
    }

    return $hashMap
}

function Remove-Duplicates {
    param (
        [hashtable]$HashMap,
        [switch]$AutoDelete
    )

    foreach ($entry in $HashMap.GetEnumerator()) {
        $duplicateGroup = $entry.Value
        if ($duplicateGroup.Count -gt 1) {
            Write-Host "`nFound duplicates:"
            for ($i = 0; $i -lt $duplicateGroup.Count; $i++) {
                Write-Host "[$i] $($duplicateGroup[$i])"
            }

            # Keep the first, delete the rest
            $toDelete = $duplicateGroup[1..($duplicateGroup.Count - 1)]
            
            for ($j = 0; $j -lt $toDelete.Count; $j++) {
                $fileIndex = $j + 1 
                $file = $toDelete[$j]
                
                if ($AutoDelete -or (Read-Host "Delete [$fileIndex] $file? (y/n)") -eq 'y') {
                    try {
                        Remove-Item -Path $file -Force
                        Write-Host "Deleted [$fileIndex]: $file"
                    } catch {
                        Write-Warning "Failed to delete [$fileIndex]: $file"
                    }
                } else {
                    Write-Host "Skipped [$fileIndex]: $file"
                }
            }
        }
    }
}


# Main execution
Write-Host "Scanning for duplicates in: $TargetFolder"
$hashMap = Get-FileHashMap -FolderPath $TargetFolder -Recurse:$Recurse
Remove-Duplicates -HashMap $hashMap -AutoDelete:$AutoDelete
Write-Host "Deletion of Duplicate Files Complete."

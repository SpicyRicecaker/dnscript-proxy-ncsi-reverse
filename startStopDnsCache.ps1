# Get "Name" of service
Param (
  [Parameter(Mandatory = $false)][string] $Service = "Dnscache",
  # Path to services, by default
  [Parameter(Mandatory = $false)][string] $Path = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services"
)

# Define enabled
Set-Variable -Name ENABLED -Option Constant -Value ([int]3)
# Define disabled
Set-Variable -Name DISABLED -Option Constant -Value ([int]4)

# Sets service and writes to output
function Set-Service ([string]$ServicePath, [int]$Value) {
  Set-ItemProperty -Path $ServicePath -Name Start -Value $Value
  
  Write-Output $ServicePath
  
  $ServiceNameObject = Get-ItemProperty -Path $ServicePath -Name Start
  [string]$ToState
  switch ($Value) {
    # Enabled
    $ENABLED {
      $ToState = "Enabled"
    }
    $DISABLED {
      $ToState = "Disabled"
    }
  }
  
  Write-Output "Successfully changed '$($ServiceNameObject.PSChildName)' to $($ToState)"
  Write-OUtput "Please restart computer to see changes take effect!"
}

# Function that takes in a path to a service and toggles it
function Update-Service ([string]$ServicePath) {
  # First we need to get the item property
  $Status = Get-ItemProperty -Path $ServicePath -Name Start
  switch ($Status.start) {
    # If it is enabled
    $ENABLED {
      # Set it to disabled
      Set-Service $ServicePath $DISABLED
    }
    # If it is disabled
    $DISABLED {
      # Set it to enabled
      Set-Service $ServicePath $ENABLED
    }
    # Otherwise, disable
    default {
      Set-Service $ServicePath $DISABLED
    }
  }
}

Update-Service "$($Path)\$($Service)"
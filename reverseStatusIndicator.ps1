# Path for which the majority of variables will be set from
$Internet = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet"

# Function for setting both IPv4 and IPv6 values
function Set-NetworkBothIPvs($Path, $KeyName, $ValueV4, $ValueV6) {
  # Set the IPv4
  Set-ItemProperty -Path $Path -Name $KeyName -Value $ValueV4
  # Set the IPv6
  Set-ItemProperty -Path $Path -Name "$($KeyName)V6" -Value $ValueV6
}

function Set-NetworkSameIPvs($Path, $KeyName, $Value) {
  # Set the IPv4
  Set-ItemProperty -Path $Path -Name $KeyName -Value $Value
  # Set the IPv6
  Set-ItemProperty -Path $Path -Name "$($KeyName)V6" -Value $Value
}

function Set-AllNetworkbothIPvs($Path, $Entries) {
  # Each entry
  foreach ($Entry in $Entries) {
    # If the entry is equal to 3
    switch ($Entry.length) {
      # If we have 3 values set both the IPv4 and IPv6 differently
      3 {
        Set-NetworkBothIPvs $Path $Entry[0] $Entry[1] $Entry[2]
      }
      # If we have 2 values set both the IPv4 and the IPv6 to differnt values
      2 {
        Set-NetworkSameIPvs $Path $Entry[0] $Entry[1]
      }
      default {
        Write-Output "YIKES NOOOOOOOOO"
      }
    }
  }
}

# Enable active probing again
Set-ItemProperty -Path $Internet -Name EnableActiveProbing -Value 1

# Desanitize microsoftr nsci presets
# Activate dns probe validation hostnames
# Reset desired string in `ncsi.txt`
# Reset website address where `ncsi.txt` is located
# Reset path to file where active dns probes are
# $EntriesToRemove = ("ActiveDnsProbeHost", "131.107.255.255", "fd3e:4f5a:5b81::1"), ("ActiveDnsProbeHost", "dns.msftncsi.com"), ("ActiveWebProbeContent", "Microsoft Connect Test"), ("ActiveWebProbehost", "www.msftconnecttest.com", "ipv6.msftconnecttest.com"), ("ActiveWebProbePath", "connecttest.txt")
$EntriesToRemove = ("ActiveDnsProbeHost", "dns.google", "dns.google"), ("ActiveDnsProbeHost", "dns.google"), ("ActiveWebProbeContent", "8.8.4.4"), ("ActiveWebProbehost", "dns.google", "dns.google"), ("ActiveWebProbePath", "connecttest.txt")

Set-AllNetworkbothIPvs $Internet $EntriesToRemove

# Reenable microsoft account sign-in
Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wlidsvc -Name Start -Value 3
# Define drive mapping parameters
$networkPath = "\\vmls2\"

# Create a new GPO object
$gpo = New-Object -ComObject "GPOTemplate.Gpo"

# Get the root of the User Configuration settings
$userConfig = $gpo.GetRootDomainSOM("User")

# Create a new Drive Maps preference item
$driveMap = $userConfig.CreateGPODriveMapItem($driveLetter, $networkPath)

# Set additional options if needed
$driveMap.Action = 2  # 1 for Create, 2 for Replace, 3 for Update, 4 for Delete
$driveMap.Label = "Label"
# $driveMap.UseFirstAvailable = $true

# Save the changes
$gpo.Save()

# Link the GPO to an Organizational Unit (OU)
# Replace "OU=YourOU,DC=domain,DC=com" with the actual OU path
$ouPath = "OU=BiodesignC1,DC=biodesignc1,DC=lan"
$ou = [ADSI]("LDAP://$ouPath")
$link = $ou.PSBase.Children.Add("linkGPO", "organizationalUnit")
$link.Properties["uSNCreated"] = $gpo.Id
$link.CommitChanges()
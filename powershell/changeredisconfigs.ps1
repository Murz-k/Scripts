# Set the parent folder path where the services' .config files are located
$parentFolder = "C:\Program Files\GreenRoad Technologies"

# Define the XML element path to search for and the attribute to add
$elementPath = "configuration/grtCachingConfiguration/providers/provider/redisConfiguration"
$oldElementPath = "configuration/grtCachingConfiguration/redisConfiguration"
$attributeName = "environment"
$attributeValue = "PREP"

# Get all .config files recursively from the parent folder
$configFiles = Get-ChildItem -Path $parentFolder -Filter "*.config" -Recurse

foreach ($file in $configFiles) {
    try {
        # Get the corresponding .exe file name by removing the .config extension
        $exeFileName = [System.IO.Path]::GetFileNameWithoutExtension($file.FullName)

        # Construct the path for the .exe file
        $exeFilePath = Join-Path -Path $file.DirectoryName -ChildPath "$exeFileName"

        # Check if the corresponding .exe file exists
        if (Test-Path $exeFilePath) {
            # Load the content of the .config file as an XML document
            $xml = [xml](Get-Content -Path $file.FullName)

            # Find all <redisConfiguration> elements using XPath
            $redisConfigurations = $xml.SelectNodes($elementPath)

            # Check if any <redisConfiguration> elements are found
            if ($redisConfigurations.Count -gt 0) {
                foreach ($redisConfig in $redisConfigurations) {
                    # Add the environment attribute to each <redisConfiguration> element
                    $redisConfig.SetAttribute($attributeName, $attributeValue)
                }

                # Save the modified XML back to the file
                $xml.Save($file.FullName)

                #Write-Host "Added attribute to $($redisConfigurations.Count) <redisConfiguration> elements in $($file.FullName)"
            } 
            else {
                 $redisConfigurations = $xml.SelectNodes($oldElementPath)
                if ($redisConfigurations.Count -gt 0) {
                   foreach ($redisConfig in $redisConfigurations) {
                        # Add the environment attribute to each <redisConfiguration> element
                        $redisConfig.SetAttribute($attributeName, $attributeValue)
                    }

                    # Save the modified XML back to the file
                    $xml.Save($file.FullName)

                    #Write-Host "Added attribute to $($redisConfigurations.Count) <redisConfiguration> elements in $($file.FullName)"
                }
                else {
                    Write-Host "No <redisConfiguration> elements found in $($file.FullName)"
                }
            }
        } else {
            Write-Host "Corresponding .exe file not found for $($file.FullName)"
        }
    } catch {
        Write-Host "Error processing $($file.FullName): $_"
    }
}

# Set the parent folder path where the app.staging.json files are located
$parentFolder = "C:\Program Files\GreenRoad Technologies"

# Define the JSON structure path to search for and the attribute value to set
$jsonPath1 = "Greenroad.Caching.Redis.InternalCache.Environment"
$jsonPath2 = "Greenroad.Caching.Redis.SharedCache.Environment"
$attributeValue = "PREP"
$configFileName = "appsettings.staging.json"

# Get all app.staging.json files recursively from the parent folder
$jsonFiles = Get-ChildItem -Path $parentFolder -Filter $configFileName -Recurse

foreach ($file in $jsonFiles) {
    try {
        # Load the content of the JSON file as a PowerShell object
        $jsonContent = Get-Content -Path $file.FullName | ConvertFrom-Json

        # Check if the structure 1 exists and modify the attribute value or create it if missing
        if ($jsonContent.$jsonPath1) {
            $jsonContent.$jsonPath1 = $attributeValue
            Write-Host "Modified $jsonPath1 in $($file.FullName)"
        } else {
            # Create the structure and set the attribute value
            $jsonPath1Parts = $jsonPath1 -split '\.'
            $currentObject = $jsonContent
            foreach ($part in $jsonPath1Parts) {
                if (-not $currentObject.$part) {
                    $currentObject.$part = @{}
                }
                $currentObject = $currentObject.$part
            }
            $currentObject = $attributeValue
            Write-Host "Created and set $jsonPath1 in $($file.FullName)"
        }

        # Check if the structure 2 exists and modify the attribute value or create it if missing
        if ($jsonContent.$jsonPath2) {
            $jsonContent.$jsonPath2 = $attributeValue
            Write-Host "Modified $jsonPath2 in $($file.FullName)"
        } else {
            # Create the structure and set the attribute value
            $jsonPath2Parts = $jsonPath2 -split '\.'
            $currentObject = $jsonContent
            foreach ($part in $jsonPath2Parts) {
                if (-not $currentObject.$part) {
                    $currentObject.$part = @{}
                }
                $currentObject = $currentObject.$part
            }
            $currentObject = $attributeValue
            Write-Host "Created and set $jsonPath2 in $($file.FullName)"
        }

        # Save the modified JSON back to the file
        $jsonContent | ConvertTo-Json -Depth 100 | Set-Content -Path $file.FullName
    } catch {
        Write-Host "Error processing $($file.FullName): $_"
    }
}


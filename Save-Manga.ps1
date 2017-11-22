function Save-Manga {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
            Position = 0,
            ValueFromPipeline,
            HelpMessage = 'the chapter URL')]
        [string]$URL,
        [Parameter(Mandatory,
            Position = 1,
            HelpMessage = 'path to save files')]
        [string]$Path,
        [Parameter(Position = 2,
            HelpMessage = 'substring regex to identify manga image files')]
        [string]$Substring
    )

    if (-not (Test-Path -Path $Path)) {

        New-Item -Path $Path -ItemType Directory -Force | Out-Null

    }

    $response = Invoke-WebRequest -Uri $URL

    $images = $response.Images.src | Where-Object -FilterScript {$_ -match $Substring}

    foreach ($image in $images) {

        Invoke-WebRequest -Uri $image -OutFile "$Path\$(($image -split '/')[-1])"

    }

}
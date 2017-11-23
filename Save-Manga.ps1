<#
    .SYNOPSIS
    Download manga from http://mangakakalot.com/
    .DESCRIPTION
    Tested on a number of series and it seems to work. Each of the comic pages has an arbitrary source name. To make
    it easier to compress into .cbr and .cbz files that can be consumed with your favorite program like ComicRack on PC
    or A Perfect Viewer on Android, the files are renamed from 000 to 999 (filetype is preserved).
    .PARAMETER URL
    The URL for the chapter you'd like to download.
    .PARAMETER Path
    The path what for where to save as.
    .EXAMPLE
    PS C:\>Save-Manga URL 'http://mangakakalot.com/chapter/made_in_abyss/chapter_1' -Path 'C:\TEMP\MiA\Chapter 1'

    Downloads all the images for Chapter 1 of Made in Abyss to the specified folder.
    .NOTES
    Some chapters are borked and that ain't on me.
#>
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
        [string]$Path
    )

    if (-not (Test-Path -Path $Path)) {

        New-Item -Path $Path -ItemType Directory -Force | Out-Null

    }

    # retrieve the whole chapter page
    $response = Invoke-WebRequest -Uri $URL

    <#
        filter images to just actual pages of the manga, i.e.
        'Made in Abyss vol.1 chapter 1 : [LQ] Oath, Town at the Edge of the Abyss page 11 - Mangakakalot.com'
    #>
    $images = $response.Images | Where-Object -FilterScript {$_.title -match 'page \d+'}

    foreach ($image in $images.src) {

        # rename weird page filenames to just a straight indexed page
        $pageNumber = ([array]::IndexOf($images.src, $image)).ToString("000")

        <#
            figure out filetype, usually just jpg. on very rare occasions, the src will have '?<lots_of_numbers>'
            appended on the end, the -replace will strip that out
        #>
        $fileType = ($image -split '\.')[-1] -replace '\?\d*'

        # download the image file from source to destination where new filename is index + filetype
        Invoke-WebRequest -Uri $image -OutFile "$Path\$pageNumber.$fileType"

    }

}
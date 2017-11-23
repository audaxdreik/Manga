First, download all the chapters of your preferred manga.

``` powershell
$chapters = 1..43

foreach ($chapter in $chapters) {

    Save-Manga -URL "http://mangakakalot.com/chapter/made_in_abyss/chapter_$chapter" -Path "C:\TEMP\MiA\Chapter $chapter"

}
```

Then, wrap them up into a comic archive.

``` powershell
Add-Type -AssemblyName 'System.IO.Compression.FileSystem'

$folders = Get-ChildItem -Path C:\TEMP\MiA

foreach ($folder in $folders) {

    $source = $folder.FullName

    $destination = "C:\TEMP\MiA\$($folder.Name).cbz"

    [System.IO.Compression.ZipFile]::CreateFromDirectory($source,$destination)

}
```
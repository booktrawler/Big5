# ADD LIST TITLES TO IMAGES

# Set variables and read in templates for book list header and footer HTML
Set-Location -Path "C:\Users\richa\OneDrive\Documents\GitHub\Big5\test\"
$image_path = "C:\Users\richa\OneDrive\Documents\GitHub\Big5\images\"
$new_image_path = "C:\Users\richa\OneDrive\Documents\GitHub\Big5\images_text\"

# Import the contents of the booklist.xlsm file, sort it and store it in the $book_list variable.
$book_categories = Import-Excel C:\Users\richa\OneDrive\Documents\GitHub\Booklist\booklist.xlsm -WorkSheetname Booklist | select-object list_links, list_links_href -Unique #| sort-object -Property "list_date" -Descending

#==========================================================================================================#
    # Convert Images to Overlaid text Images with ImageMagick
#==========================================================================================================#

# Loop through each list category list
foreach ($category in $book_categories) {
    
    $current_list = $category.list_links
    $filename = $category.list_links_href -replace '.*\/'
    $imagename = $filename + ".jpg"
    $old_imagename = $image_path + $filename + ".jpg"
    $new_imagename = $new_image_path + $filename + "-text.jpg"
    $image_magick = 'magick convert ' + $old_imagename + ' -resize 572x572  -size 572x572 xc:white +swap -gravity center -composite  -gravity north -pointsize 18 -annotate +0+20 "' + $current_list + '" ' + $new_imagename

    # Warn if image does not exist
    If (Test-Path $test_imagename -PathType leaf) {
        Write-Host $new_imagename
        cmd.exe /c $image_magick
    }
}

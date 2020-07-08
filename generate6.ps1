# GENERATE THE BIG 5 STATIC PAGE WEBSITE

# Set variables and read in templates for book list header and footer HTML
Set-Location -Path "C:\Users\richa\OneDrive\Documents\GitHub\Big5\"
$header = Get-Content -Path header_bootstrap.html -RAW
$footer = Get-Content -Path footer_bootstrap.html -RAW

# Import the contents of the booklist.xlsm file, sort it and store it in the $book_list variable.
$book_list = Import-Excel C:\Users\richa\OneDrive\Documents\GitHub\Booklist\booklist.xlsm -WorkSheetname Booklist #| sort -Property "list_links"
$book_categories = Import-Excel C:\Users\richa\OneDrive\Documents\GitHub\Booklist\booklist.xlsm -WorkSheetname Booklist | select-object list_links, list_links_href, list_category -Unique
$list_categories = Import-Excel C:\Users\richa\OneDrive\Documents\GitHub\Booklist\booklist.xlsm -WorkSheetname Booklist | select-object list_category -Unique | sort-object -Property "list_category"

#==========================================================================================================#
    # Create CATEGORY Pages for book lists
#==========================================================================================================#

# Build and footer navigation for all categories
$category_navigation = '<ul class="list-unstyled">'
foreach ($category in $list_categories) {
    if($category.list_category -ne ""){
        $category_navigation = $category_navigation + '<li><a href="' + $category.list_category.replace(" ", "-") + '.html">' + $category.list_category + '</a></li>'
    }
}
$category_navigation = $category_navigation + '</ul>'

# Loop through each list category list
foreach ($category in $list_categories) {
    if($category.list_category -ne ""){
        $category_filename = $category.list_category.replace(" ", "-") + ".html"
        $category_image = "big.jpg"
        $category_header = $header.Replace("##PageTitle##","Big 5 Club: The Big 5 Books in " + $category.list_category)
        $category_header = $category_header.Replace("##ListTitle##","The Big 5 Books ... " + $category.list_category)
        $category_header = $category_header.Replace("##CoverImage##",$category_image)
        $category_header = $category_header.Replace("##CategoryLink##","")
        $breadcrumbs = '<a href="index.html">Home</a> &nbsp;&gt;&nbsp;' + $category.list_category
        $category_header = $category_header.Replace("##Breadcrumbs##",$breadcrumbs)
        $category_header = $category_header.Replace("##CategoryNavigation##",$category_navigation)
        $category_footer = $footer
        $category_footer = $category_footer.Replace("##Navigation##","")

        # Output header to new web page
        If (Test-Path $category_filename  -PathType leaf) {$a="hello"} Else {Write-Host "New: " $category_filename}
        out-file -filepath $category_filename -InputObject $category_header -Encoding utf8

        # Loop through each book category list
        foreach ($list_category in $book_categories) {
            # Check to see if a new index page id needed or if last category has been reached
            $article = ""
            if($list_category.list_category -eq $category.list_category){
                
            $current_list = $list_category.list_links
            $filename = $list_category.list_links_href -replace '.*\/'
            $imagename = $filename + ".jpg"
            $filename = $filename + ".html"

            $article = $article + '<div class="col-md-4">'
            $article = $article + '    <div class="card mb-4 shadow-sm">'
            $article = $article + '         <div class="card">'
            $article = $article + '            <img src="images/' + $imagename + '" class="card-img-top" alt="' + $current_list + '">'
            $article = $article + '             <div class="card-header">'
            $article = $article + '			        <a href="' + $filename + '">'
            $article = $article + '			        <h5 class="card-title" style="font-family:Rosario">' + $current_list + '</h5></a>'
            $article = $article + '		        </div>'
            $article = $article + '		    </div>'
            $article = $article + '		</div>'
            $article = $article + '	</div>'

            # Append category card to category page
            out-file -filepath $category_filename -InputObject $article -Encoding utf8 -append
            }
        }
        # Add footer to category page
        out-file -filepath $category_filename -InputObject $category_footer -Encoding utf8 -append
    }
}

#==========================================================================================================#
# Create INDEX PAGES
#==========================================================================================================#

$category_count=0
$page_count=1
$home_filename="index.html"
$pagination = 20 

# Replace index page tags with header with values
$index_header = $header.Replace("##PageTitle##","Big 5 Club: The Big 5 Books")
$index_header = $index_header.Replace("##ListTitle##","The Big 5 Books ...")
$index_header = $index_header.Replace("##CoverImage##","big.jpg")
$index_header = $index_header.Replace("##CategoryLink##","")
$index_header = $index_header.Replace("##Breadcrumbs##","")
$index_header = $index_header.Replace("##CategoryNavigation##", $category_navigation)
$article=""

# Loop through each book category list
foreach ($category in $book_categories) {
    # Create index page (and paginated index pages) with links to all blog pages including header and footer content
    # Loop through each book category list and create a page for every number of categories
    $category_count++
    # Check to see if a new index page id needed or if last category has been reached
    if(($category_count % $pagination) -eq 0 -or $category_count -eq $book_categories.Count){
        # Save current index page with Previous/Next Navigation
        $index_footer = ""
        $nav_footer = '<div class="row">
            <div class="col-md-12 text-center">
                <nav aria-label="Page navigation">
                    ##Previous##&nbsp;...&nbsp;##Next##
                </nav>
            </div>
        </div>'
        $previous = ""
        $next = ""
        $page_number = $page_count - 1
        $previous_number = $page_number - 1
        $next_number = $page_number + 1
        $last_page = [math]::floor($book_categories.Count / $pagination)
        $index_footer = $footer

        If ($page_number -eq 0) {$previous=""
        } elseif ($page_number -eq 1) {
            $previous='<a href="index.html">Previous</a>'
        } else {
            $previous='<a href="index' + $previous_number + '.html" aria-label="Previous">
            <span aria-hidden="true">Previous</span></a>'
        }
        $nav_footer = $nav_footer.Replace("##Previous##",$previous)
        
        If ($page_number -eq $last_page) {$next=""
        } else {
            $next='<a href="index' + $next_number + '.html" aria-label="Next">
            <span aria-hidden="true">Next</span></a>'
        }
        $nav_footer = $nav_footer.Replace("##Next##",$next)
        
        $index_footer = $index_footer.Replace("##Navigation##",$nav_footer)
        $home_page = $index_header + $article + $index_footer
        out-file -filepath $home_filename -InputObject $home_page -Encoding utf8
        
        # Start new index page
        $home_filename="index" + $page_count + ".html"
        $page_count++
        $article = ""
    }
    
    $current_list = $category.list_links
    $filename = $category.list_links_href -replace '.*\/'
    $imagename = $filename + ".jpg"
    $filename = $filename + ".html"

    $article = $article + '<div class="col-md-4">'
    $article = $article + '    <div class="card mb-4 shadow-sm">'
    $article = $article + '         <div class="card">'
    $article = $article + '            <img src="images/' + $imagename + '" class="card-img-top" alt="...">'
    $article = $article + '             <div class="card-header">'
    $article = $article + '			        <a href="' + $filename + '">'
    $article = $article + '			        <h5 class="card-title" style="font-family:Rosario">' + $current_list + '</h5></a></div>'
    $article = $article + '					<div class="card-header">' + $category.list_category
    $article = $article + '		        </div>'
    $article = $article + '		    </div>'
    $article = $article + '		</div>'
    $article = $article + '	</div>'
}

#===============================================================================================================#
# Create BIG 5 LIST pages
#===============================================================================================================#

foreach ($category in $book_categories) {
    
    # Create category web page with HTML header
    $current_list = $category.list_links
    $filename = $category.list_links_href -replace '.*\/'
    $imagename = $filename + ".jpg"
    $test_imagename = 'images/' + $imagename
    $filename = $filename + ".html"

    # Warn if image does not exist
    If (Test-Path $test_imagename -PathType leaf) {$a="hello"} Else {Write-Host "Need new: $imagename"}

    # Replace tags with header with values
    $page_header = ""
    $page_header = $header
    $page_header = $page_header.Replace("##PageTitle##","Big 5 Club: $current_list")
    $page_header = $page_header.Replace("##ListTitle##",$current_list)
    $category_link = $category.list_category.replace(" ", "-")
    $category_link = '<a href="' + $category_link + '.html" class="text-link">' + $category.list_category + '</a>'
    $page_header = $page_header.Replace("##CategoryLink##",$category_link)
    $page_header = $page_header.Replace("##CoverImage##",$imagename)
    $breadcrumbs = '<a href="index.html">Home</a> &nbsp;&gt;&nbsp;' + $current_list
    $page_header = $page_header.Replace("##Breadcrumbs##",$breadcrumbs)
    $page_header = $page_header.Replace("##CategoryNavigation##", $category_navigation)
    $page_footer = ""
    $page_footer = $footer
    $page_footer = $page_footer.Replace("##Search##",$current_list)
    $page_footer = $page_footer.Replace("##Navigation##","")


    # Output header to new web page
    If (Test-Path $filename  -PathType leaf) {remove-item $filename} Else {Write-Host "New: " $filename}
    out-file -filepath $filename -InputObject $page_header -Encoding utf8

    # Loop through all the records in the CSV to find books for this category
    # Ignore if ISBN is not fully formed
    foreach ($book in $book_list) {
        if($book.list_links -eq $current_list -and $book.book_isbn.tostring().length -eq 13) {

            # Set up table row for next book
            $table = ""
            #Convert ISBN to ASIN
            $ISBN = $book.book_isbn.tostring()
            $ASIN = $ISBN.substring(3,9)
            $CheckSum = (([int]$ASIN.substring(0,1) * 10) + (([int]$ASIN.substring(1,1)) * 9) + (([int]$ASIN.substring(2,1)) * 8) + (([int]$ASIN.substring(3,1)) * 7) + (([int]$ASIN.substring(4,1)) * 6) + (([int]$ASIN.substring(5,1)) * 5) + (([int]$ASIN.substring(6,1)) * 4) + (([int]$ASIN.substring(7,1)) * 3) + (([int]$ASIN.substring(8,1)) * 2))
            $Mod = $CheckSum % 11
            if((11-$Mod) -eq 10){
                $ASIN = $ASIN + "X"
            } elseif((11-$Mod) -eq 11) {
                $ASIN = $ASIN + "0"
            } else {
                $ASIN = $ASIN + (11 - $Mod)
            }

            $table = $table + '<div class="col-md-4">'
            $table = $table + '    <div class="card mb-4 shadow-sm">'
            $table = $table + '         <div class="card">'
            $table = $table + '            <img src="https://ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=' + $ASIN + '&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=SL250" class="card-img-top" alt="...">'
            $table = $table + '             <div class="card-header">'
            $table = $table + '					<h3 style="font-family:Rosario">' + $book.book_links + '</h3>'
            $table = $table + '					by ' + $book.book_author + '</div>'
            $table = $table + '					<div class="card-body"><span style="font-family:Merriweather">' + $book.book_blurb + '</span></div>'
            $table = $table + '					<div class="card-footer">Find out more at <a href="https://bookshop.org/a/8799/' + $ISBN + '"  target="_blank">Bookshop.org</a> or <a href="https://amazon.com/dp/' + $ASIN + '/&tag=booktrawler-20"  target="_blank">Amazon.com</a>
                                            </div>'
            $table = $table + '		     </div>'
            $table = $table + '		</div>'
            $table = $table + '</div>'

            # Append book card to category page
            out-file -filepath $filename -InputObject $table -Encoding utf8 -append
        }
    }
    # Add footer to category page
    out-file -filepath $filename -InputObject $page_footer -Encoding utf8 -append
}


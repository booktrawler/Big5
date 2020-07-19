$URL = "https://ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=9948363507&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=SL250"

$Site = iwr -Uri $URL

$Images = ($Site).Images.src

foreach ($Image in $Images) {

    Start-BitsTransfer  -Source $Image -Destination C:\Users\richa\OneDrive\Documents\GitHub\Big5\test\ -TransferType Download  -UseBasicParsing

}

#Invoke-WebRequest 'https://bookshop.org/lists/the-big-5-books-on-working-at-home' -UseBasicParsing

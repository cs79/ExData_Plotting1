## Script to download data and recreate "Global Active Power" plot graphic as a
## 480x480 px PNG.  Script will output a file called "plot1.png".

## download the data

if(!file.exists("./data")) {dir.create("./data")}
zipURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#Windows:
download.file(zipURL, destfile="./data/EPCdata.zip")
#Mac:
download.file(zipURL, destfile="./data/EPCdata.zip", method="curl")
dateDownloaded <- date()

## unzip data

unzip("./data/EPCdata.zip", exdir="./data")

## read into R

epc <- read.table("./data/household_power_consumption.txt", header = TRUE, sep = ";")

## subset the days of interest (2007-02-01 and 2007-02-02)

epc2 <- epc[epc$Date %in% c("1/2/2007", "2/2/2007"),]

## open graphics device



## plot

hist(as.numeric(as.character(epc2[,3])), col="red", main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

## close device

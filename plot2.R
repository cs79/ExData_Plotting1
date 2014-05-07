## Script to download and recreate Plot 2 graphic of Global Active Power over
## time for the two-day window of 2/1/2007 - 2/2/2007 as a 480x480 px PNG.
## Script will output a file called "plot2.png".

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

## get datetimes as POSIX and change global active power from factor to numeric

epc2$DateTime <- strptime((paste(epc2$Date, epc2$Time, sep="-")), format="%d/%m/%Y-%H:%M:%S")
epc2$Global_active_power <- as.numeric(as.character(epc2$Global_active_power))

## open PNG graphics device with specified dimensions

png(file = "plot2.png", width = 480, height = 480, units = "px")

## plot

plot(epc2$DateTime, epc2$Global_active_power, type="l", 
     ylab="Global Active Power (kilowatts)", xlab="")

## close graphics device

dev.off()

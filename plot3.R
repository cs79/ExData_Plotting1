## Script to download data and recreate Plot 3 graphic of Energy sub-metering
## over the two-day window of 2/1/2007 - 2/2/2007 as a 480x480 px PNG.  Script
## will output a file called "plot3.png".

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

## get datetimes as POSIX; sub-metering values as numeric where they aren't already

epc2$DateTime <- strptime((paste(epc2$Date, epc2$Time, sep="-")), format="%d/%m/%Y-%H:%M:%S")
epc2$Sub_metering_1 <- as.numeric(as.character(epc2$Sub_metering_1))
epc2$Sub_metering_2 <- as.numeric(as.character(epc2$Sub_metering_2))

## open PNG graphics device with specified dimensions

png(file = "plot3.png", width = 480, height = 480, units = "px")

## plot

#empty frame with labels:
plot(epc2$DateTime, epc2$Sub_metering_1, type="n", ylab="Energy sub metering", xlab="")
#black sub-metering 1 line:
lines(epc2$DateTime, epc2$Sub_metering_1, type="l", col="black")
#red sub-metering 2 line:
lines(epc2$DateTime, epc2$Sub_metering_2, type="l", col="red")
#blue sub-metering 3 line:
lines(epc2$DateTime, epc2$Sub_metering_3, type="l", col="blue")
#legend:
legend("topright", lty="solid", col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## close graphics device

dev.off()

## Script to download data and recreate the 2x2 multi-plot Plot 4 graphic of 
## Global Active Power, Voltage, Energy sub metering, and Global Reactive Power
## for the two-day window of 2/1/2007 - 2/2/2007 as a 480x480 px PNG.  Script 
## will output a file called "plot4.png".

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

## variable preparation: datetimes as POSIX, Global Active Power as numeric,
## Voltage as numeric, Sub-metering as numeric where it is not already, and
## Global Reactive Power as numeric

epc2$DateTime <- strptime((paste(epc2$Date, epc2$Time, sep="-")), format="%d/%m/%Y-%H:%M:%S")
epc2$Global_active_power <- as.numeric(as.character(epc2$Global_active_power))
epc2$Voltage <- as.numeric(as.character(epc2$Voltage))
epc2$Sub_metering_1 <- as.numeric(as.character(epc2$Sub_metering_1))
epc2$Sub_metering_2 <- as.numeric(as.character(epc2$Sub_metering_2))
epc2$Global_reactive_power <- as.numeric(as.character(epc2$Global_reactive_power))

## open PNG graphics device with specified dimensions

png(file = "plot4.png", width = 480, height = 480, units = "px")

## plot

#set up 2x2 multi-plot space, to be filled in column-wise
par(mfcol=c(2,2))
#upper left plot (global active power):
plot(epc2$DateTime, epc2$Global_active_power, type="l", 
     ylab="Global Active Power", xlab="")
#lower left plot (energy sub metering):
plot(epc2$DateTime, epc2$Sub_metering_1, type="n", ylab="Energy sub metering", xlab="")
lines(epc2$DateTime, epc2$Sub_metering_1, type="l", col="black")
lines(epc2$DateTime, epc2$Sub_metering_2, type="l", col="red")
lines(epc2$DateTime, epc2$Sub_metering_3, type="l", col="blue")
legend("topright", lty="solid", col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
#upper right plot (voltage):
plot(epc2$DateTime, epc2$Voltage, type="l", ylab="Voltage", xlab="datetime")
#lower right plot (global reactive power):
plot(epc2$DateTime, epc2$Global_reactive_power, type="l", 
     ylab="Global_reactive_power", xlab="datetime")

## close graphics device

dev.off()

# Get data
library(lubridate)
library(dplyr)

zipFile <- 'household_power_consumption.zip'
zipFilePath <- file.path(getwd(), zipFile)

if (!file.exists(zipFilePath)) {
    zipURL <-
        'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    download.file(zipURL, destfile = zipFilePath, method = 'curl')
}


dataFile <- 'household_power_consumption.txt'
if (!file.exists(dataFile)) {
    unzip(zipfile = zipFile)
}

# setClass('DDMMYYYY')
# setClass('HHMMSS')
# setAs("character","DDMMYYYY", function(from) dmy(from) )
# setAs("character", "HHMMSS", function(from) hms(from))


power <- read.csv2(
    dataFile,
    sep = ";",
    na.strings = "?",
    dec = ".",
    colClasses =
        c(# 'DDMMYYYY','HHMMSS',
            rep('character', 2),
            rep("numeric", 7)),
    stringsAsFactors = FALSE
)



power$Date_Time <- with(power, paste(Date, Time))
power$Date <- with(power, as.POSIXct(Date, format = "%d/%m/%Y"))
power$Date_Time  <-
    with(power,  as.POSIXct(Date_Time, format = "%d/%m/%Y %H:%M:%S"))


png("./Plot4.png",width = 480, height = 480)
#windows(width=480, height=480)

par(
    mfrow = c(2, 2),
    mar = c(4, 4, 2, 2),
    oma = c(0, 0, 0, 0)
)

with(power_sample, {
    plot(
        Date_Time,
        Global_active_power,
        type = "n",
        xlab = "",
        ylab = "Global Active Power (kilowatts)"
    )
    lines(Global_active_power ~ Date_Time, lwd = 1)
    
    
    
    
    plot(
        Date_Time,
        Voltage,
        xlab = "datetime",
        ylab = "Voltage",
        type = "n"
    )
    lines(Voltage ~ Date_Time, lwd = 1)
    
    plot(
        Date_Time,
        Sub_metering_1,
        xlab = "",
        ylab = "Energy sub metering",
        type = "n"
    )
    lines(Sub_metering_1 ~ Date_Time, col = "black")
    lines(Sub_metering_2 ~ Date_Time, col = "red")
    lines(Sub_metering_3 ~ Date_Time, col = "blue")
    legend(
        "topright",
        lty = 1,
        cex = 0.6,
        col = c("black", "red", "blue"),
        bty = "n",
        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
    )
    
    plot(
        Date_Time,
        Global_reactive_power,
        xlab = "datetime",
        ylab = "Global_reactive_power",
        type = "n"
    )
    lines(Global_reactive_power ~ Date_Time, lwd = 1)
    
})


dev.off()
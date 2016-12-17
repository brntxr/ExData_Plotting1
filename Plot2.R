# Get data
library(lubridate)
library(dplyr)

zipFile <- 'household_power_consumption.zip'
zipFilePath <- file.path(getwd(),zipFile)

if (!file.exists(zipFilePath)){
    zipURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    download.file(zipURL, destfile = zipFilePath, method = 'curl')
}


dataFile<- 'household_power_consumption.txt'
if (!file.exists(dataFile)){
    unzip(zipfile = zipFile)
}



power<-read.csv2(dataFile, sep = ";", na.strings = "?", dec=".",
                 colClasses = 
                     c(
                         # 'DDMMYYYY','HHMMSS',
                         rep('character',2),
                         rep("numeric", 7)
                     ),
                 stringsAsFactors = FALSE)
power$Date_Time <- with(power, paste(Date, Time))
power$Date <- with(power, as.POSIXct(Date, format = "%d/%m/%Y"))
power$Date_Time  <- with(power,  as.POSIXct(Date_Time, format = "%d/%m/%Y %H:%M:%S"))
power_sample<- filter(power, Date >= '2007-02-01', Date<= '2007-02-02')
rm('power')

png("./Plot2.png", width=480, height=480)


with(power_sample, plot(Date_Time, Global_active_power, xlab = '', ylab = "Global Active Power (kilowatts)", type = "n"),
     x)
with(power_sample, lines(Global_active_power ~ Date_Time))
dev.off()

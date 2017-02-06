## This function only checks if we already have the dataset
## If not, then it downloads it automatically.
downloadData <- function(){
    fileName <- "household_power_consumption"
    if(!file.exists(paste(fileName, ".txt", sep = ""))){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        localFile <- paste(fileName, ".zip", sep = "")
        suppressWarnings(result <- download.file(fileUrl, destfile = localFile, method="curl"))
        if(result != 0){
            #try again in case windows don't support curl
             res <- download.file(fileUrl, destfile = localFile)
        }
        unzip(zipfile = localFile)
    }
}

## get the data from Url
downloadData()

## I did a previous analysis, so I know what are the lines
## that we need to read for dates 2007-02-01 and 2007-02-02.
## This way we avoid an unnecessary extra loading.

dataHeaders <- read.table("household_power_consumption.txt", header = TRUE, sep=";", nrows = 1)
data <- read.table("household_power_consumption.txt", sep=";", skip=66637, nrows=2881, na.strings = c("?"))
colnames(data) <- colnames(dataHeaders)
dateTime <- data.frame(as.POSIXct(strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")))
colnames(dateTime) <- c("dateTime")
data$Date <- as.Date(strptime(data$Date, "%d/%m/%Y"))
data <- cbind(data, dateTime)

## generating the plot
png("plot3.png", width = 480, height = 480, units = "px", bg = "white")
with(data, plot(dateTime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
lines(data$dateTime, data$Sub_metering_2, col = "red")
lines(data$dateTime, data$Sub_metering_3, col = "blue")
legend("topright", legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col=c('black', 'red', 'blue'), lty=c(1, 1, 1))
dev.off()
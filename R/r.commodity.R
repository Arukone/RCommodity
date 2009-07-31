## already generic in fts (which is a dependency)
dates.com <- function(x) {
    ans <- unique(unlist(lapply(x,dates)))
    class(ans) <- c("POSIXt","POSIXct")
    ans
}

simple.ret <- function(x) {
    UseMethod("simple.ret")
}

simple.ret.coms <- function(x) {
    diff(x,1)
}

ps <- function(x) {
    UseMethod("ps")
}

ps.default <- function(x) {
    x
}

ds <- function(x) {
    UseMethod("ds")
}

ds.default <- function(x) {
    x
}

max.dates <- function(x) {
    ans <- do.call(rbind,lapply(lapply(x,dates),max))
    class(ans) <- c("POSIXct","POSIXt")
    ans
}

## ds.com <- function(x,contractsForward=0,roll.method=max.dates) {
##     roll.dates <- roll.method(x)
##     nms <- names(x)
##     con.ident <- as.integer(format(attr(x,"expirationDates"),"%Y%m"))

##     max.dt <- max(unlist(lapply(lapply(x,dates),max)))
##     class(max.dt) <- c("POSIXct","POSIXt")

##     roll.dates <- roll.dates[roll.dates < max.dt]
##     ans <- list()
##     basis <- list()

##     for(i in 1:length(roll.dates)) {
##         this.index <- i + contractsForward
##         next.index <- i + contractsForward + 1
##         this.contract <- x[[ this.index ]]
##         next.contract <- x[[ next.index ]]
##         min.date <- ifelse(i == 1, dates(this.contract)[1] - 1, roll.dates[i-1])

##         basis[[ nms[i] ]] <- fts(dates=roll.dates[i],
##                                  data=as.numeric(this.contract[roll.dates[i],"close"] - next.contract[roll.dates[i],"close"]))

##         ans[[ nms[i] ]] <- this.contract[ dates(this.contract) <= roll.dates[i] & dates(this.contract) > min.date,]
##     }

##     ## do current contract
##     this.index <- i + contractsForward + 1
##     current.contract <- x[[ this.index ]]
##     ans[[ nms[i + 1] ]] <- current.contract[dates(current.contract) > max(dates(ans[[length(ans)]])),]

##     ans <- do.call(rbind,ans)
##     attr(ans,"basis") <- do.call(rbind,basis)

##     ans
## }

ds.com <- function(x,contractsForward=0,roll.method=max.dates) {
    roll.dates <- roll.method(x)
    nms <- names(x)
    con.ident <- as.integer(format(attr(x,"expirationDates"),"%Y%m"))

    max.dt <- max(unlist(lapply(lapply(x,dates),max)))
    class(max.dt) <- c("POSIXct","POSIXt")

    roll.dates <- roll.dates[roll.dates < max.dt]
    ans <- list()

    for(i in 1:length(roll.dates)) {
        this.contract <- x[[ i + contractsForward ]]
        min.date <- ifelse(i == 1, dates(this.contract)[1] - 1, roll.dates[i-1])
        ans[[ nms[i] ]] <- this.contract[ dates(this.contract) <= roll.dates[i] & dates(this.contract) > min.date,]
    }

    ## do current contract
    current.contract <- x[[ i + contractsForward + 1 ]]
    ans[[ nms[i + 1] ]] <- current.contract[dates(current.contract) > max(dates(ans[[length(ans)]])),]

    do.call(rbind,ans)
}

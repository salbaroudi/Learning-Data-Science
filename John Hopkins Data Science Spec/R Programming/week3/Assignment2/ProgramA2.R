makeVector <- function(x = numeric()) {
  m <- NULL
  set <- function(y) { #is this an object method, or inner function?
    x <<- y #<<- is the superassignment operator, that goes up the env tree until the LHS is found.
    m <<- NULL #m may not be null when this is called
  }
  
  get <- function() x
  setmean <- function(mean) x <<-mean
  getmean <- function() m
  list(set = set, get = get,
       setmean = setmean,
       getmean = getmean)
}

cachemean <- function(x, ...) {
  m <- x$getmean()
  if(!is.null(m)) {
    message("getting cached data")
    return(m)
  }
  data <- x$get
  m <- mean(data, ...)
  x$setmean(m)
  m
}

make.acc1 <- function() {
  a <- 0
  function(x) {
    a <<- a+x
    a
  }
}

#References:
#[1] https://stat.ethz.ch/pipermail/r-help/2011-April/275905.html
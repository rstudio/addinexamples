hello <- function() {
  print("Hello, World!")
}

random <- function() {
  if (!requireNamespace("rstudioapi", quietly = TRUE))
    return()

  text <- as.character(runif(1))
  rstudioapi::insertText(text)
}

insert_in <- function() {
  if (!requireNamespace("rstudioapi", quietly = TRUE))
    return()

  rstudioapi::insertText(" %in% ")
}

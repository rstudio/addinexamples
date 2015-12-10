hello <- function() {
  print("Hello, World!")
}

random <- function() {
  text <- as.character(runif(1))
  rstudioapi::insertText(text)
}

insert_in <- function() {
  rstudioapi::insertText(" %in% ")
}

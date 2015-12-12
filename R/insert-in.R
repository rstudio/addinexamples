#' Insert \%in\%.
#'
#' Call this function as an addin to insert \code{ \%in\% } at the cursor position.
#'
#' @export
insert_in <- function() {
  rstudioapi::insertText(" %in% ")
}

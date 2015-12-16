#' Rename Words in a Document
#'
#' Call this as an addin to replace occurrences of a particular sequence of
#' characters in a document with a new sequence of characters.
#'
#' @export
refactor <- function() {

  ui <- gadgetPage(

    includeHighlightJs(),
    titlebar("Refactor Code"),
    contentPanel(scrollPanel(
      h4("Replace the text 'from' with the text 'to'."),
      stableTwoColumnLayout(
        checkboxInput("boundaries", "Use Word Boundaries?", value = TRUE),
        uiOutput("changes")
      ),
      stableTwoColumnLayout(
        textInput("from", "From:"),
        textInput("to", "To:")
      ),
      uiOutput("document", container = rCodeContainer)
    ))
  )

  server <- function(input, output, session) {

    context <- rstudioapi::getActiveDocumentContext()
    original <- context$contents

    refactored <- reactive({

      from <- input$from
      to <- input$to
      boundaries <- input$boundaries

      valid <- nzchar(from) && nzchar(to)
      if (valid)
        return(performRefactor(original, from, to, boundaries))
      else
        return(list(refactored = original, changes = 0))

    })

    output$changes <- renderUI({
      spec <- refactored()
      if (spec$changes == 0)
        return(NULL)

      instances <- if (spec$changes == 1) "instance" else "instances"
      div(paste(spec$changes, instances, "will be replaced."))
    })

    output$document <- renderCode({
      spec <- refactored()
      highlightCode(session, "document")
      paste(spec$refactored, collapse = "\n")
    })

    observeEvent(input$done, {
      spec <- refactored()
      transformed <- paste(spec$refactored, collapse = "\n")
      rstudioapi::setDocumentContents(transformed)
      invisible(stopApp())
    })

  }

  runGadget(ui, server, viewer = dialogViewer("Refactor"))
}

performRefactor <- function(contents, from, to, useWordBoundaries = TRUE) {

  reFrom <- if (useWordBoundaries)
    paste("\\b", from, "\\b", sep = "")
  else
    from

  reTo <- to
  matches <- gregexpr(reFrom, contents, perl = TRUE)
  changes <- sum(unlist(lapply(matches, function(x) {
    if (x[[1]] == -1) 0 else length(x)
  })))

  refactored <- unlist(lapply(contents, function(x) {
    gsub(reFrom, reTo, x, perl = TRUE)
  }))

  list(
    refactored = refactored,
    changes = changes
  )
}
library(shiny)
library(shinygadgets)

injectHighlightHandler <- function() {

  code <- "
  Shiny.addCustomMessageHandler('highlight-code', function(message) {
    var id = message['id'];
    setTimeout(function() {
      var el = document.getElementById(id);
      hljs.highlightBlock(el);
    }, 100);
  });
  "

  tags$script(code)
}

includeHighlightJs <- function() {
  resources <- system.file("www/shared/highlight", package = "shiny")
  list(
    includeScript(file.path(resources, "highlight.pack.js")),
    includeCSS(file.path(resources, "rstudio.css")),
    injectHighlightHandler()
  )
}

highlightCode <- function(session, id) {
  session$sendCustomMessage("highlight-code", list(id = id))
}

rCodeContainer <- function(...) {
  code <- as.character(tags$code(class = "language-r", ...))
  div(pre(code))
}

renderCode <- function(expr, env = parent.frame(), quoted = FALSE) {
  func <- NULL
  installExprFunction(expr, "func", env, quoted)
  markRenderFunction(textOutput, function() {
    paste(func(), collapse = "\n")
  })
}

#' Rename Words in a Document
#'
#' Call this as an addin to replace occurrences of a particular sequence of character
#' in a document with a new sequence of characters.
#'
#' @export
refactor <- function() {

  ui <- gadgetPage(

    includeHighlightJs(),
    titlebar("Refactor Code"),
    contentPanel(scrollPanel(
      h4("Replace the text 'from' with the text 'to'."),
      checkboxInput("boundaries", "Use Word Boundaries?", value = TRUE),
      fixedRow(
        column(6, textInput("from", "From: ")),
        column(6, textInput("to", "To: "))
      ),
      fixedRow(
        column(6, uiOutput("before", container = rCodeContainer)),
        column(6, uiOutput("after", container = rCodeContainer))
      )
    ))
  )

  server <- function(input, output, session) {

    context <- rstudioapi::getActiveDocumentContext()

    before <- context$contents
    after  <- context$contents


    output$before <- renderCode({
      before
    })

    output$after <- renderCode({

      from <- input$from
      to <- input$to
      boundaries <- input$boundaries

      valid <- nzchar(from) && nzchar(to)

      transformed <- if (valid)
        performRefactor(before, from, to, boundaries)
      else
        before

      highlightCode(session, "before")
      highlightCode(session, "after")

      after <<- paste(transformed, collapse = "\n")
      after
    })

    observeEvent(input$done, {
      rstudioapi::setDocumentContents(after)
      invisible(stopApp())
    })

  }

  runGadget(ui, server)
}

performRefactor <- function(contents, from, to, useWordBoundaries = TRUE) {

  reFrom <- if (useWordBoundaries)
    paste("\\b", from, "\\b", sep = "")
  else
    from

  reTo <- to

  unlist(lapply(contents, function(x) {
    gsub(reFrom, reTo, x, perl = TRUE)
  }))
}

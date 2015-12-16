#' Reformat a block of code using formatR.
reformat <- function() {

  formatRLink <- tags$a(href = "http://yihui.name/formatR/", "formatR")

  ui <- gadgetPage(
    includeHighlightJs(),
    titlebar("Reformat Code"),
    contentPanel(scrollPanel(
      h4("Use ", formatRLink, " to reformat code"),
      verticalLayout(
        checkboxInput("brace.newline", "Place left braces '{' on a new line?", FALSE),
        numericInput("indent", "Indent size: ", 2)
      ),
      fixedRow(
        column(6, uiOutput("before", container = rCodeContainer)),
        column(6, uiOutput("after", container = rCodeContainer))
      )
    ))
  )

  server <- function(input, output, session) {

    # Get the document context.
    context <- rstudioapi::getActiveDocumentContext()
    before <- context$contents
    after  <- context$contents

    # Get the formatR options.
    output$before <- renderCode({
      before
    })

    output$after <- renderCode({

      highlightCode(session, "before")
      highlightCode(session, "after")

      formatted <- formatR::tidy_source(
        text = before,
        output = FALSE,
        width.cutoff = 500,
        indent = input$indent,
        brace.newline = input$brace.newline
      )

      after <<- paste(formatted$text.tidy, collapse = "\n")

    })

    observeEvent(input$done, {
      rstudioapi::setDocumentContents(after)
      invisible(stopApp())
    })

  }

  runGadget(ui, server, viewer = dialogViewer("Reformat"))

}

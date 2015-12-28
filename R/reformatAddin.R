#' Reformat a block of code using formatR.
reformatAddin <- function() {

  formatRLink <- tags$a(href = "http://yihui.name/formatR/", "formatR")

  ui <- miniPage(
    includeHighlightJs(),
    gadgetTitleBar("Reformat Code"),
    miniContentPanel(
      h4("Use ", formatRLink, " to reformat code."),
      hr(),
      stableColumnLayout(
        checkboxInput("brace.newline", "Place left braces '{' on a new line?", FALSE),
        numericInput("indent", "Indent size: ", 2),
        numericInput("width", "Column width: ", 60)
      ),
      uiOutput("document", container = rCodeContainer)
    )
  )

  server <- function(input, output, session) {

    # Get the document context.
    context <- rstudioapi::getActiveDocumentContext()

    reactiveDocument <- reactive({

      # Collect inputs
      brace.newline <- input$brace.newline
      indent <- input$indent
      width <- input$width

      # Build formatted document
      formatted <- formatR::tidy_source(
        text = context$contents,
        output = FALSE,
        width.cutoff = width,
        indent = indent,
        brace.newline = brace.newline
      )$text.tidy

      formatted
    })

    output$document <- renderCode({
      document <- reactiveDocument()
      highlightCode(session, "document")
      document
    })

    observeEvent(input$done, {
      contents <- paste(reactiveDocument(), collapse = "\n")
      rstudioapi::setDocumentContents(contents, id = context$id)
      invisible(stopApp())
    })

  }

  viewer <- dialogViewer("Reformat Code", width = 1000, height = 800)
  runGadget(ui, server, viewer = viewer)

}

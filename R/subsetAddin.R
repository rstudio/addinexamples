#' Subset a Data Frame.
#'
#' Interactively subset a \code{data.frame}. The resulting
#' code will be emitted as a call to the \code{\link{subset}}
#' function.
#'
#' This addin can be used to interactively subset a \code{data.frame}.
#' The intended way to use this is as follows:
#'
#' 1. Highlight a symbol naming a \code{data.frame} in your R session,
#'    e.g. \code{mtcars},
#' 2. Execute this addin, to interactively subset it.
#'
#' When you're done, the code performing this operation will be emitted
#' at the cursor position.
#'
#' @export
subsetAddin <- function() {

  # Get the document context.
  context <- rstudioapi::getActiveDocumentContext()

  # Set the default data to use based on the selection.
  text <- context$selection[[1]]$text
  defaultData <- text

  # Generate UI for the gadget.
  ui <- miniPage(
    gadgetTitleBar("Subset a data.frame"),
    miniContentPanel(
      stableColumnLayout(
        textInput("data", "Data", value = defaultData),
        textInput("subset", "Subset Expression")
      ),
      uiOutput("pending"),
      dataTableOutput("output")
    )
  )


  # Server code for the gadget.
  server <- function(input, output, session) {

    reactiveData <- reactive({

      # Collect inputs.
      dataString <- input$data
      subsetString <- input$subset

      # Check to see if there is data called 'data',
      # and access it if possible.
      if (!nzchar(dataString))
        return(errorMessage("data", "No dataset available."))

      if (!exists(dataString, envir = .GlobalEnv))
        return(errorMessage("data", paste("No dataset named '", dataString, "' available.")))

      data <- get(dataString, envir = .GlobalEnv)

      if (!nzchar(subsetString))
        return(data)

      # Try evaluating the subset expression within the data.
      condition <- try(parse(text = subsetString)[[1]], silent = TRUE)
      if (inherits(condition, "try-error"))
        return(errorMessage("expression", paste("Failed to parse expression '", subsetString, "'.")))

      call <- as.call(list(
        as.name("subset.data.frame"),
        data,
        condition
      ))

      eval(call, envir = .GlobalEnv)
    })

    output$pending <- renderUI({
      data <- reactiveData()
      if (isErrorMessage(data))
        h4(style = "color: #AA7732;", data$message)
    })

    output$output <- renderDataTable({
      data <- reactiveData()
      if (isErrorMessage(data))
        return(NULL)
      data
    })

    # Listen for 'done'.
    observeEvent(input$done, {

      # Emit a subset call if a dataset has been specified.
      if (nzchar(input$data) && nzchar(input$subset)) {
        code <- paste("subset(", input$data, ", ", input$subset, ")", sep = "")
        rstudioapi::insertText(text = code)
      }

      invisible(stopApp())
    })
  }

  # Use a modal dialog as a viewr.
  viewer <- dialogViewer("Subset", width = 1000, height = 800)
  runGadget(ui, server, viewer = viewer)

}

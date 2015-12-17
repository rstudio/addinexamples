#' Subset a Data Frame.
#'
#' @export
subsetter <- function() {

  # Get the document context.
  context <- rstudioapi::getActiveDocumentContext()

  # Set the default data to use based on the selection.
  text <- context$selection[[1]]$text
  defaultData <- text

  # Generate UI for the gadget.
  ui <- gadgetPage(
    titlebar("Subset a data.frame"),
    contentPanel(
      stableColumnLayout(
        textInput("data", "Data", value = defaultData),
        textInput("row", "Row"),
        textInput("column", "Column")
      ),
      dataTableOutput("output")
    )
  )

  # Server code for the gadget.
  server <- function(input, output, session) {

    reactiveData <- reactive({

      # Collect inputs.
      dataString    <- input$data
      rowString <- input$row
      colString <- input$column

      # Check to see if there is data called 'data'.
      if (!nzchar(dataString))
        return("Please select a data set.")

      if (!exists(dataString, envir = .GlobalEnv))
        return()

      data <- get(dataString, envir = .GlobalEnv)

      rows <- if (nzchar(rowString))
        eval(parse(text = rowString), envir = data)
      else
        TRUE

      cols <- if (nzchar(colString))
        names(data) %in% strsplit(colString, "\\s+", perl = TRUE)[[1]]
      else
        names(data)

      call <- as.call(list(as.name("["), as.name(dataString), rows, cols))
      eval(call, envir = parent.frame())

    })

    output$output <- renderDataTable(
      reactiveData()
    )

    # Listen for 'done'.
    observeEvent(input$done, {

      # Parse the row term.
      rowTerm <- input$row

      # Parse the column term.
      colSplat <- unlist(strsplit(input$column, "\\s+", perl = TRUE))

      colInside <- gsub("\\s+", ", ", input$column, perl = TRUE)
      colTerm <- paste("c(", colInside, ")", sep = "")
      code <- paste(input$data, "[", rowTerm, ", ", colTerm, "]", sep = "")
      rstudioapi::insertText(text = code, id = context$id)
      invisible(stopApp())
    })
  }

  runGadget(ui, server)

}

mtcars[mpg > 21, c(mpg, cyl, disp)]
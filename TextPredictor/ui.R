library(shiny)

fluidPage(
    titlePanel("Text Predictor"),

    sidebarLayout(
        sidebarPanel(
            textInput("input_text",
                        "Enter some text:",
                        value = "Type here"),
            actionButton("predict", "Submit")
        ),

        mainPanel(
            h3("Predicted Next Word"),
            verbatimTextOutput("prediction")
        )
    )
)

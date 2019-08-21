library(shiny)
library(shinythemes)
library(quanteda)
library(data.table)
library(markdown)

shinyUI(navbarPage(theme=shinytheme("sandstone"),
                                    "Next Word Prediction App",
                   tabPanel("App",
                            sidebarLayout(
                                sidebarPanel(
                                    helpText("This app predicts the next word. English only please!"),
                                    textInput(inputId="inputText", label="Enter text here:"),
                                    submitButton(text="Let's do this!")
                                ),
                                mainPanel(
                                    h2(p("Predicted next word:")),
                                    h4(textOutput("prediction"))
                                )
                            )
                   ),
                   tabPanel("About",
                            mainPanel(
                                includeMarkdown("About.md")
                            )
                   )
)
)

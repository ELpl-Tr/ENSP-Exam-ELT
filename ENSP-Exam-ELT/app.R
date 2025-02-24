###Projet final###

library(shiny)
#install.packages("dplyr")
library(dplyr)
#install.packages("ggplot2")
library(ggplot2)
#install.packages("shinylive")
library(shinylive)
#install.packages("DT")
library(DT)
#install.packages("bslib")
library(bslib) #theme

# Define UI for application that draws a histogram
ui <- fluidPage(
    theme = bs_theme(version = 5, bootswatch = "minty"),
    
    titlePanel("Exploration des Diamants"),

    sidebarLayout(
        sidebarPanel(
            radioButtons(inputId = "rose", 
                       label = "Colorier les points en rose ?", 
                       choices = c("Oui" = T, 
                                   "Non" = F),
                       selected = T) ,
            selectInput(inputId = "filtrer", 
                        label = "Choisir une couleur à filtrer :", 
                        choices = sort(unique(diamonds$color)), 
                        selected = T),
            sliderInput("prix",
                        "Prix maximum :",
                        min = 300,
                        max = 20000,
                        value = 5000)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

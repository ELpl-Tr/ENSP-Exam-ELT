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
                        value = 5000),
            actionButton("notif", 
                         "Afficher une notification")
        ),

        mainPanel(
           plotOutput("nuage")
        )
    )
)


server <- function(input, output) {
    donnees <- reactive({
      subset(diamonds, 
             color == input$filtrer & 
               price <= input$prix)
    })

    output$nuage <- renderPlot({
      if (input$rose == T) {
        col_pts <- "pink"
      } else {
        col_pts <- "#4F4F4F"
      }
      
      ggplot(donnees(), aes(x = carat, y = price)) +
        geom_point(color = col_pts)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

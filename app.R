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
#install.packages("glue")
library(glue) #titre interactif

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
           plotOutput("nuage"),
           DTOutput(outputId = "tableau")
        )
    )
)


server <- function(input, output) {
    donnees <- reactive({
      subset(diamonds, 
             color == input$filtrer & 
               price <= input$prix)
    })

    #Nuage de points
    output$nuage <- renderPlot({
      if (input$rose == T) {
        col_pts <- "pink"
      } else {
        col_pts <- "#4F4F4F"
      }
      
      ggplot(donnees(), aes(x = carat, y = price)) +
        geom_point(color = col_pts) +
        labs(title = glue("prix: {input$prix} & color: {input$filtrer}")) +
        theme(
          plot.title = element_text(family = "Rockwell Light", color = "#4F4F4F"),
          axis.title.x = element_text(family = "Rockwell Light", color = "#4F4F4F"),
          axis.title.y = element_text(family = "Rockwell Light", color = "#4F4F4F"))
    })
    
    #Tableau
    output$tableau <- renderDT({
      datatable(donnees(), 
                options = list(pageLength = 10, 
                               scrollX = T))
    })
    
    #Notif
    observeEvent(input$notif, {
      showNotification(
        glue("prix: {input$prix} & color: {input$filtrer}"),
        duration = 5
      )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

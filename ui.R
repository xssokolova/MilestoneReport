#library(shiny)
#library(rsconnect)
shinyUI(fluidPage(
    
    titlePanel("Predict Next Word"),
    
                
                         sidebarLayout(
                             
                             sidebarPanel(
                                 textInput('userInput',label="Input your phrase here:"),
                                 br(),
                                 helpText("Note:",br(),
                                          "The following predicted word will show up automatically as you input.")),
                             
                             mainPanel(
                                 h4("Here are the top 10 predictions:"),
                                 tableOutput('guess')
                             )
                         )
             
                
                
 
    
))

    


    
        
            
            
            
                
    
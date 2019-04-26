#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(DT)

#Rstudio function ONLY, meant to set the working directory as the location of this file.
setwd(dirname(rstudioapi::getSourceEditorContext()$path))


#importing data and changing it to a data frame.
df <- read_csv('../cleanedData.csv')
df<-as.data.frame(df[-1])



#defining functions to use in shiny app.

#frequencies of nature by agency.
freq_dept <- function(sub = c("all","GCSD","GCF","ACO","EMS"),nn, nat = ""){
  if(sub == "all"){
    if (nat != ""){
      aa <- subset(callData1, callData1$nature == nat) %>%
        group_by(date = as.Date(start_time), nature) %>%
        summarize(freq = n())
    }else{
      aa <- callData1 %>%
        group_by(date = as.Date(start_time), nature) %>%
        summarize(freq = n())
    }
    
  } else{
    if(nat !=""){
      aa <- subset(callData1,callData1$agency == sub & callData1$nature == nat) %>%
        group_by(date = as.Date(start_time), nature) %>%
        summarize(freq = n())
    }else{
      aa <- subset(callData1,callData1$agency == sub) %>%
        group_by(date = as.Date(start_time), nature) %>%
        summarize(freq = n())
    }
  }
  
  return (aa[which(aa$freq > nn),])
}

# plotting frequencies by nature and agency
patterns<-function(sub = c("all","GCSD","GCF","ACO","EMS"),nn = "",max = 170){
  
  if (sub == "all"){
    if(nn != ""){
      allData <- callData1 %>%
        group_by(date = as.Date(start_time), desired = nature == nn) %>%
        summarise(frequency_received = n()) %>%
        filter(desired == TRUE)
    }
    else{
      allData <- callData1 %>%
        group_by(date = as.Date(start_time),desired = nature) %>%
        summarise(frequency_received = n())
    }
    
  } else{
    if(nn != ""){
      allData <- subset(callData1,callData1$agency == sub) %>%
        group_by(date = as.Date(start_time), desired = nature == nn) %>%
        summarise(frequency_received = n()) %>%
        filter(desired == TRUE)
    }
    else{
      allData <- subset(callData1,callData1$agency == sub) %>%
        group_by(date = as.Date(start_time), desired = nature) %>%
        summarise(frequency_received = n())
    }
    
  }
  
  allData <- as.data.frame(allData)
  
  ggplot(allData, aes(x = date, y= frequency_received), group_by(nature)) + geom_point() + ylim(0,max)
  
}



# # Define UI for application that draws a histogram
# ui <- fluidPage(
#    
#    # Application title
#    titlePanel("Guilford County Publich Safety"),
#    
#    # Sidebar with a slider input for number of bins 
#    sidebarLayout(
#       sidebarPanel(
#          sliderInput("bins",
#                      "Number of bins:",
#                      min = 1,
#                      max = 50,
#                      value = 30)
#       ),
#       
#       # Show a plot of the generated distribution
#       mainPanel(
#          plotOutput("distPlot")
#       )
#    )
# )


ui <- fluidPage(
  tabsetPanel(
    tabPanel("Records",
             tags$p("This is to look up a single record by incident ID"),
             wellPanel(numericInput(inputId = "n",label = "recordSearch",value =""),submitButton()),
             tableOutput("tableID")),
    tabPanel("Patterns",
             tags$p("Let's look at the different call frequencies"),
             radioButtons("radio", label = "Agency", 
                          c("ALL" = "all","GCSD" = "GCSD","GCF" = "GCF","ACO"= "ACO","EMS" = "EMS")),
             selectInput("selctInput", label = "Nature", choices = c("None" = ""), plotOutput("pats"))
    )
  )
              
)
  
  


# Define server logic required to draw a histogram
server <- function(input, output) {
   
   # output$distPlot <- renderPlot({
   #    # generate bins based on input$bins from ui.R
   #    x    <- faithful[, 2] 
   #    bins <- seq(min(x), max(x), length.out = input$bins + 1)
   #    
   #    # draw the histogram with the specified number of bins
   #    hist(x, breaks = bins, col = 'darkgray', border = 'white')
   # })
   
   output$tableID <- DT::renderDataTable(df[which(df$inci_id == input$n),])
   subs<- reactive({input$radio})
   nat<-reactive({input$selectInput})
   output$pats <- patterns(sub = subs, nn = nat)
}

# Run the application 
shinyApp(ui = ui, server = server)


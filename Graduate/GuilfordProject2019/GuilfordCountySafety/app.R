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
library(stringr)
library(plyr)
library(dplyr)
library(ggplot2)

#Rstudio function ONLY, meant to set the working directory as the location of this file.
setwd(dirname(rstudioapi::getSourceEditorContext()$path))


#importing data and changing it to a data frame.
df <- read_csv('../cleanedData.csv')
df<-as.data.frame(df[-1])



ui <- fluidPage(
  tabsetPanel(
    tabPanel("Records",tags$p("This is to look up a single record by incident ID"),
             sidebarLayout(
               sidebarPanel(
                 wellPanel(sliderInput("dur",label = "Duration:", 
                                       min = min(df$duration), 
                                       max = max(df$duration), 
                                       value = 10),
                 numericInput(inputId = "id",label = "Incident ID",value =2012324665),
                 radioButtons(inputId = "agency",label = "Agency",
                              choices = c("ALL","GCSD","GCF","ACO","EMS"),
                                          selected = "ALL"),
                 submitButton(text = "Search"))
                 ),
               
               mainPanel(dataTableOutput("table"))
               )
             ),
    
    tabPanel("Patterns",
             tags$p("Let's look at the different call frequencies"),
             radioButtons("radio", label = "Agency", 
                          c(ALL = "all",GCSD = "GCSD",GCF = "GCF",ACO = "ACO",EMS = "EMS"),
                          selected = "all"),
             selectizeInput("selectInput", label = "Nature", choices = c("None" = "",
                                                                     "TRAFFIC STOP" = "ts"), 
                         selected = "None",multiple = FALSE, plotOutput("pats"))
    )
  )
)
              

  
  


# Define server logic required to draw a histogram
server <- function(input, output) {
   
  #defining functions to use in shiny app.
  
  #frequencies of nature by agency.
  freq_dept <- function(sub = c("all","GCSD","GCF","ACO","EMS"),nn, nat = ""){
    if(sub == "all"){
      if (nat != ""){
        aa <- subset(df, df$nature == nat) %>%
          group_by(date = as.Date(start_time), nature) %>%
          summarize(freq = n())
      }else{
        aa <- df %>%
          group_by(date = as.Date(start_time), nature) %>%
          summarize(freq = n())
      }
      
    } else{
      if(nat !=""){
        aa <- subset(df,df$agency == sub & df$nature == nat) %>%
          group_by(date = as.Date(start_time), nature) %>%
          summarize(freq = n())
      }else{
        aa <- subset(df,df$agency == sub) %>%
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
        allData <- df %>%
          group_by(date = as.Date(start_time), desired = nature == nn) %>%
          summarise(frequency_received = n()) %>%
          filter(desired == TRUE)
      }
      else{
        allData <- df %>%
          group_by(date = as.Date(start_time),desired = nature) %>%
          summarise(frequency_received = n())
      }
      
    } else{
      if(nn != ""){
        allData <- subset(df,df$agency == sub) %>%
          group_by(date = as.Date(start_time), desired = nature == nn) %>%
          summarise(frequency_received = n()) %>%
          filter(desired == TRUE)
      }
      else{
        allData <- subset(df,df$agency == sub) %>%
          group_by(date = as.Date(start_time), desired = nature) %>%
          summarise(frequency_received = n())
      }
      
    }
    
    allData <- as.data.frame(allData)
    
    ggplot(allData, aes(x = date, y= frequency_received), group_by(nature)) + geom_point() + ylim(0,max)
    
  }
   
  final_df <- reactive( if (input$agency != "ALL"){df[df$inci_id == input$id & df$agency == input$agency,]} 
                        else {df[df$inci_id == input$id,]})
  
  output$table <- DT:: renderDataTable({final_df()})
  
  
  
     # subs<- reactive({as.list(input$radio)})
   # nat<-reactive({as.list(input$selectInput)})
   # output$pats <- patterns(sub = subs, nn = nat)
}

# Run the application 
shinyApp(ui = ui, server = server)

#2012324665
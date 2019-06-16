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


theList<-c("None" =" ",
  "911 UNKNOWN",
  "ABDOMINAL PAIN / PROBLEMS",
  "ACCIDENT HIT & RUN W/PI-REPORT",
  "ACCIDENT HIT AND RUN PERS INJ",
  "ACCIDENT HIT AND RUN PROP DAM",
  "ACCIDENT MCI LEVEL 1",
  "ACCIDENT PI W/TRACTOR TRAILER",
  "ACCIDENT W/ INJURY PIN IN",                                           
  "ACCIDENT W/INJURY-GPD REPORT",                                        
  "ACCIDENT WITH FIRE",                                                  
  "ACCIDENT WITH PERSONAL INJURY",                                       
  "ACCIDENT WITH PROPERTY DAMAGE",                                       
  "ACTIVE SHOOTER",                                                      
  "AIR ALERT 1 LARGE AIRCRAFT",                                          
  "AIR ALERT 1 SMALL AIRCRAFT",                                          
  "AIR ALERT 2 LARGE AIRCRAFT",                                          
  "AIR ALERT 2 SMALL AIRCRAFT",                                          
  "AIR ALERT 3 LARGE AIRCRAFT",                                          
  "AIR ALERT 3 SMALL AIRCRAFT",                                          
  "AIRCRAFT EMERGENCY",                                                  
  "ALLERGIES-HIVES-STINGS",                                              
  "ANIMAL BITES / ATTACKS",                                              
  "ANIMAL RELATED CALL",                                                 
  "ARMED SUBJECT",                                                       
  "ARSON INVESTIGATION",                                                 
  "ASSAULT (NO EMS NEEDED)",                                             
  "ASSAULT / RAPE",                                                      
  "ASSIST HP WITH MEDICAL",                                              
  "ASSIST PATIENT",                                                      
  "ATV",                                                                 
  "AUTO THEFT",                                                          
  "BACK PAIN (NON-TRAUMATIC)",                                           
  "BE ON THE LOOK OUT",                                                  
  "BOMB THREAT",                                                         
  "BREATHING PROBLEMS",                                                  
  "BUILDING  CHECK",                                                     
  "BURGLAR ALARM",                                                       
  "BURGLARY FROM A MOTOR VEHICLE",                                       
  "BURGLARY OF BUSINESS",                                                
  "BURGLARY OF RESIDENCE",                                               
  "BURNS-EXPLOSIONS",                                                    
  "C1-FOLLOW UP",                                                        
  "C10-MEAL",                                                            
  "C11-BREAK",                                                           
  "C12-PERSONAL",                                                        
  "C13-PTO ACTIVITY",                                                    
  "C14-TRAINING",                                                        
  "C15-COURT",                                                           
  "C16-GUARD DUTY",                                                      
  "C17-LEGAL PAPER/COMPLAINT",                                           
  "C18-COMMUNITY PROGRAM",                                               
  "C19-50B-GCSD ONLY",                                                   
  "C2-REPORT",                                                           
  "C20-SEX OFFENDER-GCSD ONLY",                                          
  "C21-PADLOCK-GCSD ONLY",                                               
  "C22-WARRANT-GCSD ONLY",                                               
  "C3-EVIDENCE",                                                         
  "C4-RECORDS",                                                          
  "C5-SPECIAL ASSIGNMENT",                                               
  "C6-EQUIP/VEHICLE",                                                    
  "C7-PREMISES CHECK",                                                   
  "C8-ADMINISTRATIVE",                                                   
  "C9-INTERAGENCY ASSIGNMENT",                                           
  "CARBON-MONOXIDE-INHALE-HAZMAT",                                       
  "CARBON MONOXIDE ALARM",                                               
  "CARDIAC / RESPIRATORY ARREST",                                        
  "CHECK WELFARE/ASSIST FAMILY",                                         
  "CHEST PAIN",                                                          
  "CHILD ENDANGERMENT CALLS",                                            
  "CHOKING",                                                             
  "CITIZEN ASSIST / SERVICE CALL",                                       
  "CITY COMMAND CENTER UNKNOWN",                                         
  "CIVIL-GCSD ONLY",                                                     
  "CODE VIOLATION",                                                      
  "CONFINED SPACE / STRUCTURE",                                          
  "CONVALESCENT TRANSPORT",                                              
  "CRIME SCENE INVESTIGATOR CALL",                                       
  "DEAD BODY INVESTIGATION",                                             
  "DEAD BODY TRANSPORT-PTAR ONLY",                                       
  "DIABETIC PROBLEMS",                                                   
  "DISCHARGE OF FIREARM",                                                
  "DISORDER FAMILY",                                                     
  "DISORDERLY SUBJECT OR CROWD",                                         
  "DOMESTIC DISPUTE",                                                    
  "DROWNING(NEAR) / DIVING ACCIDE",                                      
  "ELECTRICAL HAZARD",                                                   
  "ELECTROCUTION",                                                       
  "ELEVATOR/ESCALATOR",                                                  
  "EMERGENCY MGT RESPONSE",                                              
  "EMERGENCY OPERATIONS CENTER",                                         
  "EMS ASSISTANCE NEEDED",                                               
  "EMS MUTUAL AID OUT OF COUNTY",                                        
  "EMS RESPONSE - EMERGENCY",                                            
  "EMS RESPONSE - NON EMERGENCY",                                        
  "EMS TACTICAL CALL",                                                   
  "EMS TEST CALL",                                                       
  "ESCORT",                                                              
  "EXPLOSION",                                                           
  "EXTRICATION / ENTRAPPED",                                             
  "EYE PROBLEMS-INJURIES",                                               
  "FALLS-BACK INJURIES(TRAUMATIC)",                                      
  "FIGHT",                                                               
  "FIRE ALARM TESTING",                                                  
  "FIRE ASSISTANCE NEEDED",                                              
  "FIRE INSPECTION",                                                     
  "FIRE INVESTIGATION/FOLLOW UP",                                        
  "FIRE ONLY - MEDICAL ASSISTANCE",                                      
  "FIRE STAND BY - EMS",                                                 
  "FIRE TEST CALL",                                                      
  "FIREWORKS",                                                           
  "FOLLOW UP",                                                           
  "FOUND PROPERTY",                                                      
  "FRAUD",                                                               
  "FUEL SPILL",                                                          
  "FUNERAL ESCORTS",                                                     
  "GAS DRIVE-OFF",                                                       
  "GAS LEAK (NATURAL & LP)",                                             
  "GUARD DUTY / GUARD A PRISONER",                                       
  "HARASSMENT",                                                          
  "HAZMAT",                                                              
  "HAZMAT - FIRE ONLY",                                                  
  "HEADACHE",                                                            
  "HEART PROBLEMS",                                                      
  "HEAT / COLD EXPOSURE",                                                
  "HEMORRHAGE / LACERATIONS",                                            
  "HIGH ANGLE RESCUE",                                                   
  "HOSPICE TRANSPORT",                                                   
  "HOSTAGE SITUATION",                                                   
  "ILLEGAL BURN",                                                        
  "INACCESS INCIDENT- OTHER ENTRP",                                      
  "INDECENT CONDUCT / EXPOSURE",                                         
  "INTOXICATED SUBJECT",                                                 
  "JAIL ESCAPE",                                                         
  "KIDNAPPING",                                                          
  "LARCENY",                                                             
  "LARCENY - SHOPLIFTING",                                               
  "LAW ASSISTANCE NEEDED",                                               
  "LEGAL PAPER / COMPLAINT",                                             
  "LIGHTNING STRIKE (INVEST)",                                           
  "LIQUOR OR ALCOHOL VIOLATION",                                         
  "LOST PROPERTY",                                                       
  "MCI1- EMS ONLY",                                                      
  "MCI2 - EMS ONLY",                                                     
  "MENTAL SUBJECT/COMMIT SERV",                                          
  "MISCELLANEOUS",                                                       
  "MISSING PERSON OR RUNAWAY",                                           
  "MISUSE OF 911",                                                       
  "MUTUAL AID",                                                          
  "NARCOTICS VIOLATION",                                                 
  "NOISE DISTURBANCE OR PARTY",                                          
  "NON RESPONSIVE UNIT",                                                 
  "ODOR (STRANGE / UNKNOWN)",                                            
  "OTHER ALARMS / PANIC ALARMS",                                         
  "OTHER OTHER ALARMS / PANIC ALARMS / PANIC OTHER ALARMS / PANIC ALARMS",
  "OUTSIDE FIRE",                                                        
  "OVERDOSE-INGESTION-POISONING",                                        
  "PANHANDLER",                                                          
  "PARKING VIOLATIONS",                                                  
  "PAROLE / PROBATION",                                                  
  "PERSONAL MESSAGE",                                                    
  "PREGNANCY-CHILDBIRTH-MISCARRY",                                       
  "PRISONER TRANSPORT",                                                  
  "PROBLEM WITH JUVENILE",                                               
  "PROJECT LIFESAVER",                                                   
  "PROWLER",                                                             
  "PSYCH/ABNORMAL BEHAV/SUIC ATT",                                       
  "PURSUIT - VEHICLE OR SUBJECT",                                        
  "RAPE / SEXUAL ASSAULT - NO EMS",                                      
  "RECOVERED STOLEN PROPERTY",                                           
  "ROBBERY ALARM (BUSINESS ONLY)",                                       
  "ROBBERY OF BUSINESS",                                                 
  "ROBBERY OF PERSON",                                                   
  "SEIZURES-CONVULSIONS",                                                
  "SICK PERSON",                                                         
  "SMOKE INVESTIGATION",                                                 
  "SPECIAL ASSIGNMENT",                                                  
  "STAB / GUNSHOT WOUND",                                                
  "STAB/SHOT - NO EMS NEEDED",                                           
  "STREET FLOODING",                                                     
  "STROKE (CVA)",                                                        
  "STRUCTURE FIRE",                                                      
  "SUSPICIOUS ACTIVITY",                                                 
  "SUSPICIOUS SUBJECT",                                                  
  "SUSPICIOUS VEHICLE",                                                  
  "TEST CALL",                                                           
  "TEXT 911 UNKNOWN",                                                    
  "THREAT",                                                              
  "THREATENING SUICIDE",                                                 
  "TRAFFIC ASSISTANCE NEEDED",                                           
  "TRAFFIC HAZARD",                                                      
  "TRAFFIC SIGNAL OUT",                                                  
  "TRAFFIC STOP",                                                        
  "TRAIN / RAIL INCIDENT",                                               
  "TRAIN AND RAIL FIRE",                                                 
  "TRAINING AND CONTINUING ED",                                          
  "TRANSFER  INTERFACILITY",                                             
  "TRANSPORT ONLY- MED FACILITY",                                        
  "TRANSPORT TO ANIMAL SHELTER",                                         
  "TRASH DUMPING / ILLEGAL DUMPIN",                                      
  "TRAUMATIC INJURIES - SPECIFIC",                                       
  "TRESPASSER",                                                          
  "UNAUTHORIZED USE OF MOTOR VEH",                                       
  "UNCONSCIOUS-FAINTING",                                                
  "UNKNOWN PROBLEM PERSON DOWN",                                         
  "VANDALISM",                                                           
  "VEHICLE FIRE",                                                        
  "VICE",                                                                
  "WANTED WALK-IN",                                                      
  "WATER RESCUE",                                                        
  "WATERCRAFT IN DISTRESS",                                              
  "WEAPONS OF MASS DESTRUCTION",                                         
  "WRONG WAY",                                                           
  "ZABANDONED ANIMAL",                                                   
  "ZACOTEST",                                                            
  "ZALLOWED TO RUN AT LARGE",                                            
  "ZANIMAL ATTACK",                                                      
  "ZANIMAL BITE",                                                        
  "ZANIMAL FIGHT IN PROGRESS",                                           
  "ZASSIST",                                                             
  "ZBAT/RACCOON IN RESIDENCE",                                           
  "ZBITE FOLLOW UP",                                                     
  "ZBREEDER",                                                            
  "ZCHECK WELFARE",                                                      
  "ZCONFINED",                                                           
  "ZCRUELTY",                                                            
  "ZCRUELTY FOLLOW UP",                                                  
  "ZDANGEROUS / VICIOUS CALL",                                           
  "ZDANGEROUS / VICIOUS FOLLOW UP",                                      
  "ZDOG LOCKED IN VEHICLE",                                              
  "ZEXPOSURE",                                                           
  "ZFOLLOW UP",                                                          
  "ZHOME RABIES SHOTS",                                                  
  "ZINJURED ANIMAL",                                                     
  "ZMISTREATMENT",                                                       
  "ZMISTREATMENT FOLLOW UP",                                             
  "ZOTHER ANIMAL IN RESIDENCE",                                          
  "ZOWNER TRAP",                                                         
  "ZPICK UP TRAP",                                                       
  "ZPUBLIC NUISANCE",                                                    
  "ZPUBLIC NUISANCE FOLLOW UP",                                          
  "ZREPORTED ANIMAL BITE",                                               
  "ZRETURN TO OWNER",                                                    
  "ZRUNNING AT LARGE",                                                   
  "ZSERVING PAPERS",                                                     
  "ZSET A TRAP",                                                         
  "ZSHELTER",                                                            
  "ZSICK ANIMAL",                                                        
  "ZSURRENDER ANIMAL",                                                   
  "ZTETHERING CALL",                                                     
  "ZTETHERING FOLLOW UP",                                                
  "ZTRANSPORT FROM VET",                                                 
  "ZTRANSPORT TO VET",                                                   
  "ZTRAP",                                                               
  "ZVICIOUS ANIMAL",
  "ZVICIOUS DOG INVESTIGATION",
  "ZWELFARE CHECK FOLLOW UP"
  
)


ui <- fluidPage(
  tabsetPanel(
    tabPanel("Records",tags$p("This is to look up a single record by incident ID"),
             sidebarLayout(
               sidebarPanel(
                 wellPanel(
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
             sidebarLayout(
               sidebarPanel(radioButtons("radio", label = "Agency", 
                          c(ALL = "all",GCSD = "GCSD",GCF = "GCF",ACO = "ACO",EMS = "EMS"),
                          selected = "all"),
                          
                          selectizeInput("selectIN", label = "Nature", choices = theList,
                                         selected = " ",multiple = FALSE),
               submitButton(text = "Search")),
             mainPanel(plotOutput("pats")))
             ),
    
    tabPanel("Frequency", tags$p("Display frequency of each nature according to agency and date."),
             sidebarLayout(
               sidebarPanel(radioButtons("radioAg", label = "Agency",
                                      choices = c(ALL = "all",GCSD = "GCSD",GCF = "GCF",ACO = "ACO",EMS = "EMS"),
                                      selected = "all"),
                         selectizeInput("selectII", label = "Nature", choices = theList,
                                        selected = " ", 
                                        multiple = FALSE),
                         numericInput("numThres", label = "Threshold", value = 100,
                                      min = 0,
                                      max = 200,
                                      step = 1),
               submitButton(text = "Submit")),
               mainPanel(verbatimTextOutput("freqq"))
             )
    )
  )
)
                         
               
      
              

  
  


# Define server logic required to draw a histogram
server <- function(input, output) {
   
  #defining functions to use in shiny app.
  
  #frequencies of nature by agency.
  freq_dept <- function(sub = c("all","GCSD","GCF","ACO","EMS"),nn, nat = " "){
    if(sub == "all"){
      if (nat != " "){
        aa <- subset(df, df$nature == nat) %>%
          group_by(date = as.Date(start_time), nature) %>%
          summarize(freq = n())
      }else{
        aa <- df %>%
          group_by(date = as.Date(start_time), nature) %>%
          summarize(freq = n())
      }
      
    } else{
      if(nat !=" "){
        aa <- subset(df,df$agency == sub & df$nature == nat) %>%
          group_by(date = as.Date(start_time), nature) %>%
          summarize(freq = n())
      }else{
        aa <- subset(df,df$agency == sub) %>%
          group_by(date = as.Date(start_time), nature) %>%
          summarize(freq = n())
      }
    }
    
    return (print(aa[which(aa$freq > nn),], n = 1000))
  }
  
  # plotting frequencies by nature and agency
  patterns<-function(sub = c("all","GCSD","GCF","ACO","EMS"),nn = " ",max = 170){
    
    if (sub == "all"){
      if(nn != " "){
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
      if(nn != " "){
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
   
  
  
  
  
  final_df <- reactive( 
    if (input$id == 0){
      if (input$agency != "ALL"){
        df[df$agency == input$agency,]}
      else {
        df}
    }
    else {
      if (input$agency != "ALL"){
        df[df$inci_id == input$id & df$agency == input$agency,]}
      else {
        df[df$inci_id == input$id,]}
      }
    )
  
  
  #The acutal Outputs
  output$table <- DT:: renderDataTable({final_df()})
  
  theGraph<- reactive({patterns(sub = input$radio, nn = input$selectIN)})
  
  output$pats <- renderPlot(theGraph(), height = 400, width = 600)
  
  theResults <- reactive({freq_dept(sub = input$radioAg, nn = input$numThres, nat = input$selectII)})
  output$freqq <- renderPrint(theResults())
}

# Run the application 
shinyApp(ui = ui, server = server)
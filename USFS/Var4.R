#CONSTANTS
INCE4SoftwoodPlywood = (1000/32)*(35/2000)*(1/(1+.15))*(1+(1+.045))*1
INCE4OSBWaferboard = (1000/32)*(40/2000)*(1/(1+.15))*(1+(1+.035))*1
INCE4LaminatedVeneerLumber = (1000)*(35/2000)*(1/(1+.15))*(1+(1+.05))*1
INCE4HardwoodPlywoodAndVeneer = (1000/32)*(42/2000)*(1/(1+.15))*(1+(1+.05))*1
INCE4SoftwoodLumber = (60)*(31.9/2000)*(1/(1+.15))*(1+(1+0))*1
INCE4HardwoodLumber = (1000/12)*(36.6/2000)*(1/(1+.15))*(1+(1+0))*1
INCE4LumberMadeAtPalletPlants = (1000/12)*(36.6/2000)*(1/(1+.15))*(1+(1+0))*1
INCE4ParticaleBoardProduction = (1000/16)*(45/2000)*(1/(1+.15))*(1+(1+0.085))*1
INCE4HardBoardProduction = (1000/96)*(60/2000)*(1/(1+.15))*(1+(1+0))*1
INCE4MDFProduction = (1000/16)*(45/2000)*(1/(1+.05))*(1+(1+0.08))*1
INCE4PulpPaperAndBoard = (1/(1+.03))*1
INCE4Pulp = (1/(1+.1))*1
INCE4OtherIndustrialProducts = 1000*(34.3/2000)*(1/(1+.15))*(1/(1+0))*1
INCE4InsulationBoard = (1000/24)*(23.5/2000)*(1/(1+.15))*(1/(1+0))*1
INCE4Pulpwood = (81300)*(34.3/2000)*(1/(1+.15))*(1/(1+0))*1
INCE4InsulationBoardTON = .9*1
INCE4HardwoodVeneer = .2*(1/(1+.15))*1
INCE4SoftwoodRoundwood = 1000*(31.9/2000)*(1/(1+.15))*(1/(1+0))*1
INCE4HardwoodRoundwood = 1000*(36.6/2000)*(1/(1+.15))*(1/(1+0))*1


SolidWoodProducts = (.907185*.5)/(10^6)
PaperProducts = (.907185*.43)/(10^6)


#Main Equation

Variable4<- function(x){return(1000*((SolidWoodProducts*RoundwoodExports(year))*(SolidWoodProducts*SawnwoodExports(year))*
                                       (SolidWoodProducts*WoodBasedPanelExports(year))*(PaperProducts*PaperAndPaperboardExports(year))*
                                       (PaperProducts*TotalFibreFurnishExports(year))))}

#Parts of Main Equation

RoundwoodExports <- function(year){
  if(year < 1950){
    return(1000*((hair1963t2SoftWoodLogAndChipExport * INCE4SoftwoodRoundwood) + 
                   (hair1963t2HardWoodLogAndChipExport * INCE4HardwoodRoundwood)))}
  
  if(year < 1965){
    return(1000 * ((U5logexports * INCE4SoftwoodRoundwood) + (U5logexports * INCE4HardwoodRoundwood)))}
  
  if(year < 1990){
    return(1000 * ((H6aLogExports*INCE4SoftwoodRoundwood) + (H7aPlywoodAndVeneerExports * INCE4HardwoodRoundwood)
                   + ((H5aPulpwoodChipExports*INCE4SoftwoodRoundwood)*(154/(154+117))) 
                   + ((H5aPulpwoodChipsExport*INCE4HardwoodRoundwood)*(117/(154+117)))))}
  if(year < 2021){
    return(1000*((H6aLogExports * INCE4SoftwoodRoundwood) + (H7aPlywoodAndVeneerExports * INCE4HardwoodRoundwood)
                 + (H6aPulpwoodChipExports * INCE4SoftwoodRoundwood) + (H7aPulpwoodChipExports * INCE4HardwoodRoundwood)))}
  if(year < 2051){
    return(1000*((Exportt3HardRoundWoodEquivofLogAndChipExports * INCE4HardwoodRoundwood) 
                 + (Exportt3SoftRoundWoodEquivLogAndChipExports * INCE4SoftwoodRoundwood)))}
}




SawnwoodExports <- function(year){
  if (year < 1920){
    return(1000*(hair1958t14TotalExports * INCE4SoftwoodLumber))}
  
  if(year < 1965){
    return(1000*((U29SoftWoodExports * 1000 * INCE4SoftwoodLumber) + (U29HardWoodExports * 1000 * INCE4HardwoodLumber)))}
  
  if(year < 2021){
    return(1000*((H28SoftWoodExport * 1000 * INCE4SoftwoodLumber) + (H28HardWoodExport * 1000 * INCE4HardwoodLumber)))}
  
  if(year < 2051){
    return(1000*((Exportt1SoftWoodLumberExport * INCE4SoftwoodLumber) + (Exportt1HardWoodLumberExport * INCE4HardwoodLumber)))}
}



WoodBasedPanelExports <- function(x){1000*(())}



PaperAndPaperboardExports <- function(year){return(1000*((INCE4PulpPaperAndBoard*INCEPaperAndPaperBoardPaperAndBoardExports)))}



TotalFibreFurnishExports <- function(year){return(USAWoodPulpForPaperExports + RecoveredPaperExports + RecoveredFibrePulpExports)}





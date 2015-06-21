library(shiny)
shinyUI(pageWithSidebar(
        headerPanel('Sample Means of Exponential Distribution Simulation'),
        sidebarPanel(
                sliderInput("lambda","Lambda", value = 0.2, min = 0.1, 
                            max = 1.5 ,step=0.1),
                sliderInput("n", "Sample size:", value = 40, 
                            min = 1,max = 200),
                sliderInput("nsims", "Nº of simulations", value = 200, 
                            min = 1, max = 1000),
                hr(),
                HTML(paste("Theoretical densities color is ", tags$span(style="color:red", "red"), sep = ""))
                
        ),
        mainPanel(
                plotOutput('plot1')
        )
))


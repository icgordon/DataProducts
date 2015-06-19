library(shiny)

shinyUI(
    navbarPage("Monte Carlo Simulation of IQ Scores",
        tabPanel("Simulation",
             sidebarPanel(
                numericInput('iq', 'IQ', value=100, min=100, max=190, step=1),
                selectInput("samplesize", label="Sample Size", 
                    choices = list("100"=100,
                                   "1,000"=1000,
                                   "10,000"=10000,
                                   "100,000"=100000,
                                   '1,000,000'=1000000,
                                   '10,000,000'=10000000,
                                   '100,000,000'=100000000,
                                   '1,000,000,000'=1000000000)
                ),
                sliderInput('runs', 'Number of Runs', min=1, max=5, value=1),
    
                helpText("Enter the desired 'IQ' (between 100 and 190) and 'Sample Size', then press the 'Run Simulation' button. (Adjust the sample size so that the displayed expected number is >= 1.)",
                    "Run the simulation again to see how the result changes.",
                    br(), br(), "Increase the sample size and/or the number of runs to try to improve the accuracy.",
                    br(), br(), "Be careful with large sample sizes as the simulation can run for a long time."),
    
                actionButton('go', 'Run Simulation')
            ),
        mainPanel(
            tabsetPanel('Simulation',
            h4(textOutput('expected')),
            h4(textOutput("simulationresult"))
        )
    )),
    tabPanel("About",
         mainPanel(
             h3("About this Shiny app."),
             
             p("This app was written for the Coursera Delivering Data Products course.",
             "The idea is to let users compare the results of a Monte Carlo simulation with the expected",
             "outcome that was calculated using the probability of the event."),
             
             p("Enter the desired parameters (IQ score (between 100 and 190), sample size, and the number of runs).",
               "The expected value for this IQ score is then calculated and siaplayed. This",
               "will give the user something to compare. When the user presses the 'Run Simulation'",
               "button, a Monte Carlo simulation will be run, and the approximate answer will be",
               "displayed."),
             
             p("In Monte Carlo simulation, we select a sample of random numbers that conform to a desired",
               "criteria, in this case, a normal distribution with a mean of 100 and a standard deviation",
               "of 15. Then we simply count the number of random values that are greater than or equal to",
               "the specified IQ score. This will allow us to approximate the number of people in the",
               "general population with an IQ greater than or equal to the specified score."),
             
             p("For information about Monte Carlo simulation, check out "),
             
             a("https://en.wikipedia.org/wiki/Monte_Carlo_method"),
             hr()
               

         )    )
    )
)

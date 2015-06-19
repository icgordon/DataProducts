library(shiny)

# We process two events - changes to the value in the IQ textBox and the 'Run Simulation' button.
# Changes to the IQ box are handled immediately, while changes to the other controls are only
# handled when the button is pressed.

# In each case, the values are checked to ensure that the IQ number is within an allowable
# range (the sample size and number of runs are controlled by their respective controls
# and cannot go outside their defined range.).
#
# When the 'Run' button is pressed, a check is made to ensure that the selected sample
# size is sufficiently large enough for the simulation.

# Define constants
mu <- 100
sd <- 15
iq_lo = 100
iq_hi = 190

shinyServer(
    function (input, output) {
        output$expected <- renderText({
            validate(
                need(as.numeric(input$iq >= iq_lo) && as.numeric(input$iq <= iq_hi),
                     sprintf("IQ must be between %d and %d", iq_lo, iq_hi))
            )
            expected <- pnorm(as.numeric(input$iq), mean=mu, sd=sd, lower=F) * as.numeric(input$samplesize)
            paste("Expected number with this IQ or higher = ", expected)
        })

        
        output$simulationresult <- eventReactive(input$go, {
            validate(
                need(pnorm(as.numeric(input$iq), mean=mu, sd=sd, lower=F) * as.numeric(input$samplesize) >= 1.0,
                     "Sample size too low for this IQ. Please increase and run again.")
            )
            
            million <- 1000000 # Max sample size we can safely handle.
            
            # Get the user-entered values and convert from string.
            sampleSize <- as.numeric(input$samplesize)
            IQ <- as.numeric(input$iq)
            
            # To minimize the amount of memory being used, internally
            # we limit the size of each sample to 1 million values. If
            # the specified sample size is greater than 1 million, we
            # draw multiple sample of size 1 million (e.g. 100,000,000
            # would be 100 separate samples of size 1 million). 
            if (sampleSize > million) {
                numSamples <- sampleSize / million
                sampleSize <- million
            } else {
                numSamples <- 1
            }
            
            runs <- input$runs
            
            theSum <- 0 # The running sum of values in the desired IQ range.
            for (r in 1:runs) {
                for (i in 1:numSamples) {
                    sim <- rnorm(sampleSize, mean=mu, sd=sd)
                    # How many values in this sample were >= the specified IQ?
                    theSum <- theSum + sum(sim >= IQ)
                }
            }
            # Divide the running sum by the number of runs to
            # get the average. This is the value that will be
            # returned to the ui.
            theSum <- theSum / runs
            
            paste("Simulation result = ", theSum)
        })
})
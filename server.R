library(shiny)
library(ggplot2) # load ggplot
library(gridExtra)
means_df <- NULL
shinyServer(function(input, output, session) {
        data <- reactive({
                input$n
                input$lambda
                rexp(input$n,input$lambda)
        })
        # Reactive expression to update the list of means when the distribution changes
        doReset <- reactive({
                
                input$lambda
                input$n
                input$nsims            
                means_df<<-NULL
                print("reset")
        })     
        output$plot1 <- renderPlot({
                
                lambda <-input$lambda
                n<-input$n
                nsims<-input$nsims
                vsims<-1:input$nsims
                #doReset()
                
                means_df<-data.frame(x = sapply(vsims, function(x) {mean(rexp(n, lambda))}))
                means<-means_df$x
                theoretical_mean<-1/lambda
                sample_mean<-mean(means)
                theoretical_sd<-(1/lambda)/sqrt(n)
                sample_sd<-sd(means)
                
                sample_var<-var(means)
                theoretical_var<-theoretical_sd^2
                #Table os theorical and sample values of mean, sd and variance
                df<-data.frame(mean=c(sample_mean, theoretical_mean),
                               sd=c(sample_sd, theoretical_sd),
                               var=c(sample_var, theoretical_var))
                row.names(df)<-c("Sample", "Theoretical")
                df_round<-round(df,2)
                t1 <- tableGrob(df_round,show.rownames = TRUE,cols = c("Mean","SD","Variance"))
                
                #Plot one sample distribution
                sample<-data()
                labelxp1<-paste("Sample Exp(",n,",",lambda,")")
                p1<-ggplot(data.frame(x=sample), aes(x=x)) + geom_histogram(aes(y=..density..),binwidth=.5,colour="black",fill="white") +
                        geom_density(alpha=.2,fill="#FF6666")
                p1<-p1 + stat_function(fun = dexp, arg = list(rate=lambda),size = 1,colour="red") +
                        xlab(label = labelxp1) +
                        ylab(label="Frecuency/Density")
                
                # plot histogram and density of scaled means
                label1<-paste("Sample means Exponential(",n,",",input$lambda,")\n",nsims," simulations") 
                p2<-ggplot(means_df, aes(x=x)) + geom_histogram(aes(y=..density..),binwidth=.1,colour="black",fill="white") +
                        geom_density(alpha=.2,fill="#FF6666") +
                        stat_function(fun = dnorm, colour = "red", arg = list(mean = theoretical_mean,sd = theoretical_sd)) +
                        geom_vline(xintercept = theoretical_mean,colour="red",linetype="dotted",size = 1) +
                        geom_vline(xintercept = sample_mean,colour="blue",linetype="dashed",size = 1) +
                        xlab(label=label1) +
                        ylab(label="Frecuency/Density")
                         
                #Q-Q plot
                p3<-qplot(sample=means,stat="qq",main="Normal Q-Q plot")
                #Arrange and print graphics
                grid.arrange(t1,p1,p2,p3,nrow=2,ncol=2)
        })
        
})

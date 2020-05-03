#####################################################
## Loading required libraries
#####################################################

library(shiny)
library(shinydashboard)
library(ggplot2)
library(data.table)
library(colourpicker)
library(wordcloud2)
library(memoise)
library(tm)
library(tidyverse)
library(readr)
library(sqldf)

#####################################################
   ## Loading dataset and tidying columns
#####################################################

# Loading data set onto raw_pizza
raw_pizza <- read_csv("Datafiniti_Pizza_Restaurants_and_the_Pizza_They_Sell_May19.csv")

# Creating a copy of raw data set for tidying data.
pizza <- raw_pizza

# Select the sub dataset pizza dataset consisting of columns which is required for visualization
# purpose.

pizza_store_info <- pizza %>% 
  select(id, address, categories, primaryCategories, 
         city, keys, latitude, longitude, name, postalCode, 
         province, menus.name)

# Renaming one of the column in the dataset for more readability.
names(pizza_store_info)[names(pizza_store_info)=="menus.name"] <- "pizzaName"

##############################################################
## Defining the User Interface component of Shiny Dashboard
##############################################################

ui <- dashboardPage(
  dashboardHeader(title = "My dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Famous Pizza Cloud", tabName = "famousPizza", icon = icon("th")),
      menuItem("Pizza's sold", tabName= "pizzaSold", icon= icon("th"))
    )
  ),
  dashboardBody(
    
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              h2("Overview of Pizza Dataset"),
              fluidPage(
                sidebarLayout(
                  sidebarPanel(
                    selectInput("State", "State", choices = c("All", unique(pizza_store_info$province))),
                    selectizeInput("city", "City", choices = c("All", unique(pizza_store_info$city)))
                  ),
                  mainPanel(
                    tabsetPanel(
                      tabPanel(
                        title = "Table",
                        DT::dataTableOutput("pizza_info_table")
                      ),
                      tabPanel(
                        title = "Plot",
                        plotly::plotlyOutput("summary")
                      )
                    )
                    
                  )
                ))
      ),
      
      # Second tab content
      tabItem(tabName = "famousPizza",
              h2("Most common pizza's"),
              fluidPage(
                sidebarLayout(
                  sidebarPanel(
                    colourInput("col", "Background color", value = "white")
                  ),
                  mainPanel(width = 20, height = 30,
                            #Add the word cloud output placeholder to the UI
                            wordcloud2Output(outputId = "cloud")
                  )
                )
              )
      ),
      
      # Third tab content
      tabItem(tabName = "pizzaSold",
              h2("Most pizza's sold for every state"),
              fluidPage(
                sidebarLayout(
                  sidebarPanel(
                    textInput("title", "Title", "Common Pizza's Sold Across States"),
                    sliderInput("pizzaNum", "Top pizza's sold",
                                value = 10, min = 1, max = 50),
                  ),
                  mainPanel(
                    tabsetPanel(
                      tabPanel(
                        title = "Table",
                        DT::dataTableOutput("pizza_sold_table")
                      ),
                      tabPanel(
                        title = "Plot",
                        plotly::plotlyOutput("pizza_table_plot")
                      )
                    )
                  )
                )
              )
      )
      
    )
  ), skin = "yellow"
)

##############################################################
## Defining the Server component of Shiny Dashboard
##############################################################

server <- function(input,output,session) {
  
  # Creating the reactive component to filter data columns as required for calculation
  filtered_data <- reactive({
    data <- pizza_store_info %>%
      select(name, categories, address, city, province, postalCode)
    
    if (input$State != "All") {
      data <- subset(
        data,
        province == input$State
      )
    }
    
    if(input$city != "All") {
      data <- subset(
        data,
        city == input$city)
    }
    data
  })
  
  filtered_cities <- reactive({
    if(input$State != "All"){
      pizza_store_info %>%
        filter(province == input$State) %>%
        pull(city)
    }    
  })
  
  # Output for Rendering table
  output$pizza_info_table <- DT::renderDataTable({
    data <- filtered_data()
    data
  })
  
  # Observe function to dynamically update the City dropdown based on Selected State.
  observe({
    
    updateSelectizeInput(session, "city", choices = filtered_cities())
    
  })
  
  output$summary <- plotly::renderPlotly({
    pizza_store_count <- pizza_store_info %>% group_by(province) %>% summarise(num = n()) %>% filter(num > 200)
    pizza_store_count <- arrange(pizza_store_count, -num)
    
    ggplot(pizza_store_count[1:25,], aes( x = reorder(province,num), y = num, fill = province)) + 
      geom_histogram(stat="identity", position="identity") +
      xlab("State") + ylab("Count of Stores") + coord_flip()
  })
  
  # Output for Famous Pizza Cloud
  output$cloud <- renderWordcloud2({
    words.freq<-table(unlist(pizza_store_info$name));
    wordcloud2(words.freq, size = 1, backgroundColor = input$col, gridSize = 5)
  })
  
  most_ordered_menu <- sqldf("select pizzaName as Pizza, province as State , count(pizzaName) as Pizza_sold
                            from pizza_store_info
                            group by pizzaName, State
                            having count(pizzaName) > 1
                            order by count(pizzaName) desc")
  
  filtered_pizza_sold <- reactive({
    data <- most_ordered_menu[1:input$pizzaNum , ] 
  })
  
  output$pizza_sold_table <- DT::renderDataTable({
    data <- filtered_pizza_sold()
    data
  })
  
  
  output$pizza_table_plot <- plotly::renderPlotly({
    
    most_occurrence_menu <- sqldf("select pizzaName, count(pizzaName) as total_occurrence
                            from pizza_info
                            group by pizzaName
                            having total_occurrence > 75
                            order by total_occurrence desc")
    
    ggplot(most_occurrence_menu, aes(x = reorder(pizzaName,total_occurrence) , y = total_occurrence , fill = pizzaName)) +
      geom_col(position = "stack", stat = "identity", width = 0.5) +
      theme(axis.text.x = element_text(size =10,
                                       angle = 0,
                                       hjust = 1,
                                       vjust = 0)) +
      ggtitle(input$title) + coord_flip()+
      xlab("Names of Pizza") + ylab("Occurrences across US")
  })
  
}

shinyApp(ui, server)

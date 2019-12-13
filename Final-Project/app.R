library(shiny)
library(leaflet)

ui <- navbarPage("Final Project",
                 tabPanel("School Shootings in the United States",
                          fluidPage(
                            leafletOutput("map"),
                            p())),
                 tabPanel("About",
                          textOutput("text")
))

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(data = x) %>% addProviderTiles(providers$CartoDB.Positron) %>% 
      setView(lat = 39.8283, lng = -98.5795, zoom = 2) %>% 
      addCircleMarkers(
        radius = ~ifelse(x$casualties<=4, 2, 6),
        lng = ~long, lat = ~lat, 
        popup = ~paste0(
          "<div>",
          "<h3>",
          x$school_name,
          "</h3>",
          "Date: ",
          x$date,
          "<br>",
          "Casualties: ",
          x$casualties,
          "</div>"
        )
      )
  })
  
output$text <- renderText({
  "About: This visualization utilizes 2018 data sourced from the Washington Post, documenting
  instances of gun violence at primary or secondary schools in the United States since the 
  Columbine High massacre on April 20, 1999."
})}
shinyApp(ui, server)
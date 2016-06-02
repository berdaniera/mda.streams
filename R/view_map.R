#' Get and browse to a URL to the site location on Google Maps
#' or plot inline with Leaflet
#' 
#' @param site_names a list of site names such as those returned from 
#'   make_site_name()
#' @param browser logical. Should the URL be opened in a browser?
#' @import httr
#' @import leaflet
#' @importFrom stats setNames complete.cases
#' @export
#' @examples 
#' \dontrun{
#' cat(view_google_map("nwis_01484680"))
#' view_google_map(c("nwis_01467200","nwis_09327000","nwis_351111089512501"))
#' }
view_map <- function(site_names, browser=TRUE) {
  if(browser) { # view with Google Maps
    url <- view_google_map(site_names)
    return(url)
  } else { # view with leaflet
    coords <- get_site_coords(site_names, format="normal", attach.units = FALSE)
    m <- leaflet() %>% addTiles() %>%  # Add default OpenStreetMap map tiles
      addMarkers(lng=coords$lon, lat=coords$lat, popup=coords$site_name)
    m  # Print the map    
  }
}

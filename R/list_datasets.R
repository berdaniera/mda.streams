#' Get a vector of timeseries dataset names
#' 
#' list_datasets(site) returns the data available to a specific site. In 
#' contrast, \code{get_var_src_codes(out="var_src")} returns a list of all
#' possible variables.
#' 
#' @param site_name a character vector of length one with a site name such as 
#'   those returned from make_site_name()
#' @param data_type character. one or more dataset types to return
#' @inheritParams ts_has_file
#' @param limit integer. the maximum number of items to return
#' @return an alphabetically sorted character vector of unique timeseries 
#'   variable names (in var_src format)for given sites
#' @examples
#' \dontrun{
#' list_datasets(site_name = 'nwis_01021050')
#' }
#' @import sbtools
#' @importFrom stringr str_detect
#' @importFrom stats setNames
#' @import dplyr
#' @export
list_datasets = function(
  site_name, data_type=c("ts","watershed"), 
  with_ts_version='rds', with_ts_archived=FALSE, limit=10000) {
  
  # process args
  if(length(site_name) != 1) stop("expecting site_name to be a character vector of length 1")
  data_type <- match.arg(data_type, several.ok = TRUE)
  str_match_patterns <- c('ts' = pkg.env$ts_prefix, 'watershed' = 'watershed')[data_type] %>%
    as.character()
  if (missing(site_name)){
    stop("site_name required. looking for a list of possible dataset variables? try ?get_var_src_codes.")
  }
  
  # get list of site items, then filter to those of the proper data_type w/ str_match_patterns
  . <- '.dplyr.var'
  site_items <- query_item_identifier(scheme = get_scheme(), key = site_name, limit = 10000)
  if (length(site_items) == 0){ 
    stop('site ', site_name, ' does not exist')
  } else {
    item_titles <- sapply(site_items, function(item) item$title)
    site_items <- site_items[item_titles != site_name]
    item_titles <- item_titles[item_titles != site_name] # update item_titles to be parallel to site_items
  }
  if(length(site_items) > 0) {
    prefix_matches <- lapply(
      setNames(str_match_patterns,str_match_patterns), 
      function (x) str_detect(item_titles, pattern = x)) %>% as_data_frame()
    is_dataset <- prefix_matches %>% rowSums() > 0 # each row is 1 site_items$title; each col is a match for a different str_match_pattern
    is_ts <- unlist(unname(prefix_matches[,1]))
    
    # further filter by ts file criteria if appropriate
    if(sum(is_ts) > 0) {
      is_desired_ts <- is_ts
      is_desired_ts[is_ts] <- ts_has_file(site_items[is_ts], with_ts_version=with_ts_version, with_ts_archived=with_ts_archived)
      site_items <- site_items[!is_ts | is_desired_ts]
    }
      
    # create a vector of dataset names
    datasets <- 
      sapply(site_items, function(item) item$title) %>%
      ifelse(is_ts, parse_ts_name(.), .) %>%
      .[is_dataset] %>%
      unique() %>%
      sort()
    
  } else {
    datasets <- character(0)
  }
  
  return(datasets)
}


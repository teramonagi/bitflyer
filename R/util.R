request <- function(endpoint, ..., region = "")
{
  url <- paste0(URL_API_BITFLYER_V1, endpoint, "/", region)
  response <- httr::GET(url, query = list(...))
  httr::stop_for_status(response)
  httr::content(response, as="text")
}

make_request <- function(...)
{
  # e.g. bitflyer::get_markets (language)
  func_name <- as.list(sys.call(-1))[[1]]
  # e.g. bitflyer::get_markets (character)
  func_name <- as.character(func_name)
  # e.g. get_markets (character)
  func_name <- func_name[length(func_name)]
  # e.g. getmarkets (character)
  func_name <- stringr::str_replace_all(func_name, "_", "")
  request(func_name, ...)
}

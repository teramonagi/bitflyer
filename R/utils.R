get_from_env_or_global_env <- function(x)
{
  if(Sys.getenv(x) != ""){
    Sys.getenv(x)
  } else if(exists(x)){
    eval(parse(text = x), envir=.GlobalEnv)
  } else{
    NULL
  }
}

#' @noRd
calling_function_name <- function(level=-2)
{
  # e.g. bitflyer::get_markets (language)
  func_name <- as.list(sys.call(level))[[1]]
  # e.g. bitflyer::get_markets (character)
  func_name <- as.character(func_name)
  # e.g. get_markets (character)
  func_name <- func_name[length(func_name)]
  # e.g. getmarkets (character)
  stringr::str_replace_all(func_name, "_", "")
}

#' @noRd
build_path <- function(version, method, calling_function, region, query)
{
  if(length(query) >= 1 & method == "GET"){
    x <- purrr::imap(query, ~ paste0(.y, "=", .x))
    query <- paste0("?", purrr::reduce(x, ~ paste(.x, .y, sep = "&")))
  }
  region <- dplyr::if_else(region == "", "", paste0("/", region))
  paste0("/", version, "/", calling_function, region, query)
}

#' @noRd
build_url <- function(version, method, calling_function, region, query)
{
  path <- build_path(version, method, calling_function, region, query)
  paste0(BITFLYER_API_URL, path)
}

#' @noRd
check_region <- function(region) {
  region <- stringr::str_to_lower(region)
  japan <- c("", "jpn", "jp")
  usa <- c("usa", "us")
  euro <- c("eu", "euro")
  # Messy to use match.arg()
  # https://stackoverflow.com/questions/41441170/failure-of-match-arg-for-the-empty-string
  stopifnot(region %in% c(japan, usa, euro))
  for(country in list(japan, usa, euro)){
    if(region %in% country){
      return(country[1])
    }
  }
}

#' @noRd
stop_for_order_status <- function(status){
  ORDER_STATUSES <- c("COMPLETED", "CANCELED", "EXPIRED", "ACTIVE", "REJECTED")
  if(!is.null(status) && !(status %in% ORDER_STATUSES)){
    stop(sprintf("child_order_state must be one of %s", paste(ORDER_STATUSES, collapse = ", ")))
  }
}


#' @noRd
request <- function(method, url, ..., query = NULL, body = NULL)
{
  response <- if(method == "GET"){
    httr::GET(url, ..., query=query)
  } else{
    httr::POST(url, ..., body=body)
  }
  content <- httr::content(response, as="text")
  httr::stop_for_status(response, task = content)
  content
}

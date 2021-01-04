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

build_path <- function(version, method, calling_function, region, query)
{
  if(length(query) >= 1 & method == "GET"){
    x <- purrr::imap(query, ~ paste0(.y, "=", .x))
    query <- paste0("?", purrr::reduce(x, ~ paste(.x, .y, sep = "&")))
  }
  region <- dplyr::if_else(region == "", "", paste0("/", region))
  paste0("/", version, "/", calling_function, region, query)
}

build_url <- function(version, method, calling_function, region, query)
{
  path <- build_path(version, method, calling_function, region, query)
  paste0(BITFLYER_API_URL, path)
}

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

if(FALSE){
  get_balance()
  #send_child_order(product_code="BTC_JPY", child_order_type="LIMIT", side="BUY", price=699000, size=0.001)
  get_collateral()
  get_child_orders(product_code="BTC_USD")
  get_child_orders(product_code="BTC_JPY")
  get_collateral_accounts()
  get_ticker()
  get_ticker(product_code="BTC_USD")
  # Private get
  get_trading_commission(product_code="BTC_JPY")
  get_trading_commission(product_code="ETH_BTC")
  # Private
  get_permissions()
  get_balance()
  get_collateral()
  get_collateral_accounts()
  get_addresses()
  get_coinins()
  get_coinouts()
  get_bank_accounts()
  get_deposits()
  withdraw()
  getwithdrawals()
  #Public
  get_health()
  get_health(product_code="BTC_JPY")
  get_health(product_code="BCH_BTC")
  get_chats()
}

make_request_private_get <- function(){}
make_request_private_post <- function(){}

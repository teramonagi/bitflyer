#' @keywords internal
get_from_env_or_global_env <- function(x)
{
  if(Sys.getenv(x) != ""){
    Sys.getenv(x)
  } else if(exists(x)){
    eval(parse(text = x), envir=.GlobalEnv)
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

build_path <- function(version, method, calling_function, region, ...)
{
  query <- NULL
  dots <- list(...)
  if(length(dots) >= 1 & method == "GET"){
    x <- purrr::imap(dots, ~ paste0(.y, "=", .x))
    query <- paste0("?", purrr::reduce(x, ~ paste(.x, .y, sep="&")))
  }
  region <- dplyr::if_else(region == "", "", paste0("/", region))
  paste0("/", version, "/", calling_function, region, query)
}

build_url <- function(version, method, calling_function, region, ...)
{
  path <- build_path(version, method, calling_function, region, ...)
  paste0(BITFLYER_API_URL, path)
}

check_region <- function(region) {
  region <- stringr::str_to_lower(region)
  # Messy to use match.arg()
  # https://stackoverflow.com/questions/41441170/failure-of-match-arg-for-the-empty-string
  stopifnot(region %in% c("", "usa", "eu"))
  region
}

request_public <- function(..., region = "")
{
  region <- check_region(region)
  name <- calling_function_name(-2)
  url <- build_url("v1", "GET", name, region)
  request("GET", url, query=list(...))
}

make_request_private_get <- function(..., region = "")
{
  calling_function <- function_name()
  make_request_private(calling_function, "GET", ..., region = region)
}

make_request_private_post <- function(..., region = "")
{
  calling_function <- function_name()
  make_request_private(calling_function, "POST", ..., region = region)
}

make_request_private <- function(calling_function, method, ..., region = "")
{
  path <- build_path("v1/me", method, calling_function, region, ...)
  url <- build_url("v1/me", method, calling_function, region, ...)
  # unix time stamp
  timestamp <- as.numeric(Sys.time())
  # Create body
  if(method == "GET"){
    query <- list(...)
    body <- NULL
  } else{
    query <- NULL
    body <- jsonlite::toJSON(list(...), auto_unbox=TRUE)
  }
  # Sign
  object <- paste0(timestamp, method, path, body)
  sign <- digest::hmac(key=get_from_env_or_global_env("BITFLYER_SECRET"), object=object, algo="sha256", serialize=FALSE)
  # Create header
  header <- httr::add_headers(
    `ACCESS-KEY`=get_from_env_or_global_env("BITFLYER_KEY"),
    `ACCESS-TIMESTAMP`=timestamp,
    `ACCESS-SIGN`=sign,
    `Content-Type`="application/json"
  )
  request(method, url, header, query=query, body=body)
}

request <- function(method, url, ..., query=NULL, body=NULL)
{
  response <- if(method == "GET"){
    httr::GET(url, ..., query=query)
  } else{
    httr::POST(url, ..., body=body)
  }
  httr::stop_for_status(response)
  httr::content(response, as="text")
}

if(FALSE){
  get_health()
  get_markets()
  markets()
  markets(region="usa")
  board()
  get_ticker()
  ticker(product_code="BTC_USD")
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
  markets()
  markets(region="USA")
  markets(region="eu")
  get_markets()
  get_markets(region="EU")
  board()
  board(product_code="BTC_JPY")
  board(product_code="BCH_BTC")
  get_board()
  get_board(product_code="BTC_JPY")
  get_board(product_code="BCH_BTC")
  ticker()
  get_ticker()
  executions()
  get_executions()
  get_health()
  get_health(product_code="BTC_JPY")
  get_health(product_code="BCH_BTC")
  get_chats()

}


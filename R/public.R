#' @include manual-template.R utils.R
NULL

# Functions in this souce file
request_public_get <- function(..., region = "")
{
  region <- check_region(region)
  name <- calling_function_name(-2)
  query <- list(...)
  url <- build_url("v1", "GET", name, region, query)
  request("GET", url, query = query)
}

# hoge <- func_product_code
# is equqal to the following code:
# hoge <- function(product_code = "BTC_JPY"){
#     request_public_get(product_code = product_code)
# }
#' @inheritParams region
func_product_code <- function(product_code = "BTC_JPY"){
  request_public_get(product_code = product_code)
}

func_region <- function(region = "") {
  request_public_get(region = region)
}

#' Market List
#'
#' Get the list of market
#'
#' @inheritParams region
#' @examples
#' \dontrun{
#'   markets()
#'   markets(region = "us")
#' }
#' @export
markets <- func_region

#' Order Book
#'
#' Get order book
#'
#' @inheritParams product_code
#' @examples
#' \dontrun{
#'   board()
#'   board(product_code = "BTC_USD")
#' }
#' @export
board <- func_product_code

#' Ticker
#'
#' Get ticker
#'
#' @inheritParams product_code
#' @examples
#' \dontrun{
#'   ticker(product_code = "BTC_JPY")
#' }
#' @export
ticker <- func_product_code

#' Execution History
#'
#' Get Execution History
#'
#' @inheritParams  product_code
#' @inheritParams  count_before_after
#' @examples
#' \dontrun{
#'   executions()
#'   executions(product_code="BCH_BTC", count=3, before="303218244")
#' }
#' @export
executions <- function(product_code = "BTC_JPY", count = 100, before = 0, after = 0){
  request_public_get(
    product_code = product_code,
    count = count,
    before = before,
    after = after
  )
}

#' Orderbook status
#'
#' Get orderbook status
#'
#' @inheritParams product_code
#' @examples
#' \dontrun{
#'   get_board_state(product_code = "BTC_JPY")
#' }
#'
#' @return status: one of the following levels will be displayed
#'   \itemize{
#'     \item NORMAL: The exchange is operating.
#'     \item BUSY: The exchange is experiencing high traffic.
#'     \item VERY BUSY: The exchange is experiencing very heavy traffic.
#'     \item SUPER BUSY: The exchange is experiencing extremely heavy traffic. There is a possibility that orders will fail or be processed after a delay.
#'     \item STOP: The exchange has been stopped. Orders will not be accepted.
#'  }
#'
#' @export
get_board_state <- func_product_code

#' Exchange status
#'
#' Get the current status of the exchange.
#'
#' @inheritParams product_code
#' @return
#'   One of the following levels
#'   \itemize{
#'     \item NORMAL: The exchange is operating.
#'     \item BUSY: The exchange is experiencing high traffic.
#'     \item VERY BUSY: The exchange is experiencing heavy traffic.
#'     \item SUPER BUSY: The exchange is experiencing extremely heavy traffic.
#'      There is a possibility that orders will fail or be processed after a delay.
#'     \item STOP: The exchange has been stopped. Orders will not be accepted.
#'   }
#' @examples
#' \dontrun{
#'   get_health()
#' }
#' @export
get_health <- func_product_code

#' Chat
#'
#' Get the history of chats
#'
#' @param from_date string (e.g. 2018-06-30).
#'   The function returns new messages after this date.
#' @examples
#' \dontrun{
#'   get_chats(from_date="2018-07-19")
#' }
#' @export
get_chats <- function(from_date){
  request_public_get(from_date = from_date)
}


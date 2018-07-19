#' @include manual-template.R util.R
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
#' @export
markets <- func_region

#' @rdname markets
#' @export
get_markets <- func_region

#' Order Book
#'
#' Get order book
#'
#' @rdname board
#' @inheritParams product_code
#' @export
board <- func_product_code

#' @rdname board
#' @export
get_board <- func_product_code

#' Ticker
#'
#' Get ticker
#'
#' @inheritParams product_code
#' @export
ticker <- func_product_code

#' @rdname ticker
#' @export
get_ticker <- func_product_code

#' Execution History
#'
#' Get Execution History
#'
#' @inheritParams  product_code
#' @inheritParams  count_before_after
#' @note
#' API endpoint \code{/v1/getexecutions} is not implemented because there is the same name endpoint in private API
#' @export
executions <- function(product_code = "BTC_JPY", count = 100, before = NA, after = NA){
  request_public_get(
    product_code = product_code,
    count = count,
    before = before,
    after = after
  )
}

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
#' get_health()
#' }
#' @export
get_health <- func_product_code

#' Chat
#'
#' Get the history of chats
#'
#' @param from_date string (e.g. 2018-06-30).
#'   The function returns new messages after this date.
#' @export
get_chats <- function(from_date){
  request_public_get(from_date = from_date)
}

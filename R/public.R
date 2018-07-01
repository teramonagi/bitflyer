#' @include util.R

#' Market List
#'
#' Get the list of market
#'
#' @export
markets <- function(...){make_request(...)}
#' @rdname markets
#' @export
get_markets <- function(...){make_request(...)}

#' Order Book
#'
#' Get order book
#'
#' @export
board <- function(...){make_request(...)}
#' @rdname board
#' @export
get_board <- function(...){make_request(...)}

#' Order Book
#'
#' Get order book
#'
#' @export
ticker <- function(...){make_request(...)}
#' @rdname ticker
#' @export
get_ticker <- function(...){make_request(...)}


#' Execution History
#'
#' Get Execution History
#'
#' @export
executions  <- function(...){make_request(...)}
#' @rdname executions
#' @export
get_executions <- function(...){make_request(...)}

#' Order Book
#'
#' Get order book
#'
#' @export
get_boardstate  <- function(...){make_request(...)}

#' Exchange status
#'
#' Get the current status of the exchange.
#'
#' @param product_code A product_code or alias, as obtained from `markets()`. Default: "BTC_JPY".
#' @return
#'  String. one of the following levels
#'    NORMAL: The exchange is operating.
#'    BUSY: The exchange is experiencing high traffic.
#'    VERY BUSY: The exchange is experiencing heavy traffic.
#'    SUPER BUSY: The exchange is experiencing extremely heavy traffic. There is a possibility that orders will fail or be processed after a delay.
#'    STOP: The exchange has been stopped. Orders will not be accepted.
#' @examples
#' \dontrun{
#' get_health()
#' }
#'
#' @export
get_health <- function(...){make_request(...)}

#' Chat
#'
#' Get the history of chats
#'
#' @param from_date string (e.g. 2018-06-30). This function wil return any new messages after this date.
#'
#' @export
get_chats  <- function(...){make_request(...)}


#' @param count: Specifies the number of results. If this is omitted, the value will be 100.
#' @param before: Obtains data having an id lower than the value specified for this parameter.
#' @param after: Obtains data having an id higher than the value specified for this parameter.
#' @param product_code A product_code or alias, as obtained from `markets()`. Default: "BTC_JPY".

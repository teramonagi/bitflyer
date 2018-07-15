#' @include manual-template.R util.R
NULL

# Functions in this souce file
request_private_get <- function(..., region = "")
{
  calling_function <- calling_function_name(-2)
  query <- list(...)
  request_private(calling_function, "GET", query = query, region = region)
}

request_private_post <- function(..., region = "")
{
  calling_function <- calling_function_name(-2)
  body <- jsonlite::toJSON(list(...), auto_unbox=TRUE)
  request_private(calling_function, "POST", body = body, region = region)
}

request_private <- function(calling_function, method, query = NULL, body = NULL, region = "") {
  region <- check_region(region)
  path <- build_path("v1/me", method, calling_function, region, query)
  url <- build_url("v1/me", method, calling_function, region, query)
  # unix time stamp
  timestamp <- as.numeric(Sys.time())
  # Sign
  text <- paste0(timestamp, method, path, body)
  sign <- digest::hmac(key=get_from_env_or_global_env("BITFLYER_SECRET"), object=text, algo="sha256", serialize=FALSE)
  header <- httr::add_headers(
    `ACCESS-KEY`=get_from_env_or_global_env("BITFLYER_KEY"),
    `ACCESS-TIMESTAMP`=timestamp,
    `ACCESS-SIGN`=sign,
    `Content-Type`="application/json"
  )
  # Create header
  request(method, url, header, query=query, body=body)
}

#' @title Params No argumet
#' @name no_argument_private_get
#' @keywords internal
func_no_argument_private_get <- function() {
  request_private_get()
}

#' Get API Key Permissions
#'
#' Access a list of which HTTP Private APIs can be used with the specified API key
#' @export
get_permissions <- func_no_argument_private_get

#' Get Account Asset Balance
#'
#' Get Account Asset Balance
#' @export
get_balance <- func_no_argument_private_get

#' Get Margin Status
#'
#' Get Margin Status
#' @export
get_collateral <- func_no_argument_private_get

#' Get Margin Status
#'
#' Get Margin Status
#' @export
get_collateral_accounts <- func_no_argument_private_get

#' Get Bitcoin/Ethereum Deposit Addresses
#'
#' Get Bitcoin/Ethereum Deposit Addresses
#' @export
get_addresses <- func_no_argument_private_get

#' Get Bitcoin/Ether Deposit History
#'
#' Get Bitcoin/Ether Deposit History
#' @export
get_coinins <- func_no_argument_private_get

#' Get Bitcoin/Ether Transaction History
#'
#' Get Bitcoin/Ether Transaction History
#' @export
get_coinouts <- func_no_argument_private_get

#' Get Summary of Bank Accounts
#'
#' Returns a summary of bank accounts registered to your account.
#' @export
get_bank_accounts <- func_no_argument_private_get

#' Get Cash Deposits
#'
#' Get Cash Deposits
#' @export
get_deposits <- func_no_argument_private_get

#' Withdrawing Funds
#'
#' Withdrawing Funds
#' @param currency_code Currently only compatible with "JPY" for Japanese accounts,
#'   "USD" for U.S. accounts, and "EUR" for European accounts.
#' @param bank_account_id ID of the bank account.
#' @param amount This is the amount that you are canceling.
#' @export
withdraw <- function(currency_code, bank_account_id, amount) {
  request_private_post(currency_code = currency_code, bank_account_id = bank_account_id, amount = amount)
}

#' Get Deposit Cancellation History
#'
#' Get Deposit Cancellation History
#' @export
get_withdrawals <- func_no_argument_private_get

#' Send a New Order
#'
#' Send a New Order
#'
#' @param product_code The product being ordered. Please specify a product_code or alias, as obtained from the Market List.
#'   Only "BTC_USD" is available for U.S. accounts, and only "BTC_EUR" is available for European accounts.
#' @param child_order_type For limit orders, it will be "LIMIT". For market orders, "MARKET".
#' @param side For buy orders, "BUY". For sell orders, "SELL".
#' @param price Specify the price. This is a required value if child_order_type has been set to "LIMIT".
#' @param size Specify the order quantity.
#' @param minute_to_expire Specify the time in minutes until the expiration time.
#'   If omitted, the value will be 43200 (30 days).
#' @param time_in_force Specify any of the following execution conditions - "GTC", "IOC", or "FOK".
#'   If omitted, the value defaults to "GTC".
#' @export
send_child_order <- function(product_code, child_order_type, side, price, size, minute_to_expire = 43200, time_in_force = "GTC") {
  request_private_post(
    product_code = product_code,
    child_order_type = child_order_type,
    side = side,
    price = price,
    size = size,
    minute_to_expire = minute_to_expire,
    time_in_force = time_in_force
  )
}

#' Cancel Order
#'
#' Cancel Order
#' @param product_code Required. The product for the corresponding order. Please specify a product_code or alias, as obtained from the Market List. Only "BTC_USD" is available for U.S. accounts, and only "BTC_EUR" is available for European accounts.
#' @param child_order_id ID for the canceling order.
#' @param child_order_acceptance_id Expects an ID from Send a New Order. When specified, the corresponding order will be cancelled.
#' @export
cancel_child_order <- send_child_order <- function(product_code, child_order_type, side, price, size, minute_to_expire = 43200, time_in_force = "GTC") {
  request_private_post(
    product_code = product_code,
    child_order_id = child_order_id,
    child_order_acceptance_id = child_order_acceptance_id
  )
}

#' Submit New Parent Order (Special order)
#'
#' It is possible to place orders including logic other than simple limit orders (LIMIT)
#' and market orders (MARKET). Such orders are handled as parent orders.
#' By using a special order, it is possible to place orders in response to market conditions or place multiple associated orders.
#' Please read about the types of special orders and their methods in [the bitFlyer Lightning documentation on special orders](https://lightning.bitflyer.com/docs/specialorder).
#' @export
send_parent_order <- make_request_private_post

#' @export
cancel_parent_order <- make_request_private_post

#' @export
cancel_all_childorders <- make_request_private_post

#' List Orders
#'
#' List Orders
#' @param product_code Please specify a product_code or alias, as obtained from the Market List. Only "BTC_USD" is available for U.S. accounts, and only "BTC_EUR" is available for European accounts.
#' @param count, before, after: See Pagination.
#' @param child_order_state When specified, return only orders that match the specified value.
#' You must specify one of the following:
#' ACTIVE: Return open order
#' COMPLETED: Return fully completed orders
#' CANCELED: Return orders that have been cancelled by the customer
#' EXPIRED: Return order that have been cancelled due to expiry
#' REJECTED: Return failed orders
#' @param child_order_id
#' @param child_order_acceptance_id ID for the child order.
#' @param parent_order_id If specified, a list of all orders associated with the parent order is obtained.
#' @export
get_child_orders <- make_request_private_get

#' List Parent Orders
#'
#' List Parent Orders
#'
#' @param product_code A product_code or alias, as obtained from the Market List.
#'   Only "BTC_USD" is available for U.S. accounts,
#'   and only "BTC_EUR" is available for European accounts.
#' @param child_order_state When specified, return only orders that match the specified value.
#'   You must specify one of the following:
#'   ACTIVE: Return open orders
#'   COMPLETED: Return fully completed orders
#'   CANCELED: Return orders that have been cancelled by the customer
#'   EXPIRED: Return order that have been cancelled due to expiry
#'   REJECTED: Return failed orders
#' @export
get_parent_orders <- make_request_private_get

#' Get Parent Order Details
#'
#' Get Parent Order Details
#' @param parent_order_id The ID of the parent order in question.
#' @param parent_order_acceptance_id The acceptance ID for the API to place a new parent order.
#'   If specified, it returns the details of the parent order in question.
#' @export
get_parent_order <- make_request_private_get

#' Get Open Interest Summary
#'
#' Get Open Interest Summary
#' @param product_code Currently supports only "FX_BTC_JPY".
#' @export
get_positions <- make_request_private_get

#' Get Margin Change History
#'
#' Get Margin Change History
#'
#' @param count Specifies the number of results. If this is omitted, the value will be 100.
#' @param before Obtains data having an id lower than the value specified for this parameter.
#' @param after Obtains data having an id higher than the value specified for this parameter.
#' @export
get_collateral_history <- make_request_private_get

#' Get Trading Commission
#'
#' Get Trading Commission
#'
#' @param product_code A product_code or alias, as obtained from the Market List.
#'   Only "BTC_USD" is available for U.S. accounts,
#'   and only "BTC_EUR" is available for European accounts.
#' @export
get_trading_commission <- make_request_private_get

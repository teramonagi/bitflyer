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
  request(method, url, header, query = query, body = body)
}

func_no_argument_private_get <- function() {
  request_private_get()
}

func_product_code_private_get <- function(product_code) {
  request_private_get(product_code = product_code)
}

func_count_before_after_private_get <- function(count = 100, before = NA, after = NA){
  request_private_get(count = count, before = before, after = after)
}

#' Get API Key Permissions
#'
#' Access a list of which HTTP Private APIs can be used with the specified API key
#'
#' @export
get_permissions <- func_no_argument_private_get

#' Get Account Asset Balance
#'
#' Get Account Asset Balance
#'
#' @export
get_balance <- func_no_argument_private_get

#' Get Margin Status
#'
#' Get Margin Status
#'
#' @export
get_collateral <- func_no_argument_private_get

#' Get Margin Status
#'
#' Get details of your collateral balances (multiple currencies supported).
#' @export
get_collateral_accounts <- func_no_argument_private_get

#' Get Bitcoin/Ethereum Deposit Addresses
#'
#' Get Bitcoin/Ethereum Deposit Addresses
#'
#' @export
get_addresses <- func_no_argument_private_get

#' Get Bitcoin/Ether Deposit History
#'
#' Get Bitcoin/Ether Deposit History
#'
#' @inheritParams  count_before_after
#' @export
get_coin_ins <- func_count_before_after_private_get

#' Get Bitcoin/Ether Transaction History
#'
#' Get Bitcoin/Ether Transaction History
#'
#' @inheritParams  count_before_after
#' @export
get_coin_outs <- func_count_before_after_private_get

#' Get Summary of Bank Accounts
#'
#' Returns a summary of bank accounts registered to your account.
#'
#' @export
get_bank_accounts <- func_no_argument_private_get

#' Get Cash Deposits
#'
#' Get Cash Deposits
#' @inheritParams  count_before_after
#' @export
get_deposits <- func_count_before_after_private_get

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
#'
#' @inheritParams  count_before_after
#' @export
get_withdrawals <- func_count_before_after_private_get

#' Send a New Order
#'
#' Send a New Order
#'
#' @inheritParams product_code
#' @param child_order_type For limit orders, it will be "LIMIT". For market orders, "MARKET".
#' @param side For buy orders, "BUY". For sell orders, "SELL".
#' @param price Specify the price. This is a required value if child_order_type has been set to "LIMIT".
#' @param size Specify the order quantity.
#' @param minute_to_expire Specify the time in minutes until the expiration time.
#'   If omitted, the value will be 43200 (30 days).
#' @param time_in_force Specify any of the following execution conditions - "GTC", "IOC", or "FOK".
#'   If omitted, the value defaults to "GTC".
#'
#' @return child_order_acceptance_id.
#'   To specify the order to return, please use this instead of child_order_id.
#'   Please confirm the item is either Cancel Order or Obtain Execution List.
#'
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
#'
#' @inheritParams product_code
#' @inheritParams child_order_id
#' @inheritParams child_order_acceptance_id
#' @export
cancel_child_order <- function(product_code, child_order_id, child_order_acceptance_id) {
  request_private_post(
    product_code = product_code,
    child_order_id = child_order_id,
    child_order_acceptance_id = child_order_acceptance_id
  )
}

#' Submit New Parent Order (Special order)
#'
#' Submit New Parent Order (Special order)
#'
#' @details
#' It is possible to place orders including logic other than simple limit orders (LIMIT)
#' and market orders (MARKET). Such orders are handled as parent orders.
#' By using a special order, it is possible to place orders in response to market conditions or place multiple associated orders.
#'
#' Please read about the types of special orders and their methods in the bitFlyer Lightning documentation on special orders:
#' \url{https://lightning.bitflyer.com/docs/specialorder}.
#'
#' @param order_method The order method. Please set it to one of the following values. If omitted, the value defaults to "SIMPLE".
#'   \itemize{
#'     \item "SIMPLE": A special order whereby one order is placed.
#'     \item "IFD": Conducts an IFD order. In this method, you place two orders at once, and when the first order is completed, the second order is automatically placed.
#'     \item "OCO": Conducts an OCO order. In this method, you place two orders at one, and when one of the orders is completed, the other order is automatically canceled.
#'     \item "IFDOCO": Conducts an IFD-OCO order. In this method, once the first order is completed, an OCO order is automatically placed.
#'   }
#' @param minute_to_expire Specifies the time until the order expires in minutes. If omitted, the value defaults to 43200 (30 days).
#' @param time_in_force Specify any of the following execution conditions - "GTC", "IOC", or "FOK". If omitted, the value defaults to "GTC".
#' @param parameters This is an array that specifies the parameters of the order to be placed.
#'   The required length of the array varies depending upon the specified order_method.
#'   If "SIMPLE" has been specified, specify one parameter.
#'   If "IFD" has been specified, specify two parameters. The first parameter is the parameter for the first order placed. The second parameter is the parameter for the order to be placed after the first order is completed.
#'   If "OCO" has been specified, specify two parameters. Two orders are placed simultaneously based on these parameters.
#'   If "IFDOCO" has been specified, specify three parameters. The first parameter is the parameter for the first order placed. After the order is complete, an OCO order is placed with the second and third parameters.
#'   In the parameters, specify an array of objects with the following keys and values.
#' @inheritParams product_code
#' @param condition_type This is the execution condition for the order. Please set it to one of the following values.
#'   \itemize{
#'     \item "LIMIT": Limit order.
#'     \item "MARKET": Market order.
#'     \item "STOP": Stop order.
#'     \item "STOP_LIMIT": Stop-limit order.
#'     \item "TRAIL": Trailing stop order.
#'  }
#' @param side For buying orders, specify "BUY", for selling orders, specify "SELL".
#' @param size Specify the order quantity.
#' @param price Specify the price. This is a required value if condition_type has been set to "LIMIT" or "STOP_LIMIT".
#' @param trigger_price Specify the trigger price for a stop order. This is a required value if condition_type has been set to "STOP" or "STOP_LIMIT".
#' @param offset Specify the trail width of a trailing stop order as a positive integer. This is a required value if condition_type has been set to "TRAIL".
#'
#' @export
send_parent_order <- function(order_method, minute_to_expire, time_in_force, parameters, product_code, condition_type, side, size, price, trigger_price, offset) {
  request_private_post(
    order_method = order_method,
    minute_to_expire = minute_to_expire,
    time_in_force = time_in_force,
    parameters = parameters,
    product_code = product_code,
    condition_type = condition_type,
    side = side,
    size = size,
    price = price,
    trigger_price = trigger_price,
    offset = offset
  )
}

#' Cancel parent order
#'
#' Parent orders can be canceled in the same manner as regular orders.
#' If a parent order is canceled, the placed orders associated with that order will all be canceled.
#'
#' @inheritParams product_code
#' @inheritParams parent_order_id
#' @inheritParams parent_order_acceptance_id
#' @details
#' When \code{parent_order_acceptance_id} is specified, the corresponding order will be cancelled.
#' @export
cancel_parent_order <- make_request_private_post

#' Cancel All Orders
#'
#' Cancel All Orders
#'
#' @inheritParams product_code
#' @export
cancel_all_childorders <- func_product_code_private_get

#' List Orders
#'
#' List Orders
#'
#' @inheritParams product_code
#' @inheritParams count_before_after
#' @inheritParams child_order_state
#' @inheritParams child_order_id
#' @inheritParams child_order_acceptance_id
#' @inheritParams parent_order_id
#' @details
#' If \code{parent_order_id} is specified, a list of all orders associated with the parent order is obtained.
#' @export
get_child_orders <- function(product_code, count = 100, before = NA, after = NA, child_order_state, child_order_id, child_order_acceptance_id, parent_order_id){
    request_private_get(
      product_code = product_code,
      count = count,
      before = before,
      after = after,
      child_order_state = child_order_state,
      child_order_id = child_order_id,
      child_order_acceptance_id = child_order_acceptance_id,
      parent_order_id = parent_order_id
    )
}

#' List Parent Orders
#'
#' List Parent Orders
#'
#' @inheritParams product_code
#' @inheritParams count_before_after
#' @inheritParams child_order_state
#' @export
get_parent_orders <- function(product_code, count = 100, before = NA, after = NA, child_order_state){
  request_private_get(
    product_code = product_code,
    count = count,
    before = before,
    after = after,
    child_order_state = child_order_state
  )
}

#' Get Parent Order Details
#'
#' Get Parent Order Details
#'
#' @inheritParams parent_order_id
#' @inheritParams parent_order_acceptance_id
#' @details
#' If \code{parent_order_acceptance_id} is specified, it returns the details of the parent order in question.
#' @export
get_parent_order <- function(parent_order_id, parent_order_acceptance_id){
    request_private_get(
      parent_order_id = parent_order_id,
      parent_order_acceptance_id = parent_order_acceptance_id
    )
}

#' List Executions
#'
#' List Executions
#'
#' @inheritParams product_code
#' @inheritParams count_before_after
#' @inheritParams child_order_id
#' @inheritParams child_order_acceptance_id
#' @details
#' When \code{child_order_id} is specified, a list of stipulations related to the order will be displayed.
#' When \code{child_order_acceptance_id} is specified, a list of stipulations related to the corresponding order will be displayed.
#' @export
get_executions <- function(product_code, count = 100, before = NA, after = NA, child_order_id, child_order_acceptance_id){
  request_private_get(
    product_code = product_code,
    count = count,
    before = before,
    after = after,
    child_order_id = child_order_id,
    child_order_acceptance_id = child_order_acceptance_id
  )
}

#' Get Open Interest Summary
#'
#' Get Open Interest Summary
#'
#' @param product_code Currently supports only "FX_BTC_JPY".
#' @export
get_positions <- function(product_code="FX_BTC_JPY"){
  request_private_get(product_code = product_code)
}

#' Get Margin Change History
#'
#' Get Margin Change History
#'
#' @inheritParams count_before_after
#' @export
get_collateral_history <- func_count_before_after_private_get

#' Get Trading Commission
#'
#' Get Trading Commission
#'
#' @inheritParams product_code
#' @export
get_trading_commission <- func_product_code_private_get

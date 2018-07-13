#' @include util.R

#' Get API Key Permissions
#'
#' Access a list of which HTTP Private APIs can be used with the specified API key
#' @export
get_permissions <- make_request_private_get

#' Get Account Asset Balance
#'
#' Get Account Asset Balance
#' @export
get_balance <- make_request_private_get


#' Get Margin Status
#'
#' Get Margin Status
#' @export
get_collateral <- make_request_private_get

#' Get Margin Status
#'
#' Get Margin Status
#' @export
get_collateral_accounts <- make_request_private_get

#' Get Bitcoin/Ethereum Deposit Addresses
#'
#' Get Bitcoin/Ethereum Deposit Addresses
#' @export
get_addresses <- make_request_private_get

#' Get Bitcoin/Ether Deposit History
#'
#' Get Bitcoin/Ether Deposit History
#' @export
get_coinins <- make_request_private_get

#' Get Bitcoin/Ether Transaction History
#'
#' Get Bitcoin/Ether Transaction History
#' @export
get_coinouts <- make_request_private_get

#' Get Summary of Bank Accounts
#'
#' Returns a summary of bank accounts registered to your account.
#' @export
get_bank_accounts <- make_request_private_get

#' Get Cash Deposits
#'
#' Get Cash Deposits
#' @export
get_deposits  <- make_request_private_get

#' Withdrawing Funds
#'
#' Withdrawing Funds
#' @param currency_code Required. Currently only compatible with "JPY" for Japanese accounts,
#'   "USD" for U.S. accounts, and "EUR" for European accounts.
#' @param bank_account_id Required. Specify id of the bank account.
#' @param amount Required. This is the amount that you are canceling.
#' @export
withdraw <- make_request_private_post

#' Get Deposit Cancellation History
#'
#' Get Deposit Cancellation History
#' @export
get_withdrawals <- make_request_private_get

#' Send a New Order
#'
#' Send a New Order
#' @param product_code Required. The product being ordered. Please specify a product_code or alias, as obtained from the Market List. Only "BTC_USD" is available for U.S. accounts, and only "BTC_EUR" is available for European accounts.
#' @param child_order_type Required. For limit orders, it will be "LIMIT". For market orders, "MARKET".
#' @param side Required. For buy orders, "BUY". For sell orders, "SELL".
#' @param price Specify the price. This is a required value if child_order_type has been set to "LIMIT".
#' @param size Required. Specify the order quantity.
#' @param minute_to_expire Specify the time in minutes until the expiration time. If omitted, the value will be 43200 (30 days).
#' @param time_in_force Specify any of the following execution conditions - "GTC", "IOC", or "FOK". If omitted, the value defaults to "GTC".
#' @export
send_child_order <- make_request_private_post

#' Cancel Order
#'
#' Cancel Order
#' @param product_code Required. The product for the corresponding order. Please specify a product_code or alias, as obtained from the Market List. Only "BTC_USD" is available for U.S. accounts, and only "BTC_EUR" is available for European accounts.
#' @param child_order_id ID for the canceling order.
#' @param child_order_acceptance_id Expects an ID from Send a New Order. When specified, the corresponding order will be cancelled.
#' @export
cancel_child_order <- make_request_private_post

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

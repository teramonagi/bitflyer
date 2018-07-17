#' @title Params product_code
#' @name product_code
#' @keywords internal
#' @param product_code A product_code or alias, as obtained from the Market List.
#'   If omitted, the value is set to "BTC_JPY".
#'   Only "BTC_USD" is available for U.S. accounts,
#'   and only "BTC_EUR" is available for European accounts.
NULL

#' @title Params region
#' @name region
#' @keywords internal
#' @param region empty string ("") or "usa"
NULL

#' @title Params count, before, after
#' @name count_before_after
#' @keywords internal
#' @param count Specifies the number of results. If this is omitted, the value will be 100.
#' @param before Obtains data having an id lower than the value specified for this parameter.
#' @param after Obtains data having an id higher than the value specified for this parameter.
NULL


#' @title Params cild_order_state
#' @name child_order_state
#' @keywords internal
#' @param child_order_state When specified, return only orders that match the specified value.
#'   You must specify one of the following:
#'   ACTIVE: Return open orders
#'   COMPLETED: Return fully completed orders
#'   CANCELED: Return orders that have been cancelled by the customer
#'   EXPIRED: Return order that have been cancelled due to expiry
#'   REJECTED: Return failed orders
NULL

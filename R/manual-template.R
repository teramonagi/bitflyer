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

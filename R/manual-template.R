#' @title product_code
#' @description product_code
#' @name product_code
#' @keywords internal
#' @param product_code A product_code or alias, as obtained from the Market List.
#'   If omitted, the value is set to "BTC_JPY".
#'   Only "BTC_USD" is available for U.S. accounts,
#'   and only "BTC_EUR" is available for European accounts.
NULL

#' @title region
#' @description region
#' @name region
#' @keywords internal
#' @param region Default value ("") is Japan.
#'   \itemize{
#'     \item Japan: ""(Default), "ja", "jpn
#'     \item Usa: "us", "usa"
#'     \item Euro: "eu"
#'   }
NULL

#' @title count, before, after
#' @description count_before_after
#' @name count_before_after
#' @keywords internal
#' @param count Specifies the number of results. If this is omitted, the value will be 100.
#' @param before Obtains data having an id lower than the value specified for this parameter.
#' @param after Obtains data having an id higher than the value specified for this parameter.
NULL


#' @title cild_order_state
#' @description cild_order_state
#' @name child_order_state
#' @keywords internal
#' @param child_order_state When specified, return only orders that match the specified value.
#'   You must specify one of the following:
#'   \itemize{
#'     \item "ACTIVE": Return open orders
#'     \item "COMPLETED": Return fully completed orders
#'     \item "CANCELED": Return orders that have been cancelled by the customer
#'     \item "EXPIRED": Return order that have been cancelled due to expiry
#'     \item "REJECTED": Return failed orders
#'   }
NULL


#' @title child_order_id
#' @description child_order_id
#' @name child_order_id
#' @keywords internal
#' @param child_order_id  ID for the child order.
NULL

#' @title child_order_acceptance_id
#' @description child_order_acceptance_id
#' @name child_order_acceptance_id
#' @keywords internal
#' @param child_order_acceptance_id Expects an ID from \code{\link{send_child_order}}
NULL

#' @title parent_order_id
#' @description child_order_acceptance_id
#' @name parent_order_id
#' @keywords internal
#' @param parent_order_id The ID of the parent order in question.
NULL

#' @title parent_order_acceptance_id
#' @description parent_order_acceptance_id
#' @name parent_order_acceptance_id
#' @keywords internal
#' @param parent_order_acceptance_id Expects an ID from \code{\link{send_parent_order}}
NULL

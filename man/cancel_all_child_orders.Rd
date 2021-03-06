% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/private.R
\name{cancel_all_child_orders}
\alias{cancel_all_child_orders}
\title{Cancel All Orders}
\usage{
cancel_all_child_orders(product_code)
}
\arguments{
\item{product_code}{A product_code or alias, as obtained from the Market List.
If omitted, the value is set to "BTC_JPY".
Only "BTC_USD" is available for U.S. accounts,
and only "BTC_EUR" is available for European accounts.}
}
\description{
Cancel All Orders
Cancel all existing orders for the corresponding product.
}

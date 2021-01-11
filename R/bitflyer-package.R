#' R Wrapper for bitFlyer's REST API
#'
#' Make it easier to use bitFlyer's REST API (\url{https://lightning.bitflyer.com/docs?lang=en})
#' @name bitflyer
#' @keywords internal
#' @docType package
"_PACKAGE"

# Constants
BITFLYER_API_URL <- "https://api.bitflyer.jp"

# Messy to import every time...
#' @importFrom jsonlite fromJSON
#' @export
jsonlite::fromJSON

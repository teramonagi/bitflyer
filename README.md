
<!-- README.md is generated from README.Rmd. Please edit that file -->
bitflyer
========

[![Build Status](https://travis-ci.org/teramonagi/bitflyer.svg?branch=master)](https://travis-ci.org/teramonagi/bitflyer)

R wrapper for bitFlyer's REST API

Installation
------------

``` r
install.packages("bitflyer")

# Or the development version from GitHub:
# install.packages("devtools")
devtools::install_github("teramonagi/bitflyer")
```

Example
-------

### Public API

``` r
library("bitflyer")
# Get the list of market
get_markets()
#> [1] "[{\"product_code\":\"BTC_JPY\"},{\"product_code\":\"FX_BTC_JPY\"},{\"product_code\":\"ETH_BTC\"},{\"product_code\":\"BCH_BTC\"},{\"product_code\":\"BTCJPY28SEP2018\",\"alias\":\"BTCJPY_MAT3M\"},{\"product_code\":\"BTCJPY20JUL2018\",\"alias\":\"BTCJPY_MAT1WK\"},{\"product_code\":\"BTCJPY27JUL2018\",\"alias\":\"BTCJPY_MAT2WK\"}]"

# Get order book
x <- board(product_code = "BTC_JPY")
stringr::str_sub(x, 1, 200)
#> [1] "{\"mid_price\":835199.0,\"bids\":[{\"price\":835050.0,\"size\":0.49763534},{\"price\":834984.0,\"size\":1.0},{\"price\":834870.0,\"size\":0.02},{\"price\":834836.0,\"size\":0.3},{\"price\":834812.0,\"size\":0.01},{\"price\":83"

# Get the current status of the exchange.
get_health()
#> [1] "{\"status\":\"NORMAL\"}"

# ... etc
```

### Private API

``` r
# Get a list of which HTTP Private APIs can be used with the specified API key
get_permissions()
#> [1] "[\"/v1/getmarkets\",\"/v1/markets\",\"/v1/getmarkets/usa\",\"/v1/markets/usa\",\"/v1/getmarkets/eu\",\"/v1/markets/eu\",\"/v1/getboard\",\"/v1/board\",\"/v1/getticker\",\"/v1/ticker\",\"/v1/getexecutions\",\"/v1/executions\",\"/v1/getchats\",\"/v1/getchats/usa\",\"/v1/getchats/eu\",\"/v1/gethealth\",\"/v1/getboardstate\",\"/v1/me/getpermissions\",\"/v1/me/getbalance\",\"/v1/me/getcollateral\",\"/v1/me/getcollateralaccounts\",\"/v1/me/sendchildorder\",\"/v1/me/sendparentorder\",\"/v1/me/cancelchildorder\",\"/v1/me/cancelparentorder\",\"/v1/me/cancelallchildorders\",\"/v1/me/getchildorders\",\"/v1/me/getparentorders\",\"/v1/me/getparentorder\",\"/v1/me/getexecutions\",\"/v1/me/getpositions\",\"/v1/me/getcollateralhistory\",\"/v1/me/gettradingcommission\"]"

# Get Margin Status
get_collateral()
#> [1] "{\"collateral\":0.0,\"open_position_pnl\":0.0,\"require_collateral\":0.0,\"keep_rate\":0.0}"

#Send a New Order
x <- send_child_order(
  product_code = "BTC_JPY", 
  child_order_type = "LIMIT", 
  side = "BUY", 
  price = 50*10^4, 
  size = 0.001
)

# Cancel Order
id <- jsonlite::fromJSON(x)$child_order_acceptance_id
print(id)
#> [1] "JRF20180719-145022-924013"
cancel_child_order(product_code = "BTC_JPY", child_order_id = NULL, child_order_acceptance_id = id)
#> No encoding supplied: defaulting to UTF-8.
#> [1] ""

# Get Trading Commission
get_trading_commission(product_code = "BTC_JPY")
#> [1] "{\"commission_rate\":0.0015}"

# ... etc
```

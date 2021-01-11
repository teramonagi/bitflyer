
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bitflyer

<!-- badges: start -->

[![R-CMD-check](https://github.com/teramonagi/bitflyer/workflows/R-CMD-check/badge.svg)](https://github.com/teramonagi/bitflyer/actions)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

R wrapper for [bitFlyer’s
API](https://lightning.bitflyer.com/docs/api?lang=en)

## Installation

``` r
# Not yet on CRAN
# install.packages("bitflyer")

# Install the development version from GitHub:
# install.packages("devtools")
devtools::install_github("teramonagi/bitflyer")
```

## Preparation of API keys

bitFlyer Private APIs require authentication using an API Key and API
Secret.

They can be obtained by generating them on the [developer’s
page](https://lightning.bitflyer.com/developer).

You must set these keys in `.Renviron`

``` bash
❯ cat ~/.Renviron 
BITFLYER_LIGHTNING_API_KEY=<your-api-key>
BITFLYER_LIGHTNING_API_SECRET=<your-api-secret>
```

or as global variables in R

``` r
> BITFLYER_LIGHTNING_API_KEY <- "your-api-key"
> BITFLYER_LIGHTNING_API_SECRET <- "your-api-secret"
```

## Example

### HTTP API

#### [HTTP Public API](https://lightning.bitflyer.com/docs/api?lang=en#http-public-api)

``` r
library("bitflyer")
# Get the list of market
fromJSON(markets())
#>      product_code market_type         alias
#> 1         BTC_JPY        Spot          <NA>
#> 2      FX_BTC_JPY          FX          <NA>
#> 3         ETH_BTC        Spot          <NA>
#> 4         BCH_BTC        Spot          <NA>
#> 5         ETH_JPY        Spot          <NA>
#> 6 BTCJPY26MAR2021     Futures  BTCJPY_MAT3M
#> 7 BTCJPY15JAN2021     Futures BTCJPY_MAT1WK
#> 8 BTCJPY22JAN2021     Futures BTCJPY_MAT2WK

# Get order book
x <- board(product_code = "BTC_JPY")
x <- fromJSON(x)
str(x)
#> List of 3
#>  $ mid_price: num 3779321
#>  $ bids     :'data.frame':   2837 obs. of  2 variables:
#>   ..$ price: num [1:2837] 3778213 3778212 3778169 3777966 3777743 ...
#>   ..$ size : num [1:2837] 0.05 0.85 0.088 0.106 0.05 0.175 0.098 0.15 0.05 0.096 ...
#>  $ asks     :'data.frame':   1926 obs. of  2 variables:
#>   ..$ price: num [1:1926] 3780430 3781496 3781499 3781500 3781590 ...
#>   ..$ size : num [1:1926] 0.006 0.03 0.8 0.095 0.139 0.00105 0.175 0.05 0.008 0.1 ...

# Ticker 
ticker(product_code = "BTC_JPY")
#> [1] "{\"product_code\":\"BTC_JPY\",\"state\":\"RUNNING\",\"timestamp\":\"2021-01-11T02:23:02.923\",\"tick_id\":11641542,\"best_bid\":3778990.0,\"best_ask\":3781496.0,\"best_bid_size\":0.195,\"best_ask_size\":0.03,\"total_bid_depth\":905.4001749,\"total_ask_depth\":838.77890196,\"market_bid_size\":0.0,\"market_ask_size\":0.0,\"ltp\":3780430.0,\"volume\":168682.06537567,\"volume_by_product\":13616.4547289}"

# Execution History
head(fromJSON(executions()))
#>           id side   price       size               exec_date
#> 1 2114086954  BUY 3781499 0.05000000  2021-01-11T02:23:00.66
#> 2 2114086953  BUY 3780000 0.05000000  2021-01-11T02:23:00.66
#> 3 2114086952 SELL 3780430 0.95519531 2021-01-11T02:22:59.647
#> 4 2114086951 SELL 3780430 0.03480469 2021-01-11T02:22:59.617
#> 5 2114086950  BUY 3780000 0.01000000 2021-01-11T02:22:59.297
#> 6 2114086948 SELL 3778336 0.01390625 2021-01-11T02:22:58.263
#>   buy_child_order_acceptance_id sell_child_order_acceptance_id
#> 1     JRF20210111-022300-006846      JRF20210111-022258-080121
#> 2     JRF20210111-022300-006846      JRF20210111-022300-030394
#> 3     JRF20210111-022258-100008      JRF20210111-022259-065022
#> 4     JRF20210111-022258-100008      JRF20210111-022259-093027
#> 5     JRF20210111-022258-100008      JRF20210111-022258-101011
#> 6     JRF20210111-022251-002787      JRF20210111-022258-181776

# Get orderbook status
fromJSON(get_board_state())
#> $health
#> [1] "NORMAL"
#> 
#> $state
#> [1] "RUNNING"

# Get the current status of the exchange.
get_health()
#> [1] "{\"status\":\"NORMAL\"}"
```

#### [HTTP Private API](https://lightning.bitflyer.com/docs/api?lang=en#http-private-api)

The results of this chunk are hidden because you really understand of my
portfolio/positions …

``` r
# Get a list of which HTTP Private APIs can be used with the specified API key
fromJSON(get_permissions())

# Get Margin Status
fromJSON(get_collateral())

#Send a New Order
x <- send_child_order(
  product_code = "BTC_JPY", 
  child_order_type = "LIMIT", 
  side = "BUY", 
  price = 300*10^4, 
  size = 0.001
)
x
child_order_acceptance_id <- fromJSON(x)$child_order_acceptance_id

# List Orders
fromJSON(get_child_orders(product_code = "BTC_JPY", child_order_acceptance_id=child_order_acceptance_id))
# You can also get all active orders
# fromJSON(get_child_orders(product_code = "BTC_JPY", child_order_state="ACTIVE"))

# Cancel the order
cancel_child_order(product_code = "BTC_JPY", child_order_acceptance_id = child_order_acceptance_id)
# You can also cancel all child orders
# cancel_all_child_orders(product_code = "BTC_JPY")

# No active orders (Check)
fromJSON(get_child_orders(product_code = "BTC_JPY", child_order_state="ACTIVE"))

# Get balance
fromJSON(get_balance())

# Get Parent Order Details
get_parent_orders(product_code = "BTC_JPY")

# List Executions
fromJSON(get_executions(product_code = "BTC_JPY"))

# List Balance History
fromJSON(get_balance_history())

# Get Open Interest Summary
get_positions()

# Get Margin Change History
fromJSON(get_collateral_history())

# Get Trading Commission
get_trading_commission(product_code = "BTC_JPY")
```

The following APIs are not implemented yet.

  - [Deposits and
    Withdrawals](https://lightning.bitflyer.com/docs?lang=en#get-crypto-assets-deposit-addresses)
    APIs
  - [Submit New Parent Order (Special
    order)](https://lightning.bitflyer.com/docs?lang=en#submit-new-parent-order-special-order)
    API
      - Endpoint: `/v1/me/sendparentorder`

### Realtime API

… Not implemented yet(under development) …

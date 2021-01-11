
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
install.packages("bitflyer")

# Or the development version from GitHub:
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
#>  $ mid_price: num 3764983
#>  $ bids     :'data.frame':   2748 obs. of  2 variables:
#>   ..$ price: num [1:2748] 3764189 3764172 3761436 3761435 3761383 ...
#>   ..$ size : num [1:2748] 0.17 0.01 0.029 0.85 0.07 0.1 1 0.001 0.003 0.01 ...
#>  $ asks     :'data.frame':   1936 obs. of  2 variables:
#>   ..$ price: num [1:1936] 3765778 3767086 3767538 3767543 3767544 ...
#>   ..$ size : num [1:1936] 0.048 0.2 0.2 0.3 0.196 0.1 0.106 0.09 0.85 0.07 ...

# Ticker 
ticker(product_code = "BTC_JPY")
#> [1] "{\"product_code\":\"BTC_JPY\",\"state\":\"RUNNING\",\"timestamp\":\"2021-01-11T02:16:55.237\",\"tick_id\":11627610,\"best_bid\":3765524.0,\"best_ask\":3766335.0,\"best_bid_size\":0.08565571,\"best_ask_size\":0.05,\"total_bid_depth\":877.16120237,\"total_ask_depth\":829.373516,\"market_bid_size\":0.0,\"market_ask_size\":0.0,\"ltp\":3765573.0,\"volume\":167618.86291907,\"volume_by_product\":13534.99677343}"

# Execution History
head(fromJSON(executions()))
#>           id side   price      size               exec_date
#> 1 2114072070  BUY 3768684 0.0030000 2021-01-11T02:16:51.007
#> 2 2114072069 SELL 3765524 0.1543443 2021-01-11T02:16:50.283
#> 3 2114072068  BUY 3767863 0.0100000 2021-01-11T02:16:50.223
#> 4 2114072066 SELL 3765778 0.0500000  2021-01-11T02:16:49.76
#> 5 2114072065  BUY 3768951 0.0000060  2021-01-11T02:16:49.48
#> 6 2114072064  BUY 3768445 0.0600000  2021-01-11T02:16:49.48
#>   buy_child_order_acceptance_id sell_child_order_acceptance_id
#> 1     JRF20210111-021650-157326      JRF20210111-021650-140427
#> 2     JRF20210111-021648-061703      JRF20210111-021650-006966
#> 3     JRF20210111-021650-089406      JRF20210111-021649-072427
#> 4     JRF20210111-021641-029164      JRF20210111-021649-070820
#> 5     JRF20210111-021649-115263      JRF20210111-021649-055719
#> 6     JRF20210111-021649-115263      JRF20210111-021649-057857

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

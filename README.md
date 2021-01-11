
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bitflyer

[![Build
Status](https://travis-ci.org/teramonagi/bitflyer.svg?branch=master)](https://travis-ci.org/teramonagi/bitflyer)

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
#>  $ mid_price: num 3911775
#>  $ bids     :'data.frame':   3039 obs. of  2 variables:
#>   ..$ price: num [1:3039] 3910551 3910456 3910452 3910258 3910109 ...
#>   ..$ size : num [1:3039] 0.05 0.05 0.05 0.05 0.03 ...
#>  $ asks     :'data.frame':   1907 obs. of  2 variables:
#>   ..$ price: num [1:1907] 3913000 3913607 3913608 3913789 3913856 ...
#>   ..$ size : num [1:1907] 0.5 0.05 0.202 0.3 0.103 ...

# Ticker 
ticker(product_code = "BTC_JPY")
#> [1] "{\"product_code\":\"BTC_JPY\",\"state\":\"RUNNING\",\"timestamp\":\"2021-01-11T01:36:36.717\",\"tick_id\":11540984,\"best_bid\":3910551.0,\"best_ask\":3913000.0,\"best_bid_size\":0.05,\"best_ask_size\":0.5,\"total_bid_depth\":903.5484432,\"total_ask_depth\":815.69053859,\"market_bid_size\":0.0,\"market_ask_size\":0.0,\"ltp\":3913607.0,\"volume\":163105.51955855,\"volume_by_product\":13195.32819796}"

# Execution History
head(fromJSON(executions()))
#>           id side   price    size               exec_date
#> 1 2113979837  BUY 3913607 0.01051  2021-01-11T01:36:35.83
#> 2 2113979836 SELL 3912339 0.04805   2021-01-11T01:36:35.3
#> 3 2113979835  BUY 3912336 0.06990 2021-01-11T01:36:34.697
#> 4 2113979832 SELL 3910453 0.00380 2021-01-11T01:36:30.303
#> 5 2113979831 SELL 3912336 0.15406 2021-01-11T01:36:28.957
#> 6 2113979830 SELL 3912336 0.00694  2021-01-11T01:36:28.94
#>   buy_child_order_acceptance_id sell_child_order_acceptance_id
#> 1     JRF20210111-013635-002627      JRF20210111-013635-077930
#> 2     JRF20210111-013634-091778      JRF20210111-013635-140089
#> 3     JRF20210111-013634-021185      JRF20210111-013633-048118
#> 4     JRF20210111-013629-077906      JRF20210111-013629-149103
#> 5     JRF20210111-013623-059906      JRF20210111-013628-065219
#> 6     JRF20210111-013623-059906      JRF20210111-013628-077903

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

# Get Trading Commission
get_trading_commission(product_code = "BTC_JPY")

# Get balance
fromJSON(get_balance())

# Get Parent Order Details
get_parent_orders(product_code = "BTC_JPY")

# List Executions
fromJSON(get_executions(product_code = "BTC_JPY"))

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

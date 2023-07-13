# install.packages("tradestatistics")
# install.packages("cepiigeodist")
# install.packages("dplyr")
# install.packages("haven")

library(tradestatistics)
library(cepiigeodist)
library(dplyr)
library(haven)

# aggregate trade 2010-2020
trade1020 <- ots_create_tidy_data(2010:2020, table = "yrp")

dist_cepii

x <- tibble(a = 1:3, b = c("apple", "orange", "banana"), s2 = c(7,8,4))
y <- tibble(a = c(1,4,2), b = c("apple", "orange", "banana"), e3 = c(7,NA,4))

x %>%
  left_join(y)

x %>%
  inner_join(y)

x %>%
  full_join(y)

trade1020 <- trade1020 %>%
  mutate_if(is.character, toupper) %>%
  mutate(
    iso_o = pmin(reporter_iso, partner_iso, na.rm = T),
    iso_d = pmax(reporter_iso, partner_iso, na.rm = T)
  ) %>%
  # left_join(dist_cepii)
  inner_join(dist_cepii)

haven::write_dta(trade1020, "trade1020.dta")
haven::write_sav(trade1020, "trade1020.sav")

trade1020_spss <- read_sav("trade1020.sav")

trade1020_spss <- trade1020_spss %>%
  mutate(
    log_trade_value_usd_exp = log(trade_value_usd_exp),
    log_dist = log(dist),
    sq_dist = dist^2
  )

lm(
  log(trade_value_usd_exp) ~ dist,
  data = trade1020_spss %>%
    filter(trade_value_usd_exp > 0)
)

glm(
  log(trade_value_usd_exp) ~ dist,
  data = trade1020_spss %>%
    filter(trade_value_usd_exp > 0)
)

glm(
  log_trade_value_usd_exp ~ I(dist^2),
  data = trade1020_spss %>%
    filter(trade_value_usd_exp > 0)
)

glm(
  log_trade_value_usd_exp ~ sq_dist,
  data = trade1020_spss %>%
    filter(trade_value_usd_exp > 0)
)

glm(
  log_trade_value_usd_exp ~ dist * comlang_off,
  data = trade1020_spss %>%
    filter(trade_value_usd_exp > 0)
)

fit_zero <- glm(
  trade_value_usd_exp ~ log_dist,
  data = trade1020_spss,
  family = quasipoisson()
)

summary(fit_zero)

saveRDS(fit_zero, "fit_zero.rds")

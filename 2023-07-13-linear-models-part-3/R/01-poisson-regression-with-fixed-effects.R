# install.packages("fixest")
# install.packages("cepiigeodist")
# install.packages("tradestatistics")
# install.packages("dplyr")

library(fixest)
library(cepiigeodist)
library(tradestatistics)
library(dplyr)

# 1: create a dataset with exports and distance, contiguity and former colony ----

# 1.1.: downloading trade data

fout <- "trade1520.rds"

if (!file.exists(fout)) {
  trade <- ots_create_tidy_data(2015:2020, reporters = "all",
                                partners = "all", table = "yrp")

  saveRDS(trade, fout)
} else {
  trade <- readRDS(fout)
}

# 1.2: combining trade with additional variables from cepiigeodist

trade2 <- trade %>%
  filter(trade_value_usd_exp > 0) %>%
  mutate(
    log_exports = log(trade_value_usd_exp),
    iso_o = toupper(pmin(reporter_iso, partner_iso)),
    iso_d = toupper(pmax(reporter_iso, partner_iso))
  ) %>%
  as_tibble()

# same as the previous operation
# trade_new <- trade[trade$trade_value_usd_exp > 0, ]
# trade_new$log_exp <- log(trade_new$trade_value_usd_exp)

trade2 <- trade2 %>%
  inner_join(
    dist_cepii %>%
      select(iso_o, iso_d, dist, colony, contig)
  )

# 2: estimate or fit a Poisson model with fixed effects ----

# 2.1.: estimation without FEs

colnames(trade2)

fepois(trade_value_usd_imp ~ dist + contig + colony, data = trade2)

# 2.2.: create new columns for the FEs

# year + exporter = 1 FEs
# year + importer = 1 FEs
trade2 <- trade2 %>%
  mutate(
    fe_exp = paste0(reporter_iso, year),
    fe_imp = paste0(partner_iso, year)
  )

glimpse(trade2)

fit_fe <- fepois(trade_value_usd_imp ~ dist + contig + colony | fe_exp + fe_imp,
                 data = trade2)

summary(fit_fe)

saveRDS(fit_fe, "fit_fe.rds")

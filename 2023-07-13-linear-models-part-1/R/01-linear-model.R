mtcars

fit1 <- lm(mpg ~ wt, data = mtcars)
# mpg ~ wt means mpg_i = a + b * wt_i + e_i
fit2 <- lm(mpg ~ wt + 0, data = mtcars)
fit3 <- lm(mpg ~ wt - 1, data = mtcars)

summary(fit1)

use_directory("data")
use_directory("data2/subfolder/subfolder")

saveRDS(fit2, "data/fit1.rds")

fit1_reread <- readRDS("data/fit1.rds")

summary(fit1)
summary(fit1_reread)

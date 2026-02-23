### CDC Public Health Dataset Analysis (R)
### Purpose: Analyze BRFSS 2021 dataset to explore relationships between fruit consumption, general health, and checkup frequency

# Clear workspace
rm(list = ls())

# Load necessary libraries
library(tidyverse)
library(psych)
library(lm.beta)

# Load dataset
brf <- read_csv("brfss2021.csv", show_col_types = FALSE)

# -----------------------------
# 1. Select relevant variables
# -----------------------------
brf_selected <- brf %>%
  select(FRUIT2, CHECKUP1, GENHLTH)

# Preview first 10 rows
head(brf_selected, 10)

# -----------------------------
# 2. Clean data: remove missing/refused responses
# -----------------------------
brf_clean <- brf_selected %>%
  filter(!GENHLTH %in% c(7, 9), !CHECKUP1 %in% c(7, 9)) %>%
  filter(!is.na(GENHLTH), !is.na(CHECKUP1)) %>%
  arrange(GENHLTH)

head(brf_clean, 10)

# -----------------------------
# 3. Percentage of respondents reporting good/very good health
# -----------------------------
Q3 <- brf_clean %>%
  filter(GENHLTH %in% c(2, 3)) %>%
  summarise(
    Count = n(),
    Percent = round((Count / nrow(brf_clean)) * 100, 1)
  )

Q3

# -----------------------------
# 4. Health by time since last checkup
# -----------------------------
Q4 <- brf_clean %>%
  filter(GENHLTH %in% c(1, 2, 3)) %>%
  group_by(CHECKUP1) %>%
  summarise(
    n = n(),
    proportion = round(n / nrow(brf_clean), 3)
  )

Q4

# -----------------------------
# 5. Convert fruit consumption to per-day values
# -----------------------------
brf_fruit <- brf_clean %>%
  filter(!FRUIT2 %in% c(777, 999)) %>%
  mutate(
    FRTDAY = case_when(
      between(FRUIT2, 101, 199) ~ round(FRUIT2 - 100, 2),
      between(FRUIT2, 201, 299) ~ round((FRUIT2 - 200) / 7, 2),
      between(FRUIT2, 301, 399) ~ round((FRUIT2 - 300) / 30, 2),
      FRUIT2 == 300 ~ 0.02,
      FRUIT2 == 555 ~ 0,
      TRUE ~ NA_real_
    )
  ) %>%
  select(FRTDAY, CHECKUP1, GENHLTH) %>%
  arrange(GENHLTH)

head(brf_fruit, 10)

# -----------------------------
# 6. Descriptive statistics of fruit consumption by health
# -----------------------------
Q6 <- brf_fruit %>%
  group_by(GENHLTH) %>%
  summarise(
    Mean = round(mean(FRTDAY, na.rm = TRUE), 2),
    Median = round(median(FRTDAY, na.rm = TRUE), 2),
    SD = round(sd(FRTDAY, na.rm = TRUE), 2),
    Count = n()
  ) %>%
  arrange(GENHLTH)

Q6

# -----------------------------
# 7. Handle outliers (>8 servings/day) and impute missing fruit values
# -----------------------------
brf_fruit_clean <- brf_fruit %>%
  mutate(FRTDAY = ifelse(FRTDAY > 8, NA, FRTDAY)) %>%
  mutate(FRTDAY = ifelse(is.na(FRTDAY), median(FRTDAY, na.rm = TRUE), FRTDAY))

# Summary after cleaning
Q7 <- describe(brf_fruit_clean)
Q7

# -----------------------------
# 8. Linear regression: predict general health
# -----------------------------
brf_fruit_clean$CHECKUP1 <- as.factor(brf_fruit_clean$CHECKUP1)

mod_lm <- lm(GENHLTH ~ FRTDAY + CHECKUP1, data = brf_fruit_clean)
mod_lm_std <- lm.beta(mod_lm)
Q8 <- summary(mod_lm_std)

Q8

# -----------------------------
# 9. Logistic regression: binary health outcome
# -----------------------------
brf_logistic <- brf_fruit_clean %>%
  mutate(
    binHealth = factor(ifelse(GENHLTH %in% c(1, 2), 1, 0)),
    binCheckup = factor(ifelse(CHECKUP1 == 1, 1, 0))
  )

log_model <- glm(binHealth ~ FRTDAY + binCheckup, data = brf_logistic, family = binomial)
Q9 <- summary(log_model)
Q9

# -----------------------------
# 10. Predict on new individuals
# -----------------------------
new_individuals <- data.frame(
  ID = c("Person1", "Person2", "Person3", "Person4", "Person5"),
  FRTDAY = c(0, 1, 2, 3, 6),
  binCheckup = factor(c(0, 0, 0, 1, 1))
)

Q10 <- round(predict(log_model, newdata = new_individuals), 2)
Q10

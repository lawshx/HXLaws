library(ggplot2)
library(dplyr)

mtcars$cyl <- factor(mtcars$cyl)

ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE, aes(color = cyl)) + 
  geom_smooth(method = "lm", se = FALSE, linetype = 2, aes(color = cyl, group = 1))
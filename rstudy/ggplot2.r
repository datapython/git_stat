###  1: plot regression line, and add reg equation and R_square on the graph
library(ggplot2)
df <- data.frame(x = c(1:100))
df$y <- 2 + 3 * df$x + rnorm(100, sd = 40)
p <- ggplot(data = df, aes(x = x, y = y)) +
            geom_smooth(method = "lm", se=FALSE, color="black", formula = y ~ x) +
            geom_point()

p

lm_eqn = function(df){
    m = lm(y ~ x, df);
    eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
         list(a = format(coef(m)[1], digits = 2), 
              b = format(coef(m)[2], digits = 2), 
             r2 = format(summary(m)$r.squared, digits = 3)))
    as.character(as.expression(eq));                 
}

p1 = p + geom_text(aes(x = 25, y = 300, label = lm_eqn(df)), parse = TRUE)

p1


###  2: add the number of counts in the histogram / bar plot
library(plyr)
library(ggplot2)
ggplot(diamonds)+geom_histogram(aes(cut))
 
cut_avg <- aggregate(.~cut, diamonds, length)

ggplot(diamonds)+geom_histogram(aes(cut), colour="blue", fill="white")+geom_text(aes(y=cut_avg$depth, x=cut_avg$cut, label=cut_avg$depth), size=10)



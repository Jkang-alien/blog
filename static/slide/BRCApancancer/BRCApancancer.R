## ----- library ------------
library(rstan)
library(dplyr)
library(tibble)
library(ggplot2)

## ------ data_gen ----------
x <- c()
s <- c()
b <- c()
for (i in 1:20){
  v <- sample(seq(100, 800, by = 100), 1, prob=rev(seq(0.1, 0.8, by = 0.1)))
  s <- append(s, v)
  b <- sample((v-20):(v+20), 10, rep = TRUE)
  x <- append(x, b)
}


l =c()
for (i in 1:length(s)) {
  lead_location <- rep(i, 10)
  l <- append(l, lead_location)
}

Nsub <- length(s)


#### minor MAF: inverse proportional to copy number
f_raw <- (1-s/(max(s)+100))/2
f <- c()
for (i in f_raw) {
  sample_f <- sample(seq(i-0.05, i+0.05, by = 0.01),
                     10, replace = TRUE)
  f <- c(f, sample_f)
}

r <- (log2(x/mean(x)))

mydata <- list(r = r, f = f, N=length(r), s = l, Nsub = Nsub, psi = mean(x)/100)

## ------- read_distribution ------

ggplot(data.frame(read = x, location = mydata$s),
       aes(x = location, y = read)) +
  geom_point()

## ------- MAF_distribution ------

ggplot(data.frame(MAF = f, location = mydata$s),
       aes(x = location, y = MAF)) +
  geom_point()

## ------- code ----------------

code <- '
data {
  int N;
  real r[N];
  real f[N];
  int<lower=1> Nsub;
  int<lower=1> s[N];
}
parameters {
  real<lower=0.1, upper=10> cn[Nsub];
  real m_logit[Nsub];
  vector<lower=0>[Nsub] sigma_cn;
  vector<lower=0>[Nsub] sigma_m;
  real<lower=0, upper=1.0> P;
}
transformed parameters {
  real m[Nsub];
  real psi;
  for (i in 1:Nsub){
  m[i] = (0+(cn[i]/2-0)*inv_logit(m_logit[i])); //log jacobian determinant stan constraints transformation
  }
  psi = mean(cn);
}
model {
  for(i in 1:N){
  r[i] ~ normal(log2((P*cn[s[i]] + 2*(1-P))/(P*psi + 2*(1-P))),sigma_cn[s[i]]);
  f[i] ~ normal((P*m[s[i]]+1-P)/(P*cn[s[i]]+2*(1-P)), sigma_m[s[i]]);
  }
}
'
## ------------ code1 ----------------

'data {
  int N;
  real r[N];
  real f[N];
  int<lower=1> Nsub;
  int<lower=1> s[N];
}'

## ------------ code2 ----------------
'parameters {
  real<lower=0.1, upper=10> cn[Nsub];
  real m_logit[Nsub];
  vector<lower=0>[Nsub] sigma_cn;
  vector<lower=0>[Nsub] sigma_m;
  real<lower=0, upper=1.0> P;
}
transformed parameters {
  real m[Nsub];
  real psi;
  for (i in 1:Nsub){
    m[i] = (0+(cn[i]/2-0)*inv_logit(m_logit[i])); //log jacobian determinant stan constraints transformation
  }
  psi = mean(cn);
}'

## -------------- code3 ------------------
'model {
  for(i in 1:N){
  r[i] ~ normal(log2((P*cn[s[i]] + 2*(1-P))/(P*psi + 2*(1-P))),sigma_cn[s[i]]);
  f[i] ~ normal((P*m[s[i]]+1-P)/(P*cn[s[i]]+2*(1-P)), sigma_m[s[i]]);
  }
}'

## ------------ fit -------------------
set.seed(456278)
fit <- stan(model_code = code, data = mydata, iter = 2000, 
            chains = 2, control = list(adapt_delta = 0.9,
                                       max_treedepth = 5))

## ------------ cn --------------------

plot(fit, pars = 'cn')

## ------------ m ---------------------
plot(fit, pars = 'm')

## ------------ trace -----------------
traceplot(fit, pars = 'cn')

## ------------ diag ------------------
stan_diag(fit)

## ------------ tumor_purity-----------
post <- extract(fit)

hist(post$P,
     main = paste("Tumor purity"),
     ylab = '')
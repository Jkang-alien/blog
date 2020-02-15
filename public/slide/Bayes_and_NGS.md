Bayesian
========================================================
author: Jun Kang
date: October 8, 2018
autosize: true
css: custom.css
<style>
.reveal .slides section .slideContent{
    font-size: 24pt;
}
</style>

Coin toss
=======================================================

<img src="Coin_Toss.jpg" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="100%" />
***
- Observed data (H, H, H, H, H, H, H, H, H, H) <br>
- Guess the probability of coming head: 0.5? or 1.0?

Frequentist approch (What usually has been done)
======================================================
- Null hypothesis: probability of coming head is 0.5
- Hypothesis testing: Probability of observed data under null hypothesis a.k.a. p-value = (\(\frac{1}{2}^{10}\\))
- Hypothesis rejection: probability of coming head is not 0.5

Coin toss prior probability
=======================================================
<img src="tazza.jpg" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="100%" />
***
- The gambling dealer!! <br>
- Guess the probability of coming head after seeing 10 continuous head: 0.5? or 1.0?


Coin toss prior probability
=======================================================

![](coin_toss.png)
***
- Stanford reseach gives the probability 0.51!!
- Guess the probability of coming head after seeing 10 continuous head: 0.5? 0.51? 0.6? 0.7? 1.0?

Bayes theorem 1
======================================================

$$
\begin{equation}
\label{eq:bayes}
P(\theta|\textbf{D}) = P(\theta ) \frac{P(\textbf{D} |\theta)}{P(\textbf{D})} \end{equation}
$$

Bayes theorem 2
================================================
$$
\text{Posterior} = (\text{Prior} * \text{Likelyhood} )/\text{Normalizing constant}
$$

- Posterior
- Prior
- Likelyhood
- Normalizing constant

=================================================
Likelyhood function
<br>
<br>
$$\mathcal{L}(\theta \mid x) = p_\theta (x) = P_\theta (X=x)
$$
<br>

$$
\mathcal{L}(p_\text{H}=0.5 \mid \text{HH}) = 0.25.
$$

$$
\mathcal{L}(p_\text{H}=1.0 \mid \text{HH}) = 1.0.
$$

***

Probability distribution function
<br>
<br>
$$
\sum_u \operatorname{P}(X=u) = 1
$$

$$
P(\text{H} \mid p_\text{H}=0.5) = 0.5.
$$

$$
P(\text{T} \mid p_\text{H}=0.5) = 0.5.
$$

Bayesian example in genotype (SOAPsnp)
===================================================
<img src="http://www.genomics.cn/BGI/uploadfile/news/image/20120229/8694_en_Giant%20Panda-%20small.jpg" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" width="70%" />
Genotype calling
====================================================
<img src="https://genome.cshlp.org/content/19/6/1124/F1.large.jpg" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" width="70%" />
<br>
Genome Res. 2009. 19: 1124-1132

Likelyhood of genotype calling
====================================================
- Allele type
- Quality score
- Coordinates on the read
- t-th occurrence 

A:0, T:3, G:0, C:0, <br>
phred score: 30, 30, 30 <br>
Likelyhood?

Likelyhood of genotype calling
====================================================
$$
\text{L(Genotype T/G)|Read(T,T,T))} = (0.5*(1-0.001) + 0.5*0.001)^3
$$

$$
\text{L(Genotype T/T)|Read(T,T,T))} = (1-0.001)^3
$$

$$
\text{.}
$$
$$
\text{.}
$$
$$
\text{.}
$$

Prior probability 
====================================================
<img src="https://genome.cshlp.org/content/19/6/1124/T1.large.jpg" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" width="70%" />
- Reference allele: G
- Homozygous SNP rate: 0.0005
- Heterozygous SNP rate: 0.001
- Ratio of transitions versus transversions: 4

Posterior probability (incomplete)
==================================================
<br><br>

$$
\text{Posterior (Genotype T/G|Read(T,T,T))} 
$$

$$
= Prior (1.67*10^{-4}) * Likelyhood (0.5*(1-0.001) + 0.5*0.001)^3
$$

$$
=2.09*10^{-5}
$$

<br> <br> <br>

$$
\text{Posterior (Genotype T/T|Read(T,T,T))}
$$

$$ 
= Prior (8.33*10^{-5}) * Likelyhood((1-0.001)^3)
$$

$$
=8.31*10^{-5}
$$

Normalizing constant
====================================================
$$
P(D)=\sum_i P(D|H_i)P(H_i) \
$$

- Markov chain Monte Carlo (MCMC)
- WinBUGS
- JAGS
- STAN

MCMC
===================================================
<blockquote class="imgur-embed-pub" lang="en" data-id="2p1va60"><a href="//imgur.com/2p1va60"></a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>
```
MCMC (Gibbs sampling)
===================================================
<blockquote class="imgur-embed-pub" lang="en" data-id="91TeFpu"><a href="//imgur.com/91TeFpu"></a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>

Three steps of Bayesian data analysis  
=====================================================

























```
Error in file(con, "r") : cannot open the connection
```

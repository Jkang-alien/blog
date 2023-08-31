library(sequenza)
data.file <-
  system.file("extdata", "example.seqz.txt.gz", package = "sequenza")

test <- sequenza.extract(data.file, verbose = FALSE)

CP <- sequenza.fit(test)

sequenza.results(
  sequenza.extract = test,
  cp.table = CP,
  sample.id = "Test",
  out.dir = "TEST"
)
cp.plot(CP)
cp.plot.contours(
  CP,
  add = TRUE,
  likThresh = c(0.999, 0.95),
  col = c("lightsalmon", "red"),
  pch = 20
)

library(tidyverse)

cp <- read_delim("TEST/Test_confints_CP.txt", delim = '\t')

ploidy <- as.numeric(cp[2, 2])
SampleID <- "example1"

example <- read_delim("TEST/Test_segments.txt", delim = '\t')
example <- example %>%
  rename(
    Chromosome = "chromosome",
    Start_position = "start.pos",
    End_position = "end.pos",
    total_cn = "CNt",
    A_cn = "A",
    B_cn = "B"
  ) %>%
  mutate(SampleID = rep(SampleID, dim(example)[1]),
         ploidy = rep(ploidy, dim(example)[1])) %>%
  select(SampleID, Chromosome, Start_position, End_position, total_cn, A_cn, B_cn, ploidy)

write_delim(example, file = "example/example1.txt", delim = '\t')

library(scarHRD)

scar_score("example/example1.txt", reference = "grch38", chr.in.names = FALSE, seqz = FALSE)

seg <- read.table("example/example1.txt", header = T, check.names = F, stringsAsFactors = F, 
                  sep = "\t")


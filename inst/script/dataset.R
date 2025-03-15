## Here is listed the scripts used to generate the data files

#### minnbreast ####


#### sampleped ####
sampleped <- read.delim("inst/extdata/sampleped.tab",
    header = TRUE, sep = " ", stringsAsFactors = FALSE
)
sampleped[c("famid", "id", "dadid", "momid")] <- as.data.frame(
    lapply(sampleped[c("famid", "id", "dadid", "momid")], as.character)
)
sampleped <- mutate_if(
    sampleped, is.character,
    ~replace(., . %in% "0", NA)
)
summary(sampleped)
usethis::use_data(sampleped, overwrite = TRUE)


#### relped ####
relped <- read.delim("inst/extdata/relped.tab",
    header = TRUE, sep = " ", stringsAsFactors = FALSE
)
relped[c("famid", "id1", "id2", "code")] <- as.data.frame(
    lapply(relped[c("famid", "id1", "id2", "code")], as.character)
)
summary(relped)
usethis::use_data(relped, overwrite = TRUE)

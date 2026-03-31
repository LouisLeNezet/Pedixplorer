# Minnesota Breast Cancer Study

Data from the Minnesota Breast Cancer Family Study. This contains
extended pedigrees from 426 families, each identified by a single
proband in 1945-1952, with follow up for incident breast cancer.

## Usage

``` r
data(minnbreast)
```

## Format

A data frame with 28081 observations, one line per subject, on the
following 14 variables.

- `id` : Subject identifier

- `proband` : If 1, this subject is one of the original 426 probands

- `fatherid` : Identifier of the father, if the father is part of the
  data set; zero otherwise

- `motherid` : Identifier of the mother, if the mother is part of the
  data set; zero otherwise

- `famid` : Family identifier

- `endage` : Age at last follow-up or incident cancer

- `cancer` : `1` = breast cancer (females) or prostate cancer (males),
  `0` = censored

- `yob` : Year of birth

- `education` : Amount of education: 1-8 years, 9-12 years, high school
  graduate, vocational education beyond high school, some college but
  did not graduate, college graduate, post-graduate education, refused
  to answer on the questionnaire

- `marstat` : Marital status: married, living with someone in a
  marriage-like relationship, separated or divorced, widowed, never
  married, refused to answer the questionaire

- `everpreg` : Ever pregnant at the time of baseline survey

- `parity` : Number of births

- `nbreast` : Number of breast biopsies

- `sex` : `M` or `F`

- `bcpc` : Part of one of the families in the breast / prostate cancer
  substudy: `0` = no, `1` = yes. Note that subjects who were recruited
  to the overall study after the date of the BP substudy are coded as
  zero.

## Details

The original study was conducted by Dr. Elving Anderson at the Dight
Institute for Human Genetics at the University of Minnesota. From 1944
to 1952, 544 sequential breast cancer cases seen at the University
Hospital were enrolled, and information gathered on parents, siblings,
offspring, aunts / uncles, and grandparents with the goal of
understanding possible familial aspects of brest cancer. In 1991 the
study was resurrected by Dr Tom Sellers.

Of the original 544 he excluded 58 prevalent cases, along with another
19 who had less than 2 living relatives at the time of Dr Anderson's
survey. Of the remaining 462 families 10 had no living members, 23 could
not be located and 8 refused, leaving 426 families on whom updated
pedigrees were obtained.

This gave a study with 13351 males and 12699 females (5183 marry-ins).
Primary questions were the relationship of early life exposures, breast
density, and pharmacogenomics on incident breast cancer risk. For a
subset of the families data was gathered on prostate cancer risk for
male subjects via questionnaires sent to men over 40. Other than this,
data items other than parentage are limited to the female subjects. In
2003 a second phase of the study was instituted. The pedigrees were
further extended to the numbers found in this data set, and further data
gathered by questionnaire.

## References

Epidemiologic and genetic follow-up study of 544 Minnesota breast cancer
families: design and methods. Sellers TA, Anderson VE, Potter JD, Bartow
SA, Chen PL, Everson L, King RA, Kuni CC, Kushi LH, McGovern PG, et al.
Genetic Epidemiology, 1995; 12(4):417-29.

Evaluation of familial clustering of breast and prostate cancer in the
Minnesota Breast Cancer Family Study. Grabrick DM, Cerhan JR, Vierkant
RA, Therneau TM, Cheville JC, Tindall DJ, Sellers TA. Cancer Detect
Prev. 2003; 27(1):30-6.

Risk of breast cancer with oral contraceptive use in women with a family
history of breast cancer. Grabrick DM, Hartmann LC, Cerhan JR, Vierkant
RA, Therneau TM, Vachon CM, Olson JE, Couch FJ, Anderson KE, Pankratz
VS, Sellers TA. JAMA. 2000; 284(14):1791-8.

## Examples

``` r
data(minnbreast)
breastped <- Pedigree(minnbreast,
    cols_ren_ped = list(
        "dadid" = "fatherid", "momid" = "motherid"
    ), missid = "0", col_aff = "cancer"
)
summary(breastped)
#> $pedigree_summary
#> [1] "Ped object with 28081 individuals and 12 metadata columns"
#> 
#> $relationship_summary
#> [1] "Rel object with 0 relationshipswith 0 MZ twin, 0 DZ twin, 0 UZ twin, 0 Spouse"
#> 
scales(breastped)
#> An object of class "Scales"
#> Slot "fill":
#>   order column_values column_mods mods            labels affected  fill density
#> 1     1        cancer cancer_mods    0 Healthy <= to 0.5    FALSE white      NA
#> 2     1        cancer cancer_mods    1 Affected > to 0.5     TRUE   red      NA
#> 3     1        cancer cancer_mods   NA              <NA>       NA  grey      NA
#>   angle
#> 1    NA
#> 2    NA
#> 3    NA
#> 
#> Slot "border":
#>   column_values column_mods mods        labels border
#> 1         avail  avail_mods   NA            NA   grey
#> 2         avail  avail_mods    1     Available  green
#> 3         avail  avail_mods    0 Non Available  black
#> 
#plot family 8, proband is solid, slash for cancers
if (interactive()) {
    plot(breastped[famid(ped(breastped)) == "8"], aff_mark = TRUE)
}
```

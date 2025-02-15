# Norm ped

    Code
      ped_df
    Output
         id dadid momid    sex           fertility avail NumOther AffMod miscarriage
      1   1     3     4 female           infertile    NA        1   <NA>         SAB
      2   2     0     0   male             fertile  TRUE        2      A       FALSE
      3   3     8     7   male infertile_choice_na FALSE        2      E       FALSE
      4   4     6     5 female             fertile    NA        3      A       FALSE
      5   5     0     0 female             fertile    NA        7      E         ECT
      6   6  <NA>     0   male           infertile FALSE     <NA>      D         TOP
      7   7     0     0 female           infertile    NA        6      A       FALSE
      8   8     0     0 female             fertile FALSE        3      D       FALSE
      9   8     2     0 female             fertile    NA        3      A       FALSE
      10  9     9     8   male             fertile    NA        5      B         SAB
                                                                                                       error
      1                                                                         is-aborted-but-has-fertility
      2                                                                                                 <NA>
      3                                                          dadid-duplicated_is-infertile-but-is-parent
      4                                                                                                 <NA>
      5                                                                             is-aborted-but-is-parent
      6  one-parent-missing_is-infertile-but-is-parent_is-aborted-but-is-parent_is-aborted-but-has-fertility
      7                                                                           is-infertile-but-is-parent
      8                                       self-id-duplicated_is-mother-and-father_is-father-but-not-male
      9                                       self-id-duplicated_is-mother-and-father_is-father-but-not-male
      10                                         momid-duplicated_is-its-own-parent_is-aborted-but-is-parent
         famid deceased evaluated consultand proband carrier asymptomatic adopted
      1   <NA>       NA     FALSE      FALSE   FALSE      NA           NA   FALSE
      2   <NA>       NA     FALSE      FALSE   FALSE      NA           NA   FALSE
      3   <NA>       NA     FALSE      FALSE   FALSE      NA           NA   FALSE
      4   <NA>       NA     FALSE      FALSE   FALSE      NA           NA   FALSE
      5   <NA>       NA     FALSE      FALSE   FALSE      NA           NA   FALSE
      6   <NA>       NA     FALSE      FALSE   FALSE      NA           NA   FALSE
      7   <NA>       NA     FALSE      FALSE   FALSE      NA           NA   FALSE
      8   <NA>       NA     FALSE      FALSE   FALSE      NA           NA   FALSE
      9   <NA>       NA     FALSE      FALSE   FALSE      NA           NA   FALSE
      10  <NA>       NA     FALSE      FALSE   FALSE      NA           NA   FALSE

# Norm rel

    Code
      rel_df
    Output
         id1 id2    code famid                          error
      1  1_1 1_2 MZ twin     1                           <NA>
      2  1_1 1_3 DZ twin     1                           <NA>
      3  1_2 1_3 UZ twin     1                           <NA>
      4  2_1 2_2  Spouse     2                           <NA>
      5  2_3 2_4 MZ twin     2                           <NA>
      6  2_6 2_7    <NA>     2             code-not-recognise
      7  2_8 2_8  Spouse     2                        same-id
      8  1_9 1_0  Spouse     1                           <NA>
      9 <NA> 1_B    <NA>     1 id1-length0_code-not-recognise

---

    Code
      norm_rel(rel_df, missid = "0")
    Output
            id1   id2    code famid              error
      1       1     2 MZ twin  <NA>               <NA>
      2       3     2 DZ twin  <NA>               <NA>
      3       3     1 DZ twin  <NA>               <NA>
      4       3     4 MZ twin  <NA>               <NA>
      5       7 Other    <NA>  <NA> code-not-recognise
      6 spo Use     9    <NA>  <NA> code-not-recognise


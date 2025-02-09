# Norm ped

    Code
      ped_df
    Output
         id dadid momid        sex steril avail NumOther AffMod
      1   1     3     4 terminated   TRUE    NA        1   <NA>
      2   2     0     0       male  FALSE  TRUE        2      A
      3   3     8     7       male  FALSE FALSE        2      E
      4   4     6     5     female  FALSE    NA        3      A
      5   5     0     0     female  FALSE    NA        7      E
      6   6  <NA>     0       male  FALSE FALSE     <NA>      D
      7   7     0     0     female  FALSE    NA        6      A
      8   8     0     0     female  FALSE FALSE        3      D
      9   8     2     0     female  FALSE    NA        3      A
      10  9     9     8       male  FALSE    NA        5      B
                                                                  error famid
      1                                                            <NA>  <NA>
      2                                         is_steril_but_is_parent  <NA>
      3                                                dadid_duplicated  <NA>
      4                                                            <NA>  <NA>
      5                                                            <NA>  <NA>
      6                      one_parent_missing_is_steril_but_is_parent  <NA>
      7                                                            <NA>  <NA>
      8  self_id_duplicated_is_mother_and_father_is_father_but_not_male  <NA>
      9  self_id_duplicated_is_mother_and_father_is_father_but_not_male  <NA>
      10                             momid_duplicated_is_its_own_parent  <NA>
         deceased
      1        NA
      2        NA
      3        NA
      4        NA
      5        NA
      6        NA
      7        NA
      8        NA
      9        NA
      10       NA

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
      6  2_6 2_7    <NA>     2             code_not_recognise
      7  2_8 2_8  Spouse     2                        same_id
      8  1_9 1_0  Spouse     1                           <NA>
      9 <NA> 1_B    <NA>     1 id1_length0_code_not_recognise

---

    Code
      norm_rel(rel_df, missid = "0")
    Output
            id1   id2    code famid              error
      1       1     2 MZ twin  <NA>               <NA>
      2       3     2 DZ twin  <NA>               <NA>
      3       3     1 DZ twin  <NA>               <NA>
      4       3     4 MZ twin  <NA>               <NA>
      5       7 Other    <NA>  <NA> code_not_recognise
      6 spo Use     9    <NA>  <NA> code_not_recognise


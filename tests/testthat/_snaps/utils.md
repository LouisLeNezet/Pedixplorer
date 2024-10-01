# get_families_table

    Code
      get_families_table(df, "health")
    Output
      # A tibble: 3 x 3
        famid `Major mod` `Nb Ind`
        <dbl> <chr>          <int>
      1     1 A                  2
      2     2 A                  1
      3     3 B                  3

---

    Code
      get_families_table(df, "age")
    Output
      # A tibble: 3 x 3
        famid `Major mod` `Nb Ind`
        <dbl>       <dbl>    <int>
      1     1          23        2
      2     2          12        1
      3     3          45        3


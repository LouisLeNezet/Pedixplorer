# Pedigree plotting test

    Code
      lst
    Output
      $df
                               id     x0    y0   x1    y1       type    fill border
      1                   polygon  1.000 1.000   NA    NA square_2_1     red  black
      2                   polygon  0.000 2.000   NA    NA square_2_1   white  green
      3                   polygon  0.700 3.000   NA    NA circle_2_1   white  black
      4                   polygon  1.200 4.000   NA    NA circle_2_1   white  black
      5                   polygon  2.000 1.000   NA    NA circle_2_1   white  green
      6                   polygon  1.000 2.000   NA    NA circle_2_1     red  green
      7                   polygon  1.700 3.000   NA    NA square_2_1     red  green
      8                   polygon  2.000 2.000   NA    NA square_2_1   white  green
      9                   polygon  2.700 3.000   NA    NA square_2_1   white  green
      10                  polygon  3.000 2.000   NA    NA circle_2_1     red  black
      11                 aff_mark  0.975 1.050   NA    NA       text   black   <NA>
      12                 aff_mark -0.025 2.050   NA    NA       text   black   <NA>
      13                 aff_mark  0.675 3.050   NA    NA       text   black   <NA>
      14                 aff_mark  1.175 4.050   NA    NA       text   black   <NA>
      15                 aff_mark  1.975 1.050   NA    NA       text   black   <NA>
      16                 aff_mark  0.975 2.050   NA    NA       text   black   <NA>
      17                 aff_mark  1.675 3.050   NA    NA       text   black   <NA>
      18                 aff_mark  1.975 2.050   NA    NA       text   black   <NA>
      19                 aff_mark  2.675 3.050   NA    NA       text   black   <NA>
      20                 aff_mark  2.975 2.050   NA    NA       text   black   <NA>
      21                  polygon  1.000 1.000   NA    NA square_2_2   white  black
      22                  polygon  0.000 2.000   NA    NA square_2_2   white  green
      23                  polygon  0.700 3.000   NA    NA circle_2_2 #c300ff  black
      24                  polygon  1.200 4.000   NA    NA circle_2_2   white  black
      25                  polygon  2.000 1.000   NA    NA circle_2_2    grey  green
      26                  polygon  1.000 2.000   NA    NA circle_2_2 #c300ff  green
      27                  polygon  1.700 3.000   NA    NA square_2_2   white  green
      28                  polygon  2.000 2.000   NA    NA square_2_2 #c300ff  green
      29                  polygon  2.700 3.000   NA    NA square_2_2   white  green
      30                  polygon  3.000 2.000   NA    NA circle_2_2   white  black
      31                 aff_mark  1.025 1.050   NA    NA       text   black   <NA>
      32                 aff_mark  0.025 2.050   NA    NA       text   black   <NA>
      33                 aff_mark  0.725 3.050   NA    NA       text   black   <NA>
      34                 aff_mark  1.225 4.050   NA    NA       text   black   <NA>
      35                 aff_mark  2.025 1.050   NA    NA       text   black   <NA>
      36                 aff_mark  1.025 2.050   NA    NA       text   black   <NA>
      37                 aff_mark  1.725 3.050   NA    NA       text   black   <NA>
      38                 aff_mark  2.025 2.050   NA    NA       text   black   <NA>
      39                 aff_mark  2.725 3.050   NA    NA       text   black   <NA>
      40                 aff_mark  3.025 2.050   NA    NA       text   black   <NA>
      41                     dead  0.940 1.110 1.06 0.990   segments   black   <NA>
      42                     dead -0.060 2.110 0.06 1.990   segments   black   <NA>
      43                     dead  1.940 1.110 2.06 0.990   segments   black   <NA>
      44                     dead  0.940 2.110 1.06 1.990   segments   black   <NA>
      45                       id  1.000 1.170   NA    NA       text   black   <NA>
      46                       id  0.000 2.170   NA    NA       text   black   <NA>
      47                       id  0.700 3.170   NA    NA       text   black   <NA>
      48                       id  1.200 4.170   NA    NA       text   black   <NA>
      49                       id  2.000 1.170   NA    NA       text   black   <NA>
      50                       id  1.000 2.170   NA    NA       text   black   <NA>
      51                       id  1.700 3.170   NA    NA       text   black   <NA>
      52                       id  2.000 2.170   NA    NA       text   black   <NA>
      53                       id  2.700 3.170   NA    NA       text   black   <NA>
      54                       id  3.000 2.170   NA    NA       text   black   <NA>
      55             line_spouses  1.050 1.050 1.95 1.050   segments   black   <NA>
      56             line_spouses  0.050 2.050 0.95 2.050   segments   black   <NA>
      57             line_spouses  0.750 3.050 1.65 3.050   segments   black   <NA>
      58             line_spouses  2.050 2.050 2.95 2.050   segments   black   <NA>
      59            line_spouses2  0.750 3.060 1.65 3.060   segments   black   <NA>
      60   line_children_vertical  0.000 2.000 0.00 1.800   segments   black   <NA>
      61   line_children_vertical  3.000 2.000 3.00 1.800   segments   black   <NA>
      62 line_children_horizontal  0.000 1.800 3.00 1.800   segments   black   <NA>
      63          line_parent_mid  1.500 1.800 1.50 1.575   segments   black   <NA>
      64          line_parent_mid  1.500 1.575 1.50 1.275   segments   black   <NA>
      65          line_parent_mid  1.500 1.275 1.50 1.050   segments   black   <NA>
      66   line_children_vertical  0.700 3.000 0.70 2.800   segments   black   <NA>
      67 line_children_horizontal  0.700 2.800 0.70 2.800   segments   black   <NA>
      68          line_parent_mid  0.700 2.800 0.70 2.575   segments   black   <NA>
      69          line_parent_mid  0.700 2.575 0.50 2.275   segments   black   <NA>
      70          line_parent_mid  0.500 2.275 0.50 2.050   segments   black   <NA>
      71   line_children_vertical  1.700 3.000 2.20 2.800   segments   black   <NA>
      72   line_children_vertical  2.700 3.000 2.20 2.800   segments   black   <NA>
      73     label_children_twin3  2.200 2.900   NA    NA       text   black   <NA>
      74 line_children_horizontal  2.200 2.800 2.20 2.800   segments   black   <NA>
      75          line_parent_mid  2.200 2.800 2.20 2.575   segments   black   <NA>
      76          line_parent_mid  2.200 2.575 2.50 2.275   segments   black   <NA>
      77          line_parent_mid  2.500 2.275 2.50 2.050   segments   black   <NA>
      78   line_children_vertical  1.200 4.000 1.20 3.800   segments   black   <NA>
      79 line_children_horizontal  1.200 3.800 1.20 3.800   segments   black   <NA>
      80          line_parent_mid  1.200 3.800 1.20 3.575   segments   black   <NA>
      81          line_parent_mid  1.200 3.575 1.20 3.275   segments   black   <NA>
      82          line_parent_mid  1.200 3.275 1.20 3.050   segments   black   <NA>
         angle density cex label                                                tips
      1     NA      NA   1  <NA>  <span style='font-size:14px'><b>1_1</b></span><br>
      2     NA      NA   1  <NA>  <span style='font-size:14px'><b>1_3</b></span><br>
      3     NA      NA   1  <NA>  <span style='font-size:14px'><b>1_7</b></span><br>
      4     NA      NA   1  <NA> <span style='font-size:14px'><b>1_10</b></span><br>
      5     NA      NA   1  <NA>  <span style='font-size:14px'><b>1_2</b></span><br>
      6     NA      NA   1  <NA>  <span style='font-size:14px'><b>1_5</b></span><br>
      7     NA      NA   1  <NA>  <span style='font-size:14px'><b>1_8</b></span><br>
      8     NA      NA   1  <NA>  <span style='font-size:14px'><b>1_6</b></span><br>
      9     NA      NA   1  <NA>  <span style='font-size:14px'><b>1_9</b></span><br>
      10    NA      NA   1  <NA>  <span style='font-size:14px'><b>1_4</b></span><br>
      11    NA      NA   1     1  <span style='font-size:14px'><b>1_1</b></span><br>
      12    NA      NA   1     0  <span style='font-size:14px'><b>1_3</b></span><br>
      13    NA      NA   1     0  <span style='font-size:14px'><b>1_7</b></span><br>
      14    NA      NA   1     0 <span style='font-size:14px'><b>1_10</b></span><br>
      15    NA      NA   1     0  <span style='font-size:14px'><b>1_2</b></span><br>
      16    NA      NA   1     1  <span style='font-size:14px'><b>1_5</b></span><br>
      17    NA      NA   1     1  <span style='font-size:14px'><b>1_8</b></span><br>
      18    NA      NA   1     0  <span style='font-size:14px'><b>1_6</b></span><br>
      19    NA      NA   1     0  <span style='font-size:14px'><b>1_9</b></span><br>
      20    NA      NA   1     1  <span style='font-size:14px'><b>1_4</b></span><br>
      21    NA      NA   1  <NA>  <span style='font-size:14px'><b>1_1</b></span><br>
      22    NA      NA   1  <NA>  <span style='font-size:14px'><b>1_3</b></span><br>
      23    NA      NA   1  <NA>  <span style='font-size:14px'><b>1_7</b></span><br>
      24    NA      NA   1  <NA> <span style='font-size:14px'><b>1_10</b></span><br>
      25    NA      NA   1  <NA>  <span style='font-size:14px'><b>1_2</b></span><br>
      26    NA      NA   1  <NA>  <span style='font-size:14px'><b>1_5</b></span><br>
      27    NA      NA   1  <NA>  <span style='font-size:14px'><b>1_8</b></span><br>
      28    NA      NA   1  <NA>  <span style='font-size:14px'><b>1_6</b></span><br>
      29    NA      NA   1  <NA>  <span style='font-size:14px'><b>1_9</b></span><br>
      30    NA      NA   1  <NA>  <span style='font-size:14px'><b>1_4</b></span><br>
      31    NA      NA   1     0  <span style='font-size:14px'><b>1_1</b></span><br>
      32    NA      NA   1     0  <span style='font-size:14px'><b>1_3</b></span><br>
      33    NA      NA   1     1  <span style='font-size:14px'><b>1_7</b></span><br>
      34    NA      NA   1     0 <span style='font-size:14px'><b>1_10</b></span><br>
      35    NA      NA   1  <NA>  <span style='font-size:14px'><b>1_2</b></span><br>
      36    NA      NA   1     1  <span style='font-size:14px'><b>1_5</b></span><br>
      37    NA      NA   1     0  <span style='font-size:14px'><b>1_8</b></span><br>
      38    NA      NA   1     1  <span style='font-size:14px'><b>1_6</b></span><br>
      39    NA      NA   1     0  <span style='font-size:14px'><b>1_9</b></span><br>
      40    NA      NA   1     0  <span style='font-size:14px'><b>1_4</b></span><br>
      41    NA      NA   1  <NA>                                                <NA>
      42    NA      NA   1  <NA>                                                <NA>
      43    NA      NA   1  <NA>                                                <NA>
      44    NA      NA   1  <NA>                                                <NA>
      45    NA      NA   1   1_1  <span style='font-size:14px'><b>1_1</b></span><br>
      46    NA      NA   1   1_3  <span style='font-size:14px'><b>1_3</b></span><br>
      47    NA      NA   1   1_7  <span style='font-size:14px'><b>1_7</b></span><br>
      48    NA      NA   1  1_10 <span style='font-size:14px'><b>1_10</b></span><br>
      49    NA      NA   1   1_2  <span style='font-size:14px'><b>1_2</b></span><br>
      50    NA      NA   1   1_5  <span style='font-size:14px'><b>1_5</b></span><br>
      51    NA      NA   1   1_8  <span style='font-size:14px'><b>1_8</b></span><br>
      52    NA      NA   1   1_6  <span style='font-size:14px'><b>1_6</b></span><br>
      53    NA      NA   1   1_9  <span style='font-size:14px'><b>1_9</b></span><br>
      54    NA      NA   1   1_4  <span style='font-size:14px'><b>1_4</b></span><br>
      55    NA      NA   1  <NA>                                                <NA>
      56    NA      NA   1  <NA>                                                <NA>
      57    NA      NA   1  <NA>                                                <NA>
      58    NA      NA   1  <NA>                                                <NA>
      59    NA      NA   1  <NA>                                                <NA>
      60    NA      NA   1  <NA>                                                <NA>
      61    NA      NA   1  <NA>                                                <NA>
      62    NA      NA   1  <NA>                                                <NA>
      63    NA      NA   1  <NA>                                                <NA>
      64    NA      NA   1  <NA>                                                <NA>
      65    NA      NA   1  <NA>                                                <NA>
      66    NA      NA   1  <NA>                                                <NA>
      67    NA      NA   1  <NA>                                                <NA>
      68    NA      NA   1  <NA>                                                <NA>
      69    NA      NA   1  <NA>                                                <NA>
      70    NA      NA   1  <NA>                                                <NA>
      71    NA      NA   1  <NA>                                                <NA>
      72    NA      NA   1  <NA>                                                <NA>
      73    NA      NA   1     ?                                                <NA>
      74    NA      NA   1  <NA>                                                <NA>
      75    NA      NA   1  <NA>                                                <NA>
      76    NA      NA   1  <NA>                                                <NA>
      77    NA      NA   1  <NA>                                                <NA>
      78    NA      NA   1  <NA>                                                <NA>
      79    NA      NA   1  <NA>                                                <NA>
      80    NA      NA   1  <NA>                                                <NA>
      81    NA      NA   1  <NA>                                                <NA>
      82    NA      NA   1  <NA>                                                <NA>
         adjx adjy lty
      1    NA   NA  NA
      2    NA   NA  NA
      3    NA   NA  NA
      4    NA   NA  NA
      5    NA   NA  NA
      6    NA   NA  NA
      7    NA   NA  NA
      8    NA   NA  NA
      9    NA   NA  NA
      10   NA   NA  NA
      11  0.5  0.5  NA
      12  0.5  0.5  NA
      13  0.5  0.5  NA
      14  0.5  0.5  NA
      15  0.5  0.5  NA
      16  0.5  0.5  NA
      17  0.5  0.5  NA
      18  0.5  0.5  NA
      19  0.5  0.5  NA
      20  0.5  0.5  NA
      21   NA   NA  NA
      22   NA   NA  NA
      23   NA   NA  NA
      24   NA   NA  NA
      25   NA   NA  NA
      26   NA   NA  NA
      27   NA   NA  NA
      28   NA   NA  NA
      29   NA   NA  NA
      30   NA   NA  NA
      31  0.5  0.5  NA
      32  0.5  0.5  NA
      33  0.5  0.5  NA
      34  0.5  0.5  NA
      35  0.5  0.5  NA
      36  0.5  0.5  NA
      37  0.5  0.5  NA
      38  0.5  0.5  NA
      39  0.5  0.5  NA
      40  0.5  0.5  NA
      41   NA   NA  NA
      42   NA   NA  NA
      43   NA   NA  NA
      44   NA   NA  NA
      45  0.5  1.0  NA
      46  0.5  1.0  NA
      47  0.5  1.0  NA
      48  0.5  1.0  NA
      49  0.5  1.0  NA
      50  0.5  1.0  NA
      51  0.5  1.0  NA
      52  0.5  1.0  NA
      53  0.5  1.0  NA
      54  0.5  1.0  NA
      55   NA   NA  NA
      56   NA   NA  NA
      57   NA   NA  NA
      58   NA   NA  NA
      59   NA   NA  NA
      60   NA   NA  NA
      61   NA   NA  NA
      62   NA   NA  NA
      63   NA   NA  NA
      64   NA   NA  NA
      65   NA   NA  NA
      66   NA   NA  NA
      67   NA   NA  NA
      68   NA   NA  NA
      69   NA   NA  NA
      70   NA   NA  NA
      71   NA   NA  NA
      72   NA   NA  NA
      73  0.5  0.5  NA
      74   NA   NA  NA
      75   NA   NA  NA
      76   NA   NA  NA
      77   NA   NA  NA
      78   NA   NA  NA
      79   NA   NA  NA
      80   NA   NA  NA
      81   NA   NA  NA
      82   NA   NA  NA
      
      $par_usr
      $par_usr$usr
      [1] -0.05  3.05  4.20  1.00
      
      $par_usr$old_par
      $par_usr$old_par$xpd
      [1] TRUE
      
      
      $par_usr$boxw
      [1] 0.1
      
      $par_usr$boxh
      [1] 0.1
      
      $par_usr$labh
      [1] 0.05
      
      $par_usr$legh
      [1] 0.2
      
      

# Tooltip works

    Code
      html_plot


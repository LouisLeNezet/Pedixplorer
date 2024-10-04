# Pedigree plotting test

    Code
      lst
    Output
      $df
                               id      x0     y0    x1     y1       type    fill
      1                   polygon  1.0000 1.0000    NA     NA square_2_1     red
      2                   polygon  0.0000 2.0000    NA     NA square_2_1   white
      3                   polygon  0.7000 3.0000    NA     NA circle_2_1   white
      4                   polygon  1.2000 4.0000    NA     NA circle_2_1   white
      5                   polygon  2.0000 1.0000    NA     NA circle_2_1   white
      6                   polygon  1.0000 2.0000    NA     NA circle_2_1     red
      7                   polygon  1.7000 3.0000    NA     NA square_2_1     red
      8                   polygon  2.0000 2.0000    NA     NA square_2_1   white
      9                   polygon  2.7000 3.0000    NA     NA square_2_1   white
      10                  polygon  3.0000 2.0000    NA     NA circle_2_1     red
      11                 aff_mark  0.9825 1.0350    NA     NA       text   black
      12                 aff_mark -0.0175 2.0350    NA     NA       text   black
      13                 aff_mark  0.6825 3.0350    NA     NA       text   black
      14                 aff_mark  1.1825 4.0350    NA     NA       text   black
      15                 aff_mark  1.9825 1.0350    NA     NA       text   black
      16                 aff_mark  0.9825 2.0350    NA     NA       text   black
      17                 aff_mark  1.6825 3.0350    NA     NA       text   black
      18                 aff_mark  1.9825 2.0350    NA     NA       text   black
      19                 aff_mark  2.6825 3.0350    NA     NA       text   black
      20                 aff_mark  2.9825 2.0350    NA     NA       text   black
      21                  polygon  1.0000 1.0000    NA     NA square_2_2   white
      22                  polygon  0.0000 2.0000    NA     NA square_2_2   white
      23                  polygon  0.7000 3.0000    NA     NA circle_2_2 #c300ff
      24                  polygon  1.2000 4.0000    NA     NA circle_2_2   white
      25                  polygon  2.0000 1.0000    NA     NA circle_2_2    grey
      26                  polygon  1.0000 2.0000    NA     NA circle_2_2 #c300ff
      27                  polygon  1.7000 3.0000    NA     NA square_2_2   white
      28                  polygon  2.0000 2.0000    NA     NA square_2_2 #c300ff
      29                  polygon  2.7000 3.0000    NA     NA square_2_2   white
      30                  polygon  3.0000 2.0000    NA     NA circle_2_2   white
      31                 aff_mark  1.0175 1.0350    NA     NA       text   black
      32                 aff_mark  0.0175 2.0350    NA     NA       text   black
      33                 aff_mark  0.7175 3.0350    NA     NA       text   black
      34                 aff_mark  1.2175 4.0350    NA     NA       text   black
      35                 aff_mark  2.0175 1.0350    NA     NA       text   black
      36                 aff_mark  1.0175 2.0350    NA     NA       text   black
      37                 aff_mark  1.7175 3.0350    NA     NA       text   black
      38                 aff_mark  2.0175 2.0350    NA     NA       text   black
      39                 aff_mark  2.7175 3.0350    NA     NA       text   black
      40                 aff_mark  3.0175 2.0350    NA     NA       text   black
      41                     dead  0.9580 1.0770 1.042 0.9930   segments   black
      42                     dead -0.0420 2.0770 0.042 1.9930   segments   black
      43                     dead  1.9580 1.0770 2.042 0.9930   segments   black
      44                     dead  0.9580 2.0770 1.042 1.9930   segments   black
      45                       id  1.0000 1.1060    NA     NA       text   black
      46                       id  0.0000 2.1060    NA     NA       text   black
      47                       id  0.7000 3.1060    NA     NA       text   black
      48                       id  1.2000 4.1060    NA     NA       text   black
      49                       id  2.0000 1.1060    NA     NA       text   black
      50                       id  1.0000 2.1060    NA     NA       text   black
      51                       id  1.7000 3.1060    NA     NA       text   black
      52                       id  2.0000 2.1060    NA     NA       text   black
      53                       id  2.7000 3.1060    NA     NA       text   black
      54                       id  3.0000 2.1060    NA     NA       text   black
      55             line_spouses  1.0350 1.0350 1.965 1.0350   segments   black
      56             line_spouses  0.0350 2.0350 0.965 2.0350   segments   black
      57             line_spouses  0.7350 3.0350 1.665 3.0350   segments   black
      58             line_spouses  2.0350 2.0350 2.965 2.0350   segments   black
      59            line_spouses2  0.7350 3.0420 1.665 3.0420   segments   black
      60   line_children_vertical  0.0000 2.0000 0.000 1.9000   segments   black
      61   line_children_vertical  3.0000 2.0000 3.000 1.9000   segments   black
      62 line_children_horizontal  0.0000 1.9000 3.000 1.9000   segments   black
      63          line_parent_mid  1.5000 1.9000 1.500 1.6405   segments   black
      64          line_parent_mid  1.5000 1.6405 1.500 1.2945   segments   black
      65          line_parent_mid  1.5000 1.2945 1.500 1.0350   segments   black
      66   line_children_vertical  0.7000 3.0000 0.700 2.9000   segments   black
      67 line_children_horizontal  0.7000 2.9000 0.700 2.9000   segments   black
      68          line_parent_mid  0.7000 2.9000 0.700 2.6405   segments   black
      69          line_parent_mid  0.7000 2.6405 0.500 2.2945   segments   black
      70          line_parent_mid  0.5000 2.2945 0.500 2.0350   segments   black
      71   line_children_vertical  1.7000 3.0000 2.200 2.9000   segments   black
      72   line_children_vertical  2.7000 3.0000 2.200 2.9000   segments   black
      73     label_children_twin3  2.2000 2.9500    NA     NA       text   black
      74 line_children_horizontal  2.2000 2.9000 2.200 2.9000   segments   black
      75          line_parent_mid  2.2000 2.9000 2.200 2.6405   segments   black
      76          line_parent_mid  2.2000 2.6405 2.500 2.2945   segments   black
      77          line_parent_mid  2.5000 2.2945 2.500 2.0350   segments   black
      78   line_children_vertical  1.2000 4.0000 1.200 3.9000   segments   black
      79 line_children_horizontal  1.2000 3.9000 1.200 3.9000   segments   black
      80          line_parent_mid  1.2000 3.9000 1.200 3.6405   segments   black
      81          line_parent_mid  1.2000 3.6405 1.200 3.2945   segments   black
      82          line_parent_mid  1.2000 3.2945 1.200 3.0350   segments   black
         border angle density cex label tips adjx adjy
      1   black    NA      NA 0.5  <NA> <NA>   NA   NA
      2   green    NA      NA 0.5  <NA> <NA>   NA   NA
      3   black    NA      NA 0.5  <NA> <NA>   NA   NA
      4   black    NA      NA 0.5  <NA> <NA>   NA   NA
      5   green    NA      NA 0.5  <NA> <NA>   NA   NA
      6   green    NA      NA 0.5  <NA> <NA>   NA   NA
      7   green    NA      NA 0.5  <NA> <NA>   NA   NA
      8   green    NA      NA 0.5  <NA> <NA>   NA   NA
      9   green    NA      NA 0.5  <NA> <NA>   NA   NA
      10  black    NA      NA 0.5  <NA> <NA>   NA   NA
      11   <NA>    NA      NA 1.0     1 <NA>   NA   NA
      12   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      13   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      14   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      15   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      16   <NA>    NA      NA 1.0     1 <NA>   NA   NA
      17   <NA>    NA      NA 1.0     1 <NA>   NA   NA
      18   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      19   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      20   <NA>    NA      NA 1.0     1 <NA>   NA   NA
      21  black    NA      NA 0.5  <NA> <NA>   NA   NA
      22  green    NA      NA 0.5  <NA> <NA>   NA   NA
      23  black    NA      NA 0.5  <NA> <NA>   NA   NA
      24  black    NA      NA 0.5  <NA> <NA>   NA   NA
      25  green    NA      NA 0.5  <NA> <NA>   NA   NA
      26  green    NA      NA 0.5  <NA> <NA>   NA   NA
      27  green    NA      NA 0.5  <NA> <NA>   NA   NA
      28  green    NA      NA 0.5  <NA> <NA>   NA   NA
      29  green    NA      NA 0.5  <NA> <NA>   NA   NA
      30  black    NA      NA 0.5  <NA> <NA>   NA   NA
      31   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      32   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      33   <NA>    NA      NA 1.0     1 <NA>   NA   NA
      34   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      35   <NA>    NA      NA 1.0  <NA> <NA>   NA   NA
      36   <NA>    NA      NA 1.0     1 <NA>   NA   NA
      37   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      38   <NA>    NA      NA 1.0     1 <NA>   NA   NA
      39   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      40   <NA>    NA      NA 1.0     0 <NA>   NA   NA
      41   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      42   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      43   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      44   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      45   <NA>    NA      NA 1.0   1_1 <NA>   NA   NA
      46   <NA>    NA      NA 1.0   1_3 <NA>   NA   NA
      47   <NA>    NA      NA 1.0   1_7 <NA>   NA   NA
      48   <NA>    NA      NA 1.0  1_10 <NA>   NA   NA
      49   <NA>    NA      NA 1.0   1_2 <NA>   NA   NA
      50   <NA>    NA      NA 1.0   1_5 <NA>   NA   NA
      51   <NA>    NA      NA 1.0   1_8 <NA>   NA   NA
      52   <NA>    NA      NA 1.0   1_6 <NA>   NA   NA
      53   <NA>    NA      NA 1.0   1_9 <NA>   NA   NA
      54   <NA>    NA      NA 1.0   1_4 <NA>   NA   NA
      55   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      56   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      57   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      58   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      59   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      60   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      61   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      62   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      63   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      64   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      65   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      66   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      67   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      68   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      69   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      70   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      71   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      72   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      73   <NA>    NA      NA 1.0     ? <NA>   NA   NA
      74   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      75   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      76   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      77   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      78   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      79   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      80   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      81   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      82   <NA>    NA      NA 0.5  <NA> <NA>   NA   NA
      
      $par_usr
      $par_usr$usr
      [1] -0.035  3.035  4.220  1.000
      
      $par_usr$old_par
      $par_usr$old_par$xpd
      [1] TRUE
      
      
      $par_usr$boxw
      [1] 0.07
      
      $par_usr$boxh
      [1] 0.07
      
      $par_usr$labh
      [1] 0.03
      
      $par_usr$legh
      [1] 0.1
      
      


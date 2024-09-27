# ibd_matrix works

    Code
      ibd_matrix(df$id1, df$id2, df$ibd, diagonal = 2, idmap = idmap)
    Output
      4 x 4 sparse Matrix of class "dsCMatrix"
           A    B    C    D
      A 2.00 0.50 .    0.27
      B 0.50 2.00 0.16 .   
      C .    0.16 2.00 .   
      D 0.27 .    .    2.00


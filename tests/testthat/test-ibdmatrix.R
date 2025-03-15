test_that("ibd_matrix works", {
    df <- data.frame(
        id1 = c("1", "2", "1", "1"),
        id2 = c("2", "3", "4", "2"),
        ibd = c(0.5, 0.16, 0.27, 0.4)
    )
    idmap <- data.frame(
        id = c("1", "2", "3", "4"),
        name = c("A", "B", "C", "D")
    )
    expect_snapshot(
        ibd_matrix(
            df$id1, df$id2, df$ibd,
            diagonal = 2, idmap = idmap
        )
    )
    expect_error(ibd_matrix(df[c("id1", "id2")]))
    expect_error(ibd_matrix(df$id1))
    expect_error(ibd_matrix(df$id1, df$id2))
    expect_error(ibd_matrix(df, df$id2, df$ibd))
    expect_error(ibd_matrix(df, ibd = df$ibd))
})

#### Select the **fertility status** column of the individuals

**Optional** column.

The value of this column must contains a character, factor or numeric vector corresponding to the fertility status of the individuals.

This will be transformed to a factor with the following levels:
`infertile_choice_na`, `infertile`, `fertile`

The following values are recognized:
- "inferile_choice_na" : "infertile_choice", "infertile_na"
- "infertile" : "infertile", "steril", `FALSE`, `0`
- "fertile" : "fertile", `TRUE`, `1`, `NA`

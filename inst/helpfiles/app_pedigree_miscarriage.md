#### Select the **miscarriage status** column of the individuals

**Optional** column.

The value of this column must contains a character, factor or numeric vector corresponding to the miscarriage status of the individuals. 

This will be transformed to a factor with the following levels:
`TOP`, `SAB`, `ECT`, `FALSE`

The following values are recognized:
- "SAB" : "spontaneous", "spontaenous abortion"
- "TOP" : "termination", "terminated", "termination of pregnancy"
- "ECT" : "ectopic", "ectopic pregnancy"
- FALSE : `0`, `FALSE`, "no", `NA`

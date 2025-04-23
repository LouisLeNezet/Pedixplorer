### Select if colors should be a gradient or not

If set to `TRUE` then:

- If **values** isn't numeric:
    Each levels of the affected values vector will get it's own color from the **Least Affected** to the **Affected** colors.
    Each levels of the unaffected values vector will get it's own color from the **Unaffected** to the **Dubious** colors.

- If **values** is numeric:
    The mean of the affected individuals will be compared to the mean of the unaffected individuals and the colors will be set up such as the color
    gradient follow the direction of the affection and the gradient will be set up from the **Least Affected** to the **Affected** colors for the affected individuals and from the **Unaffected** to the **Dubious** colors for the unaffected individuals.

If set to `FALSE` then only the **Affected** colors will be used for the affected individuals and only the **Unaffected** colors will be used for the unaffected individuals.

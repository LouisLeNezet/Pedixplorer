### Filter based on distance to informative individuals

This filter allows you to set a maximum distance value from the informatives individuals in your dataset.
This distance is a transformation of the maximum kinship degree between the informative individuals and all the others.

This transformation is done by taking the `log2` of the inverse of the maximum kinship degree.

$$\text{minDist} = \log_2\left(\frac{1}{\max(\text{kinship})}\right)$$

Therefore, the minimum distance is `0` when the maximum kinship is `1` and
is infinite when the maximum kinship is `0`.

For siblings, the kinship value is `0.5` and the minimum distance is `1`.
Each time the kinship degree is divided by `2`, the minimum distance is increased by `1`.

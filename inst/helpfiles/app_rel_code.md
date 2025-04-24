#### Select the **relationship code** column

**Mandatory** column.

The value of this column must contains a character, factor or numeric vector corresponding to the relation code of the individuals:

- MZ twin = Monozygotic twin
- DZ twin = Dizygotic twin
- UZ twin = twin of unknown zygosity
- Spouse = Spouse

The following values are recognized:

- character() or factor() : "MZ twin", "DZ twin", "UZ twin", "Spouse" with of without space between the words. The case is not important.
- numeric() : 1 = "MZ twin", 2 = "DZ twin", 3 = "UZ twin", 4 = "Spouse"

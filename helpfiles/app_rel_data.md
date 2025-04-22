### Select the special relationship data file

This optional file is needed only if you want to add special relationships between individuals (see below).

The file **must** contains the following columns :

- `id` : the first individual identifier
- `id2` : the second individual identifier
- `code` : the relationship between the two individuals

Other columns are **optional** and can be used to provide additional information about the individuals:

- `famid` : family identifier

The relationship codes are:

- `1` for Monozygotic twin
- `2` for Dizygotic twin
- `3` for Twin of unknown zygosity
- `4` for Spouse relationship

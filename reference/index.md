# Package index

## Pedixplorer

Pedixplorer a Bioconductor package to create, filter and draw pedigrees.

- [`Pedixplorer`](https://louislenezet.github.io/Pedixplorer/reference/Pedixplorer_package.md)
  [`Pedixplorer-package`](https://louislenezet.github.io/Pedixplorer/reference/Pedixplorer_package.md)
  : The Pedixplorer package for pedigree data

## Pedigree S4 object

The Pedigree object is a S4 class that contains the pedigree data.

- [`Pedigree()`](https://louislenezet.github.io/Pedixplorer/reference/Pedigree-class.md)
  : Pedigree object
- [`Ped(`*`<data.frame>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/Ped-class.md)
  [`Ped(`*`<character_OR_integer>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/Ped-class.md)
  : Ped object
- [`Rel(`*`<data.frame>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/Rel-class.md)
  [`Rel(`*`<character_OR_integer>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/Rel-class.md)
  : Rel object
- [`Scales()`](https://louislenezet.github.io/Pedixplorer/reference/Scales-class.md)
  : Scales object
- [`Hints()`](https://louislenezet.github.io/Pedixplorer/reference/Hints-class.md)
  : Hints object

## Pedigree construction

How to fix pedigree data and normalize it

- [`fix_parents(`*`<character>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/fix_parents.md)
  [`fix_parents(`*`<data.frame>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/fix_parents.md)
  : Fix parents relationship and gender
- [`norm_ped()`](https://louislenezet.github.io/Pedixplorer/reference/norm_ped.md)
  : Normalise a Ped object dataframe
- [`norm_rel()`](https://louislenezet.github.io/Pedixplorer/reference/norm_rel.md)
  : Normalise a Rel object dataframe
- [`plink_to_pedigree()`](https://louislenezet.github.io/Pedixplorer/reference/plink_to_pedigree.md)
  : Import from .fam file or .ped file

## Shiny app

The Pedixplorer package comes with a shiny app to interact with the
Pedigree object.

- [`ped_shiny()`](https://louislenezet.github.io/Pedixplorer/reference/ped_shiny.md)
  : Run Pedixplorer Shiny application
- [`ped_server()`](https://louislenezet.github.io/Pedixplorer/reference/ped_server.md)
  : Create the server logic for the ped_shiny application
- [`ped_ui`](https://louislenezet.github.io/Pedixplorer/reference/ped_ui.md)
  : Create the user interface for the ped_shiny application

## Pedigree drawing and legend

The Pedigree object can be drawn using the plot method.

- [`plot(`*`<Pedigree>`*`,`*`<missing>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/plot_pedigree.md)
  : Plot Pedigrees
- [`ped_to_plotdf(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/ped_to_plotdf.md)
  : Create plotting data frame from a Pedigree
- [`ped_to_legdf(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/ped_to_legdf.md)
  : Create plotting legend data frame from a Pedigree
- [`plot_fromdf()`](https://louislenezet.github.io/Pedixplorer/reference/plot_fromdf.md)
  : Create a plot from a data.frame
- [`generate_colors(`*`<character>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/generate_colors.md)
  [`generate_colors(`*`<numeric>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/generate_colors.md)
  [`generate_colors(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/generate_colors.md)
  : Process the filling and border colors based on affection and
  availability

## Pedigree informations

Informations about the pedigree.

- [`kinship(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/kinship.md)
  [`kinship(`*`<character>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/kinship.md)
  [`kinship(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/kinship.md)
  : Kinship matrix
- [`ibd_matrix()`](https://louislenezet.github.io/Pedixplorer/reference/ibd_matrix.md)
  : IBD matrix
- [`num_child(`*`<character_OR_integer>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/num_child.md)
  [`num_child(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/num_child.md)
  : Number of childs
- [`is_informative(`*`<character_OR_integer>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/is_informative.md)
  [`is_informative(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/is_informative.md)
  [`is_informative(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/is_informative.md)
  : Find informative individuals
- [`family_infos_table()`](https://louislenezet.github.io/Pedixplorer/reference/family_infos_table.md)
  : Affection and availability information table
- [`unrelated(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/unrelated.md)
  [`unrelated(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/unrelated.md)
  : Find Unrelated subjects
- [`parent_of(`*`<character_OR_integer>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/parent_of.md)
  [`parent_of(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/parent_of.md)
  [`parent_of(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/parent_of.md)
  : Get parents of individuals
- [`is_parent(`*`<character_OR_integer>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/is_parent.md)
  [`is_parent(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/is_parent.md)
  : Are individuals parents
- [`make_famid(`*`<character>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/make_famid.md)
  [`make_famid(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/make_famid.md)
  : Compute family id
- [`upd_famid(`*`<character>`*`,`*`<ANY>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/upd_famid.md)
  [`upd_famid(`*`<Ped>`*`,`*`<character_OR_integer>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/upd_famid.md)
  [`upd_famid(`*`<Ped>`*`,`*`<missing>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/upd_famid.md)
  [`upd_famid(`*`<Rel>`*`,`*`<character_OR_integer>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/upd_famid.md)
  [`upd_famid(`*`<Rel>`*`,`*`<missing>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/upd_famid.md)
  [`upd_famid(`*`<Pedigree>`*`,`*`<character_OR_integer>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/upd_famid.md)
  [`upd_famid(`*`<Pedigree>`*`,`*`<missing>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/upd_famid.md)
  : Update family prefix in individuals id

## Pedigree filtering

Filtering methods to select a subset of individuals in a pedigree.

- [`useful_inds(`*`<character>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/useful_inds.md)
  [`useful_inds(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/useful_inds.md)
  [`useful_inds(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/useful_inds.md)
  : Usefulness of individuals
- [`min_dist_inf(`*`<character>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/min_dist_inf.md)
  [`min_dist_inf(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/min_dist_inf.md)
  [`min_dist_inf(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/min_dist_inf.md)
  : Minimum distance to the informative individuals
- [`shrink(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md)
  [`shrink(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/shrink.md)
  : Shrink Pedigree object
- [`bit_size(`*`<character_OR_integer>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/bit_size.md)
  [`bit_size(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/bit_size.md)
  [`bit_size(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/bit_size.md)
  : Bit size of a Pedigree
- [`find_avail_affected(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/find_avail_affected.md)
  [`find_avail_affected(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/find_avail_affected.md)
  : Find single affected and available individual from a Pedigree
- [`find_avail_noninform(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/find_avail_noninform.md)
  [`find_avail_noninform(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/find_avail_noninform.md)
  : Find uninformative but available subject
- [`find_unavailable(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/find_unavailable.md)
  [`find_unavailable(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/find_unavailable.md)
  : Find unavailable subjects in a Pedigree

## Pedigree datasets

Different datasets are available to test the package.

- [`minnbreast`](https://louislenezet.github.io/Pedixplorer/reference/minnbreast.md)
  : Minnesota Breast Cancer Study
- [`sampleped`](https://louislenezet.github.io/Pedixplorer/reference/sampleped.md)
  : Sampleped data
- [`relped`](https://louislenezet.github.io/Pedixplorer/reference/relped.md)
  : Relped data

## Pedigree alignment

Alignment methods to organize graphical representation of pedigrees.

- [`align(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/align.md)
  : Align a Pedigree object
- [`alignped1()`](https://louislenezet.github.io/Pedixplorer/reference/alignped1.md)
  : Alignment first routine
- [`alignped2()`](https://louislenezet.github.io/Pedixplorer/reference/alignped2.md)
  : Alignment second routine
- [`alignped3()`](https://louislenezet.github.io/Pedixplorer/reference/alignped3.md)
  : Alignment third routine
- [`alignped4()`](https://louislenezet.github.io/Pedixplorer/reference/alignped4.md)
  : Alignment fourth routine
- [`auto_hint(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/auto_hint.md)
  : Initial hint for a Pedigree alignment
- [`best_hint(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/best_hint.md)
  : Best hint for a Pedigree alignment
- [`kindepth(`*`<character_OR_integer>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/kindepth.md)
  [`kindepth(`*`<Pedigree>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/kindepth.md)
  [`kindepth(`*`<Ped>`*`)`](https://louislenezet.github.io/Pedixplorer/reference/kindepth.md)
  : Individual's depth in a pedigree

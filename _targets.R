library(targets)
library(tarchetypes)
tar_option_set(packages = c("ape", "phangorn", "tidyverse"))
tar_source()

# pipeline
list(

  # ─────────────────────────────────────────
  # Load D-PLACE data and phylogeny
  # ─────────────────────────────────────────

  # get data urls
  tar_target(
    dplace_data_url,
    paste0(
      "https://raw.githubusercontent.com/D-PLACE/dplace-cldf/",
      "6c2008c187a297d1955b41d8ae80d8e31d404f6c/cldf/data.csv"
    ),
    format = "url"
  ),
  tar_target(
    dplace_societies_url,
    paste0(
      "https://raw.githubusercontent.com/D-PLACE/dplace-cldf/",
      "6c2008c187a297d1955b41d8ae80d8e31d404f6c/cldf/societies.csv"
    ),
    format = "url"
  ),
  tar_target(
    glottolog_languages_url,
    paste0(
      "https://raw.githubusercontent.com/glottolog/glottolog-cldf/",
      "072ca0d0410039fb8b779be8fc165bac575d2cda/cldf/languages.csv"
    ),
    format = "url"
  ),

  # get tree file path
  tar_target(tree_file, "data/tree/dplace.nxs", format = "file"),

  # get world regions file path
  tar_target(world_regions_file, "data/world_regions/world_regions.csv",
             format = "file"),

  # load tree
  tar_target(tree, read.nexus(tree_file)),

  # load world regions
  tar_target(world_regions, read_csv(world_regions_file)),

  # compute maximum clade credibility tree
  tar_target(mcc_tree, phangorn::mcc(tree)),

  # load dplace data
  tar_target(
    data,
    load_dplace_data(
      dplace_data_url, dplace_societies_url,
      glottolog_languages_url, mcc_tree, world_regions
    )
  ),

  # write session info
  tar_target(
    sessionInfo,
    writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
  )

)

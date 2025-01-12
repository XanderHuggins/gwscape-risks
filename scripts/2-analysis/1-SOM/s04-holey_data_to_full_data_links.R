
# import the input data, that contains holes
input_stack_df = rast(here("data/01_risk_stack_scaled_alldata_noNAtrim.tif")) |> as_tibble() |> filter(id > 0)

# keep only the rows that have missing data
full_data_ids = terra::rast(here("data/01_risk_stack_scaled.tif")) |> 
  as_tibble() |> drop_na() |> pull(id)

input_stack_holes = input_stack_df |> filter(id %!in% full_data_ids)

# import the prototype data for classifying 
prototype_pts = readr::read_rds(here("data/som_files/som_files_full/som1_nrc_64_iter_52.rds"))
prototype_pts = prototype_pts$codes |> as.data.frame() |> as_tibble()
head(prototype_pts)

prototype_pts$id = 1:nrow(prototype_pts)
prototype_pts$area = rep(NA) # just so the function works

hole_anchor_snap = sand_grains_to_pebbles_membership(unsampled_points_df = input_stack_holes, 
                                                     sampled_points_df = prototype_pts, 
                                                     intvl = 1e4)

write_rds(hole_anchor_snap, file = here("data/02_holey_data_to_prototypes.rds"))


# 
# 
# 
# ## old approach below
# # import unsampled points and prototypes
# unsampled_pts = readr::read_rds(here("data/01_unsampled_points_holes_filled.rds"))
# 
# prototypes = readr::read_rds(here("data/som_files/som_selections/som1_nrc_34_iter_20.rds"))
# prototypes = prototypes$codes[[1]] |> as.data.frame()
# prototypes$id = c(1:nrow(prototypes))
# prototypes$area = rep(NA)
# 
# grain_membership = sand_grains_to_pebbles_membership(unsampled_points_df = unsampled_pts,
#                                                      sampled_points_df = prototypes,
#                                                      intvl = 1e4)
# 
# write_rds(grain_membership, file = here("data/02_membership_sand_to_prototypes.rds"))

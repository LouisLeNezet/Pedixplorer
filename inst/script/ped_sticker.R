#### Libraries needed ####
library(dplyr)
library(hexSticker)
library(Pedixplorer)
library(magick)

# Charge necessary data
data(sampleped)

# Create Pedigree object
ped1 <- Pedigree(
    sampleped[sampleped$famid == "1", -1],
)
dateofbirth(ped(ped1)) <- NA_character_
dateofdeath(ped(ped1)) <- NA_character_

rel(ped1) <- Rel(obj = "127", id2 = "128", code = "2")

border(ped1)[2, "border"] <- "#8aca25"
fill(ped1)[2, "fill"] <- "#3fb7db"

# Shrink Pedigree
ped1trim <- shrink(ped1, max_bits = 15)

# Export plot to png
output_dir <- "inst/figures/graph.png"
png(output_dir,
    width = 1000, height = 800,
    units = "px", bg = "#FFFFFF00", pointsize = 36)

Pedixplorer::plot(ped1trim$pedObj,
    cex = 0.8, symbolsize = 0.7, aff_mark = FALSE,
    lwd = 5,
    legend = TRUE, leg_cex = 0.5, leg_symbolsize = 0.035,
    leg_loc = c(0.2, 0.65, -0.13, -0.52),
    leg_adjx = 0, leg_adjy = -0.005,
    ped_par = list(cex = 1.2, lwd = 5, mar = c(5, 0.5, 0.5, 0.5)),
    leg_par = list(lwd = 5, mar = c(0.5, 0.5, 0.5, 0.5))
)

dev.off()

# Create sticker
hexSticker::sticker(
    output_dir,
    package = "Pedixplorer", p_size = 50, p_color = "#000000",
    p_x = 1, p_y = 1.5, p_family = "Aller_Rg",
    s_x = 1, s_y = 0.8, s_width = 0.7, s_height = 0.4,
    h_fill = "#FFFFFF", h_color = "#3792ad", h_size = 3,
    filename = "inst/figures/icon_Pedixplorer.png", dpi = 1000,
    white_around_sticker = TRUE
)

hexSticker::sticker(
    output_dir,
    package = "Pedixplorer", p_size = 5, p_color = "#000000",
    p_x = 1, p_y = 1.5, p_family = "Aller_Rg",
    s_x = 1, s_y = 0.8, s_width = 0.7, s_height = 0.4,
    h_fill = "#FFFFFF", h_color = "#3792ad", h_size = 3,
    filename = "inst/figures/icon_Pedixplorer.svg", dpi = 1000,
    white_around_sticker = TRUE
)

hexSticker::sticker(
    output_dir,
    package = "Pedixplorer", p_size = 5, p_color = "#000000",
    p_x = 1, p_y = 1.5, p_family = "Aller_Rg",
    s_x = 1, s_y = 0.8, s_width = 0.7, s_height = 0.4,
    h_fill = "#FFFFFF", h_color = "#3792ad", h_size = 3,
    filename = "inst/figures/icon_Pedixplorer.pdf", dpi = 1000,
    white_around_sticker = TRUE
)

# Load the sticker
sticker <- image_read("inst/figures/icon_Pedixplorer.png")

# Remove the white background while keeping the full border
sticker_transp <- sticker |>
    image_fill(
        color = "transparent", refcolor = "white",
        fuzz = 4, point = "+100+100"
    ) |>
    image_fill(
        color = "transparent", refcolor = "white",
        fuzz = 4, point = "+1600+1800"
    ) |>
    image_fill(
        color = "transparent", refcolor = "white",
        fuzz = 4, point = "+1600+100"
    ) |>
    image_fill(
        color = "transparent", refcolor = "white",
        fuzz = 4, point = "+100+1800"
    )

# Save the final transparent sticker
image_write(sticker_transp, path = "inst/figures/icon_Pedixplorer.png")

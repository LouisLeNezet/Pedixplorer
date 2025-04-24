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

rel(ped1) <- Rel(obj = "127", id2 = "128", code = "2")

border(ped1)[2, "border"] <- "#8aca25"
fill(ped1)[2, "fill"] <- "#3fb7db"

# Shrink Pedigree
ped1trim <- shrink(ped1, max_bits = 12)

# Export plot to png
output_dir <- "inst/figures/graph.png"
png(output_dir,
    width = 1300, height = 900,
    units = "px", bg = "#FFFFFF00", pointsize = 36)

plot(ped1trim$pedObj,
    cex = 1.5, symbolsize = 1.1, aff_mark = FALSE,
    mar = c(4, 0.5, 0.5, 0.5), oma = c(0, 0, 0, 0),
    lwd = 8
)

op <- par(oma = c(0, 0, 0, 0), mar = c(0.5, 0.5, 0.5, 0.5))
plot_legend(
    ped1trim$pedObj, cex = 0.8, add_to_existing = TRUE,
    leg_loc = c(0.2, 5.5, 4.1, 5), boxw = 0.2, boxh = 0.18,
    adjx = 1, adjy = 0.12, lwd = 5
)
dev.off()
dev.off()

# Create sticker
hexSticker::sticker(
    output_dir,
    package = "Pedixplorer", p_size = 50, p_color = "#000000",
    p_x = 1, p_y = 1.5,
    s_x = 1, s_y = 0.85, s_width = 0.7, s_height = 0.4,
    h_fill = "#FFFFFF", h_color = "#3792ad", h_size = 3,
    filename = "inst/figures/icon_Pedixplorer.png", dpi = 1000,
    white_around_sticker = TRUE
)

# Load the sticker
sticker <- image_read("inst/figures/icon_Pedixplorer.png")

# Remove the white background while keeping the full border
sticker_transp <- sticker %>%
    image_fill(
        color = "transparent", refcolor = "white",
        fuzz = 4, point = "+100+100"
    ) %>%
    image_fill(
        color = "transparent", refcolor = "white",
        fuzz = 4, point = "+1600+1800"
    ) %>%
    image_fill(
        color = "transparent", refcolor = "white",
        fuzz = 4, point = "+1600+100"
    ) %>%
    image_fill(
        color = "transparent", refcolor = "white",
        fuzz = 4, point = "+100+1800"
    )

# Save the final transparent sticker
image_write(sticker_transp, path = "inst/figures/icon_Pedixplorer.png")

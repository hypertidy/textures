u <- "https://vignette.wikia.nocookie.net/bobsburgerpedia/images/6/6e/Tina_render.png"
usethis::use_directory("inst/extdata")
download.file(u,file.path("inst/extdata", "Tina_render.png"), mode = "wb")

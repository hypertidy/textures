u <- "https://www.r-project.org/logo/Rlogo.png"
f <- "inst/extdata/Rlogo.png"
if (!file.exists(f)) download.file(u, f, mode = "wb")

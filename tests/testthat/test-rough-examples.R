test_that("rough examples work", {
  src <- system.file("rough-examples/rough-examples.R", package = "textures")
  expect_warning(source(src))
})

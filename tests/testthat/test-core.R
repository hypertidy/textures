test_that("quad_index matches the R reference implementation", {
  ib_ref <- textures:::ib_index
  for (ydown in c(FALSE, TRUE)) {
    for (dm in list(c(1L, 1L), c(2L, 3L), c(5L, 4L), c(7L, 1L), c(1L, 6L))) {
      expect_identical(quad_index(dm, ydown = ydown),
                       ib_ref(dm[1L], dm[2L], ydown = ydown))
    }
  }
  ## single dimension value is recycled
  expect_identical(quad_index(3L), quad_index(c(3L, 3L)))
  expect_error(quad_index(c(0, 1)))
  expect_error(quad_index(NA))
})

test_that("double index path agrees with integer path", {
  expect_false(textures:::.needs_double_index(c(1000L, 1000L)))
  expect_true(textures:::.needs_double_index(c(50000L, 50000L)))
  ## values > 2^31 vertex count force doubles, small grids stay integer
  expect_true(is.integer(quad_index(c(3L, 2L))))
  for (ydown in c(FALSE, TRUE)) {
    i_int <- quad_index(c(3L, 2L), ydown = ydown)
    i_dbl <- matrix(textures:::quad_index_dbl_cpp(3, 2, ydown) + 1, 4L)
    expect_true(is.double(i_dbl))
    expect_true(all(i_int == i_dbl))
  }
})

test_that("quad_edges gives the unexpanded margins", {
  e <- quad_edges(c(2L, 3L), extent = c(0, 10, 0, 30))
  expect_identical(e$x, c(0, 5, 10))
  expect_identical(e$y, c(0, 10, 20, 30))
  ## default extent is the unit square
  e01 <- quad_edges(c(2L, 2L))
  expect_identical(e01$x, c(0, 0.5, 1))
  ## ydown reverses y
  ed <- quad_edges(c(2L, 2L), ydown = TRUE)
  expect_identical(ed$y, c(1, 0.5, 0))
})

test_that("quad_vertex is the expansion of quad_edges, x fastest", {
  dm <- c(3L, 2L)
  ext <- c(-5, 5, 100, 200)
  e <- quad_edges(dm, ext)
  v <- quad_vertex(dm, ext)
  expect_identical(dim(v), c((dm[1L] + 1L) * (dm[2L] + 1L), 2L))
  expect_identical(unname(v[, 1L]), rep(e$x, times = length(e$y)))
  expect_identical(unname(v[, 2L]), rep(e$y, each = length(e$x)))
  ## matches materialized mesh vertices
  q <- quad(dm, extent = ext)
  expect_identical(t(unname(q$vb[1:2, ])), unname(v))
})

test_that("quad_spec materializes identically to quad()", {
  for (ydown in c(FALSE, TRUE)) {
    spec <- quad_spec(c(5L, 4L), extent = c(0, 10, 0, 8), ydown = ydown)
    expect_s3_class(spec, "quad_spec")
    m <- quad_mesh(spec)
    q <- quad(c(5L, 4L), extent = c(0, 10, 0, 8), ydown = ydown)
    expect_identical(m, q)
  }
  ## the spec is a plain serializable list
  spec <- quad_spec(c(2L, 2L), extent = c(0, 1, 0, 1))
  expect_identical(spec, unserialize(serialize(spec, NULL)))
  expect_output(print(spec), "quad_spec")
})

test_that("texture coordinates are extent-normalized vertices", {
  tf <- tempfile(fileext = ".png")
  file.create(tf)
  spec <- quad_spec(c(2L, 2L), extent = c(100, 200, -50, 0), texture = tf)
  m <- quad_mesh(spec)
  expect_identical(dim(m$texcoords), c(2L, 9L))
  expect_identical(range(m$texcoords), c(0, 1))
  expect_identical(m$material$texture, tf)
  ## same as the long-standing quad_texture() convention
  qt <- quad_texture(c(2L, 2L), extent = c(100, 200, -50, 0), texture = tf)
  expect_true(all(qt$texcoords == m$texcoords))
  ## missing texture file warns at spec creation
  expect_warning(quad_spec(c(1L, 1L), texture = "no-such-file.png"), "does not exist")
  unlink(tf)
})

test_that("mesh construction does not require rgl", {
  ## the mesh3d object is constructed directly
  m <- quad_mesh(quad_spec(c(2L, 2L)))
  expect_s3_class(m, "mesh3d")
  expect_identical(names(m), c("vb", "material", "normals", "texcoords",
                               "meshColor", "ib"))
})

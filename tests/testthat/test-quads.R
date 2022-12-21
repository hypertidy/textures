
## the boilerplate, no vb, no ib
qmesh_hull <- list(material = list(color = "#FFFFFFFF"), normals = NULL, texcoords = NULL,
                   meshColor = "vertices")

test_that("quad works, basic 1x1 canvas", {

  ## default is 1x1, ydown = FALSE
  q0 <- quad()
  expect_equal(q0, quad(c(1L, 1L)))
  expect_equal(q0$vb,
               structure(c(0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1), .Dim = c(4L,4L)))
  expect_equal(q0$ib,
               structure(c(1L, 2L, 4L, 3L), .Dim = c(4L, 1L)))

  expect_equal(q0[-c(1, length(q0))], qmesh_hull)

  ## --- break the mesh and we have a different orientation, because the vertices
  ## are now in the order they are indexed and no index is repeated
  qu <- break_mesh(quad())
  expect_equal(qu, break_mesh(quad(c(1L, 1L))))


  expect_equal(qu$vb,
               structure(c(0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1), .Dim = c(4L,
                                                                                     4L))
              )

  expect_equal(qu$ib,
               structure(1:4, .Dim = c(4L, 1L))
               )



  expect_warning(qt <- quad_texture(), "texture file given does not exist")
  expect_warning(qty <- quad_texture(ydown = TRUE), "texture file given does not exist")

  expect_null( q0$texcoords)
  expect_equal(qt$texcoords, q0$vb[1:2, ])
  expect_false(all(qt$vb == qty$vb))
  expect_equal(qty$vb, structure(c(0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1), .Dim = c(4L,
                                                                                     4L)))

})

## these fail, need to fix
test_that("these don't fail", {

  skip("skipping test")
  expect_warning(qty <- quad_texture(ydown = TRUE), "texture file given does not exist")

  expect_equal(qty$ib, structure(c(3L, 4L, 2L, 1L), .Dim = c(4L, 1L)))

  expect_equal(qty, structure(list(vb = structure(c(0, 1, 0, 1, 1, 1, 0, 1, 0, 0,
                                                    0, 1, 1, 0, 0, 1), .Dim = c(4L, 4L)), ib = structure(c(3L, 4L,
                                                  2L, 1L), .Dim = c(4L, 1L)), material = list(color = "#FFFFFFFF",
                                                  texture = ""), normals = NULL, texcoords = structure(c(0,
                                                  1, 1, 1, 0, 0, 1, 0), .Dim = c(2L, 4L)), meshColor = "vertices"), class = c("mesh3d",
                                                  "shape3d")))

  expect_equal(quad(2L), quad(c(2L, 2L)))
  expect_equal(quad(1L), quad(c(1L, 1L)))
  expect_equal(expect_warning(quad_texture(2L)), expect_warning(quad_texture(c(2L, 2L))))
  expect_equal(expect_warning(quad_texture(1L)), expect_warning(quad_texture(c(1L, 1L))))

})

vb_5x4 <- structure(c(0, 0, 0, 1, 0.2, 0, 0, 1, 0.4, 0, 0, 1, 0.6, 0, 0,
                        1, 0.8, 0, 0, 1, 1, 0, 0, 1, 0, 0.25, 0, 1, 0.2, 0.25, 0, 1,
                        0.4, 0.25, 0, 1, 0.6, 0.25, 0, 1, 0.8, 0.25, 0, 1, 1, 0.25, 0,
                        1, 0, 0.5, 0, 1, 0.2, 0.5, 0, 1, 0.4, 0.5, 0, 1, 0.6, 0.5, 0,
                        1, 0.8, 0.5, 0, 1, 1, 0.5, 0, 1, 0, 0.75, 0, 1, 0.2, 0.75, 0,
                        1, 0.4, 0.75, 0, 1, 0.6, 0.75, 0, 1, 0.8, 0.75, 0, 1, 1, 0.75,
                        0, 1, 0, 1, 0, 1, 0.2, 1, 0, 1, 0.4, 1, 0, 1, 0.6, 1, 0, 1, 0.8,
                        1, 0, 1, 1, 1, 0, 1), .Dim = c(4L, 30L))
ib_5x4 <- structure(c(1L, 2L, 8L, 7L, 7L, 8L, 14L, 13L, 13L, 14L, 20L,
                      19L, 19L, 20L, 26L, 25L, 2L, 3L, 9L, 8L, 8L, 9L, 15L, 14L, 14L,
                      15L, 21L, 20L, 20L, 21L, 27L, 26L, 3L, 4L, 10L, 9L, 9L, 10L,
                      16L, 15L, 15L, 16L, 22L, 21L, 21L, 22L, 28L, 27L, 4L, 5L, 11L,
                      10L, 10L, 11L, 17L, 16L, 16L, 17L, 23L, 22L, 22L, 23L, 29L, 28L,
                      5L, 6L, 12L, 11L, 11L, 12L, 18L, 17L, 17L, 18L, 24L, 23L, 23L,
                      24L, 30L, 29L), .Dim = c(4L, 20L))

vb_5x4_unmesh <- structure(c(0, 0, 0, 1, 0.2, 0, 0, 1, 0.2, 0.25, 0, 1, 0, 0.25,
                             0, 1, 0, 0.25, 0, 1, 0.2, 0.25, 0, 1, 0.2, 0.5, 0, 1, 0, 0.5,
                             0, 1, 0, 0.5, 0, 1, 0.2, 0.5, 0, 1, 0.2, 0.75, 0, 1, 0, 0.75,
                             0, 1, 0, 0.75, 0, 1, 0.2, 0.75, 0, 1, 0.2, 1, 0, 1, 0, 1, 0,
                             1, 0.2, 0, 0, 1, 0.4, 0, 0, 1, 0.4, 0.25, 0, 1, 0.2, 0.25, 0,
                             1, 0.2, 0.25, 0, 1, 0.4, 0.25, 0, 1, 0.4, 0.5, 0, 1, 0.2, 0.5,
                             0, 1, 0.2, 0.5, 0, 1, 0.4, 0.5, 0, 1, 0.4, 0.75, 0, 1, 0.2, 0.75,
                             0, 1, 0.2, 0.75, 0, 1, 0.4, 0.75, 0, 1, 0.4, 1, 0, 1, 0.2, 1,
                             0, 1, 0.4, 0, 0, 1, 0.6, 0, 0, 1, 0.6, 0.25, 0, 1, 0.4, 0.25,
                             0, 1, 0.4, 0.25, 0, 1, 0.6, 0.25, 0, 1, 0.6, 0.5, 0, 1, 0.4,
                             0.5, 0, 1, 0.4, 0.5, 0, 1, 0.6, 0.5, 0, 1, 0.6, 0.75, 0, 1, 0.4,
                             0.75, 0, 1, 0.4, 0.75, 0, 1, 0.6, 0.75, 0, 1, 0.6, 1, 0, 1, 0.4,
                             1, 0, 1, 0.6, 0, 0, 1, 0.8, 0, 0, 1, 0.8, 0.25, 0, 1, 0.6, 0.25,
                             0, 1, 0.6, 0.25, 0, 1, 0.8, 0.25, 0, 1, 0.8, 0.5, 0, 1, 0.6,
                             0.5, 0, 1, 0.6, 0.5, 0, 1, 0.8, 0.5, 0, 1, 0.8, 0.75, 0, 1, 0.6,
                             0.75, 0, 1, 0.6, 0.75, 0, 1, 0.8, 0.75, 0, 1, 0.8, 1, 0, 1, 0.6,
                             1, 0, 1, 0.8, 0, 0, 1, 1, 0, 0, 1, 1, 0.25, 0, 1, 0.8, 0.25,
                             0, 1, 0.8, 0.25, 0, 1, 1, 0.25, 0, 1, 1, 0.5, 0, 1, 0.8, 0.5,
                             0, 1, 0.8, 0.5, 0, 1, 1, 0.5, 0, 1, 1, 0.75, 0, 1, 0.8, 0.75,
                             0, 1, 0.8, 0.75, 0, 1, 1, 0.75, 0, 1, 1, 1, 0, 1, 0.8, 1, 0,
                             1), .Dim = c(4L, 80L))

ib_5x4_unmesh <- structure(1:80, .Dim = c(4L, 20L))
test_that("quad works, 5x4 canvas", {

  skip("reinstate this")
  ## default is 1x1, ydown = FALSE
  q1 <- quad(c(5, 4))

  expect_equal(q1$vb,
               vb_5x4)
  expect_equal(q1$ib,
               ib_5x4)
  expect_equal(q1[-c(1, length(q1))], qmesh_hull)

  ## --- break the mesh and we have a different orientation, because the vertices
  ## are now in the order they are indexed and no index is repeated
  qu1 <- break_mesh(quad(c(5, 4)))
  expect_equal(qu1, break_mesh(quad(c(5L, 4L))))


  expect_equal(qu1$vb,
               vb_5x4_unmesh
)

  expect_equal(qu1$ib,
               ib_5x4_unmesh
  )




})

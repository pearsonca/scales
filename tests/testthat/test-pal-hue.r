test_that("hue_pal arguments are forcely evaluated on each call #81", {
  col1 <- hue_pal(h.start = 0)
  col2 <- hue_pal(h.start = 90)

  colours <- list()
  hues <- c(0, 90)
  for (i in 1:2) {
    colours[[i]] <- hue_pal(h.start = hues[i])
  }
  expect_equal(col1(1), colours[[1]](1))
  expect_equal(col2(1), colours[[2]](1))
})

test_that("hue_pal respects direction argument #252", {
  col1 <- hue_pal()
  col2 <- hue_pal(direction = -1)

  expect_equal(col1(3), rev(col2(3)))
  expect_equal(col1(9), rev(col2(9)))
})

test_that("hue_pal respects h.start", {
  hue <- function(...) {
    farver::decode_colour(hue_pal(...)(2), to = "hcl")[, "h"]
  }

  # Have to use large tolerance since we're generating out of gamut colours.
  expect_equal(hue(), c(15, 195), tolerance = 0.1)
  expect_equal(hue(h.start = 30), c(45, 235), tolerance = 0.1)
})

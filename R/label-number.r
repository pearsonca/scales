#' Label numbers in decimal format (e.g. 0.12, 1,234)
#'
#' Use `label_number()` force decimal display of numbers (i.e. don't use
#' [scientific][label_scientific] notation). `label_comma()` is a special case
#' that inserts a comma every three digits.
#'
#' @return
#' All `label_()` functions return a "labelling" function, i.e. a function that
#' takes a vector `x` and returns a character vector of `length(x)` giving a
#' label for each input value.
#'
#' Labelling functions are designed to be used with the `labels` argument of
#' ggplot2 scales. The examples demonstrate their use with x scales, but
#' they work similarly for all scales, including those that generate legends
#' rather than axes.
#'
#' @param accuracy A number to round to. Use (e.g.) `0.01` to show 2 decimal
#'   places of precision. If `NULL`, the default, uses a heuristic that should
#'   ensure breaks have the minimum number of digits needed to show the
#'   difference between adjacent values.
#'
#'   Applied to rescaled data.
#' @param scale A scaling factor: `x` will be multiplied by `scale` before
#'   formatting. This is useful if the underlying data is very small or very
#'   large.
#' @param prefix Additional text to display before the number. The suffix is
#'   applied to absolute value before `style_positive` and `style_negative` are
#'   processed so that `prefix = "$"` will yield (e.g.) `-$1` and `($1)`.
#' @param suffix Additional text to display after the number.
#' @param big.mark Character used between every 3 digits to separate thousands.
#' @param decimal.mark The character to be used to indicate the numeric
#'   decimal point.
#' @param style_positive A string that determines the style of positive numbers:
#'
#'   * `"none"` (the default): no change, e.g. `1`.
#'   * `"plus"`: preceded by `+`, e.g. `+1`.
#' @param style_negative A string that determines the style of negative numbers:
#'
#'   * `"hyphen"` (the default): preceded by a standard hypen `-`, e.g. `-1`.
#'   * `"minus"`, uses a proper Unicode minus symbol. This is a typographical
#'      nicety that ensures `-` aligns with the horizontal bar of the
#'      the horizontal bar of `+`.
#'   * `"parens"`, wrapped in parentheses, e.g. `(1)`.
#' @param scale_cut Named numeric vector that allows you to rescale large
#'   (or small) numbers and add a prefix. Built-in helpers include:
#'   * `cut_short_scale()`: [10^3, 10^6) = K, [10^6, 10^9) = M, [10^9, 10^12) = B, [10^12, Inf) = T.
#'   * `cut_long_scale()`: [10^3, 10^6) = K, [10^6, 10^12) = M, [10^12, 10^18) = B, [10^18, Inf) = T.
#'   * `cut_si(unit)`: uses standard SI units.
#'
#'   If you supply a vector `c(a = 100, b = 1000)`, absolute values in the
#'   range `[0, 100)` will not be rescaled, absolute values in the range `[100, 1000)`
#'   will be divided by 100 and given the suffix "a", and absolute values in
#'   the range `[1000, Inf)` will be divided by 1000 and given the suffix "b".
#' @param trim Logical, if `FALSE`, values are right-justified to a common
#'   width (see [base::format()]).
#' @param ... Other arguments passed on to [base::format()].
#' @export
#' @examplesIf getRversion() >= "3.5"
#' demo_continuous(c(-1e6, 1e6))
#' demo_continuous(c(-1e6, 1e6), labels = label_number())
#' demo_continuous(c(-1e6, 1e6), labels = label_comma())
#'
#' # Use scale to rescale very small or large numbers to generate
#' # more readable labels
#' demo_continuous(c(0, 1e6), labels = label_number())
#' demo_continuous(c(0, 1e6), labels = label_number(scale = 1 / 1e3))
#' demo_continuous(c(0, 1e-6), labels = label_number())
#' demo_continuous(c(0, 1e-6), labels = label_number(scale = 1e6))
#'
#' #' Use scale_cut to automatically add prefixes for large/small numbers
#' demo_log10(
#'   c(1, 1e9),
#'   breaks = log_breaks(10),
#'   labels = label_number(scale_cut = cut_short_scale())
#' )
#' demo_log10(
#'   c(1, 1e9),
#'   breaks = log_breaks(10),
#'   labels = label_number(scale_cut = cut_si("m"))
#' )
#' demo_log10(
#'   c(1e-9, 1),
#'   breaks = log_breaks(10),
#'   labels = label_number(scale_cut = cut_si("g"))
#' )
#' # use scale and scale_cut when data already uses SI prefix
#' # for example, if data was stored in kg
#' demo_log10(
#'   c(1e-9, 1),
#'   breaks = log_breaks(10),
#'   labels = label_number(scale_cut = cut_si("g"), scale = 1e3)
#' )
#'
#' #' # Use style arguments to vary the appearance of positive and negative numbers
#' demo_continuous(c(-1e3, 1e3), labels = label_number(
#'   style_positive = "plus",
#'   style_negative = "minus"
#' ))
#' demo_continuous(c(-1e3, 1e3), labels = label_number(style_negative = "parens"))
#'
#' # You can use prefix and suffix for other types of display
#' demo_continuous(c(32, 212), labels = label_number(suffix = "\u00b0F"))
#' demo_continuous(c(0, 100), labels = label_number(suffix = "\u00b0C"))
label_number <- function(accuracy = NULL, scale = 1, prefix = "",
                         suffix = "", big.mark = " ", decimal.mark = ".",
                         style_positive = c("none", "plus"),
                         style_negative = c("hyphen", "minus", "parens"),
                         scale_cut = NULL,
                         trim = TRUE, ...) {
  force_all(
    accuracy,
    scale,
    prefix,
    suffix,
    big.mark,
    decimal.mark,
    style_positive,
    style_negative,
    scale_cut,
    trim,
    ...
  )
  function(x) {
    number(
      x,
      accuracy = accuracy,
      scale = scale,
      prefix = prefix,
      suffix = suffix,
      big.mark = big.mark,
      decimal.mark = decimal.mark,
      style_positive = style_positive,
      style_negative = style_negative,
      scale_cut = scale_cut,
      trim = trim,
      ...
    )
  }
}


#' @export
#' @rdname label_number
#' @param digits `r lifecycle::badge("deprecated")` Use `accuracy` instead.
label_comma <- function(accuracy = NULL, scale = 1, prefix = "",
                        suffix = "", big.mark = ",", decimal.mark = ".",
                        trim = TRUE, digits, ...) {
  if (!missing(digits)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "label_comma(digits)",
      with = "label_comma(accuracy)"
    )
  }
  number_format(
    accuracy = accuracy,
    scale = scale,
    prefix = prefix,
    suffix = suffix,
    big.mark = big.mark,
    decimal.mark = decimal.mark,
    trim = trim,
    ...
  )
}

#' Superseded interface to `label_number()`/`label_comma()`
#'
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' These functions are kept for backward compatibility; you should switch
#' to [label_number()]/[label_comma()] for new code.
#'
#' @keywords internal
#' @export
#' @inheritParams label_number
#' @param x A numeric vector to format.
comma <- function(x, accuracy = NULL, scale = 1, prefix = "",
                  suffix = "", big.mark = ",", decimal.mark = ".",
                  trim = TRUE, digits, ...) {
  if (!missing(digits)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "comma(digits)",
      with = "comma(accuracy)"
    )
  }
  number(
    x = x,
    accuracy = accuracy,
    scale = scale,
    prefix = prefix,
    suffix = suffix,
    big.mark = big.mark,
    decimal.mark = decimal.mark,
    trim = trim,
    ...
  )
}

#' @export
#' @rdname comma
number_format <- label_number

#' @export
#' @rdname comma
comma_format <- label_comma

#' A low-level numeric formatter
#'
#' This function is a low-level helper that powers many of the labelling
#' functions. You should generally not need to call it directly unless you
#' are creating your own labelling function.
#'
#' @keywords internal
#' @export
#' @inheritParams label_number
#' @return A character vector of `length(x)`.
number <- function(x, accuracy = NULL, scale = 1, prefix = "",
                   suffix = "", big.mark = " ", decimal.mark = ".",
                   style_positive = c("none", "plus"),
                   style_negative = c("hyphen", "minus", "parens"),
                   scale_cut = NULL,
                   trim = TRUE, ...) {
  if (length(x) == 0) {
    return(character())
  }

  style_positive <- arg_match(style_positive)
  style_negative <- arg_match(style_negative)

  if (!is.null(scale_cut)) {
    cut <- scale_cut(x,
      breaks = scale_cut,
      scale = scale,
      accuracy = accuracy,
      suffix = suffix
    )

    scale <- cut$scale
    suffix <- cut$suffix
    accuracy <- cut$accuracy
  }

  accuracy <- accuracy %||% precision(x * scale)
  x <- round_any(x, accuracy / scale)
  nsmalls <- -floor(log10(accuracy))
  nsmalls <- pmin(pmax(nsmalls, 0), 20)

  sign <- sign(x)
  sign[is.na(sign)] <- 0
  x <- abs(x)
  x_scaled <- scale * x

  ret <- character(length(x))
  for (nsmall in unique(nsmalls)) {
    idx <- nsmall == nsmalls

    ret[idx] <- format(
      x_scaled[idx],
      big.mark = big.mark,
      decimal.mark = decimal.mark,
      trim = trim,
      nsmall = nsmall,
      scientific = FALSE,
      ...
    )
  }

  ret <- paste0(prefix, ret, suffix)
  ret[is.infinite(x)] <- as.character(x[is.infinite(x)])

  if (style_negative == "hyphen") {
    ret[sign < 0] <- paste0("-", ret[sign < 0])
  } else if (style_negative == "minus") {
    ret[sign < 0] <- paste0("\u2212", ret[sign < 0])
  } else if (style_negative == "parens") {
    ret[sign < 0] <- paste0("(", ret[sign < 0], ")")
  }
  if (style_positive == "plus") {
    ret[sign > 0] <- paste0("+", ret[sign > 0])
  }

  # restore NAs from input vector
  ret[is.na(x)] <- NA
  names(ret) <- names(x)

  ret
}


# Helpers -----------------------------------------------------------------

precision <- function(x) {
  x <- unique(x)
  # ignore NA and Inf/-Inf
  x <- x[is.finite(x)]

  if (length(x) <= 1) {
    return(1)
  }

  smallest_diff <- min(diff(sort(x)))
  if (smallest_diff < sqrt(.Machine$double.eps)) {
    1
  } else {
    precision <- 10^(floor(log10(smallest_diff)) - 1)

    # reduce precision when final digit always 0
    if (all(round(x / precision) %% 10 == 0)) {
      precision <- precision * 10
    }

    # Never return precision bigger than 1
    pmin(precision, 1)
  }
}

# each value of x is assigned a suffix and associated scaling factor
scale_cut <- function(x, breaks, scale = 1, accuracy = NULL, suffix = "") {

  if (!is.numeric(breaks) || is.null(names(breaks))) {
    abort("`scale_cut` must be a named numeric vector")
  }
  breaks <- sort(breaks, na.last = TRUE)
  if (any(is.na(breaks))) {
    abort("`scale_cut` values must not be missing")
  }
  if (!identical(breaks[[1]], 0) && !identical(breaks[[1]], 0L)) {
    abort("Smallest value of `scales_cut` must be zero")
  }

  break_suffix <- as.character(cut(
    abs(x * scale),
    breaks = c(unname(breaks), Inf),
    labels = c(names(breaks)),
    right = FALSE
  ))
  break_suffix[is.na(break_suffix)] <- names(which.min(breaks))

  break_scale <- scale * unname(1 / breaks[break_suffix])
  break_scale[which(break_scale %in% c(Inf, NA))] <- scale

  # exact zero is not scaled
  x_zero <- which(abs(x) == 0)
  scale[x_zero] <- 1

  suffix <- paste0(break_suffix, suffix)
  accuracy <- accuracy %||% stats::ave(x * break_scale, break_scale, FUN = precision)

  list(
    scale = break_scale,
    suffix = suffix,
    accuracy = accuracy
  )
}

#' #' See [Metric Prefix](https://en.wikipedia.org/wiki/Metric_prefix) on Wikipedia
#' for more details.

#' @export
#' @rdname number
#' @param space Add a space before the scale suffix?
cut_short_scale <- function(space = FALSE) {
  out <- c(0, K = 1e3, M = 1e6, B = 1e9, T = 1e12)
  if (space) {
    names(out) <- paste0(" ", names(out))
  }
  out
}

#' @export
#' @rdname number
cut_long_scale <- function(space = FALSE) {
  out <- c(0, K = 1e3, M = 1e6, B = 1e12, T = 1e18)
  if (space) {
    names(out) <- paste0(" ", names(out))
  }
  out
}

# power-of-ten prefixes used by the International System of Units (SI)
# https://www.bipm.org/en/measurement-units/prefixes.html
#
# note: irregular prefixes (hecto, deca, deci, centi) are not stored
# because they don't commonly appear in scientific usage anymore
si_powers <- c(
  y = -24, z = -21, a = -18, f = -15,
  p = -12, n =  -9, micro = -6, m = -3,
  0,
  k =  3, M =  6, G =  9, T = 12,
  P = 15, E = 18, Z = 21, Y = 24
)
# Avoid using UTF8 as symbol
names(si_powers)[si_powers == -6] <- "\u00b5"

#' @export
#' @rdname number
#' @param unit SI unit abbreviation.
cut_si <- function(unit) {
  out <- c(0, 10^si_powers)
  names(out) <- c(paste0(" ", unit), paste0(" ", names(si_powers), unit))
  out
}

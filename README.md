RStudio Addins
==============

RStudio addins are R functions that can be called through RStudio. This package
provides a small set of example addins, and helps demonstrate how package
authors can create and expose their own addins.

Addins are just R functions with a bit of special registration metadata. Within
[R/addins.R](https://github.com/rstudio/rstudioaddins/blob/master/R/addins.R),
a couple of functions are defined. The associated registration metadata is contained
within
[inst/rstudio/addins.dcf](https://github.com/rstudio/rstudioaddins/blob/master/inst/rstudio/addins.dcf).

When RStudio is launched, it will automatically discover addins registered by
installed R packages, and register them so that they can be invoked through
keyboard shortcuts and other UI gestures. See [this support
article](https://support.rstudio.com/hc/en-us/articles/215605467) for more
details.

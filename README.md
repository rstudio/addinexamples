RStudio Addins
==============

RStudio addins are R functions that can be called through RStudio. This
package provides a small set of example addins, and helps demonstrate how
package authors can create and expose their own addins.

Addins are just R functions with a bit of special registration metadata. Within
[R/addins.R](https://github.com/rstudio/rstudioaddins/blob/master/R/addins.R),
three functions are created.

The associated registration metadata is contained within
[inst/rstudio/addins.dcf](https://github.com/rstudio/rstudioaddins/blob/master/inst/rstudio/addins.dcf).
RStudio will automatically discover these files when it is launched, and
register them so that they can be invoked through keyboard shortcuts and other
UI gestures.

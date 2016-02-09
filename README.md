RStudio Addins
==============

RStudio addins are R functions that can be called through RStudio. This package
provides a small set of example addins, and helps demonstrate how package
authors can create and expose their own addins.

Installation
------------

First, ensure that you have the latest versions of
[htmltools](https://github.com/rstudio/htmltools),
[shiny](https://github.com/rstudio/shiny), and
[miniUI](https://github.com/rstudio/miniUI);
then install this package.

```r
if (!requireNamespace("devtools", quietly = TRUE))
  install.packages("devtools")

devtools::install_github("rstudio/htmltools")
devtools::install_github("rstudio/shiny")
devtools::install_github("rstudio/miniUI")
devtools::install_github("rstudio/addinexamples")
```

What's an Addin?
----------------

Addins are just R functions with a bit of special registration metadata. This
package exports two simple addins: one function,
[insertInAddin](https://github.com/rstudio/addinexamples/blob/master/R/insertInAddin.R),
can be used to insert ' %in% ' at the cursor position. Another,
[findAndReplaceAddin](https://github.com/rstudio/addinexamples/blob/master/R/findAndReplaceAddin.R),
can be used to interactively refactor code in a document, using a Shiny application.
These addins are registered through a Debian Control File, located at
[inst/rstudio/addins.dcf](https://github.com/rstudio/addinexamples/blob/master/inst/rstudio/addins.dcf).

When RStudio is launched, it will automatically discover addins registered by
installed R packages, and register them so that they can be invoked through
keyboard shortcuts and other UI gestures. See the
[RStudio Addins website](http://rstudio.github.io/rstudioaddins/)
for more details.

tsgames
==========

The `tsgames` package is a collection of games written by the [TalkStats community](http://www.talkstats.com)
    
## Installation

Currently there isn't a release on [CRAN](http://cran.r-project.org/).

You can, however, download the [zip ball](https://github.com/TalkStats/tsgames/zipball/master) or [tar ball](https://github.com/TalkStats/tsgames/tarball/master), decompress and run `R CMD INSTALL` on it, or use the **devtools** package to install the development version:

```r
## Make sure your current packages are up to date
update.packages()
## devtools is required
library(devtools)
install_github("tsgames", "TalkStats")
```

# factnum

factnum provides a new sequential method to determine the number of factors in exploratory factor models.



## Features

* a more efficient and accurate function to determine the number of factors, compared to traditional LRT method and Bartlett-corrected LRT method.
* Only require a data matrix to be the input.


## Installation

To install the latest development builds directly from GitHub, run the following code:

```R
if (!require("devtools"))
  install.packages("devtools")
devtools::install_github("tlwangzi123/factnum")
```

### How to use

* First, we generate a data matrix, which contains some factors.

```R
library(factnum)
n = 50
p = 7
rho = 0.5
mat = matrix(rep(rho,p), ncol = 1)  
phi = diag(apply(mat, 1, function(x) 1-x[1]^2))
sigma_m = mat %*% t(mat) + phi
x = rnorm(n*p)
dim(x) = c(n,p)
r = chol(sigma_m)
m = x %*% r  # data m contain 1 factor, since rank(mat) = 1
```

* Second, we run factnum() function.

```R
k = fact_num(m)
k
```



## Stay In Touch

- For latest releases and announcements, follow on GitHub: [@tlwangzi123](https://github.com/tlwangzi123)


## License

[MIT](http://opensource.org/licenses/MIT)

Copyright (c) 2020-present, Zi Wang (tlwangzi@umich.edu) 

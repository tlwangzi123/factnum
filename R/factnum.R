#' Determine the number of factors in exploratory factor models
#' 
#' This function uses a new sequential method proposed in the paper to 
#' determine the number of factors in exploratory factor models. 
#' It returns an integer, representing the number of factors.
#' 
#'  @param data The data matrix used for exploratory factor analysis.
#'  
#'  @export
#'  
#'  @return k, which is the number of factors of data.
#'  @author Zi Wang
#'  @examples
#'  
#'  library(fact_num)
#'  n = 50
#'  p = 7
#'  rho = 0.5
#'  mat = matrix(rep(rho,p), ncol = 1)  
#'  phi = diag(apply(mat, 1, function(x) 1-x[1]^2))
#'  sigma_m = mat %*% t(mat) + phi
#'  x = rnorm(n*p)
#'  dim(x) = c(n,p)
#'  r = chol(sigma_m)
#'  m = x %*% r  # data m contain 1 factor, since rank(mat) = 1
#'  k = fact_num(m)
#'  k

factnum = function(data){
  n = dim(data)[1]
  p = dim(data)[2]
  t = FALSE
  i = 0
  mu_0 = (p-n+3/2)*log(1-p/(n-1))-(n-2)*p/(n-1) # approximation -p^2/(2*n)
  sigma_0 = sqrt(-2*(p/(n-1)+log(1-p/(n-1)))) 
  new_stat = (log(det(cor(data)))-mu_0)/sigma_0 
  # if det(cor(data)) is too large, could try sum(log(eigen(cor(data))$values))
  pval = pnorm(new_stat, lower.tail = T)
  if (pval < 0.05){
    for (i in 1:(2*p+1-sqrt(8*p+1)/2)){  # degrees of freedom of LRT statistic should be positive
      model = factanal(data, factors = i)
      Rn = model$loadings %*% t(model$loadings) + diag(model$uniquenesses)
      Rn = cov2cor(Rn)
      mu = (p-n+1.5) * log(1-p/(n-1))-(n-2)*p/(n-1) + log(det(Rn))
      sigma = sqrt((-2) * (p/(n-1)+log(1-p/(n-1))) + 2*(sum(diag((Rn-diag(p)) %*% (Rn-diag(p)))))/(n-1))
      new_stat = (log(det(cor(data)))-mu)/sigma 
      pval = pnorm(new_stat, lower.tail = T)
      if (pval >= 0.05){
        t = TRUE
        break
      }    
    }      
  }else{
    t = TRUE
  }
  
  if (t) {
    k = i  
  }else{
    k = -1  
  }
  
  k  
}
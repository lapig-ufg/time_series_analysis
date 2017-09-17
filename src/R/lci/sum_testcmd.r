fun <- function(){
  x = 0
  y = 0
  t = 0
  v = 0
  x <- fix(x); print("What is the value of x?")
  y <- fix(y); print("What is the value of y?")
  t <- fix(t); print("What is the value of t?")
  v <- fix(v); print("What is the value of v?")

  out1 <- x + y
  out2 <- t + v

  return(list(out1, out2))

}


print(fun())
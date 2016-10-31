# Monte-Carlo of 3-Door Monty Hall problem

require(doParallel)
require(foreach)
## Change door

cl <- makeCluster(5)
registerDoParallel(cl)

results <- foreach (i=1:10000, .combine = 'rbind') %dopar% {
  reality <- data.frame(index = c(1:3), real = sample(c('car', 'sheep', 'sheep'), 3))
  real_win <- reality$index[reality$real == 'car']
  first_shot <- sample(reality$index, 1)
  open <- sample(reality$index[reality$real != 'car' & reality$index != first_shot], 1)
  second_shot <- reality$index[!reality$index %in% c(first_shot, open)]
  result_temp <- data.frame(win = real_win, first = first_shot, open = open, second = second_shot)
  result_temp
}

stopCluster(cl)

cat('If we insist the first shot, then the probability of winning is:', sum(results$first == results$win)/10000)
cat('If we do a second shot, then the probability of winning is:', sum(results$second == results$win)/10000)

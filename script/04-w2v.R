# word2vec本体部分
# 20170724
# tosei hatori

# 初期化------
rm(list = ls())
gc();gc()

# ライブラリ-----
require(dplyr)
require(wordVectors)
require(RMeCab)
require(purrr)

# 名前のデータと分かち書きしたタイトルのデータから学習----------
params <- expand.grid(
  vectors = c(10, 100, 300, 500)
  , windows = c(5, 15, 30)
)
for(loop_i in 1 : nrow(params)){
  print(paste("now is ", params$vectors[loop_i], "vec", params$windows[loop_i], "win"))
  # タイトルの部分を学習
  output_file_titles <- paste0("./model/model_titles_v", params$vectors[loop_i], "_w", params$windows[loop_i], ".txt")
  try(
    wordVectors::train_word2vec(
      train_file = "./out/title_wakati.txt", output_file = output_file_titles,
      vectors = params$vectors[loop_i], window = params$windows[loop_i],
      threads = 3, force = T
    )
    , silent = TRUE
  )
}


# 結果を見てみる------


# ちょっとした関数定義
queryToMat <- function(word, window_size, vector_size){
  title_model_1 <- read.binary.vectors(filename = paste0("./model/model_titles_v", vector_size[1],"_w", window_size[1],".txt"))
  title_model_2 <- read.binary.vectors(filename = paste0("./model/model_titles_v", vector_size[2],"_w", window_size[2],".txt"))
  title_model_3 <- read.binary.vectors(filename = paste0("./model/model_titles_v", vector_size[3],"_w", window_size[3],".txt"))
  
  tmp_mat <- matrix(nrow = 10, ncol = 6)
  tmp_mat[, 1] <- nearest_to(title_model_1, word) %>% names()
  tmp_mat[, 2] <- nearest_to(title_model_1, word) %>% unlist() %>% round(digits = 2)
  tmp_mat[, 3] <- nearest_to(title_model_2, word) %>% names()
  tmp_mat[, 4] <- nearest_to(title_model_2, word) %>% unlist() %>% round(digits = 2)
  tmp_mat[, 5] <- nearest_to(title_model_3, word) %>% names()
  tmp_mat[, 6] <- nearest_to(title_model_3, word) %>% unlist() %>% round(digits = 2)
  return(rbind(c("w=5", "", "w=15", "", "w=30", ""), rep(x = c("word", "distance"), 3), tmp_mat))
}

# 名詞
mat_1 <- rbind(
  queryToMat(word = "アナル", window_size = c(5, 15, 30), vector_size = c(10, 10, 10))
  ,queryToMat(word = "アナル", window_size = c(5, 15, 30), vector_size = c(100, 100, 100))
  ,queryToMat(word = "アナル", window_size = c(5, 15, 30), vector_size = c(300, 300, 300))
  ,queryToMat(word = "アナル", window_size = c(5, 15, 30), vector_size = c(500, 500, 500))
  )
View(mat_1)

mat_1 <- rbind(
  queryToMat(word = "眼鏡", window_size = c(5, 15, 30), vector_size = c(10, 10, 10))
  ,queryToMat(word = "眼鏡", window_size = c(5, 15, 30), vector_size = c(100, 100, 100))
  ,queryToMat(word = "眼鏡", window_size = c(5, 15, 30), vector_size = c(300, 300, 300))
  ,queryToMat(word = "眼鏡", window_size = c(5, 15, 30), vector_size = c(500, 500, 500))
)
View(mat_1)
mat_1 <- rbind(
  queryToMat(word = "おっぱい", window_size = c(5, 15, 30), vector_size = c(10, 10, 10))
  ,queryToMat(word = "おっぱい", window_size = c(5, 15, 30), vector_size = c(100, 100, 100))
  ,queryToMat(word = "おっぱい", window_size = c(5, 15, 30), vector_size = c(300, 300, 300))
  ,queryToMat(word = "おっぱい", window_size = c(5, 15, 30), vector_size = c(500, 500, 500))
)
View(mat_1)
mat_1 <- rbind(
  queryToMat(word = "うんこ", window_size = c(5, 15, 30), vector_size = c(10, 10, 10))
  ,queryToMat(word = "うんこ", window_size = c(5, 15, 30), vector_size = c(100, 100, 100))
  ,queryToMat(word = "うんこ", window_size = c(5, 15, 30), vector_size = c(300, 300, 300))
  ,queryToMat(word = "うんこ", window_size = c(5, 15, 30), vector_size = c(500, 500, 500))
)
View(mat_1)

# やや抽象的な言葉
mat_1 <- rbind(
  queryToMat(word = "解禁", window_size = c(5, 15, 30), vector_size = c(10, 10, 10))
  ,queryToMat(word = "解禁", window_size = c(5, 15, 30), vector_size = c(100, 100, 100))
  ,queryToMat(word = "解禁", window_size = c(5, 15, 30), vector_size = c(300, 300, 300))
  ,queryToMat(word = "解禁", window_size = c(5, 15, 30), vector_size = c(500, 500, 500))
)
View(mat_1)
mat_1 <- rbind(
  queryToMat(word = "開発", window_size = c(5, 15, 30), vector_size = c(10, 10, 10))
  ,queryToMat(word = "開発", window_size = c(5, 15, 30), vector_size = c(100, 100, 100))
  ,queryToMat(word = "開発", window_size = c(5, 15, 30), vector_size = c(300, 300, 300))
  ,queryToMat(word = "開発", window_size = c(5, 15, 30), vector_size = c(500, 500, 500))
)
View(mat_1)
nearest_to(title_model_1, "解禁")
nearest_to(title_model_2, "解禁")
nearest_to(title_model_3, "解禁")
nearest_to(title_model_1, "開発")
nearest_to(title_model_2, "開発")
nearest_to(title_model_3, "開発")
nearest_to(title_model_1, "上昇")
nearest_to(title_model_2, "上昇")
nearest_to(title_model_3, "上昇")
# 人名
mat_1 <- rbind(
  queryToMat(word = "しみけん", window_size = c(5, 15, 30), vector_size = c(10, 10, 10))
  ,queryToMat(word = "しみけん", window_size = c(5, 15, 30), vector_size = c(100, 100, 100))
  ,queryToMat(word = "しみけん", window_size = c(5, 15, 30), vector_size = c(300, 300, 300))
  ,queryToMat(word = "しみけん", window_size = c(5, 15, 30), vector_size = c(500, 500, 500))
)
View(mat_1)
mat_1 <- rbind(
  queryToMat(word = "あべみかこ", window_size = c(5, 15, 30), vector_size = c(10, 10, 10))
  ,queryToMat(word = "あべみかこ", window_size = c(5, 15, 30), vector_size = c(100, 100, 100))
  ,queryToMat(word = "あべみかこ", window_size = c(5, 15, 30), vector_size = c(300, 300, 300))
  ,queryToMat(word = "あべみかこ", window_size = c(5, 15, 30), vector_size = c(500, 500, 500))
)
View(mat_1)
nearest_to(title_model_1, "しみけん")
nearest_to(title_model_2, "しみけん")
nearest_to(title_model_3, "しみけん")
nearest_to(title_model_1, "あべみかこ")
nearest_to(title_model_2, "あべみかこ")
nearest_to(title_model_3, "あべみかこ")
nearest_to(title_model_1, "浅田結梨")
nearest_to(title_model_2, "浅田結梨")
nearest_to(title_model_3, "浅田結梨")
# 多義的な言葉
nearest_to(title_model_1, "百合")
nearest_to(title_model_2, "百合")
nearest_to(title_model_3, "百合")
nearest_to(title_model_1, "菊")
nearest_to(title_model_2, "菊")
nearest_to(title_model_3, "菊")

# 演算
# ちょっとした関数定義
queryToMat2 <- function(word, window_size, vector_size, isPlus){
  title_model_1 <- read.binary.vectors(filename = paste0("./model/model_titles_v", vector_size[1],"_w", window_size[1],".txt"))
  title_model_2 <- read.binary.vectors(filename = paste0("./model/model_titles_v", vector_size[2],"_w", window_size[2],".txt"))
  title_model_3 <- read.binary.vectors(filename = paste0("./model/model_titles_v", vector_size[3],"_w", window_size[3],".txt"))
  
  tmp_mat <- matrix(nrow = 10, ncol = 6)
  if(isPlus){
    tmp_mat[, 1] <- nearest_to(title_model_1, title_model_1[[word[1]]] + title_model_1[[word[2]]]) %>% names()
    tmp_mat[, 2] <- nearest_to(title_model_1, title_model_1[[word[1]]] + title_model_1[[word[2]]]) %>% unlist() %>% round(digits = 2)
    tmp_mat[, 3] <- nearest_to(title_model_2, title_model_2[[word[1]]] + title_model_2[[word[2]]]) %>% names()
    tmp_mat[, 4] <- nearest_to(title_model_2, title_model_2[[word[1]]] + title_model_2[[word[2]]]) %>% unlist() %>% round(digits = 2)
    tmp_mat[, 5] <- nearest_to(title_model_3, title_model_3[[word[1]]] + title_model_3[[word[2]]]) %>% names()
    tmp_mat[, 6] <- nearest_to(title_model_3, title_model_3[[word[1]]] + title_model_3[[word[2]]]) %>% unlist() %>% round(digits = 2)
  }else{
    tmp_mat[, 1] <- nearest_to(title_model_1, title_model_1[[word[1]]] - title_model_1[[word[2]]]) %>% names()
    tmp_mat[, 2] <- nearest_to(title_model_1, title_model_1[[word[1]]] - title_model_1[[word[2]]]) %>% unlist() %>% round(digits = 2)
    tmp_mat[, 3] <- nearest_to(title_model_2, title_model_2[[word[1]]] - title_model_2[[word[2]]]) %>% names()
    tmp_mat[, 4] <- nearest_to(title_model_2, title_model_2[[word[1]]] - title_model_2[[word[2]]]) %>% unlist() %>% round(digits = 2)
    tmp_mat[, 5] <- nearest_to(title_model_3, title_model_3[[word[1]]] - title_model_3[[word[2]]]) %>% names()
    tmp_mat[, 6] <- nearest_to(title_model_3, title_model_3[[word[1]]] - title_model_3[[word[2]]]) %>% unlist() %>% round(digits = 2)
  }
  return(rbind(c("w=5", "", "w=15", "", "w=30", ""), rep(x = c("word", "distance"), 3), tmp_mat))
}
mat_1 <- rbind(
  queryToMat2(word = c("あべみかこ", "貧乳"), window_size = c(5, 15, 30)
             , vector_size = c(100, 100, 100), isPlus = F)
  ,queryToMat2(word = c("あべみかこ", "貧乳"), window_size = c(5, 15, 30)
               , vector_size = c(300, 300, 300), isPlus = F)
)
View(mat_1)
nearest_to(title_model_1, title_model_1[["あべみかこ"]] - title_model_1[["貧乳"]])
nearest_to(title_model_2, title_model_2[["あべみかこ"]] - title_model_2[["貧乳"]])
nearest_to(title_model_3, title_model_3[["あべみかこ"]] - title_model_3[["貧乳"]])
nearest_to(title_model_1, title_model_1[["跡美しゅり"]] - title_model_1[["貧乳"]])
nearest_to(title_model_2, title_model_2[["跡美しゅり"]] - title_model_2[["貧乳"]])
nearest_to(title_model_3, title_model_3[["跡美しゅり"]] - title_model_3[["貧乳"]])
nearest_to(title_model_1, title_model_1[["あべみかこ"]] + title_model_1[["巨乳"]])
nearest_to(title_model_2, title_model_2[["あべみかこ"]] + title_model_2[["巨乳"]])
nearest_to(title_model_3, title_model_3[["あべみかこ"]] + title_model_3[["巨乳"]])
nearest_to(title_model_1, title_model_1[["百合華"]] - title_model_1[["眼鏡"]])
nearest_to(title_model_2, title_model_2[["百合華"]] - title_model_2[["眼鏡"]])
nearest_to(title_model_3, title_model_3[["百合華"]] - title_model_3[["眼鏡"]])

nearest_to(title_model_1, title_model_1[["あべみかこ"]] + title_model_1[["眼鏡"]])
nearest_to(title_model_2, title_model_2[["あべみかこ"]] + title_model_2[["眼鏡"]])
nearest_to(title_model_3, title_model_3[["あべみかこ"]] + title_model_3[["眼鏡"]])

nearest_to(title_model_1, title_model_1[["あべみかこ"]] + title_model_1[["制服"]])
nearest_to(title_model_2, title_model_2[["あべみかこ"]] + title_model_2[["制服"]])
nearest_to(title_model_3, title_model_3[["あべみかこ"]] + title_model_3[["制服"]])

nearest_to(title_model_1, title_model_1[["眼鏡"]] + title_model_1[["制服"]])
nearest_to(title_model_2, title_model_2[["眼鏡"]] + title_model_2[["制服"]])
nearest_to(title_model_3, title_model_3[["眼鏡"]] + title_model_3[["制服"]])


nearest_to(title_model_1, title_model_1[["眼鏡"]] + title_model_1[["地味"]])
nearest_to(title_model_2, title_model_2[["眼鏡"]] + title_model_2[["地味"]])
nearest_to(title_model_3, title_model_3[["眼鏡"]] + title_model_3[["地味"]])

nearest_to(title_model_1, title_model_1[["眼鏡"]] + title_model_1[["巨乳"]])
nearest_to(title_model_2, title_model_2[["眼鏡"]] + title_model_2[["巨乳"]])
nearest_to(title_model_3, title_model_3[["眼鏡"]] + title_model_3[["巨乳"]])

nearest_to(title_model_1, title_model_1[["澁谷果歩"]] - title_model_1[["巨乳"]])
nearest_to(title_model_2, title_model_2[["澁谷果歩"]] - title_model_2[["巨乳"]])
nearest_to(title_model_3, title_model_3[["澁谷果歩"]] - title_model_3[["巨乳"]])

nearest_to(title_model_1, title_model_1[["澁谷果歩"]] + title_model_1[["眼鏡"]])
nearest_to(title_model_2, title_model_2[["澁谷果歩"]] + title_model_2[["眼鏡"]])
nearest_to(title_model_3, title_model_3[["澁谷果歩"]] + title_model_3[["眼鏡"]])
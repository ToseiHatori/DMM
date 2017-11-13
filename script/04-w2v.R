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
  vectors = c(10, 100)
  , windows = c(15, 50)
)
for(loop_i in 1 : nrow(params)){
  # 名前の部分を学習
  output_file_names <- paste0("./model/model_names_v", params$vectors[loop_i], "_w", params$windows[loop_i], ".txt")
  try(
    wordVectors::train_word2vec(
      train_file = "./out/names_list.csv", output_file = output_file_names,
      vectors = params$vectors[loop_i], window = params$windows[loop_i],
      threads = 3, force = T
    )
    , silent = TRUE
  )

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
title_model_v10_w15 <- read.binary.vectors(filename = "./model/model_titles_v10_w15.txt")
title_model_v10_w50 <- read.binary.vectors(filename = "./model/model_titles_v10_w50.txt")
title_model_v100_w15 <- read.binary.vectors(filename = "./model/model_titles_v100_w15.txt")
title_model_v100_w50 <- read.binary.vectors(filename = "./model/model_titles_v100_w50.txt")

# 名詞
nearest_to(title_model_v10_w15, "アナル")
nearest_to(title_model_v10_w50, "アナル")
nearest_to(title_model_v100_w15, "アナル")
nearest_to(title_model_v100_w50, "アナル")
nearest_to(title_model_v10_w15, "おっぱい")
nearest_to(title_model_v10_w50, "おっぱい")
nearest_to(title_model_v100_w15, "おっぱい")
nearest_to(title_model_v100_w50, "おっぱい")
nearest_to(title_model_v10_w15, "うんこ")
nearest_to(title_model_v10_w50, "うんこ")
nearest_to(title_model_v100_w15, "うんこ")
nearest_to(title_model_v100_w50, "うんこ")
nearest_to(title_model_v10_w15, "コスプレ")
nearest_to(title_model_v10_w50, "コスプレ")
nearest_to(title_model_v100_w15, "コスプレ")
nearest_to(title_model_v100_w50, "コスプレ")
nearest_to(title_model_v10_w15, "妄想")
nearest_to(title_model_v10_w50, "妄想")
nearest_to(title_model_v100_w15, "妄想")
nearest_to(title_model_v100_w50, "妄想")
# やや抽象的な言葉
nearest_to(title_model_v10_w15, "解禁")
nearest_to(title_model_v10_w50, "解禁")
nearest_to(title_model_v100_w15, "解禁")
nearest_to(title_model_v100_w50, "解禁")
nearest_to(title_model_v10_w15, "開発")
nearest_to(title_model_v10_w50, "開発")
nearest_to(title_model_v100_w15, "開発")
nearest_to(title_model_v100_w50, "開発")
# 人名
nearest_to(title_model_v10_w15, "しみけん")
nearest_to(title_model_v10_w50, "しみけん")
nearest_to(title_model_v100_w15, "しみけん")
nearest_to(title_model_v100_w50, "しみけん")
nearest_to(title_model_v10_w15, "あべみかこ")
nearest_to(title_model_v10_w50, "あべみかこ")
nearest_to(title_model_v100_w15, "あべみかこ")
nearest_to(title_model_v100_w50, "あべみかこ")
nearest_to(title_model_v10_w15, "浅田結梨")
nearest_to(title_model_v10_w50, "浅田結梨")
nearest_to(title_model_v100_w15, "浅田結梨")
nearest_to(title_model_v100_w50, "浅田結梨")
# 多義的な言葉
nearest_to(title_model_v10_w15, "百合")
nearest_to(title_model_v10_w50, "百合")
nearest_to(title_model_v100_w15, "百合")
nearest_to(title_model_v100_w50, "百合")
nearest_to(title_model_v10_w15, "菊")
nearest_to(title_model_v10_w50, "菊")
nearest_to(title_model_v100_w15, "菊")
nearest_to(title_model_v100_w50, "菊")

# 演算
nearest_to(title_model_v10_w15, title_model_v10_w15[["あべみかこ"]] - title_model_v10_w15[["貧乳"]])
nearest_to(title_model_v10_w50, title_model_v10_w50[["あべみかこ"]] - title_model_v10_w50[["貧乳"]])
nearest_to(title_model_v100_w15, title_model_v100_w15[["あべみかこ"]] - title_model_v100_w15[["貧乳"]])
nearest_to(title_model_v100_w50, title_model_v100_w50[["あべみかこ"]] - title_model_v100_w50[["貧乳"]])
nearest_to(title_model_v10_w15, title_model_v10_w15[["跡美しゅり"]] - title_model_v10_w15[["貧乳"]])
nearest_to(title_model_v10_w50, title_model_v10_w50[["跡美しゅり"]] - title_model_v10_w50[["貧乳"]])
nearest_to(title_model_v100_w15, title_model_v100_w15[["跡美しゅり"]] - title_model_v100_w15[["貧乳"]])
nearest_to(title_model_v100_w50, title_model_v100_w50[["跡美しゅり"]] - title_model_v100_w50[["貧乳"]])
nearest_to(title_model_v10_w15, title_model_v10_w15[["あべみかこ"]] + title_model_v10_w15[["巨乳"]])
nearest_to(title_model_v10_w50, title_model_v10_w50[["あべみかこ"]] + title_model_v10_w50[["巨乳"]])
nearest_to(title_model_v100_w15, title_model_v100_w15[["あべみかこ"]] + title_model_v100_w15[["巨乳"]])
nearest_to(title_model_v100_w50, title_model_v100_w50[["あべみかこ"]] + title_model_v100_w50[["巨乳"]])
nearest_to(title_model_v10_w15, title_model_v10_w15[["百合華"]] - title_model_v10_w15[["眼鏡"]])
nearest_to(title_model_v10_w50, title_model_v10_w50[["百合華"]] - title_model_v10_w50[["眼鏡"]])
nearest_to(title_model_v100_w15, title_model_v100_w15[["百合華"]] - title_model_v100_w15[["眼鏡"]])
nearest_to(title_model_v100_w50, title_model_v100_w50[["百合華"]] - title_model_v100_w50[["眼鏡"]])


# 結果を見てみる------
name_model_v10_w15 <- read.binary.vectors(filename = "./model/model_names_v10_w15.txt")
name_model_v10_w50 <- read.binary.vectors(filename = "./model/model_names_v10_w50.txt")
name_model_v100_w15 <- read.binary.vectors(filename = "./model/model_names_v100_w15.txt")
name_model_v100_w50 <- read.binary.vectors(filename = "./model/model_names_v100_w50.txt")

# 名詞
nearest_to(name_model_v10_w15, "あべみかこ")
nearest_to(name_model_v10_w50, "あべみかこ")
nearest_to(name_model_v100_w15, "あべみかこ")
nearest_to(name_model_v100_w50, "あべみかこ")
nearest_to(name_model_v10_w15, "天使もえ")
nearest_to(name_model_v10_w50, "天使もえ")
nearest_to(name_model_v100_w15, "天使もえ")
nearest_to(name_model_v100_w50, "天使もえ")
nearest_to(name_model_v10_w15, "水野朝陽")
nearest_to(name_model_v10_w50, "水野朝陽")
nearest_to(name_model_v100_w15, "水野朝陽")
nearest_to(name_model_v100_w50, "水野朝陽")
nearest_to(name_model_v10_w15, "ANRI")
nearest_to(name_model_v10_w50, "ANRI")
nearest_to(name_model_v100_w15, "ANRI")
nearest_to(name_model_v100_w50, "ANRI")



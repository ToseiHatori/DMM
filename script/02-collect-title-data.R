# dmm.comのAPIを叩いて作品タイトルを収集するスクリプト
# 20170724
# tosei hatori

# 初期化------
rm(list = ls())
gc();gc()

# ライブラリ-----
require(dplyr)
require(rvest)

# 叩く--------
# apiIDとアフィリエイトIDは事前登録が必要
api_id <- "yourApiId"
aff_id <- "yourAffId"

# 結果格納用の変数を作る
time_start <- seq(as.Date("2010-04-01"), as.Date(Sys.Date()), by="days")

# 行列の定義
res_names <- list()
res_title <- list()
# ここからループでとっていく
start_time <- proc.time()
for(time_loop in 1 : length(time_start)){
  # クエリを整形
  query <- paste0("https://api.dmm.com/affiliate/v3/ItemList"
                  , "?api_id=", api_id, "&affiliate_id=", aff_id
                  , "&service=digital&floor=videoa&hits=100"
                  , "&sort=rank&site=DMM.R18"
                  , "&gte_date=",time_start[time_loop] ,"T00:00:00"
                  , "&lte_date=", time_start[time_loop + 1],"T00:00:00"
                  , "&output=xml")
  
  # APIを叩く
  xml_raw <- read_xml(query)
  
  # ログをとる
  date_first <- xml_raw %>% html_nodes(xpath = "//date") %>% html_text() %>% head(1)
  title_first <- xml_raw %>% html_nodes(xpath = "//title") %>% html_text() %>% head(1)
  print(paste("-------now is ", time_loop, "and ","first title is", title_first, "and date is ", date_first))
  
  # 結果の格納
  if (length(title_first) > 0){ # idが存在するときのみ変数にいれたりする
    # itemタグに「名前、ルビ、種別」とぶら下がっているので3で割って1あまるものだけ取得
    names_tmp <- xml_raw %>% html_nodes(xpath = "//actress/item[position() mod3 = 1]/name") %>% html_text() %>%
      # カッコだの句読点だのはとる
      purrr::map(., .f = gsub, pattern = "\\(|（|\\)|）|、", replacement = " ") %>% unlist()
    # タイトルを取得
    title_tmp <- xml_raw %>% html_nodes(xpath = "//item/title") %>% html_text()
    # 行列に入れる
    res_names[[time_loop]] <- names_tmp
    res_title[[time_loop]] <- title_tmp
  }
  
  # 休憩
  Sys.sleep(1)
  # 記録
  if (time_loop %% 100 == 0){
    corpus_names <- res_names %>% purrr::map(.f = paste, collapse = " ") %>% unlist()
    corpus_title <- res_title %>% purrr::map(.f = paste, collapse = " ") %>% unlist() 
    write.csv(x = corpus_names, file = "./out/names_list.csv", row.names = FALSE, quote = FALSE)
    write.csv(x = corpus_title, file = "./out/title_list.csv", row.names = FALSE, quote = FALSE)
  }
}
corpus_names <- res_names %>% purrr::map(.f = paste, collapse = " ") %>% unlist()
corpus_title <- res_title %>% purrr::map(.f = paste, collapse = " ") %>% unlist() 
write.csv(x = corpus_names, file = "./out/names_list.csv", row.names = FALSE, quote = FALSE)
write.csv(x = corpus_title, file = "./out/title_list.csv", row.names = FALSE, quote = FALSE)
end_time <- proc.time()
# 時間測定
elapsed_time <- end_time - start_time %>% as.matrix()
print(elapsed_time)
write.csv(x = elapsed_time, file = "./out/log_title.csv")


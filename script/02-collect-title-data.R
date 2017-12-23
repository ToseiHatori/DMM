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
date_start <- seq(as.Date("2010-04-01"), as.Date(Sys.Date()), by="days")
offset_term <- seq(1, 50000, by = 100)

# 行列の定義
res_names <- NULL
res_title <- NULL
# ここからループでとっていく
start_time <- proc.time()
for(loop_date in 1 : length(date_start)){
  for(loop_offset in 1 : length(offset_term)){
    # クエリを整形
    query <- paste0("https://api.dmm.com/affiliate/v3/ItemList"
                    , "?api_id=", api_id, "&affiliate_id=", aff_id
                    , "&service=digital&floor=videoa&hits=100"
                    , "&sort=rank&site=DMM.R18"
                    , "&offset=", offset_term[loop_offset]
                    , "&gte_date=", date_start[loop_date] ,"T00:00:00"
                    , "&lte_date=", date_start[loop_date],"T23:59:59"
                    , "&output=xml")
    
    # APIを叩く
    xml_raw <- read_xml(query)
    
    # ログをとる
    print(paste("-------date is ", date_start[loop_date], "offset is ", offset_term[loop_offset]))
    date_first <- xml_raw %>% html_nodes(xpath = "//date") %>% html_text() %>% head(1)
    title_first <- xml_raw %>% html_nodes(xpath = "//title") %>% html_text() %>% head(1)
    
    # 結果の格納
    if (length(title_first) > 0){ # idが存在するときのみ変数にいれたりする
      print(title_first)
      # itemタグに「名前、ルビ、種別」とぶら下がっているので3で割って1あまるものだけ取得
      names_tmp <- xml_raw %>% html_nodes(xpath = "//actress/item[position() mod3 = 1]/name") %>% html_text() %>%
        # カッコだの句読点だのはとる
        purrr::map(., .f = gsub, pattern = "\\(|（|\\)|）|、", replacement = " ") %>% unlist()
      # タイトルを取得
      title_tmp <- xml_raw %>% html_nodes(xpath = "//item/title") %>% html_text()
      # 行列に入れる
      res_names <- append(res_names, names_tmp)
      res_title <- append(res_title, title_tmp)
    }else{
      break
    }
    
    # 休憩
    Sys.sleep(1)
    # 記録
    if (loop_date %% 100 == 0){
      write.csv(x = res_names, file = "./out/names_list.csv", row.names = FALSE, quote = FALSE)
      write.csv(x = res_title, file = "./out/title_list.csv", row.names = FALSE, quote = FALSE)
    } 
  }
}
write.csv(x = res_names, file = "./out/names_list.csv", row.names = FALSE, quote = FALSE)
write.csv(x = names_title, file = "./out/title_list.csv", row.names = FALSE, quote = FALSE)
end_time <- proc.time()
# 時間測定
elapsed_time <- end_time - start_time %>% as.matrix()
print(elapsed_time)
write.csv(x = elapsed_time, file = "./out/log_title.csv")


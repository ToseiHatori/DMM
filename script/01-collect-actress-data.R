# dmm.comのAPIを叩いて女優のマスターデータを収集するスクリプト
# 20170724
# tosei hatori

# 初期化------
rm(list = ls())
gc();gc()

# ライブラリ-----
require(dplyr)
require(rvest)

# 関数定義-----
# 空文字に対してnullを返す関数
getObjectOrNull <- function(res){
  res <- ifelse(length(res) == 0, yes = NA, no = res)
  return(res)
}
getObjectFromXml <- function(parts){
  return(xml_raw %>% html_nodes(parts) %>% html_text() %>% getObjectOrNull())
}

# 叩く--------
# apiIDとアフィリエイトIDは事前登録が必要
api_id <- "yourApiId"
aff_id <- "yourAffId"

# 女優IDの最大値を決めておく
max_num <- 30000 # 27000台まで存在してるっぽい
# 収集する項目をとっておく
list_contents <- c("id", "name", "bust", "cup", "waist", "hip", "height"
                   ,"birthday", "blood_type", "hobby", "prefectures")
# 結果格納用の変数を作る
res_data <- matrix(nrow = 0, ncol = length(list_contents)) #今回は11項目収集する
colnames(res_data) <- list_contents
# ここからループでとっていく
start_time <- proc.time()
for(act_id in 1 : max_num){
  # クエリを整形
  query <- paste0("https://api.dmm.com/affiliate/v3/ActressSearch"
                  ,"?api_id=", api_id, "&affiliate_id=", aff_id
                  , "&actress_id=", act_id,"&output=xml")
  # APIを叩く
  xml_raw <- read_xml(query)
  # 順次結果を格納
  res_id<- xml_raw %>% html_nodes("id") %>% html_text()

  if(length(res_id) > 0){ # idが存在するときのみ変数にいれたりする
    res_data_tmp <- sapply(X = list_contents, FUN = function(x)getObjectFromXml(x))
    res_data <- rbind(res_data, res_data_tmp)
  }
  # 休憩
  Sys.sleep(1)
  # 記録
  if(act_id %% 10 == 0){
    print(paste0("Now fetchng", res_id))
    write.csv(x = res_data, file = "./out/actress_master.csv")
  }
}
write.csv(x = res_data, file = "./out/actress_master.csv")
end_time <- proc.time()
# 時間測定
elapsed_time <- end_time - start_time %>% as.matrix()
print(elapsed_time)
write.csv(x = elapsed_time, file = "./out/log_actress.csv")
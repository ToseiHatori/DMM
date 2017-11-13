# パッケージのインストール
# 20170724
# tosei hatori

# install
if (!require(rvest)){
  install.packages("rvest", dependencies = T)
}
if (!require(dplyr)){
  install.packages("dplyr", dependencies = T)
}
if (!require(lubridate)){
  install.packages("lubridate", dependencies = T)
}
if (!require(parsedate)){
  install.packages("parsedate", dependencies = T)
}
if (!require(data.table)){
  install.packages("data.table", dependencies = T)
}
if (!require(RMeCab)){
  install.packages("RMeCab", repos = "http://rmecab.jp/R")
}
if (!require(parsedate)){
  install.packages("parsedate", dependencies = T)
}
if (!require(purrr)){
  install.packages("purrr", dependencies = T)
}
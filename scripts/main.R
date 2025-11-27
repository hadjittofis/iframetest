

# ##############################################################################
# [A] PACKAGES
start_time <- Sys.time()
datetime <- format(start_time,"%Y%m%d_%H%M%S")

pckgs <- c('data.table','plotly','dplyr', 'httr', 'here', 'pxweb', 'htmltools', 'htmlwidgets', 'sodium')
if( length(setdiff(pckgs, rownames(installed.packages()))) > 0 ){
  toinstall <- setdiff( pckgs, rownames(installed.packages()))
  cat(paste0("   --> Will be installing the following packages: '",paste(toinstall,collapse="' + '"),"'\n"))
  install.packages(toinstall)
  rm(toinstall)
  cat("\n")
  gc()
}
library(data.table)
library(plotly)
library(dplyr)
library(htmltools)
library(htmlwidgets)

source(here::here("scripts/functions.R"))


# ##############################################################################
# [C] SETUP PATHS
dir.create( graph_dir <- here::here("docs/"), recursive=TRUE, showWarnings=FALSE)
dir.create( logs_gen <- here::here("logs/"), recursive=TRUE, showWarnings=FALSE)
dir.create( logs_dir <- here::here(logs_gen, options_api$subtheme,"/"), recursive=TRUE, showWarnings=FALSE)
csv_changes <- paste0(logs_gen,"/DT_Hashes.csv")


# ##############################################################################
# [C] LOGS
logfile <- file(paste0(logs_dir,"/Log_Graph_",options_api$subtheme,"_",datetime,".txt"))
sink(logfile, append = FALSE, type = c("output"), split=FALSE)
sink(logfile, append = FALSE, type = c("message"), split=FALSE)

cat("\n")
cat("################################################\n")
cat("### CREATE INTERACTIVE GRAPHS FROM CYSTAT DB ###\n")
cat("################################################\n")
cat("\n\n")
cat(paste0("Start Time:  ", start_time))
cat("\n\n")


# ##############################################################################
# [D] GET DATA
cat(paste("[01] Get API metadata...","\n"))
px_metad <- pxweb::pxweb_get(url = paste0(options_api$db, options_api$pxf))
cat("\n")


cat(paste("[02] Get API data...","\n"))
cat(paste("      - Build API query...","\n"))
px_varbs <- sapply(px_metad$variables, `[[`, "code")
px_query <- lapply(px_varbs, function(x) c("*"))
names(px_query) <- px_varbs
cat(paste("      - Get data via API...","\n"))
px_data <- pxweb::pxweb_get(url = paste0(options_api$db,options_api$pxf), 
                            query = px_query)
cat(paste("      - Data in tabular format...","\n"))
df <- as.data.frame(px_data, column.name.type = "text", variable.value.type = "text")
dt <- data.table::as.data.table(df)

rm(
   px_metad, px_varbs, px_query, px_data, df)
gc()
cat("\n")


cat(paste("[03] Hashing data and comparing to prev version...","\n"))
cat(paste("      - Current Hash...","\n"))
dt_raw <- serialize(dt, connection = NULL)
current_hash <- sodium::bin2hex(sodium::hash(dt_raw))

cat(paste("      - Previous Hashes...","\n"))
if(file.exists(csv_changes)) {
  previous_hashes <- fread(csv_changes, colClasses=c("character"))
  setorderv(previous_hashes, c("graph","datetime"), c(1,-1))
  previous_hash <- previous_hashes[graph == options_api$subtheme][1,hash]
  if(is.na(previous_hash)){
    cat(paste("      -- No Previous hash found, hence CREATE graph","\n"))
    status = 1
  }else{
    if(previous_hash == current_hash){
      cat(paste("      -- Current Hash == Previous hash, hence do NOT re-create graph","\n"))
      status = 0
    }else{
      cat(paste("      -- Current Hash != Previous hash, hence RE-CREATE graph","\n"))
      status = 1
    }
  }
  hash <- data.table::data.table(graph = options_api$subtheme, datetime = datetime, status = status, hash = current_hash)
  current_hashes <- rbindlist(c(list(previous_hashes),list(hash)))
  rm(previous_hashes, previous_hash, hash)
}else{
  cat(paste("      -- No Previous hashes file found, hence CREATE file AND graph","\n"))
  status = 1
  current_hashes <- data.table::data.table(graph = options_api$subtheme, datetime = datetime, status = status, hash = current_hash)
}
setorderv(current_hashes, c("graph","datetime"), c(1,-1))
data.table::fwrite(current_hashes, file=csv_changes, sep=";")
rm(dt_raw, current_hash, current_hashes)
gc()
cat("\n")


if (status == 1) {
  cat(paste("[04] Cleaning data...","\n"))
  cat(paste("      - Identify and rename 'value' column (from'",options_pxf$col_value,"')","\n"))
  setnames(dt, options_pxf$col_value, "Value")
  
  if(nchar(options_pxf$col_trnsp)>0){
    cat(paste("      - Transposing the data on column '",options_pxf$col_trnsp,"'","\n"))
    eval(parse(text = paste0( "dt <- dcast(dt, ... ~ ", options_pxf$col_trnsp ,", value.var='Value')")))
    if(length(options_pxf$col_trnsp_renamefrom)>0){
      setnames(dt, c(options_pxf$col_trnsp_renamefrom), c(options_pxf$col_trnsp_renameto))
      colsvalue <- options_pxf$col_trnsp_renameto
    }else{
      colsvalue <- options_pxf$col_trnsp_renamefrom
    }
  }else{
    cat(paste("      - Will NOT be transposing the data...","\n"))
    colsvalue <- "Value"
  }
  
  cat(paste("      - Identify and format 'Date' column (from'",options_pxf$col_date,"')","\n"))
  dt[, Date := cystat_date( eval(parse(text=options_pxf$col_date)) )]
  
  cat(paste("      - Finalised Table to be plotted, now having the following structure","\n"))
  cat(paste("--------------------------------------------------------------------------","\n"))
  dt <- dt[,c("Date",colsvalue), with=F]
  print(tail(dt,3))
  cat(paste("--------------------------------------------------------------------------","\n"))
  cat("\n")
  
  
  cat(paste("[05] Plotting data...","\n"))
  if(dt[,.N]>50){
    nrows <- dt[,.N]
    initial_start <- as.character(dt[nrows-50,Date])
    initial_end <- as.character(dt[nrows,Date])
  }else{
    initial_start <- as.character(dt[1,Date])
    initial_end   <- as.character(dt[nrows,Date])
  }
  
  
  cat(paste("      - Create custom button for linking to CYSTAT DB:","\n","      --> ",options_api$user_link,"\n"))
  custom_button <- cystat_custbuttn(url = options_api$user_link)
  
  
  cat(paste("      - Creating plot...","\n"))
  fig <- plot_ly()
  
  fig <- config( fig,
                 locale = options_api$lang,
                 modeBarButtons = list(list('toImage', custom_button)),
                 displaylogo = FALSE)
  
  fig <- cystat_plotly(
    data_dt = dt, 
    xcol = "Date", 
    ycols = colsvalue, 
    fig_options = fig_options
  )
  
  
  cat(paste("      - Adding Border and Margin...","\n"))
  fig_final <- cystat_add_bordermargin(fig, fig_options$onRender$ADD_BORDER, fig_options$onRender$ADD_MARGIN)
  html_fname <- paste0(options_api$subtheme,"_",toupper(options_api$lang),".html")
  htmlwidgets::saveWidget(
    widget = fig_final,
    file = paste0(graph_dir,"/",html_fname),
    libdir="lib",
    selfcontained = TRUE
  )
  cat(paste0("#### Graph saved to: ", graph_dir,"/",html_fname,"\n"))
  
  # fig
  # fig_final
}



end_time <- Sys.time()
cat("\n\n")
cat(paste0("END Time: ", end_time))
cat("\n")
timetaken <- end_time - start_time
cat(paste0("Time taken for code to run: ", timetaken, " ",units(timetaken)))
cat("\n\nFINISHED!\n\n")
cat("################################################\n")
cat("\n")

closeAllConnections()


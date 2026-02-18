
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


# ##############################################################################
# [B] OPTIONS AND PATHS
dir.create( graph_dir <- here::here("docs/"), recursive=TRUE, showWarnings=FALSE)
dir.create( logs_dir <- here::here("logs/"), recursive=TRUE, showWarnings=FALSE)
csv_changes <- paste0(logs_dir,"/DT_Hashes.csv")

source(here::here("scripts/functions.R"))
subthemes <- c("RandD","Inflation","Tourism")
langs <- c("en", "el")


##############################################################################
# [C] LOGS
logfile <- file(paste0(logs_dir,"/Log_InteractiveGraphs_",datetime,".txt"))
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
# [E] GET DATA
cat(paste0("----->> Load previous Hashes file...","\n\n"))
if(file.exists(csv_changes)) {
  previous_hashes <- fread(csv_changes, colClasses=c("character"))
  setorderv(previous_hashes, c("graph","language","datetime"), c(1,1,-1))
  current_hashes <- copy(previous_hashes)
}else{
  current_hashes <- data.table()
}

for(subtheme in subthemes){
# subtheme <- subthemes[1]
  
  cat("##############################################################################\n")
  cat(paste0("--- SUBTHEME: ",subtheme,"\n"))
  cat(paste0("-    Loading Options...","\n"))
  source(here::here(paste0("scripts/options_",subtheme,".R")))

  for(lang in langs){
    # lang <- langs[1]
    cat("* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * \n")
    cat(paste0("    LANGUAGE: ",toupper(lang)," (",subtheme,")","\n"))
    cat("* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * \n")
    
    
    cat(paste0("[01] Get API metadata...","\n"))
    px_metad <- pxweb::pxweb_get(url = paste0(options_api[[lang]]$db, options_api[[lang]]$pxf))
    
    
    cat(paste0("[02] Get API data...","\n"))
    cat(paste0("-    Build API query...","\n"))
    px_varbs <- sapply(px_metad$variables, `[[`, "code")
    px_query <- lapply(px_varbs, function(x) c("*"))
    names(px_query) <- px_varbs
    cat(paste0("-    Get data via API...","\n"))
    px_data <- pxweb::pxweb_get(url = paste0(options_api[[lang]]$db,options_api[[lang]]$pxf), 
                                query = px_query)
    cat(paste0("-    Data in tabular format...","\n"))
    df <- as.data.frame(px_data, column.name.type = "text", variable.value.type = "text")
    dt <- data.table::as.data.table(df)
    rm(px_metad, px_varbs, px_query, px_data, df)
    
    
    cat(paste0("[03] Hashing data and comparing to prev version...","\n"))
    cat(paste0("-    Current Hash...","\n"))
    dt_raw <- serialize(dt, connection = NULL)
    current_hash <- sodium::bin2hex(sodium::hash(dt_raw))

    cat(paste0("-    Check previous Hashes...","\n"))
    if(exists("previous_hashes")) {
      previous_hash <- previous_hashes[graph == subtheme & language == lang][1,hash]
      if(is.na(previous_hash)){
        cat(paste0("-    -- No Previous hash found, hence CREATE graph","\n"))
        status = 1
      }else{
        if(previous_hash == current_hash){
          cat(paste0("-    -- Current Hash == Previous hash, hence do NOT re-create graph","\n"))
          status = 0
        }else{
          cat(paste0("-    -- Current Hash != Previous hash, hence RE-CREATE graph","\n"))
          status = 1
        }
      }
      rm(previous_hash)
    }else{
      cat(paste0("-    -- No Previous hashes file found, hence CREATE file AND graph","\n"))
      status = 1
    }
    current_hash_dt <- data.table::data.table(graph = subtheme, language = lang,
                                              datetime = datetime, status = status,
                                              hash = current_hash)
    current_hashes <- rbindlist(c(list(current_hashes),list(current_hash_dt)))
    setorderv(current_hashes, c("graph","language","datetime"), c(1,1,-1))
    rm(dt_raw, current_hash, current_hash_dt)
    
    
    if (status == 1) {
      cat(paste0("[04] Cleaning data...","\n"))
      cat(paste0("-    Identify and rename 'value' column (from'",options_pxf[[lang]]$col_value,"')","\n"))
      setnames(dt, options_pxf[[lang]]$col_value, "Value")
      
      if(!is.null(options_pxf[[lang]]$col_trnsp)) {
        cat(paste0("-    Transposing the data on columns '", paste(options_pxf[[lang]]$col_trnsp, collapse = "', '") ,"'","\n"))
        
        eval(parse(text = paste0( "dt <- dcast(dt, ... ~ ", options_pxf[[lang]]$col_trnsp ,", value.var='Value')")))
        colsvalue <- unlist(options_pxf[[lang]]$col_trnsp_colnames)
        if(!is.null(options_pxf[[lang]]$col_trnsp_renamefrom)){
          idx <- match(colsvalue, options_pxf[[lang]]$col_trnsp_renamefrom)
          colsvalue[!is.na(idx)] <- options_pxf[[lang]]$col_trnsp_renameto[idx[!is.na(idx)]]
          setnames(dt, c(options_pxf[[lang]]$col_trnsp_renamefrom), c(options_pxf[[lang]]$col_trnsp_renameto))
        }
      }else{
        cat(paste0("-    Will NOT be transposing the data...","\n"))
        colsvalue <- "Value"
      }
      
      cat(paste0("-    Identify and format 'Date' column (from'",options_pxf[[lang]]$col_date,"')","\n"))
      dt <- cystat_date(dtname = "dt", datecol = options_pxf[[lang]]$col_date)
      
      cat(paste0("-    Finalised Table to be plotted, now having the following structure:","\n"))
      cat(paste0("==========================================================================","\n"))
      dt <- dt[,c("Date",colsvalue), with=F]
      print(tail(dt,3))
      cat(paste0("==========================================================================","\n"))

      
      cat(paste0("[05] Plotting data...","\n"))
      nrows <- dt[,.N]
      if(nrows>50 & options_fig$xaxis$xaxis_rs_v){
        initial_start <- as.character(dt[nrows-50,Date])
        initial_end <- as.character(dt[nrows,Date])
      }else{
        initial_start <- as.character(dt[1,Date])
        initial_end   <- as.character(dt[nrows,Date])
      }
      
      
      cat(paste0("-    Create custom button for linking to CYSTAT DB:","\n","      --> ",options_api[[lang]]$user_link,"\n"))
      custom_button <- cystat_custbuttn(url = options_api[[lang]]$user_link)
      
      
      cat(paste0("-    Creating plot...","\n"))
      fig <- plot_ly()
      
      fig <- config( fig,
                     locale = lang,
                     modeBarButtons = list(list('toImage', custom_button)),
                     displaylogo = FALSE)
      
      fig <- cystat_plotly(
        data_dt = "dt",
        lang = lang,
        xcol = "Date", 
        ycols = colsvalue, 
        options_fig = options_fig
      )
      
      
      cat(paste0("-    Adding Border and Margin...","\n"))
      fig_final <- prependContent(fig, tags$style(HTML(paste0("
          /* Create border on overlapping containerS */
          .svg-container {
                border: ",options_fig$onRender$ADD_BORDER[[2]]," !important;
            }
          
          
          /* Let container of graph have a gap from the border of 20px */
          #htmlwidget_container {
            inset: ",options_fig$onRender$ADD_INSET[[2]]," !important;
          }
          
          /* The actual graph area - issue when it is 100%, it engulfs our .svg-container border */
          .main-svg {
            width: 99% !important;
            height: 99% !important;
          }
          
          "))))
      
      # ###########################################
      # The following no longer used - replace by prependContent function above, which targets existing plotly elements
      # fig_final <- cystat_add_bordermargin(fig, 
      #                                      options_fig$onRender$ADD_BORDER, 
      #                                      options_fig$onRender$ADD_MARGIN)
      # ###########################################
      
      html_fname <- paste0(subtheme,"_",toupper(lang),".html")
      htmlwidgets::saveWidget(
        widget = fig_final,
        file = paste0(graph_dir,"/",html_fname),
        libdir="lib",
        selfcontained = TRUE
      )
      
      cat(paste0("----->> Graph saved to: ", graph_dir,"/",html_fname,"\n\n"))
      
      rm(colsvalue, nrows, initial_start, initial_end, custom_button, 
         fig, fig_final, html_fname)
      gc()
      
    }# --- END "status"
    
    rm(lang, dt, status)
    
  } # --- END "langs"
  
  rm(subtheme, options_fig, options_api, options_pxf)
  gc()
  cat("\n\n")
  
} # --- END "subthemes"


cat("\n\n")
data.table::fwrite(current_hashes, file=csv_changes, sep=";")
rm(current_hashes)
cat(paste0("----->> Save new Hashes file...","\n\n"))


end_time <- Sys.time()
cat("\n\n")
cat(paste0("END Time: ", end_time))
cat("\n")
timetaken <- end_time - start_time
cat(paste0("Time taken for code to run: ", timetaken, " ",units(timetaken)))
cat("\n\nFINISHED!\n\n")
cat("##############################################################################\n")
cat("\n")

rm(list=ls())
gc()

closeAllConnections()


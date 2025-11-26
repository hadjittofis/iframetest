

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
# [B] OPTIONS
subtheme <- "Tourism"
api_pxfile  <- "Tourism/Tourists/Monthly/2021012E.px"

col_value <- "Arrivals of Tourists, Monthly"

col_dates <- "MONTH"    # in format 2021M09
create_date <- function (date) { as.Date(paste0(substr(date, 1, 4), "-", substr(date, 6, 7), "-01")) }

col_trnsp <- "MEASURE"
col_trnsp_renamefrom  <- c("Annual change (%)", "Number")
col_trnsp_renameto    <- c("Perc", "Number")


html_fname  <- paste0(subtheme,".html")
cystat_db   <- "https://cystatdb23px.cystat.gov.cy:443/api/v1/en/8.CYSTAT-DB/"


# ##############################################################################
# [C] SETUP PATHS
dir.create( graph_dir <- here::here("docs/"), recursive=TRUE, showWarnings=FALSE)
dir.create( logs_gen <- here::here("logs/"), recursive=TRUE, showWarnings=FALSE)
dir.create( logs_dir <- here::here(logs_gen, subtheme,"/"), recursive=TRUE, showWarnings=FALSE)
csv_changes <- paste0(logs_gen,"/DT_Hashes.csv")


# ##############################################################################
# [C] LOGS
logfile <- file(paste0(logs_dir,"/Log_Graph_",subtheme,"_",datetime,".txt"))
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
px_metad <- pxweb::pxweb_get(url = paste0(cystat_db,api_pxfile))
cat("\n")


cat(paste("[02] Get API data...","\n"))
cat(paste("      - Build API query...","\n"))
px_varbs <- sapply(px_metad$variables, `[[`, "code")
px_query <- lapply(px_varbs, function(x) c("*"))
names(px_query) <- px_varbs
cat(paste("      - Get data via API...","\n"))
px_data <- pxweb::pxweb_get(url = paste0(cystat_db,api_pxfile), 
                            query = px_query)
cat(paste("      - Data in tabular format...","\n"))
df <- as.data.frame(px_data, column.name.type = "text", variable.value.type = "text")
dt <- data.table::as.data.table(df)

rm(cystat_db, api_pxfile,
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
  previous_hash <- previous_hashes[graph == subtheme][1,hash]
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
  hash <- data.table::data.table(graph = subtheme, datetime = datetime, status = status, hash = current_hash)
  current_hashes <- rbindlist(c(list(previous_hashes),list(hash)))
  rm(previous_hashes, previous_hash, hash)
}else{
  cat(paste("      -- No Previous hashes file found, hence CREATE file AND graph","\n"))
  status = 1
  current_hashes <- data.table::data.table(graph = subtheme, datetime = datetime, status = status, hash = current_hash)
}
setorderv(current_hashes, c("graph","datetime"), c(1,-1))
data.table::fwrite(current_hashes, file=csv_changes, sep=";")
rm(dt_raw, current_hash, current_hashes)
gc()
cat("\n")


if (status == 1) {
  cat(paste("[04] Cleaning data...","\n"))
  cat(paste("      - Identify and rename 'value' column (from'",col_value,"')","\n"))
  setnames(dt, col_value, "Value")
  
  if(nchar(col_trnsp)>0){
    cat(paste("      - Transposing the data on column '",col_trnsp,"'","\n"))
    eval(parse(text = paste0( "dt <- dcast(dt, ... ~ ", col_trnsp ,", value.var='Value')")))
    if(length(col_trnsp_renamefrom)>0){
      setnames(dt, c(col_trnsp_renamefrom), c(col_trnsp_renameto))
      colsvalue <- col_trnsp_renameto
    }else{
      colsvalue <- col_trnsp_renamefrom
    }
  }else{
    cat(paste("      - Will NOT be transposing the data...","\n"))
    colsvalue <- "Value"
  }
  
  cat(paste("      - Identify and format 'Date' column (from'",col_dates,"')","\n"))
  dt[, Date := create_date( eval(parse(text=col_dates)) )]
  
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
  
  fig <- plot_ly() %>%
    add_trace(
      data = dt,
      x = ~Date,
      y = ~Number,
      text = ~format(Date,"%b %Y"),
      hovertemplate = paste0(
        "<b>Μήνας:</b> %{text}<br>",
        "<b>Αριθμός:</b> %{y:.2r}<br>",
        "<extra></extra>"
      ),
      type = 'scatter',
      mode = 'lines+markers',
      name = "Αριθμός Αφίξεων",
      line = list(color='#17375E', width=2, dash='solid'),
      marker = list(color='#17375E', size=5, symbol='circle' ),
      visible = TRUE
    ) %>%
    add_trace(
      data = dt,
      x = ~Date,
      y = ~Perc,
      type = 'scatter',
      mode = 'lines+markers',
      name = "Ετήσια μεταβολή (%)",
      line = list(color='#17375E', width=2, dash='solid'),
      marker = list(color='#17375E', size=5, symbol='circle' ),
      visible = FALSE
    ) %>%
    layout(
      title = list(text=col_value),
      showlegend=FALSE,
      font = list(
        family = "Verdana",
        size = 14,
        color = "black"
      ),
      margin = list(
        l = 100,
        r = 100,
        b = 50,
        t = 50
      ),
      # paper_bgcolor = 'red',
      # plot_bgcolor = 'white',
      hoverlabel = list(
        bgcolor = "white",      
        font = list(color = "#17375E"),
        bordercolor = "#17375E"
      ),
      updatemenus = list(
        list(
          type = "buttons", #"buttons" --> radio buttons, "dropdown" --> dropdown list
          active = 0,
          xanchor = "left",
          x = 0.05, # xanchor's x-position of updatemenus
          buttons = list(
            list(label = "Αριθμός", method = "update",
                 args = list(list(visible = c(TRUE, FALSE)),
                             list(yaxis = list(
                               title = list(text="Αριθμός Αφίξεων", standoff = 10))))),
            list(label = "Ετήσια μεταβολή (%)", method = "update",
                 args = list(list(visible = c(FALSE, TRUE)),
                             list(yaxis = list(
                               title = list(text="Ετήσια μεταβολή (%)", standoff = 10)))))
          )
        )
      ),
      xaxis = list(
        title = "Μήνας",
        range = c(initial_start, initial_end),
        fixedrange = FALSE,
        tickangle = -45,
        rangeslider = list(
          visible = TRUE,
          type = "date",
          range = c(min(dt$Date, na.rm=T), max(dt$Date, na.rm=T)),
          
          # To hide the context plot in the range slider:
          thickness = 0.03,
          bgcolor = 'white'
        )
      ),
      yaxis = list(
        title = list(text="Αριθμός Αφίξεων", standoff = 10),
        fixedrange = FALSE,
        autorange = TRUE
      )
    )
  
  
  fig_with_border <- htmlwidgets::onRender(
    x = fig,
    jsCode = "
    function(el, x) {
      // Apply border and margins to the container element
      el.parentElement.style.border = '3px solid black';
      el.parentElement.style.marginLeft = '100px';
      el.parentElement.style.marginRight = '100px';
      el.parentElement.style.marginTop = '10px';
      el.parentElement.style.marginBottom = '10px';
      
      var mainSvg = el.querySelector('.main-svg');
      if (mainSvg) {
        mainSvg.style.width = '98%'; 
        mainSvg.style.height = '98%';
      }
    
      // Force Plotly to recalculate its layout based on the parent's new dimensions
      // Use a timeout as a final safeguard, though it might not be necessary now.
      var fixLayout = function() {
        Plotly.relayout(el, {});
        
        if (window.dispatchEvent) {
          window.dispatchEvent(new Event('resize'));
        } else { // For older IE
          window.fireEvent('onresize');
        }
      };
      
      setTimeout(fixLayout, 50);
    }
  "
  )
  
  # fig
  # fig_with_border
  
  htmlwidgets::saveWidget(
    widget = fig,
    file = paste0(graph_dir,"/noborder_",html_fname),
    libdir="lib",
    selfcontained = TRUE
  )
  
  htmlwidgets::saveWidget(
    widget = fig_with_border,
    file = paste0(graph_dir,"/",html_fname),
    libdir="lib",
    selfcontained = TRUE
  )
  cat(paste0("#### Graph saved to: ", graph_dir,"/",html_fname,"\n"))
  
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


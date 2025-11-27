
# ######## PX FILE DOWNLOAD OPTIONS
options_api <- list(
  subtheme = "Tourism",
  lang = "en",
  db = "https://cystatdb23px.cystat.gov.cy:443/api/v1/en/8.CYSTAT-DB/",
  pxf = "Tourism/Tourists/Monthly/2021012E.px",
  user_link ="https://www.google.com"
)

# ######## PX FILE EDIT OPTIONS
options_pxf <- list(
  col_value = "Arrivals of Tourists, Monthly",
  col_date  = "MONTH",    # in format 2021M09
  col_trnsp = "MEASURE",  # if empty, no transposition
  col_trnsp_renamefrom = c("Number", "Annual change (%)"),
  col_trnsp_renameto = c("Number", "Perc")
)

# ######## FIGURE OPTIONS
fig_options <- list(
  gen=list(    
    margin_b = list(l = 100, r = 100, b = 50, t = 50), # figure margin from border
    standoff = 10           # distance axes labels from axes
  ),
  fonts = list(
    font_t = "Verdana",     # font type
    font_c = "black",       # font color
    font_s = 14             # font size
  ),
  hover = list(
    hover_t = "x unified",  # hover type
    hover_c = "#17375E",  # hover font color
    hover_b = "#17375E",  # hover border color
    hover_bg = "white",     # hover background color
    hover_xf = "%B %Y"      # hover format of x-axis data
  ),
  spikeline = list(
    spike_t = 'solid',      # spikeline type
    spike_c = "#17375E",  # spikeline color
    spike_s = 3             # spikeline size
  ),
  updmenus = list(
    updm_t = "buttons",     #"buttons" --> radio buttons, "dropdown" --> dropdown list
    updm_x = 0.05          # position of menus along x-axis
  ),
  xaxis = list(
    xaxis_h = "Month",      # x-axis header
    xaxis_la = -45,         # x-axis angle of labels
    xaxis_rs_v = TRUE,      # should a rangslider appear on the x-axis?
    xaxis_rs_t = "date",    # type of rangeslider
    xaxis_rs_c = "white",   # background color of rangeslider
    xaxis_rs_s = 0.03       # thicness of rangeslider
  ),  
  trace = list(
    list(
      yaxis_h = options_pxf$col_trnsp_renamefrom[1],  # y-axis header
      buttn_h = options_pxf$col_trnsp_renameto[1],    # button header
      hover_h = options_pxf$col_trnsp_renamefrom[1],  # hover header (y-axis)
      hover_f = "{y:.0f}",    # y-values display format
      type = 'scatter',       # line graph, bar chart, etc...
      mode = 'lines+markers', # line mode
      line_t  = 'solid',      # line type
      line_c  = '#17375E',  # line color
      line_s  = 2,            # line size
      point_t = 'circle',     # points type
      point_c = '#17375E',  # points color
      point_s = 5             # points size
    ),
    list(
      yaxis_h = options_pxf$col_trnsp_renamefrom[2],  # y-axis header
      buttn_h = options_pxf$col_trnsp_renameto[2],    # button header
      hover_h = options_pxf$col_trnsp_renamefrom[2],  # hover header (y-axis)      
      hover_f = "{y:.0f}",    # y-values display format
      type = 'scatter',       # line graph, bar chart, etc...
      mode = 'lines+markers', # line mode
      line_t  = 'solid',      # line type
      line_c  = '#17375E',  # line color
      line_s  = 2,            # line size
      point_t = 'circle',     # points type
      point_c = '#17375E',  # points color
      point_s = 5             # points size
    )    
  ),
  onRender = list(
    ADD_BORDER = list(TRUE, "3px solid black"), # border style
    ADD_MARGIN = list(TRUE, c('10px','100px','10px','100px')) # margins clockside from top
  )  
)




# Create date fields out of text fields of the form "2021M09"
cystat_date <- function (date) { 
  as.Date(paste0(substr(date, 1, 4), "-", substr(date, 6, 7), "-01")) 
}




# Create a custom button to link to CYSTAT DB table
cystat_custbuttn <- function (url) { 
  cystatdb_icon <- 'M 786 554 v 267 q 0 15 -11 26 t -25 10 h -214 v -214 h -143 v 214 h -214 q -15 0 -25 -10 t -11 -26 v -267 q 0 -1 0 -2 t 0 -2 l 321 -264 321 264 q 1 1 1 4 z m 124 -39 l -34 41 q -5 5 -12 6 h -2 q -7 0 -12 -3 l -386 -322 -386 322 q -7 4 -13 4 -7 -2 -12 -7 l -35 -41 q -4 -5 -3 -13 t 6 -12 l 401 -334 q 18 -15 42 -15 t 43 15 l 136 114 v -109 q 0 -8 -5 -13 t -13 -5 h 107 q 8 0 13 5 t 5 13 v 227 l 122 102 q 5 5 6 12 t -4 13 z'
  
  buttn <- list(
    name  = "Link to CYSTAT-DB", # Tooltip text when hovering over the button
    icon = list('height' = 928.6, 
                'width' = 1000, 
                'path' = cystatdb_icon
    ),
    click= htmlwidgets::JS( paste0(" function() {window.open('", url, "', '_blank');}") )
  )

  return(buttn)
}





# create margin around figure
cystat_add_bordermargin <- function(figure, fig_ADD_BORDER, fig_ADD_MARGIN){  
  jsCode_str <- "function(el, x) {"
  
  if(fig_ADD_BORDER[[1]]){
    jsCode_str <- paste0(jsCode_str,"
        // Apply border to the container element
        el.parentElement.style.border = '",fig_ADD_BORDER[[2]],"';
        ")
  }

  if(fig_ADD_MARGIN[[1]]){
    jsCode_str <- paste0(jsCode_str,"
        // Apply margins to the container element
        el.parentElement.style.marginTop = '",fig_ADD_MARGIN[[2]][1],"';
        el.parentElement.style.marginRight = '",fig_ADD_MARGIN[[2]][2],"';
        el.parentElement.style.marginBottom = '",fig_ADD_MARGIN[[2]][3],"';
        el.parentElement.style.marginLeft = '",fig_ADD_MARGIN[[2]][4],"';

        var mainSvg = el.querySelector('.main-svg');
        if (mainSvg) {
          mainSvg.style.width = '98%'; 
          mainSvg.style.height = '98%';
        }
        ")
  }

  if(fig_ADD_BORDER[[1]] | fig_ADD_MARGIN[[1]]){
    jsCode_str <- paste0(jsCode_str,"
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
    ")

    figure <- htmlwidgets::onRender(x = figure, jsCode = jsCode_str)
  }

  return(figure)
}




  
# create plotly figure
cystat_plotly <- function(data_dt, xcol, ycols, fig_options){
  
  buttons_list <- list()
  for(t in 1:length(ycols)){
    if(t == 1){
      vis <- TRUE # Make the first trace visible by default
    } else {
      vis <- 'legendonly' # Hide subsequent traces by default
    }
    
    fig <- add_trace( fig,
                      data = dt,
                      x = dt[[xcol]],
                      y = dt[[ycols[t]]],
                      hovertemplate = paste0(
                        "<b>",fig_options$trace[[t]]$hover_h,":</b> %",fig_options$trace[[t]]$hover_f,
                        "<extra></extra>"),
                      type = fig_options$trace[[t]]$type,
                      mode = fig_options$trace[[t]]$mode,
                      name = fig_options$trace[[t]]$yaxis_h,
                      line = list(color = fig_options$trace[[t]]$line_c,
                                  width = fig_options$trace[[t]]$line_s,
                                  dash = fig_options$trace[[t]]$line_t
                                  ),
                      marker = list(color = fig_options$trace[[t]]$point_c,
                                    size = fig_options$trace[[t]]$point_s,
                                    symbol = fig_options$trace[[t]]$point_t
                                    ),
                      visible = vis)
    
    
    buttons_list[[t]] <- list(label = fig_options$trace[[t]]$buttn_h,
                              method = "update",
                              args = list(list(visible = c(ycols==ycols[t])),
                                          list(yaxis = list(title = list(text=fig_options$trace[[t]]$yaxis_h, 
                                                                         standoff = fig_options$gen$standoff)))))
  }
  
  fig <- layout(fig,
                title = list(text=options_pxf$col_value),
                showlegend=FALSE,
                font = list(
                  family = fig_options$fonts$font_t,
                  size = fig_options$fonts$font_s,
                  color = fig_options$fonts$font_c
                ),
                hovermode = fig_options$hover$hover_t,
                hoverlabel = list(
                  bgcolor = fig_options$hover$hover_bg,     
                  font = list(color = fig_options$hover$hover_c),
                  bordercolor = fig_options$hover$hover_b
                ),
                margin = fig_options$gen$margin_b,
                updatemenus = list(
                  list(
                    type = fig_options$updmenus$updm_t, 
                    active = 0,
                    xanchor = "left",
                    x = fig_options$updmenus$updm_x,
                    buttons = buttons_list
                  )
                ), # --END-- updatemenus
                xaxis = list(
                  title = fig_options$xaxis$xaxis_h,
                  hoverformat = fig_options$hover$hover_xf,
                  range = c(initial_start, initial_end),
                  fixedrange = FALSE,
                  tickangle = fig_options$xaxis$xaxis_la,
                  showspikes = TRUE,
                  spikemode = "across",
                  spikesnap = 'data',
                  spikecolor = fig_options$spikeline$spike_c,
                  spikethickness = fig_options$spikeline$spike_s,
                  spikedash = fig_options$spikeline$spike_t,
                  rangeslider = list(
                    visible = fig_options$xaxis$xaxis_rs_v,
                    type = fig_options$xaxis$xaxis_rs_t,
                    range = c(min(dt$Date, na.rm=T), max(dt$Date, na.rm=T)),
                    thickness = fig_options$xaxis$xaxis_rs_s,
                    bgcolor = fig_options$xaxis$xaxis_rs_c
                  )
                ), # --END-- xaxis
                yaxis = list(
                  title = list(text=fig_options$trace[[1]]$yaxis_h, standoff = fig_options$gen$standoff),
                  fixedrange = FALSE,
                  autorange = TRUE
                ) # --END-- yaxis
  )

  return(fig)
}




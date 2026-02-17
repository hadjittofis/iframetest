

# ###########################################################################################################
# Create date fields out of text fields of the form "2021" or "2021M09"
cystat_date <- function (dtname, datecol) { 
  
  dtinner <- copy(eval(parse(text=dtname)))
  dtinner[, dateinner := as.character(eval(parse(text=datecol)))]
  
  date_nchar <- dtinner[!is.na(dateinner), nchar(dateinner)][1]
  if(date_nchar==4){ # Annual data (e.g. "2021")
    dtinner[, Date := as.Date(paste0(dateinner, "-01-01")) ]
  }else if(date_nchar==7){ # Monthly data (e.g. "2021M09")
    dtinner[, Date := as.Date(paste0(substr(dateinner, 1, 4), "-", substr(dateinner, 6, 7), "-01")) ]
  }
  dtinner[, dateinner := NULL]
  
  return(dtinner)
}



# ###########################################################################################################
# Create a custom button to link to CYSTAT DB table
cystat_custbuttn <- function (url) { 
  # List of svg paths for all font awsome icons: https://gist.github.com/leejordan/6d43d5bf5cf438177b1d
  cystatdb_icon_home <- 'M 786 554 v 267 q 0 15 -11 26 t -25 10 h -214 v -214 h -143 v 214 h -214 q -15 0 -25 -10 t -11 -26 v -267 q 0 -1 0 -2 t 0 -2 l 321 -264 321 264 q 1 1 1 4 z m 124 -39 l -34 41 q -5 5 -12 6 h -2 q -7 0 -12 -3 l -386 -322 -386 322 q -7 4 -13 4 -7 -2 -12 -7 l -35 -41 q -4 -5 -3 -13 t 6 -12 l 401 -334 q 18 -15 42 -15 t 43 15 l 136 114 v -109 q 0 -8 -5 -13 t -13 -5 h 107 q 8 0 13 5 t 5 13 v 227 l 122 102 q 5 5 6 12 t -4 13 z'
  cystatdb_icon_db <- 'M1024 1024q237 0 443-43t325-127v170q0 69-103 128t-280 93.5-385 34.5-385-34.5-280-93.5-103-128v-170q119 84 325 127t443 43z m0 768q237 0 443-43t325-127v170q0 69-103 128t-280 93.5-385 34.5-385-34.5-280-93.5-103-128v-170q119 84 325 127t443 43z m0-384q237 0 443-43t325-127v170q0 69-103 128t-280 93.5-385 34.5-385-34.5-280-93.5-103-128v-170q119 84 325 127t443 43z m0-1152q208 0 385 34.5t280 93.5 103 128v128q0 69-103 128t-280 93.5-385 34.5-385-34.5-280-93.5-103-128v-128q0-69 103-128t280-93.5 385-34.5z'
  
  buttn <- list(
    name  = "Link to CYSTAT-DB", # Tooltip text when hovering over the button
    icon = list(# 'height' = 928.6, 'width' = 1000,  # for HOME icon
                'height' = 2200, 'width' = 2000, 
                'path' = cystatdb_icon_db
    ),
    click= htmlwidgets::JS( paste0(" function() {window.open('", url, "', '_blank');}") )
  )

  return(buttn)
}



# ###########################################################################################################
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
        
        setTimeout(fixLayout, 100);
      }
    ")

    figure <- htmlwidgets::onRender(x = figure, jsCode = jsCode_str)
  }

  return(figure)
}



# ###########################################################################################################
# Create Plotly figure - Bar or Line Chart
cystat_plotly <- function(data_dt="dt", lang, xcol, ycols, options_fig){
  
  dt_inn <- copy(eval(parse(text=data_dt)))
  
  if(options_fig$show_updmenu){ buttons_list <- list() }
  
  for(t in 1:length(ycols)){
    
    if(options_fig$show_updmenu){
      if(t == 1){
        vis <- TRUE # Make the first trace visible by default
      } else {
        vis <- 'legendonly' # Hide subsequent traces by default
      }
    }
    
    fig <- add_trace( fig,
                      data = dt_inn,
                      x = dt_inn[[xcol]],
                      y = dt_inn[[ycols[t]]],
                      hovertemplate = paste0(
                        options_fig$trace[[t]][[lang]]$hover_h,": <b>%", 
                        options_fig$trace[[t]]$hover_f,
                        "</b>","<extra></extra>"),
                      type = options_fig$trace[[t]]$type,
                      name = options_fig$trace[[t]][[lang]]$yaxis_h,
                      visible = if(options_fig$show_updmenu){vis}else{NULL},
                      
                      marker = if(options_fig$gen$chart_type=="line"){
                        list(color = options_fig$trace[[t]]$point_c,
                             size = options_fig$trace[[t]]$point_s,
                             symbol = options_fig$trace[[t]]$point_t
                             )
                        }else if(options_fig$gen$chart_type=="bar"){
                          list(color = options_fig$trace[[t]]$bar_c)
                        }else{NULL},
                      
                      mode = if(options_fig$gen$chart_type=="line"){
                        options_fig$trace[[t]]$mode
                        }else{NULL},  
                      
                      line = if(options_fig$gen$chart_type=="line"){
                        list(color = options_fig$trace[[t]]$line_c,
                             width = options_fig$trace[[t]]$line_s,
                             dash = options_fig$trace[[t]]$line_t)
                        }else{NULL}
                      )
    
    if(options_fig$show_updmenu){
      buttons_list[[t]] <- list(label = options_fig$trace[[t]][[lang]]$buttn_h,
                                method = "update",
                                args = list(list(visible = c(ycols==ycols[t])),
                                            list(yaxis = list(title = list(text=options_fig$trace[[t]][[lang]]$yaxis_h, 
                                                                           standoff = options_fig$gen$standoff)))))
    }
    if(options_fig$show_updmenu){
      rm(vis)
    }
  }
  
  fig <- layout(fig,
                title = list(text=options_fig$title[[lang]]),
                showlegend = options_fig$showlegend,
                legend = if(options_fig$showlegend){
                  list(
                    orientation = options_fig$legend$orientation,
                    x = options_fig$legend$x,
                    xanchor = options_fig$legend$xanchor,
                    y = options_fig$legend$y,
                    yanchor = options_fig$legend$yanchor,
                    itemwidth = options_fig$legend$itemwidth,
                    font = list(size = options_fig$fonts$font_s - 1)
                  )
                },
                font = list(
                  family = options_fig$fonts$font_t,
                  size = options_fig$fonts$font_s,
                  color = options_fig$fonts$font_c
                ),
                separators = ',.',
                hovermode = options_fig$hover$hover_t,
                hoverlabel = list(
                  bgcolor = options_fig$hover$hover_bg,
                  font = list(color = options_fig$hover$hover_c),
                  bordercolor = options_fig$hover$hover_b
                ),
                margin = options_fig$gen$margin_b,
                barmode = if(options_fig$gen$chart_type=="bar"){
                  options_fig$gen$bar_mode
                },
                updatemenus = if(options_fig$show_updmenu){
                  list(
                    list(
                      type = options_fig$updmenus$updm_t,
                      active = 0,
                      xanchor = "left",
                      x = options_fig$updmenus$updm_x,
                      buttons = buttons_list
                    )
                  )
                } else {NULL},     # --END-- updatemenus
               
                xaxis = list(
                  title = options_fig$xaxis$xaxis_h,
                  hoverformat = options_fig$hover$hover_xf,
                  range = if(options_fig$gen$chart_type=="line"){
                    c(initial_start, initial_end)
                    }else{NULL},
                  expand = options_fig$xaxis$xaxis_e,
                  fixedrange = FALSE,
                  tickangle = options_fig$xaxis$xaxis_la,
                  showspikes = TRUE,
                  spikemode = "across+toaxis", # across
                  spikesnap = 'data',
                  spikecolor = options_fig$spikeline$spike_c,
                  spikethickness = options_fig$spikeline$spike_s,
                  spikedash = options_fig$spikeline$spike_t,
                  rangeslider = list(
                    visible = options_fig$xaxis$xaxis_rs_v,
                    type = options_fig$xaxis$xaxis_rs_t,
                    range = c(min(dt_inn$Date, na.rm=T), max(dt_inn$Date, na.rm=T)),
                    thickness = options_fig$xaxis$xaxis_rs_s,
                    bgcolor = options_fig$xaxis$xaxis_rs_c
                  )
                ), # --END-- xaxis
                
                yaxis = list(
                  title = if(! options_fig$use_annotations){
                    list(text = options_fig$yaxis[[lang]]$title,
                         standoff = options_fig$gen$standoff
                         )
                    }else{NULL},
                  fixedrange = FALSE,
                  autorange = TRUE
                ), # --END-- yaxis
                
                annotations = if(options_fig$use_annotations){ # for y-axis label to appear at the top, where the axis arrow ends
                    list(
                      x = options_fig$annotations$x,
                      y = options_fig$annotations$y,
                      xref = options_fig$annotations$xref,
                      yref = options_fig$annotations$yref,
                      text = options_fig$yaxis[[lang]]$title,
                      showarrow = options_fig$annotations$showarrow,
                      xanchor = options_fig$annotations$xanchor,
                      yanchor = options_fig$annotations$yanchor,
                      font = list(
                        family = options_fig$fonts$font_t,
                        size = options_fig$fonts$font_s,
                        color = options_fig$fonts$font_c
                      )
                    )
                  } # --END-- annotations
  )
  
  return(fig)
}





# ######## PX FILE DOWNLOAD OPTIONS
options_api <- list(
  en=list(
    subtheme = "Tourism",
    db = "https://cystatdb23px.cystat.gov.cy:443/api/v1/en/8.CYSTAT-DB/",
    pxf = "Tourism/Tourists/Monthly/2021012E.px",
    user_link ="https://cystatdb23px.cystat.gov.cy:443/sq/a6c94e17-57a4-4c11-a886-2629ffa73615"
  ),
  el=list(
    subtheme = "Tourism",
    db = "https://cystatdb23px.cystat.gov.cy:443/api/v1/el/8.CYSTAT-DB/",
    pxf = "Tourism/Tourists/Monthly/2021012G.px",
    user_link ="https://cystatdb23px.cystat.gov.cy:443/sq/4721a586-85e0-4c5e-ab24-dcf085ed0bf7"
  )
)

# ######## PX FILE EDIT OPTIONS
options_pxf <- list(
  en=list(
    col_value = "Arrivals of Tourists, Monthly",
    col_date  = "MONTH",    # in format 2021M09
    col_trnsp = "MEASURE",  # if empty, no transposition
    col_trnsp_renamefrom = c("Number", "Annual change (%)"),
    col_trnsp_renameto = c("Number of Arrivals", "Annual change (%)")
  ),
  el=list(
    col_value = "Αφίξεις Τουριστών, Μηνιαία",
    col_date  = "ΜΗΝΑΣ",    # in format 2021M09
    col_trnsp = "ΜΕΤΡΟ",    # if empty, no transposition
    col_trnsp_renamefrom = c("Αριθμός", "Ετήσια μεταβολή (%)"),
    col_trnsp_renameto = c("Αριθμός Αφίξεων", "Ετήσια μεταβολή (%)")
  )
)

# ######## FIGURE OPTIONS
options_fig <- list(
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
      en=list(
        yaxis_h = options_pxf$en$col_trnsp_renamefrom[1],  # y-axis header
        buttn_h = options_pxf$en$col_trnsp_renameto[1],    # button header
        hover_h = options_pxf$en$col_trnsp_renamefrom[1]   # hover header (y-axis)
      ),
      el=list(
        yaxis_h = options_pxf$el$col_trnsp_renamefrom[1],  # y-axis header
        buttn_h = options_pxf$el$col_trnsp_renameto[1],    # button header
        hover_h = options_pxf$el$col_trnsp_renamefrom[1]   # hover header (y-axis)
      ),
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
      en=list(
        yaxis_h = options_pxf$en$col_trnsp_renamefrom[2],  # y-axis header
        buttn_h = options_pxf$en$col_trnsp_renameto[2],    # button header
        hover_h = options_pxf$en$col_trnsp_renamefrom[2]   # hover header (y-axis)    
      ),
      el=list(
        yaxis_h = options_pxf$el$col_trnsp_renamefrom[2],  # y-axis header
        buttn_h = options_pxf$el$col_trnsp_renameto[2],    # button header
        hover_h = options_pxf$el$col_trnsp_renamefrom[2]   # hover header (y-axis)    
      ),
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

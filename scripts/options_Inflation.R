# ######## PX FILE DOWNLOAD OPTIONS
options_api <- list(
  en=list(
    subtheme = "Inflation",
    db = "https://cystatdb23px.cystat.gov.cy:443/api/v1/en/8.CYSTAT-DB/",
    pxf = "Price Indices/Consumer Price Index/0410050E.px",
    user_link ="https://cystatdb23px.cystat.gov.cy:443/sq/67ef91a3-0296-4040-a059-0701223b68a0"
  ),
  el=list(
    subtheme = "Inflation",
    db = "https://cystatdb23px.cystat.gov.cy:443/api/v1/el/8.CYSTAT-DB/",
    pxf = "Price Indices/Consumer Price Index/0410050G.px",
    user_link ="https://cystatdb23px.cystat.gov.cy:443/sq/8c2b489f-78c9-4b88-ad1d-27d8e71f2819"
  )
)

# ######## PX FILE EDIT OPTIONS
options_pxf <- list(
  en=list(
    col_value = "Inflation, Annual",
    col_date  = "YEAR",    # in format 2021
    col_trnsp = NULL,  # if NULL, no transposition
    col_trnsp_colunits = NULL,
    col_trnsp_colnames = NULL,
    col_trnsp_renamefrom = c(""),
    col_trnsp_renameto = c("")
  ),
  el=list(
    col_value = "Πληθωρισμός, Ετήσια",
    col_date  = "ΕΤΟΣ",    # in format 2021    
    col_trnsp = NULL,  # if NULL, no transposition
    col_trnsp_colunits = NULL,
    col_trnsp_colnames = NULL,
    col_trnsp_renamefrom = c(""),
    col_trnsp_renameto = c("")
  )
)

# ######## FIGURE OPTIONS
options_fig <- list(
  title = list(
    en="Annual Inflation",
    el="Ετήσιος Πληθωρισμός"
  ),
  gen=list(    
    margin_b = list(l = 100, r = 100, b = 50, t = 50), # figure margin from border
    standoff = 10,           # distance axes labels from axes
    chart_type = "line",    # "bar" or "line"
    bar_mode = ""           #  in case chart_type = "bar": stack or group
  ),
  fonts = list(
    font_t = "Verdana",     # font type
    font_c = "black",       # font color
    font_s = 14             # font size
  ),
  hover = list(
    hover_t = "x unified",  # hover type
    hover_c = "black",  # hover font color
    hover_b = "black",  # hover border color
    hover_bg = "white",     # hover background color
    hover_xf = list(
      en="Year: %Y",
      el="Έτος: %Y"
    )      # hover format of x-axis data
  ),
  spikeline = list(
    spike_t = 'dash',      # spikeline type
    spike_c = "black",  # spikeline color
    spike_s = 2             # spikeline size
  ),
  showlegend = FALSE,
  legend = list(
    x = 0.5,
    y = -0.07,
    xanchor = "center",
    yanchor = "top",
    orientation = "h",
    itemwidth = 120
  ),
  show_updmenu = FALSE,
  updmenus = list(
    updm_t = "buttons",     #"buttons" --> radio buttons, "dropdown" --> dropdown list
    updm_x = 0.05          # position of menus along x-axis
  ),
  xaxis = list(
    xaxis_h = "",      # x-axis header
    xaxis_la = -45,         # x-axis angle of labels
    xaxis_rs_v = FALSE,      # should a rangslider appear on the x-axis?
    xaxis_rs_t = "date",    # type of rangeslider
    xaxis_rs_c = "white",   # background color of rangeslider
    xaxis_rs_s = 0.03       # thicness of rangeslider
  ),  
  yaxis = list(
    en = list(title = "%"),
    el = list(title = "%")
  ),
  use_annotations = TRUE,
  annotations = list( # for y-axis label to appear at the top, where the axis arrow ends
    x = -0.03,
    y = 0.5,
    xref = "paper",
    yref = "paper",
    showarrow = FALSE,
    xanchor = "right",
    yanchor = "middle"
  ),
  trace = list(
    list(
      en=list(
        yaxis_h = "%",  # y-axis header
        buttn_h = "",    # button header
        hover_h = "Inflation(%)"  # hover header (y-axis)
      ),
      el=list(
        yaxis_h = "%",  # y-axis header
        buttn_h = "",    # button header
        hover_h = "Πληθωρισμός(%)"  # hover header (y-axis)
      ),
      hover_f = "{y:.1f}",    # y-values display format
      type = 'scatter',       # line graph, bar chart, etc...
      
      # --- BAR GRAPH options
      bar_c = '#00065F', # bar color

      # --- LINE GRAPH options
      mode = 'lines+markers', # line mode
      line_t  = 'solid',      # line type
      line_c  = '#F28500',  # line color
      line_s  = 2,            # line size
      point_t = '',     # points type
      point_c = '',  # points color
      point_s = ''            # points size
    )
    
  ),
  onRender = list(
    ADD_BORDER = list(TRUE, "1px solid black") # border style
    # , 
    # ADD_MARGIN = list(TRUE, c('10px','100px','10px','100px')) # margins clockside from top - unused, replaced by inset=20px in prependContent function
  )  
)

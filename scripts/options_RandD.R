# ######## PX FILE DOWNLOAD OPTIONS
options_api <- list(
  en=list(
    subtheme = "RandD",
    db = "https://cystatdb23px.cystat.gov.cy:443/api/v1/en/8.CYSTAT-DB/",
    pxf = "Research and Development/1200010E.px",
    user_link ="https://cystatdb23px.cystat.gov.cy:443/sq/8af15361-db42-4803-bde8-dfcc5ea01708"
  ),
  el=list(
    subtheme = "RandD",
    db = "https://cystatdb23px.cystat.gov.cy:443/api/v1/el/8.CYSTAT-DB/",
    pxf = "Research and Development/1200010G.px",
    user_link ="https://cystatdb23px.cystat.gov.cy:443/sq/e14dcc06-917e-411a-ac3f-15b3480a285d"
  )
)

# ######## PX FILE EDIT OPTIONS
options_pxf <- list(
  en=list(
    col_value = "Main Indicators for Research and Development, Annual",
    col_date  = "YEAR",      
    col_trnsp = list("INDICATOR"),
    col_trnsp_colunits = list(
      c("41", "42", "43", "44", "45", "46")
    ),       
    col_trnsp_colnames = list(       
      c(
        "R&D personnel, by field of science: Natural Sciences",
        "R&D personnel, by field of science: Engineering and Technology",
        "R&D personnel, by field of science: Medical Sciences",
        "R&D personnel, by field of science: Agricultural Sciences",
        "R&D personnel, by field of science: Social Sciences",
        "R&D personnel, by field of science: Humanities"
      )
    ),
    col_trnsp_renamefrom = NULL,
    col_trnsp_renameto = NULL
  ),
  el=list(
    col_value = "Βασικοί Δείκτες για την Έρευνα και Ανάπτυξη, Ετήσια",
    col_date  = "ΕΤΟΣ",    
    col_trnsp = list("ΔΕΙΚΤΗΣ"),   
    col_trnsp_colunits = list(
      c("41", "42", "43", "44", "45", "46")
    ), 
    col_trnsp_colnames = list(
      c(
        "Ερευνητικό δυναμικό, κατά τομέα επιστήμης: Θετικές Επιστήμες",
        "Ερευνητικό δυναμικό, κατά τομέα επιστήμης: Επιστήμες Μηχανικού",
        "Ερευνητικό δυναμικό, κατά τομέα επιστήμης: Ιατρικές Επιστήμες",
        "Ερευνητικό δυναμικό, κατά τομέα επιστήμης: Αγροτικές Επιστήμες",
        "Ερευνητικό δυναμικό, κατά τομέα επιστήμης: Κοινωνικές Επιστήμες",
        "Ερευνητικό δυναμικό, κατά τομέα επιστήμης: Ανθρωπιστικές Επιστήμες"
      )
    ),
    col_trnsp_renamefrom = NULL,
    col_trnsp_renameto = NULL
  )
)

# ######## FIGURE OPTIONS
options_fig <- list(
  title = list(
    en="R & D Personnel by Field of Science",
    el="Ερευνητικό Δυναμικό κατά Τομέα Επιστήμης"
  ),
  gen=list(    
    margin_b = list(l = 100, r = 100, b = 50, t = 50), # figure margin from border
    standoff = 10,           # distance axes labels from axes
    chart_type = "bar",     # "bar" or "line"
    bar_mode = "stack"      #  in case chart_type = "bar": stack or group
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
    hover_xf = "Year: %Y"      # hover format of x-axis data
  ),
  spikeline = list(
    spike_t = 'dash',      # spikeline type e.g. 'solid' OR 'dash'
    spike_c = "black",  # spikeline color
    spike_s = 2             # spikeline size
  ),
  showlegend = TRUE,
  legend = list(
    orientation = "h",
    x = 0.5,
    xanchor = "center",
    y = -0.05,
    yanchor = "top",
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
    en = list(title = "Full time equivalent"),
    el = list(title = "Ισοδύναμο πλήρους\nαπασχόλησης")
  ),
  use_annotations = TRUE,
  annotations = list( # for y-axis label to appear at the top, where the axis arrow ends
    x = 0,
    y = 1,
    xref = "paper",
    yref = "paper",
    showarrow = FALSE,
    xanchor = "center",
    yanchor = "top"
  ),
  trace = list(
    list(
      en=list(
        yaxis_h = "Natural Sciences",  # y-axis header
        buttn_h = "" ,    # button header
        hover_h = "Natural Sciences"   # hover header (y-axis)
      ),
      el=list(
        yaxis_h = "Θετικές Επιστήμες",  # y-axis header
        buttn_h = "" ,    # button header
        hover_h = "Θετικές Επιστήμες"   # hover header (y-axis)
      ),
      hover_f = "{y:.0f}",    # y-values display format
      type = 'bar',       # line graph, bar chart, etc...

      # --- BAR GRAPH options
      bar_c = '#00065F', # bar color
      
      # --- LINE GRAPH options
      mode = 'lines+markers', # line mode
      line_t  = 'solid',      # line type
      line_c  = '#00065F',  # line color
      line_s  = 2,            # line size
      point_t = 'circle',     # points type
      point_c = '#00065F',  # points color
      point_s = 5             # points size
    )
    ,
    list(
      en=list(
        yaxis_h = "Engineering and technology",  # y-axis header
        buttn_h = "" ,    # button header
        hover_h = "Engineering and technology"   # hover header (y-axis)
      ),
      el=list(
        yaxis_h = "Επιστήμες Μηχανικού",  # y-axis header
        buttn_h = "" ,    # button header
        hover_h = "Επιστήμες Μηχανικού"   # hover header (y-axis)
      ),
      hover_f = "{y:.0f}",    # y-values display format
      type = 'bar',       # line graph, bar chart, etc...

      # --- BAR GRAPH options
      bar_c = '#ff7f0e', # bar color
      
      # --- LINE GRAPH options
      mode = 'lines+markers', # line mode
      line_t  = 'solid',      # line type
      line_c  = '#ff7f0e',  # line color
      line_s  = 2,            # line size
      point_t = 'circle',     # points type
      point_c = '#ff7f0e',  # points color
      point_s = 5             # points size
    )
    ,
    list(
      en=list(
        yaxis_h = "Medical Sciences",  # y-axis header
        buttn_h = "",    # button header
        hover_h = "Medical Sciences"   # hover header (y-axis)
      ),
      el=list(
        yaxis_h = "Ιατρικές επιστήμες",  # y-axis header
        buttn_h = "",   # button header
        hover_h = "Ιατρικές επιστήμες"   # hover header (y-axis)
      ),
      hover_f = "{y:.0f}",    # y-values display format
      type = 'bar',       # line graph, bar chart, etc...

      # --- BAR GRAPH options
      bar_c = '#d62728', # bar color
      
      # --- LINE GRAPH options
      mode = 'lines+markers', # line mode
      line_t  = 'solid',      # line type
      line_c  = '#d62728',  # line color
      line_s  = 2,            # line size
      point_t = 'circle',     # points type
      point_c = '#d62728',  # points color
      point_s = 5             # points size
    )
    ,
    list(
      en=list(
        yaxis_h = "Agricultural Sciences",  # y-axis header
        buttn_h = "" ,   # button header
        hover_h = "Agricultural Sciences"   # hover header (y-axis)
      ),
      el=list(
        yaxis_h = "Αγροτικές επιστήμες",  # y-axis header
        buttn_h = "" ,   # button header
        hover_h = "Αγροτικές επιστήμες"   # hover header (y-axis)
      ),
      hover_f = "{y:.0f}",    # y-values display format
      type = 'bar',       # line graph, bar chart, etc...

      # --- BAR GRAPH options
      bar_c = '#222222', # bar color
      
      # --- LINE GRAPH options
      mode = 'lines+markers', # line mode
      line_t  = 'solid',      # line type
      line_c  = '#222222',  # line color
      line_s  = 2,            # line size
      point_t = 'circle',     # points type
      point_c = '#222222',  # points color
      point_s = 5             # points size
    )
    ,
    list(
      en=list(
        yaxis_h = "Social Sciences",  # y-axis header
        buttn_h = "" ,   # button header
        hover_h = "Social Sciences"   # hover header (y-axis)
      ),
      el=list(
        yaxis_h = "Κοινωνικές επιστήμες",  # y-axis header
        buttn_h = "" ,   # button header
        hover_h = "Κοινωνικές επιστήμες"   # hover header (y-axis)
      ),
      hover_f = "{y:.0f}",    # y-values display format
      type = 'bar',       # line graph, bar chart, etc...
      
      # --- BAR GRAPH options
      bar_c = '#1f77b4', # bar color

      # --- LINE GRAPH options
      mode = 'lines+markers', # line mode
      line_t  = 'solid',      # line type
      line_c  = '#1f77b4',  # line color
      line_s  = 2,            # line size
      point_t = 'circle',     # points type
      point_c = '#1f77b4',  # points color
      point_s = 5             # points size
    )
    ,
    list(
      en=list(
        yaxis_h = "Humanities",  # y-axis header
        buttn_h = "" ,   # button header
        hover_h = "Humanities"   # hover header (y-axis)
      ),
      el=list(
        yaxis_h = "Ανθρωπιστικές επιστήμες",  # y-axis header
        buttn_h = "" ,    # button header
        hover_h = "Ανθρωπιστικές επιστήμες"   # hover header (y-axis)
      ),
      hover_f = "{y:.0f}",    # y-values display format
      type = 'bar',       # line graph, bar chart, etc...

      # --- BAR GRAPH options
      bar_c = '#2ca02c', # bar color
      
      # --- LINE GRAPH options
      mode = 'lines+markers', # line mode
      line_t  = 'solid',      # line type
      line_c  = '#2ca02c',  # line color
      line_s  = 2,            # line size
      point_t = 'circle',     # points type
      point_c = '#2ca02c',  # points color
      point_s = 5             # points size
    )
  ),
  onRender = list(
    ADD_BORDER = list(TRUE, "1px solid black"), # border style
    ADD_MARGIN = list(TRUE, c('10px','100px','10px','100px')) # margins clockside from top
  )  
)

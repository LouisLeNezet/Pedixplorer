# Evaluate par()

    Code
      par()
    Output
      $xlog
      [1] FALSE
      
      $ylog
      [1] FALSE
      
      $adj
      [1] 0.5
      
      $ann
      [1] TRUE
      
      $ask
      [1] FALSE
      
      $bg
      [1] "transparent"
      
      $bty
      [1] "o"
      
      $cex
      [1] 1
      
      $cex.axis
      [1] 1
      
      $cex.lab
      [1] 1
      
      $cex.main
      [1] 1.2
      
      $cex.sub
      [1] 1
      
      $cin
      [1] 0.15 0.20
      
      $col
      [1] "black"
      
      $col.axis
      [1] "black"
      
      $col.lab
      [1] "black"
      
      $col.main
      [1] "black"
      
      $col.sub
      [1] "black"
      
      $cra
      [1] 10.8 14.4
      
      $crt
      [1] 0
      
      $csi
      [1] 0.2
      
      $cxy
      [1] 0.02604 0.03876
      
      $din
      [1] 7 7
      
      $err
      [1] 0
      
      $family
      [1] ""
      
      $fg
      [1] "black"
      
      $fig
      [1] 0 1 0 1
      
      $fin
      [1] 7 7
      
      $font
      [1] 1
      
      $font.axis
      [1] 1
      
      $font.lab
      [1] 1
      
      $font.main
      [1] 2
      
      $font.sub
      [1] 1
      
      $lab
      [1] 5 5 7
      
      $las
      [1] 0
      
      $lend
      [1] "round"
      
      $lheight
      [1] 1
      
      $ljoin
      [1] "round"
      
      $lmitre
      [1] 10
      
      $lty
      [1] "solid"
      
      $lwd
      [1] 1
      
      $mai
      [1] 1.02 0.82 0.82 0.42
      
      $mar
      [1] 5.1 4.1 4.1 2.1
      
      $mex
      [1] 1
      
      $mfcol
      [1] 1 1
      
      $mfg
      [1] 1 1 1 1
      
      $mfrow
      [1] 1 1
      
      $mgp
      [1] 3 1 0
      
      $mkh
      [1] 0.001
      
      $new
      [1] FALSE
      
      $oma
      [1] 0 0 0 0
      
      $omd
      [1] 0 1 0 1
      
      $omi
      [1] 0 0 0 0
      
      $page
      [1] TRUE
      
      $pch
      [1] 1
      
      $pin
      [1] 5.76 5.16
      
      $plt
      [1] 0.1171 0.9400 0.1457 0.8829
      
      $ps
      [1] 12
      
      $pty
      [1] "m"
      
      $smo
      [1] 1
      
      $srt
      [1] 0
      
      $tck
      [1] NA
      
      $tcl
      [1] -0.5
      
      $usr
      [1] 0 1 0 1
      
      $xaxp
      [1] 0 1 5
      
      $xaxs
      [1] "r"
      
      $xaxt
      [1] "s"
      
      $xpd
      [1] FALSE
      
      $yaxp
      [1] 0 1 5
      
      $yaxs
      [1] "r"
      
      $yaxt
      [1] "s"
      
      $ylbias
      [1] 0.2
      

# Evaluate options()

    Code
      opts[!names(opts) %in% no_check]
    Output
      $CBoundsCheck
      [1] FALSE
      
      $HTTPUserAgent
      [1] "R (4.4.1 x86_64-w64-mingw32 x86_64 mingw32)"
      
      $OutDec
      [1] "."
      
      $PCRE_limit_recursion
      [1] NA
      
      $PCRE_study
      [1] FALSE
      
      $PCRE_use_JIT
      [1] TRUE
      
      $`R.methodsS3:useSearchPath`
      [1] TRUE
      
      $add.smooth
      [1] TRUE
      
      $ambiguousMethodSelection
      function (cond) 
      NULL
      <environment: R_EmptyEnv>
      
      $browser
      [1] "C:/Program Files/Google/Chrome/Application/chrome.exe"
      
      $browserNLdisabled
      [1] FALSE
      
      $callr.condition_handler_cli_message
      function (msg) 
      {
          custom_handler <- getOption("cli.default_handler")
          if (is.function(custom_handler)) {
              custom_handler(msg)
          }
          else {
              cli_server_default(msg)
          }
      }
      <bytecode: 0x00000200a4e25770>
      <environment: namespace:cli>
      
      $catch.script.errors
      [1] FALSE
      
      $check.bounds
      [1] FALSE
      
      $chromote.verbose
      [1] TRUE
      
      $citation.bibtex.max
      [1] 1
      
      $cli.condition_width
      [1] Inf
      
      $cli.dynamic
      [1] FALSE
      
      $cli.hyperlink
      [1] FALSE
      
      $cli.hyperlink_help
      [1] FALSE
      
      $cli.hyperlink_run
      [1] FALSE
      
      $cli.hyperlink_vignette
      [1] FALSE
      
      $cli.num_colors
      [1] 1
      
      $cli.unicode
      [1] FALSE
      
      $cli.width
      [1] 80
      
      $continue
      [1] "+ "
      
      $contrasts
              unordered           ordered 
      "contr.treatment"      "contr.poly" 
      
      $crayon.enabled
      [1] FALSE
      
      $datatable.alloccol
      [1] 1024
      
      $datatable.allow.cartesian
      [1] FALSE
      
      $datatable.auto.index
      [1] TRUE
      
      $datatable.dfdispatchwarn
      [1] TRUE
      
      $datatable.optimize
      [1] Inf
      
      $datatable.print.class
      [1] TRUE
      
      $datatable.print.colnames
      [1] "auto"
      
      $datatable.print.keys
      [1] TRUE
      
      $datatable.print.nrows
      [1] 100
      
      $datatable.print.rownames
      [1] TRUE
      
      $datatable.print.topn
      [1] 5
      
      $datatable.print.trunc.cols
      [1] FALSE
      
      $datatable.show.indices
      [1] FALSE
      
      $datatable.use.index
      [1] TRUE
      
      $datatable.verbose
      [1] FALSE
      
      $datatable.warnredundantby
      [1] TRUE
      
      $defaultPackages
      [1] "datasets"  "utils"     "grDevices" "graphics"  "stats"     "methods"  
      
      $demo.ask
      [1] "default"
      
      $deparse.cutoff
      [1] 60
      
      $devOptions
      $devOptions$`*`
      $devOptions$`*`$sep
      [1] ","
      
      $devOptions$`*`$path
      [1] "figures"
      
      $devOptions$`*`$force
      [1] TRUE
      
      
      
      $device
      function(...) {
              httpgd::hgd(
                  silent = TRUE
              )
              .vsc$request("httpgd", url = httpgd::hgd_url())
          }
      <environment: 0x00000200a5d9e008>
      
      $device.ask.default
      [1] FALSE
      
      $devtools.ellipsis_action
      function (message = NULL, class = NULL, ..., body = NULL, footer = NULL, 
          parent = NULL, use_cli_format = NULL, .inherit = NULL, .frequency = c("always", 
              "regularly", "once"), .frequency_id = NULL, .subclass = deprecated()) 
      {
          message <- validate_signal_args(message, class, NULL, .subclass, 
              "warn")
          message_info <- cnd_message_info(message, body, footer, caller_env(), 
              use_cli_format = use_cli_format)
          message <- message_info$message
          extra_fields <- message_info$extra_fields
          use_cli_format <- message_info$use_cli_format
          .frequency <- arg_match0(.frequency, c("always", "regularly", 
              "once"))
          if (!needs_signal(.frequency, .frequency_id, warning_freq_env, 
              "rlib_warning_verbosity")) {
              return(invisible(NULL))
          }
          if (!is_null(parent)) {
              if (is_null(.inherit)) {
                  .inherit <- !inherits(parent, "error")
              }
              extra_fields$rlang <- c(extra_fields$rlang, list(inherit = .inherit))
          }
          cnd <- warning_cnd(class, message = message, !!!extra_fields, 
              use_cli_format = use_cli_format, parent = parent, ...)
          cnd$footer <- c(cnd$footer, message_freq(message, .frequency, 
              "warning"))
          local_long_messages()
          warning(cnd)
      }
      <bytecode: 0x00000200a28bc318>
      <environment: namespace:rlang>
      
      $devtools.install.args
      [1] ""
      
      $devtools.path
      [1] "~/R-dev"
      
      $diffobj.align.count.alnum.only
      [1] TRUE
      
      $diffobj.align.min.chars
      [1] 3
      
      $diffobj.align.threshold
      [1] 0.25
      
      $diffobj.brightness
      [1] "neutral"
      
      $diffobj.color.mode
      [1] "yb"
      
      $diffobj.context
      [1] 2
      
      $diffobj.context.auto.max
      [1] 10
      
      $diffobj.context.auto.min
      [1] 1
      
      $diffobj.convert.hz.white.space
      [1] TRUE
      
      $diffobj.disp.width
      [1] 0
      
      $diffobj.format
      [1] "auto"
      
      $diffobj.guides
      [1] TRUE
      
      $diffobj.html.escape.html.entities
      [1] TRUE
      
      $diffobj.html.output
      [1] "auto"
      
      $diffobj.html.scale
      [1] TRUE
      
      $diffobj.hunk.limit
      [1] -1
      
      $diffobj.ignore.white.space
      [1] TRUE
      
      $diffobj.less.flags
      [1] "R"
      
      $diffobj.line.limit
      [1] -1
      
      $diffobj.max.diffs
      [1] 50000
      
      $diffobj.mode
      [1] "auto"
      
      $diffobj.pager
      [1] "auto"
      
      $diffobj.pager.file.keep
      [1] FALSE
      
      $diffobj.pager.file.path
      [1] NA
      
      $diffobj.pager.mode
      [1] "threshold"
      
      $diffobj.pager.threshold
      [1] -1
      
      $diffobj.rds
      [1] TRUE
      
      $diffobj.silent
      [1] FALSE
      
      $diffobj.style
      [1] "auto"
      
      $diffobj.tab.stops
      [1] 8
      
      $diffobj.trim
      [1] TRUE
      
      $diffobj.unwrap.atomic
      [1] TRUE
      
      $diffobj.warn
      [1] TRUE
      
      $diffobj.word.diff
      [1] TRUE
      
      $digits
      [1] 4
      
      $dplyr.show_progress
      [1] TRUE
      
      $echo
      [1] TRUE
      
      $editor
      [1] "notepad"
      
      $encoding
      [1] "native.enc"
      
      $example.ask
      [1] "default"
      
      $expressions
      [1] 5000
      
      $help.search.types
      [1] "vignette" "demo"     "help"    
      
      $help.try.all.packages
      [1] FALSE
      
      $help_type
      [1] "html"
      
      $httr_oauth_cache
      [1] NA
      
      $httr_oob_default
      [1] FALSE
      
      $install.packages.compile.from.source
      [1] "interactive"
      
      $internet.info
      [1] 2
      
      $keep.parse.data
      [1] TRUE
      
      $keep.parse.data.pkgs
      [1] FALSE
      
      $keep.source
      [1] TRUE
      
      $keep.source.pkgs
      [1] FALSE
      
      $lifecycle_verbosity
      [1] "warning"
      
      $locatorBell
      [1] TRUE
      
      $mailer
      [1] "mailto"
      
      $matprod
      [1] "default"
      
      $max.contour.segments
      [1] 25000
      
      $max.print
      [1] 99999
      
      $menu.graphics
      [1] TRUE
      
      $na.action
      [1] "na.omit"
      
      $nwarnings
      [1] 50
      
      $page_viewer
      function(url, title = NULL, ...,
                                   viewer = getOption("vsc.page_viewer", "Active")) {
          if (is.null(title)) {
              expr <- substitute(url)
              if (is.character(url)) {
                  title <- "Page Viewer"
              } else {
                  title <- deparse(expr, nlines = 1)
              }
          }
          show_webview(url = url, title = title, ..., viewer = viewer)
      }
      <environment: 0x00000200a5d9e008>
      
      $pager
      [1] "internal"
      
      $papersize
      [1] "a4"
      
      $pdfviewer
      [1] "C:/PROGRA~1/R/R-44~1.1/bin/x64/open.exe"
      
      $pkgType
      [1] "both"
      
      $prompt
      [1] "> "
      
      $repos
          CRAN 
      "@CRAN@" 
      
      $rlang_interactive
      [1] FALSE
      
      $scipen
      [1] 0
      
      $shiny.fullstacktrace
      [1] TRUE
      
      $shiny.testmode
      [1] TRUE
      
      $shinytest2.load_timeout
      [1] 60000
      
      $show.coef.Pvalues
      [1] TRUE
      
      $show.error.messages
      [1] TRUE
      
      $show.signif.stars
      [1] TRUE
      
      $showErrorCalls
      [1] FALSE
      
      $showNCalls
      [1] 50
      
      $showWarnCalls
      [1] FALSE
      
      $str
      $str$strict.width
      [1] "no"
      
      $str$digits.d
      [1] 3
      
      $str$vec.len
      [1] 4
      
      $str$list.len
      [1] 99
      
      $str$deparse.lines
      NULL
      
      $str$drop.deparse.attr
      [1] TRUE
      
      $str$formatNum
      function (x, ...) 
      format(x, trim = TRUE, drop0trailing = TRUE, ...)
      <environment: 0x00000200a2cc3b60>
      
      
      $str.dendrogram.last
      [1] "`"
      
      $testthat.snapshotter
      <SnapshotReporter>
        Inherits from: <Reporter>
        Public:
          .context: NULL
          .start_context: function (context) 
          add_result: function (context, test, result) 
          announce_file_snapshot: function (name) 
          capabilities: list
          cat_line: function (...) 
          cat_tight: function (...) 
          clone: function (deep = FALSE) 
          crayon: TRUE
          cur_snaps: FileSnaps, R6
          end_context: function (context) 
          end_context_if_started: function (context) 
          end_file: function () 
          end_reporter: function () 
          end_test: function (context, test) 
          fail_on_new: FALSE
          file: parameters
          hyperlinks: TRUE
          initialize: function (snap_dir = "_snaps", fail_on_new = FALSE) 
          is_active: function () 
          is_full: function () 
          local_user_output: function (.env = parent.frame()) 
          new_snaps: FileSnaps, R6
          old_snaps: FileSnaps, R6
          out: NULL
          rstudio: TRUE
          rule: function (...) 
          snap_dir: C:\Users\llenezet\Documents\Repositories\Pedixplorer\tes ...
          snap_file_seen: align/sampleped-withrel.svg align/sampleped-withrel.svg  ...
          snap_files: function () 
          start_context: function (context) 
          start_file: function (path, test = NULL) 
          start_reporter: function () 
          start_test: function (context, test) 
          take_file_snapshot: function (name, path, file_equal, variant = NULL, trace_env = NULL) 
          take_snapshot: function (value, save = identity, load = identity, ..., tolerance = testthat_tolerance(), 
          test: Evaluate options()
          test_file_seen: align app bitSize class descendants fix_parents generate ...
          unicode: TRUE
          update: function () 
          variants_changed: 
          width: 80
      
      $testthat_path
      [1] "test-parameters.R"
      
      $timeout
      [1] 60
      
      $ts.S.compat
      [1] FALSE
      
      $ts.eps
      [1] 1e-05
      
      $unzip
      [1] "internal"
      
      $useFancyQuotes
      [1] FALSE
      
      $verbose
      [1] FALSE
      
      $viewer
      function(url, title = NULL, ...,
                              viewer = getOption("vsc.viewer", "Two")) {
          if (is.null(title)) {
              expr <- substitute(url)
              if (is.character(url)) {
                  title <- "Viewer"
              } else {
                  title <- deparse(expr, nlines = 1)
              }
          }
          show_webview(url = url, title = title, ..., viewer = viewer)
      }
      <environment: 0x00000200a5d9e008>
      
      $vsc.browser
      [1] "Active"
      
      $vsc.dev.args
      $vsc.dev.args$width
      [1] 800
      
      $vsc.dev.args$height
      [1] 1200
      
      
      $vsc.globalenv
      [1] TRUE
      
      $vsc.helpPanel
      [1] "Two"
      
      $vsc.object_length_limit
      [1] 2000
      
      $vsc.object_timeout
      [1] 50
      
      $vsc.page_viewer
      [1] "Active"
      
      $vsc.plot
      [1] "Two"
      
      $vsc.row_limit
      [1] 0
      
      $vsc.rstudioapi
      [1] TRUE
      
      $vsc.show_object_size
      [1] FALSE
      
      $vsc.str.max.level
      [1] 0
      
      $vsc.use_httpgd
      [1] TRUE
      
      $vsc.use_webserver
      [1] FALSE
      
      $vsc.view
      [1] "Two"
      
      $vsc.viewer
      [1] "Two"
      
      $warn
      [1] 0
      
      $warnPartialMatchArgs
      [1] FALSE
      
      $warnPartialMatchAttr
      [1] FALSE
      
      $warnPartialMatchDollar
      [1] FALSE
      
      $warning.length
      [1] 1000
      
      $width
      [1] 80
      
      $windowsTimeouts
      [1] 100 500
      


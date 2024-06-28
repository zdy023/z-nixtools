xnoremap <localleader>( s(<c-r>")<esc>
xnoremap <localleader>[ s[<c-r>"]<esc>
xnoremap <localleader>< s<<c-r>"><esc>
xnoremap <localleader>{ s{<c-r>"}<esc>
xnoremap <localleader>" s"<c-r>""<esc>
xnoremap <localleader>' s'<c-r>"'<esc>
xnoremap <localleader>` s`<c-r>"`<esc>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> <localleader>) s（<c-r>"）<esc>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> <localleader>] s〔<c-r>"〕<esc>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> <localleader>} s【<c-r>"】<esc>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> <localleader>> s《<c-r>"》<esc>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> <localleader>@ s“<c-r>"”<esc>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> <localleader>~ s‘<c-r>"’<esc>

autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> i) lT（oht）
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> a) lF（ohf）
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> i] lT〔oht〕
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> a] lF〔ohf〕
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> i} lT【oht】
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> a} lF【ohf】
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> i> lT《oht》
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> a> lF《ohf》
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> i@ lT“oht”
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> a@ lF“ohf”
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> i~ lT‘oht’
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind xnoremap <buffer> a~ lF‘ohf’

autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> i) :norm vi)<cr>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> a) :norm va)<cr>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> i] :norm vi]<cr>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> a] :norm va]<cr>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> i} :norm vi}<cr>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> a} :norm va}<cr>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> i> :norm vi><cr>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> a> :norm va><cr>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> i@ :norm vi@<cr>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> a@ :norm va@<cr>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> i~ :norm vi~<cr>
autocmd FileType markdown,tex,dokuwiki,html,xml,vue,remind onoremap <buffer> a~ :norm va~<cr>

autocmd FileType tex xnoremap <buffer> <localleader>` s`<c-r>"'<esc>
autocmd FileType tex xnoremap <buffer> <localleader>! s``<c-r>"''<esc>
autocmd FileType markdown xnoremap <buffer> <localleader>b s**<c-r>"**<esc>
autocmd FileType markdown xnoremap <buffer> <localleader>i s*<c-r>"*<esc>
autocmd FileType markdown xnoremap <buffer> <localleader>e s***<c-r>"***<esc>
autocmd FileType markdown xnoremap <buffer> <localleader>d s~~<c-r>"~~<esc>
autocmd FileType tex xnoremap <buffer> <localleader>b s\textbf{<c-r>"}<esc>
autocmd FileType tex xnoremap <buffer> <localleader>B s{\bf <c-r>"}<esc>
autocmd FileType tex xnoremap <buffer> <localleader>i s\textit{<c-r>"}<esc>
autocmd FileType tex xnoremap <buffer> <localleader>I s{\it <c-r>"}<esc>
autocmd FileType tex xnoremap <buffer> <localleader>e s\emph{<c-r>"}<esc>
autocmd FileType tex xnoremap <buffer> <localleader>E s{\em <c-r>"}<esc>
autocmd FileType tex xnoremap <buffer> <localleader>t s\texttt{<c-r>"}<esc>
autocmd FileType tex xnoremap <buffer> <localleader>T s{\tt <c-r>"}<esc>
autocmd FileType tex xnoremap <buffer> <localleader>v s\verb|<c-r>"|<esc>
autocmd FileType dokuwiki xnoremap <buffer> <localleader>b s**<c-r>"**<esc>
autocmd FileType dokuwiki xnoremap <buffer> <localleader>i s//<c-r>"//<esc>

" vimc: novimc:
syn match AnalSecTitle /^|\d\+\.\ .*$/
syn match Comment /^#.*$/
syn match AnalMetaInfo /^[A-Z]:\ /
syn match Todo /\<TODO\>\|^I:/
syn match VIMC /^vimc:\ .*:$/
syn match AnalComplete /✓$/
syn match AnalFail /✗$/
syn match AnalInfoElm /\<i$/

hi AnalSecTitle term=bold cterm=bold
hi AnalMetaInfo term=italic ctermfg=red
hi VIMC ctermfg=grey
hi AnalComplete term=reverse,bold ctermfg=green
hi AnalFail term=reverse,bold ctermfg=red
hi AnalInfoElm term=reverse,bold ctermfg=cyan

let pattern_cif = '\<if\>:\<else\ if\>:\<else\>'
let pattern_pif = '\<if\>:\<elif\>:\<else\>'
let pattern_shif = '\<if\>:\<else\ if\>\|\<elif\>:\<else\>:\<fi\>'
let pattern_vif = '\<if\>:\<elseif\>:\<else\>:\<endif\>'

let pattern_sh = '\<do\>:\<done\>,\<case\>:\<esac\>'
let pattern_matlab = '\(^\s*\)\@<=\(while\|for\|function\|if\)\>:\(^\s*\)\@<=end\>'
let pattern_vim = '\<\(function\|while\|for\)\>:\<end\1\>'

let pattern_html = '<\([a-zA-Z0-9_-]\+\)\(\s\+.*\)*>:</\1>,<!--:-->'
let pattern_tex = '\\begin{\(.\+\)}:\\end{\1},\\left\>:\\right\>'

let pattern_ccmt = '\/\*:\*\/'
let pattern_jcmt = '\/\*\*:\*\/'

let pattern_hgpp = '<#:\(\\\)\@<!>'

let pattern_zh_cn = '（:）,【:】,‘:’,“:”,〔:〕,《:》'

autocmd FileType c,cpp let b:match_words=pattern_cif.','.pattern_ccmt
autocmd FileType java let b:match_words=pattern_cif.','.pattern_ccmt.','.pattern_jcmt
autocmd FileType python let b:match_words=pattern_pif
autocmd FileType sh let b:match_words=pattern_sh.','.pattern_shif
autocmd FileType matlab let b:match_words=pattern_matlab
autocmd FileType vim let b:match_words=pattern_vim.','.pattern_vif

autocmd FileType html,xml,vue let b:match_words=pattern_html.','.pattern_hgpp.','.pattern_zh_cn
autocmd FileType tex let b:match_words=pattern_tex.','.pattern_zh_cn
autocmd FileType markdown,dokuwiki let b:match_words=pattern_html.','.pattern_hgpp.','.pattern_tex.','.pattern_zh_cn
autocmd FileType remind let b:match_words=pattern_zh_cn

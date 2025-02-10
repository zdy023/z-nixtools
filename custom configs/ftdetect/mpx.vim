function MPXSyntax()
	syn match MPXMeta /^\S\+: .* \*$/ contains=MPXChannelSymbol,MPXMetaChar
	syn match MPXChannelSymbol /^\S\+\(: \)\@=/ contained
	syn match MPXMetaChar /\( \)\@<=\*$/ contained
	syn match MPXChannelCmd /\( \)\@<=\(|\|\*\*\|\S*>\)$/

	hi MPXChannelSymbol term=bold cterm=bold ctermfg=green
	hi MPXChannelCmd term=italic, cterm=italic ctermfg=yellow
	hi link MPXMetaChar MPXChannelCmd
endfunction

autocmd BufRead,BufNewFile *.mpx call MPXSyntax()

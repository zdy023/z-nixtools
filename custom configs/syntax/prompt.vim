syn match PromptMark /^\(%%%\|---\)/ contained
syn match PromptMeta /^%%% *\w*$/ contains=PromptMark " instruct/chat model
syn match PromptRole /^--- *\w*$/ contains=PromptMark " system/user/assistant
syn match Comment /^% .*$/
syn match PromptEscapeLine /^\\\\\\.*$/ contains=PromptEscape
syn match PromptEscape /^\\\\\\/ contained " Anything after \\\ will be parsed literally
syn match PromptSlot /\${\w\+}/ contains=PromptSlotChar
syn match PromptImage /\${image_\w\+}/ contains=PromptSlotChar,PromptImageLeading
syn match PromptImagef /\${imagef:[^:}]\+\(:\d\+\(:\d\+\)\=\)\=}/ contains=PromptSlotChar,PromptImagefLeading,PromptImageSize
syn match PromptSlotChar /\${\|}/ contained
syn match PromptImageLeading /\<image_/ contained
syn match PromptImagefLeading /\<imagef:/ contained
syn match PromptImageSize /:\d\+\>/ contained

hi PromptMark term=bold cterm=bold
hi PromptMeta term=underline cterm=bold ctermfg=red
hi PromptRole term=italic cterm=italic ctermfg=magenta
hi link PromptEscapeLine Normal
hi PromptEscape ctermfg=grey
hi PromptSlotChar term=bold cterm=bold ctermfg=yellow
hi PromptSlot term=underline cterm=bold ctermfg=green
hi PromptImage term=underline cterm=bold ctermfg=blue
hi PromptImagef term=underline cterm=bold ctermfg=blue
hi PromptImageLeading term=italic cterm=italic ctermfg=grey
hi PromptImagefLeading term=italic cterm=italic ctermfg=red
hi PromptImageSize term=italic cterm=italic ctermfg=green
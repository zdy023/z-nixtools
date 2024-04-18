syn match PromptMark /^\(%%%\|---\)/ contained
syn match PromptMeta /^%%% *\w*$/ contains=PromptMark " instruct/chat model
syn match PromptRole /^--- *\w*$/ contains=PromptMark " system/user/assistant
syn match Comment /^% .*$/
syn match PromptEscapeLine /^\\\\\\.*$/ contains=PromptEscape
syn match PromptEscape /^\\\\\\/ contained " Anything after \\\ will be parsed literally
syn match PromptSlot /\${\w\+}/ contains=PromptSlotChar
syn match PromptSlotChar /\${\|}/ contained

hi PromptMark term=bold cterm=bold
hi PromptMeta term=underline cterm=bold ctermfg=red
hi PromptRole term=italic cterm=italic ctermfg=magenta
hi link PromptEscapeLine Normal
hi PromptEscape ctermfg=grey
hi PromptSlotChar term=bold cterm=bold ctermfg=yellow
hi PromptSlot term=underline cterm=bold ctermfg=green

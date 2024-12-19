syn match PromptMark /^\(%%%\|---\|```\|===\|###\)/ contained
syn match PromptMeta /^%%% *\w*$/ contains=PromptMark " instruct/chat model
syn match PromptRole /^--- *\w*$/ contains=PromptMark " system/user/assistant

syn match PromptSegDef /^```\( \w\+\)\=$/ contains=PromptMark " define reusable segments
syn match PromptValDef /^###\( \w\+\)\=$/ contains=PromptMark " define default values for slots
" instantiate a reusable segments, the given suffix will be appended to slot
" names (or main name of image file names) to distinguish different instances
syn match PromptSegIns /^=== \w\+ \w\+$/ contains=PromptMark

syn match Comment /^% .*$/ contains=ZppCommand
syn match PromptEscapeLine /^\\\\\\.*$/ contains=PromptEscape
syn match PromptEscape /^\\\\\\/ contained " Anything after \\\ will be parsed literally

syn match PromptSlot /\(\(^\|[^$]\)\(\$\$\)*\)\@<=\${\=\w\+}\=/ contains=PromptSlotChar
syn match PromptImage /\(\(^\|[^$]\)\(\$\$\)*\)\@<=\${\=image\(_\w\+\)\=}\=/ contains=PromptSlotChar,PromptImageLeading
syn match PromptImagef /\(\(^\|[^$]\)\(\$\$\)*\)\@<=\${imagef:[^:}]\+\(:\d\+\(:\d\+\)\=\)\=}/ contains=PromptSlotChar,PromptImagefLeading,PromptImageSize
syn match PromptSlotChar /\${\=\|}/ contained
syn match PromptImageLeading /\<image_\=/ contained
syn match PromptImagefLeading /\<imagef:/ contained
syn match PromptImageSize /:\d\+\>/ contained

syn match LiteralDollar /\$\$/

syn region ZppCommand start=/\(^% *\)\@<=\(include\|defineR\=\|undef\|\(el\)\=ifn\=\(def\|eqn\=\|[gl][et]\)\|else\|endif\|else\|endif\)/ end="$" contained contains=ZppCommandName,ZppMacroName,ZppFix,ZppLinePreFix,ZppLineSufFix,ZppReSub,ZppRegex
"syn match ZppCommandStart /\(^% *\)\@<=/ contained nextgroup=ZppIncludeCommand,ZppMacroCommand,ZppSingleCommand
"syn match ZppFileName /[^-+/<>].*\(\s*$\)\@=/ contains=ZppAbsMark contained

syn keyword ZppCommandName contained include define[R] undef ifdef ifeq ifeqn ifge ifle ifgt iflt ifndef ifneq ifneqn ifnge ifnle ifngt ifnlt elifdef elifeq elifeqn elifge elifle elifgt eliflt elifndef elifneq elifneqn elifnge elifnle elifngt elifnlt else endif

"syn match ZppIncludeCommand /\(^% *\)\@<=include\>/ contained "skipwhite nextgroup=ZppFix,ZppLineFix,ZppReSub,ZppFileName
syn match ZppMacroName /\(\(defineR\=\|undef\|\(el\)\=ifn\=\(def\|eqn\=\|[gl][et]\)\|else\|endif\)\s\+\)\@<=\w\+\>/ contained skipwhite nextgroup=ZppRegex

syn match ZppFix /\(\s\)\@<=[-+]\S*/ contains=ZppFixMark skipwhite nextgroup=ZppFix,ZppLinePreFix,ZppLineSufFix,ZppReSub
syn match ZppLinePreFix /\(\s\)\@<=<\([^<]\|\\<\)*<\(\s\)\@=/ contains=ZppLinePreFixMark skipwhite nextgroup=ZppFix,ZppLineSufFix,ZppReSub
syn match ZppLineSufFix /\(\s\)\@<=>\([^>]\|\\>\)*>\(\s\)\@=/ contains=ZppLineSufFixMark skipwhite nextgroup=ZppFix,ZppLinePreFix,ZppReSub
syn match ZppReSub /\(\s\)\@<=\/\([^/]\|\\\/\)*\/\([^/]\|\\\/\)*\/\(\s\)\@=/ contains=ZppReMark skipwhite nextgroup=ZppFix,ZppLinePreFix,ZppReSub

syn match ZppRegex /\(\s\)\@<=\/\([^/]\|\\\/\)*\/[AILMSUX]*\(\s\)\@=/ contains=ZppReMark
"syn match ZppMacroValue /\w\+\(\s*$\)\@=/
"
syn match ZppFixMark /\(\s\)\@<=[-+]/ contained
syn match ZppLinePreFixMark /\(\\\)\@<!</ contained
syn match ZppLineSufFixMark /\(\\\)\@<!>/ contained
syn match ZppReMark /\(\\\)\@<!\// contained
"syn match ZppAbsMark /\(\s\)\@<=#/ contained

hi PromptMark term=bold cterm=bold
hi PromptMeta term=underline cterm=bold ctermfg=red
hi PromptRole term=italic cterm=italic ctermfg=magenta

hi PromptSegDef term=bold cterm=bold ctermfg=cyan
hi PromptValDef term=bold cterm=bold ctermfg=green
hi PromptSegIns term=bold cterm=bold ctermfg=blue

hi link PromptEscapeLine Normal
hi PromptEscape ctermfg=grey

hi PromptSlotChar term=bold cterm=bold ctermfg=yellow
hi PromptSlot term=underline cterm=bold ctermfg=green
hi PromptImage term=underline cterm=bold ctermfg=blue
hi PromptImagef term=underline cterm=bold ctermfg=blue
hi PromptImageLeading term=italic cterm=italic ctermfg=grey
hi PromptImagefLeading term=italic cterm=italic ctermfg=red
hi PromptImageSize term=italic cterm=italic ctermfg=green

hi link LiteralDollar PromptSlot

hi ZppCommandName term=bold cterm=bold ctermfg=green

hi ZppFix term=italic cterm=italic
hi link ZppLinePreFix ZppFix
hi link ZppLineSufFix ZppFix
hi link ZppReSub ZppFix
hi link ZppRegex ZppFix

hi ZppMacroName term=bold ctermfg=yellow
"hi link ZppMacroValue Normal
"hi link ZppFileName Normal

hi ZppFixMark term=bold cterm=bold ctermfg=cyan
hi link ZppLinePreFixMark ZppFixMark
hi link ZppLineSufFixMark ZppFixMark
hi link ZppReMark ZppFixMark
"hi link ZppAbsMark ZppFixMark

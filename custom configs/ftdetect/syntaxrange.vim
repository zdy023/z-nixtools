autocmd FileType markdown call SyntaxRange#Include('```sh', '```', 'sh', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```c', '```', 'c', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```cpp', '```', 'cpp', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```java', '```', 'java', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```python', '```', 'python', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```haskell', '```', 'haskell', 'NonText')

autocmd FileType markdown,dokuwiki call SyntaxRange#Include('\$\$', '\$\$', 'tex')
"autocmd FileType markdown,dokuwiki call SyntaxRange#IncludeEx('start=/\$/ skip=/\\\$/ end=/\(\\\)\@<!\$/', 'tex')

autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=sh', '\\end{lstlisting}', 'sh', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=c', '\\end{lstlisting}', 'c', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=cpp', '\\end{lstlisting}', 'cpp', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=java', '\\end{lstlisting}', 'java', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=python', '\\end{lstlisting}', 'python', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=haskell', '\\end{lstlisting}', 'haskell', 'NonText')

autocmd FileType dokuwiki call SyntaxRange#Include('<file sh', '</file>', 'sh', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file c', '</file>', 'c', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file cpp', '</file>', 'cpp', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file java', '</file>', 'java', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file python', '</file>', 'python', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file haskell', '</file>', 'haskell', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file php', '</file>', 'php', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file html', '</file>', 'html', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code c', '</code>', 'c', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code cpp', '</code>', 'cpp', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code java', '</code>', 'java', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code python', '</code>', 'python', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code haskell', '</code>', 'haskell', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code php', '</code>', 'php', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code html', '</code>', 'html', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<php>', '</php>', 'php', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<html>', '</html>', 'html', 'NonText')

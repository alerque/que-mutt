set ft=mail

" Autocompplete email addresses for mutt
setlocal omnifunc=mailcomplete#Complete

if !exists("*FirstInPost")
	function FirstInPost (...) range
		call FixHeaders()
		let cur = a:firstline
		while cur <= a:lastline
			let str = getline(cur)
			if str == 'Subject:'
				execute cur
				s/$/ /
				:start!
				break
			endif
			if str == 'To:'
				execute cur
				s/$/ /
				:start!
				break
			endif
			" We have reached the end of the headers.
			if str == ''
				:start
				/\n\n/+
				"if strlen(getlin(line('.'))) > 1
				if line('$') > line('.')
					:put! =\"\n\n\"
				else
					:put! =\"\n\"
					+
				endif
				break
			endif
			let cur = cur + 1
		endwhile
	endfunction
endif

if !exists("*FixFlowed")
	function! FixFlowed()
		" save cursor position
		let pos = getpos(".")
		" add spaces to the end of every line
		silent! %s/\([^]> :]\)\ze\n>[> ]*[^> ]/\1 /g
		" remove extraneous spaces
		silent! %s/ \+\ze\n[> ]*$//
		" make sure there's only ONE space at the end of each line
		silent! %s/ \{2,}$/ /
		" fix the wockas spacing from the text
		silent! %s/^[> ]*>\ze[^> ]/& /
		" compress the wockas
		while search('^>\+ >', 'w') > 0
			s/^>\+\zs >/>/
		endwhile
		" restore the original cursor location
		call setpos('.',pos)
	endfunction
endif

" Manually mangle mutt's edit_headers output so format-flowed 'fixes' don't
if !exists("*FixHeaders")
	function! FixHeaders()
		let pos = getpos('.')
		" remove spaces at end of headers so we don't break wrapping
		silent! 1,/\n\n/s/: $/:/
		call setpos('.',pos)
	endfunction
endif

if !exists("*FixIndented")
	function! FixIndented()
		let pos = getpos('.')
		" remove spaces at end of indented lines
		silent! %s/^\s.*\zs \+$//
		call setpos('.',pos)
	endfunction
endif

augroup mail_filetype
	autocmd!
	autocmd VimEnter * command! Fixq call FixFlowed()
	autocmd BufWritePre * call FixIndented()
	autocmd BufReadPost * call FixFlowed()
augroup END

" Move around by line even in wrapped lines
map j gj
map k gk

" Jump throuph things that get filled in
map <Tab> :Fip<CR>
imap <Tab> <Esc>:Fip<CR>

" Set wrap properties
set wrap
set nosmartindent
set textwidth=72
set linebreak
set formatoptions=2tcqaw
set digraph
set spell!
set display+=lastline

" Less comments
"set comments=n:>,n::,n:#,n:%,n:\|

" Open folds so our field jumper doesn't choke
normal zr

" Move cursor to top reply
com Fip :%call FirstInPost()

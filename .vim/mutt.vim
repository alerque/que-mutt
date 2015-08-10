set ft=mail

" Autocompplete email addresses for mutt
setlocal omnifunc=mailcomplete#Complete

if !exists("*FirstInPost")
	function FirstInPost (...) range
		let cur = a:firstline
		while cur <= a:lastline
			let str = getline(cur)
			if str == 'Subject: '
				execute cur
				:start!
				break
			endif
			if str == 'To: '
				execute cur
				:start!
				break
			endif
			" We have reached the end of the headers.
			if str == ''
				:start
				normal gg/\n\njyypO
				break
			endif
			let cur = cur + 1
		endwhile
	endfunction
endif

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

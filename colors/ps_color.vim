" Vim color file
" Maintainer:	Pan Shizhu <dicpan@hotmail.com>
" Last Change:	14 July 2003
"
" Grey on Black
"	Optimized for GUI interfaces with gentleness color. There're 3
"	parameters to describe a color: Hue, Saturation and Brightness.  In
"	this color scheme, the saturation is low and the brightness are
"	designed to be very close to each other in order not to fatigue your
"	eyes after a whole day's programming work!

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
" PS means nothing, it's just my name!
let g:colors_name = "ps_color"

" Hardcoded Colors Comment: 
" #aabbcc = Red aa, Green bb, Blue cc
" we must use hardcoded colors to get more 'tender' colors 
" 
" Grey Scales :
" #b0b0b0 = Grey 11/16  #d0d0d0 = Grey 13/16    #e0e0e0 = Grey 7/8 (=14/16)
" #404040 = Grey 1/4	#808080 = Gery 1/2	Black	= Grey 0
"
" Red & Magenta Scales:
" #000080 = Blood Red   #e0c060 = Tender Orange	#f08060 = Bright Red
" #f0c0f0 = Tender Pink	#800080 = Purple
"
" Green & Yellow Scales:
" #00f000 = Cursor	#d0d090 = Rice Yellow	#c0e080 = Tree Green
" #60f080 = Bright Green
"
" Blue & Cyan Scales:
" #80c0e0 = Sea Blue	#6080f0 = Gem Blue	#000080 = Indigo Blue	
" #a6caf0 = Sky Cyan	#b0d0f0 = Bright Cyan	#c0d8f8 = Br. Cyan Variant 
"


" GUI:
" Take NT gui for example, If you want to use a console font such as
" Lusida_Console with font size larger than 14, the font looks already thick,
" and the bold font for that will be too thick, you may not want it be bolded,
" in this case this color scheme will suit your taste. I disabled all of the
" bold font for the same reason: continuously switching between bold and plain
" font hurts consistency and will inevitably fatigue your eye!
highlight Normal     	guifg=#d0d0d0	guibg=Black     gui=NONE
highlight Search     	guifg=#e0e0e0	guibg=#800000	gui=NONE
highlight Visual     	guifg=Black	guibg=#a6caf0	gui=NONE	
highlight Cursor     	guifg=Black	guibg=#00f000	gui=NONE
highlight Special    	guifg=#e0c060			gui=NONE
highlight Comment    	guifg=#d0d090			gui=NONE
highlight Constant   	guifg=#80c0e0			gui=NONE
highlight Number     	guifg=#e0c060			gui=NONE
highlight String     	guifg=#80c0e0			gui=NONE
highlight StatusLine 	guifg=Black	guibg=#a6caf0   gui=NONE
highlight LineNr     	guifg=#b0b0b0			gui=NONE
highlight Question   	guifg=Black	guibg=#d0d090   gui=NONE
highlight PreProc    	guifg=#60f080			gui=NONE
" The Statement-group and Type-group are easy to distinguish, different color
" for them are not needed, I use similar color for S-group & T-group in order
" not to make the screen too 'colorful'.
" But if you do want the Statement & Type to be different color, 
" try 'let statement_different_from_type=1' in your .vimrc file.
if exists("statement_different_from_type")
    highlight Statement	guifg=#6080f0			gui=NONE
else
    highlight Statement	guifg=#c0d8f8			gui=NONE
endif
highlight Type       	guifg=#b0d0f0			gui=NONE
highlight Todo       	guifg=#800000	guibg=#d0d090	gui=NONE
highlight Error      	guifg=#f08060	guibg=Black     gui=NONE
highlight Identifier 	guifg=#f0c0f0	guibg=Black     gui=NONE
highlight ModeMsg       				gui=NONE
highlight VisualNOS					gui=NONE
highlight SpecialKey	guifg=#b0d0f0			gui=NONE
highlight NonText       guifg=#6080f0			gui=NONE
highlight Directory     guifg=#b0d0f0			gui=NONE
highlight ErrorMsg      guifg=#d0d090	guibg=#800000	gui=NONE
highlight MoreMsg       guifg=#c0e080			gui=NONE
highlight Title         guifg=#f0c0f0			gui=NONE
highlight WarningMsg    guifg=#f08060			gui=NONE
highlight WildMenu      guifg=Black	guibg=#d0d090	gui=NONE
highlight Folded        guifg=#d0d0d0	guibg=#004000	gui=NONE
highlight FoldColumn    guifg=#e0e0e0	guibg=#008000	gui=NONE
highlight DiffAdd       		guibg=#000080	gui=NONE
highlight DiffChange    		guibg=#800080	gui=NONE
highlight DiffDelete    guifg=#80c0e0	guibg=#404040	gui=NONE
highlight DiffText      guifg=Black	guibg=#c0e080	gui=NONE


" Color Term:
" This scheme is designed for NT Cygwin bash shell console, this console has a
" strange behavier for 16 colors, i.e. there's only 8 color names available,
" the cterm=bold specifies which should be bright color, so totally the 16
" color frontground is available, but color name DarkXXX and LightXXX are the
" same.
"
" Cygwin console is actually a Windows NT Prompt console, In Windows NT Prompt
" console you can change the exact value of each color, so you can have the
" same color with your GUI version of Vim, (isn't that great? someone had
" never been dreamed of that). The pre-configured Cygwin.lnk is available for
" download on my web page for Vim, at the following url:
" http://poet.tomud.com/pub/Cygwin.lnk.gz
" 
"
" If you are using terminals which works very well for 16 color names, or if
" your color terminal does only have 8 colors, you may want to switch to other
" color schemes to gain more readability. Anyway, you can specify in your
" .vimrc to use different color scheme under different consoles and GUI.
"
" It is said that most color xterms only have 8 colors, since I do not have an
" xterm now, no work has been done to give color xterm the same color as GUI
" version.
" 
highlight Normal     ctermfg=LightGrey			cterm=none
highlight Search     ctermfg=White      ctermbg=DarkRed	cterm=bold
highlight Visual     	                                cterm=reverse	
highlight Cursor     ctermfg=Black	ctermbg=Green	cterm=bold
highlight Special    ctermfg=Brown                      cterm=none
highlight Comment    ctermfg=Yellow			cterm=bold
highlight Constant   ctermfg=Blue                  	cterm=bold
highlight Number     ctermfg=Brown                      cterm=none
highlight String     ctermfg=Blue			cterm=bold
highlight StatusLine ctermfg=Blue	ctermbg=White   cterm=none
highlight LineNr     ctermfg=DarkGrey                   cterm=bold
highlight Question   ctermfg=Black      ctermbg=Cyan    cterm=none
highlight PreProc    ctermfg=Green			cterm=bold
highlight Statement  ctermfg=Cyan			cterm=bold
highlight Type       ctermfg=Cyan	        	cterm=bold
highlight Todo       ctermfg=DarkRed    ctermbg=Yellow	cterm=none
highlight Error      ctermfg=Red        ctermbg=Black   cterm=bold
highlight Identifier ctermfg=Magenta    ctermbg=Black   cterm=bold
highlight Folded     ctermfg=White	ctermbg=Green	cterm=none


" Term:
" For console with only 4 colors (term, not cterm), we'll use the default.
" ...
" The default colorscheme is good enough for terms with no more than 4 colors



" Links:
" Character must be different from strings because in many languages 
" (including C) a 'char' variable is actually an 'int', 
" mistaken a 'char' for a 'string' will cause disaster!
hi link		Character	Number
hi link		SpecialChar	LineNr
" Warning is used by DrChip's EngSpChk
hi link		Warning		MoreMsg		

" vim:noet:nosta:ts=8:

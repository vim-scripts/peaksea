" Vim colour file: The colorscheme reloaded.
" Maintainer:	Pan Shizhu <dicpan@hotmail.com>
" Last Change:	16 July 2004
" URL:		http://vim.sourceforge.net/scripts/script.php?script_id=760
" Version:	0.6
"
"	Please prepend [VIM] in the title when writing e-mail to me, or it will
"	be silently discarded.
"
" Description:
"
"	See :h reloaded.txt for details
"
" Release Notes:
"
" v0.6  For default users it may be slow, Added :se lz to disable refresh
" 	Changed some groups of the sample parameter
" 	Use bracketed variable instead of the exe statement
" 	Changed the order of most division calculation to improve accuracy
" v0.5	Initial upload at 15 July 2004.
"


" minimal value of all the given numbers, maximum 20 parameters
fu! s:min(num1,num2,...)
  let l:min = a:num1<a:num2 ? a:num1 : a:num2

  let l:idx = a:0
  wh l:idx > 0
    let l:var = a:{l:idx}
    if l:var < l:min
      let l:min = l:var
    en
    let l:idx = l:idx - 1
  endw
  retu l:min
endf

" same as above for maximal value
fu! s:max(num1,num2,...)
  let l:max = a:num1>a:num2 ? a:num1 : a:num2

  let l:idx = a:0
  wh l:idx > 0
    let l:var = a:{l:idx}
    if l:var > l:max
      let l:max = l:var
    en
    let l:idx = l:idx - 1
  endw
  retu l:max
endf

" guard the var to be in the range between unity and base.
" if base is omitted, treat like degrees.
fu! s:guard(var,unity,...)
  if a:0
    if a:var < a:1
      retu a:1
    elsei a:var > a:unity
      retu a:unity
    en
    retu a:var
  en
  if a:var < 0
    retu a:unity + (a:var % a:unity)
  en
  retu a:var % a:unity
endf

" sub-function
  " 8-bit integer to 2 digit hexadecimal
  fu! s:to_hex(num)
    retu '0123456789abcdef' [a:num/16%16] . '0123456789abcdef' [a:num%16]
  endf

" rgb to rgb color string
fu! s:rgb2colors(red,green,blue)
  retu "#".s:to_hex(a:red+0).s:to_hex(a:green+0).s:to_hex(a:blue+0)
endf

" sub-functions
  fu! s:hue2rgb(v1, v2, hue)
    " trim to the first period
    let l:hue = s:guard(a:hue, 360)

    if l:hue < 60 
      retu a:v1 + l:hue * (a:v2 - a:v1) / 60
    en
    if l:hue < 180 
      retu a:v2
    en
    if l:hue < 240 
      retu a:v1 + (240 - l:hue) * (a:v2 - a:v1) / 60
    en
    retu a:v1
  endf

" hsl to rgb color string
fu! s:hsb2colors(hue,sat,bri)
  " Hue: Any integer degree (modular 360)
  " Saturation: 0 to 1023/1023
  " Luminance: 0 to 1023/1023
  " RGB results = 0 to 255

  if a:sat == 0
    let l:lum = a:bri / 4
    retu s:rgb2colors(l:lum, l:lum, l:lum)
  en

  if a:bri < 512
    let l:v2 = a:bri * ( 1023 + a:sat )
  el           
    let l:v2 = ( a:bri + a:sat ) * 1023 - ( a:sat * a:bri )
  en

  let l:v1 = 2 * 1023 * a:bri - l:v2

  let l:red = s:hue2rgb(l:v1, l:v2, a:hue + 120) / 4092
  let l:green = s:hue2rgb(l:v1, l:v2, a:hue) / 4092
  let l:blue = s:hue2rgb(l:v1, l:v2, a:hue - 120) / 4092

  retu s:rgb2colors(l:red, l:green, l:blue)

endf

" rgb color number to s:rgb
fu! s:color2rgb(color)
  let s:red = a:color / 0x10000
  let s:green = (a:color / 0x100) % 0x100
  let s:blue = a:color % 0x100
endf

" rgb to s:hsl
fu! s:rgb2hsb(red,green,blue)

  let l:red = a:red * 1023 / 255
  let l:green = a:green * 1023 / 255
  let l:blue = a:blue * 1023 / 255

  let l:min = s:min(l:red, l:green, l:blue) 
  let l:max = s:max(l:red, l:green, l:blue) 
  let l:delta = l:max - l:min

  let s:bri = (l:max + l:min) / 2

  if  l:delta == 0 
    let s:hue = 180	" When sat = 0, hue default to 180
    let s:sat = 0
  el 
    if s:bri < 512 
      let s:sat = l:delta * 1023 / (l:max + l:min)
    el           
      let s:sat = l:delta * 1023 / (2*1023 - l:max - l:min)
    en

    let l:del_r = ( (l:max-l:red) + (l:delta*3) ) * 60 / l:delta
    let l:del_g = ( (l:max-l:green) + (l:delta*3) ) * 60 / l:delta
    let l:del_b = ( (l:max-l:blue) + (l:delta*3) ) * 60 / l:delta

    if l:red == l:max 
      let s:hue = l:del_b - l:del_g
    elsei  l:green == l:max  
      let s:hue = 120 + l:del_r - l:del_b
    elsei  l:blue == l:max  
      let s:hue = 240 + l:del_g - l:del_r
    en

    let s:hue = s:guard(s:hue, 360)
  en
endf

" sub-functions
  if !exists("s:loaded") | let s:hue_range = 0 | let s:hue_phase = 0 | en
  fu! s:cast_hue(hue)
    retu a:hue * s:hue_range / 360 - s:hue_range / 2 + s:hue_phase 
  endf

  if !exists("s:loaded") | let s:sat_base = 0 | let s:sat_modify = 0 | en
  fu! s:cast_sat(sat)
    let l:sat = a:sat * (1024 - s:sat_base) / 1024 + s:sat_base
    retu l:sat * s:sat_modify / 100
  endf

  if !exists("s:loaded") | let s:bri_base = 0 | let s:bri_modify = 0 | en
  fu! s:cast_bri(bri)
    let l:bri = a:bri * (1024 - s:bri_base) / 1024 + s:bri_base
    retu l:bri * s:bri_modify / 100
  endf

" input hsl, do modification in HSL color space, output rgb color string
fu! s:make_hsb(hue,sat,bri)

  let l:hue = s:guard(s:cast_hue(a:hue), 360)
  let l:sat = s:guard(s:cast_sat(a:sat), 1023, s:sat_base)
  let l:bri = s:guard(s:cast_bri(a:bri), 1023, s:bri_base)

  if s:verbose | ec "\"\tH=".l:hue."\tS=".l:sat."\tL=".l:bri | en
  retu s:hsb2colors(l:hue, l:sat, l:bri)

endf

" input rgb color number, transfer to HSL, then do <sid>make_hsb
fu! s:make_color(color)
  cal s:color2rgb(a:color)
  cal s:rgb2hsb(s:red, s:green, s:blue)
  retu s:make_hsb(s:hue, s:sat, s:bri)
endf

" input color string, transfer in HSL, output rgb color string
fu! s:parse_color(p)
  if a:p[6] == "#"
    let l:p = '0x'.strpart(a:p, 7, 6) + 0
    retu strpart(a:p, 0, 6).s:make_color(l:p)
  elsei a:p[6] == "@"
    let l:hue = s:guard(strpart(a:p, 7, 3) + 0, 360)
    let l:sat = s:guard(strpart(a:p, 10, 4) + 0, 1023, 0)
    let l:bri = s:guard(strpart(a:p, 14, 4) + 0, 1023, 0)
    retu strpart(a:p, 0, 6).s:make_hsb(l:hue, l:sat, l:bri)
  el
    retu a:p
  en
endf

if !exists("s:loaded") | let s:verbose = 0 | en
fu! s:psc_hi(group, p1, p2, ...)
  if a:0 == 0
    let l:p3 = "gui=NONE"
  el
    let l:p3 = a:1
  en
  let l:p1 = s:parse_color(a:p1)
  let l:p2 = s:parse_color(a:p2)
  if s:verbose | ec "hi ".a:group." ".l:p1." ".l:p2." ".l:p3 | en
  exe "hi ".a:group." ".l:p1." ".l:p2." ".l:p3
endf

fu! s:multi_hi(setting, ...)
  let l:idx = a:0
  wh l:idx > 0
    let l:hlgroup = a:{l:idx}
    if s:verbose | ec "hi ".l:hlgroup." ".a:setting | en
    exe "hi ".l:hlgroup." ".a:setting
    let l:idx = l:idx - 1
  endw
endf

" Transfer global variable into script variable
fu! s:init_option(var, value)
  if !exists("g:psc_".a:var)
    exe "let s:".a:var." = ".a:value
  el
    let s:{a:var} = g:psc_{a:var}
  en
endf

if !exists("loaded") | let s:file = expand("<sfile>") | en

cal s:init_option("reload_prefix", "'".fnamemodify(s:file,":p:h")."/'")

fu! s:psc_reload(...)

  " Only do color for GUI
  if !has("gui_running") | retu | en

  if a:0 > 10
    echoe "Too many parameters, ".'a:0 == '.a:0
    retu
  en

  com! -nargs=+ InitOpt cal s:init_option(<f-args>)

  if a:0 >= 6
    " Hue = phase +- (range/2)
    " Sat = sat * modify% then promoted from base to 1024
    " Bri = bri * modify% then promoted from base to 1024

    let s:hue_range = a:1
    let s:sat_modify = a:2
    let s:bri_modify = a:3

    let s:hue_phase = a:4
    let s:sat_base = a:5
    let s:bri_base = a:6
  el
    InitOpt hue_range 360
    InitOpt sat_modify 100
    InitOpt bri_modify 100

    InitOpt hue_phase 180
    InitOpt sat_base 0
    InitOpt bri_base 0
  en

  if a:0 >= 7
    let s:lightbg = a:7
  el
    InitOpt style 'cool'
    if s:style == 'warm'
      InitOpt lightbg 1
    el
      InitOpt lightbg 0
    en
  en

  if a:0 >= 8 
    let s:plainfont = a:8
  el
    InitOpt fontface 'mixed'
    if s:fontface == 'mixed'
      InitOpt plainfont 0
    el
      InitOpt plainfont 1
    en
  en

  if a:0 >= 9
    let s:verbose = a:9
  el
    InitOpt verbose 0
  en

  if a:0 == 10
    let s:reload_filename = a:10
  el
    InitOpt reload_filename 'ps_color.vim'
  en

  delc InitOpt

  let s:reload_filename = s:reload_prefix.s:reload_filename

  if !filereadable(s:reload_filename)
    echoe "Color data file ".s:reload_filename." not found."
    retu
  en

  se lz

  if !s:lightbg | se bg=dark | el | se bg=light | en

  hi clear

  if exists("syntax_on") | sy reset | en

  " This is mandatory, personally I think it is a bug rather than a feature.
  let g:colors_name = expand("<sfile>:t:r")


  " GUI:
  "
  " Matrix Reloaded style for gui
  "
  let s:tempfile = '__Temp_Colors__'

  exe "sil! 1new ".s:tempfile
  sil! %d
  exe "sil! 0r ".s:reload_filename
  if s:verbose 
    ec '" Reloaded color scheme from '.s:reload_filename 
    ec '" with param ' s:hue_range s:sat_modify s:bri_modify 
          \s:hue_phase s:sat_base s:bri_base s:lightbg s:plainfont 
    ec '" '
  en

  if !s:lightbg
    sil! 1,/^\s*" DARK COLOR DEFINE START$/d
    sil! /^\s*" DARK COLOR DEFINE END$/,$d
  el
    sil! 1,/^\s*" LIGHT COLOR DEFINE START$/d
    sil! /^\s*" LIGHT COLOR DEFINE END$/,$d
  en

  sil! 0
  let s:nnb = 1
  com! -nargs=+ PscHi cal s:psc_hi(<f-args>)
  wh 1
    let s:nnb = nextnonblank(s:nnb)
    if !s:nnb | brea | en

    let s:line = getline(s:nnb)

    let s:nnb = s:nnb + 1

    " Skip invalid lines 
    if s:line !~ '^\s*hi\%[ghlight]\s*.*' | con | en

    exe substitute(s:line, '\<hi\%[ghlight]\>', 'PscHi', '')
  endw
  sil! q!
  delc PscHi

  " Enable the bold style
  com! -nargs=+ MultiHi cal s:multi_hi(<f-args>)
  if !s:plainfont
    MultiHi gui=bold Question StatusLine DiffText Statement Type MoreMsg ModeMsg NonText Title VisualNOS DiffDelete
  endif
  delc MultiHi

  " Color Term:
  " Are you crazy?


  " Term:
  " Don't be silly...


  " Links:
  " Something sensible

  exe "sil! 1new ".s:tempfile
  sil! %d
  exe "sil! 0r ".s:reload_filename

  sil! 1,/^\s*" COLOR LINKS DEFINE START$/d
  sil! /^\s*" COLOR LINKS DEFINE END$/,$d

  sil! 0
  let s:nnb = 1
  wh 1
    let s:nnb = nextnonblank(s:nnb)
    if !s:nnb
      brea
    en
    let s:line = getline(s:nnb)

    let s:nnb = s:nnb + 1
    " Skip invalid lines 
    if s:line !~ '^\s*hi\%[ghlight]\s*.*' | con | en

    if s:verbose | ec s:line | en

    sil! exe s:line
  endw
  sil! q!

endf

" To flag the script variables are initialized
let s:loaded = 1

com! -nargs=* Reload cal <SID>psc_reload(<f-args>)

" vim:et:nosta:sw=2:ts=8:
" HelpExtractor:
" The document {{{2
fu! s:extract_help()
  se lz
  let docdir = substitute(s:file, '\<colors[/\\].*$', 'doc', '')
  if !isdirectory(docdir)
    if has("win32")
      echoe 'Please make '.docdir.' directory first'
      unl docdir
      return
    elsei !has("mac")
      exe "!mkdir ".docdir
    en
  en

  let curfile = fnamemodify(s:file, ":t:r")
  let docfile = substitute(fnamemodify(s:file, ":r").".txt",
	\'\<colors\>', 'doc', '')
  exe "silent! 1new ".docfile
  sil! %d
  exe "silent! 0r ".fnamemodify(s:file, ":p")
  sil! 1,/^" HelpExtractorDoc:$/d
  norm! GVkkd
  cal append(line('$'), '')
  cal append(line('$'), 'v' . 'im:tw=78:ts=8:noet:ft=help:fo+=t:norl:noet:')
  sil! wq!
  exe "helptags ".substitute(docfile,'^\(.*doc.\).*$','\1','e')

  exe "silent! 1new ".fnamemodify(s:file, ":p")
  1
  sil! /^" HelpExtractor:$/,$g/.*/d
  sil! wq!

  noh
endf

cal s:extract_help()
fini

" ---------------------------------------------------------------------
" Put the help after the HelpExtractorDoc label...
" HelpExtractorDoc:
*reloaded.txt*  Color Tuner and Reloader           Last change:  16 July 2004


PERSONAL COLOUR TUNER AND RELOADER                               *psc_reload*


Author:  Pan, Shizhu.  <dicpan> at <hotmail o com> >
	(prepend '[VIM]' in the title or your mail may be silently removed.)
<
==============================================================================
CONTENTS                                                 *pcr* *pcr-contents*

	1. Contents.....................|pcr-contents|
	2. PCR Overview.................|pcr-overview|
	3. PCR Usage....................|pcr-usage|
	4. PCR Options..................|pcr-options|
	5. PCR FAQ .....................|pcr-faq|
	6. PCR Todo List................|pcr-todo|

For release notes, please see the header of reloaded.vim

==============================================================================
PCR FEATURES OVERVIEW                           *pcr-features* *pcr-overview*

	Features ~

	. PCR is a color scheme tuner and reloader.
	. PCR is an optional utility for ps_color as well as other schemes
	. It tunes the whole color scheme in HSL color space.
	. Thousands of color styles can be achieved by HSL tuning.
	. Tuned output can be saved to create new color schemes.
	. Can be configured to tune your own color scheme.
	. Works under GUI only, do not affect console version.

	Design Concern ~

	When I'm designing the color scheme |ps_color|, I realized it is
	extremely difficult to fine-tune the color, the whole step is not at
	all straight forward.  What is more, RGB is not quite comprehensive
	for most average people.  It would be much better if it is possible to
	tune the color scheme in HSL color space.  Many color schemes in vim
	are actually similar, just some tune in the HSL color space.

	It is very easy to understand HSL color space even if one has NO
	previous knowledge.  This may be another reason to use HSL color
	space.

	Portability ~

	Before playing the game of colors, you are strongly recommended to
	adjust your monitor to 6500k color temperature and proper gamma curve.
	This has been described in the |ps_color.txt| at the same
	"Portability" section.  If you don't know how, just skip it.

	The only portability issue, for the obvious reason, this is GUI only.
	;-)

==============================================================================
PSC USAGE                                                         *pcr-usage*

	For the impatient ~

	Make sure both ps_color.vim and reloaded.vim are in your
	[runtimepath]/colors and type in the following command >

		:colo reloaded
<
        in your Vim or append to your |.vimrc|.  The [runtimepath] can be any
        'writable' directory listed in |vimfiles|, normally your $HOME/.vim in
        Unix or $HOME/vimfiles in Windows.
	
	Note that you don't need to remove your current :colo lines in .vimrc,
        since the :colo reloaded does nothing on color scheme, the
        reloaded.vim has to be a color scheme for some bizarre reason.  

	Note if you do not want to have ps_color.vim, go to FAQ section to see
	how to create your own.

	Experiencing ~
        
	Normally, nothing will happen when you sourced the colorscheme
	reloaded, this only enables the command :Reload.

	The :Reload command will be available after you sourced the
	colorscheme reloaded.  If not, type :colo reloaded now. 
	
	Now try the following:
>
		:Reload 60 100 100 120 341 0 0 0 0
<
	If you do as above, you will get a greenish feeling like "Matrix
	reloaded".  You can run the Reload command in vim command line as well
	as in .vimrc. To see what the :Reload is capable of, try the
	following, one by one:
>
		:Reload 120 100 100 60 341 128
		:Reload 120 100 100 60 341 0 1
		:Reload 480 84 84 195 256 96 0
		:Reload 720 71 100 360 0 0 0
		:Reload 60 100 100 150 341 0 0
		:Reload 240 120 100 330 341 0 1
		:Reload 360 100 100 180 0 0 0 1
		:Reload 360 100 100 180 0 0 1 0
<
	(Hint: choose a document which has as much highlight as possible to
	see what the come scheme looks like. Vim scripts or Vim help documents
	may be good samples.)

	. The first line will give you a golden feeling, followed by
	  a reversed version. 
	. Next comes a low contrast dark-cyan-background scheme.
	. Next comes a black background with decreased saturation.
	. The Hue can be changed anyway. This is a cyan-green style, call it
	  "Matrix revolution"?
	. Be hot, lets try a reddish style.
	. The last two lines will give you the same as ps_color 'cool' and
	  'warm' style.

	Are you amazed? I guess so.  And, of course all the above can be
	further fine-tuned.

	If you want to explore the mysteries inside this, see the next
	section.

==============================================================================
PCR OPTIONS                                                     *pcr-options*

	Since it is much easier and straight forward to specify command line
	arguments, there are no need to create individual options. Here we
	describe the 10 parameters.

	Synopsis ~

	:Reload h_r s_m l_m h_p s_b l_b [ lbg [ pf [ vb [ cdf ] ] ] ]

	Scope ~

	Hue is the dominant parameter to a color, because the human eye is
	very sensitive to the changing of hue.  Generally, the hue is
	expressed by angle, can be 0 to 360 degrees, where 359 degree is equal
	to -1 degree, 360 degree is equal to 0 degree, 361 degree is equal to
	1 degree, etc.

	The human eye is less sensitive to Saturation, the Black, Grey, and
	White has saturation=0, The pure Red, Green, and Blue has
	saturation=max, usually, saturation is defined to be between 0 and 1.
	But Vim is not capable of handling floating points, so I defined the
	saturation to be between 0 and 1023. 

	The saturation is the amount the different color elements differs, if
	the red, green, blue are similar, the saturation is low.

	The human eye is least sensitive to Luminance, since the dynamic range
	of human eye can be changed on the fly.  The luminance, or to say
	brightness, needs no explanation, since the meaning is quite obvious.

	The Luminance is also defined to be 0 to 1023, for the same reason.

	Parameter h_r and h_p ~

	This refers to hue range and hue phase.
	
	set the hue range to any positive value, the hue will be in the range
	of hue_phase-(hue_range/2) to hue_phase-(hue_range/2)

	The normal hue is from 0 to 360, let hue_range=360 and hue_phase=180
	will have the range 0 to 360, hence the hue of original color scheme
	will be retained. 

	Set the hue range to between 0 and 360 will have the hue range
	compressed, or to say a color-filtered look.  Set the hue range to
	0 will force all colors in the color scheme to have the same hue value
	as hue_phase.  You may not want it to be that low, since the
	hue_range=60 will in most cases enough to give the whole color scheme
	a color-filtered look.
	
	Set the hue range to >360 will have the color changed without compress
	the hue range, the behavior is not easy to describe, you need to do
	more experiments to understand what it does.

	Set the hue range to <0 is illegal.

	The hue_phase is the base value the whole color scheme designed
	around.  Usually, the Hue=0 is Red, Hue=60 is Yellow, Hue=120 is
	Green, Hue=180 is Cyan, Hue=240 is Blue, Hue=300 is Magenta, any other
	value is between two color, for example, Hue=30 is Orange color.

	It would be very interesting to see how a color scheme changes when
	change the hue_phase.

	Parameter s_m and s_b ~

	This refers to saturation modify and saturation base

	The saturation modify is a percent value, 100 means no modify. 
	If set to 50, all saturation will be decreased to 50%, 
	If set to 0, the screen will be black and white (greyscale), 
	If set to 200, all saturation will be increased to 200% times the
	original value.

	The saturation base is a linear value, it defines the minimum
	saturation.
	If set to 0, the saturation will not be modified.
	If set to 256, the minimum saturation will be 1/4.
	If set to 341, the minimum saturation will be 1/3.
	If set to 512, the minimum saturation will be 1/2.

	Oops, please _note_ that a too high value of saturation is not quite
	comfortable for most people.

	Parameter l_m and l_b ~

	This refers to luminance modify and luminance base

	The luminance modify is a percent value, 100 means no modify. 
	If set to 50, all luminance will be decreased to 50%, 
	If set to 0, the screen will be completely dark (can be possibly used
	for boss key?)
	If set to 200, all luminance will be increased to 200% times the
	original value.

	The luminance base is a linear value, it defines the minimum
	luminance. 
	
	Main use of this is to tune the background for a dark background
	colorscheme.
	If set to 0, the background will be black.
	If set to 128, the background will be a 1/8 dark one, the color of
	background can be tuned by saturation_base and hue_phase.
	If set to 1023, the screen will be completely white.

	For light background, it is recommended to set luminance base to 0.


	Parameter lbg ~

	This refers to light background

	when set to 1, the reloader choose a light background scheme and set
	bg to light, otherwise, it is set to 0.

	This options is optional, if omitted, it checks the value of
	g:psc_style, if the style is 'warm', the light background is set to 1.

	Parameter pf ~

	This refers to plain font

	Optional, set to 1 will turn all bolded font to plain font.
	When not set, will check for g:psc_fontface, if non-exists,
	default to 0.

	Parameter vb ~

	This refers to 'verbose'

	When set to 1, some debug messages will be echoed when running the
	command.
	
	Parameter cdf ~

	This refers to custom data file

	The default data file is the ps_color.vim placed at the same directory
	as reloaded.vim.  You can set it to any file you want.

	When present, it should be the file name of your data file.
	For example, if your data file is ~/.vim/colors/template.vim:
>
	:Reload 360 100 100 180 0 0 1 0 0 template.vim
<
	will reload the light color scheme in template.vim
							    *pcr-custom-data*
	Designing a data file ~

	The data file can be a normal color scheme script, such as
	ps_color.vim, You may need to know more if you want to do
	modifications.

	The ps_color.vim is fairly complicated, but only part of the file are
	imported as data.  Mainly, you only need to see how it organizes
	statements in between "DEFINE START" and "DEFINE END" blocks.

	The data file should conform to some restrictions:

	. Must be in the same directory as reloaded.vim

	. ALL highlight group must be defined, do not accept any default
          value, this include the Underline and Ignore groups, this also hints
          that both foreground and background must be defined.  Use :ru
          syntax/hitest.vim to check if all highlight groups are defined.

	. Color names like "SlateBlue" should not be used, only hardcoded color
	  like #rrggbb is acceptable, the fg and bg can be used though, Since
	  fg and bg comes from the group Normal, and Normal group must be
	  defined with #rrggbb form of foreground and background.

	. The following should exist in the file
>
		" DARK COLOR DEFINE START
		" DARK COLOR DEFINE END
		" LIGHT COLOR DEFINE START
		" LIGHT COLOR DEFINE END
		" COLOR LINKS DEFINE START
		" COLOR LINKS DEFINE END
<
	  the highlight statement should be placed in between START and END.  
	  All statement other than the 'highlight' will be silently discarded.

	  You can put dark color scheme defines in dark color define section,
	  or light color scheme in light color section.  It doesn't matter if
	  you have nothing in the section, since the defaults are used.
	  However, the defaults will not be tuned in the HSL color space,
	  which may be you want, and may not! 
	  
	  Further statements can be put in color links define section, you can
	  put any 'highlight' statements in this section since the statements
	  in this section will be execute unparsed, if you want to manually
	  change some groups in a reloaded scheme, put something there.


==============================================================================
PCR FAQ AND TIPS                                                    *pcr-faq*
>
	Q: How to make my own color to be tunable?
<
	A: Your own color scheme must conform to some restrictions, 
	   see |pcr-custom-data| for details.
>
	Q: How to run reloaded.vim without having ps_color.vim?
<
	A: reloaded.vim is just a utility to reload colorscheme, it does not
	   contain any colors. You must have a data file, or to say
	   colorscheme, contains the 'highlight' statements like those in
	   ps_color.vim, and tell the reloaded.vim to use that file.
	   Instructions on creating custom data file is described in
	   |pcr-custom-data|.
>
	Q: How to export the tuned output to create new color scheme?
<
	A: This is still under construction, currently you can set verbose in
	   the command line parameter and capture the output, but it is not
	   working very well.
>
	Q: Why this should be a colorschme instead of a plugin utility?
<
	A: This seems to be a Vim bug (or to say 'feature' if you prefer), the
	   main function will hang up if run as a plugin and you will not be
	   able to source the colorscheme in the current Vim session, so,
	   please put reloaded.vim in ~/.vim/colors, do NOT put it in
	   ~/.vim/plugin !
>
        Q: Why it is impossible to browse functions in reloaded.vim with
	   taglist plugin?
<
	A: The old versions of exuberant ctags utility do not cope with <sid>
	   functions very well, please download and recompile the newest
	   version of exuberant ctags utility.


==============================================================================
PCR TODO LIST                                                      *pcr-todo*

	o Fix the remaining bugs.
	o Try to be able to parse color names
	o Improve the output feature

==============================================================================
vim:et:nosta:sw=2:ts=8:
}}}2 vim600:fdm=marker:fdl=1:

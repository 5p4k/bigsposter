%% bigsposter.cls
%% Copyright 2017 Pietro Saccardi (saccardi at or.uni-bonn.de)
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
% The Current Maintainer of this work is Pietro Saccardi.
%
% This work consists of the files bigsposter.cls, demo.tex, bigsposter.tex.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bigsposter}[2017/06/20]

\makeatletter

% Used only for debugging purposes
% \def\convertto#1#2{\strip@pt\dimexpr #2*65536/\number\dimexpr 1#1}

% Use article 12pt as base
\LoadClass[12pt]{article}

% Remove all header and footer
\pagestyle{empty}

% For logos
\RequirePackage{tikz}

% Original top margin was 0.5in, but I can't see imperial system, and bottom margin undefined
\RequirePackage[margin=5mm, ignoreall=true]{geometry}

% Skip instead of indenting
\RequirePackage[parfill]{parskip}

% Colors
\RequirePackage{xcolor}

% Silent warnings for custom fonts
\RequirePackage{lmodern}

% Framed environments
\RequirePackage{framed}

% Hyperlink for email
\RequirePackage{hyperref}

% Clearly used for multiple columns
\RequirePackage{multicol}

% MUST disable singlelinecheck or stuff inside the blockcaption will be evaluated twice
\RequirePackage[hypcap=false, singlelinecheck=false]{caption}


% ALL PARMS --------------------------------------------

% Thickness of the frame border for each blockrow
\def\@blockborderthickness{3pt}
% Background color of the blocktitle
\def\@bigsyellow{0.97, 0.92, 0.7}
% Margins around the title
\def\@titlelmargin{1em}
\def\@titlermargin{1em}
\def\@titletmargin{0em}
\def\@titlebmargin{4.5em}
% Margin between the bigs logo and the text
\def\@bigslogomargin{5em}
% Margin between the text and the uni logo
\def\@unilogomargin{1em}
% Sizes of the logos
\def\@bigslogowidth{0.2\textwidth}
\def\@unilogowidth{0.2\textwidth}
% Space between the work title and the autor
\def\@titletoauthorskip{3em}
% Space between the author and the advisor
\def\@authortoadvisorskip{1em}
% Padding space for each column
\def\@columnsepwidth{2em}
% Command that defines the title font size. MUST INCLUDE \selectfont because
% we change also font and variants before calling this
\def\@titlefontsize{\fontsize{0.03\textwidth}{0.032\textwidth}\selectfont}
% Command that defines the author and advisor font size. Does not have to include \selectfont
\def\@authoradvisorfontsize{\fontsize{0.021\textwidth}{0.024\textwidth}\selectfont}

\DeclareOption{fixed}{
  % Redefine as fixed. This comes from the old template and is kept for retro compatibility
  \def\@titlelmargin{10mm}
  \def\@titlermargin{6.5mm}
  \def\@titletmargin{0mm}
  \def\@titlebmargin{22mm}
  \def\@bigslogomargin{19mm}
  \def\@bigslogowidth{73mm}
  \def\@unilogomargin{5mm}
  \def\@unilogowidth{80mm}
  \def\@titletoauthorskip{10mm}
  \def\@authortoadvisorskip{7mm}
  \def\@columnsepwidth{1cm}
  \def\@titlefontsize{\fontsize{1cm}{1.32cm}\selectfont\vspace{.5em}}
  \def\@authoradvisorfontsize{\Huge}
}

% ------------------------------------------------------

% Process the options here
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{geometry}}

\ProcessOptions

% Lengths and counters and colors

\setlength{\columnsep}{\@columnsepwidth}

\newlength{\@oldFrameSep}
\newlength{\@oldFrameRule}

\newcounter{block}
\newcounter{blockrow}
\newcounter{blockfootnote}
\newcounter{blockfootnotetext}

\setcounter{blockrow}{0}
\setcounter{blockfootnote}{0}
\setcounter{blockfootnotetext}{0}

\definecolor{BigsYellow}{rgb}{\@bigsyellow}

% These colors are used in the logos
\definecolor{c1f55ad}{RGB}{31,85,173}
\definecolor{cf9b10a}{RGB}{249,177,10}
\definecolor{c848270}{RGB}{132,130,112}
\definecolor{cffffff}{RGB}{255,255,255}
\definecolor{c004e9e}{RGB}{0,78,158}
\definecolor{c9daad7}{RGB}{157,170,215}

% TITLE ------------------------------------------------

% Undefined macros we are not using
\let\date\undefined
\let\and\undefined
\let\thanks\undefined
\let\@date\undefined
\let\@thanks\undefined

% Define extra macros that we accept as input for the title.
% Copied from article.cls
\def\@advisor{\ClassWarning{bigsposter}{No \noexpand\advisor given}}
\def\advisor#1{\gdef\@advisor{#1}}
\def\@institute{\ClassWarning{bigsposter}{No \noexpand\institute given}}
\def\institute#1{\gdef\@institute{#1}}
\def\@posteryear{\ClassWarning{bigsposter}{No \noexpand\posteryear given}}
\def\posteryear#1{\gdef\@posteryear{#1}}
\def\@email{\ClassWarning{bigsposter}{No \noexpand\email given}}
\def\email#1{\gdef\@email{#1}}

% Copied from article.cls and adapted. Removed part relative to footnotes.
\renewcommand{\maketitle}{\par
  \begingroup
    \global\@topnum\z@   % Prevents figures from going at top of page.
    \@maketitle
  \endgroup
  \global\let\@maketitle\relax
  \global\let\@author\@empty
  \global\let\@title\@empty
  \global\let\@advisor\@empty
  \global\let\maketitle\relax
  \global\let\author\relax
  \global\let\title\relax
  \global\let\advisor\relax
}

% Real title command. Copied from article.cls and adapted.
\def\@maketitle{%
  \null\vspace{\@titletmargin}\hspace{\@titlelmargin}%
  % Use raisebox to anchor logo + title to the top
  \raisebox{-\height}{% Group logo and title to vertically center them
    \makebox{% Center vertically by raising of half height
      \raisebox{-0.5\height}{\@bigslogo{\@bigslogowidth}}%
      \hspace{\@bigslogomargin}%
      \raisebox{-0.5\height}{%
        % Title may have several lines, let's use a bottom-aligned parbox.
        % Needs to be bottom aligned so that we do not have half line vertical offset
        \parbox[b]{\dimexpr
          % Compute the parbox width by subtracting all the known quantities
          \textwidth-\@titlelmargin-\@titlermargin
          -\@bigslogowidth-\@unilogowidth
          -\@bigslogomargin-\@unilogomargin
          \relax
        }{%
          {\fontencoding{T1}\fontfamily{pag}\fontseries{b}\fontshape{n}%
            \@titlefontsize%
            \@title\par%
          }%
          \vspace{\@titletoauthorskip}%
          {\@authoradvisorfontsize\bfseries\@author\par}\vspace{\@authortoadvisorskip}%
          {\@authoradvisorfontsize\bfseries Advisor: \@advisor\par}%
        }%
      }%
    }%
  }%
  \hspace{\@unilogomargin}%
  % Top aligned logo, top aligns with the top of the previous box, including both
  % bigs logo and title
  \raisebox{-\height}{\@unilogo{\@unilogowidth}}%
  \par\vspace{\@titlebmargin}%
}

% BLOCKS -----------------------------------------------

% Blockrow environment. Basically a framed multicolumn with some measurements and lenghts
\newenvironment{blockrow}[1][2]{%
  \stepcounter{blockrow}\setcounter{block}{1}%
  \setlength\@oldFrameSep{\FrameSep}%
  \setlength\@oldFrameRule{\FrameRule}%
  \setlength{\FrameSep}{\dimexpr 0.5\@columnsepwidth + \@blockborderthickness \relax}%
  \setlength{\FrameRule}{\@blockborderthickness}%
  \begin{framed}%
  \vspace{\dimexpr-0.5\@columnsepwidth-\@blockborderthickness\relax}%
  \setlength{\FrameSep}{\@oldFrameSep}%
  \setlength{\FrameRule}{\@oldFrameRule}%
  \setlength{\columnseprule}{1pt}%
  \raggedcolumns%
  \begin{multicols}{#1}%
  \def\@nblocks{#1}%
  \def\blockwidth{\dimexpr
    (\textwidth - \@columnsepwidth * (\@nblocks - 1)) / \@nblocks
  \relax}%
\ignorespaces}{
  \end{multicols}%
  \vspace{\dimexpr-0.5\@columnsepwidth-\@blockborderthickness\relax}%
  \end{framed}\ignorespaces}


% Blockbreak command. Just a glorified columnbreak with some void elements to
% make it work also if there is no input on one side
\newcommand{\blockbreak}{\par\stepcounter{block}\columnbreak\mbox{}}

% Blockfoot command. Space, ruler a description.
\newcommand{\blockfoot}{
  \vfill\bigskip%
  \hrule%
  \medskip
  \@posteryear~\@institute\\
  \href{mailto:\@email}{\texttt{\@email}}%
  \global\let\@institute\@empty%
  \global\let\@posteryear\@empty%
  \global\let\@email\@empty%
  \global\let\institute\relax%
  \global\let\posteryear\relax%
  \global\let\email\relax%
}

% Blocktitle command. Spacing, coloredbox and a fixed size parbox with the title.
\newcommand{\blocktitle}[1]{\unskip%
  \medskip%
  \setlength{\@oldFrameSep}{\fboxsep}%
  \setlength{\fboxsep}{0pt}%
  \colorbox{BigsYellow}{%
    \parbox[b][6ex][c]{\dimexpr\blockwidth - \fboxsep * 2\relax}{%
      \centering\Large\textsf{\textbf{#1}}%
    }%
  }%
  \setlength{\fboxsep}{\@oldFrameSep}%
  \medskip%
}

% Blockfigure environment. Just a center environment with a bit less spacing.
\newenvironment{blockfigure}{\vspace{-0.5\baselineskip}\begin{center}}{\end{center}\vspace{-0.5\baselineskip}}

% Blockcaption command. A centered parbox which calls \captionof{figure}{...}
\newcommand{\blockcaption}[2][0.8\blockwidth]{\par\centering{\parbox{#1}{\captionof{figure}{#2}}}}


% BUGFIXES FOR EXISTING PKGS ---------------------------

% Bugfixes space before theorems and definition with parskip
% http://tex.stackexchange.com/a/26350/26355
\newcommand{\patchthmspacing}[1]{%
   \@for\theoremstyle:=#1\do{%
     \expandafter\g@addto@macro\csname th@\theoremstyle\endcsname{%
       \addtolength\thm@preskip\parskip%
     }%
   }%
}

% FOOTNOTES ENABLING SECTION ---------------------------

% This is a bit trickier. Essentially we use the standard footnotes, but we
%  1. Protect the command for usage within captions, framed, multicols
%  2. Override manually the counter with ours
%  3. Issue only the footnotemark command, and postpone the footnotetext
%     at the end of the document


% This collects the footnotetext commands
\newcommand*\@pushedfootnotes{\relax}

% Blockfootnotetext command. Alias to footnotetext, plus counter step, but the actual cmd
% is appended to \@pushedfootnotes, which is going to be executed at the end, thanks to
% \g@addto@macro.
\newcommand*{\blockfootnotetext}[1]{\g@addto@macro\@pushedfootnotes{\stepcounter{blockfootnotetext}\footnotetext[\value{blockfootnotetext}]{#1}}}

% Blockfootnotemark command. Alias counter step and protected footnotemark.
\newcommand*{\blockfootnotemark}{\protect\stepcounter{blockfootnote}\protect\footnotemark[\value{blockfootnote}]}

% Blockfootnote. Combination of footnotetext and footnotemark.
\newcommand*{\blockfootnote}[1]{\blockfootnotemark\blockfootnotetext{#1}}

% Push command at the end
\AtEndDocument{\@pushedfootnotes}

% LOGOS ------------------------------------------------
% Converted using svg2tikz, https://github.com/kjellmf/svg2tikz

\newcommand{\@bigslogo}[1]{%
  \resizebox{#1}{!}{%
    \begin{tikzpicture}[y=0.80pt, x=0.80pt, yscale=-1.000000, xscale=1.000000, inner sep=0pt, outer sep=0pt]
      \path[fill=black,nonzero rule] (77.8320,56.5820) .. controls (77.7227,56.3945)
        and (77.6211,56.2148) .. (77.3828,56.0078) .. controls (76.9922,55.6680) and
        (76.4688,55.4688) .. (75.8594,55.4688) .. controls (74.8398,55.4688) and
        (73.9023,56.0273) .. (73.9023,57.1680) .. controls (73.9023,58.4062) and
        (75.1523,58.7656) .. (75.8125,58.9453) .. controls (76.4219,59.1016) and
        (76.9375,59.2891) .. (76.9375,59.8125) .. controls (76.9375,60.1875) and
        (76.6250,60.5781) .. (75.9688,60.5781) .. controls (75.2578,60.5781) and
        (74.9570,60.1094) .. (74.7383,59.7812) -- (73.7148,60.1797) .. controls
        (73.9023,60.5430) and (74.4023,61.5195) .. (75.8984,61.5195) .. controls
        (77.4336,61.5195) and (77.9961,60.4688) .. (77.9961,59.7109) .. controls
        (77.9961,59.3281) and (77.8477,58.8203) .. (77.5195,58.4844) .. controls
        (77.2305,58.1992) and (76.7969,57.9961) .. (76.0391,57.8086) .. controls
        (75.2383,57.6133) and (74.9648,57.4336) .. (74.9648,57.0352) .. controls
        (74.9648,56.6680) and (75.2500,56.3008) .. (75.8047,56.3008) .. controls
        (76.4062,56.3008) and (76.7266,56.7539) .. (76.8750,56.9727) --
        cycle(72.9648,57.0664) .. controls (72.8945,56.7930) and (72.4297,55.4531) ..
        (70.8516,55.4688) .. controls (69.4648,55.4688) and (68.3008,56.5273) ..
        (68.3008,58.5938) .. controls (68.3008,60.8516) and (69.7383,61.5195) ..
        (70.8281,61.5195) .. controls (71.7031,61.5195) and (72.2578,61.1055) ..
        (72.5898,60.6875) .. controls (72.8711,60.3359) and (72.9414,60.0391) ..
        (73.0195,59.7422) -- (71.9609,59.4453) .. controls (71.6094,60.4844) and
        (70.8047,60.4844) .. (70.6875,60.4844) .. controls (69.8633,60.4844) and
        (69.5039,59.5391) .. (69.5039,58.5508) .. controls (69.5039,57.9023) and
        (69.6758,56.4102) .. (70.7969,56.4102) .. controls (71.1406,56.4102) and
        (71.7031,56.5508) .. (71.8984,57.3711) -- cycle(66.0234,61.4102) --
        (67.1641,61.4102) -- (67.1641,55.5820) -- (66.0234,55.5820) --
        cycle(60.5625,55.5859) -- (60.5625,56.5977) -- (62.2031,56.5977) --
        (62.2031,61.4102) -- (63.3398,61.4102) -- (63.3398,56.5977) --
        (64.9883,56.5977) -- (64.9883,55.5859) -- cycle(58.9883,59.1953) --
        (57.6641,59.1953) -- (58.3164,57.1602) -- (58.3320,57.1602) --
        cycle(57.7148,55.5859) -- (55.8281,61.4102) -- (56.9531,61.4102) --
        (57.3984,60.0469) -- (59.2617,60.0469) -- (59.7070,61.4102) --
        (60.8281,61.4102) -- (58.9336,55.5859) -- cycle(49.4492,55.5859) --
        (49.4492,61.4102) -- (50.5352,61.4102) -- (50.5352,56.2227) --
        (50.5469,56.2227) -- (51.9297,61.4102) -- (52.5391,61.4102) --
        (53.9258,56.2227) -- (53.9414,56.2227) -- (53.9414,61.4102) --
        (55.0273,61.4102) -- (55.0273,55.5859) -- (53.2070,55.5859) --
        (52.2422,59.1953) -- (52.2266,59.1953) -- (51.2656,55.5859) --
        cycle(44.5352,55.5859) -- (44.5352,61.4102) -- (48.4258,61.4102) --
        (48.4258,60.3984) -- (45.6758,60.3984) -- (45.6758,58.8125) --
        (47.4688,58.8125) -- (47.4688,57.8789) -- (45.6758,57.8789) --
        (45.6758,56.5977) -- (48.4258,56.5977) -- (48.4258,55.5859) --
        cycle(38.6680,55.5859) -- (38.6680,61.4102) -- (39.8086,61.4102) --
        (39.8086,58.8984) -- (42.0078,58.8984) -- (42.0078,61.4102) --
        (43.1445,61.4102) -- (43.1445,55.5859) -- (42.0078,55.5859) --
        (42.0078,57.8867) -- (39.8086,57.8867) -- (39.8086,55.5859) --
        cycle(33.2969,55.5859) -- (33.2969,56.5977) -- (34.9336,56.5977) --
        (34.9336,61.4102) -- (36.0742,61.4102) -- (36.0742,56.5977) --
        (37.7188,56.5977) -- (37.7188,55.5859) -- cycle(31.7188,59.1953) --
        (30.3945,59.1953) -- (31.0469,57.1602) -- (31.0625,57.1602) --
        cycle(30.4492,55.5859) -- (28.5586,61.4102) -- (29.6836,61.4102) --
        (30.1289,60.0469) -- (31.9922,60.0469) -- (32.4375,61.4102) --
        (33.5586,61.4102) -- (31.6641,55.5859) -- cycle(22.1797,55.5859) --
        (22.1797,61.4102) -- (23.2656,61.4102) -- (23.2656,56.2227) --
        (23.2812,56.2227) -- (24.6602,61.4102) -- (25.2695,61.4102) --
        (26.6562,56.2227) -- (26.6719,56.2227) -- (26.6719,61.4102) --
        (27.7578,61.4102) -- (27.7578,55.5859) -- (25.9375,55.5859) --
        (24.9727,59.1953) -- (24.9570,59.1953) -- (23.9961,55.5859) --
        cycle(15.2305,55.5859) -- (15.2305,61.4102) -- (16.3711,61.4102) --
        (16.3711,59.1250) -- (17.8828,59.1250) -- (17.8828,58.1133) --
        (16.3711,58.1133) -- (16.3711,56.5977) -- (18.7930,56.5977) --
        (18.7930,55.5859) -- cycle(11.5938,56.4805) .. controls (11.7266,56.4805) and
        (12.0703,56.5117) .. (12.3984,56.7695) .. controls (12.8281,57.1133) and
        (12.9688,57.7617) .. (12.9688,58.5117) .. controls (12.9688,58.9062) and
        (12.9531,60.5078) .. (11.6250,60.5078) .. controls (10.2383,60.5078) and
        (10.2383,58.8750) .. (10.2383,58.5156) .. controls (10.2383,57.9102) and
        (10.3398,56.4805) .. (11.5938,56.4805)(11.4883,55.4688) .. controls
        (10.2773,55.4688) and (9.0391,56.3164) .. (9.0391,58.5000) .. controls
        (9.0391,60.6992) and (10.2852,61.5195) .. (11.6250,61.5195) .. controls
        (13.2344,61.5195) and (14.1680,60.4297) .. (14.1680,58.5312) .. controls
        (14.1680,56.6055) and (13.2578,55.4688) .. (11.4883,55.4688);
      \path[fill=black,nonzero rule] (82.3242,46.0977) -- (82.3242,51.9258) --
        (85.8672,51.9258) -- (85.8672,50.9180) -- (83.4648,50.9180) --
        (83.4648,46.0977) -- cycle(78.7227,46.9922) .. controls (78.8555,46.9922) and
        (79.1953,47.0234) .. (79.5234,47.2812) .. controls (79.9531,47.6250) and
        (80.0938,48.2734) .. (80.0938,49.0234) .. controls (80.0938,49.4219) and
        (80.0781,51.0195) .. (78.7539,51.0195) .. controls (77.3633,51.0195) and
        (77.3633,49.3906) .. (77.3633,49.0312) .. controls (77.3633,48.4219) and
        (77.4648,46.9922) .. (78.7227,46.9922)(78.6133,45.9805) .. controls
        (77.4023,45.9805) and (76.1641,46.8281) .. (76.1641,49.0156) .. controls
        (76.1641,51.2148) and (77.4102,52.0312) .. (78.7539,52.0312) .. controls
        (80.3594,52.0312) and (81.2969,50.9414) .. (81.2969,49.0469) .. controls
        (81.2969,47.1172) and (80.3828,45.9805) .. (78.6133,45.9805)(72.8711,46.9922)
        .. controls (73.0039,46.9922) and (73.3477,47.0234) .. (73.6758,47.2812) ..
        controls (74.1055,47.6250) and (74.2422,48.2734) .. (74.2422,49.0234) ..
        controls (74.2422,49.4219) and (74.2305,51.0195) .. (72.9023,51.0195) ..
        controls (71.5156,51.0195) and (71.5156,49.3906) .. (71.5156,49.0312) ..
        controls (71.5156,48.4219) and (71.6172,46.9922) ..
        (72.8711,46.9922)(72.7617,45.9805) .. controls (71.5547,45.9805) and
        (70.3125,46.8281) .. (70.3125,49.0156) .. controls (70.3125,51.2148) and
        (71.5625,52.0312) .. (72.9023,52.0312) .. controls (74.5078,52.0312) and
        (75.4453,50.9414) .. (75.4453,49.0469) .. controls (75.4453,47.1172) and
        (74.5312,45.9805) .. (72.7617,45.9805)(64.7930,46.0977) -- (64.7930,51.9258)
        -- (65.9297,51.9258) -- (65.9297,49.4102) -- (68.1289,49.4102) --
        (68.1289,51.9258) -- (69.2695,51.9258) -- (69.2695,46.0977) --
        (68.1289,46.0977) -- (68.1289,48.3984) -- (65.9297,48.3984) --
        (65.9297,46.0977) -- cycle(63.7695,47.5781) .. controls (63.6992,47.3047) and
        (63.2305,45.9648) .. (61.6562,45.9805) .. controls (60.2656,45.9805) and
        (59.1055,47.0391) .. (59.1055,49.1094) .. controls (59.1055,51.3633) and
        (60.5391,52.0312) .. (61.6328,52.0312) .. controls (62.5039,52.0312) and
        (63.0586,51.6172) .. (63.3945,51.1992) .. controls (63.6758,50.8477) and
        (63.7461,50.5508) .. (63.8242,50.2539) -- (62.7617,49.9570) .. controls
        (62.4102,50.9961) and (61.6094,50.9961) .. (61.4922,50.9961) .. controls
        (60.6641,50.9961) and (60.3047,50.0508) .. (60.3047,49.0625) .. controls
        (60.3047,48.4141) and (60.4766,46.9258) .. (61.6016,46.9258) .. controls
        (61.9453,46.9258) and (62.5039,47.0625) .. (62.6992,47.8828) --
        cycle(58.1523,47.0938) .. controls (58.0430,46.9062) and (57.9414,46.7305) ..
        (57.6992,46.5195) .. controls (57.3086,46.1836) and (56.7891,45.9805) ..
        (56.1797,45.9805) .. controls (55.1562,45.9805) and (54.2227,46.5430) ..
        (54.2227,47.6797) .. controls (54.2227,48.9219) and (55.4688,49.2773) ..
        (56.1328,49.4609) .. controls (56.7422,49.6133) and (57.2578,49.8008) ..
        (57.2578,50.3242) .. controls (57.2578,50.6992) and (56.9453,51.0898) ..
        (56.2891,51.0898) .. controls (55.5781,51.0898) and (55.2734,50.6211) ..
        (55.0547,50.2930) -- (54.0352,50.6914) .. controls (54.2227,51.0586) and
        (54.7227,52.0312) .. (56.2188,52.0312) .. controls (57.7539,52.0312) and
        (58.3164,50.9805) .. (58.3164,50.2227) .. controls (58.3164,49.8398) and
        (58.1680,49.3359) .. (57.8398,49.0000) .. controls (57.5508,48.7109) and
        (57.1133,48.5078) .. (56.3594,48.3203) .. controls (55.5547,48.1250) and
        (55.2812,47.9453) .. (55.2812,47.5469) .. controls (55.2812,47.1797) and
        (55.5703,46.8164) .. (56.1250,46.8164) .. controls (56.7266,46.8164) and
        (57.0469,47.2656) .. (57.1914,47.4844) -- cycle(46.9297,46.0977) --
        (46.9297,51.9258) -- (50.8203,51.9258) -- (50.8203,50.9102) --
        (48.0664,50.9102) -- (48.0664,49.3242) -- (49.8594,49.3242) --
        (49.8594,48.3906) -- (48.0664,48.3906) -- (48.0664,47.1094) --
        (50.8203,47.1094) -- (50.8203,46.0977) -- cycle(41.5391,46.0977) --
        (41.5391,47.1094) -- (43.1758,47.1094) -- (43.1758,51.9258) --
        (44.3164,51.9258) -- (44.3164,47.1094) -- (45.9609,47.1094) --
        (45.9609,46.0977) -- cycle(39.9648,49.7070) -- (38.6367,49.7070) --
        (39.2930,47.6719) -- (39.3086,47.6719) -- cycle(38.6914,46.0977) --
        (36.8047,51.9258) -- (37.9258,51.9258) -- (38.3711,50.5586) --
        (40.2344,50.5586) -- (40.6797,51.9258) -- (41.8047,51.9258) --
        (39.9062,46.0977) -- cycle(31.6797,46.0977) -- (31.6797,49.8477) .. controls
        (31.6797,51.3867) and (32.5547,52.0312) .. (34.0195,52.0312) .. controls
        (35.6758,52.0312) and (36.2969,51.0898) .. (36.2969,49.8242) --
        (36.2969,46.0977) -- (35.1602,46.0977) -- (35.1602,49.6680) .. controls
        (35.1602,50.4883) and (34.7539,50.9961) .. (33.9727,50.9961) .. controls
        (33.1719,50.9961) and (32.8203,50.4414) .. (32.8203,49.6680) --
        (32.8203,46.0977) -- cycle(27.6641,47.1094) .. controls (28.6367,47.1094) and
        (29.4258,47.7812) .. (29.4258,48.9609) .. controls (29.4258,49.7383) and
        (29.0430,50.9102) .. (27.8984,50.9102) -- (27.0938,50.9102) --
        (27.0938,47.1094) -- cycle(25.9570,46.0977) -- (25.9570,51.9258) --
        (27.8750,51.9258) .. controls (28.5078,51.9258) and (29.2852,51.7617) ..
        (29.8164,51.2227) .. controls (30.3789,50.6445) and (30.6289,49.7539) ..
        (30.6289,48.9688) .. controls (30.6289,47.4531) and (29.7383,46.0977) ..
        (28.0625,46.0977) -- cycle(23.2734,49.7070) -- (21.9453,49.7070) --
        (22.6016,47.6719) -- (22.6172,47.6719) -- cycle(22.0000,46.0977) --
        (20.1133,51.9258) -- (21.2344,51.9258) -- (21.6797,50.5586) --
        (23.5469,50.5586) -- (23.9883,51.9258) -- (25.1133,51.9258) --
        (23.2188,46.0977) -- cycle(17.2891,47.1094) .. controls (17.5156,47.1094) and
        (18.3828,47.1406) .. (18.3828,47.8672) .. controls (18.3828,48.4297) and
        (17.8281,48.6875) .. (17.2891,48.6875) -- (16.3672,48.6875) --
        (16.3672,47.1094) -- cycle(15.2305,46.0977) -- (15.2305,51.9258) --
        (16.3672,51.9258) -- (16.3672,49.5859) -- (17.4297,49.5859) --
        (18.3984,51.9258) -- (19.5352,51.9258) -- (18.4922,49.3633) .. controls
        (18.9883,49.1602) and (19.5820,48.8594) .. (19.5820,47.9219) .. controls
        (19.5820,47.4688) and (19.4414,46.9766) .. (19.0586,46.6133) .. controls
        (18.7383,46.3008) and (18.3203,46.0977) .. (16.7969,46.0977) --
        cycle(13.9688,47.6875) .. controls (13.8750,47.3516) and (13.7852,46.9922) ..
        (13.3828,46.6133) .. controls (13.0469,46.2930) and (12.5234,45.9805) ..
        (11.7070,45.9805) .. controls (11.0273,45.9805) and (10.2695,46.2227) ..
        (9.7383,46.8086) .. controls (9.2617,47.3359) and (9.0352,48.1172) ..
        (9.0352,49.1211) .. controls (9.0352,50.2383) and (9.3086,50.8242) ..
        (9.6289,51.2305) .. controls (9.9883,51.6914) and (10.6367,52.0312) ..
        (11.3789,52.0312) .. controls (12.1016,52.0312) and (12.6562,51.7539) ..
        (13.1484,51.2148) -- (13.1484,51.9258) -- (14.0664,51.9258) --
        (14.0664,48.9297) -- (11.6289,48.9297) -- (11.6289,49.8242) --
        (13.1484,49.8242) .. controls (13.1016,50.0586) and (13.0312,50.3320) ..
        (12.7578,50.6133) .. controls (12.4688,50.9102) and (12.0469,51.0586) ..
        (11.6797,51.0586) .. controls (11.2617,51.0586) and (10.8477,50.8711) ..
        (10.6055,50.5430) .. controls (10.4258,50.3008) and (10.2383,49.9336) ..
        (10.2383,48.9844) .. controls (10.2383,48.7266) and (10.2461,48.2188) ..
        (10.4336,47.7734) .. controls (10.6211,47.3281) and (11.0039,46.9531) ..
        (11.7500,46.9531) .. controls (12.7109,46.9531) and (12.9531,47.6875) ..
        (13.0547,48.0000) -- cycle(13.9688,47.6875);
      \path[fill=black,nonzero rule] (94.9609,36.6094) -- (94.9609,42.4375) --
        (98.5039,42.4375) -- (98.5039,41.4297) -- (96.1016,41.4297) --
        (96.1016,36.6094) -- cycle(92.3086,40.2188) -- (90.9844,40.2188) --
        (91.6367,38.1836) -- (91.6562,38.1836) -- cycle(91.0391,36.6094) --
        (89.1523,42.4375) -- (90.2734,42.4375) -- (90.7188,41.0703) --
        (92.5820,41.0703) -- (93.0273,42.4375) -- (94.1523,42.4375) --
        (92.2539,36.6094) -- cycle(83.6758,36.6094) -- (83.6758,42.4375) --
        (84.8125,42.4375) -- (84.8125,38.3711) -- (84.8281,38.3711) --
        (87.2773,42.4375) -- (88.4102,42.4375) -- (88.4102,36.6094) --
        (87.2695,36.6094) -- (87.2695,40.5156) -- (87.2539,40.5156) --
        (84.8828,36.6094) -- cycle(80.0625,37.5078) .. controls (80.1953,37.5078) and
        (80.5391,37.5352) .. (80.8672,37.7969) .. controls (81.2969,38.1367) and
        (81.4375,38.7852) .. (81.4375,39.5352) .. controls (81.4375,39.9336) and
        (81.4219,41.5312) .. (80.0938,41.5312) .. controls (78.7070,41.5312) and
        (78.7070,39.9023) .. (78.7070,39.5430) .. controls (78.7070,38.9336) and
        (78.8086,37.5078) .. (80.0625,37.5078)(79.9531,36.4922) .. controls
        (78.7461,36.4922) and (77.5039,37.3438) .. (77.5039,39.5273) .. controls
        (77.5039,41.7266) and (78.7539,42.5469) .. (80.0938,42.5469) .. controls
        (81.7031,42.5469) and (82.6367,41.4531) .. (82.6367,39.5586) .. controls
        (82.6367,37.6328) and (81.7227,36.4922) .. (79.9531,36.4922)(75.2344,42.4375)
        -- (76.3750,42.4375) -- (76.3750,36.6094) -- (75.2344,36.6094) --
        cycle(69.7773,36.6094) -- (69.7773,37.6250) -- (71.4141,37.6250) --
        (71.4141,42.4375) -- (72.5508,42.4375) -- (72.5508,37.6250) --
        (74.1992,37.6250) -- (74.1992,36.6094) -- cycle(68.1992,40.2188) --
        (66.8750,40.2188) -- (67.5273,38.1836) -- (67.5430,38.1836) --
        cycle(66.9297,36.6094) -- (65.0391,42.4375) -- (66.1641,42.4375) --
        (66.6094,41.0703) -- (68.4727,41.0703) -- (68.9180,42.4375) --
        (70.0391,42.4375) -- (68.1445,36.6094) -- cycle(59.5664,36.6094) --
        (59.5664,42.4375) -- (60.7031,42.4375) -- (60.7031,38.3711) --
        (60.7188,38.3711) -- (63.1680,42.4375) -- (64.3008,42.4375) --
        (64.3008,36.6094) -- (63.1602,36.6094) -- (63.1602,40.5156) --
        (63.1445,40.5156) -- (60.7734,36.6094) -- cycle(56.2031,37.6250) .. controls
        (56.4297,37.6250) and (57.2969,37.6523) .. (57.2969,38.3789) .. controls
        (57.2969,38.9414) and (56.7422,39.1992) .. (56.2031,39.1992) --
        (55.2812,39.1992) -- (55.2812,37.6250) -- cycle(54.1445,36.6094) --
        (54.1445,42.4375) -- (55.2812,42.4375) -- (55.2812,40.0977) --
        (56.3438,40.0977) -- (57.3086,42.4375) -- (58.4492,42.4375) --
        (57.4062,39.8789) .. controls (57.9023,39.6758) and (58.4961,39.3711) ..
        (58.4961,38.4336) .. controls (58.4961,37.9805) and (58.3555,37.4883) ..
        (57.9727,37.1250) .. controls (57.6562,36.8125) and (57.2305,36.6094) ..
        (55.7109,36.6094) -- cycle(49.1914,36.6094) -- (49.1914,42.4375) --
        (53.0820,42.4375) -- (53.0820,41.4219) -- (50.3281,41.4219) --
        (50.3281,39.8398) -- (52.1250,39.8398) -- (52.1250,38.9023) --
        (50.3281,38.9023) -- (50.3281,37.6250) -- (53.0820,37.6250) --
        (53.0820,36.6094) -- cycle(43.8008,36.6094) -- (43.8008,37.6250) --
        (45.4375,37.6250) -- (45.4375,42.4375) -- (46.5781,42.4375) --
        (46.5781,37.6250) -- (48.2227,37.6250) -- (48.2227,36.6094) --
        cycle(38.1211,36.6094) -- (38.1211,42.4375) -- (39.2617,42.4375) --
        (39.2617,38.3711) -- (39.2773,38.3711) -- (41.7266,42.4375) --
        (42.8555,42.4375) -- (42.8555,36.6094) -- (41.7188,36.6094) --
        (41.7188,40.5156) -- (41.7031,40.5156) -- (39.3320,36.6094) --
        cycle(35.5352,42.4375) -- (36.6719,42.4375) -- (36.6719,36.6094) --
        (35.5352,36.6094) -- cycle(26.9062,36.6094) -- (26.9062,42.4375) --
        (28.0469,42.4375) -- (28.0469,38.3711) -- (28.0625,38.3711) --
        (30.5117,42.4375) -- (31.6406,42.4375) -- (31.6406,36.6094) --
        (30.5039,36.6094) -- (30.5039,40.5156) -- (30.4883,40.5156) --
        (28.1172,36.6094) -- cycle(20.8164,36.6094) -- (20.8164,42.4375) --
        (21.9531,42.4375) -- (21.9531,38.3711) -- (21.9688,38.3711) --
        (24.4180,42.4375) -- (25.5508,42.4375) -- (25.5508,36.6094) --
        (24.4102,36.6094) -- (24.4102,40.5156) -- (24.3945,40.5156) --
        (22.0234,36.6094) -- cycle(17.2031,37.5078) .. controls (17.3359,37.5078) and
        (17.6797,37.5352) .. (18.0078,37.7969) .. controls (18.4375,38.1367) and
        (18.5781,38.7852) .. (18.5781,39.5352) .. controls (18.5781,39.9336) and
        (18.5586,41.5312) .. (17.2344,41.5312) .. controls (15.8477,41.5312) and
        (15.8477,39.9023) .. (15.8477,39.5430) .. controls (15.8477,38.9336) and
        (15.9492,37.5078) .. (17.2031,37.5078)(17.0938,36.4922) .. controls
        (15.8867,36.4922) and (14.6445,37.3438) .. (14.6445,39.5273) .. controls
        (14.6445,41.7266) and (15.8945,42.5469) .. (17.2344,42.5469) .. controls
        (18.8398,42.5469) and (19.7773,41.4531) .. (19.7773,39.5586) .. controls
        (19.7773,37.6328) and (18.8672,36.4922) .. (17.0938,36.4922)(11.6797,39.7930)
        .. controls (12.2500,39.7930) and (12.7500,40.0586) .. (12.7500,40.6484) ..
        controls (12.7500,41.4688) and (11.8750,41.5391) .. (11.4375,41.5391) --
        (10.5195,41.5391) -- (10.5195,39.7930) -- cycle(11.7109,37.5078) .. controls
        (12.0234,37.5078) and (12.6094,37.5859) .. (12.6094,38.1992) .. controls
        (12.6094,38.6992) and (12.1641,38.8945) .. (11.7422,38.8945) --
        (10.5195,38.8945) -- (10.5195,37.5078) -- cycle(9.3789,36.6094) --
        (9.3789,42.4375) -- (11.9453,42.4375) .. controls (13.5234,42.4375) and
        (13.9531,41.4688) .. (13.9531,40.8359) .. controls (13.9531,40.4062) and
        (13.7500,39.9727) .. (13.3984,39.6836) .. controls (13.1797,39.5039) and
        (13.0078,39.4336) .. (12.7031,39.3477) -- (12.7031,39.3320) .. controls
        (12.9688,39.2539) and (13.7969,38.9648) .. (13.7969,37.9961) .. controls
        (13.7969,37.6992) and (13.7188,37.3672) .. (13.4219,37.0703) .. controls
        (13.1016,36.7578) and (12.6875,36.6094) .. (11.8672,36.6094) --
        cycle(9.3789,36.6094);
      \path[fill=c004e9e,nonzero rule] (63.5000,10.5664) -- (70.4492,14.1367) ..
        controls (71.9453,14.8633) and (72.8281,16.5938) .. (72.8281,18.5117) ..
        controls (72.8281,21.6602) and (70.6016,23.6562) .. (67.8750,23.6562) --
        (58.6250,23.6562) -- (58.6250,20.0859) -- (67.6836,20.0859) .. controls
        (68.2969,20.0859) and (68.7969,19.6250) .. (68.7969,18.8203) .. controls
        (68.7969,17.8203) and (67.7227,17.3594) .. (67.7227,17.3594) --
        (61.1211,13.8281) .. controls (59.6250,13.0234) and (58.6250,11.2578) ..
        (58.6250,9.4141) .. controls (58.6250,6.6875) and (60.8516,4.4648) ..
        (63.5781,4.4648) -- (72.0586,4.4648) -- (72.0586,8.0312) -- (63.5781,8.0312)
        .. controls (62.9648,8.0312) and (62.4648,8.5312) .. (62.4648,9.1055) ..
        controls (62.4648,10.1055) and (63.5000,10.5664) ..
        (63.5000,10.5664)(56.8984,14.0586) .. controls (56.8984,13.6367) and
        (56.8984,13.2539) .. (56.8203,12.7930) -- (56.7461,12.2539) --
        (47.3008,12.2539) -- (47.3008,15.5938) -- (52.8672,15.5938) .. controls
        (52.1758,18.0117) and (49.9492,20.0078) .. (47.3008,20.0078) .. controls
        (44.1172,20.0078) and (41.5430,17.2461) .. (41.5430,14.0586) .. controls
        (41.5430,10.8711) and (44.1172,8.1094) .. (47.3008,8.1094) .. controls
        (49.1445,8.1094) and (50.7578,9.1445) .. (51.8320,10.4883) --
        (56.2070,10.4883) .. controls (54.7891,6.9570) and (51.3320,4.4648) ..
        (47.3008,4.4648) .. controls (42.0039,4.4648) and (37.7070,8.7617) ..
        (37.7070,14.0586) .. controls (37.7070,19.3555) and (42.0039,23.6562) ..
        (47.3008,23.6562) .. controls (52.5977,23.6562) and (56.8984,19.3555) ..
        (56.8984,14.0586)(35.0195,4.4648) -- (30.9883,4.4648) -- (30.9883,23.6562) --
        (35.0195,23.6562) -- cycle(24.4609,14.0586) .. controls (24.4609,17.2461) and
        (21.8906,20.0078) .. (18.7031,20.0078) .. controls (15.5195,20.0078) and
        (12.9453,17.2461) .. (12.9453,14.0586) .. controls (12.9453,10.8711) and
        (15.5195,8.1094) .. (18.7031,8.1094) .. controls (21.8906,8.1094) and
        (24.4609,10.8711) .. (24.4609,14.0586)(28.3008,14.0586) .. controls
        (28.3008,8.7617) and (24.0039,4.4648) .. (18.7031,4.4648) .. controls
        (16.5547,4.4648) and (14.5195,5.2305) .. (12.9453,6.7656) -- (12.9453,0.0859)
        -- (9.1094,0.0859) -- (9.1094,14.0586) .. controls (9.1094,19.3555) and
        (13.4062,23.6562) .. (18.7031,23.6562) .. controls (24.0039,23.6562) and
        (28.3008,19.3555) .. (28.3008,14.0586);
      \path[fill=c004e9e,nonzero rule] (0.0000,57.4297) -- (3.8164,57.4297) --
        (3.8164,61.2422) -- (0.0000,61.2422) -- cycle(0.0000,57.4297);
      \path[fill=c004e9e,nonzero rule] (0.0000,47.8555) -- (3.8164,47.8555) --
        (3.8164,51.6719) -- (0.0000,51.6719) -- cycle(0.0000,47.8555);
      \path[fill=c9daad7,nonzero rule] (0.0000,38.3867) -- (3.8164,38.3867) --
        (3.8164,42.2031) -- (0.0000,42.2031) -- cycle(0.0000,38.3867);
      \path[fill=c9daad7,nonzero rule] (0.0000,28.9648) -- (3.8164,28.9648) --
        (3.8164,32.7812) -- (0.0000,32.7812) -- cycle(0.0000,28.9648);
      \path[fill=c9daad7,nonzero rule] (0.0000,19.3945) -- (3.8164,19.3945) --
        (3.8164,23.2109) -- (0.0000,23.2109) -- cycle(0.0000,19.3945);
      \path[fill=c9daad7,nonzero rule] (0.0000,9.6211) -- (3.8164,9.6211) --
        (3.8164,13.4375) -- (0.0000,13.4375) -- cycle(0.0000,9.6211);
      \path[fill=c9daad7,nonzero rule] (0.0000,0.0000) -- (3.8164,0.0000) --
        (3.8164,3.8164) -- (0.0000,3.8164) -- cycle(0.0000,0.0000);
    \end{tikzpicture}%
  }%
}

\newcommand{\@unilogo}[1]{%
  \resizebox{#1}{!}{%
    \begin{tikzpicture}[y=0.80pt, x=0.80pt, yscale=-1.000000, xscale=1.000000, inner sep=0pt, outer sep=0pt]
      \path[fill=c1f55ad,nonzero rule] (119.8555,15.7227) .. controls
        (124.5781,10.1641) and (127.2344,5.6016) .. (129.3555,0.0000) --
        (92.9727,0.0000) -- (92.9727,31.4336) .. controls (100.1680,30.4648) and
        (110.2617,27.0156) .. (119.8555,15.7227);
      \path[fill=cf9b10a,nonzero rule] (92.9766,40.9453) -- (149.9414,40.9453) --
        (149.9414,56.9570) -- (92.9766,56.9570) -- cycle(92.9766,40.9453);
      \path[fill=c848270,nonzero rule] (149.9336,0.0000) -- (131.7383,0.0000) ..
        controls (129.5586,5.9258) and (126.2500,11.9219) .. (121.2188,17.8438) ..
        controls (111.3164,29.5000) and (100.3516,33.0117) .. (92.9727,33.9844) --
        (92.9727,38.4102) -- (149.9336,38.4102) -- cycle(149.9336,0.0000);
      \path[fill=cffffff,nonzero rule] (99.5156,52.6758) .. controls
        (100.9023,52.6758) and (101.3359,52.3945) .. (101.3359,51.1562) .. controls
        (101.3359,49.7852) and (100.8711,49.4258) .. (99.4570,49.4102) --
        (97.5625,49.4102) -- (97.5625,52.6602) -- cycle(97.5625,45.1641) --
        (97.5625,48.0547) -- (99.4258,48.0547) .. controls (100.6797,48.0547) and
        (101.0977,47.7578) .. (101.0977,46.5820) .. controls (101.0977,45.4336) and
        (100.6484,45.1641) .. (99.2773,45.1641) -- cycle(101.1250,48.7578) .. controls
        (102.6758,48.8906) and (103.1992,49.8594) .. (103.1992,51.5000) .. controls
        (103.1992,53.6133) and (102.2266,54.1797) .. (99.8281,54.1797) .. controls
        (97.9531,54.1797) and (96.9688,54.1641) .. (95.7305,54.0625) --
        (95.7305,43.7812) .. controls (96.8320,43.6758) and (97.7266,43.6602) ..
        (99.3672,43.6602) .. controls (101.9609,43.6602) and (102.8828,44.2266) ..
        (102.8828,46.3438) .. controls (102.8828,47.8203) and (102.3789,48.5781) ..
        (101.1250,48.6953) -- cycle(101.1250,48.7578);
      \path[fill=cffffff,nonzero rule] (106.6953,48.9219) .. controls
        (106.6953,51.7812) and (107.2344,52.6602) .. (108.9609,52.6602) .. controls
        (110.7031,52.6602) and (111.2422,51.7812) .. (111.2422,48.9219) .. controls
        (111.2422,46.0586) and (110.7031,45.1797) .. (108.9609,45.1797) .. controls
        (107.2344,45.1797) and (106.6953,46.0586) ..
        (106.6953,48.9219)(113.2109,48.9219) .. controls (113.2109,53.0039) and
        (112.1055,54.2539) .. (108.9609,54.2539) .. controls (105.8320,54.2539) and
        (104.7305,53.0039) .. (104.7305,48.9219) .. controls (104.7305,44.8359) and
        (105.8320,43.5859) .. (108.9609,43.5859) .. controls (112.1055,43.5859) and
        (113.2109,44.8359) .. (113.2109,48.9219);
      \path[fill=cffffff,nonzero rule] (123.5039,53.3750) .. controls
        (123.5039,53.8242) and (123.2656,54.0625) .. (122.8164,54.0625) --
        (121.3398,54.0625) .. controls (120.9414,54.0625) and (120.7305,53.8828) ..
        (120.5664,53.4961) -- (117.6758,47.1914) .. controls (117.4805,46.7734) and
        (117.1680,46.1367) .. (117.0664,45.6562) -- (116.8867,45.6562) .. controls
        (116.9609,46.1797) and (116.9766,46.6992) .. (116.9766,47.2070) --
        (116.9766,54.0625) -- (115.1445,54.0625) -- (115.1445,44.4648) .. controls
        (115.1445,44.0195) and (115.3984,43.7812) .. (115.8438,43.7812) --
        (117.2891,43.7812) .. controls (117.6914,43.7812) and (117.8828,43.9570) ..
        (118.0664,44.3477) -- (120.8633,50.4727) .. controls (121.0586,50.9180) and
        (121.3555,51.5430) .. (121.5820,52.0938) -- (121.7578,52.0938) .. controls
        (121.7148,51.5273) and (121.6875,50.9766) .. (121.6875,50.4258) --
        (121.6875,43.7812) -- (123.5039,43.7812) -- cycle(123.5039,53.3750);
      \path[fill=cffffff,nonzero rule] (134.1562,53.3750) .. controls
        (134.1562,53.8242) and (133.9141,54.0625) .. (133.4688,54.0625) --
        (131.9922,54.0625) .. controls (131.5938,54.0625) and (131.3828,53.8828) ..
        (131.2188,53.4961) -- (128.3281,47.1914) .. controls (128.1367,46.7734) and
        (127.8203,46.1367) .. (127.7188,45.6562) -- (127.5391,45.6562) .. controls
        (127.6133,46.1797) and (127.6289,46.6992) .. (127.6289,47.2070) --
        (127.6289,54.0625) -- (125.7969,54.0625) -- (125.7969,44.4648) .. controls
        (125.7969,44.0195) and (126.0508,43.7812) .. (126.4961,43.7812) --
        (127.9414,43.7812) .. controls (128.3438,43.7812) and (128.5352,43.9570) ..
        (128.7148,44.3477) -- (131.5156,50.4727) .. controls (131.7109,50.9180) and
        (132.0078,51.5430) .. (132.2305,52.0938) -- (132.4102,52.0938) .. controls
        (132.3672,51.5273) and (132.3359,50.9766) .. (132.3359,50.4258) --
        (132.3359,43.7812) -- (134.1562,43.7812) -- cycle(134.1562,53.3750);
      \path[fill=c848270,nonzero rule] (10.4883,50.0938) .. controls (10.4883,53.1055)
        and (9.4883,54.2539) .. (6.7578,54.2539) .. controls (3.9414,54.2539) and
        (2.9141,53.1055) .. (2.9141,50.0938) -- (2.9141,43.7734) -- (4.4062,43.7734)
        -- (4.4062,50.0938) .. controls (4.4062,52.2109) and (4.9883,52.9258) ..
        (6.6992,52.9258) .. controls (8.3828,52.9258) and (8.9961,52.2109) ..
        (8.9961,50.0938) -- (8.9961,43.7734) -- (10.4883,43.7734) --
        cycle(10.4883,50.0938);
      \path[fill=c848270,nonzero rule] (20.9727,53.4805) .. controls (20.9727,53.8672)
        and (20.7773,54.0586) .. (20.4180,54.0586) -- (19.0039,54.0586) .. controls
        (18.6758,54.0586) and (18.4961,53.9141) .. (18.3633,53.5977) --
        (15.1562,46.5898) .. controls (14.9805,46.2070) and (14.6641,45.5938) ..
        (14.5469,45.1602) -- (14.3398,45.1602) .. controls (14.3984,45.6367) and
        (14.4102,46.1289) .. (14.4102,46.5898) -- (14.4102,54.0586) --
        (12.9219,54.0586) -- (12.9219,44.3555) .. controls (12.9219,43.9688) and
        (13.1289,43.7734) .. (13.4883,43.7734) -- (14.8594,43.7734) .. controls
        (15.1875,43.7734) and (15.3672,43.9219) .. (15.5156,44.2344) --
        (18.6328,51.0625) .. controls (18.8242,51.4805) and (19.1211,52.0781) ..
        (19.3477,52.6016) -- (19.5703,52.6016) .. controls (19.5273,52.0625) and
        (19.4961,51.5430) .. (19.4961,51.0039) -- (19.4961,43.7734) --
        (20.9727,43.7734) -- cycle(20.9727,53.4805);
      \path[fill=c848270,nonzero rule] (23.4844,43.7734) -- (24.9727,43.7734) --
        (24.9727,54.0586) -- (23.4844,54.0586) -- cycle(23.4844,43.7734);
      \path[fill=c848270,nonzero rule] (32.0859,53.6445) .. controls (32.0117,53.8828)
        and (31.7891,54.0586) .. (31.5195,54.0586) -- (30.0586,54.0586) .. controls
        (29.7891,54.0586) and (29.5664,53.8828) .. (29.4922,53.6445) --
        (26.4492,43.7734) -- (27.9844,43.7734) -- (30.3125,51.7812) .. controls
        (30.4180,52.1523) and (30.5039,52.5391) .. (30.5938,52.9141) --
        (30.9961,52.9141) .. controls (31.0742,52.5391) and (31.1758,52.1523) ..
        (31.2812,51.7812) -- (33.5898,43.7734) -- (35.1289,43.7734) --
        cycle(32.0859,53.6445);
      \path[fill=c848270,nonzero rule] (43.0039,53.9727) .. controls (41.6484,54.0898)
        and (40.0664,54.0898) .. (38.5898,54.0898) .. controls (37.3086,54.0898) and
        (36.5312,53.3750) .. (36.5195,52.2422) -- (36.5195,45.5938) .. controls
        (36.5312,44.4609) and (37.3242,43.7461) .. (38.5898,43.7461) .. controls
        (40.0664,43.7461) and (41.6484,43.7461) .. (43.0039,43.8633) --
        (42.9297,45.0273) -- (38.8438,45.0273) .. controls (38.2500,45.0273) and
        (38.0234,45.2812) .. (38.0234,45.9805) -- (38.0234,48.0391) --
        (42.3633,48.0391) -- (42.3633,49.2461) -- (38.0234,49.2461) --
        (38.0234,51.8672) .. controls (38.0234,52.5703) and (38.2500,52.8242) ..
        (38.8438,52.8242) -- (42.9297,52.8242) -- cycle(43.0039,53.9727);
      \path[fill=c848270,nonzero rule] (48.5547,48.5430) .. controls (50.0000,48.5312)
        and (50.4766,48.1289) .. (50.4766,46.7109) .. controls (50.4766,45.2930) and
        (50.0000,44.9219) .. (48.5547,44.9219) .. controls (47.7500,44.9219) and
        (47.0352,44.9219) .. (46.4688,44.9375) -- (46.4688,48.5430) --
        cycle(50.7617,54.0625) -- (49.8828,50.8555) .. controls (49.6406,50.1094) and
        (49.2422,49.8281) .. (48.5859,49.8281) -- (46.4688,49.8125) --
        (46.4688,54.0625) -- (44.9922,54.0625) -- (44.9922,43.7734) .. controls
        (46.1250,43.6562) and (46.8984,43.6406) .. (48.5859,43.6406) .. controls
        (51.0000,43.6406) and (51.9805,44.3125) .. (51.9805,46.6211) .. controls
        (51.9805,48.2461) and (51.4609,49.0664) .. (50.0898,49.2461) --
        (50.0898,49.3203) .. controls (50.5977,49.4688) and (51.1641,49.9180) ..
        (51.3867,50.8125) -- (52.3555,54.0625) -- cycle(50.7617,54.0625);
      \path[fill=c848270,nonzero rule] (60.2617,43.9102) -- (60.1719,44.9961) ..
        controls (59.3086,44.9688) and (58.1875,44.9219) .. (57.2227,44.9219) ..
        controls (55.8203,44.9219) and (55.2812,44.9805) .. (55.2812,46.3516) ..
        controls (55.2812,47.4102) and (55.6562,47.6953) .. (56.5195,47.9180) --
        (58.5625,48.4844) .. controls (60.1562,48.9180) and (60.6484,49.8711) ..
        (60.6484,51.4062) .. controls (60.6484,53.7773) and (59.6211,54.2383) ..
        (57.1445,54.2383) .. controls (56.4883,54.2383) and (55.3438,54.2109) ..
        (53.9102,53.9414) -- (54.0156,52.8398) .. controls (55.8789,52.8984) and
        (56.4023,52.9141) .. (57.1758,52.9141) .. controls (58.6797,52.8984) and
        (59.1289,52.6758) .. (59.1289,51.3906) .. controls (59.1289,50.2734) and
        (58.7422,50.0352) .. (57.9062,49.8125) -- (55.8203,49.2305) .. controls
        (54.3125,48.8125) and (53.7773,47.8750) .. (53.7773,46.3086) .. controls
        (53.7773,43.9258) and (54.8359,43.5977) .. (57.1602,43.5977) .. controls
        (58.1289,43.5977) and (59.2188,43.6562) .. (60.2617,43.9102);
      \path[fill=c848270,nonzero rule] (62.6367,43.7734) -- (64.1289,43.7734) --
        (64.1289,54.0586) -- (62.6367,54.0586) -- cycle(62.6367,43.7734);
      \path[fill=c848270,nonzero rule] (70.4805,45.1016) -- (70.4805,54.0586) --
        (68.9766,54.0586) -- (68.9766,45.1016) -- (65.7383,45.1016) --
        (65.7383,43.7734) -- (73.7461,43.7734) -- (73.7461,45.1016) --
        cycle(70.4805,45.1016);
      \path[fill=c848270,nonzero rule] (78.9805,42.6562) .. controls (78.7148,42.6562)
        and (78.5938,42.5352) .. (78.5938,42.2539) -- (78.5938,41.4492) .. controls
        (78.5938,41.2109) and (78.7148,41.0469) .. (78.9805,41.0469) --
        (79.4609,41.0469) .. controls (79.7109,41.0469) and (79.8594,41.2109) ..
        (79.8594,41.4492) -- (79.8594,42.2539) .. controls (79.8594,42.5352) and
        (79.7109,42.6562) .. (79.4609,42.6562) -- cycle(78.3398,45.7578) .. controls
        (78.2656,45.4883) and (78.1641,45.1914) .. (78.1016,44.9219) --
        (77.6992,44.9219) .. controls (77.6094,45.1914) and (77.5195,45.4883) ..
        (77.4453,45.7578) -- (76.2539,49.6641) -- (79.5469,49.6641) --
        cycle(76.3438,42.6562) .. controls (76.0742,42.6562) and (75.9570,42.5352) ..
        (75.9570,42.2539) -- (75.9570,41.4492) .. controls (75.9570,41.2109) and
        (76.0742,41.0469) .. (76.3438,41.0469) -- (76.8203,41.0469) .. controls
        (77.0898,41.0469) and (77.2070,41.2109) .. (77.2070,41.4492) --
        (77.2070,42.2539) .. controls (77.2070,42.5352) and (77.0898,42.6562) ..
        (76.8203,42.6562) -- cycle(75.8516,50.9609) -- (74.8984,54.0586) --
        (73.3594,54.0586) -- (76.5977,44.1758) .. controls (76.6562,43.9258) and
        (76.8789,43.7734) .. (77.1328,43.7734) -- (78.6523,43.7734) .. controls
        (78.9219,43.7734) and (79.1289,43.9258) .. (79.2070,44.1758) --
        (82.4414,54.0586) -- (80.9062,54.0586) -- (79.9531,50.9609) --
        cycle(75.8516,50.9609);
      \path[fill=c848270,nonzero rule] (86.7969,45.1016) -- (86.7969,54.0586) --
        (85.2930,54.0586) -- (85.2930,45.1016) -- (82.0586,45.1016) --
        (82.0586,43.7734) -- (90.0625,43.7734) -- (90.0625,45.1016) --
        cycle(86.7969,45.1016);
    \end{tikzpicture}%
  }%
}

\makeatother

\endinput

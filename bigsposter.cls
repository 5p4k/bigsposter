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
% This work consists of the files bigsposter.cls, bigsposter-example.cls
% and bigsposter-doc.tex.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bigsposter}[2017/06/20]

\makeatletter


\def\convertto#1#2{\strip@pt\dimexpr #2*65536/\number\dimexpr 1#1}


% Use article 12pt as base
\LoadClass[12pt]{article}

% Remove all header and footer
\pagestyle{empty}

% For includegraphics
\RequirePackage{graphicx}

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

\RequirePackage{multicol}

% MUST disable singlelinecheck or stuff inside the blockcaption will be evaluated twice
\RequirePackage[hypcap=false, singlelinecheck=false]{caption}

% Lengths and counters

\newlength{\@oldFrameSep}
\newlength{\@oldFrameRule}

\newcounter{block}
\newcounter{blockrow}
\newcounter{blockfootnote}
\newcounter{blockfootnotetext}

\setcounter{blockrow}{0}
\setcounter{blockfootnote}{0}
\setcounter{blockfootnotetext}{0}


% ALL PARMS --------------------------------------------

\def\@blockborderthickness{3pt}
\def\@bigsyellow{0.97,0.92,0.7} % rgb

\def\@titlelmargin{1em}
\def\@titlermargin{1em}
\def\@titletmargin{0em}
\def\@titlebmargin{4.5em}
\def\@bigslogomargin{5em}
\def\@bigslogowidth{0.2\textwidth}
\def\@unilogomargin{1em}
\def\@unilogowidth{0.2\textwidth}
\def\@titletoauthorskip{3em}
\def\@authortoadvisorskip{1em}
\def\@columnsepwidth{2em}
\def\@titlefontsize{\fontsize{0.03\textwidth}{0.032\textwidth}\selectfont}
\def\@authoradvisorfontsize{\fontsize{0.021\textwidth}{0.024\textwidth}\selectfont}

\DeclareOption{fixed}{
  % Redefine as fixed
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
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{geometry}}

\ProcessOptions

\definecolor{BigsYellow}{rgb}{\@bigsyellow}

% TITLE ------------------------------------------------

% Undefined macros we are not using
\let\date\undefined
\let\and\undefined
\let\thanks\undefined
\let\@date\undefined
\let\@thanks\undefined

\def\@advisor{\ClassWarning{bigsposter}{No \noexpand\advisor given}}
\def\advisor#1{\gdef\@advisor{#1}}
\def\@institute{\ClassWarning{bigsposter}{No \noexpand\institute given}}
\def\institute#1{\gdef\@institute{#1}}
\def\@posteryear{\ClassWarning{bigsposter}{No \noexpand\posteryear given}}
\def\posteryear#1{\gdef\@posteryear{#1}}
\def\@email{\ClassWarning{bigsposter}{No \noexpand\email given}}
\def\email#1{\gdef\@email{#1}}

\renewcommand\maketitle{\par
  \begingroup
    \global\@topnum\z@   % Prevents figures from going at top of page.
    \@maketitle
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@author\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
}

\def\@maketitle{%
  \null\vspace{\@titletmargin}\hspace{\@titlelmargin}%
  % Use raisebox to anchor logo + title to the top
  \raisebox{-\height}{% Group logo and title to vertically center them
    \makebox{% Center vertically by raising of half height
      \raisebox{-0.5\height}{\includegraphics[width=\@bigslogowidth]{bigs-logo.pdf}}%
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
  \raisebox{-\height}{\includegraphics[width=\@unilogowidth]{uni-logo.pdf}}%
  \par\vspace{\@titlebmargin}%
}

% BLOCKS -----------------------------------------------

\setlength{\columnsep}{\@columnsepwidth}

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

\newcommand{\blockbreak}{\par\stepcounter{block}\columnbreak\mbox{}}

\newcommand{\blockfoot}{
  \vfill\bigskip%
  \hrule%
  \medskip
  \@posteryear~\@institute\\
  \href{mailto:\@email}{\texttt{\@email}}
}

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

\newenvironment{blockfigure}{\vspace{-0.5\baselineskip}\begin{center}}{\end{center}\vspace{-0.5\baselineskip}}

\newcommand{\blockcaption}[2][0.8\blockwidth]{\par\centering{\parbox{#1}{\captionof{figure}{#2}}}}


\newcommand*\@pushedfootnotes{\relax}

\newcommand*{\blockfootnotetext}[1]{\g@addto@macro\@pushedfootnotes{\stepcounter{blockfootnotetext}\footnotetext[\value{blockfootnotetext}]{#1}}}

\newcommand*{\blockfootnote}[1]{\blockfootnotemark\blockfootnotetext{#1}}

\newcommand*{\blockfootnotemark}{\protect\stepcounter{blockfootnote}\protect\footnotemark[\value{blockfootnote}]}

\AtEndDocument{\@pushedfootnotes}

\makeatother

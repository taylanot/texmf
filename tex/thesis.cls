\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis}[2013/06/22 v1.0 TU Delft thesis class]

\newif\if@dutch
\newif\if@english
\newif\if@print
\newif\if@roman
\@romantrue
%\newif\if@whitetitle
% \newif\if@whitelogo
\DeclareOption{dutch}{\@dutchtrue\@englishfalse}
\DeclareOption{roman}{\@romantrue}
\DeclareOption{noroman}{\@romanfalse}
\DeclareOption{english}{\@dutchfalse\@englishtrue}
\DeclareOption{print}{\@printtrue}
%\DeclareOption{whitetitle}{\@whitetitletrue}
% \DeclareOption{whitelogo}{\@whitelogotrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ExecuteOptions{english}
\ProcessOptions\relax

\LoadClass[10pt]{book}

\RequirePackage{amsmath}
\RequirePackage{amssymb}
%% English is the default language, but this can be changed to Dutch by
%% specifying the 'dutch' option to the document class.
\if@dutch
    \RequirePackage[dutch]{babel}
\else
    %% Even for English reports, some sections might be in Dutch, for example on
    %% the title page.
    \RequirePackage[dutch,english]{babel}
\fi

\RequirePackage[nooneline,footnotesize,center]{caption}
\RequirePackage{fancyhdr}
\RequirePackage[flushmargin,hang]{footmisc}
\RequirePackage{ifpdf}
\RequirePackage{ifxetex}
\RequirePackage{mathpazo}
\RequirePackage{palatino}
\RequirePackage[pdftex]{geometry}
\RequirePackage[pdftex]{graphicx}
\RequirePackage[pdftex]{hyperref}
\RequirePackage{metalogo}
\RequirePackage[numbers,sort&compress]{natbib}
\RequirePackage{tikz}
\RequirePackage[noindentafter]{titlesec}
\RequirePackage{titletoc}
\RequirePackage[nottoc]{tocbibind}
\RequirePackage{xcolor}
\RequirePackage{xkeyval}
\RequirePackage[export]{adjustbox}
\def\@largetitlesize{24pt}


%% Define the TU Delft house style colors.
\definecolor{cyan}{cmyk}{1,0,0,0}
\definecolor{black}{cmyk}{0,0,0,1}
\definecolor{white}{cmyk}{0,0,0,0}
\definecolor{sea-green}{cmyk}{0.54,0,0.32,0}
\definecolor{green}{cmyk}{1,0.15,0.4,0}
\definecolor{dark-blue}{cmyk}{1,0.66,0,0.4}
\definecolor{purple}{cmyk}{0.98,1,0,0.35}
\definecolor{turquoise}{cmyk}{0.82,0,0.21,0.08}
\definecolor{sky-blue}{cmyk}{0.45,0,0.06,0.06}
\definecolor{lavendel}{cmyk}{0.45,0.2,0,0.07}
\definecolor{orange}{cmyk}{0.02,0.56,0.84,0}
\definecolor{warm-purple}{cmyk}{0.58,1,0,0.02}
\definecolor{fuchsia}{cmyk}{0.19,1,0,0.19}
\definecolor{bright-green}{cmyk}{0.36,0,1,0}
\definecolor{yellow}{cmyk}{0.02,0,0.54,0}

%% Use TU Delft cyan as the color for titles, unless the 'print' option is
%% specified. % JMT changed this: all titles black!
% \if@print
    \colorlet{title}{black}
%\else
%    \colorlet{title}{cyan}
%\fi

%% We use A4 paper with slightly smaller margins than the default (scale = 0.7).
\geometry{a4paper,hscale=0.75,vscale=0.8}

%% Redefine the author command to add the name to the PDF meta data.
\renewcommand*\author[2][white]{%
    \def\@authorcolor{#1}%
    \def\@author{#2}%
    \hypersetup{pdfauthor=#2}%
}

%% The affiliation is shown in the blue box on the front cover.
\newcommand*\affiliation[2][white]{\def\@afilcolor{#1}%
                                           \def\@affiliation{#2}}

%% Remove the header and page number on empty pages.
\def\cleardoublepage{%
    \clearpage%
    \if@twoside%
        \ifodd\c@page%
        \else%
            \thispagestyle{empty}%
            \vspace*{\fill}%
            \newpage%
        \fi%
    \fi%
}

%% Fancy style for the main matter.
\fancypagestyle{mainmatter}{%
    \fancyhf{}
    %% Page numbers on the top left and top right.
    \fancyhead[LE,RO]{\thepage}
    %% Chapter name on the left (even) page.
    \fancyhead[RE]{\nouppercase{\leftmark}}
    %% Section name on the right (odd) page.
    \fancyhead[LO]{\nouppercase{\rightmark}}
}

%% The mainmatter style is default for normal pages.
\pagestyle{mainmatter}

%% Print the current chapter and section at the top of the page in cyan.
\renewcommand*\chaptermark[1]{\markboth{\thechapter.\ \color{black}#1}{}}
\renewcommand*\sectionmark[1]{\markright{\thesection.\ \color{black}#1}}
\newcommand*\setheader[1]{\markboth{\color{title}#1}{\color{black}#1}}

%% Change the headrule command (from fancyhdr.sty) to draw the line below the
%% header in the title color.
\renewcommand*\headrule{%
    \if@fancyplain%
        \let\headrulewidth\plainheadrulewidth%
    \fi%
    {\color{title}\hrule\@height\headrulewidth\@width\headwidth}%
    \vskip-\headrulewidth%
}

%% Draw the line above a footnote in the title color as well.
\renewcommand*\footnoterule{%
    \vspace*{-3pt}%
    {\color{title}\hrule width 0.5\textwidth height 0.4pt}%
    \vspace*{2.6pt}%
}

%% A part title starts with a huge (96pt) bold black number, flushed to the
%% right, followed by the part name on the next line in the title color.
\titleformat{\part}[display]
    {\flushright}
    {\fontsize{\@largetitlesize}{\@largetitlesize}\bfseries\thepart}
    {0pt}
    {\Huge\color{title}}
%% Separate the title from the text by two empty lines.
\titlespacing{\part}{0pt}{0pt}{2\baselineskip}
%% In the table of contents, the part name is preceded by an empty line, printed
%% in bold, and not followed by a line of dots.
\dottedcontents{part}[0em]{\vspace{\baselineskip}\titlefont\bfseries}{1.5em}{0pc}

%% Chapter titles have the same layout as parts.
\newcommand{\hsp}{\hspace{25pt}}
\titleformat{\chapter}[hang]{\Huge\bfseries}{\thechapter\hsp{|}\hsp}{0pt}{\Huge\bfseries}




%% In the table of contents, a chapter is similar to a part, except that it is
%% preceded by half an empty line.
\dottedcontents{chapter}[1.5em]{\vspace{0.5\baselineskip}\bfseries}{1.5em}{0pc}

%% Subsubsections have the same font and color as sections and subsections, but
%% are not preceded by a number.
\titleformat{\subsubsection}
    {\bfseries}
    {}
    {0pt}
    {\color{title}}
%% Subsubsections are preceded by an empty line and do not appear in the table
%% of contents.
\titlespacing{\subsubsection}{0pt}{\bigskipamount}{0pt}
\dottedcontents{subsection}[7em]{\titlefont}{3.2em}{8pt}
%% Color the bullets of the itemize environment and make the symbol of the third
%% level a diamond instead of an asterisk.
\renewcommand*\labelitemi{\color{title}\textbullet}
\renewcommand*\labelitemii{\color{title}--}
\renewcommand*\labelitemiii{\color{title}$\diamond$}
\renewcommand*\labelitemiv{\color{title}\textperiodcentered}

%% Use a custom bibliography style based on apsrev4-1.

%% Hyperlinks are cyan, except in print mode, when they are all black.
\hypersetup{
    colorlinks=true,
    citecolor=title,
    linkcolor=title,
    urlcolor=title
}

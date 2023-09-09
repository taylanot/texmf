% PACKAGE INFO

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{my_cv}[2011/03/26 My custom CV class]

% LOAD BASE CLASS

\LoadClass[11pt]{article}

% Call to Required Packages

\RequirePackage{titlesec}
\RequirePackage{geometry}
\RequirePackage{hyperref}
\RequirePackage{varwidth}
\RequirePackage{fontawesome}
\RequirePackage{mathpazo}
\RequirePackage{fancyhdr}
\RequirePackage{hyperref}


% Settings 
\geometry{a4paper,total={170mm,257mm},left=20mm,top=20mm}
\hypersetup{colorlinks=true,linkcolor=blue,urlcolor=blue}
\renewcommand{\baselinestretch}{1.0}
\pagestyle{fancy}
\fancyhf{}
% Update
\newcommand{\update}	[0]{\centerline{\textsc{Last Update:}\large{\today}}}
% PERSONAL INFORMATION
\newcommand{\name}		[1]{\centerline{\textbf{\scshape\Large{#1}}}}
\newcommand{\address}	[1]{\faMapMarker \quad {{#1}}}
\newcommand{\phone}		[1]{\faMobilePhone \quad {{#1}}}
\newcommand{\linkdin}	[1]{\faLinkedinSquare \quad \href{#1}{#1}}
\newcommand{\mail}		[1]{\faEnvelope \quad \href{mailto:#1}{#1}}
\newcommand{\github}	[1]{\faGithub \quad \href{https:// #1}{#1}}
% Formatting Titles

\titleformat{\section}{\bfseries\Large\scshape\raggedright}{}{0em}{}[\titlerule]
\titleformat{\subsection}{\bfseries\large\scshape\raggedright}{}{0em}{}
\titleformat{\subsubsection}{\scshape\raggedright}{}{0em}{}

% Date Addition

\newcommand{\datedsection}		[2]{\section[#1]{#1 \hfill #2}}
\newcommand{\datedsubsection}	[2]{\subsection[#1]{#1 \hfill #2}}
\newcommand{\datedsubsubsection}	[2]{\subsubsection[#1]{#1 \hfill #2}}



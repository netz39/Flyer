% Font licenses:
% OpenSans published under Apache License Version 2.0, for more details see \ressources\fonts\open-sans\Apache License.txt or https://www.apache.org/licenses/LICENSE-2.0
% PoliticsHead by Fred Bordfeld published under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License, for more details see \ressources\fonts\PoliticsHead\CC_by_nc_nd Licence.txt or https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode

% compile with XeLaTex --recorder

\LoadClass{article}
\NeedsTeXFormat{LaTeX2e}
\RequirePackage{currfile}
\RequirePackage{titlesec}
\RequirePackage{multicol}
\RequirePackage{graphicx}
%\RequirePackage{parskip}
\RequirePackage{fontspec}
\RequirePackage{enumitem}
\RequirePackage{calc}
\RequirePackage[absolute]{textpos}
\RequirePackage[german]{babel}
\ProvidesClass{netz39}[2019/04/16 v1.0 Netz39 e.V.]
\setlist{nosep}

\newif\if@flyer
\DeclareOption{flyer}{
	\@flyertrue
	\def\columncount{3}
}

\newif\if@poster
\DeclareOption{poster}{
	\@postertrue
	\def\columncount{4}
}
\ProcessOptions

\newenvironment{headlinefont}{\PoliticsHead\selectfont}{\par}

\if@flyer
\usepackage[a4paper, margin=1in, landscape, left=1cm, right=1cm, top=1cm, bottom=1cm]{geometry}
\newenvironment{wholeColumn}[1][t]{\begin{minipage}[#1][\textheight]{\linewidth}}{\end{minipage}}
\newcommand{\emptycol}{\begin{minipage}[c][\textheight]{\textwidth}\end{minipage}}
\newenvironment{contact}{
	\begin{textblock*}{\linewidth}(\oddsidemargin+1in,0cm)
		\begin{wholeColumn}[c]}{\end{wholeColumn}
	\end{textblock*}
	\emptycol
}
\newenvironment{about}{
	\begin{textblock*}{\linewidth}(\oddsidemargin+1in+\linewidth+\columnsep,0cm)
		\begin{wholeColumn}[c]}{\end{wholeColumn}
	\end{textblock*}
	\emptycol
}
\renewcommand{\title}[2]{
	\begin{textblock*}{\linewidth}(\oddsidemargin+1in+2\linewidth+2\columnsep,0cm)
		\begin{wholeColumn}[c]
			\begin{center}
				\includegraphics[width=\titlewidth]{../resources/logo/Netz39_logo_text_unten}
				\vspace{0.5cm}\\
				\begin{headlinefont}
					\resizebox{\titlewidth}{!}{#1}\\
					\resizebox{\titlewidth}{!}{#2}
				\end{headlinefont}
			\end{center}
		\end{wholeColumn}
	\end{textblock*}
	\emptycol
}

\fi

\if@poster
\usepackage[a3paper, margin=1in, landscape, left=2cm, right=2cm, top=1cm, bottom=2cm]{geometry}

\newcommand{\emptycol}{
	\begin{minipage}[c][\textheight]{\textwidth}
	\end{minipage}
}
\newenvironment{about}{}{\vfill}
\newenvironment{contact}{}{\null\columnbreak}
\renewcommand{\title}[2]{
	\end{multicols}
		\begin{minipage}[c][5cm]{0.23\linewidth}
			\includegraphics[width=\linewidth]{../resources/logo/Netz39_logo_text_rechts}
		\end{minipage}
		\begin{minipage}[t][5cm]{0.77\linewidth}
		\PoliticsHead\selectfont%
			\raggedleft%
				\resizebox{!}{1.5cm}{#1}\\
				\resizebox{!}{1cm}{#2}
		\end{minipage}
	\begin{multicols}{\columncount}
}

\fi

% fonts
\setmainfont[
Path          = ../resources/fonts/open-sans/,
UprightFont   = OpenSans-Regular.ttf,
BoldItalicFont= OpenSans-BoldItalic.ttf,
BoldFont      = OpenSans-Bold.ttf
]{OpenSans}

\newfontfamily\PoliticsHead[
Path          = ../resources/fonts/PoliticsHead/,
UprightFont   = PoliticsHeadv1_9.ttf,
BoldItalicFont= PoliticsHeadv1_9.ttf,
BoldFont      = PoliticsHeadv1_9.ttf
]{PoliticsHead}

% misc
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.2cm}
\newcommand{\@minipagerestore}{\setlength{\parskip}{0.2cm}}
\pagenumbering{gobble}
\renewcommand\section{\@startsection{section}{1}{\z@}%
	{-5.5ex \@plus -2ex \@minus -4ex}%
	{0.5ex \@plus.2ex}%
	{\LARGE\PoliticsHead}*%
}

% width of netz39 logo and title text
\def\titlewidth{0.8\textwidth}

% custom commands

\newenvironment{events}[1]{%
	\newcommand\event{\bfseries\item}%
	%\vspace{0.1cm}
	
	\textbf{#1}
	\begin{itemize}[label={},leftmargin=0cm,noitemsep, topsep=-5pt]}{
	\end{itemize}\vspace{0.5cm}
}

\newenvironment{entry}[1]{\begin{minipage}[t]{\linewidth}\section{#1}}{\end{minipage}}

\AtBeginDocument{
	\if@flyer
		\setlength\columnsep{2cm}
	\fi
	\if@poster
		\setlength\columnsep{1cm}
	\fi
	\begin{multicols*}{\columncount}
	\raggedcolumns
	\interlinepenalty=10000
	
}
\AtEndDocument{
	\end{multicols*}
}
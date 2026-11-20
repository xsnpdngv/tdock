# Dockerized Tech Documentation Compiler

**Tdock** is an isolated environment for compiling Markdown into
professional technical documentation PDFs via XeLaTeX. It natively
supports **PlantUML**, **Mermaid**, **WebSequence**, and **Graphviz**
(DOT) diagram rendering, syntax highlighting, and common professional
fonts.


## 1. Setup & Building

You only need Docker installed. To build the local image:

```bash
git clone https://github.com/xsnpdngv/tdock
cd tdock
make build
```

Optionally, you can install the `tdock` script globally for easier access...

```bash
# by copying the script to your local bin for easy access:
cp tdock /usr/local/bin/tdock

# or creating an alias in your shell config:
echo "alias tdock='/path/to/tdock/tdock'" >> ~/.bashrc
source ~/.bashrc

# or creating a symlink to it:
ln -s /path/to/tdock/tdock ~/bin/tdock
```


## 2. Using the Control Script

The `tdock` script acts as a seamless wrapper. It mounts your current
directory into the container, and processes the given file(s) Files are
generated with proper host permissions (no root ownership issues).


### The Quick Test

Compile the provided example.md file into a PDF:

```bash
./tdock example.md
```

See the prepared [example.pdf](example.pdf) for the output. It includes
syntax-highlighted code blocks and rendered diagrams, demonstrating the
capabilities of the tool.


### Handling Diagrams (SVGs vs PDFs)

For markdown files code-blocks render as `.pdf` vector files so
XeLaTeX can embed them perfectly.

If you want to compile standalone diagrams for web use (SVG):

```bash
./tdock seq-diag.puml         # PlantUML diagrams
./tdock webseq-diag.wsd       # WebSequence diagrams (processed via PlantUML)
./tdock mermaid-diag.mmd      # Mermaid diagrams
./tdock graphviz.dot          # Graphviz (DOT) diagrams
```

**Note:** WebSequence Diagram (`.wsd`) files are automatically wrapped
with PlantUML `@startuml`/`@enduml` tags and rendered through PlantUML.


### Workflow Macros

* Watch Mode (recompiles on save): `./tdock --watch doc.md`
* Change code highlight theme: `./tdock doc.md --syntax-highlighting=zenburn`

[pandoc-manual]: https://pandoc.org/MANUAL.html
[pandoc-options]: https://pandoc.org/MANUAL.html#options
[pandoc-opt-V]: https://pandoc.org/MANUAL.html#option--variable
[pandoc-opt-M]: https://pandoc.org/MANUAL.html#option--metadata
[pandoc-latex-vars]: https://pandoc.org/MANUAL.html#variables-for-latex
[pandoc-layout]: https://pandoc.org/MANUAL.html#layout
[pandoc-fonts]: https://pandoc.org/MANUAL.html#fonts
[pandoc-links]: https://pandoc.org/MANUAL.html#links
[pandoc-front-matter]: https://pandoc.org/MANUAL.html#front-matter
[pandoc-yaml]: https://pandoc.org/MANUAL.html#extension-yaml_metadata_block
[pandoc-md]: https://pandoc.org/MANUAL.html#pandocs-markdown
[pandoc-citations]: https://pandoc.org/MANUAL.html#citations
[pandoc-demos]: https://pandoc.org/demos.html


## 3. Writing Documents

A tdock document is a plain [Pandoc Markdown][pandoc-md] file. It
starts with a **YAML front matter** block, which tells pandoc (and
XeLaTeX behind it) how to lay out the PDF. The Markdown body follows it:

```markdown
---
title: My Design Document
author: Jane Doe
date: \today
toc: true
numbersections: true
---

# Introduction

Regular *Markdown* goes here, including fenced `plantuml`,
`mermaid` and `dot` code blocks for diagrams.
```

The front matter must be the very first thing in the file, delimited by
`---` lines. Values are YAML: quote strings that contain `:` or start
with special characters, and use `true`/`false` for switches. Raw LaTeX
(e.g. `\today`) is passed through as-is.


### How settings reach pandoc

Settings can come from three places. Later ones override earlier ones,
key by key:

1. **tdock defaults** in the `tdock` script (`DEFAULT_METADATA`, e.g.
   `monofont: "Ubuntu Mono"`).
2. **The document's YAML front matter.**
3. **Command-line options** passed after the file name, which tdock
   forwards to pandoc unchanged:

   ```bash
   ./tdock doc.md -V fontsize=12pt -M title="Draft" --toc
   ```

Any front matter key can also be given on the command line as
`-V key=value` ([template variable][pandoc-opt-V]) or `-M key=value`
([metadata][pandoc-opt-M]). For example, `--toc` and `--number-sections`
are equivalent to `toc: true` and `numbersections: true`.

`header-includes` is the exception: tdock's own LaTeX preamble
(`DEFAULT_HEADER_INCLUDES`: `hyperref`, `cleveref`, `float` with figures
pinned in place) is always **merged** with the document's
`header-includes`, not replaced by it. Passing `-H`/`-V header-includes`
on the command line replaces both, as it does in plain pandoc.


### Front Matter Quick Reference

The most useful keys for PDF output via XeLaTeX. The full list is in the
pandoc manual under [Variables for LaTeX][pandoc-latex-vars].

| Key | Example | Effect |
|:----|:--------|:-------|
| **Title block** | | |
| `title`, `subtitle` | `title: System Design` | Document title (and subtitle) |
| `author` | `author: [Jane Doe, John Roe]` | One author or a list of authors |
| `date` | `date: \today` or `date: 2026-01-31` | Date shown under the title |
| `abstract` | `abstract: Short summary...` | Abstract after the title block |
| `lang` | `lang: en-GB` | Language (hyphenation, "Contents" label, etc.) |
| `keywords`, `subject` | `keywords: [5G, charging]` | PDF metadata |
| **Page layout** | | |
| `documentclass` | `article`, `report`, `book`, `scrartcl`, `scrreprt` | LaTeX class (`report`/`book` give chapters and a title page) |
| `classoption` | `[twoside, landscape]` | Options for the document class |
| `papersize` | `a4`, `letter` | Paper size |
| `geometry` | `margin=2cm` or `[top=2cm, left=3cm]` | Margins via the `geometry` package |
| `fontsize` | `10pt`, `11pt`, `12pt` | Base font size |
| `linestretch` | `1.25` | Line spacing |
| `indent` | `true` | Indent paragraphs instead of spacing them |
| `pagestyle` | `plain`, `empty`, `headings` | Header/footer style |
| **Structure** | | |
| `toc` | `true` | Table of contents |
| `toc-depth` | `2` | Heading levels shown in the TOC |
| `toc-title` | `Contents` | TOC heading |
| `numbersections` | `true` | Number the headings |
| `secnumdepth` | `2` | Heading levels to number |
| `lof`, `lot` | `true` | List of figures / list of tables |
| **Fonts** (see [fonts/README.md](fonts/README.md)) | | |
| `mainfont` | `"DejaVu Serif"` | Body text font |
| `sansfont` | `"Open Sans"` | Sans-serif font |
| `monofont` | `"Fira Code"` | Code font (tdock default: `Ubuntu Mono`) |
| `mathfont` | `"Latin Modern Math"` | Math font |
| `CJKmainfont` | `"Noto Sans CJK SC"` | Font for Chinese/Japanese/Korean text |
| **Links** | | |
| `colorlinks` | `true` | Colored links instead of boxed ones |
| `linkcolor`, `urlcolor`, `toccolor`, `citecolor` | `blue`, `NavyBlue` | Colors of internal links, URLs, TOC entries and citations |
| **Raw LaTeX** | | |
| `header-includes` | see examples below | Extra LaTeX preamble (packages, macros) |
| `include-before`, `include-after` | `\newpage` | LaTeX at the start/end of the body |
| **Citations** (needs `--citeproc`) | | |
| `bibliography` | `refs.bib` | Bibliography file |
| `csl` | `ieee.csl` | Citation style |
| `link-citations` | `true` | Make citations link to the bibliography |

Run `./tdock -c fc-list : family` to see the font names available in
the image.

Some pandoc options exist only on the command line, not in the front
matter. Pass them after the file name:

| Option | Effect |
|:-------|:-------|
| `--toc`, `--number-sections` | Same as `toc: true`, `numbersections: true` |
| `--syntax-highlighting=zenburn` | Code highlighting theme (`pygments`, `kate`, `monochrome`, `breezedark`, `espresso`, `haddock`, `tango`, `zenburn`) |
| `--top-level-division=chapter` | Treat `#` headings as chapters (automatic for `report`/`book`, needed e.g. for `scrreprt`/`scrbook`) |
| `--citeproc` | Process citations against `bibliography` |
| `--metadata-file=meta.yaml` | Read front matter from a separate, shared YAML file |
| `-H preamble.tex` | Add a LaTeX file to the preamble (replaces `header-includes`, including tdock's defaults) |
| `-o other.pdf` | Output file name (default: input name with `.pdf`) |

For everything else, see the pandoc documentation:

* [Pandoc User's Guide][pandoc-manual] (the full manual)
* [Options][pandoc-options] (everything you can pass after the file name)
* [Variables for LaTeX][pandoc-latex-vars] (front matter keys for PDF
  output: [layout][pandoc-layout], [fonts][pandoc-fonts],
  [links][pandoc-links], [front matter][pandoc-front-matter])
* [YAML metadata blocks][pandoc-yaml] (front matter syntax)
* [Pandoc's Markdown][pandoc-md] (tables, footnotes, cross-references,
  math, etc.)
* [Citations][pandoc-citations]
* [Demos][pandoc-demos]


### Examples

**Short memo**: compact, no title page, no section numbers:

```yaml
---
title: Release 4.2 Notes
author: Platform Team
date: \today
papersize: a4
geometry: margin=2cm
fontsize: 11pt
colorlinks: true
---
```

**Technical specification**: numbered sections, TOC, lists of figures
and tables, custom fonts:

```yaml
---
title: Charging Gateway
subtitle: Interface Specification
author:
  - Jane Doe
  - John Roe
date: 2026-01-31
lang: en-GB
papersize: a4
documentclass: article
geometry: margin=1in
numbersections: true
secnumdepth: 3
toc: true
toc-depth: 2
lof: true
lot: true
mainfont: DejaVu Serif
sansfont: DejaVu Sans
monofont: JetBrains Mono
colorlinks: true
linkcolor: blue
urlcolor: blue
---
```

**Report with chapters, a title page, and headers/footers**. With
`documentclass: report` (or `book`), pandoc makes each `#` heading a
chapter automatically:

```yaml
---
title: Architecture Handbook
author: Jane Doe
date: \today
documentclass: report
classoption: [11pt, twoside]
papersize: a4
geometry: [top=25mm, bottom=25mm, inner=30mm, outer=20mm]
toc: true
numbersections: true
abstract: |
  This handbook describes the overall architecture,
  its components and their interfaces.
header-includes: |
  \usepackage{fancyhdr}
  \pagestyle{fancy}
  \fancyhead{}
  \fancyhead[LE,RO]{\leftmark}
  \fancyfoot{}
  \fancyfoot[C]{\thepage}
  \renewcommand{\headrulewidth}{0.4pt}
---
```

**Landscape document with small code** (for wide tables or long
log excerpts):

```yaml
---
title: Interface Matrix
classoption: landscape
geometry: margin=1.5cm
fontsize: 10pt
header-includes: |
  \usepackage{fvextra}
  \fvset{fontsize=\footnotesize, breaklines=true}
---
```

**Citations**: put the references in `refs.bib` next to the document,
cite them with `[@key]` in the text, and enable `--citeproc`:

```yaml
---
title: Literature Review
bibliography: refs.bib
link-citations: true
---
```

```bash
./tdock review.md --citeproc
```

**Shared settings for many documents**: keep the common keys in a
single file, and put only the per-document keys (`title`, `author`,
...) in each document's front matter:

```bash
./tdock doc.md --metadata-file=company-style.yaml
```

See [example.md](example.md) for a complete document using front matter,
tables, math, code, and diagrams.


## 4. Custom Fonts

The Docker image supports custom fonts by placing them in the `fonts/`
directory.  Fonts are automatically copied into the container during the
build and made available to XeLaTeX and other tools.

For detailed instructions on adding fonts, font sources, and usage
examples, see [fonts/README.md](fonts/README.md).

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
* Change code highlight theme: `./tdock doc.md --highlight-style=zenburn`


## 3. Custom Fonts

The Docker image supports custom fonts by placing them in the `fonts/`
directory.  Fonts are automatically copied into the container during the
build and made available to XeLaTeX and other tools.

For detailed instructions on adding fonts, font sources, and usage
examples, see [fonts/README.md](fonts/README.md).

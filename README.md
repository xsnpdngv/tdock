# Dockerized Tech Documentation Compiler

**Tdock** is an isolated environment for compiling Markdown into
professional PDFs via XeLaTeX. It natively supports **PlantUML**,
**Mermaid**, and **Graphviz** (DOT) diagram rendering, syntax
highlighting, and common Google/Ubuntu fonts.


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
./tdock seq-diag.puml
./tdock webseq-diag.wsd
./tdock mermaid-diag.mmd
./tdock graphviz.dot
```


### Workflow Macros

* Watch Mode (recompiles on save): `./tdock --watch doc.md`
* Change code highlight theme: `./tdock doc.md --highlight-style=zenburn`

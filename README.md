# Dockerized Tech Documentation Compiler

**Tdock** is an isolated environment for compiling Markdown into
professional PDFs via XeLaTeX. It natively supports **PlantUML**,
**Mermaid**, and **Graphviz** (DOT) diagram rendering, syntax
highlighting, and common Google/Ubuntu fonts.


## 1. Setup & Building

You only need Docker installed. To build the local image:

```bash
make build
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


### Handling Diagrams (SVGs vs PDFs)

For markdown files code-blocks render as `.pdf` vector files so
XeLaTeX can embed them perfectly.

If you want to compile standalone diagrams for web use (SVG):

```bash
./tdock seq-diag.puml
./tdock mermaid-diag.mmd
./tdock graphviz.dot
```


### Workflow Macros

* Watch Mode (recompiles on save): `./tdock --watch doc.md`
* Change code highlight theme: `./tdock doc.md --highlight-style=zenburn`

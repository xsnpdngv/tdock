# Pandock: Dockerized Docs-as-Code

Pandock is an isolated environment for compiling Markdown into
professional PDFs via XeLaTeX. It natively supports PlantUML, Mermaid,
and Graphviz (DOT) diagram rendering, syntax highlighting, and common
Google/Ubuntu fonts.

## 1. Setup & Building

You only need Docker installed. To build the local image:

```bash
make build
```

## 2. Using the Control Script

The `pandock` script acts as a seamless wrapper. It mounts your current
directory into the container, processes the markdown, and handles
diagram artifacts. Files are generated with proper host permissions (no
root ownership issues).

### The Quick Test

Compile the provided example.md fileinto a PDF:

```bash
./pandock example.md
```

### Handling Diagrams (SVGs vs PDFs)

By default, code-blocks render as temporary `.pdf` vector files so
XeLaTeX can embed them perfectly. The wrapper cleans these up
automatically. 

If you want to extract the diagrams for web use:
* `./pandock --keep-svg mydoc.md`: Generates the PDF and drops `.svg` diagram files.
* `./pandock --svg-only mydoc.md`: Skips PDF generation and only drops `.svg` files.

### Workflow Macros

* Watch Mode (recompiles on save): `./pandock --watch doc.md`
* Cleanup temporary LaTeX files: `./pandock --clean doc.md`
* Change code highlight theme: `./pandock doc.md --highlight-style=zenburn`

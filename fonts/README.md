# Custom Fonts

This directory contains font files that are included in the tdock Docker image.
The fonts are copied to `/usr/share/fonts/extra-fonts/` during the image build.

**Note:** This directory is not tracked in git (see `.gitignore`). You need to add your own fonts here.

## Adding Fonts

To include fonts in the tdock image:

1. Create a subdirectory with the font family name:
   ```bash
   mkdir -p fonts/roboto
   mkdir -p fonts/source-code-pro
   ```

2. Add font files (`.ttf` or `.otf`) to the subdirectories:
   ```bash
   # Example: Download and extract fonts
   cd fonts/roboto
   wget https://github.com/google/roboto/releases/download/v3.0/Roboto-hinted.zip
   unzip Roboto-hinted.zip
   ```

3. Rebuild the Docker image:
   ```bash
   make build
   ```

## Example: Popular Fonts

Here are some fonts commonly used with tdock:

### Roboto (Sans-serif)
- **Source:** [Google Fonts](https://fonts.google.com/specimen/Roboto)
- **Download:** https://github.com/google/roboto/releases

### Source Code Pro (Monospace)
- **Source:** [Adobe Fonts](https://github.com/adobe-fonts/source-code-pro)
- **Download:** https://github.com/adobe-fonts/source-code-pro/releases

### Ubuntu Fonts
- **Source:** [Canonical/Ubuntu](https://design.ubuntu.com/font/)
- **Download:** [Ubuntu Font Family](https://fonts.ubuntu.com/)

### Linux Libertine (Serif)
- **Source:** [Libertine Project](https://libertine-fonts.org/)
- **Download:** https://libertine-fonts.org/

## Font Licensing

When adding fonts to your local repository:
- Respect each font's license
- Include license files with the fonts (e.g., `LICENSE.txt`, `OFL.txt`, `UFL.txt`)
- Do not commit fonts with restrictive licenses to shared repositories

## Using Fonts in LaTeX

Once fonts are added and the image is rebuilt, reference them by family name in XeLaTeX:

```latex
\setmainfont{Roboto}
\setmonofont{Source Code Pro}
```

Or in Pandoc metadata:

```yaml
mainfont: Roboto
monofont: Source Code Pro
```
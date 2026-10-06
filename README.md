![banner]()

# Automated Reasoning and Formal Verification

Source for the _Automated Reasoning & Formal Verification_ (ARFV) notes, written in
[Typst](https://typst.app/docs/) and based on
[Prof. Sebastiani's course](https://disi.unitn.it/rseba/DIDATTICA/arfv2026/SLIDES/)
and lectures held at the University of Trento in 2027.

## Download PDFs and identify versions

The [GitHub _Releases_ page](https://github.com/zenosaltt/arfv/releases) stores
the latest PDF of the lecture notes, along with older versions. On that page,
find the asset list and download the `.pdf` file.

Each PDF release shows its version tag (`vx.y.z`) on the cover. The first white
page shows the date when the PDF was built.

> Note: releases are less frequent than commits, so a PDF release may not
> include the latest updates.

## Build the PDF on your own

Since releases are less frequent than commits, you may want to build the PDF
yourself. On Linux, macOS, or WSL for Windows, install:

- _Git_ to clone this repository and maintain a local copy.
- _Make_ to run the project commands.
- _Docker_ to run the tools without installing them individually.

Then clone the repository and, from its root, run:

```sh
make build
```

The result is `build/ARFV-Notes_ddmmyy.pdf`, using the build date in the file
name (for example, `ARFV-Notes_041026.pdf` for 4 October 2026). The first run
builds a Docker image with the required tools. The [Makefile](Makefile) shows
the commands it runs. Other useful commands:

- `make watch`: rebuild the PDF after each save.
- `make clean`: remove generated PDFs from `build/`.

Without a release tag, the cover shows `DRAFT` and the build date. To edit the
notes or open a pull request, see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

© 2026 Zeno Saletti. The original text, illustrations, and cover photograph
(`src/assets/images/broadperspective.jpg`) are by Zeno Saletti and licensed,
along with their Typst sources and generated PDF, under
[Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).
See [LICENSE](LICENSE) for the legal text.

<div align="center">
  <a target="_blank" href="https://creativecommons.org/licenses/by-sa/4.0/" style="background:none">
    <img src="https://mirrors.creativecommons.org/presskit/buttons/88x31/svg/by-sa.svg" alt="https://creativecommons.org/licenses/by-sa/4.0/">
  </a>
</div>

Third-party course materials and other third-party content are not covered by
the CC BY-SA license unless explicitly stated otherwise.

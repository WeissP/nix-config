#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.plotly

import sys
import argparse
from pathlib import Path
import plotly.io as pio


def main(argv: list[str] | None = None) -> int:
    if argv is None:
        argv = sys.argv[1:]

    # Parse CLI args with argparse
    parser = argparse.ArgumentParser(
        prog="python -m hello_world",
        description="Render a Plotly figure from JSON; optionally save an image and/or HTML.",
    )
    parser.add_argument(
        "target",
        help="Path to figure JSON file, or '-' to read from stdin",
    )
    parser.add_argument(
        "--save-image",
        dest="save_image",
        metavar="OUTPUT",
        help="Path to save static image. If a directory, PNG files are written; if a file path, it is used as-is.",
    )
    parser.add_argument(
        "--save-html",
        dest="save_html",
        metavar="OUTPUT",
        help="Path to save interactive HTML. If a directory, .html files are written.",
    )
    parser.add_argument(
        "--show",
        action="store_true",
        help="Show the figure(s) after processing. If omitted, figures are not shown."
    )
    try:
        args = parser.parse_args(argv)
        show_fig: bool = args.show
    except SystemExit as e:
        # Preserve exit codes (0 for --help, 2 for parse errors) while keeping main()'s return contract
        return e.code if isinstance(e.code, int) else 2
    save_path: str | None = args.save_image
    save_html_path: str | None = args.save_html
    target: str = args.target
    if target == "-":
        json_text = sys.stdin.read()
    else:
        p = Path(target)
        if not p.is_file():
            print(f"Error: file not found: {p}", file=sys.stderr)
            return 2
        json_text = p.read_text(encoding="utf-8")

    fig = pio.from_json(json_text)

    # Save interactive HTML if requested
    if save_html_path:
        try:
            out = Path(save_html_path)
            if isinstance(fig, (list, tuple)):
                # If OUTPUT has an extension, append numeric suffixes; otherwise treat as a directory (.html files)
                if out.suffix:
                    stem = out.stem
                    suffix = out.suffix
                    parent = out.parent
                    for idx, f in enumerate(fig, start=1):
                        f.write_html(str(parent / f"{stem}_{idx}{suffix}"))
                else:
                    out.mkdir(parents=True, exist_ok=True)
                    for idx, f in enumerate(fig, start=1):
                        f.write_html(str(out / f"figure_{idx}.html"))
            else:
                fig.write_html(str(out))
        except Exception as e:
            print(f"Error: failed to save HTML: {e}", file=sys.stderr)
            return 2

    # Save static image(s) using kaleido if requested
    if save_path:
        try:
            out = Path(save_path)
            if isinstance(fig, (list, tuple)):
                # If OUTPUT has an extension, append numeric suffixes; otherwise treat as a directory (PNG files)
                if out.suffix:
                    stem = out.stem
                    suffix = out.suffix
                    parent = out.parent
                    for idx, f in enumerate(fig, start=1):
                        f.write_image(
                            str(parent / f"{stem}_{idx}{suffix}"), engine="kaleido"
                        )
                else:
                    out.mkdir(parents=True, exist_ok=True)
                    for idx, f in enumerate(fig, start=1):
                        f.write_image(str(out / f"figure_{idx}.png"), engine="kaleido")
            else:
                fig.write_image(str(out), engine="kaleido")
        except Exception as e:
            print(
                f"Error: failed to save static image(s) with kaleido: {e}",
                file=sys.stderr,
            )
            print("Hint: ensure the 'kaleido' package is installed.", file=sys.stderr)
            return 2

    if show_fig:
        if isinstance(fig, (list, tuple)):
            for f in fig:
                f.show()
        else:
            fig.show()

    return 0


main()

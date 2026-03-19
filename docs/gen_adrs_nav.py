# SPDX-FileCopyrightText: Copyright (C) 2026 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>
#
# SPDX-License-Identifier: MIT

"""
Generate the navigation for ADRs.

Taken inspiration from:
    * https://oprypin.github.io/mkdocs-literate-nav/#hybrid-nav
    * https://oprypin.github.io/mkdocs-gen-files/
"""

import tomllib
from pathlib import Path

from mkdocs.utils import meta, get_markdown_title
import mkdocs_gen_files

with Path('adrs.toml').open('rb') as f:
    adrs_config = tomllib.load(f)

adr_root = Path(adrs_config['adr_dir'])
decisions_root = Path(*adr_root.parts[1:])

adrs = []

for path in sorted(Path(adr_root).glob('*.md')):
    if path.name == 'index.md':
        continue

    markdown, metadata = meta.get_data(path.read_text())
    title = get_markdown_title(markdown)
    number = metadata['number']


    adrs.append(f'* [{number:04d} {title}]({path.relative_to(adr_root)})')


with mkdocs_gen_files.open(decisions_root / 'SUMMARY.md', 'w') as nav_file:
    print('* [index](./index.md)', file=nav_file)

    for adr in adrs:
        print(adr, file=nav_file)

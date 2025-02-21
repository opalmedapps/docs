# SPDX-FileCopyrightText: Copyright (C) 2022 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>
#
# SPDX-License-Identifier: MIT

FROM squidfunk/mkdocs-material:9.6.4

# install any additional dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

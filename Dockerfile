FROM squidfunk/mkdocs-material:9.5.25

# install any additional dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

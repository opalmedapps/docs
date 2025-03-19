FROM squidfunk/mkdocs-material:9.6.9

# install any additional dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

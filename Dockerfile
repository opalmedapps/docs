FROM squidfunk/mkdocs-material:9.0.11

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

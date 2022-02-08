FROM squidfunk/mkdocs-material:8.1.10

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

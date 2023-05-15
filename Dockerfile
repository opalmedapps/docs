FROM squidfunk/mkdocs-material:9.1.12

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

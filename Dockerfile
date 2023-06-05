FROM squidfunk/mkdocs-material:9.1.15

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

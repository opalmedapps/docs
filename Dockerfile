FROM squidfunk/mkdocs-material:9.1.1

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

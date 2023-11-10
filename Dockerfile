FROM squidfunk/mkdocs-material:9.4.8

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

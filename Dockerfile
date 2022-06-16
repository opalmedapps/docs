FROM squidfunk/mkdocs-material:8.3.6

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

FROM squidfunk/mkdocs-material:8.5.11

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

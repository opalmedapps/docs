FROM squidfunk/mkdocs-material:8.3.0

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

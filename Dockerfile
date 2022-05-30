FROM squidfunk/mkdocs-material:8.2.16

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

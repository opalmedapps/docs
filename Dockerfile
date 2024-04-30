FROM squidfunk/mkdocs-material:9.5.20

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

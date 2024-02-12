FROM squidfunk/mkdocs-material:9.5.9

# install any additional dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

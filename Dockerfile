FROM squidfunk/mkdocs-material:9.5.43

# install any additional dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3

WORKDIR /app

# jupyterlabをインストール
COPY requirements.txt .
RUN pip3 install --upgrade pip && 
    pip3 install -r requirements.txt && 
    pip install jupyterlab
	


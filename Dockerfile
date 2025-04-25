FROM python:3.9-slim

WORKDIR /app

	
# jupyterlabをインストール
COPY requirements.txt .

RUN apt-get update && apt-get install -y \
    build-essential \
    libatlas-base-dev \
	git && \
	pip3 install --upgrade pip && \
	pip3 install -r requirements.txt



# コンテナのリッスンポート番号を8888番に設定する
EXPOSE 8888

# コンテナ起動時にjupyter-labを実行する
# IPアドレス接続制限なし、ポート番号8888でアクセスを受ける、ブラウザを起動しない、rootでの実行を許可、トークンなしでのアクセスを許可
ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''"]

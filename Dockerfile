FROM ubuntu:latest

# 環境変数設定
ENV TZ=Asia/Tokyo \
    # minicondaに関する環境設定
    # Javaに関する環境設定
    JAVA_HOME=/usr/lib/jvm/java-18-openjdk-amd64 \
    PATH=$JAVA_HOME/bin:$PATH \
    PATH=/opt/miniconda3/bin:$PATH \
    GANYMEDE_VERSION=2.1.1.20221231

# パッケージの追加とタイムゾーンの設定
# 必要に応じてインストールするパッケージを追加してください
RUN apt update && apt install -y tzdata \
&& ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
&& apt update && apt install -y \
    python3 \
    python3-pip \
    python3-dev \
    wget \
    build-essential \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev  \
    nodejs \
    npm \ 
    openjdk-18-jdk \
&&  ln -s /usr/bin/python3 /usr/bin/python \
&&  apt autoremove \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/* \
# minicondaの導入
&& wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
&&  sh Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 \
&&  rm -r ./Miniconda3-latest-Linux-x86_64.sh \
# mambaをインストール
&&  conda install -c conda-forge mamba \
&&  pip install --upgrade pip \
&&  conda update -n base -c defaults conda \
&&  conda init \
&&  echo "conda activate base" >> ~/.bashrc \
# jupyterlabをインストール
&&  mamba install -y -c conda-forge jupyterlab \
    jupyterlab-language-pack-ja-jp jupyterlab-variableinspector \
    jupyterlab_code_formatter black isort \
    ipywidgets jupyterlab-git \
    jupyterlab-github jupyterlab_pygments jupyterlab_widgets \
    jupyterlab-drawio \
    xeus-cling \
&&  mamba clean -a \
# pythonにプログラミングに必要になるだろうパッケージをインストールする
&& pip install --no-cache-dir \
    numpy \
    pandas \
    scrapy \
    scipy \
    scikit-learn \
    pycaret \
    matplotlib \
    japanize_matplotlib \
    mlxtend \
    seaborn \
    plotly \
    requests \
    beautifulsoup4 \
    Pillow \
    leafmap \
    xpath-py \
    fsspec \
    s3fs \
&&  pip cache purge \
# tslab
&&  npm install -g tslab \
&&  tslab install \
&&  npm cache clean --force \
# Install JVM languages
## Java
# https://github.com/allen-ball/ganymede
&& wget https://github.com/allen-ball/ganymede/releases/download/v${GANYMEDE_VERSION}/ganymede-${GANYMEDE_VERSION}.jar -O /tmp/ganymede.jar \
&&  ${JAVA_HOME}/bin/java \
      -jar /tmp/ganymede.jar  \
      -i --sys-prefix --id=java --display-name=Java18 --copy-jar=true
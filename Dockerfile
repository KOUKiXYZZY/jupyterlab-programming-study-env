FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt

# 環境変数設定
ENV TZ=Asia/Tokyo \
    DEBIAN_FRONTEND=noninteractive \
    # micromambaに関する環境設定
    MAMBA_ROOT_PREFIX=/opt/micromamba \
    PATH=/opt/micromamba/bin:$PATH \
    # Javaに関する設定
    GANYMEDE_VERSION=2.1.1.20221231

RUN apt update && apt install -y \
     bzip2 \
     unzip \
     curl \
     tzdata \
&&  ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
&&  apt autoremove \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/* 

# micromambaをインストール
RUN mkdir -p /opt/micromamba/ \
&&  curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj -C /opt/micromamba 

# jupyterlabをインストール
RUN eval "$(micromamba shell hook -s posix)" \
    && micromamba activate && micromamba install -y  git \
    python pip \
    nodejs  \
    openjdk \
    jupyterlab \
    jupyterlab-language-pack-ja-jp jupyterlab-variableinspector \
    jupyterlab_code_formatter black isort \
    ipywidgets jupyterlab-git \
    jupyterlab-github jupyterlab_pygments jupyterlab_widgets \
    jupyterlab-drawio \
    xeus-cling \
    -c conda-forge \
&&  micromamba clean -a

# pythonにプログラミングに必要になるだろうパッケージをインストールする
RUN pip install --no-cache-dir \
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
&&  pip cache purge

# tslab
RUN npm install -g tslab \
&&  tslab install --python=python \
&&  npm cache clean --force

# IJava
RUN mkdir /opt/IJava && cd /opt/IJava \
&&  curl -sL https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip -o ijava.zip && unzip ./ijava.zip -d ./ \
&&  python install.py \
&&  cd ../ && rm -rf IJava

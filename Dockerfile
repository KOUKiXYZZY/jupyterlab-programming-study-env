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
    python=3.10 \
    pip=23.1.2 \
    nodejs=18.15.0 \
    openjdk=20.0.0 \
    jupyterlab=3.6.3 \
    jupyterlab-language-pack-ja-jp=3.6.post3 \
#    jupyterlab-variableinspector \
    jupyterlab_code_formatter=2.2.1 \
    jupyterlab_widgets=3.0.7 \
    jupyterlab_pygments=0.2.2 \
    black \
    isort \
    ipywidgets=8.0.6 \
    jupyterlab-git=0.41 \
    jupyterlab-github=3.0 \
    jupyterlab-drawio=0.9 \
    xeus-cling=0.15 \
    -c conda-forge \
&&  micromamba clean -a

# pythonにプログラミングに必要になるだろうパッケージをインストールする
RUN pip install --no-cache-dir \
    MarkupSafe==2.0.1 \
    numpy \
    pandas \
    opencv-python \
    opencv-contrib-python \
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
    PyYAML==5.3.1 \ 
&&  pip3 install MarkupSafe elyra \
&&  pip cache purge

# tslab
RUN npm install -g tslab@1.0.21 \
&&  tslab install --python=python \
&&  npm cache clean --force

# IJava
RUN mkdir /opt/IJava && cd /opt/IJava \
&&  curl -sL https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip -o ijava.zip && unzip ./ijava.zip -d ./ \
&&  python install.py \
&&  cd ../ && rm -rf IJava

# Bash Kernel
RUN pip install bash_kernel==0.9.0 \
&& python -m bash_kernel.install


RUN jupyter lab build
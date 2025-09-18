FROM python:3.11-slim

# 创建用户和组
RUN groupadd -g 1000 python && \
    useradd -m -u 1000 -g python python

# 安装基础依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        tini \
        gosu \
        build-essential && \
    rm -rf /var/lib/apt/lists/*

# 安装 Python LSP Server
RUN pip install --no-cache-dir 'python-lsp-server[all]'

# 设置环境变量
ENV UID=1000 USER=python \
    GID=1000 GROUP=python \
    PYTHON_VERSION=3.11 \
    LSP_VERSION=latest

# 复制入口脚本
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 切换到非 root 用户
USER python

# 设置工作目录
WORKDIR /home/python

ENTRYPOINT ["/entrypoint.sh"]
CMD ["pylsp"]

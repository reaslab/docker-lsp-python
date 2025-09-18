# 构建阶段
FROM python:3.11-slim as builder

# 安装构建依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential && \
    rm -rf /var/lib/apt/lists/*

# 安装 Python LSP Server
RUN pip install --no-cache-dir --user 'python-lsp-server[all]'

# 运行阶段
FROM python:3.11-slim

# 创建用户和组
RUN groupadd -g 1000 python && \
    useradd -m -u 1000 -g python python

# 安装运行时依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        tini && \
    rm -rf /var/lib/apt/lists/*

# 从构建阶段复制 Python 包
COPY --from=builder --chown=python:python /root/.local /home/python/.local

# 设置环境变量
ENV PATH=/home/python/.local/bin:$PATH
ENV UID=1000 USER=python \
    GID=1000 GROUP=python \
    PYTHON_VERSION=3.11 \
    LSP_VERSION=latest

# 切换到非 root 用户
USER python

# 设置工作目录
WORKDIR /app

CMD ["pylsp"]

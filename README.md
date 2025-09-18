# docker-lsp-python

基于 Docker 的 Python Language Server Protocol (LSP) 环境，支持多版本 Python 和 Python LSP Server。

## 特性

- 基于 Python 3.11 的 Python LSP Server
- 包含完整的 Python LSP 插件生态
- 用户和组管理，确保安全的文件权限
- 自动化的 Docker 镜像构建和发布
- 支持多架构构建（amd64, arm64）

## 使用方法

### 使用预构建镜像

预构建的镜像可在 [GHCR](https://github.com/reaslab/docker-lsp-python/pkgs/container/docker-lsp-python) 获取。您可以直接拉取并运行：

```sh
docker pull ghcr.io/reaslab/docker-lsp-python:latest
docker run --rm -it ghcr.io/reaslab/docker-lsp-python:latest
```

### 可用标签

| 镜像标签 | 描述 |
|----------|------|
| `latest` | 最新版本（Python 3.11 + 最新 LSP） |
| `{run_number}` | 构建编号标签（如 `123`） |

### 环境变量

`entrypoint.sh` 脚本支持以下环境变量：

- `USER`, `GROUP`: 设置容器内的用户名/组名（默认：`python`）
- `UID`, `GID`: 设置用户/组 ID（默认：1000）
- `XDG_CACHE_HOME`: 设置自定义缓存目录（默认：`/home/python/.cache`）

示例：

```sh
docker run -e USER=myuser -e UID=1234 ghcr.io/reaslab/docker-lsp-python:latest
```

### 使用 Docker Compose

```yaml
version: '3.8'
services:
  python-lsp:
    image: ghcr.io/reaslab/docker-lsp-python:latest
    ports:
      - "2087:2087"
    volumes:
      - ~/.cache/python-lsp:/home/python/.cache
      - ~/.config/python-lsp:/home/python/.config
      - ./workspace:/workspace
    working_dir: /workspace
    environment:
      - USER=python
      - UID=1000
      - GROUP=python
      - GID=1000
    command:
      - pylsp
      - --tcp
      - --port
      - "2087"
      - --host
      - "0.0.0.0"
```

### 本地开发

1. 克隆仓库：
```sh
git clone https://github.com/reaslab/docker-lsp-python.git
cd docker-lsp-python
```

2. 构建镜像：
```sh
docker build -t docker-lsp-python:latest .
```

3. 运行容器：
```sh
docker run --rm -it docker-lsp-python:latest
```

## 配置

### LSP 配置

容器包含默认的 LSP 配置，位于 `/home/python/.config/python-lsp/config.json`。您可以通过挂载卷来自定义配置：

```sh
docker run -v /path/to/your/config.json:/home/python/.config/python-lsp/config.json ghcr.io/reaslab/docker-lsp-python:latest
```

### 支持的插件

- **代码检查**: pycodestyle, pyflakes, mccabe
- **代码格式化**: autopep8, yapf
- **代码补全**: jedi
- **类型检查**: pylint（默认禁用）
- **其他**: preload, rope

## 自动化构建

此项目使用 GitHub Actions 进行自动化构建：

- **推送构建**: 推送到 main 分支时自动构建
- **手动构建**: 通过 workflow_dispatch 手动触发
- **多架构支持**: 同时构建 amd64 和 arm64 架构
- **标签策略**: `latest` 为最新版本，`{run_number}` 为构建编号

## 开发

### 本地测试

```sh
# 构建镜像
docker build -t docker-lsp-python:latest .

# 运行容器
docker run --rm -it docker-lsp-python:latest
```

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](./LICENSE) 文件。

## 贡献

欢迎提交 Issue 和 Pull Request！

## 相关项目

- [python-lsp-server](https://github.com/python-lsp/python-lsp-server) - Python LSP Server 实现
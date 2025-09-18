#!/usr/bin/env bash

set -e

# 创建配置目录
CONFIG_DIR="/home/python/.config/python-lsp"
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
fi

# 创建默认配置文件
if [ ! -f "$CONFIG_DIR/config.json" ]; then
    cat > "$CONFIG_DIR/config.json" << EOF
{
    "pylsp": {
        "plugins": {
            "pycodestyle": {"enabled": true},
            "pyflakes": {"enabled": true},
            "pylint": {"enabled": false},
            "autopep8": {"enabled": true},
            "yapf": {"enabled": false},
            "mccabe": {"enabled": true},
            "preload": {"enabled": true},
            "jedi": {"enabled": true},
            "jedi_completion": {"enabled": true},
            "jedi_definition": {"enabled": true},
            "jedi_hover": {"enabled": true},
            "jedi_references": {"enabled": true},
            "jedi_signature_help": {"enabled": true},
            "jedi_symbols": {"enabled": true},
            "jedi_workspace": {"enabled": true}
        }
    }
}
EOF
fi

# 执行命令
exec "$@"

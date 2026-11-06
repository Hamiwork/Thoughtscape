#!/bin/bash
set -eu
cd -- "$(dirname -- "$0")"
if command -v node >/dev/null 2>&1; then
  thoughtscape_node="$(command -v node)"
else
  thoughtscape_node="$HOME/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node"
fi
if [[ ! -x "$thoughtscape_node" ]]; then
  echo '未找到 Node.js，请安装 Node.js 22.12+ 后重试。'
  read -r -p '按回车关闭。'
  exit 1
fi
export PATH="$(dirname -- "$thoughtscape_node"):$PATH"
if [[ ! -f node_modules/vite/bin/vite.js ]]; then
  echo '请先在此文件夹运行 pnpm install 或 npm install 安装依赖。'
  read -r -p '按回车关闭。'
  exit 1
fi
if /usr/bin/curl -fsS http://127.0.0.1:5173/ 2>/dev/null | /usr/bin/grep -q 'Thoughtscape'; then
  open http://127.0.0.1:5173/
  exit 0
fi
echo 'Thoughtscape 正在启动。浏览器地址：http://127.0.0.1:5173/'
echo '关闭此终端或按 Control+C 可停止服务器。'
(sleep 1; open http://127.0.0.1:5173/) &
exec "$thoughtscape_node" node_modules/vite/bin/vite.js --host 127.0.0.1 --port 5173 --strictPort

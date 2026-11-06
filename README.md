# Thoughtscape v0.5.0

从一个问题进入关键词网络，沿观点、关系与条件形成自己的理解。

## 当前版本：多议题演示，默认不接入 AI

用户可以在首页点击议题，或输入「远程办公」「AI 写作」「交通」等关键词匹配演示地图。未收录的问题会说明边界，不会把其他地图伪装成新问题的分析。所有预置内容在本机直接加载，不消耗任何 AI API token。

| 演示议题                                              | 关键词 | 关系 |
| ----------------------------------------------------- | -----: | ---: |
| AI 客服应该尽可能自动化，还是优先保证用户能找到人工？ |     30 |   38 |
| 大学应该允许学生使用 AI 辅助写作吗？                  |     12 |   16 |
| 远程办公能提高效率，还是会削弱团队协作？              |     12 |   16 |
| 四天工作制能提升工作质量，还是会压缩服务能力？        |     12 |   15 |
| 缓解城市拥堵，应该优先公共交通还是拓宽道路？          |     12 |   16 |

每张地图都有独立的概念、候选观点、立场名称、关系语义、成立条件和不确定性。新议题复用同一套画布与交互，并非只替换标题。原有暖纸、酒红、编辑式关键词网络风格保留。

## 运行

桌面项目双击 **启动 Thoughtscape.command**，访问 http://127.0.0.1:5173/ 。源码包不包含依赖，其他电脑需要 Node.js 22.12+：

```sh
pnpm install
pnpm dev
```

也支持 npm。React、TypeScript、Vite、React Flow、lucide-react 与普通 CSS 沿用原项目，没有新增项目依赖。首页与画布代码分开加载。

## GitHub Pages 发布

仓库包含 `.github/workflows/deploy-pages.yml`，推送到 `main` 后会运行测试、构建并发布。首次需在仓库 **Settings → Pages → Source** 选择 **GitHub Actions**。流程根据 Pages 的 `base_path` 自动配置 Vite，兼容项目子路径和用户主页。

Pages 部署为纯静态演示，构建时设置 `VITE_STATIC_DEMO=true`，不请求 `/api/status` 或生成接口，不包含服务器配置或密钥。五个预置议题及全部画布交互可以正常使用。可选 AI 接口源码仍保留，下载后自行在本地运行；GitHub Pages 本身不运行该接口。

本地模拟项目子路径构建：

```sh
THOUGHTSCAPE_BASE_PATH=/thoughtscape/ VITE_STATIC_DEMO=true pnpm build
THOUGHTSCAPE_BASE_PATH=/thoughtscape/ pnpm preview
```

然后访问 `http://127.0.0.1:4173/thoughtscape/`。本地正常开发仍使用 `pnpm dev`，无需设置这些构建参数。

## 现场演示路径

1. 首页选一个问题，或输入主题关键词后点击「进入演示地图」。
2. 看完整网络，悬停关键词局部放大与预览，单击固定选择并高亮一步关联。
3. 从详情中的相关词继续探索，展开二步、三步关联；用历史箭头恢复之前的位置和缩放。
4. 切换当前议题的支持、质疑和条件视角。布局保留，跨立场关系仍可探索。
5. 点击连线，检查两端、关系解释、条件、不确定性与相关主张。
6. 点击「重新判断关系」，改为「待判断」或其他类型，填写备注并应用。连线、短标签和详情同步，可撤销。
7. 通过「修改问题」返回首页；再次进入当前议题可继续原来的探索。切换到另一议题会开启该议题的新会话。

节点可拖动，空白处可平移，滚轮与按钮可缩放。「重置视图」恢复布局，保留你的改判；关键词查找中的「恢复初始数据」恢复当前议题自己的关系和立场，不会跳回 AI 客服。

## 内容真实性

全部预置内容为 **演示假设，待核实**，不是已验证的研究结论。

AI 客服沿用 6 份明确标记的构造情景，可演示证据和来源追溯。新增四个议题没有核实的外部来源，因此来源数为 0，并明确提示没有已核实证据。没有编造真实机构、作者、论文、统计数据、网址或原文引文。不同立场不等于必然冲突，关系解释始终包含适用条件和不确定性。

关系、立场、节点拖动和探索历史仅保存在当前页面会话。刷新后恢复预置内容。

## 可选 AI 接口，供使用者自行接入

首页输入框下方直接提示自定义问题需要「接入自己的 AI」，点击可展开并跳转到配置说明。五个演示问题下方提供可展开的「接入自己的 AI」说明，包括云端与本地配置、启动步骤、费用边界和关闭方式。查看说明不会启用接口。

用户最新要求是不接 AI，因此默认配置 `THOUGHTSCAPE_ENABLE_AI=false`；即使填了 Key 或本地模型名称，也不会发出生成请求。另有独立的付费服务开关，防止误调用云端。

保留同一端口下的接口：

- `GET /api/status`：只报告配置状态，不返回 Key。
- `POST /api/generate`：请求体为 `{"question":"..."}`。默认返回接口关闭提示；启用后返回经过结构校验的地图数据。

接口挂载于 Vite 开发服务和 `pnpm preview` 的本地服务。直接用其他静态文件服务器托管 `dist/` 不会提供该 API。

以后需要自行接入时，将 `.env.example` 复制成 `.env.local`，填写自己的兼容服务地址、模型和密钥：

```dotenv
THOUGHTSCAPE_ENABLE_AI=true
THOUGHTSCAPE_API_KEY=由使用者填写
THOUGHTSCAPE_BASE_URL=https://api.openai.com/v1
THOUGHTSCAPE_MODEL=gpt-4.1-mini
THOUGHTSCAPE_ALLOW_PAID_API=true
```

以上是使用者主动启用云端服务的示例，费用由其供应商账户承担。默认不包含这些启用值。若连接已安装的本地模型，可使用本机 OpenAI 兼容地址，不需要密钥，也不用开启付费服务开关。本项目没有安装或下载本地模型。

Key 只在服务端读取，不能加 `VITE_` 前缀；`.env.local` 已加入忽略规则，交付 ZIP 不包含它。配置修改后重启项目。OpenAI 的结构化输出接口用法依据 [官方文档](https://developers.openai.com/api/docs/guides/structured-outputs?api-mode=chat)；其他兼容服务使用 JSON 模式，仍经相同的引用、连通性与字段校验。接口有取消、超时和错误处理，不会自动退回演示地图冒充生成成功，也不检索外部资料或编造证据。

**未进行真实付费 API 调用。** 可选接入仅以本地模拟响应和错误契约测试验证；使用者自行配置后，需要实际验证自己的供应商、网络和模型质量。

## 代码与验证

```sh
pnpm test
pnpm build
pnpm preview
```

- `src/data/presets.ts`：议题目录、搜索匹配及数据组装。
- `src/data/presets/*.json`：四个新增议题的独立概念、观点、关系、条件和视角。
- `src/data/entities.ts`、`relations.ts`、`sources.ts`：原 AI 客服演示。
- `src/context/KnowledgeContext.tsx`：让当前议题驱动画布、详情、预览和立场。
- `src/App.tsx`、`QuestionEntry.tsx`：输入、选题、返回与可选接入流程。
- `src/ThoughtscapeWorkspace.tsx`、`components/`：可复用知识探索界面。
- `src/domain/generatedGraph.ts`：共享结构校验与稳定布局，预置地图完全在本地构建。
- `src/domain/relations.ts`、`hooks/useRelations.ts`：当前议题的改判、立场、撤销与恢复。
- `server/`：默认关闭的可选 AI 接口、输出结构与提示词。
- `tests/`：预置数据完整性、跨议题恢复、交互领域规则及可选接口契约测试。

验收记录见 `VALIDATION.md`。旧版交付包保留。

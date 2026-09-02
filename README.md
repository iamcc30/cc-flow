# CC Flow

CC Flow 是一个面向 Codex 的开源研发流程 Skill，把项目上下文、任务计划、独立测试、代码评审和文档同步变成可审计的仓库工作流。

```text
UNDERSTAND → PLAN → APPROVE → IMPLEMENT → TEST → REVIEW → DOCUMENT → DONE
```

## 核心能力

- 为现有或新项目初始化 `AGENTS.md` 和 `.ai/`，并从仓库证据生成项目、架构、业务和进度初稿。
- 用两个字段选择交付级别和架构风格，默认不改变现有架构。
- 把一句简短需求整理为 `task.md`、`plan.md`、`result.md`、`test.md` 和 `review.md`，不静默编造业务规则。
- 执行 Understand、Plan、Implement、Test、Review 门槛；只有独立测试通过才能完成任务。
- 检查任务证据、文档同步、必填占位符和状态流转。
- 同时提供 Codex、Claude Code、Cursor 和 GitHub Copilot 的仓库入口文件。
- 可选工作区模式：一句自然语言需求自动路由到产品协调仓库和受影响的代码仓库。
- 可选轻量 Subagent 编排：默认单 Agent，只对边界清晰、适合并行的复杂工作进行委派。

## 轻量配置

每个项目只需要维护 `.ai/profile.md` 中的两个字段：

```yaml
delivery_level: standard
architecture_style: existing
```

交付级别可选 `prototype / standard / enterprise`，架构风格可选 `existing / layered / clean / hexagonal / ddd`。

默认 `standard + existing` 适合大多数项目。选择 `enterprise` 会增加生产质量证据，选择 `ddd` 才会启用领域边界、聚合不变量、仓储和领域事件等要求。配置不会自动授权架构迁移或无关重构。

## 自动触发范围

CC Flow 保持自动触发，但只用于可能修改软件的任务：新增、修改或优化功能，修复 Bug，重构代码，以及测试、配置、数据结构、依赖、构建或部署机制的变更。已有 CC Flow 任务的后续测试、评审和文档阶段也继续使用原任务记录。

只读问答、代码或架构解释、仓库探索、调研、报告、总结、状态查询和独立文档生成默认不触发，也不会创建或更新 `.ai/tasks/`、`.ai/progress.md` 等流程记录。显式输入 `$cc-flow` 时始终触发；只读请求后来转为修改任务时，从修改开始前进入流程。

## 轻量产品意图检查

CC Flow 不新增产品调研阶段，而是在 `UNDERSTAND` 内先从项目证据确认用户目标、用户场景和成功标准。信息足够就直接继续；只有缺失内容会实质改变范围、用户价值或验收时，才询问最多 1～3 个问题。

用户提出的界面或技术实现默认作为候选方案，而不直接等同于需求；`task.md` 分开记录目标、场景、成功标准和用户原始方案，`plan.md` 再比较可选方案并说明推荐与取舍。明确 Bug、机械修改和已批准方案不会被强制进行产品访谈。

## 安装与升级

### Codex 插件市场（推荐）

适用于 Codex App、Windows、WSL、macOS 和 Linux：

```bash
codex plugin marketplace add iamcc30/cc-flow --ref main
codex plugin add cc-flow@cc-flow
```

第一条命令添加 CC Flow 的 GitHub 市场，第二条命令安装其中的插件。完成后新建一个 Codex 任务，使插件提供的 Skill 进入新任务上下文。

CC Flow 的项目内辅助脚本使用 POSIX `sh`；Windows 原生环境建议通过 WSL 运行项目工作流。

### 独立 Skill

可以让 Codex 使用 Skill Installer 从本仓库安装：

```text
$skill-installer 从 https://github.com/iamcc30/cc-flow 安装 cc-flow
```

也可以在 macOS、Linux 或 WSL 中手动克隆到个人 Skills 目录：

```bash
git clone https://github.com/iamcc30/cc-flow.git "${CODEX_HOME:-$HOME/.codex}/skills/cc-flow"
```

新建一个 Codex 任务后即可使用。

### 升级已安装版本

插件市场安装：

```bash
codex plugin marketplace upgrade cc-flow
codex plugin add cc-flow@cc-flow
codex plugin list
```

`plugin list` 应显示新的 CC Flow 版本。升级完成后新建 Codex 任务，已有任务不会重新加载新的 Skill。

如果 `upgrade` 报错 `marketplace 'cc-flow' is not configured as a Git marketplace`，说明早期版本把它配置成了本地市场。不要继续执行后续安装命令，先进行一次迁移：

```bash
codex plugin marketplace remove cc-flow
codex plugin marketplace add iamcc30/cc-flow --ref main
codex plugin add cc-flow@cc-flow
codex plugin list
```

命令中的插件名应写成 `cc-flow@cc-flow`，不需要在 `@` 前添加反斜杠。迁移只替换 marketplace 来源，不会修改业务仓库的 `.ai/` 或历史任务。

版本变化与兼容说明见 [GitHub Releases](https://github.com/iamcc30/cc-flow/releases)。

通过 `git clone` 安装的独立 Skill：

```bash
git -C "${CODEX_HOME:-$HOME/.codex}/skills/cc-flow" pull --ff-only
```

如果独立 Skill 是由 Skill Installer 下载而不是 Git 克隆，建议改用插件市场管理后续升级。

### 刷新已有项目

升级插件或 Skill 只更新 CC Flow 本体，不会自动覆盖业务仓库中已经生成并定制过的 `.ai/` 文件。需要采用新版脚本或模板时，在目标仓库的新 Codex 任务中执行：

```text
$cc-flow 更新当前项目的 CC Flow 规范，保留已有项目配置、项目事实和历史任务
```

CC Flow 会比较并合并可复用机制，不会自动迁移历史任务。新初始化的项目无需额外刷新。

## 使用

```text
$cc-flow 初始化当前项目
$cc-flow 分析并补齐项目上下文
$cc-flow 创建任务：增加订单退款
$cc-flow 按 Plan、Implement、Test、Review 执行当前任务
$cc-flow 测试当前任务
$cc-flow 评审并检查当前任务
```

也可以直接使用自然语言，例如：

```text
给这个项目初始化 AI 研发规范。
按完整研发流程执行这个需求。
检查当前任务的测试证据和完成条件。
增加 App 住户登记功能。
```

## 多仓库工作区

当前后端、Web、App 等代码分布在多个仓库时，先分别初始化 CC Flow，再在产品协调仓库执行一次：

```text
$cc-flow 初始化多仓库工作区，识别当前工作区中的产品、后端、Web 和 App 仓库。
```

CC Flow 会生成 `.ai/workspace.yaml`，记录稳定的仓库路径和职责。之后只需描述功能，例如“增加 App 住户登记功能”，CC Flow 会读取配置，创建协调仓库父任务和受影响仓库子任务，生成计划并按风险执行审批门槛。它不会因为一句简短需求而编造业务规则，或自动获得创建远程 Issue/PR、推送、发布和生产变更的权限。

## 轻量多 Agent

CC Flow 不按文件数量机械拆分，也不会给每个 Subagent 创建一套任务文档。Plan 默认选择 `single`；只有至少两个工作流可以独立交付、依赖明确、写入边界不重叠，并行确实有收益时才选择 `parallel`。调查、测试和评审优先并行；共享接口或文件尚未稳定时使用 `coordinated` 顺序执行。主 Agent 始终负责审批、集成、任务状态、测试结论和文档。

## 项目中生成的结构

```text
.
├── AGENTS.md
├── CLAUDE.md
├── .ai/
│   ├── README.md
│   ├── project.md
│   ├── profile.md
│   ├── workspace.yaml  # 多仓库项目可选
│   ├── architecture.md
│   ├── business.md
│   ├── conventions.md
│   ├── decisions.md
│   ├── progress.md
│   ├── prompts/            # 五个研发阶段的提示模板
│   ├── scripts/            # 任务创建与校验工具
│   ├── templates/task/     # 任务记录模板
│   └── tasks/YYYY-MM-DD/HHMMSS-short-slug/
├── .cursor/rules/
└── .github/
```

### `.ai/` 文件用途

项目上下文与长期规范：

| 文件 | 用途 |
|---|---|
| `.ai/README.md` | `.ai/` 目录索引、维护原则和敏感信息边界。 |
| `.ai/project.md` | 项目目标、用户、范围、非目标和约束。 |
| `.ai/profile.md` | 交付级别和架构风格。 |
| `.ai/workspace.yaml` | 多仓库项目的仓库路径、角色和职责；单仓库可不创建。 |
| `.ai/architecture.md` | 系统边界、模块、依赖、数据、接口和部署约束。 |
| `.ai/business.md` | 业务术语、权限、规则、流程、状态和异常处理。 |
| `.ai/conventions.md` | 任务分级、审批、测试和完成标准等研发协议。 |
| `.ai/decisions.md` | 需要长期追溯的重要决策及其取舍。 |
| `.ai/progress.md` | 当前阶段、已完成、进行中、风险和下一步。 |

工作流资源：

| 目录/文件 | 用途 |
|---|---|
| `.ai/prompts/understand.md` | 指导 AI 从一句需求和仓库证据中形成明确任务，不提前修改代码。 |
| `.ai/prompts/plan.md` | 指导 AI 调查现状、分析影响、制定测试与回滚方案，并选择是否拆分工作流。 |
| `.ai/prompts/implement.md` | 指导 AI 在批准范围内实现、记录偏差，并在完成后进入测试阶段。 |
| `.ai/prompts/test.md` | 指导 AI 独立执行测试，记录真实命令、结果、未运行项和残余风险。 |
| `.ai/prompts/review.md` | 指导 AI 根据实际差异和测试证据进行独立评审并形成结论。 |
| `.ai/scripts/ai-task-start.sh` | 按日期和时间创建任务目录，并从任务模板生成五个任务文件。 |
| `.ai/scripts/ai-task-check.sh` | 校验项目上下文、任务状态、必需文件、测试结论和完成条件；支持单任务及全量检查。 |
| `.ai/scripts/ai-doc-sync.sh` | 检查任务是否明确记录了项目、架构、业务、决策、进度等文档的同步结果。 |
| `.ai/templates/task/` | 保存任务文件的空白结构，只作为创建任务时的模板，不记录真实任务进度。 |
| `.ai/tasks/YYYY-MM-DD/HHMMSS-<slug>/` | 保存某个真实任务从定义、计划、实现、测试到评审的完整可审计证据；时间前缀让同日任务按创建顺序排列。 |

每个真实任务目录中的文件职责：

| 文件 | 用途 |
|---|---|
| `task.md` | 任务来源、用户目标、用户场景、成功标准、用户原始方案、约束、风险、状态和审批信息。 |
| `plan.md` | 需求与方案区分、现状与根因、可选及推荐方案、修改范围、影响分析、测试和回滚方案。 |
| `result.md` | 实际代码变更、与计划的偏差、实现阶段自检、文档同步和已知限制。 |
| `test.md` | 独立测试范围、实际执行命令、验收覆盖、失败回归、未运行项和测试结论。 |
| `review.md` | 对实际差异与测试证据的评审发现、严重度、处理状态、残余风险和最终结论。 |

`prompts/` 回答“AI 在每个阶段应该怎么工作”，`templates/` 回答“任务记录应该采用什么结构”，`tasks/` 则保存“某次真实任务实际发生了什么”。

Skill 负责安装和执行通用流程；项目仓库中的 `.ai/` 文件负责保存该项目的真实上下文、约束、决策和任务证据。

Skill 包自身的 `scripts/` 是安装和自检工具；复制到业务仓库的任务脚本放在 `.ai/scripts/`，不会占用或混入项目自己的根目录 `scripts/`。

## 安全与兼容

- 初始化脚本默认拒绝覆盖任何同名文件。
- 升级旧版项目时不会自动删除根目录中的旧脚本；确认它们未被项目修改后再清理。
- `--force` 只应在明确检查冲突并授权覆盖后使用。
- 初始化上下文时不修改产品代码。
- 不在 `.ai/` 中保存密钥、凭据、个人敏感数据或生产数据。
- 新任务按 `.ai/tasks/YYYY-MM-DD/HHMMSS-<slug>/` 归档，任务 ID 为 `YYYY-MM-DD-HHMMSS-<slug>`；时间表示创建顺序，不表示优先级。
- 旧版日期目录下无时间前缀的任务和更早的扁平任务目录仍可校验，升级时不会自动搬迁历史记录；新任务使用包含产品意图、配置快照、跨仓库关联和独立 `test.md` 的协议版本 4。

## 开发与验证

根目录是独立 Skill 的源码，`plugins/cc-flow/skills/cc-flow/` 是插件市场发布副本。修改 Skill 后先同步这五项，再运行验证：

```bash
rsync -a SKILL.md plugins/cc-flow/skills/cc-flow/SKILL.md
rsync -a --delete agents/ plugins/cc-flow/skills/cc-flow/agents/
rsync -a --delete assets/ plugins/cc-flow/skills/cc-flow/assets/
rsync -a --delete references/ plugins/cc-flow/skills/cc-flow/references/
rsync -a --delete scripts/ plugins/cc-flow/skills/cc-flow/scripts/
./scripts/verify.sh
```

验证脚本会检查 Shell 语法、初始化一个隔离项目、创建示例任务，并确认独立测试文件和任务校验流程可用。

## License

[MIT](LICENSE)

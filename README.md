# CC Flow

CC Flow 是一个面向 Codex 的开源研发流程 Skill，把项目上下文、任务计划、独立测试、代码评审和文档同步变成可审计的仓库工作流。

```text
UNDERSTAND → PLAN → APPROVE → IMPLEMENT → TEST → REVIEW → DOCUMENT → DONE
```

## 核心能力

- 为现有或新项目初始化 `AGENTS.md` 和 `.ai/` 研发上下文。
- 用两个字段选择交付级别和架构风格，默认不改变现有架构。
- 从仓库证据生成项目、架构、业务和进度初稿，不凭空编造事实。
- 把一句简短需求和仓库证据整理成明确的 `task.md`，未知业务规则不会被静默编造。
- 为标准任务生成独立的 `task.md`、`plan.md`、`result.md`、`test.md` 和 `review.md`。
- 强制 Understand、Plan、Implement、Test、Review 阶段门槛。
- 只有独立测试记录为 `test_status: passed` 才能进入评审和完成状态。
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

## 安装

### Codex 插件市场（推荐）

适用于 Codex App、Windows、WSL、macOS 和 Linux：

```bash
codex plugin marketplace add iamcc30/cc-flow --ref main
codex plugin add cc-flow@cc-flow
```

第一条命令添加 CC Flow 的 GitHub 市场，第二条命令安装其中的插件。完成后新建一个 Codex 任务，使插件提供的 Skill 进入新任务上下文。

### 独立 Skill

可以让 Codex 使用 Skill Installer 从本仓库安装：

```text
$skill-installer 从 https://github.com/iamcc30/cc-flow 安装 cc-flow
```

也可以在 macOS、Linux 或 WSL 中手动克隆到个人 Skills 目录：

```bash
git clone https://github.com/iamcc30/cc-flow.git "${CODEX_HOME:-$HOME/.codex}/skills/cc-flow"
```

重新打开 Codex 任务后即可使用。

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
│   ├── prompts/
│   │   ├── understand.md
│   │   ├── plan.md
│   │   ├── implement.md
│   │   ├── test.md
│   │   └── review.md
│   ├── scripts/
│   │   ├── ai-task-start.sh
│   │   ├── ai-task-check.sh
│   │   └── ai-doc-sync.sh
│   ├── templates/task/
│   │   ├── task.md
│   │   ├── plan.md
│   │   ├── result.md
│   │   ├── test.md
│   │   └── review.md
│   └── tasks/
│       └── YYYY-MM-DD/
│           └── short-slug/
│               ├── task.md
│               ├── plan.md
│               ├── result.md
│               ├── test.md
│               └── review.md
├── .cursor/rules/
└── .github/
```

### `.ai/` 文件用途

项目上下文与长期规范：

| 文件 | 用途 | 主要更新时机 |
|---|---|---|
| `.ai/README.md` | `.ai/` 目录索引、维护原则和敏感信息边界。 | 初始化或目录职责变化时。 |
| `.ai/project.md` | 说明项目为什么存在、服务谁、目标、非目标、范围和约束。 | 产品目标或项目边界变化时。 |
| `.ai/profile.md` | 选择交付级别 `prototype / standard / enterprise` 和架构风格。 | 团队明确调整质量门槛或架构约束时。 |
| `.ai/workspace.yaml` | 多仓库项目的协调配置，记录仓库路径、角色和职责；单仓库可不创建。 | 增删仓库或仓库职责变化时。 |
| `.ai/architecture.md` | 记录系统边界、模块职责、依赖方向、数据、接口、部署和质量属性。 | 架构事实、接口或部署方式变化时。 |
| `.ai/business.md` | 记录统一术语、角色权限、业务规则、流程、状态机和异常处理。 | 业务行为或规则变化时。 |
| `.ai/conventions.md` | AI 和开发者共同遵守的研发协议，包括任务分级、审批、测试和完成标准。 | 团队研发规范或实际检查命令变化时。 |
| `.ai/decisions.md` | 保存需要长期追溯的重要架构或业务决策及其取舍。 | 产生新的长期决策，或旧决策被替代时。 |
| `.ai/progress.md` | 提供项目当前阶段、已完成、进行中、风险和下一步的一页式快照。 | 每个正式任务完成或项目状态变化时。 |

工作流资源：

| 目录/文件 | 用途 |
|---|---|
| `.ai/prompts/understand.md` | 指导 AI 从一句需求和仓库证据中形成明确任务，不提前修改代码。 |
| `.ai/prompts/plan.md` | 指导 AI 调查现状、分析影响、制定测试与回滚方案，并选择是否拆分工作流。 |
| `.ai/prompts/implement.md` | 指导 AI 在批准范围内实现、记录偏差，并在完成后进入测试阶段。 |
| `.ai/prompts/test.md` | 指导 AI 独立执行测试，记录真实命令、结果、未运行项和残余风险。 |
| `.ai/prompts/review.md` | 指导 AI 根据实际差异和测试证据进行独立评审并形成结论。 |
| `.ai/scripts/ai-task-start.sh` | 按日期创建任务目录，并从任务模板生成五个任务文件。 |
| `.ai/scripts/ai-task-check.sh` | 校验项目上下文、任务状态、必需文件、测试结论和完成条件；支持单任务及全量检查。 |
| `.ai/scripts/ai-doc-sync.sh` | 检查任务是否明确记录了项目、架构、业务、决策、进度等文档的同步结果。 |
| `.ai/templates/task/` | 保存任务文件的空白结构，只作为创建任务时的模板，不记录真实任务进度。 |
| `.ai/tasks/YYYY-MM-DD/<slug>/` | 保存某个真实任务从定义、计划、实现、测试到评审的完整可审计证据。 |

每个真实任务目录中的文件职责：

| 文件 | 用途 |
|---|---|
| `task.md` | 任务来源、目标、非目标、验收标准、约束、风险、状态和审批信息。 |
| `plan.md` | 现状与根因、实施方案、修改范围、影响分析、执行策略、测试计划和回滚方案。 |
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
- 新任务按 `.ai/tasks/YYYY-MM-DD/<slug>/` 归档，任务 ID 仍为 `YYYY-MM-DD-<slug>`。
- 旧版扁平任务目录仍可校验，升级时不会自动搬迁历史记录；新任务继续使用包含配置快照、跨仓库关联和独立 `test.md` 的协议版本 3。

## 开发与验证

根目录是独立 Skill 的源码，`plugins/cc-flow/skills/cc-flow/` 是插件市场发布副本。修改 Skill 后先同步这五项，再运行验证：

```bash
rsync -a SKILL.md plugins/cc-flow/skills/cc-flow/SKILL.md
rsync -a --delete agents/ plugins/cc-flow/skills/cc-flow/agents/
rsync -a --delete assets/ plugins/cc-flow/skills/cc-flow/assets/
rsync -a --delete references/ plugins/cc-flow/skills/cc-flow/references/
rsync -a --delete scripts/ plugins/cc-flow/skills/cc-flow/scripts/
```

```bash
./scripts/verify.sh
```

验证脚本会检查 Shell 语法、初始化一个隔离项目、创建示例任务，并确认独立测试文件和任务校验流程可用。

## License

[MIT](LICENSE)

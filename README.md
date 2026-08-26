# CC Flow

CC Flow 是一个面向 Codex 的开源研发流程 Skill，把项目上下文、任务计划、独立测试、代码评审和文档同步变成可审计的仓库工作流。

```text
UNDERSTAND → PLAN → APPROVE → IMPLEMENT → TEST → REVIEW → DOCUMENT → DONE
```

## 核心能力

- 为现有或新项目初始化 `AGENTS.md` 和 `.ai/` 研发上下文。
- 用两个字段选择交付级别和架构风格，默认不改变现有架构。
- 从仓库证据生成项目、架构、业务和进度初稿，不凭空编造事实。
- 为标准任务生成独立的 `task.md`、`plan.md`、`result.md`、`test.md` 和 `review.md`。
- 强制 Plan、Implement、Test、Review 阶段门槛。
- 只有独立测试记录为 `test_status: passed` 才能进入评审和完成状态。
- 检查任务证据、文档同步、必填占位符和状态流转。
- 同时提供 Codex、Claude Code、Cursor 和 GitHub Copilot 的仓库入口文件。
- 可选工作区模式：一句自然语言需求自动路由到产品协调仓库和受影响的代码仓库。

## 轻量配置

每个项目只需要维护 `.ai/profile.md` 中的两个字段：

```yaml
delivery_level: standard
architecture_style: existing
```

交付级别可选 `prototype / standard / enterprise`，架构风格可选 `existing / layered / clean / hexagonal / ddd`。

默认 `standard + existing` 适合大多数项目。选择 `enterprise` 会增加生产质量证据，选择 `ddd` 才会启用领域边界、聚合不变量、仓储和领域事件等要求。配置不会自动授权架构迁移或无关重构。

## 安装

可以让 Codex 使用 Skill Installer 从本仓库安装：

```text
$skill-installer 从 https://github.com/iamcc30/cc-flow 安装 cc-flow
```

也可以手动克隆到个人 Skills 目录：

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

## 项目中生成的结构

```text
.
├── AGENTS.md
├── CLAUDE.md
├── .ai/
│   ├── project.md
│   ├── profile.md
│   ├── workspace.yaml  # 多仓库项目可选
│   ├── architecture.md
│   ├── business.md
│   ├── conventions.md
│   ├── decisions.md
│   ├── progress.md
│   ├── prompts/
│   ├── templates/
│   └── tasks/
├── .cursor/rules/
├── .github/
└── scripts/
```

Skill 负责安装和执行通用流程；项目仓库中的 `.ai/` 文件负责保存该项目的真实上下文、约束、决策和任务证据。

## 安全与兼容

- 初始化脚本默认拒绝覆盖任何同名文件。
- `--force` 只应在明确检查冲突并授权覆盖后使用。
- 初始化上下文时不修改产品代码。
- 不在 `.ai/` 中保存密钥、凭据、个人敏感数据或生产数据。
- 旧版任务记录仍可校验；新任务使用包含独立 `test.md` 的协议版本 2。

## 开发与验证

```bash
./scripts/verify.sh
```

验证脚本会检查 Shell 语法、初始化一个隔离项目、创建示例任务，并确认独立测试文件和任务校验流程可用。

## License

[MIT](LICENSE)

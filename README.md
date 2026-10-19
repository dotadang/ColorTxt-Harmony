# 彩读 ColorTxt · 鸿蒙版

[彩读 ColorTxt](https://github.com/ssnangua/ColorTxt) 的 HarmonyOS NEXT 移动端移植。
ArkWeb 混合架构：**本仓库自包含**（ArkTS 壳 + Web 阅读核心快照），一条命令出 HAP。

## 仓库结构

```
├── harmony/        ArkTS 壳工程（Ability / Bridge / 分块读写 / 沉浸式 / 返回手势）
├── web/            Web 阅读核心快照（Vue 阅读器 / EPUB 转换 / 内容上色 / GBK 检测）
│   ├── src/mobile/         移动端 UI 与逻辑（本仓库独立演化的部分）
│   ├── src/{chapter,ebook,markdown,reader,constants,monaco,utils,shared}/
│   │                       主工程快照（用 sync-from-colortxt.sh 同步）
│   ├── SNAPSHOT            快照来源的主工程 commit
│   └── vite.config.ts      IIFE + defer（规避 ArkWeb resource:// CORS）
└── sync-from-colortxt.sh   从主工程同步快照（清单制）
```

## 构建

```bash
cd web && npm install && npm run build   # Web 产出直出 harmony/.../rawfile/web/
./harmony/build.sh                       # 或 DevEco Studio 打开仓库直接 Run
./harmony/deploy.sh                      # 构建并推送真机（需 hdc 连接）
```

## 与主工程的关系

`web/src` 下除 `mobile/` 外的目录是主工程的**只读快照**（列在
`sync-from-colortxt.sh` 的 MANIFEST 里）。主工程修了共享 bug（如
parseEpub）后，在本仓库执行 `./sync-from-colortxt.sh` 同步并重新构建。

长期方向：快照中的核心模块（章节识别 / EPUB 转换 / 上色规则）计划抽为
npm 包，届时本仓库改为包依赖。

## License

GPL-3.0（继承自上游项目）

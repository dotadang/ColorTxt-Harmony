# 彩读 ColorTxt · 鸿蒙版（壳工程）

[彩读 ColorTxt](https://github.com/ssnangua/ColorTxt) 的 HarmonyOS NEXT 移动端移植：
ArkWeb 混合架构 —— 本仓库是 **ArkTS 壳工程**，Web 阅读核心复用主工程代码。

## 架构

```
HAP
├── ArkTS 壳（本仓库）
│   ├── EntryAbility / Index.ets   ← Web 组件全屏加载 rawfile 页面
│   ├── Bridge.ets                 ← JSBridge：书库(导入/读取/删除)、
│   │                                 沉浸式、返回手势分级、Toast
│   └── 分块读写                   ← 大文件分 64KB 过桥（整串会崩）
└── Web 包（构建产物，gitignore）
    └── Vue 阅读器 + EPUB 转换 + 内容上色（来自主工程）
```

## 构建

1. **产出 Web 包**（在主工程仓库执行）：

   ```bash
   npm run build:mobile
   # 产物在 harmony/entry/src/main/resources/rawfile/web/
   ```

2. **构建 HAP**：DevEco Studio 打开本仓库，或命令行：

   ```bash
   ./build.sh        # 产物 entry/build/default/outputs/default/
   ./deploy.sh       # 构建并推送到连接的真机
   ```

## 环境要求

- DevEco Studio（HarmonyOS NEXT SDK，API 26）
- 真机调试：手机开启开发者模式 + USB 调试，DevEco 自动签名

## License

GPL-3.0（继承自上游项目）

#!/bin/bash
# 从主工程 ColorTxt 同步移动端 Web 源码快照到本仓库 web/src/
#
# 依赖清单（MANIFEST）内是移动端 Web 实际引用的主工程文件。
# 主工程修改了下列文件后，在本仓库执行一次本脚本即可同步。
# 脚本头部会记录来源 commit，便于追溯快照版本。

set -e

MAIN="${COLORTXT_MAIN:-$HOME/code/ColorTxt}"
SELF="$(cd "$(dirname "$0")/.." && pwd)"

if [ ! -d "$MAIN/src/renderer/src/mobile" ]; then
  echo "找不到主工程: $MAIN（可用 COLORTXT_MAIN=路径 覆盖）"
  exit 1
fi

MAIN_COMMIT=$(git -C "$MAIN" rev-parse --short HEAD)
echo "来源: $MAIN @$MAIN_COMMIT"

MANIFEST=(
  # ---- 移动端入口（整体目录） ----
  "src/renderer/src/mobile"
  # ---- 被移动端直接/间接引用的主工程模块 ----
  "src/renderer/src/chapter.ts"
  "src/renderer/src/constants/appUi.ts"
  "src/renderer/src/constants/readerPalette.ts"
  "src/renderer/src/constants/readerPalettePresets.ts"
  "src/renderer/src/constants/readerBackground.ts"
  "src/renderer/src/constants/readerBuiltins"
  "src/renderer/src/monaco/txtrTextMonarch.ts"
  "src/renderer/src/monaco/txtrHighlightMonarch.ts"
  "src/renderer/src/monaco/readerEditorOptions.ts"
  "src/renderer/src/ebook"
  "src/renderer/src/markdown"
  "src/renderer/src/reader"
  "src/renderer/src/utils/fontFamilyCss.ts"
  "src/renderer/src/utils/format.ts"
  "src/renderer/src/utils/modalStack.ts"
  "src/renderer/src/utils/presetFontDefinitions.ts"
  "src/renderer/mobile.html"
  "src/shared/chapterMatchBuiltinPatterns.ts"
  "src/shared/ebookExtensions.ts"
  "src/shared/packageDerived.ts"
  "src/shared/aiSmartFormatTypes.ts"
  "src/shared/textConvertTypes.ts"
  "src/shared/aiTokenUsage.ts"
  "src/shared/aiTypes.ts"
  "src/shared/aiEndpointProfiles.ts"
  "src/shared/aiSystemPromptPresets.ts"
  "src/shared/apiEndpointPresets.ts"
  "src/shared/builtinEmbeddingModels.ts"
  "src/shared/txt2ImgBackend.ts"
  "src/shared/txt2ImgOpenAiQuality.ts"
  "src/shared/readerBackground.ts"
)

# 记录来源版本
echo "$MAIN_COMMIT" > "$SELF/web/SNAPSHOT"

for item in "${MANIFEST[@]}"; do
  src="$MAIN/$item"
  dest="$SELF/web/${item#src/renderer/}"
  dest="$SELF/web/${item#src/}"
  if [ -d "$src" ]; then
    rm -rf "$dest"
    mkdir -p "$(dirname "$dest")"
    cp -R "$src" "$dest"
    echo "同步目录: $item"
  elif [ -f "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "同步文件: $item"
  else
    echo "警告: 主工程不存在 $item（可能已重构，请更新本脚本的 MANIFEST）"
  fi
done

# mobile.html 的入口路径按本仓库布局修正
sed -i '' 's|/src/mobile/mobileMain.ts|/src/mobile/mobileMain.ts|' "$SELF/web/mobile.html" 2>/dev/null || true

echo ""
echo "同步完成。验证: cd web && npm run build"

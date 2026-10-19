import { fileURLToPath } from "node:url";
import vue from "@vitejs/plugin-vue";
import { defineConfig } from "vite";
import { fileURLToPath as fURL2 } from "node:url";

const resolve = (p: string) => fileURLToPath(new URL(p, import.meta.url));

// ArkWeb resource:// 源下 ES module 走 CORS 会被拦：输出 IIFE + defer 经典脚本
export default defineConfig({
  root: resolve("."),
  resolve: {
    alias: {
      "@shared": fURL2(new URL("./src/shared", import.meta.url)),
    },
  },
  plugins: [
    vue(),
    {
      name: "classic-script-html",
      transformIndexHtml(html) {
        return html
          .replace(' type="module" crossorigin', " defer")
          .replace(' crossorigin', "");
      },
    },
  ],
  base: "./",
  publicDir: false,
  define: {
    __APP_DISPLAY_NAME__: JSON.stringify("彩读"),
    __GITHUB_REPO_URL__: JSON.stringify("https://github.com/ssnangua/ColorTxt"),
  },
  build: {
    outDir: resolve("../harmony/entry/src/main/resources/rawfile/web"),
    emptyOutDir: true,
    target: "chrome110",
    modulePreload: { polyfill: false },
    rollupOptions: {
      input: { index: resolve("./mobile.html") },
      output: { format: "iife", inlineDynamicImports: true },
    },
  },
});

import { renameSync } from "node:fs";
// 壳工程 Index.ets 固定加载 $rawfile('web/index.html')
renameSync("../harmony/entry/src/main/resources/rawfile/web/mobile.html", "../harmony/entry/src/main/resources/rawfile/web/index.html");
console.log("renamed mobile.html -> index.html");

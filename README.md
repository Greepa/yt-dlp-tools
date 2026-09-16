# yt-dlp-tools · 开箱即用的视频下载工具包

一键下载 YouTube / Bilibili / Twitter(X) 等 1000+ 站点的视频、字幕、元数据。
Out-of-the-box video / subtitle / metadata downloader for YouTube, Bilibili, Twitter(X) and 1000+ sites.

> 本工具包是对 [yt-dlp](https://github.com/yt-dlp/yt-dlp)（开源，Unlicense / 公共领域）的**二次封装**：
> 仅提供配置、脚本与说明文档，**不修改 yt-dlp 本体**，下载引擎与 ffmpeg 均从其官方发布页获取。
> This toolkit is a wrapper/config around the upstream [yt-dlp](https://github.com/yt-dlp/yt-dlp) project (Unlicense / public domain).

---

## 快速开始 / Quick start

1. 把本文件夹放到任意位置（如 `E:\yt-dlp-tools`）。脚本用相对路径，**放到哪都行**。
   Put this folder anywhere. Scripts are path-independent.
2. 双击 **`setup.bat`** 一键装好 ffmpeg 和 `yt-dlp.exe`（需联网；国内自动走 gh-proxy）。
   Double-click **`setup.bat`** to fetch ffmpeg + `yt-dlp.exe` (needs internet).
3. 双击 **`download.bat`**，粘贴视频链接即可下载。
   Double-click **`download.bat`** and paste a URL.

> 不想用 `setup.bat` 也行：自己把 `yt-dlp.exe` 丢进本文件夹，再双击 `install_ffmpeg.bat` 装 ffmpeg。
> Prefer manual? Drop `yt-dlp.exe` into this folder, then run `install_ffmpeg.bat`.

⚠️ **B 站用户先跑 `set_cookie.bat`** 配置 cookie，否则会被 412 限流（详见 `使用说明.md` 第二节）。
⚠️ **Bilibili users: run `set_cookie.bat` first** to avoid HTTP 412 rate limiting.

---

## 脚本一览 / Scripts

| 脚本 | 作用 |
|---|---|
| `set_cookie.bat` | 配置 B站 cookie（解决 412 限流，强烈建议先跑） |
| `download.bat` | 下载单个视频 |
| `batch_download.bat` | 批量下载（填 `urls.txt`，一行一个链接） |
| `batch_info.bat` | 批量采集播放量/点赞/评论 → `video_stats.csv` |
| `info.bat` | 只看元数据不下载 |
| `subtitles.bat` | 只下字幕（分析脚本用） |
| `update.bat` | 更新 yt-dlp |
| `install_ffmpeg.bat` | 仅装 ffmpeg |
| `get_yt-dlp.bat` | 仅下载 `yt-dlp.exe` |
| `setup.bat` | 一键装 ffmpeg + `yt-dlp.exe` |

---

## 🤖 给智能体 / WorkBuddy 的配置说明（指令式）

本仓库面向「能读 README、能执行命令」的智能体设计。一个 WorkBuddy 类智能体可照以下步骤完成配置：

1. **读取文档**：先读 `README.md` 与本仓库的 `使用说明.md`，理解脚本与已知坑点。
2. **安装依赖**（任选其一）：
   - 让智能体执行 `setup.bat`（Windows 下 `cmd /c setup.bat`），自动下载 ffmpeg 与 `yt-dlp.exe`；
   - 或让智能体把 `yt-dlp.exe` 放到本目录，再执行 `install_ffmpeg.bat`。
3. **配 B 站 cookie**（仅 B 站需要）：让智能体执行 `set_cookie.bat`，按提示从浏览器复制 `document.cookie` 并粘贴。
   若智能体已拿到 cookie 字符串，也可直接写入 Netscape 格式 `cookies.txt`，并取消 `yt-dlp.conf` 里 `--cookies` 行的注释。
4. **调用下载**：让智能体在**本目录内**执行 `yt-dlp.exe --config-location yt-dlp.conf "<URL>"`。
   ⚠️ 务必先 `cd` 到本目录（脚本均以此保证相对路径 `./` 生效）。
5. **关键约束（智能体必看）**：
   - **配置文件编码**：在中文 Windows 上 yt-dlp 按 **GBK/ANSI** 读 `yt-dlp.conf`。若智能体要改配置，**必须用 GBK/ANSI 保存**，勿存成含中文的 UTF-8，否则报 `'gbk' codec can't decode byte`。仓库内置 `yt-dlp.conf` 已为纯 ASCII，跨平台安全。
   - **路径用正斜杠**：配置里路径一律 `E:/foo` 而非 `E:\foo`，反斜杠会被当转义吃掉的。
   - **YouTube / X 需代理**：本仓库不含代理，下载这类站点需自备 `--proxy`。

This toolkit is agent-friendly: every script uses relative paths and `%~dp0` / `$PSScriptRoot`, so an agent can clone anywhere, run `setup.bat`, then call `yt-dlp.exe --config-location yt-dlp.conf "<URL>"`.

---

## 详细中文说明

见 **`使用说明.md`**（含 B站 412、YouTube 代理、中文文件名、GBK 编码等坑）。

---

## 📜 开源与合规 / License & compliance

- 上游项目：[yt-dlp](https://github.com/yt-dlp/yt-dlp)，采用 **Unlicense（公共领域）** 许可。
- 本仓库为**二次创作（derivative work）**：仅包含配置、脚本与文档，**未改动 yt-dlp 源代码**，下载的 `yt-dlp.exe` / ffmpeg 均来自其各自官方发布页（已内置 gh-proxy 备用源）。
- 本仓库本身以相同精神发布：脚本与文档可自由使用、修改、再分发；**不对 yt-dlp / ffmpeg 主张任何权利**。
- **下载行为由使用者自负责任**：请遵守目标站点的服务条款与所在地区法律法规，勿用于侵权或批量抓取受保护内容。
- Upstream: [yt-dlp](https://github.com/yt-dlp/yt-dlp) (Unlicense / public domain). This repo wraps it with config + scripts and claims no copyright over yt-dlp or ffmpeg. Respect each project's license and your local laws when downloading.

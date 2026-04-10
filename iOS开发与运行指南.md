# 钱小满 (Money Full) - iOS 开发与运行指南

本文档将指导您如何将通过 Flutter 纯代码构建的项目生成为 iOS 原生工程，并在 Xcode 的模拟器中运行，体验《钱小满》App 真实的跨平台丝滑效果。

## 运行步骤

因为我们之前主要是纯手写了 Flutter 的跨平台核心代码 (Dart 语言)，还没有生成 iOS 专属的运行环境文件。所以我们需要先让 Flutter 自动“生成”一下 `ios` 文件夹，然后再用 Xcode 打开它。

### 第一步：生成 iOS 原生工程文件
打开您的 **终端 (Terminal)** 软件，输入以下命令。这会进入我们的项目文件夹，并让 Flutter 补全缺少的 iOS 和 Android 底层环境文件夹：

```bash
cd /Users/cs/Desktop/CS/AI/money_full/money_full_flutter/
flutter create .
```
*(注意：命令最后有一个小数点 `.` ，代表在当前目录创建原生工程环境)*

### 第二步：下载所需的插件与依赖
继续在终端里输入下面的命令，把我们在 `pubspec.yaml` 中配置的图表、状态管理等工具包下载下来：

```bash
flutter pub get
```

### 第三步：用 Xcode 打开项目
iOS 的依赖包需要通过 CocoaPods 管理，并且最终的项目必须通过特殊的 `workspace` 文件打开。继续在终端里输入这行代码并回车，它会自动帮您唤起 Xcode 并打开这个项目：

```bash
open ios/Runner.xcworkspace
```
*(💡 **核心提示**：在开发 Flutter 的 iOS 端时，我们永远都是打开 `Runner.xcworkspace` 这个文件，千万**不要**只打开 `Runner.xcodeproj` 哦！)*

### 第四步：在 Xcode 中运行模拟器
当 Xcode 软件打开后，按照以下三步操作：

1. **选择手机型号**：
   看 Xcode 窗口的最上方正中间，有一个长得像设备名字的地方（可能默认写着 `Any iOS Device (arm64)`）。
   点击它，会弹出一个下拉菜单。在 "iOS Simulators" 列表里，选一个您喜欢的手机型号，比如 **iPhone 15 Pro**。

2. **点击运行**：
   选好手机后，点击 Xcode 窗口**左上角的三角形“播放”按钮（▶️）**。或者您也可以按下快捷键 `Cmd + R`。

3. **耐心等待首次编译**：
   第一次编译 iOS App 需要几分钟时间下载一些构建工具并把跨平台代码翻译成原生代码。Xcode 上方会显示正在 "Building" 或者 "Compiling"。

编译成功后，一个完美的 iPhone 模拟器就会自动弹出来！您就能看到《钱小满》的莫兰迪色看板、水豚小动画，并且可以点开“记一笔”体验那个带弹簧动画的自定义数字键盘啦！

---

## 常见问题排查 (Troubleshooting)

如果在任何一步出现了红色的报错（比如提示找不到 Flutter，或者 Xcode 证书/Ruby 环境没有配置好），您只需要在终端输入：

```bash
flutter doctor
```
这个命令是 Flutter 官方的“环境体检”医生，它会用绿色的 `[✓]` 和红色的 `[✗]` 清晰地列出您电脑上还缺少什么配置。如果有报错，请随时发给我，我会马上为您诊断并解决！

# MonoLoadKit

**32 款极简 SwiftUI Loading 动画，可通过 Swift Package Manager 直接引入。**

![Swift](https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white) ![iOS](https://img.shields.io/badge/iOS-16%2B-000000?logo=apple) ![macOS](https://img.shields.io/badge/macOS-13%2B-000000?logo=apple) ![tvOS](https://img.shields.io/badge/tvOS-16%2B-000000?logo=apple) ![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg) ![SwiftPM](https://img.shields.io/badge/SwiftPM-compatible-F05138?logo=swift&logoColor=white)

[English](README.md) · [许可证](LICENSE) · [Demo](Examples/MonoLoadDemo)

## 核心特点

- **32 种独立样式**：圆弧、粒子、竖线、交叠双环、几何形状等。
- **100% 原生 SwiftUI**：基于 `Canvas` 矢量绘制，不播放 GIF，不依赖第三方库。
- **可配置**：尺寸、颜色、速度、播放/暂停。
- **暂停后从原进度恢复**：`MonoLoadingView` 持续维护自身播放时钟。
- **支持辅助功能**：系统启用“减少动态效果”时使用静态展示。
- **性能友好的展示方式**：一次展示 32 款时，使用一个 `TimelineView` 驱动所有可见单元，而非分别创建 Timer。
- **独立 iOS Demo**：搜索、类别筛选、深浅模式、速度/尺寸控制、暂停、单项放大预览、复制调用代码。
- MIT 开源许可，零第三方依赖，不配置 GitHub Actions。

## 兼容性

Swift 5.9+、iOS 16+、macOS 13+、tvOS 16+，推荐使用最新版 Xcode 编译。当前交付包含 Swift 源码与完整 Xcode Demo 工程，但请在 macOS/Xcode 中进行最终编译与设备测试。

## 接入方式

将仓库放到本地，在 Xcode 中选择 **File → Add Package Dependencies → Add Local…**，选中仓库根目录，添加 `MonoLoadKit` 产品到应用 Target。

发布到 GitHub 后，也可以使用仓库 URL 按照 Swift Package Manager 方式添加：

```swift
.package(url: "https://github.com/wangjianqi/MonoLoadKit.git", from: "1.0.0")
```

```swift
import SwiftUI
import MonoLoadKit

// 推荐的默认样式：02 流动月牙
MonoLoadingView(
    style: .flowingCrescent,
    size: 28,
    color: .primary,
    speed: 1,
    isAnimating: true
)

// 19 反向双弧
MonoLoadingView(style: .counterRotatingArcs, size: 32)
```

组件只负责绘制，不自动添加遮罩、毛玻璃卡片、提示文字、阻止交互或更改业务状态。是否覆盖页面、何时显示、是否允许取消，由宿主应用决定。

### 同屏展示 32 款

建议使用 **一个 `TimelineView` + 32 个 `MonoLoadingGlyph`**，避免给每个网格单元单独创建刷新时钟：

```swift
TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { frame in
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))]) {
        ForEach(MonoLoadingStyle.allCases) { style in
            MonoLoadingGlyph(
                style: style,
                size: 48,
                elapsed: frame.date.timeIntervalSinceReferenceDate
            )
        }
    }
}
```

## 启动 Demo

1. 保留解压后完整文件夹结构。
2. Xcode 打开 `Examples/MonoLoadDemo/MonoLoadDemo.xcodeproj`。
3. 选择 `MonoLoadDemo` Scheme。
4. 选择 iOS 16+ 模拟器，直接运行。
5. 在画廊中筛选、搜索或点击任意样式进入大图预览。

Demo 已通过 Xcode 本地包引用 `../..` 关联根目录的 Swift Package，无需联网下载依赖。真机运行时需按 Xcode 提示选择签名团队。

## API

| 属性 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `style` | `MonoLoadingStyle` | `.flowingCrescent` | 32 款动画任选 |
| `size` | `CGFloat` | `28` | 单位 pt |
| `color` | `Color` | `.primary` | 随系统深浅模式变化 |
| `speed` | `Double` | `1` | 倍速，`0` 冻结 |
| `isAnimating` | `Bool` | `true` | 动画是否运行 |

所有样式完整名称请参考 [README.md](README.md#32-styles) 与 `MonoLoadingStyle.swift`，包含英文和中文标签。

## 验证

Mac 上运行：

```bash
./Scripts/verify.sh
swift test
xcodebuild -project Examples/MonoLoadDemo/MonoLoadDemo.xcodeproj \
  -scheme MonoLoadDemo \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

源代码语法和 SPM 清单可在 Linux 验证；**无法代替 Xcode 的 SwiftUI 编译、iOS 模拟器实际运行和性能测试**。

## 开源

[MIT 许可证](LICENSE)。欢迎通过 Issue / PR 提出新的矢量动画和性能改进。参见 [CONTRIBUTING.md](CONTRIBUTING.md)。

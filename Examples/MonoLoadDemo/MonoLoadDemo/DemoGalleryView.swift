import SwiftUI
import MonoLoadKit
import UIKit

struct DemoGalleryView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedCategory: MonoLoadingCategory?
    @State private var newCollectionOnly = false
    @State private var isCompact = false
    @State private var isCaptureMode = false
    @State private var compactSpacing: CGFloat = 5
    @State private var selectedStyle: MonoLoadingStyle?
    @State private var query = ""
    @State private var isDark = true
    @State private var isPlaying = true
    @State private var size: Double = 48
    @State private var speed: Double = 1
    @State private var clockSpeed: Double = 1
    @State private var clockOrigin = Date()
    @State private var clockAccumulated: TimeInterval = 0

    private var canvas: Color {
        isDark ? Color(red: 0.055, green: 0.058, blue: 0.065)
               : Color(red: 0.965, green: 0.966, blue: 0.97)
    }

    private var tile: Color {
        isDark ? Color(red: 0.090, green: 0.095, blue: 0.105) : .white
    }

    private var foreground: Color { isDark ? .white : .black }
    private var secondary: Color { isDark ? .white.opacity(0.48) : .black.opacity(0.46) }

    private var filteredStyles: [MonoLoadingStyle] {
        MonoLoadingStyle.allCases.filter { style in
            let inCategory = selectedCategory == nil || style.category == selectedCategory
            let inCollection = !newCollectionOnly || style.number > 32
            let inQuery = query.isEmpty || style.label.localizedCaseInsensitiveContains(query)
                || style.chineseLabel.localizedCaseInsensitiveContains(query)
                || String(style.number) == query
            return inCategory && inCollection && inQuery
        }
    }

    private func time(at date: Date) -> TimeInterval {
        clockAccumulated + (isPlaying ? max(0, date.timeIntervalSince(clockOrigin)) * clockSpeed : 0)
    }

    private func togglePlayback() {
        let now = Date()
        clockAccumulated = time(at: now)
        clockOrigin = now
        isPlaying.toggle()
    }

    private func updateSpeed(_ newSpeed: Double) {
        let now = Date()
        clockAccumulated = time(at: now)
        clockOrigin = now
        clockSpeed = newSpeed
        speed = newSpeed
    }

    var body: some View {
        ZStack {
            canvas.ignoresSafeArea()
            if isCaptureMode {
                captureLayout
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: isCompact ? 14 : 24) {
                        if isCompact {
                            compactHeader
                            compactControls
                        } else {
                            header
                            controls
                            filterBar
                        }
                        TimelineView(.animation(minimumInterval: 1.0 / 30.0,
                                                paused: !isPlaying || reduceMotion)) { frame in
                            if isCompact {
                                compactGallery(elapsed: reduceMotion ? 0 : time(at: frame.date))
                            } else {
                                gallery(elapsed: reduceMotion ? 0 : time(at: frame.date))
                            }
                        }
                        if !isCompact { footer }
                    }
                    .padding(.horizontal, isCompact ? 12 : 20)
                    .padding(.top, isCompact ? 8 : 22)
                    .padding(.bottom, isCompact ? 12 : 32)
                }
                .scrollIndicators(.hidden)
            }
        }
        .preferredColorScheme(isDark ? .dark : .light)
        .statusBarHidden(isCaptureMode)
        .sheet(item: $selectedStyle) { style in
            DemoStyleDetailView(style: style, isDark: isDark)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Compact / recording-friendly gallery

    private var compactHeader: some View {
        HStack(spacing: 10) {
            Image("BrandMark")
                .resizable().scaledToFit()
                .frame(width: 27, height: 27)
                .accessibilityHidden(true)
            Text("MonoLoadKit")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(foreground)
            Text("\(filteredStyles.count) STYLES")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundStyle(secondary)
            Spacer()
            Button { isCompact = false } label: {
                Image(systemName: "rectangle.grid.2x2")
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("Standard layout")
            .accessibilityIdentifier("gallery-standard-mode")
            Button { isDark.toggle() } label: {
                Image(systemName: isDark ? "sun.max" : "moon")
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("Toggle color scheme")
        }
        .foregroundStyle(foreground)
    }

    private var compactControls: some View {
        HStack(spacing: 10) {
            Button {
                newCollectionOnly = false
                selectedCategory = nil
                query = ""
                compactSpacing = 4
                if !isPlaying { togglePlayback() }
                isCaptureMode = true
            } label: {
                Label("Capture GIF", systemImage: "record.circle")
                    .font(.system(size: 12, weight: .medium))
            }
            .accessibilityIdentifier("gallery-capture-mode")
            Spacer()
            Button(action: togglePlayback) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 13))
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel(isPlaying ? "Pause" : "Play")
            .accessibilityIdentifier("compact-play-pause")
            Menu {
                Button("Comfortable") { compactSpacing = 8 }
                Button("Dense") { compactSpacing = 5 }
                Button("Maximum") { compactSpacing = 2 }
            } label: {
                Image(systemName: "square.grid.3x3")
                    .font(.system(size: 15))
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("Grid density")
        }
        .foregroundStyle(foreground)
        .padding(.horizontal, 8)
        .frame(height: 38)
        .background(tile, in: RoundedRectangle(cornerRadius: 12))
    }

    private func compactGallery(elapsed: TimeInterval) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 45, maximum: 72), spacing: compactSpacing)],
                  spacing: compactSpacing) {
            ForEach(filteredStyles) { style in
                Button { selectedStyle = style } label: {
                    VStack(spacing: 2) {
                        MonoLoadingGlyph(style: style, size: 34, color: foreground,
                                         elapsed: elapsed, reduceMotion: reduceMotion)
                            .frame(height: 42)
                        Text(String(format: "%02d", style.number))
                            .font(.system(size: 9, weight: .medium, design: .monospaced))
                            .foregroundStyle(secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(tile, in: RoundedRectangle(cornerRadius: 10))
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Style \(style.number): \(style.label)")
                .accessibilityIdentifier("compact-style-\(style.number)")
            }
        }
    }

    /// The full-screen capture surface fits all 44 styles without scrolling.
    /// Double-tap anywhere to return to the compact gallery.
    private var captureLayout: some View {
        GeometryReader { geometry in
            TimelineView(.animation(minimumInterval: 1.0 / 30.0,
                                    paused: !isPlaying || reduceMotion)) { frame in
                captureGrid(
                    elapsed: reduceMotion ? 0 : time(at: frame.date),
                    available: geometry.size
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture(count: 2) { isCaptureMode = false }
                .accessibilityAction(named: Text("Exit capture mode")) {
                    isCaptureMode = false
                }
            }
        }
        .accessibilityIdentifier("gallery-capture-grid")
    }

    private func captureGrid(elapsed: TimeInterval, available: CGSize) -> some View {
        let styles = MonoLoadingStyle.allCases
        // Adaptive column count: 6–7 on iPhone portrait; more on iPad/landscape.
        let gap: CGFloat = 4
        let columns = max(4, min(16, Int((available.width - 16 + gap) / 54)))
        let rows = Int(ceil(Double(styles.count) / Double(columns)))
        let tileWidth = (available.width - 16 - CGFloat(columns - 1) * gap) / CGFloat(columns)
        let tileHeight = min(tileWidth * 1.2,
                             (available.height - 24 - CGFloat(rows - 1) * gap) / CGFloat(rows))
        let iconSize = max(16, min(40, tileWidth * 0.68, tileHeight - 15))
        return VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image("BrandMark").resizable().scaledToFit()
                    .frame(width: 22, height: 22)
                Text("MonoLoadKit")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("44 LOADING ANIMATIONS")
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundStyle(secondary)
            }
            .foregroundStyle(foreground)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: gap), count: columns),
                      spacing: gap) {
                ForEach(styles) { style in
                    VStack(spacing: 2) {
                        MonoLoadingGlyph(style: style, size: iconSize, color: foreground,
                                         elapsed: elapsed, reduceMotion: reduceMotion)
                            .frame(height: max(1, tileHeight - 15))
                        Text(String(format: "%02d", style.number))
                            .font(.system(size: 8, weight: .medium, design: .monospaced))
                            .foregroundStyle(secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: max(30, tileHeight))
                    .background(tile.opacity(0.68), in: RoundedRectangle(cornerRadius: 9))
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Image("BrandMark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 7) {
                    Text("MONOLOADKIT")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .tracking(3)
                        .foregroundStyle(secondary)
                    Text("44 minimalist loaders")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .tracking(-1.1)
                        .foregroundStyle(foreground)
                    Text("SwiftUI  ·  Vector  ·  0 Dependencies")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(secondary)
                }
                Spacer(minLength: 4)
                Button {
                    isDark.toggle()
                } label: {
                    Image(systemName: isDark ? "sun.max" : "moon")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(foreground)
                        .frame(width: 42, height: 42)
                        .background(tile, in: RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityLabel("Toggle color scheme")
            }
            Button {
                isCompact = true
            } label: {
                Label("Minimal grid / GIF capture", systemImage: "square.grid.3x3.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(foreground)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(tile, in: Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("gallery-compact-mode")
            Text("Original 32 + 12 crafted styles. Pure SwiftUI motion.")
                .font(.system(size: 13))
                .foregroundStyle(secondary)
        }
    }

    private var controls: some View {
        VStack(spacing: 19) {
            HStack {
                Label("PREVIEW CONTROLS", systemImage: "slider.horizontal.3")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundStyle(secondary)
                    .tracking(1)
                Spacer()
                Button(action: togglePlayback) {
                    Label(isPlaying ? "Pause" : "Play", systemImage: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(foreground)
                }
                .accessibilityIdentifier("gallery-play-pause")
            }
            HStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Text("Size")
                        Spacer()
                        Text("\(Int(size)) pt").monospacedDigit()
                    }
                    .font(.system(size: 12))
                    .foregroundStyle(secondary)
                    Slider(value: $size, in: 18...72, step: 1)
                        .tint(foreground)
                        .accessibilityIdentifier("gallery-size")
                }
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Text("Speed")
                        Spacer()
                        Text(String(format: "%.2f×", speed)).monospacedDigit()
                    }
                    .font(.system(size: 12))
                    .foregroundStyle(secondary)
                    Slider(value: Binding(get: { speed }, set: updateSpeed),
                           in: 0.25...3, step: 0.25)
                        .tint(foreground)
                        .accessibilityIdentifier("gallery-speed")
                }
            }
        }
        .padding(17)
        .background(tile, in: RoundedRectangle(cornerRadius: 20))
    }

    private var filterBar: some View {
        VStack(spacing: 14) {
            HStack(spacing: 7) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(secondary)
                TextField("Search style, name or number", text: $query)
                    .font(.system(size: 13))
                    .foregroundStyle(foreground)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityIdentifier("gallery-search")
            }
            .padding(.horizontal, 14)
            .frame(height: 42)
            .background(tile, in: RoundedRectangle(cornerRadius: 13))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button {
                        newCollectionOnly = false
                        selectedCategory = nil
                    } label: {
                        collectionChip("All 44", active: !newCollectionOnly && selectedCategory == nil)
                    }
                    .buttonStyle(.plain)
                    Button {
                        newCollectionOnly = true
                        selectedCategory = nil
                    } label: {
                        collectionChip("New 12", active: newCollectionOnly)
                    }
                    .buttonStyle(.plain)
                    ForEach(MonoLoadingCategory.allCases) { category in
                        categoryButton(category.label, category: category)
                    }
                }
            }
        }
    }

    private func categoryButton(_ title: String, category: MonoLoadingCategory?) -> some View {
        let active = selectedCategory == category && !newCollectionOnly
        return Button {
            newCollectionOnly = false
            selectedCategory = category
        } label: {
            collectionChip(title, active: active)
        }
        .buttonStyle(.plain)
    }

    private func collectionChip(_ title: String, active: Bool) -> some View {
        Text(title)
            .font(.system(size: 12, weight: active ? .semibold : .medium))
            .foregroundStyle(active ? canvas : foreground.opacity(0.72))
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(active ? foreground : tile, in: Capsule())
    }

    private func gallery(elapsed: TimeInterval) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 136, maximum: 200), spacing: 12)], spacing: 12) {
            ForEach(filteredStyles) { style in
                Button {
                    selectedStyle = style
                } label: {
                    VStack(spacing: 0) {
                        HStack {
                            Text(String(format: "%02d", style.number))
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundStyle(secondary)
                            Spacer()
                            if style.number > 32 {
                                Text("NEW")
                                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                                    .tracking(0.7)
                                    .foregroundStyle(secondary)
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 14)
                        Spacer(minLength: 8)
                        MonoLoadingGlyph(style: style, size: size, color: foreground,
                                         elapsed: elapsed, reduceMotion: reduceMotion)
                            .frame(height: 72)
                        Spacer(minLength: 8)
                        VStack(spacing: 4) {
                            Text(style.label)
                                .font(.system(size: 11, weight: .medium))
                                .lineLimit(1)
                            Text(style.chineseLabel)
                                .font(.system(size: 10))
                                .foregroundStyle(secondary)
                        }
                        .foregroundStyle(foreground)
                        .padding(.bottom, 15)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
                    .background(tile, in: RoundedRectangle(cornerRadius: 18))
                    .contentShape(RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("style-\(style.number)")
                .accessibilityLabel("\(style.number), \(style.label)")
            }
        }
        .overlay {
            if filteredStyles.isEmpty {
                Text("No matching styles")
                    .font(.system(size: 14))
                    .foregroundStyle(secondary)
                    .frame(maxWidth: .infinity, minHeight: 160)
            }
        }
    }

    private var footer: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark.circle")
            Text("Built with SwiftUI Canvas · MIT License")
        }
        .font(.system(size: 11))
        .foregroundStyle(secondary)
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
}

private struct DemoStyleDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let style: MonoLoadingStyle
    let isDark: Bool
    @State private var size: Double = 64
    @State private var speed: Double = 1
    @State private var playing = true
    @State private var didCopy = false

    private var fg: Color { isDark ? .white : .black }
    private var bg: Color { isDark ? Color(red: 0.075, green: 0.078, blue: 0.085) : .white }

    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(String(format: "STYLE %02d", style.number))
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(.secondary)
                    Text(style.label)
                        .font(.system(size: 24, weight: .semibold))
                    Text(style.chineseLabel)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, 12)
            Spacer(minLength: 0)
            MonoLoadingView(style: style, size: size, color: fg,
                            speed: speed, isAnimating: playing)
                .frame(width: 120, height: 120)
                .accessibilityIdentifier("detail-loading")
            Spacer(minLength: 0)
            HStack {
                Text("Size")
                Slider(value: $size, in: 20...112, step: 1).tint(fg)
                Text("\(Int(size))").monospacedDigit()
            }
            HStack {
                Text("Speed")
                Slider(value: $speed, in: 0.25...3, step: 0.25).tint(fg)
                Text(String(format: "%.2f×", speed)).monospacedDigit()
            }
            .font(.system(size: 13))
            HStack(spacing: 12) {
                Button {
                    playing.toggle()
                } label: {
                    Label(playing ? "Pause" : "Play", systemImage: playing ? "pause.fill" : "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                Button {
                    UIPasteboard.general.string =
                        "MonoLoadingView(style: .\(style.rawValue), size: 28, color: .primary)"
                    didCopy = true
                } label: {
                    Label(didCopy ? "Copied" : "Copy Swift", systemImage: didCopy ? "checkmark" : "doc.on.doc")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(fg)
                .foregroundStyle(bg)
            }
            .font(.system(size: 13, weight: .medium))
        }
        .foregroundStyle(fg)
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bg.ignoresSafeArea())
        .preferredColorScheme(isDark ? .dark : .light)
    }
}

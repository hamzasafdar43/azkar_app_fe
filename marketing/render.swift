// Composes the marketing film from the storyboard, the captured screenshots
// and the synthesised bed — with AVFoundation and CoreText, so there is
// nothing to install. `design/rasterize.swift` makes the same bet for the
// icons and for the same reason: this machine's Homebrew belongs to another
// account, and a marketing asset should not need a package manager.
//
//     swift render.swift [storyboard.json] [out.mp4]
//
// Three passes: draw every frame into a silent .mov, transcode the WAV bed to
// AAC, then mux the two by passthrough so the pictures are encoded exactly
// once.

import AVFoundation
import AppKit
import CoreText

// MARK: - Storyboard

struct Scene: Decodable {
    let kind: String
    let dur: Double
    let xfade: Double?
    let theme: String?
    let image: String?
    let caption: String?
    let mark: Bool?
    let title: String?
    let arabic: String?
    let sub: String?
    let pan: Double?
}

struct Board: Decodable {
    let width: Int
    let height: Int
    let fps: Int
    let audio: String
    let fadeIn: Double?
    let fadeOut: Double?
    let scenes: [Scene]
}

// MARK: - Palette
//
// Lifted from `lib/src/ui/theme.dart`. The video has no colour of its own:
// if the app's paper changes, these change with it and nothing else does.

struct Palette {
    let paper: CGColor
    let raised: CGColor
    let ink: CGColor
    let accent: CGColor
    let bezel: CGColor

    static func rgb(_ hex: UInt32, _ a: CGFloat = 1) -> CGColor {
        CGColor(red: CGFloat((hex >> 16) & 0xFF) / 255,
                green: CGFloat((hex >> 8) & 0xFF) / 255,
                blue: CGFloat(hex & 0xFF) / 255, alpha: a)
    }

    static let light = Palette(paper: rgb(0xFBF7F0), raised: rgb(0xFFFDF9),
                               ink: rgb(0x1B211F), accent: rgb(0x2E6E64),
                               bezel: rgb(0x1B211F, 0.90))
    // The dark accent is the app's teal lifted for a dark ground, the same
    // move `sakinahTheme` makes when the brightness flips.
    static let dark = Palette(paper: rgb(0x111614), raised: rgb(0x1C2420),
                              ink: rgb(0xECE7DE), accent: rgb(0x7FD1BE),
                              bezel: rgb(0x39413D))

    func ink(_ a: CGFloat) -> CGColor { ink.copy(alpha: a)! }
}

// MARK: - Text

let arabicFontLoaded: Bool = {
    let url = URL(fileURLWithPath: "../assets/fonts/Amiri-Regular.ttf")
    return CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
}()

func latin(_ size: CGFloat, _ weight: NSFont.Weight) -> NSFont {
    NSFont.systemFont(ofSize: size, weight: weight)
}

func amiri(_ size: CGFloat) -> NSFont {
    _ = arabicFontLoaded
    return NSFont(name: "Amiri", size: size) ?? latin(size, .regular)
}

struct Block {
    let frame: CTFrame
    let size: CGSize
}

/// Lays a centred, wrapped paragraph out and measures it, so a caption can be
/// positioned by its real height rather than by a guess at its line count.
func layout(_ text: String, font: NSFont, color: CGColor,
            maxWidth: CGFloat, lineMultiple: CGFloat = 1.25,
            tracking: CGFloat = 0) -> Block {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    style.lineHeightMultiple = lineMultiple
    let attrs: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: NSColor(cgColor: color)!,
        .paragraphStyle: style,
        .kern: tracking,
    ]
    let attributed = NSAttributedString(string: text, attributes: attrs)
    let setter = CTFramesetterCreateWithAttributedString(attributed)
    let constraint = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
    var fitRange = CFRange()
    let measured = CTFramesetterSuggestFrameSizeWithConstraints(
        setter, CFRange(location: 0, length: 0), nil, constraint, &fitRange)
    // A couple of points of slack: the suggested size clips a descender on
    // some faces, and a clipped descender is the sort of thing that is only
    // ever noticed once the video is published.
    let size = CGSize(width: maxWidth, height: ceil(measured.height) + 4)
    let path = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
    let frame = CTFramesetterCreateFrame(setter, CFRange(location: 0, length: 0), path, nil)
    return Block(frame: frame, size: size)
}

extension CGContext {
    /// Draws a laid-out block with its *top-left* at (x, yFromTop), taking the
    /// flip into account once here rather than at every call site.
    func draw(_ block: Block, x: CGFloat, yFromTop: CGFloat, canvasHeight: CGFloat,
              alpha: CGFloat = 1) {
        saveGState()
        setAlpha(alpha)
        translateBy(x: x, y: canvasHeight - yFromTop - block.size.height)
        CTFrameDraw(block.frame, self)
        restoreGState()
    }
}

// MARK: - Assets

var imageCache: [String: CGImage] = [:]

func loadImage(_ path: String) -> CGImage? {
    if let hit = imageCache[path] { return hit }
    guard let image = NSImage(contentsOfFile: path),
          let cg = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
    else { return nil }
    imageCache[path] = cg
    return cg
}

let iconPath = "../ios/Runner/Assets.xcassets/AppIcon.appiconset/Tasbih-1024.png"

// MARK: - Scene drawing

/// Eased 0…1. Everything in this film moves on this curve; nothing moves
/// linearly, because linear motion is the thing that reads as "a slideshow".
func ease(_ t: Double) -> Double {
    let t = min(max(t, 0), 1)
    return t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
}

func background(_ ctx: CGContext, _ p: Palette, _ w: CGFloat, _ h: CGFloat) {
    ctx.setFillColor(p.paper)
    ctx.fill(CGRect(x: 0, y: 0, width: w, height: h))
    // One soft pool of light, a little above centre. It is what stops 1080
    // by 1920 of flat colour reading as a placeholder.
    let space = CGColorSpaceCreateDeviceRGB()
    if let gradient = CGGradient(colorsSpace: space,
                                 colors: [p.raised, p.paper] as CFArray,
                                 locations: [0, 1]) {
        let centre = CGPoint(x: w / 2, y: h * 0.60)
        ctx.drawRadialGradient(gradient, startCenter: centre, startRadius: 0,
                               endCenter: centre, endRadius: w * 1.02, options: [])
    }
}

/// The app icon, drawn as iOS draws it: a rounded square, its own shadow.
func drawIcon(_ ctx: CGContext, side: CGFloat, centre: CGPoint, alpha: CGFloat) {
    guard let icon = loadImage(iconPath) else { return }
    let rect = CGRect(x: centre.x - side / 2, y: centre.y - side / 2, width: side, height: side)
    let radius = side * 0.2237  // iOS's continuous-corner ratio, near enough
    ctx.saveGState()
    ctx.setAlpha(alpha)
    ctx.setShadow(offset: CGSize(width: 0, height: -side * 0.05),
                  blur: side * 0.13,
                  color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.22))
    ctx.addPath(CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil))
    ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1))
    ctx.fillPath()
    ctx.restoreGState()

    ctx.saveGState()
    ctx.setAlpha(alpha)
    ctx.addPath(CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil))
    ctx.clip()
    ctx.draw(icon, in: rect)
    ctx.restoreGState()
}

/// A screenshot in a bezel. Deliberately not a photorealistic handset: a
/// hairline frame says "this is a phone" without putting a rendered gadget
/// between the viewer and the page.
func drawPhone(_ ctx: CGContext, _ image: CGImage, rect: CGRect, _ p: Palette,
               k: CGFloat, alpha: CGFloat) {
    let bezel: CGFloat = 10 * k
    let outer = rect.insetBy(dx: -bezel, dy: -bezel)
    let screenRadius = rect.width * 0.139
    let outerRadius = screenRadius + bezel

    ctx.saveGState()
    ctx.setAlpha(alpha)
    ctx.setShadow(offset: CGSize(width: 0, height: -18 * k), blur: 46 * k,
                  color: CGColor(red: 0.05, green: 0.08, blue: 0.07, alpha: 0.30))
    ctx.addPath(CGPath(roundedRect: outer, cornerWidth: outerRadius,
                       cornerHeight: outerRadius, transform: nil))
    ctx.setFillColor(p.bezel)
    ctx.fillPath()
    ctx.restoreGState()

    ctx.saveGState()
    ctx.setAlpha(alpha)
    ctx.addPath(CGPath(roundedRect: rect, cornerWidth: screenRadius,
                       cornerHeight: screenRadius, transform: nil))
    ctx.clip()
    ctx.draw(image, in: rect)
    ctx.restoreGState()
}

func drawScene(_ scene: Scene, at local: Double, into ctx: CGContext,
               w: CGFloat, h: CGFloat) {
    let p = scene.theme == "dark" ? Palette.dark : Palette.light
    background(ctx, p, w, h)

    // Every measurement below is expressed against the 1080x1920 the piece was
    // designed at, so a second aspect ratio is a command-line argument rather
    // than a second layout to keep in step with this one.
    let k = h / 1920
    let progress = min(max(local / max(scene.dur, 0.001), 0), 1)

    switch scene.kind {
    case "title":
        // Blocks are measured, then the stack is centred as a whole, so a
        // two-line title and a three-line one both sit on the same axis.
        var blocks: [(h: CGFloat, gap: CGFloat, draw: (CGFloat) -> Void)] = []

        if scene.mark == true {
            let hasText = scene.title != nil
            let side = (hasText ? 236 : 340) * k
            blocks.append((side, hasText ? 74 * k : 0, { yTop in
                drawIcon(ctx, side: side,
                         centre: CGPoint(x: w / 2, y: h - yTop - side / 2), alpha: 1)
            }))
        }
        if let title = scene.title {
            let block = layout(title, font: latin(104 * k, .semibold), color: p.ink,
                               maxWidth: w * 0.861, lineMultiple: 1.06, tracking: -1.6 * k)
            blocks.append((block.size.height, 26 * k, { yTop in
                ctx.draw(block, x: w * 0.0695, yFromTop: yTop, canvasHeight: h)
            }))
        }
        if let arabic = scene.arabic {
            let block = layout(arabic, font: amiri(88 * k), color: p.ink(0.74),
                               maxWidth: w * 0.861, lineMultiple: 1.5)
            blocks.append((block.size.height, 34 * k, { yTop in
                ctx.draw(block, x: w * 0.0695, yFromTop: yTop, canvasHeight: h)
            }))
        }
        if let sub = scene.sub {
            let block = layout(sub, font: latin(46 * k, .regular), color: p.ink(0.62),
                               maxWidth: w * 0.824, lineMultiple: 1.34)
            blocks.append((block.size.height, 0, { yTop in
                ctx.draw(block, x: w * 0.088, yFromTop: yTop, canvasHeight: h)
            }))
        }

        let total = blocks.reduce(0) { $0 + $1.h + $1.gap }
        var cursor = (h - total) / 2

        // The whole stack rises a little and resolves. 0.9 s in, and then it
        // is still for as long as the scene lasts — the stillness is the point.
        let entry = ease(min(local / 0.9, 1))
        ctx.saveGState()
        ctx.setAlpha(entry)
        ctx.translateBy(x: 0, y: -(1 - entry) * 26 * k)
        for block in blocks {
            block.draw(cursor)
            cursor += block.h + block.gap
        }
        ctx.restoreGState()

    case "shot":
        guard let path = scene.image, let image = loadImage(path) else { return }

        // The screenshot is as large as the frame allows once the caption has
        // been given its room — never larger than it would be at 9:16, so the
        // piece does not change character when the canvas does.
        let topMargin = 118 * k
        let captionTop = h - 300 * k
        let aspect = CGFloat(image.width) / CGFloat(image.height)
        let room = captionTop - topMargin - 130 * k
        let cardWidth = min(w * 0.574, room * aspect)
        let cardHeight = cardWidth / aspect

        let panAmount = scene.pan ?? 1
        // A slow push in. 3% over four seconds is under the threshold at which
        // a viewer notices the movement, which is exactly where it should sit.
        let scale = 1 + 0.030 * panAmount * progress
        let drift = -10.0 * k * panAmount * progress

        var rect = CGRect(x: (w - cardWidth) / 2, y: h - topMargin - cardHeight,
                          width: cardWidth, height: cardHeight)
        rect = rect.insetBy(dx: -cardWidth * (scale - 1) / 2,
                            dy: -cardHeight * (scale - 1) / 2)
            .offsetBy(dx: 0, dy: drift)

        let entry = ease(min(local / 0.75, 1))
        drawPhone(ctx, image, rect: rect, p, k: k, alpha: entry)

        if let caption = scene.caption {
            let block = layout(caption, font: latin(50 * k, .medium), color: p.ink(0.88),
                               maxWidth: w * 0.843, lineMultiple: 1.28, tracking: -0.4 * k)
            // `yFromTop` counts down from the top and the context counts up
            // from the bottom; the rule sits above the caption in the latter.
            let captionTopUp = h - captionTop
            ctx.saveGState()
            ctx.setAlpha(entry)
            ctx.setFillColor(p.accent)
            ctx.fill(CGRect(x: w / 2 - 30 * k, y: captionTopUp + 44 * k,
                            width: 60 * k, height: 4 * k))
            ctx.restoreGState()
            ctx.draw(block, x: w * 0.0787, yFromTop: captionTop, canvasHeight: h, alpha: entry)
        }

    default:
        break
    }
}

// MARK: - Timeline

let boardPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "storyboard.json"
let outPath = CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : "out/sakinah.mp4"

let board = try JSONDecoder().decode(
    Board.self, from: Data(contentsOf: URL(fileURLWithPath: boardPath)))

let outWidth = CommandLine.arguments.count > 3 ? Int(CommandLine.arguments[3])! : board.width
let outHeight = CommandLine.arguments.count > 4 ? Int(CommandLine.arguments[4])! : board.height
let W = CGFloat(outWidth), H = CGFloat(outHeight)
let fps = board.fps

/// Where each scene starts, given that every scene overlaps the one before it
/// by its own crossfade.
var starts: [Double] = []
var clock = 0.0
for (i, scene) in board.scenes.enumerated() {
    if i > 0 { clock -= scene.xfade ?? 0.5 }
    starts.append(clock)
    clock += scene.dur
}
let totalSeconds = clock
let totalFrames = Int((totalSeconds * Double(fps)).rounded())

print(String(format: "%d scenes · %.2f s · %d frames · %.0fx%.0f",
             board.scenes.count, totalSeconds, totalFrames, W, H))

// MARK: - Pass one: the pictures

let outURL = URL(fileURLWithPath: outPath)
try? FileManager.default.createDirectory(
    at: outURL.deletingLastPathComponent(), withIntermediateDirectories: true)

let silentURL = outURL.deletingLastPathComponent()
    .appendingPathComponent("_silent.mov")
try? FileManager.default.removeItem(at: silentURL)

let writer = try AVAssetWriter(outputURL: silentURL, fileType: .mov)
let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: [
    AVVideoCodecKey: AVVideoCodecType.h264,
    AVVideoWidthKey: outWidth,
    AVVideoHeightKey: outHeight,
    AVVideoCompressionPropertiesKey: [
        AVVideoAverageBitRateKey: CommandLine.arguments.count > 5
            ? Int(Double(CommandLine.arguments[5])! * 1_000_000) : 9_000_000,
        AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
        AVVideoMaxKeyFrameIntervalKey: fps * 2,
    ],
])
videoInput.expectsMediaDataInRealTime = false
let adaptor = AVAssetWriterInputPixelBufferAdaptor(
    assetWriterInput: videoInput,
    sourcePixelBufferAttributes: [
        kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA),
        kCVPixelBufferWidthKey as String: outWidth,
        kCVPixelBufferHeightKey as String: outHeight,
    ])
writer.add(videoInput)
guard writer.startWriting() else { fatalError("startWriting: \(writer.error as Any)") }
writer.startSession(atSourceTime: .zero)

let space = CGColorSpaceCreateDeviceRGB()
let bitmap = CGImageAlphaInfo.premultipliedFirst.rawValue
    | CGBitmapInfo.byteOrder32Little.rawValue

func offscreen() -> CGContext {
    let ctx = CGContext(data: nil, width: outWidth, height: outHeight,
                        bitsPerComponent: 8, bytesPerRow: 0, space: space,
                        bitmapInfo: bitmap)!
    ctx.interpolationQuality = .high
    ctx.setAllowsAntialiasing(true)
    return ctx
}
let layerA = offscreen(), layerB = offscreen()

var pool: CVPixelBufferPool?
CVPixelBufferPoolCreate(nil, nil, [
    kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_32BGRA),
    kCVPixelBufferWidthKey: outWidth,
    kCVPixelBufferHeightKey: outHeight,
    kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary,
] as CFDictionary, &pool)

let queue = DispatchQueue(label: "render")
let done = DispatchSemaphore(value: 0)
var frame = 0

videoInput.requestMediaDataWhenReady(on: queue) {
    while videoInput.isReadyForMoreMediaData {
        if frame >= totalFrames {
            videoInput.markAsFinished()
            done.signal()
            return
        }
        let t = Double(frame) / Double(fps)

        // The active scene is the last one that has started; the one before it
        // is still on screen for the length of the newcomer's crossfade.
        var index = 0
        for (i, start) in starts.enumerated() where t >= start - 1e-9 { index = i }
        let scene = board.scenes[index]
        let into = t - starts[index]

        drawScene(scene, at: into, into: layerA, w: W, h: H)
        var composited = layerA.makeImage()!

        let xfade = scene.xfade ?? 0.5
        if index > 0, xfade > 0, into < xfade {
            let previous = board.scenes[index - 1]
            drawScene(previous, at: t - starts[index - 1], into: layerB, w: W, h: H)
            let under = layerB.makeImage()!
            // Crossfade as a compositing step over flat, fully drawn layers —
            // per-element alpha would double-darken every shadow in the frame.
            let mix = offscreen()
            mix.draw(under, in: CGRect(x: 0, y: 0, width: W, height: H))
            mix.setAlpha(CGFloat(ease(into / xfade)))
            mix.draw(composited, in: CGRect(x: 0, y: 0, width: W, height: H))
            composited = mix.makeImage()!
        }

        var buffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil, pool!, &buffer)
        guard let pixels = buffer else { fatalError("no pixel buffer") }
        CVPixelBufferLockBaseAddress(pixels, [])
        let ctx = CGContext(data: CVPixelBufferGetBaseAddress(pixels),
                            width: outWidth, height: outHeight,
                            bitsPerComponent: 8,
                            bytesPerRow: CVPixelBufferGetBytesPerRow(pixels),
                            space: space, bitmapInfo: bitmap)!
        ctx.draw(composited, in: CGRect(x: 0, y: 0, width: W, height: H))

        // Open on the page and close on it. Fading to black would make the
        // last thing the viewer sees a void, which is the one note this app
        // is not allowed to end on.
        let paper = (board.scenes.last?.theme == "dark" ? Palette.dark : Palette.light).paper
        let fadeIn = board.fadeIn ?? 0, fadeOut = board.fadeOut ?? 0
        var veil = 0.0
        if fadeIn > 0, t < fadeIn { veil = 1 - ease(t / fadeIn) }
        if fadeOut > 0, t > totalSeconds - fadeOut {
            veil = max(veil, 1 - ease((totalSeconds - t) / fadeOut))
        }
        if veil > 0.001 {
            ctx.setFillColor(paper.copy(alpha: CGFloat(veil))!)
            ctx.fill(CGRect(x: 0, y: 0, width: W, height: H))
        }
        CVPixelBufferUnlockBaseAddress(pixels, [])

        adaptor.append(pixels, withPresentationTime:
            CMTime(value: CMTimeValue(frame), timescale: CMTimeScale(fps)))
        frame += 1
        if frame % 150 == 0 {
            print("  \(frame)/\(totalFrames)")
        }
    }
}

done.wait()
let finished = DispatchSemaphore(value: 0)
writer.finishWriting { finished.signal() }
finished.wait()
if writer.status != .completed { fatalError("video: \(writer.error as Any)") }
print("  pictures done")

// MARK: - Pass two: the bed, as AAC

let videoDuration = CMTime(value: CMTimeValue(totalFrames), timescale: CMTimeScale(fps))
let m4aURL = outURL.deletingLastPathComponent().appendingPathComponent("_bed.m4a")
try? FileManager.default.removeItem(at: m4aURL)

let wav = AVURLAsset(url: URL(fileURLWithPath: board.audio))
guard let audioExport = AVAssetExportSession(
    asset: wav, presetName: AVAssetExportPresetAppleM4A) else {
    fatalError("no audio export session")
}
audioExport.outputURL = m4aURL
audioExport.outputFileType = .m4a
audioExport.timeRange = CMTimeRange(start: .zero, duration: videoDuration)
let audioDone = DispatchSemaphore(value: 0)
audioExport.exportAsynchronously { audioDone.signal() }
audioDone.wait()
if audioExport.status != .completed { fatalError("audio: \(audioExport.error as Any)") }

// MARK: - Pass three: mux

let composition = AVMutableComposition()
let pictures = AVURLAsset(url: silentURL)
let bed = AVURLAsset(url: m4aURL)

guard let pictureTrack = pictures.tracks(withMediaType: .video).first,
      let bedTrack = bed.tracks(withMediaType: .audio).first else {
    fatalError("missing track")
}
let vTrack = composition.addMutableTrack(withMediaType: .video,
                                         preferredTrackID: kCMPersistentTrackID_Invalid)!
try vTrack.insertTimeRange(CMTimeRange(start: .zero, duration: videoDuration),
                           of: pictureTrack, at: .zero)
let aTrack = composition.addMutableTrack(withMediaType: .audio,
                                         preferredTrackID: kCMPersistentTrackID_Invalid)!
try aTrack.insertTimeRange(CMTimeRange(start: .zero, duration: videoDuration),
                           of: bedTrack, at: .zero)

try? FileManager.default.removeItem(at: outURL)
guard let mux = AVAssetExportSession(asset: composition,
                                     presetName: AVAssetExportPresetPassthrough) else {
    fatalError("no mux session")
}
mux.outputURL = outURL
mux.outputFileType = .mp4
let muxDone = DispatchSemaphore(value: 0)
mux.exportAsynchronously { muxDone.signal() }
muxDone.wait()
if mux.status != .completed { fatalError("mux: \(mux.error as Any)") }

try? FileManager.default.removeItem(at: silentURL)
try? FileManager.default.removeItem(at: m4aURL)

let bytes = (try? FileManager.default.attributesOfItem(atPath: outPath)[.size] as? Int) ?? 0
print(String(format: "%@  %.2f s  %.1f MB", outPath, totalSeconds,
             Double(bytes ?? 0) / 1_048_576))

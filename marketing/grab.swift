// Pulls stills out of a rendered film so the composition can be checked
// without a player. `swift grab.swift out/sakinah.mp4 out/grabs 1 5 12 …`
import AVFoundation
import AppKit

let args = CommandLine.arguments
let asset = AVURLAsset(url: URL(fileURLWithPath: args[1]))
let dir = args[2]
try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)

let gen = AVAssetImageGenerator(asset: asset)
gen.appliesPreferredTrackTransform = true
gen.requestedTimeToleranceBefore = .zero
gen.requestedTimeToleranceAfter = .zero
gen.maximumSize = CGSize(width: 540, height: 960)

for raw in args.dropFirst(3) {
    let seconds = Double(raw)!
    let time = CMTime(seconds: seconds, preferredTimescale: 600)
    let image = try gen.copyCGImage(at: time, actualTime: nil)
    let out = URL(fileURLWithPath: "\(dir)/t\(raw).png")
    let dest = CGImageDestinationCreateWithURL(out as CFURL, "public.png" as CFString, 1, nil)!
    CGImageDestinationAddImage(dest, image, nil)
    CGImageDestinationFinalize(dest)
    print("  \(out.lastPathComponent)")
}

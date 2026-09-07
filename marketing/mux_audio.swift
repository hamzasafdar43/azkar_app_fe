// Replace the audio on an existing film without re-encoding the pictures.
//
//     swift mux_audio.swift video.mp4 audio.wav out.mp4
//
// Same three-piece bet as render.swift: transcode the WAV to AAC, then mux
// by passthrough so the H.264 is copied byte-for-byte.

import AVFoundation
import Foundation

guard CommandLine.arguments.count >= 4 else {
    fputs("usage: swift mux_audio.swift video.mp4 audio.wav out.mp4\n", stderr)
    exit(2)
}

let videoURL = URL(fileURLWithPath: CommandLine.arguments[1])
let wavURL   = URL(fileURLWithPath: CommandLine.arguments[2])
let outURL   = URL(fileURLWithPath: CommandLine.arguments[3])

let pictures = AVURLAsset(url: videoURL)
guard let pictureTrack = pictures.tracks(withMediaType: .video).first else {
    fatalError("no video track in \(videoURL.path)")
}
let videoDuration = pictures.duration
print(String(format: "video  %.2f s", CMTimeGetSeconds(videoDuration)))

let tmpDir = outURL.deletingLastPathComponent()
let m4aURL = tmpDir.appendingPathComponent("_bed.m4a")
try? FileManager.default.removeItem(at: m4aURL)

let wav = AVURLAsset(url: wavURL)
guard let audioExport = AVAssetExportSession(
    asset: wav, presetName: AVAssetExportPresetAppleM4A) else {
    fatalError("no audio export session")
}
audioExport.outputURL = m4aURL
audioExport.outputFileType = .m4a
let wavDur = wav.duration
let cut = CMTimeMinimum(wavDur, videoDuration)
audioExport.timeRange = CMTimeRange(start: .zero, duration: cut)
let audioDone = DispatchSemaphore(value: 0)
audioExport.exportAsynchronously { audioDone.signal() }
audioDone.wait()
if audioExport.status != .completed { fatalError("audio: \(audioExport.error as Any)") }

let bed = AVURLAsset(url: m4aURL)
guard let bedTrack = bed.tracks(withMediaType: .audio).first else {
    fatalError("no audio track after transcode")
}

let composition = AVMutableComposition()
let vTrack = composition.addMutableTrack(withMediaType: .video,
                                         preferredTrackID: kCMPersistentTrackID_Invalid)!
try vTrack.insertTimeRange(CMTimeRange(start: .zero, duration: videoDuration),
                           of: pictureTrack, at: .zero)
vTrack.preferredTransform = pictureTrack.preferredTransform

let aTrack = composition.addMutableTrack(withMediaType: .audio,
                                         preferredTrackID: kCMPersistentTrackID_Invalid)!
try aTrack.insertTimeRange(CMTimeRange(start: .zero, duration: cut),
                           of: bedTrack, at: .zero)

let tmpOut = tmpDir.appendingPathComponent("_muxed.mp4")
try? FileManager.default.removeItem(at: tmpOut)
guard let mux = AVAssetExportSession(asset: composition,
                                     presetName: AVAssetExportPresetPassthrough) else {
    fatalError("no mux session")
}
mux.outputURL = tmpOut
mux.outputFileType = .mp4
let muxDone = DispatchSemaphore(value: 0)
mux.exportAsynchronously { muxDone.signal() }
muxDone.wait()
if mux.status != .completed { fatalError("mux: \(mux.error as Any)") }

try? FileManager.default.removeItem(at: m4aURL)
try? FileManager.default.removeItem(at: outURL)
try FileManager.default.moveItem(at: tmpOut, to: outURL)

let bytes = (try? FileManager.default.attributesOfItem(atPath: outURL.path)[.size] as? Int) ?? 0
print(String(format: "%@  %.2f s  %.1f MB", outURL.path, CMTimeGetSeconds(videoDuration),
             Double(bytes) / 1_048_576))

"""Trim a downloaded track to the film and give it the same in/out as the pictures.

    python3 prepare_bed.py src.wav dst.wav seconds
"""
import array
import math
import sys
import wave

src, dst, seconds = sys.argv[1], sys.argv[2], float(sys.argv[3])
fade_in, fade_out, gain = 0.7, 1.5, float(sys.argv[4]) if len(sys.argv) > 4 else 0.52

with wave.open(src, "rb") as f:
    ch, sw, sr = f.getnchannels(), f.getsampwidth(), f.getframerate()
    if sw != 2:
        sys.exit(f"need 16-bit wav, got {sw * 8}-bit")
    samples = array.array("h")
    samples.frombytes(f.readframes(f.getnframes()))

take = int(seconds * sr) * ch
if take > len(samples):
    sys.exit(f"source is shorter than {seconds:.2f}s")
samples = samples[:take]
nframes = len(samples) // ch

for i in range(nframes):
    t = i / sr
    g = gain
    if t < fade_in:
        g *= 0.5 - 0.5 * math.cos(math.pi * t / fade_in)
    remain = seconds - t
    if remain < fade_out:
        g *= max(0.0, remain / fade_out) ** 1.2
    for c in range(ch):
        idx = i * ch + c
        samples[idx] = int(max(-32767, min(32767, samples[idx] * g)))

with wave.open(dst, "wb") as f:
    f.setnchannels(ch)
    f.setsampwidth(2)
    f.setframerate(sr)
    f.writeframes(samples.tobytes())

print(f"{dst}  {seconds:.2f}s  gain={gain}")

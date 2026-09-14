"""The video's background bed, synthesised from nothing.

There is no sample and no recording in here, so there is nothing to licence
and nothing for a platform's content matcher to claim. Two layers:

  * a **drone** on D, its fifth and its octave, which never stops and is
    what makes the thing feel still rather than merely quiet;
  * a **melody** of long single notes in *maqam Hijaz* on D — the augmented
    second between Eb and F# is the interval that reads as Arab rather than
    as European, and it is the whole reason the bed sounds like this app
    instead of like a meditation stock track.

The voice is additive: a fundamental with a little second and third harmonic,
which lands somewhere near a ney and, more to the point, nowhere near a
synthesiser pad. Envelopes are raised-cosine in and exponential out, so no
note has an edge on it.

    python3 soundtrack.py bed.wav [seconds]
"""

import array
import math
import sys
import wave

SR = 44100

# Maqam Hijaz on D. The Eb–F# step is an augmented second; equal temperament
# is a compromise here (the true jins wants Eb a touch high) but a wrong-by-a-
# comma Hijaz still reads as Hijaz, and a tuning table does not.
D3, A3 = 146.83, 220.00
D4, EB4, FS4, G4, A4, BB4, C5, D5 = (
    293.66, 311.13, 369.99, 392.00, 440.00, 466.16, 523.25, 587.33
)

# (start, note, length). Sparse on purpose: the silences are where the drone
# is heard, and the drone is the calm. Nothing here resolves in a hurry —
# the line rises to the fifth and comes home, once, over the whole minute.
MELODY = [
    ( 2.0, D4,  6.0),
    ( 7.5, EB4, 5.5),
    (12.5, FS4, 6.0),
    (18.0, G4,  5.5),
    (23.0, A4,  7.0),
    (29.5, G4,  5.0),
    (34.0, FS4, 5.5),
    (39.0, EB4, 5.0),
    (43.5, D4,  8.0),
    (51.0, A3,  9.0),
]


def sine(buf, freq, start, length, amp, attack, harmonics):
    """Add one additive-sine voice into `buf` with a soft-in, long-out shape."""
    i0, i1 = int(start * SR), min(len(buf), int((start + length) * SR))
    if i1 <= i0:
        return
    span = i1 - i0
    hold = max(1, int(attack * SR))
    step = 2.0 * math.pi * freq / SR
    for i in range(i0, i1):
        t = i - i0
        # Raised cosine in; exponential out over whatever is left.
        if t < hold:
            env = 0.5 - 0.5 * math.cos(math.pi * t / hold)
        else:
            env = math.exp(-3.0 * (t - hold) / max(1, span - hold))
        phase = step * t
        s = 0.0
        for mult, level in harmonics:
            s += level * math.sin(phase * mult)
        buf[i] += amp * env * s


def build(seconds):
    n = int(seconds * SR)
    buf = [0.0] * n

    # The drone. Quiet enough that it is felt rather than listened to, and
    # detuned a hair between the octaves so it breathes instead of beating.
    for freq, amp in ((D3, 0.30), (A3, 0.16), (D4, 0.085), (D3 * 1.0007, 0.10)):
        sine(buf, freq, 0.0, seconds, amp, 6.0, ((1.0, 1.0), (2.0, 0.16)))

    for start, note, length in MELODY:
        if start >= seconds:
            continue
        sine(buf, note, start, min(length, seconds - start), 0.20, 1.6,
             ((1.0, 1.0), (2.0, 0.26), (3.0, 0.09)))

    # A slow swell across the whole thing, so it arrives and departs rather
    # than switching on. 4 s in, 6 s out.
    for i in range(n):
        t = i / SR
        g = 1.0
        if t < 4.0:
            g *= 0.5 - 0.5 * math.cos(math.pi * t / 4.0)
        if t > seconds - 6.0:
            g *= max(0.0, (seconds - t) / 6.0) ** 1.5
        buf[i] *= g

    peak = max(abs(v) for v in buf) or 1.0
    gain = 0.62 / peak
    return [v * gain for v in buf]


def write(path, mono):
    # Stereo width from an 11 ms Haas delay on the right. One delay line is
    # the cheapest honest way to stop a synthetic bed sounding like it is
    # coming out of a single point in the middle of your head.
    delay = int(0.011 * SR)
    out = array.array("h")
    for i, v in enumerate(mono):
        r = mono[i - delay] * 0.92 if i >= delay else 0.0
        out.append(int(max(-1.0, min(1.0, v)) * 32767))
        out.append(int(max(-1.0, min(1.0, r)) * 32767))
    with wave.open(path, "wb") as f:
        f.setnchannels(2)
        f.setsampwidth(2)
        f.setframerate(SR)
        f.writeframes(out.tobytes())


if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else "bed.wav"
    secs = float(sys.argv[2]) if len(sys.argv) > 2 else 60.0
    write(out, build(secs))
    print(f"{out}  {secs:.1f}s")

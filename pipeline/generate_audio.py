import math
import random
import struct
import wave
from pathlib import Path


RATE = 44_100
OUTPUT = Path("/Users/bytedance/Documents/jianghu-verdict/game/assets/audio")


def write(name, duration, sample):
    OUTPUT.mkdir(parents=True, exist_ok=True)
    with wave.open(str(OUTPUT / name), "wb") as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(RATE)
        frames = bytearray()
        for index in range(int(duration * RATE)):
            t = index / RATE
            value = max(-1.0, min(1.0, sample(t, duration)))
            frames.extend(struct.pack("<h", int(value * 32767)))
        wav.writeframes(frames)


def env(t, duration, attack=0.01, release=0.15):
    return min(1.0, t / attack) * min(1.0, (duration - t) / release)


def ui_select(t, duration):
    return math.sin(math.tau * (460 + 160 * t / duration) * t) * env(t, duration) * 0.16


def paper_pick(t, duration):
    random.seed(int(t * RATE))
    noise = random.random() * 2.0 - 1.0
    scrape = math.sin(math.tau * 180 * t) * 0.2
    return (noise * 0.18 + scrape) * env(t, duration, 0.005, 0.12)


def contradiction(t, duration):
    wood = math.sin(math.tau * 115 * t) * math.exp(-t * 9)
    metal = math.sin(math.tau * 760 * t) * math.exp(-t * 7)
    return (wood * 0.6 + metal * 0.22) * env(t, duration, 0.003, 0.1)


def seal(t, duration):
    low = math.sin(math.tau * 58 * t) * math.exp(-t * 6)
    knock = math.sin(math.tau * 145 * t) * math.exp(-t * 12)
    return (low * 0.72 + knock * 0.35) * env(t, duration, 0.002, 0.2)


def result_bell(t, duration):
    tones = (293.66, 440.0, 587.33)
    value = sum(math.sin(math.tau * tone * t) * math.exp(-t * 2.5) for tone in tones)
    return value * env(t, duration, 0.005, 0.4) * 0.13


def rain_hall(t, duration):
    random.seed(int(t * 4_000))
    rain = (random.random() * 2.0 - 1.0) * 0.045
    beam = math.sin(math.tau * 43.65 * t) * 0.1
    drum = math.sin(math.tau * 55.0 * t) * (0.5 + 0.5 * math.sin(t * 0.18)) * 0.04
    edge = min(1.0, t / 1.0, (duration - t) / 1.0)
    return (rain + beam + drum) * edge


write("ui_select.wav", 0.16, ui_select)
write("evidence_pick.wav", 0.28, paper_pick)
write("contradiction.wav", 0.52, contradiction)
write("seal.wav", 0.72, seal)
write("result_bell.wav", 1.4, result_bell)
write("rain_hall.wav", 16.0, rain_hall)
print(f"Generated original audio at {OUTPUT}")

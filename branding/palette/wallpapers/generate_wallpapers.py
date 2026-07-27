#!/usr/bin/env python3
"""Quokka OS - 追加壁紙バリエーション生成スクリプト。
palette.md のブランドカラーをそのまま使用する。実行はビルド準備時の
一度きりで、成果物のPNGを branding/palette/wallpapers/ に出力する。"""

import math
import random
from PIL import Image, ImageDraw, ImageFilter

W, H = 1920, 1080

BG = (0x00, 0x04, 0x10)
BG_ELEV = (0x0A, 0x0F, 0x1E)
BG_ELEV2 = (0x11, 0x1A, 0x2E)
CYAN = (0x00, 0xCF, 0xFE)
CYAN_GLOW = (0x7B, 0xEF, 0xFF)


def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def make_gradient():
    img = Image.new("RGB", (W, H), BG)
    px = img.load()
    cx, cy = W * 0.5, H * 0.38
    max_r = math.hypot(max(cx, W - cx), max(cy, H - cy))
    for y in range(H):
        for x in range(0, W, 2):  # 2pxステップで高速化、後でリサイズ補間
            r = math.hypot(x - cx, y - cy) / max_r
            r = min(1.0, r)
            c = lerp(BG_ELEV, BG, r ** 1.3)
            px[x, y] = c
            if x + 1 < W:
                px[x + 1, y] = c
    img = img.filter(ImageFilter.GaussianBlur(2))
    return img


def make_circuit():
    img = Image.new("RGB", (W, H), BG)
    draw = ImageDraw.Draw(img, "RGBA")

    random.seed(42)
    grid = 96
    line_color = (0x00, 0xCF, 0xFE, 18)  # 非常に薄いシアン
    node_color = (0x00, 0xCF, 0xFE, 40)

    # 横線・縦線をまばらに(全部ではなく間引いて回路っぽいノイズ感を出す)
    for gx in range(0, W + grid, grid):
        if random.random() < 0.55:
            y0 = random.randint(0, H)
            length = random.randint(120, 420)
            draw.line([(gx, y0), (gx, min(H, y0 + length))], fill=line_color, width=1)
    for gy in range(0, H + grid, grid):
        if random.random() < 0.55:
            x0 = random.randint(0, W)
            length = random.randint(150, 500)
            draw.line([(x0, gy), (min(W, x0 + length), gy)], fill=line_color, width=1)

    # 交点にノードのドットを少数配置
    for _ in range(70):
        x = random.randint(0, W)
        y = random.randint(0, H)
        r = random.choice([1, 1, 2])
        draw.ellipse([x - r, y - r, x + r, y + r], fill=node_color)

    # 右上にほんのりグロー(ロゴの雰囲気に寄せる)
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gdraw = ImageDraw.Draw(glow)
    gdraw.ellipse([W - 700, -300, W + 100, 500], fill=(0x00, 0xCF, 0xFE, 25))
    glow = glow.filter(ImageFilter.GaussianBlur(180))
    img = Image.alpha_composite(img.convert("RGBA"), glow).convert("RGB")

    return img


if __name__ == "__main__":
    make_gradient().save("quokka-wallpaper-gradient-1920x1080.png")
    make_circuit().save("quokka-wallpaper-circuit-1920x1080.png")
    print("done")

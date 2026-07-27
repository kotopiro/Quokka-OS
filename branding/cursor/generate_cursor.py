#!/usr/bin/env python3
"""Quokka OS - カーソル(left_ptr)のソースPNGを生成する。
xcursorgenでXcursorバイナリ形式にコンパイルする前段階のアセット。
正直な制約: このテーマは left_ptr(標準の矢印ポインタ)のみを独自デザインし、
それ以外のカーソル形状(テキスト選択・待機・リサイズ等)は
index.theme の Inherits=Adwaita により既存テーマから継承する一次実装。"""

from PIL import Image, ImageDraw

BG = (0x00, 0x04, 0x10, 0)  # 透明
OUTLINE = (0x00, 0x04, 0x10, 255)
CYAN = (0x00, 0xCF, 0xFE, 255)
GLOW = (0x7B, 0xEF, 0xFF, 255)


def make_arrow(size):
    img = Image.new("RGBA", (size, size), BG)
    d = ImageDraw.Draw(img)
    s = size / 32.0  # 32pxを基準にスケール

    # 矢印(標準的なleft_ptr形状に近いポリゴン)
    pts = [
        (2 * s, 1 * s), (2 * s, 24 * s), (7 * s, 19 * s),
        (10.5 * s, 27 * s), (13.5 * s, 25.5 * s), (10 * s, 18 * s),
        (18 * s, 18 * s),
    ]
    d.polygon(pts, fill=CYAN, outline=OUTLINE)
    # 先端にわずかなグロー効果として明るいシアンの縁取り
    d.line(pts + [pts[0]], fill=GLOW, width=max(1, int(s * 0.6)))
    return img


if __name__ == "__main__":
    for size, hot in [(24, (2, 1)), (32, (2, 1)), (48, (3, 2))]:
        img = make_arrow(size)
        img.save(f"left_ptr_{size}.png")
    print("done")

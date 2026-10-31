#!/usr/bin/env python3
"""Decoder do formato ASprite (Gameloft, magic 0x05DF) usado em Miami Nights 2.

Uso:
    # exporta todos os sprites do build para PNG (+ JSON de animacoes)
    python3 tools/mn2_asprite.py build/mn2 build/mn2/png

    # um unico arquivo
    python3 tools/mn2_asprite.py --one build/mn2/entries/0050_p00_asprite.bin build/mn2/png

Layout do arquivo (little-endian):
    u16  magic = 0x05DF
    u32  flags
    [flags & 1]      u16 nModules; por modulo: u8 tipo, (flags&2 ? u8 x,u8 y) , u8 w, u8 h
                     (se o byte apos o tipo == 0xFF o modulo e "especial": 8 bytes no total)
    [flags & 0x100]  u16 nFModules; por fmodule: u8 mod, s8 ox, s8 oy, u8 fl   (6 bytes c/ s16 se flags&0x400)
                        bits 0-1 de fl: flipX/flipY ; bits 6-7: 2 bits altos do indice do modulo
                     u16 nFrames; por frame: (flags&0x800 ? u8 : u16) nFM, u16 fmStart
                     [!(flags&0x1000)] retangulos dos frames (4 x s8 ou s16 por frame)
                     [flags & 0x2000]  retangulos de colisao (idem)
    [flags & 0x10000] u16 nAFrames; por aframe: u8 frame, u8 duracao, s8 ox, s8 oy, u8 fl
                      u16 nAnims; por anim: (flags&0x80000 ? u8 : u16) nAF, u16 afStart
    paleta: u16 fmt (0x8888 = ARGB32 ; 0x6505 = RGB565, 0xF81F = transparente)
            u8 nPaletas, u8 nCores (0 => 256), cores...
    u16  pixfmt: 0x27F1 RLE (byte>127 => repete proximo indice), 0x1600 4bpp, 0x0400 2bpp,
                 0x0200 1bpp, 0x5602 8bpp, 0x64F0 RLE empacotado (indice | run<<bits)
    por modulo: u16 len, dados

Sprites "esqueleto" (RES_CHARACTER 0672/0673) nao tem paleta nem pixels: seus modulos sao
slots redirecionados em tempo real para as pecas de RES_MANPARTS / RES_WOMANPARTS
(sistema paper-doll). Somente biblioteca padrao do Python.
"""
import json
import os
import struct
import sys
import zlib


def u16(b, o):
    return b[o] | (b[o + 1] << 8)


def s16(b, o):
    v = u16(b, o)
    return v - 0x10000 if v & 0x8000 else v


def s8(v):
    return v - 256 if v > 127 else v


class ASprite:
    def __init__(self, data: bytes):
        b = data
        if u16(b, 0) != 0x05DF:
            raise ValueError('magic invalida')
        n = 2
        self.flags = fl = struct.unpack_from('<I', b, n)[0]
        n += 4
        self.mod_w, self.mod_h = [], []
        if fl & 1:
            nmod = u16(b, n)
            n += 2
            for _ in range(nmod):
                n += 1
                if b[n] == 255:
                    n += 7
                    self.mod_w.append(0)
                    self.mod_h.append(0)
                    continue
                if fl & 2:
                    n += 2
                self.mod_w.append(b[n])
                self.mod_h.append(b[n + 1])
                n += 2
        self.fmodules, self.frames, self.frame_rects = [], [], []
        if fl & 0x100:
            nfm = u16(b, n)
            n += 2
            rec = 6 if fl & 0x400 else 4
            for _ in range(nfm):
                r = b[n:n + rec]
                n += rec
                if rec == 6:
                    self.fmodules.append((r[0] | ((r[5] & 0xC0) << 2), s16(r, 1), s16(r, 3), r[5] & 0x0F))
                else:
                    self.fmodules.append((r[0] | ((r[3] & 0xC0) << 2), s8(r[1]), s8(r[2]), r[3] & 0x0F))
            nfr = u16(b, n)
            n += 2
            for _ in range(nfr):
                if fl & 0x800:
                    self.frames.append((b[n], u16(b, n + 1)))
                    n += 3
                else:
                    self.frames.append((u16(b, n), u16(b, n + 2)))
                    n += 4
            if not (fl & 0x1000):
                sz = nfr * 4
                if fl & 0x400:
                    self.frame_rects = [s16(b, n + 2 * i) for i in range(sz)]
                    n += sz * 2
                else:
                    self.frame_rects = [s8(x) for x in b[n:n + sz]]
                    n += sz
            if fl & 0x2000:
                sz = nfr * 4
                n += sz * 2 if fl & 0x400 else sz
        self.aframes, self.anims = [], []
        if fl & 0x10000:
            naf = u16(b, n)
            n += 2
            for _ in range(naf):
                r = b[n:n + 5]
                n += 5
                self.aframes.append((r[0] | ((r[4] & 0xC0) << 2), r[1], s8(r[2]), s8(r[3]), r[4] & 0x0F))
            nan = u16(b, n)
            n += 2
            for _ in range(nan):
                if fl & 0x80000:
                    self.anims.append((b[n], u16(b, n + 1)))
                    n += 3
                else:
                    self.anims.append((u16(b, n), u16(b, n + 2)))
                    n += 4
        self.palettes, self.pixfmt, self.mod_data, self.ncolors = [], None, [], 0
        if self.mod_w and n < len(b):
            palfmt = u16(b, n)
            n += 2
            npal, ncol = b[n], b[n + 1] or 256
            n += 2
            self.ncolors = ncol
            for _ in range(npal):
                pal = []
                for _c in range(ncol):
                    if palfmt == 0x8888:
                        pal.append(struct.unpack_from('<I', b, n)[0])
                        n += 4
                    elif palfmt == 0x6505:
                        v = u16(b, n)
                        n += 2
                        if v == 0xF81F:
                            pal.append(0)
                        else:
                            r, g, bb = (v >> 11) & 0x1F, (v >> 5) & 0x3F, v & 0x1F
                            pal.append(0xFF000000 | (r << 19) | (g << 10) | (bb << 3))
                    else:
                        raise ValueError('formato de paleta %x' % palfmt)
                self.palettes.append(pal)
            self.pixfmt = u16(b, n)
            n += 2
            if self.pixfmt == 0x64F0:
                m, self.rle_mask, self.rle_bits = ncol - 1, 1, 0
                while m:
                    m >>= 1
                    self.rle_mask <<= 1
                    self.rle_bits += 1
                self.rle_mask -= 1
            for _ in range(len(self.mod_w)):
                ln = u16(b, n)
                n += 2
                self.mod_data.append(b[n:n + ln])
                n += ln
        self.end, self.total = n, len(b)

    def module_pixels(self, idx, pal=0):
        w, h = self.mod_w[idx], self.mod_h[idx]
        d, p, tot, f = self.mod_data[idx], self.palettes[pal], w * h, self.pixfmt
        out, n = [], 0
        if f == 0x27F1:
            while len(out) < tot:
                c = d[n]
                n += 1
                if c > 127:
                    out.extend([p[d[n]]] * (c - 128))
                    n += 1
                else:
                    out.append(p[c])
        elif f == 0x1600:
            while len(out) < tot:
                out.append(p[d[n] >> 4])
                out.append(p[d[n] & 15])
                n += 1
        elif f == 0x0400:
            while len(out) < tot:
                for s in (6, 4, 2, 0):
                    out.append(p[(d[n] >> s) & 3])
                n += 1
        elif f == 0x0200:
            while len(out) < tot:
                for s in range(7, -1, -1):
                    out.append(p[(d[n] >> s) & 1])
                n += 1
        elif f == 0x5602:
            out = [p[x] for x in d[:tot]]
        elif f == 0x64F0:
            while len(out) < tot:
                c = d[n]
                n += 1
                out.extend([p[c & self.rle_mask]] * ((c >> self.rle_bits) + 1))
        else:
            raise ValueError('pixfmt %x' % f)
        return w, h, out[:tot]

    def frame_bounds(self, fi):
        nfm, st = self.frames[fi]
        if nfm == 0:
            return 0, 0, 1, 1
        x0 = y0 = 1 << 30
        x1 = y1 = -(1 << 30)
        for k in range(nfm):
            mi, ox, oy, _ = self.fmodules[st + k]
            x0, y0 = min(x0, ox), min(y0, oy)
            x1, y1 = max(x1, ox + self.mod_w[mi]), max(y1, oy + self.mod_h[mi])
        return x0, y0, x1, y1

    def render_frame(self, fi, pal=0, canvas=None, dx=0, dy=0, flip=0):
        nfm, st = self.frames[fi]
        if canvas is None:
            x0, y0, x1, y1 = self.frame_bounds(fi)
            canvas, dx, dy = Canvas(x1 - x0, y1 - y0), -x0, -y0
        for k in range(nfm):
            mi, ox, oy, fl = self.fmodules[st + k]
            w, h, px = self.module_pixels(mi, pal)
            fl ^= flip
            for yy in range(h):
                for xx in range(w):
                    c = px[yy * w + xx]
                    if not (c >> 24):
                        continue
                    sx = (w - 1 - xx) if fl & 1 else xx
                    sy = (h - 1 - yy) if fl & 2 else yy
                    canvas.put(dx + ox + sx, dy + oy + sy, c)
        return canvas

    def anim_json(self):
        """Animacoes como lista de {frame, duracao, ox, oy, flip} - util para mapear clipes 3D."""
        out = []
        for ai, (naf, st) in enumerate(self.anims):
            out.append([dict(frame=f, dur=t, ox=ox, oy=oy, flip=fl) for (f, t, ox, oy, fl) in self.aframes[st:st + naf]])
        return out


class Canvas:
    def __init__(self, w, h):
        self.w, self.h = max(1, w), max(1, h)
        self.px = [0] * (self.w * self.h)

    def put(self, x, y, c):
        if 0 <= x < self.w and 0 <= y < self.h:
            self.px[y * self.w + x] = c

    def png(self, path):
        raw = bytearray()
        for y in range(self.h):
            raw.append(0)
            for x in range(self.w):
                c = self.px[y * self.w + x]
                raw += bytes(((c >> 16) & 255, (c >> 8) & 255, c & 255, (c >> 24) & 255))

        def chunk(t, d):
            return struct.pack('>I', len(d)) + t + d + struct.pack('>I', zlib.crc32(t + d) & 0xffffffff)
        with open(path, 'wb') as f:
            f.write(b'\x89PNG\r\n\x1a\n')
            f.write(chunk(b'IHDR', struct.pack('>IIBBBBB', self.w, self.h, 8, 6, 0, 0, 0)))
            f.write(chunk(b'IDAT', zlib.compress(bytes(raw), 9)))
            f.write(chunk(b'IEND', b''))


def frame_sheet(spr, out, pal=0):
    frames = range(len(spr.frames))
    cells = [spr.frame_bounds(f) for f in frames]
    cw = max(c[2] - c[0] for c in cells) + 2
    ch = max(c[3] - c[1] for c in cells) + 2
    cols = max(1, min(16, int(len(cells) ** 0.5) + 1))
    rows = (len(cells) + cols - 1) // cols
    cv = Canvas(cols * cw, rows * ch)
    for i, f in enumerate(frames):
        x0, y0, _, _ = cells[i]
        spr.render_frame(f, pal, cv, (i % cols) * cw + 1 - x0, (i // cols) * ch + 1 - y0)
    cv.png(out)
    return cv


def module_sheet(spr, out, pal=0):
    n = len(spr.mod_w)
    cw, ch = max(spr.mod_w) + 2, max(spr.mod_h) + 2
    cols = min(16, n)
    rows = (n + cols - 1) // cols
    cv = Canvas(cols * cw, rows * ch)
    for i in range(n):
        if spr.mod_w[i] == 0:
            continue
        w, h, px = spr.module_pixels(i, pal)
        for y in range(h):
            for x in range(w):
                c = px[y * w + x]
                if c >> 24:
                    cv.put((i % cols) * cw + 1 + x, (i // cols) * ch + 1 + y, c)
    cv.png(out)
    return cv


def export(path, out_dir):
    name = os.path.splitext(os.path.basename(path))[0]
    spr = ASprite(open(path, 'rb').read())
    info = dict(file=name, flags=hex(spr.flags), modules=len(spr.mod_w), fmodules=len(spr.fmodules),
                frames=len(spr.frames), anims=len(spr.anims), palettes=len(spr.palettes),
                pixfmt=hex(spr.pixfmt) if spr.pixfmt else None, consumed=f'{spr.end}/{spr.total}')
    if spr.palettes and spr.mod_data:
        for p in range(len(spr.palettes)):
            if spr.frames:
                frame_sheet(spr, os.path.join(out_dir, f'{name}_frames_pal{p}.png'), p)
            else:
                module_sheet(spr, os.path.join(out_dir, f'{name}_modules_pal{p}.png'), p)
    if spr.anims:
        json.dump(dict(info=info, modules=list(zip(spr.mod_w, spr.mod_h)), frames=spr.frames,
                       fmodules=spr.fmodules, anims=spr.anim_json()),
                  open(os.path.join(out_dir, f'{name}.json'), 'w'))
    return info


def main(argv):
    if len(argv) >= 4 and argv[1] == '--one':
        os.makedirs(argv[3], exist_ok=True)
        print(export(argv[2], argv[3]))
        return
    if len(argv) != 3:
        print(__doc__)
        sys.exit(1)
    build_dir, out_dir = argv[1], argv[2]
    os.makedirs(out_dir, exist_ok=True)
    manifest = json.load(open(os.path.join(build_dir, 'manifest.json')))
    for m in manifest:
        if m['kind'] != 'asprite':
            continue
        try:
            info = export(os.path.join(build_dir, 'entries', m['file']), out_dir)
            print(info)
        except Exception as ex:  # sprites corrompidos nao devem abortar o lote
            print(m['file'], 'ERRO', ex)


if __name__ == '__main__':
    main(sys.argv)

/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.microedition.lcdui.Graphics
 *  javax.microedition.lcdui.Image
 */
import javax.microedition.lcdui.Graphics;
import javax.microedition.lcdui.Image;

final class a {
    static byte[] var_byte_arr_a;
    private int var_int_c = -1;
    private int var_int_d = -1;
    public int var_int_a = -1;
    private int[][] var_int_arr_arr_a = null;
    private static int[] var_int_arr_a;
    private int var_int_e;
    public static boolean var_boolean_a;
    private int var_int_f;
    private byte[] var_byte_arr_d;
    private byte[] var_byte_arr_e;
    byte[] var_byte_arr_b;
    private byte[] var_byte_arr_f;
    private byte[] var_byte_arr_g;
    private short[] var_short_arr_b;
    private short[] var_short_arr_c;
    private byte[] var_byte_arr_h;
    private byte[] var_byte_arr_i;
    private short[] var_short_arr_d;
    private short[] var_short_arr_e;
    private int var_int_g;
    private byte[] var_byte_arr_j;
    private byte[] var_byte_arr_k;
    private short[] var_short_arr_f;
    public short[] var_short_arr_a;
    private int var_int_h;
    public byte[] var_byte_arr_c;
    public int var_int_b;
    private int[][] var_int_arr_arr_b;
    private int var_int_i;
    private boolean var_boolean_b;
    private short var_short_a;
    private int var_int_j;
    private int var_int_k;
    private byte[] var_byte_arr_l;
    private short[] var_short_arr_g;
    private Image[][] var_javax_microedition_lcdui_Image_arr_arr_a;
    private static int var_int_l;
    private static int[] var_int_arr_b;
    private static a[] var_a_arr_a;

    final int a(char c2) {
        int n = c2 & 0xFFFF;
        c2 = (char)n;
        if (n > var_byte_arr_a.length) {
            c2 = (char)(c2 - 624);
        }
        if (c2 < var_byte_arr_a.length) {
            int n2 = var_byte_arr_a[c2] & 0xFF;
            c2 = (char)n2;
            int n3 = n2 << 2;
            c2 = (char)n3;
            if (n3 < this.var_byte_arr_j.length) {
                int n4 = this.var_byte_arr_j[c2] & 0xFF;
                return (this.var_byte_arr_b[n4] & 0xFF) - this.var_byte_arr_j[c2 + '\u0001'] + this.var_byte_arr_j[1];
            }
        }
        return 0;
    }

    final int int_a() {
        return this.var_byte_arr_b[0] & 0xFF;
    }

    final int int_b() {
        return this.var_byte_arr_f[0] & 0xFF;
    }

    final void a(Graphics graphics, char c2, int n, int n2) {
        int n3 = c2 & 0xFFFF;
        c2 = (char)n3;
        if (n3 > var_byte_arr_a.length) {
            c2 = (char)(c2 - 624);
        }
        if (c2 < var_byte_arr_a.length) {
            int n4 = var_byte_arr_a[c2] & 0xFF;
            c2 = (char)n4;
            if (n4 << 2 < this.var_byte_arr_j.length) {
                this.a(graphics, 0, c2, n, n2, 0);
            }
        }
    }

    public a(byte[] byArray, int n) {
        this.a(byArray, 0);
    }

    private void a(byte[] byArray, int n) {
        try {
            int n2;
            int n3;
            int n4;
            int n5;
            int n6;
            int n7 = (byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8);
            if (n7 != 1503) {
                return;
            }
            this.var_int_e = (byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8) + ((byArray[n++] & 0xFF) << 16) + ((byArray[n++] & 0xFF) << 24);
            if ((this.var_int_e & 1) != 0) {
                this.var_int_f = (byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8);
                if (this.var_int_f > 0) {
                    if ((this.var_int_e & 2) != 0) {
                        this.var_byte_arr_d = new byte[this.var_int_f];
                        this.var_byte_arr_e = new byte[this.var_int_f];
                    }
                    this.var_byte_arr_b = new byte[this.var_int_f];
                    this.var_byte_arr_f = new byte[this.var_int_f];
                    for (n7 = 0; n7 < this.var_int_f; ++n7) {
                        if ((byArray[++n] & 0xFF) == 255) {
                            n += 7;
                            continue;
                        }
                        if ((this.var_int_e & 2) != 0) {
                            this.var_byte_arr_d[n7] = byArray[n++];
                            this.var_byte_arr_e[n7] = byArray[n++];
                        }
                        this.var_byte_arr_b[n7] = byArray[n++];
                        this.var_byte_arr_f[n7] = byArray[n++];
                    }
                }
            }
            if ((this.var_int_e & 0x100) != 0) {
                this.var_int_g = (byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8);
                if (this.var_int_g > 0) {
                    this.var_byte_arr_j = (this.var_int_e & 0x400) != 0 ? new byte[this.var_int_g * 6] : new byte[this.var_int_g << 2];
                    System.arraycopy(byArray, n, this.var_byte_arr_j, 0, this.var_byte_arr_j.length);
                    n += this.var_byte_arr_j.length;
                }
                if ((n7 = (byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8)) > 0) {
                    if ((this.var_int_e & 0x800) != 0) {
                        this.var_byte_arr_g = new byte[n7];
                        this.var_short_arr_c = new short[n7];
                        for (n6 = 0; n6 < n7; ++n6) {
                            this.var_byte_arr_g[n6] = byArray[n++];
                            this.var_short_arr_c[n6] = (short)((byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8));
                        }
                    } else {
                        this.var_short_arr_b = new short[n7];
                        this.var_short_arr_c = new short[n7];
                        for (n6 = 0; n6 < n7; ++n6) {
                            this.var_short_arr_b[n6] = (short)((byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8));
                            this.var_short_arr_c[n6] = (short)((byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8));
                        }
                    }
                    if ((this.var_int_e & 0x1000) == 0) {
                        n6 = n7 << 2;
                        if ((this.var_int_e & 0x400) == 0) {
                            this.var_byte_arr_h = new byte[n6];
                            System.arraycopy(byArray, n, this.var_byte_arr_h, 0, n6);
                            n += n6;
                        } else {
                            this.var_short_arr_d = new short[n6];
                            for (n5 = 0; n5 < n6; ++n5) {
                                this.var_short_arr_d[n5] = (short)((byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8));
                            }
                        }
                    }
                    if ((this.var_int_e & 0x2000) != 0) {
                        n6 = n7 << 2;
                        if ((this.var_int_e & 0x400) == 0) {
                            this.var_byte_arr_i = new byte[n6];
                            System.arraycopy(byArray, n, this.var_byte_arr_i, 0, n6);
                            n += n6;
                        } else {
                            this.var_short_arr_e = new short[n6];
                            for (n5 = 0; n5 < n6; ++n5) {
                                this.var_short_arr_e[n5] = (short)((byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8));
                            }
                        }
                    }
                }
            }
            if ((this.var_int_e & 0x10000) != 0) {
                this.var_int_h = (byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8);
                if (this.var_int_h > 0) {
                    this.var_byte_arr_c = new byte[this.var_int_h * 5];
                    System.arraycopy(byArray, n, this.var_byte_arr_c, 0, this.var_byte_arr_c.length);
                    n += this.var_byte_arr_c.length;
                }
                if ((n7 = (byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8)) > 0) {
                    if ((this.var_int_e & 0x80000) != 0) {
                        this.var_byte_arr_k = new byte[n7];
                        this.var_short_arr_a = new short[n7];
                        for (n6 = 0; n6 < n7; ++n6) {
                            this.var_byte_arr_k[n6] = byArray[n++];
                            this.var_short_arr_a[n6] = (short)((byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8));
                        }
                    } else {
                        this.var_short_arr_f = new short[n7];
                        this.var_short_arr_a = new short[n7];
                        for (n6 = 0; n6 < n7; ++n6) {
                            this.var_short_arr_f[n6] = (short)((byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8));
                            this.var_short_arr_a[n6] = (short)((byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8));
                        }
                    }
                }
            }
            if (this.var_int_f <= 0) {
                return;
            }
            if (n >= byArray.length) {
                return;
            }
            n7 = (short)((byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8));
            this.var_int_b = byArray[n++] & 0xFF;
            if ((n6 = byArray[n++] & 0xFF) == 0) {
                n6 = 256;
            }
            this.var_int_arr_arr_b = new int[this.var_int_b][];
            for (n5 = 0; n5 < this.var_int_b; ++n5) {
                this.var_int_arr_arr_b[n5] = new int[n6];
                if (n7 == -30584) {
                    for (n4 = 0; n4 < n6; ++n4) {
                        n3 = byArray[n++] & 0xFF;
                        n3 += (byArray[n++] & 0xFF) << 8;
                        n3 += (byArray[n++] & 0xFF) << 16;
                        if (((n3 += (byArray[n++] & 0xFF) << 24) & 0xFF000000) != -16777216) {
                            this.var_boolean_b = true;
                        }
                        this.var_int_arr_arr_b[n5][n4] = n3;
                    }
                    continue;
                }
                if (n7 != 25861) continue;
                for (n4 = 0; n4 < n6; ++n4) {
                    n3 = byArray[n++] & 0xFF;
                    int n8 = n++;
                    n2 = -16777216;
                    if ((n3 += (byArray[n8] & 0xFF) << 8) == 63519) {
                        n2 = 0;
                        this.var_boolean_b = true;
                    }
                    this.var_int_arr_arr_b[n5][n4] = n3 = n2 | (n3 & 0xF800) << 8 | (n3 & 0x7E0) << 5 | (n3 & 0x1F) << 3;
                }
            }
            this.var_short_a = (short)((byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8));
            if (this.var_short_a == 25840) {
                n5 = n6 - 1;
                this.var_int_j = 1;
                this.var_int_k = 0;
                while (n5 != 0) {
                    n5 >>= 1;
                    this.var_int_j <<= 1;
                    ++this.var_int_k;
                }
                --this.var_int_j;
            }
            if (this.var_int_f > 0) {
                this.var_short_arr_g = new short[this.var_int_f];
                n5 = 0;
                n4 = n;
                for (n3 = 0; n3 < this.var_int_f; ++n3) {
                    n2 = (byArray[n4++] & 0xFF) + ((byArray[n4++] & 0xFF) << 8);
                    this.var_short_arr_g[n3] = (short)n5;
                    n4 += n2;
                    n5 += n2;
                }
                this.var_byte_arr_l = new byte[n5];
                for (n3 = 0; n3 < this.var_int_f; ++n3) {
                    n2 = (byArray[n++] & 0xFF) + ((byArray[n++] & 0xFF) << 8);
                    System.arraycopy(byArray, n, this.var_byte_arr_l, this.var_short_arr_g[n3] & 0xFFFF, n2);
                    n += n2;
                }
            }
            return;
        }
        catch (Exception exception) {
            return;
        }
    }

    public final void void_a() {
        this.var_byte_arr_l = null;
        this.var_short_arr_g = null;
    }

    public final void a(int[] nArray, int[] nArray2, int n) {
        if (this.var_int_arr_arr_b != null) {
            int n2;
            for (n2 = 4; n2 <= 7; ++n2) {
                this.var_int_arr_arr_b[0][n2] = nArray[n2 - 4];
            }
            n2 = this.var_int_arr_arr_b[0].length - 1;
            for (int i = n; i < n2; ++i) {
                this.var_int_arr_arr_b[0][i] = nArray2[i - 8];
            }
            f.var_int_arr_l = this.var_int_arr_arr_b[0];
        }
    }

    private int[] int_arr_a(int n, int n2) {
        int[] nArray;
        block26: {
            byte[] byArray;
            int n3;
            int n4;
            int[] nArray2;
            int n5;
            int n6;
            block30: {
                block29: {
                    block28: {
                        block27: {
                            block25: {
                                if (this.var_byte_arr_l == null || this.var_short_arr_g == null) {
                                    return null;
                                }
                                n6 = this.var_byte_arr_b[n] & 0xFF;
                                n5 = this.var_byte_arr_f[n] & 0xFF;
                                nArray = var_int_arr_a;
                                if ((n2 & Integer.MIN_VALUE) != 0) {
                                    nArray2 = f.var_int_arr_l;
                                } else {
                                    try {
                                        nArray2 = this.var_int_arr_arr_b.length > this.var_int_i ? this.var_int_arr_arr_b[this.var_int_i] : this.var_int_arr_arr_b[0];
                                    }
                                    catch (Exception exception) {
                                        nArray2 = this.var_int_arr_arr_b[0];
                                    }
                                }
                                if ((n2 & 0x40000000) != 0) {
                                    if (this.var_int_a != this.var_int_d) {
                                        boolean bl;
                                        a a2 = this;
                                        if (a2.var_int_d == -1) {
                                            a2.var_int_d = d.ae;
                                        }
                                        if (a2.var_int_a == a2.var_int_d) {
                                            bl = true;
                                        } else {
                                            n4 = 0;
                                            if (a2.var_int_arr_arr_a == null) {
                                                a2.var_int_arr_arr_a = new int[a2.var_int_b][];
                                            }
                                            for (n3 = 0; n3 < a2.var_int_b; ++n3) {
                                                if (a2.var_int_arr_arr_a[n3] == null || n3 == a2.var_int_b - 1) continue;
                                                int[] nArray3 = a2.var_int_arr_arr_b[n3];
                                                int[] nArray4 = a2.var_int_arr_arr_b[n3 + 1];
                                                int n7 = a2.var_int_arr_arr_a[n3].length;
                                                for (int i = 0; i < n7; ++i) {
                                                    if ((nArray3[i] & 0xFFFFFF) == 0xFF00FF) {
                                                        n4 = 1;
                                                        a2.var_int_arr_arr_a[n3][i] = 0xFF00FF;
                                                        continue;
                                                    }
                                                    int n8 = nArray3[i] & 0xFF;
                                                    int n9 = nArray4[i] & 0xFF;
                                                    n8 += (n9 - n8) * a2.var_int_d >> 8;
                                                    a2.var_int_arr_arr_a[n3][i] = n8;
                                                    n8 = nArray3[i] >> 8 & 0xFF;
                                                    n9 = nArray4[i] >> 8 & 0xFF;
                                                    n8 += (n9 - n8) * a2.var_int_d >> 8;
                                                    int[] nArray5 = a2.var_int_arr_arr_a[n3];
                                                    int n10 = i;
                                                    nArray5[n10] = nArray5[n10] | n8 << 8;
                                                    n8 = nArray3[i] >> 16 & 0xFF;
                                                    n9 = nArray4[i] >> 16 & 0xFF;
                                                    n8 += (n9 - n8) * a2.var_int_d >> 8;
                                                    int[] nArray6 = a2.var_int_arr_arr_a[n3];
                                                    int n11 = i;
                                                    nArray6[n11] = nArray6[n11] | n8 << 16;
                                                    n8 = nArray3[i] >> 24 & 0xFF;
                                                    n9 = nArray4[i] >> 24 & 0xFF;
                                                    n8 += (n9 - n8) * a2.var_int_d >> 8;
                                                    int[] nArray7 = a2.var_int_arr_arr_a[n3];
                                                    int n12 = i;
                                                    nArray7[n12] = nArray7[n12] | n8 << 24;
                                                }
                                                a2.var_int_a = a2.var_int_d;
                                            }
                                            bl = n4 != 0 || a2.var_boolean_b;
                                        }
                                    }
                                    if (this.var_int_arr_arr_a[this.var_int_i] != null) {
                                        nArray2 = this.var_int_arr_arr_a[this.var_int_i];
                                    }
                                }
                                if (nArray2 == null) {
                                    return null;
                                }
                                byArray = this.var_byte_arr_l;
                                n = this.var_short_arr_g[n] & 0xFFFF;
                                n4 = 0;
                                n6 *= n5;
                                if (this.var_short_a != 10225) break block25;
                                while (n4 < n6) {
                                    if ((n5 = byArray[n++] & 0xFF) > 127) {
                                        n3 = byArray[n++] & 0xFF;
                                        int n13 = nArray2[n3];
                                        n5 -= 128;
                                        while (n5-- > 0) {
                                            nArray[n4++] = n13;
                                        }
                                        continue;
                                    }
                                    nArray[n4++] = nArray2[n5];
                                }
                                break block26;
                            }
                            if (this.var_short_a != 5632) break block27;
                            while (n4 < n6) {
                                nArray[n4++] = nArray2[byArray[n] >> 4 & 0xF];
                                nArray[n4++] = nArray2[byArray[n] & 0xF];
                                ++n;
                            }
                            break block26;
                        }
                        if (this.var_short_a != 1024) break block28;
                        while (n4 < n6) {
                            nArray[n4++] = nArray2[byArray[n] >> 6 & 3];
                            nArray[n4++] = nArray2[byArray[n] >> 4 & 3];
                            nArray[n4++] = nArray2[byArray[n] >> 2 & 3];
                            nArray[n4++] = nArray2[byArray[n] & 3];
                            ++n;
                        }
                        break block26;
                    }
                    if (this.var_short_a != 512) break block29;
                    while (n4 < n6) {
                        nArray[n4++] = nArray2[byArray[n] >> 7 & 1];
                        nArray[n4++] = nArray2[byArray[n] >> 6 & 1];
                        nArray[n4++] = nArray2[byArray[n] >> 5 & 1];
                        nArray[n4++] = nArray2[byArray[n] >> 4 & 1];
                        nArray[n4++] = nArray2[byArray[n] >> 3 & 1];
                        nArray[n4++] = nArray2[byArray[n] >> 2 & 1];
                        nArray[n4++] = nArray2[byArray[n] >> 1 & 1];
                        nArray[n4++] = nArray2[byArray[n] & 1];
                        ++n;
                    }
                    break block26;
                }
                if (this.var_short_a != 22018) break block30;
                while (n4 < n6) {
                    nArray[n4++] = nArray2[byArray[n++] & 0xFF];
                }
                break block26;
            }
            if (this.var_short_a != 25840) break block26;
            while (n4 < n6) {
                n5 = byArray[n++] & 0xFF;
                n3 = nArray2[n5 & this.var_int_j];
                n5 >>= this.var_int_k;
                while (n5-- >= 0) {
                    nArray[n4++] = n3;
                }
            }
        }
        return nArray;
    }

    public final void a(int n, int n2, int n3, int n4) {
        this.void_a(n, 0);
    }

    public final void void_a(int n, int n2) {
        if (this.var_javax_microedition_lcdui_Image_arr_arr_a == null) {
            this.var_javax_microedition_lcdui_Image_arr_arr_a = (n2 & Integer.MIN_VALUE) != 0 ? new Image[80][] : new Image[this.var_int_b][];
        }
        if (this.var_javax_microedition_lcdui_Image_arr_arr_a[n] == null) {
            this.var_javax_microedition_lcdui_Image_arr_arr_a[n] = new Image[this.var_int_f];
        }
    }

    public static void void_b() {
        for (int i = 0; i < 400; ++i) {
            a.var_a_arr_a[i] = null;
            a.var_int_arr_b[i] = -1;
        }
        var_int_l = 0;
    }

    public final int int_a(int n) {
        if ((this.var_int_e & 0x80000) != 0) {
            return this.var_byte_arr_k[n] & 0xFF;
        }
        return this.var_short_arr_f[n] & 0xFFFF;
    }

    private int e(int n) {
        if ((this.var_int_e & 0x800) != 0) {
            return this.var_byte_arr_g[n] & 0xFF;
        }
        return this.var_short_arr_b[n] & 0xFFFF;
    }

    public final int c() {
        if ((this.var_int_e & 0x800) != 0) {
            return this.var_byte_arr_g.length;
        }
        return this.var_short_arr_b.length;
    }

    public final void a(Graphics graphics, int n, int n2, int n3, int n4, int n5, int n6, int n7) {
        n = (this.var_short_arr_a[n] + n2) * 5;
        n2 = this.var_byte_arr_c[n] & 0xFF;
        n6 = (n5 & 1) != 0 ? 0 + this.var_byte_arr_c[n + 2] : 0 - this.var_byte_arr_c[n + 2];
        n7 = (n5 & 2) != 0 ? 0 + this.var_byte_arr_c[n + 3] : 0 - this.var_byte_arr_c[n + 3];
        this.a(graphics, n2 |= (this.var_byte_arr_c[n + 4] & 0xC0) << 2, n3 - n6, n4 - n7, n5 ^ this.var_byte_arr_c[n + 4] & 0xF, n6, n7);
    }

    public final void a(Graphics graphics, int n, int n2, int n3, int n4, int n5, int n6) {
        n5 = this.e(n);
        for (n6 = 0; n6 < n5; ++n6) {
            this.a(graphics, n, n6, n2, n3, n4);
        }
    }

    public final void b(Graphics graphics, int n, int n2, int n3, int n4, int n5, int n6) {
        n5 = this.e(n);
        for (n6 = 0; n6 < n5; ++n6) {
            this.a(graphics, n, n6, n2, n3, n4);
        }
    }

    private void a(Graphics graphics, int n, int n2, int n3, int n4, int n5) {
        if ((this.var_int_e & 0x400) != 0) {
            n = (this.var_short_arr_c[n] + n2) * 6;
            n2 = this.var_byte_arr_j[n + 5] & 0xFF;
        } else {
            n = this.var_short_arr_c[n] + n2 << 2;
            n2 = this.var_byte_arr_j[n + 3] & 0xFF;
        }
        int n6 = this.var_byte_arr_j[n] & 0xFF;
        n6 |= (n2 & 0xC0) << 2;
        if ((this.var_int_e & 0x400) != 0) {
            n3 = (n5 & 1) != 0 ? (n3 -= (short)((this.var_byte_arr_j[n + 1] & 0xFF) + ((this.var_byte_arr_j[n + 2] & 0xFF) << 8))) : (n3 += (short)((this.var_byte_arr_j[n + 1] & 0xFF) + ((this.var_byte_arr_j[n + 2] & 0xFF) << 8)));
            n4 = (n5 & 2) != 0 ? (n4 -= (short)((this.var_byte_arr_j[n + 3] & 0xFF) + ((this.var_byte_arr_j[n + 4] & 0xFF) << 8))) : (n4 += (short)((this.var_byte_arr_j[n + 3] & 0xFF) + ((this.var_byte_arr_j[n + 4] & 0xFF) << 8)));
        } else {
            n3 = (n5 & 1) != 0 ? (n3 -= this.var_byte_arr_j[n + 1]) : (n3 += this.var_byte_arr_j[n + 1]);
            n4 = (n5 & 2) != 0 ? (n4 -= this.var_byte_arr_j[n + 2]) : (n4 += this.var_byte_arr_j[n + 2]);
        }
        if (f.var_boolean_b) {
            int n7 = -1;
            a a2 = null;
            if (f.var_int_arr_j[0] == 0) {
                if (n6 >= 0 && n6 < 3) {
                    n7 = n6;
                    a2 = d.var_a_arr_a[433];
                    int n8 = f.var_int_arr_j[1] << 4;
                    a a3 = a2;
                    a2.var_int_i = n8;
                    if (f.var_boolean_c) {
                        a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_c[f.var_int_arr_j[3]], 10);
                    }
                } else if (n6 >= 3 && n6 < 6) {
                    n7 = n6 - 3;
                    a2 = d.var_a_arr_a[434 + f.var_int_arr_j[2]];
                    int n9 = f.var_int_arr_j[3] + (f.var_int_arr_j[1] << 4);
                    a a4 = a2;
                    a2.var_int_i = n9;
                    if (f.var_boolean_c) {
                        a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_c[f.var_int_arr_j[3]], 8);
                    }
                } else if (n6 >= 6 && n6 < 9) {
                    n7 = n6 - 6;
                    a2 = d.var_a_arr_a[464 + f.int_h(f.var_int_arr_j[4], 0)];
                    int n10 = f.var_int_arr_j[5] + (f.var_int_arr_j[1] << 4);
                    a a5 = a2;
                    a2.var_int_i = n10;
                    if (f.var_boolean_c) {
                        a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_b[f.var_int_arr_j[5]], 8);
                    }
                } else if (n6 >= 9 && n6 < 43) {
                    n7 = n6 - 9;
                    a2 = d.var_a_arr_a[495 + f.int_h(f.var_int_arr_j[4], f.var_int_u)];
                    int n11 = f.var_int_arr_j[5] + (f.var_int_arr_j[1] << 4);
                    a a6 = a2;
                    a2.var_int_i = n11;
                    if (f.var_boolean_c) {
                        a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_b[f.var_int_arr_j[5]], 8);
                    }
                } else if (n6 >= 43 && n6 < 56) {
                    n7 = n6 - 43;
                    a2 = d.var_a_arr_a[512 + f.var_int_arr_j[6]];
                    int n12 = f.var_int_arr_j[7] + (f.var_int_arr_j[1] << 4);
                    a a7 = a2;
                    a2.var_int_i = n12;
                    if (f.var_boolean_c) {
                        a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_b[f.var_int_arr_j[7]], 8);
                    }
                } else if (n6 >= 56 && n6 < 65) {
                    n7 = n6 - 56;
                    a2 = d.var_a_arr_a[542 + f.var_int_arr_j[8]];
                    int n13 = f.var_int_arr_j[9] + (f.var_int_arr_j[1] << 4);
                    a a8 = a2;
                    a2.var_int_i = n13;
                    if (f.var_boolean_c) {
                        a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_b[f.var_int_arr_j[9]], 8);
                    }
                } else if (n6 >= 65 && n6 < 96) {
                    n7 = n6 - 65;
                    a2 = d.var_a_arr_a[430];
                    int n14 = f.var_int_arr_j[1] << 4;
                    a a9 = a2;
                    a2.var_int_i = n14;
                    if (f.var_boolean_c) {
                        a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_b[0], 10);
                    }
                } else if (n6 >= 145 && n6 <= 275) {
                    n7 = n6 - 96;
                    a2 = d.var_a_arr_a[432];
                    int n15 = 1;
                    a a10 = a2;
                    a2.var_int_i = n15;
                } else if (n6 >= 96) {
                    n7 = n6 - 96;
                    a2 = d.var_a_arr_a[432];
                }
            } else if (n6 >= 0 && n6 < 3) {
                n7 = n6;
                a2 = d.var_a_arr_a[558];
                int n16 = f.var_int_arr_j[1] << 4;
                a a11 = a2;
                a2.var_int_i = n16;
                if (f.var_boolean_c) {
                    a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_c[f.var_int_arr_j[3]], 10);
                }
            } else if (n6 >= 3 && n6 < 6) {
                n7 = n6 - 3;
                a2 = d.var_a_arr_a[559 + f.var_int_arr_j[2]];
                int n17 = f.var_int_arr_j[3] + (f.var_int_arr_j[1] << 4);
                a a12 = a2;
                a2.var_int_i = n17;
                if (f.var_boolean_c) {
                    a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_c[f.var_int_arr_j[3]], 8);
                }
            } else if (n6 >= 6 && n6 < 10) {
                n7 = n6 - 6;
                a2 = d.var_a_arr_a[589 + f.int_h(f.var_int_arr_j[4], f.var_int_v)];
                int n18 = f.var_int_arr_j[5] + (f.var_int_arr_j[1] << 4);
                a a13 = a2;
                a2.var_int_i = n18;
                if (f.var_boolean_c) {
                    a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_b[f.var_int_arr_j[5]], 8);
                }
            } else if (n6 >= 10 && n6 < 49) {
                n7 = n6 - 10;
                a2 = d.var_a_arr_a[620 + f.int_h(f.var_int_arr_j[4], f.var_int_w)];
                int n19 = f.var_int_arr_j[5] + (f.var_int_arr_j[1] << 4);
                a a14 = a2;
                a2.var_int_i = n19;
                if (f.var_boolean_c) {
                    a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_b[f.var_int_arr_j[5]], 8);
                }
            } else if (n6 >= 49 && n6 < 60) {
                n7 = n6 - 49;
                a2 = d.var_a_arr_a[637 + f.var_int_arr_j[6]];
                int n20 = f.var_int_arr_j[7] + (f.var_int_arr_j[1] << 4);
                a a15 = a2;
                a2.var_int_i = n20;
                if (f.var_boolean_c) {
                    a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_b[f.var_int_arr_j[7]], 8);
                }
            } else if (n6 >= 60 && n6 < 69) {
                n7 = n6 - 60;
                a2 = d.var_a_arr_a[667 + f.var_int_arr_j[8]];
                int n21 = f.var_int_arr_j[9] + (f.var_int_arr_j[1] << 4);
                a a16 = a2;
                a2.var_int_i = n21;
                if (f.var_boolean_c) {
                    a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_b[f.var_int_arr_j[9]], 8);
                }
            } else if (n6 >= 69 && n6 < 100) {
                n7 = n6 - 69;
                a2 = d.var_a_arr_a[431];
                int n22 = f.var_int_arr_j[1] << 4;
                a a17 = a2;
                a2.var_int_i = n22;
                if (f.var_boolean_c) {
                    a2.a(f.var_int_arr_arr_a[f.var_int_arr_j[1]], f.var_int_arr_arr_b[0], 10);
                }
            } else if (n6 >= 149 && n6 <= 279) {
                n7 = n6 - 100;
                a2 = d.var_a_arr_a[432];
                int n23 = 1;
                a a18 = a2;
                a2.var_int_i = n23;
            } else if (n6 >= 100) {
                n7 = n6 - 100;
                a2 = d.var_a_arr_a[432];
            }
            n3 = (n5 & 1) != 0 ? (n3 -= (a2.var_byte_arr_b[n7] & 0xFF) + ((n2 & 1) == 0 ? a2.f(n7) : 0)) : (n3 += (n2 & 1) == 0 ? a2.f(n7) : 0);
            n4 = (n5 & 2) != 0 ? (n4 -= (a2.var_byte_arr_f[n7] & 0xFF) + ((n2 & 2) == 0 ? a2.g(n7) : 0)) : (n4 += (n2 & 2) == 0 ? a2.g(n7) : 0);
            a2.a(graphics, n7, n3, n4, n5 ^ n2 & 0xF);
            return;
        }
        if ((n5 & 1) != 0) {
            n3 -= this.var_byte_arr_b[n6] & 0xFF;
        }
        if ((n5 & 2) != 0) {
            n4 -= this.var_byte_arr_f[n6] & 0xFF;
        }
        this.a(graphics, n6, n3, n4, n5 ^ n2 & 0xF);
    }

    public final void a(Graphics graphics, int n, int n2, int n3, int n4) {
        int n5 = 0;
        int n6 = 0;
        if (this.var_byte_arr_b != null & this.var_byte_arr_f != null) {
            n5 = this.var_byte_arr_b[n] & 0xFF;
            n6 = this.var_byte_arr_f[n] & 0xFF;
            if (n5 <= 0 || n6 <= 0) {
                return;
            }
        }
        int n7 = graphics.getClipX();
        int n8 = graphics.getClipY();
        int n9 = graphics.getClipWidth();
        int n10 = graphics.getClipHeight();
        if (n2 + n5 < n7 || n3 + n6 < n8 || n2 >= n7 + n9 || n3 >= n8 + n10) {
            return;
        }
        if (this.var_javax_microedition_lcdui_Image_arr_arr_a == null || this.var_javax_microedition_lcdui_Image_arr_arr_a[this.var_int_i] == null || this.var_javax_microedition_lcdui_Image_arr_arr_a[this.var_int_i][n] == null) {
            int n11;
            int[] nArray = this.var_int_c >= 0 && this.var_int_d >= 0 ? this.int_arr_a(n, 0x40000000) : this.int_arr_a(n, n4);
            if (nArray == null) {
                return;
            }
            Image image = Image.createRGBImage((int[])nArray, (int)n5, (int)n6, (boolean)true);
            n9 = this.var_int_i;
            n8 = n;
            a a2 = this;
            if (var_int_arr_b == null) {
                var_int_arr_b = new int[400];
                var_a_arr_a = new a[400];
                for (n11 = 0; n11 < 400; ++n11) {
                    a.var_int_arr_b[n11] = -1;
                }
            }
            if (a2.var_javax_microedition_lcdui_Image_arr_arr_a == null || a2.var_javax_microedition_lcdui_Image_arr_arr_a[n9] == null || a2.var_javax_microedition_lcdui_Image_arr_arr_a[n9][n8] == null) {
                n11 = var_int_arr_b[var_int_l];
                int n12 = n11 & 0x3FF;
                int n13 = n11 >> 10;
                a a3 = var_a_arr_a[var_int_l];
                if (n11 > 0 && a3.var_javax_microedition_lcdui_Image_arr_arr_a != null && a3.var_javax_microedition_lcdui_Image_arr_arr_a[n13] != null && a3.var_javax_microedition_lcdui_Image_arr_arr_a[n13][n12] != null) {
                    a3.var_javax_microedition_lcdui_Image_arr_arr_a[n13][n12] = null;
                }
                a.var_int_arr_b[a.var_int_l] = n9 << 10 | n8 & 0x3FF;
                a.var_a_arr_a[a.var_int_l] = a2;
                if (a2.var_javax_microedition_lcdui_Image_arr_arr_a == null) {
                    a2.var_javax_microedition_lcdui_Image_arr_arr_a = new Image[a2.var_int_b][];
                }
                if (a2.var_javax_microedition_lcdui_Image_arr_arr_a[n9] == null) {
                    a2.var_javax_microedition_lcdui_Image_arr_arr_a[n9] = new Image[a2.var_int_f];
                }
                a2.var_javax_microedition_lcdui_Image_arr_arr_a[n9][n8] = image;
                var_int_l = (var_int_l + 1) % 400;
            }
            int n14 = n5;
            n8 = n6;
            n9 = 0;
            int n15 = 0;
            if (n2 < 0) {
                n14 += n2;
                n9 = -n2;
                n2 = 0;
            }
            if (n3 < 0) {
                n8 += n3;
                n15 = -n3;
                n3 = 0;
            }
            if (n14 <= 0 || n8 <= 0) {
                return;
            }
            if ((n4 & 4) != 0) {
                graphics.drawRGB(a.a(nArray, 0, n5, n5, n6, n4), n15 * n5 + n9, n8, n2, n3, n8, n14, this.var_boolean_b);
                return;
            }
            graphics.drawRGB(a.a(nArray, 0, n5, n5, n6, n4), n15 * n5 + n9, n5, n2, n3, n14, n8, this.var_boolean_b);
            return;
        }
        Image image = this.var_javax_microedition_lcdui_Image_arr_arr_a[this.var_int_i][n];
        if ((n4 & 1) != 0) {
            if ((n4 & 2) != 0) {
                if ((n4 & 4) != 0) {
                    graphics.drawRegion(image, 0, 0, n5, n6, 6, n2, n3, 0);
                    return;
                }
                graphics.drawRegion(image, 0, 0, n5, n6, 3, n2, n3, 0);
                return;
            }
            if ((n4 & 4) != 0) {
                graphics.drawRegion(image, 0, 0, n5, n6, 7, n2, n3, 0);
                return;
            }
            graphics.drawRegion(image, 0, 0, n5, n6, 2, n2, n3, 0);
            return;
        }
        if ((n4 & 2) != 0) {
            if ((n4 & 4) != 0) {
                graphics.drawRegion(image, 0, 0, n5, n6, 4, n2, n3, 0);
                return;
            }
            graphics.drawRegion(image, 0, 0, n5, n6, 1, n2, n3, 0);
            return;
        }
        if ((n4 & 4) != 0) {
            graphics.drawRegion(image, 0, 0, n5, n6, 5, n2, n3, 0);
            return;
        }
        graphics.drawRegion(image, 0, 0, n5, n6, 0, n2, n3, 0);
    }

    private static int[] a(int[] nArray, int n, int n2, int n3, int n4, int n5) {
        int n6;
        int n7;
        int n8;
        int n9;
        n = n3 * n4;
        if ((n5 & 1) != 0) {
            n9 = 0;
            for (n8 = n3 - 1; n9 < n8; ++n9, --n8) {
                for (n7 = 0; n7 < n; n7 += n3) {
                    n6 = nArray[n7 + n9];
                    nArray[n7 + n9] = nArray[n7 + n8];
                    nArray[n7 + n8] = n6;
                }
            }
        }
        if ((n5 & 2) != 0) {
            n9 = 0;
            for (n8 = (n4 - 1) * n3; n9 < n8; n9 += n3, n8 -= n3) {
                for (n7 = 0; n7 < n3; ++n7) {
                    n6 = nArray[n9 + n7];
                    nArray[n9 + n7] = nArray[n8 + n7];
                    nArray[n8 + n7] = n6;
                }
            }
        }
        if ((n5 & 4) == 0) {
            return nArray;
        }
        int[] nArray2 = new int[n];
        for (n9 = 0; n9 < n4; ++n9) {
            for (n8 = 0; n8 < n3; ++n8) {
                nArray2[n4 - 1 - n9 + n8 * n4] = n7 = nArray[n8 + 0 + n9 * n2];
            }
        }
        return nArray2;
    }

    public final void void_a(int n) {
        this.var_int_i = n;
    }

    public final int int_b(int n) {
        return this.var_byte_arr_f[n] & 0xFF;
    }

    private int f(int n) {
        try {
            if (this.var_byte_arr_j == null || this.var_short_arr_c == null) {
                return 0;
            }
            if ((this.var_int_e & 0x400) != 0) {
                return this.var_byte_arr_j[(this.var_short_arr_c[n] << 2) + (this.var_short_arr_c[n] << 1) + 1] & 0xFF | (this.var_byte_arr_j[(this.var_short_arr_c[n] << 2) + (this.var_short_arr_c[n] << 1) + 2] & 0xFF) << 8;
            }
            return this.var_byte_arr_j[(this.var_short_arr_c[n] << 2) + 1];
        }
        catch (Exception exception) {
            return 0;
        }
    }

    private int g(int n) {
        try {
            if (this.var_byte_arr_j == null || this.var_short_arr_c == null) {
                return 0;
            }
            if ((this.var_int_e & 0x400) != 0) {
                return this.var_byte_arr_j[(this.var_short_arr_c[n] << 2) + (this.var_short_arr_c[n] << 1) + 3] & 0xFF | (this.var_byte_arr_j[(this.var_short_arr_c[n] << 2) + (this.var_short_arr_c[n] << 1) + 4] & 0xFF) << 8;
            }
            return this.var_byte_arr_j[(this.var_short_arr_c[n] << 2) + 2];
        }
        catch (Exception exception) {
            return 0;
        }
    }

    public final int c(int n) {
        if ((this.var_int_e & 0x400) == 0) {
            return this.var_byte_arr_h[(n << 2) + 2] & 0xFF;
        }
        return this.var_short_arr_d[(n << 2) + 2] & 0xFFFF;
    }

    public final int d(int n) {
        if ((this.var_int_e & 0x400) == 0) {
            return this.var_byte_arr_h[(n << 2) + 3] & 0xFF;
        }
        return this.var_short_arr_d[(n << 2) + 3] & 0xFFFF;
    }

    public final int int_a(int n, int n2) {
        n = this.var_short_arr_c[n] << 2;
        return this.var_byte_arr_j[n + 2];
    }

    public final int b(int n, int n2) {
        n = this.var_short_arr_c[n] << 2;
        n = this.var_byte_arr_j[n] & 0xFF;
        return this.var_byte_arr_f[n] & 0xFF;
    }

    public final void a(int[] nArray, int n, int n2, int n3, int n4, int n5, int n6) {
        int n7;
        int n8;
        short s;
        short s2;
        n <<= 2;
        if ((this.var_int_e & 0x400) == 0) {
            s2 = this.var_byte_arr_h[n++];
            s = this.var_byte_arr_h[n++];
            n8 = this.var_byte_arr_h[n++] & 0xFF;
            n7 = this.var_byte_arr_h[n] & 0xFF;
        } else {
            s2 = this.var_short_arr_d[n++];
            s = this.var_short_arr_d[n++];
            n8 = this.var_short_arr_d[n++] & 0xFFFF;
            n7 = this.var_short_arr_d[n] & 0xFFFF;
        }
        n5 = (n4 & 1) != 0 ? (n5 += s2 + n8) : (n5 -= s2);
        n6 = (n4 & 2) != 0 ? (n6 += s + n7) : (n6 -= s);
        nArray[0] = n2 - (n5 << 8);
        nArray[1] = n3 - (n6 << 8);
        nArray[2] = nArray[0] + (n8 << 8);
        nArray[3] = nArray[1] + (n7 << 8);
    }

    public final void a(int[] nArray, int n, int n2, int n3, int n4, int n5, int n6, int n7) {
        n = (this.var_short_arr_a[n] + n2) * 5;
        n2 = this.var_byte_arr_c[n] & 0xFF;
        n6 = (n5 & 1) != 0 ? 0 + this.var_byte_arr_c[n + 2] : 0 - this.var_byte_arr_c[n + 2];
        n7 = (n5 & 2) != 0 ? 0 + this.var_byte_arr_c[n + 3] : 0 - this.var_byte_arr_c[n + 3];
        this.a(nArray, n2 |= (this.var_byte_arr_c[n + 4] & 0xC0) << 2, 0, 0, n5 ^ this.var_byte_arr_c[n + 4] & 0xF, n6, n7);
    }

    public final void void_b(int n) {
        if (this.var_javax_microedition_lcdui_Image_arr_arr_a != null && n < this.var_int_b && this.var_javax_microedition_lcdui_Image_arr_arr_a[n] != null) {
            for (int i = 0; i < this.var_int_f; ++i) {
                this.var_javax_microedition_lcdui_Image_arr_arr_a[n][i] = null;
            }
        }
    }

    static {
        var_int_arr_a = new int[16704];
        var_boolean_a = false;
        var_int_l = 0;
        var_int_arr_b = null;
        var_a_arr_a = null;
    }
}


/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.microedition.lcdui.Graphics
 */
import javax.microedition.lcdui.Graphics;

final class d {
    int var_int_a;
    int var_int_b;
    private int af;
    private int ag;
    private int ah;
    private int ai;
    int var_int_c;
    int var_int_d;
    boolean var_boolean_a = false;
    int var_int_e;
    a var_a_a = null;
    static a[] var_a_arr_a;
    static boolean[] var_boolean_arr_a;
    static boolean[] var_boolean_arr_b;
    static int[] var_int_arr_a;
    static int[] var_int_arr_b;
    static int[] var_int_arr_c;
    int var_int_f = -1;
    private int aj;
    int var_int_g;
    int var_int_h;
    int var_int_i;
    int var_int_j;
    private int ak;
    private int al;
    private int am;
    int var_int_k;
    int var_int_l;
    int var_int_m;
    private int an = -1;
    private int ao = -1;
    boolean var_boolean_b = true;
    boolean var_boolean_c = false;
    private boolean var_boolean_p;
    boolean var_boolean_d;
    private boolean var_boolean_q = false;
    boolean var_boolean_e = false;
    private boolean var_boolean_r = false;
    int var_int_n = 0;
    int var_int_o = -64;
    private int[] var_int_arr_r;
    byte var_byte_a;
    int var_int_p;
    int var_int_q;
    int var_int_r;
    int var_int_s;
    int[] var_int_arr_d;
    private int ap;
    short var_short_a;
    int var_int_t;
    int var_int_u = -1;
    d var_d_a = null;
    d var_d_b = null;
    public static int var_int_v;
    public static int var_int_w;
    public static boolean var_boolean_f;
    public static boolean var_boolean_g;
    public static d var_d_c;
    public static d var_d_d;
    public static d var_d_e;
    static int var_int_x;
    static int[] var_int_arr_e;
    static int[] var_int_arr_f;
    static int[] var_int_arr_g;
    static int[] var_int_arr_h;
    static int[] var_int_arr_i;
    static int var_int_y;
    static int[] var_int_arr_j;
    static int[] var_int_arr_k;
    static int[] var_int_arr_l;
    static int[] var_int_arr_m;
    static int[] var_int_arr_n;
    static int[] var_int_arr_o;
    static int[] var_int_arr_p;
    static int[] var_int_arr_q;
    static boolean var_boolean_h;
    static boolean[] var_boolean_arr_c;
    static int var_int_z;
    static int A;
    private static int aq;
    static int B;
    static int C;
    static int D;
    static int E;
    static int F;
    static int G;
    static int H;
    static int I;
    static int J;
    static int K;
    static int L;
    static int M;
    static int N;
    static int O;
    static int P;
    static int Q;
    static int R;
    static int S;
    static int T;
    static int U;
    static boolean var_boolean_i;
    static boolean var_boolean_j;
    static boolean var_boolean_k;
    static int V;
    static int W;
    private static int ar;
    private static int as;
    private static int at;
    private static int au;
    private static int av;
    static int X;
    static int Y;
    static int Z;
    static int aa;
    static int ab;
    static int ac;
    private static int[] var_int_arr_s;
    private static int[] var_int_arr_t;
    private static int aw;
    private static boolean var_boolean_s;
    public static boolean var_boolean_l;
    public int ad = -2;
    private boolean var_boolean_t = false;
    private boolean var_boolean_u = false;
    private boolean var_boolean_v = false;
    private boolean var_boolean_w = false;
    private int ax = 0;
    private int ay = 0;
    private boolean var_boolean_x = false;
    private boolean var_boolean_y = false;
    private boolean var_boolean_z = false;
    public static boolean var_boolean_m;
    public static boolean var_boolean_n;
    public static int ae;
    public static boolean var_boolean_o;
    private e var_e_a;

    public d() {
    }

    public d(int[] object, int n) {
        int n2 = 1;
        this.var_int_q = object[0];
        this.var_int_a = object[2] << 4;
        this.var_int_b = object[3] << 4;
        this.var_int_f = -1;
        this.var_short_a = (short)object[1];
        this.var_int_t = -1;
        this.var_int_c = this.var_int_a;
        this.var_int_d = this.var_int_b;
        switch (this.var_int_q) {
            case 0: {
                break;
            }
            case 1: {
                this.var_byte_a = (byte)object[5];
                this.var_int_f = object[6];
                this.var_int_k = object[8] & 0xFFFF;
                if ((this.var_int_k & 0x2000) != 0) {
                    int n3;
                    boolean bl = false;
                    int n4 = 0;
                    while (n4 < f.var_short_arr_a.length && !bl) {
                        if (f.var_short_arr_a[n4] == this.var_int_f) {
                            bl = true;
                        } else {
                            for (n3 = 0; n3 < f.var_byte_arr_arr_arr_a[n4].length; ++n3) {
                                if (f.var_byte_arr_arr_arr_a[n4][n3].length <= 2 || (n2 = f.var_short_arr_a[f.var_byte_arr_arr_arr_a[n4][n3][2]]) != this.var_int_f) continue;
                                d.var_boolean_arr_a[f.var_short_arr_a[n4]] = true;
                                bl = true;
                            }
                        }
                        if (bl) continue;
                        ++n4;
                    }
                    if (bl) {
                        n3 = f.var_byte_arr_b[3100 + (n4 << 1)];
                        if (f.var_byte_arr_arr_arr_a[n4][n3].length > 2) {
                            this.var_int_f = f.var_short_arr_a[f.var_byte_arr_arr_arr_a[n4][n3][2]];
                            d.var_boolean_arr_a[f.var_short_arr_a[n4]] = true;
                        } else {
                            this.var_int_f = f.var_short_arr_a[n4];
                        }
                        object[7] = f.var_byte_arr_arr_arr_a[n4][n3][0];
                        if ((this.var_int_k & 0x200) != 0) {
                            object[7] = object[7] + 1;
                        }
                        object[11] = f.var_byte_arr_arr_arr_a[n4][n3][1];
                        for (n3 = 0; n3 < f.var_byte_arr_arr_arr_a[n4].length; ++n3) {
                            if (f.var_byte_arr_arr_arr_a[n4][n3].length <= 2) continue;
                            n2 = f.var_short_arr_a[f.var_byte_arr_arr_arr_a[n4][n3][2]];
                            d.var_boolean_arr_a[n2] = true;
                        }
                    }
                }
                this.var_int_i = -1;
                this.var_int_g = -1;
                this.var_int_h = this.var_int_f == 115 ? 1 : object[7];
                this.var_int_r = object[9];
                this.var_int_s = object[10];
                this.o();
                n2 = 1 << object[11];
                this.var_int_arr_d = new int[2];
                this.var_int_arr_d[0] = object[12] % 1000;
                this.var_int_arr_d[1] = object[11];
                if ((this.var_int_k & 0x8000) != 0) {
                    this.void_b(true);
                }
                if ((this.var_int_k & 0x4000) != 0) {
                    d d2 = this;
                    this.var_boolean_q = true;
                }
                this.var_int_e = object[13];
                if (object[13] == 0) break;
                this.var_boolean_a = true;
                this.var_int_c = -1;
                this.var_int_d = object[13];
                break;
            }
            case 2: {
                this.var_boolean_d = true;
                this.var_byte_a = (byte)object[5];
                this.var_int_f = object[6];
                this.var_int_r = object[9];
                this.var_int_s = object[10];
                this.var_int_k = object[8] & 0xFFFF;
                this.o();
                n2 = 1 << object[11];
                this.b(object[7]);
                this.var_int_arr_d = new int[2];
                this.var_int_arr_d[0] = object[12] % 1000;
                this.var_int_arr_d[1] = object[11];
                if ((this.var_int_k & 0x8000) != 0) {
                    this.void_b(true);
                }
                if ((this.var_int_k & 0x4000) != 0) {
                    d d3 = this;
                    this.var_boolean_q = true;
                }
                this.var_int_e = object[13];
                if (object[13] == 0) break;
                this.var_boolean_a = true;
                this.var_int_c = -1;
                this.var_int_d = object[13];
                break;
            }
            case 19: {
                this.var_boolean_d = true;
                this.var_byte_a = (byte)object[5];
                int n5 = f.int_n(object[13]);
                if (n5 < 0) {
                    n5 = 0;
                }
                this.var_int_f = f.int_i(n5, 1);
                this.var_int_r = object[8];
                this.var_int_s = object[9];
                this.var_int_k = object[7] & 0xFFFF;
                this.var_int_m = object[7] & 1;
                this.o();
                n2 = 1 << object[10];
                this.b(object[6]);
                this.var_int_arr_d = new int[8];
                this.var_int_arr_d[0] = object[11] % 1000;
                this.var_int_arr_d[1] = object[10];
                if ((this.var_int_k & 0x8000) != 0) {
                    this.void_b(true);
                }
                d d4 = this;
                this.var_boolean_q = true;
                this.var_int_e = object[12];
                if (object[12] != 0) {
                    this.var_boolean_a = true;
                    this.var_int_c = -1;
                    this.var_int_d = object[12];
                }
                object[2] = 0;
                object[4] = 0;
                object[3] = 0;
                object[5] = -1;
                object[6] = 0;
                break;
            }
            case 3: {
                Object object2 = new byte[10];
                this.var_int_arr_r = new int[4];
                this.var_byte_a = (byte)object[5];
                this.var_boolean_d = true;
                this.b(object[6]);
                if (object[7] == 0) {
                    this.var_boolean_c = true;
                }
                var_d_c = this;
                int[] nArray = new int[]{7, 0, 0, 0, 0};
                this.var_d_a = new d(nArray, 0);
                object2[0] = f.var_byte_arr_b[0];
                object2[1] = f.var_byte_arr_b[1];
                object2[3] = f.var_byte_arr_b[3];
                object2[2] = f.var_byte_arr_b[90];
                object2[4] = f.var_byte_arr_b[92];
                object2[5] = f.var_byte_arr_b[93];
                object2[6] = f.var_byte_arr_b[94];
                object2[7] = f.var_byte_arr_b[95];
                object2[9] = f.var_byte_arr_b[96];
                object2[8] = f.var_byte_arr_b[3028];
                this.a((byte[])object2, 0);
                this.a(f.var_byte_arr_b, 0);
                this.var_int_arr_d = new int[13];
                for (int i = 0; i < 13; ++i) {
                    this.var_int_arr_d[i] = f.var_byte_arr_b[i];
                }
                object = this;
                A = -1;
                aq = -1;
                V = -1;
                W = -1;
                ((d)object).void_g();
                object2 = this;
                this.var_boolean_q = true;
                break;
            }
            case 4: {
                this.var_byte_a = (byte)object[5];
                this.var_boolean_d = true;
                this.b(object[7]);
                this.var_int_m = object[17] & 1;
                if (object[8] == 0) {
                    this.var_boolean_c = true;
                }
                this.var_int_r = object[9];
                this.var_int_s = object[10];
                Object object3 = new int[]{7, 0, 0, 0, 0};
                this.var_d_b = new d((int[])object3, 0);
                this.var_d_a = new d((int[])object3, 0);
                int n6 = object[20];
                if ((object[17] & 0x80) != 0) {
                    f.void_d(n6);
                }
                f.var_int_arr_k[object[6]] = n6;
                f.b(this, n6);
                this.var_int_arr_d = new int[50];
                this.var_int_arr_d[37] = object[14];
                this.var_int_arr_d[38] = 0;
                this.var_int_arr_d[12] = n6;
                d.f(this);
                this.var_int_arr_d[11] = -1;
                this.var_int_arr_d[36] = object[7];
                this.var_int_arr_d[14] = object[6];
                this.var_int_arr_d[39] = 10 + f.int_d(f.int_f()) % 11;
                this.var_int_arr_d[34] = -1;
                this.r();
                this.i(2);
                d d5 = this;
                n6 = 2;
                object3 = d5;
                d5.b(n6, true);
                if (object[16] == -1) {
                    this.b(2, false);
                } else {
                    this.b((int)object[16], false);
                }
                this.var_int_arr_d[31] = 10;
                this.var_int_arr_d[32] = (int)object[19];
                object = this;
                ((d)object).var_int_arr_d[45] = 0;
                if (f.var_int_arr_c != null) {
                    this.var_int_arr_d[22] = n;
                    f.var_int_arr_c[f.var_int_arr_a[39]] = n;
                    f.var_int_arr_a[39] = f.var_int_arr_a[39] + 1;
                }
                object3 = this;
                this.var_boolean_q = true;
                this.var_int_arr_d[46] = f.int_d(f.var_java_util_Random_a.nextInt() % 300);
                this.var_int_arr_d[47] = 0;
                this.var_int_arr_d[48] = 4;
                this.var_int_arr_d[49] = 0;
                break;
            }
            case 5: 
            case 8: {
                int n7 = object[4];
                if (n7 > 0) {
                    this.var_int_arr_d = new int[n7];
                    for (int i = 0; i < n7; ++i) {
                        this.var_int_arr_d[i] = object[i + 5];
                    }
                }
                this.var_byte_a = (byte)6;
                if (this.var_int_q == 8) {
                    this.var_int_k |= this.var_int_arr_d[3] << 12;
                    this.var_int_arr_r[0] = this.var_int_a;
                    this.var_int_arr_r[1] = this.var_int_b;
                    this.var_int_arr_r[2] = this.var_int_a + (this.var_int_arr_d[1] << 4);
                    this.var_int_arr_r[3] = this.var_int_b + (this.var_int_arr_d[2] << 4);
                    this.var_int_arr_d[9] = this.var_int_arr_d[9] % 1000;
                    this.var_int_n = (this.var_int_arr_d[10] & 0x8000) != 0 ? this.var_int_arr_d[10] | 0xFFFF0000 : this.var_int_arr_d[10];
                    this.var_int_o = (this.var_int_arr_d[11] & 0x8000) != 0 ? this.var_int_arr_d[11] | 0xFFFF0000 : this.var_int_arr_d[11];
                } else {
                    this.var_int_k |= this.var_int_arr_d[4] << 12;
                    this.var_int_arr_d[10] = this.var_int_arr_d[10] % 1000;
                    this.var_int_n = (this.var_int_arr_d[11] & 0x8000) != 0 ? this.var_int_arr_d[11] | 0xFFFF0000 : this.var_int_arr_d[11];
                    this.var_int_o = (this.var_int_arr_d[12] & 0x8000) != 0 ? this.var_int_arr_d[12] | 0xFFFF0000 : this.var_int_arr_d[12];
                }
                this.var_int_f = 0;
                break;
            }
            case 6: {
                d.var_int_arr_e[d.var_int_x] = this.var_short_a;
                d.var_int_arr_f[d.var_int_x] = this.var_int_a;
                d.var_int_arr_g[d.var_int_x] = this.var_int_b;
                d.var_int_arr_h[d.var_int_x] = this.var_int_a + (object[5] << 4);
                d.var_int_arr_i[d.var_int_x] = this.var_int_b + (object[6] << 4);
                ++var_int_x;
                break;
            }
            case 9: {
                d.var_int_arr_j[d.var_int_y] = this.var_short_a;
                d.var_int_arr_k[d.var_int_y] = this.var_int_a;
                d.var_int_arr_l[d.var_int_y] = this.var_int_b;
                d.var_int_arr_m[d.var_int_y] = this.var_int_a + (object[5] << 4);
                d.var_int_arr_n[d.var_int_y] = this.var_int_b + (object[6] << 4);
                d.var_int_arr_q[d.var_int_y] = object[7];
                int n8 = this.var_int_a + (object[5] << 4) / 2;
                int n9 = this.var_int_b + (object[6] << 4) / 2;
                d.var_int_arr_o[d.var_int_y] = n8;
                d.var_int_arr_p[d.var_int_y] = n9;
                ++var_int_y;
            }
        }
        if (this.var_int_f > -1) {
            d.var_boolean_arr_a[this.var_int_f] = true;
            int n10 = this.var_int_f;
            var_int_arr_a[n10] = var_int_arr_a[n10] | n2;
            int n11 = this.var_int_f;
            var_int_arr_b[n11] = var_int_arr_b[n11];
            int n12 = this.var_int_f;
            var_int_arr_c[n12] = var_int_arr_c[n12];
            if (f.var_int_arr_b != null) {
                f.var_int_arr_b[f.var_int_arr_a[2]] = n;
                f.var_int_arr_a[2] = f.var_int_arr_a[2] + 1;
            }
        }
    }

    private void o() {
        this.var_int_n = 0;
        this.var_int_o = -64;
    }

    static void void_a() {
        var_boolean_arr_a = new boolean[1111];
        var_boolean_arr_b = new boolean[1111];
        var_int_arr_a = new int[1111];
        var_int_arr_b = new int[1111];
        var_int_arr_c = new int[1111];
        if (var_a_arr_a == null) {
            var_a_arr_a = new a[1111];
        }
    }

    final void a(byte[] byArray, int n) {
        int n2;
        int n3 = byArray[n] * 125;
        this.var_int_f = 428 + byArray[n];
        int n4 = n3 == 0 ? 430 : 431;
        d.var_boolean_arr_a[n4] = true;
        int n5 = byArray[n + 1] << 4;
        if (n5 < 32) {
            int n6 = n4;
            var_int_arr_a[n6] = var_int_arr_a[n6] | 1 << n5;
        } else if (n5 < 64) {
            int n7 = n4;
            var_int_arr_b[n7] = var_int_arr_b[n7] | 1 << n5 - 32;
        } else {
            int n8 = n4;
            var_int_arr_c[n8] = var_int_arr_c[n8] | 1 << n5 - 64;
        }
        d.var_boolean_arr_a[432] = true;
        var_int_arr_a[432] = var_int_arr_a[432] | 1;
        d.var_boolean_arr_a[n3 + 434 + byArray[n + 2]] = true;
        n5 = byArray[n + 3] + (byArray[n + 1] << 4);
        if (n5 < 32) {
            int n9 = n3 + 434 + byArray[n + 2];
            var_int_arr_a[n9] = var_int_arr_a[n9] | 1 << n5;
        } else if (n5 < 64) {
            int n10 = n3 + 434 + byArray[n + 2];
            var_int_arr_b[n10] = var_int_arr_b[n10] | 1 << n5 - 32;
        } else {
            int n11 = n3 + 434 + byArray[n + 2];
            var_int_arr_c[n11] = var_int_arr_c[n11] | 1 << n5 - 64;
        }
        d.var_boolean_arr_a[n3 + 542 + byArray[n + 8]] = true;
        n5 = byArray[n + 9] + (byArray[n + 1] << 4);
        if (n5 < 32) {
            int n12 = n3 + 542 + byArray[n + 8];
            var_int_arr_a[n12] = var_int_arr_a[n12] | 1 << n5;
        } else if (n5 < 64) {
            int n13 = n3 + 542 + byArray[n + 8];
            var_int_arr_b[n13] = var_int_arr_b[n13] | 1 << n5 - 32;
        } else {
            int n14 = n3 + 542 + byArray[n + 8];
            var_int_arr_c[n14] = var_int_arr_c[n14] | 1 << n5 - 64;
        }
        d.var_boolean_arr_a[n3 + 433] = true;
        n5 = byArray[n + 1] << 4;
        if (n5 < 32) {
            int n15 = n3 + 433;
            var_int_arr_a[n15] = var_int_arr_a[n15] | 1 << n5;
        } else if (n5 < 64) {
            int n16 = n3 + 433;
            var_int_arr_b[n16] = var_int_arr_b[n16] | 1 << n5 - 32;
        } else {
            int n17 = n3 + 433;
            var_int_arr_c[n17] = var_int_arr_c[n17] | 1 << n5 - 64;
        }
        if (n3 == 0) {
            n2 = f.int_h((int)byArray[n + 4], 0);
            n4 = f.int_h((int)byArray[n + 4], f.var_int_u);
        } else {
            n2 = f.int_h((int)byArray[n + 4], f.var_int_v);
            n4 = f.int_h((int)byArray[n + 4], f.var_int_w);
        }
        d.var_boolean_arr_a[n3 + 464 + n2] = true;
        n5 = byArray[n + 5] + (byArray[n + 1] << 4);
        if (n5 < 32) {
            int n18 = n3 + 464 + n2;
            var_int_arr_a[n18] = var_int_arr_a[n18] | 1 << n5;
        } else if (n5 < 64) {
            int n19 = n3 + 464 + n2;
            var_int_arr_b[n19] = var_int_arr_b[n19] | 1 << n5 - 32;
        } else {
            int n20 = n3 + 464 + n2;
            var_int_arr_c[n20] = var_int_arr_c[n20] | 1 << n5 - 64;
        }
        d.var_boolean_arr_a[n3 + 495 + n4] = true;
        n5 = byArray[n + 5] + (byArray[n + 1] << 4);
        if (n5 < 32) {
            int n21 = n3 + 495 + n4;
            var_int_arr_a[n21] = var_int_arr_a[n21] | 1 << n5;
        } else if (n5 < 64) {
            int n22 = n3 + 495 + n4;
            var_int_arr_b[n22] = var_int_arr_b[n22] | 1 << n5 - 32;
        } else {
            int n23 = n3 + 495 + n4;
            var_int_arr_c[n23] = var_int_arr_c[n23] | 1 << n5 - 64;
        }
        d.var_boolean_arr_a[n3 + 512 + byArray[n + 6]] = true;
        n5 = byArray[n + 7] + (byArray[n + 1] << 4);
        if (n5 < 32) {
            int n24 = n3 + 512 + byArray[n + 6];
            var_int_arr_a[n24] = var_int_arr_a[n24] | 1 << n5;
            return;
        }
        if (n5 < 64) {
            int n25 = n3 + 512 + byArray[n + 6];
            var_int_arr_b[n25] = var_int_arr_b[n25] | 1 << n5 - 32;
            return;
        }
        int n26 = n3 + 512 + byArray[n + 6];
        var_int_arr_c[n26] = var_int_arr_c[n26] | 1 << n5 - 64;
    }

    static void void_a(int n) {
        if (n >= 428) {
            int n2 = n - 428;
            d.var_a_arr_a[n] = n2 >= 130 ? f.a((n2 -= 130) + 803, var_int_arr_a[n], var_int_arr_b[n], var_int_arr_c[n], n, false) : (n2 >= 5 ? f.a((n2 -= 5) + 678, var_int_arr_a[n], var_int_arr_b[n], var_int_arr_c[n], n, false) : f.a(n2 + 672, var_int_arr_a[n], var_int_arr_b[n], var_int_arr_c[n], n, false));
            d.var_boolean_arr_c[n] = true;
        }
    }

    static void void_b() {
        for (int i = 0; i < 1111; ++i) {
            if (var_a_arr_a[i] == null) continue;
            for (int j = 0; j < d.var_a_arr_a[i].var_int_b; ++j) {
                var_a_arr_a[i].void_b(j);
            }
            if (var_boolean_arr_a[i]) continue;
            var_a_arr_a[i].void_a();
            d.var_a_arr_a[i] = null;
        }
    }

    static boolean boolean_a(int n) {
        if (var_boolean_arr_a[n] && var_a_arr_a[n] == null) {
            if (n >= 428) {
                int n2 = n - 428;
                d.var_a_arr_a[n] = n2 >= 130 ? f.a((n2 -= 130) + 803, var_int_arr_a[n], var_int_arr_b[n], var_int_arr_c[n], n, false) : (n2 >= 5 ? f.a((n2 -= 5) + 678, var_int_arr_a[n], var_int_arr_b[n], var_int_arr_c[n], n, false) : f.a(n2 + 672, var_int_arr_a[n], var_int_arr_b[n], var_int_arr_c[n], n, false));
                if (n == 432) {
                    var_a_arr_a[n].a(1, 0, -1, -1);
                }
            } else {
                a.var_boolean_a = false;
                d.var_a_arr_a[n] = f.a_a(n + 240, var_int_arr_a[n], false);
            }
            d.var_boolean_arr_b[n] = true;
            return true;
        }
        return false;
    }

    static void void_c() {
        d.a(true, true);
    }

    static void void_a(boolean bl) {
        d.a(bl, true);
    }

    static void a(boolean n, boolean bl) {
        if (n != 0 && var_a_arr_a != null) {
            for (n = 0; n < 1111; ++n) {
                if (var_a_arr_a[n] != null) {
                    var_a_arr_a[n].void_a();
                }
                d.var_a_arr_a[n] = null;
                if (var_boolean_arr_b == null) continue;
                d.var_boolean_arr_b[n] = false;
            }
        }
        if (bl) {
            var_boolean_arr_a = null;
            var_boolean_arr_b = null;
            var_int_arr_a = null;
            var_int_arr_b = null;
            var_int_arr_c = null;
        }
    }

    /*
     * Unable to fully structure code
     */
    final void void_d() {
        block203: {
            if (this.var_boolean_c) {
                return;
            }
            if (this.var_boolean_p) {
                return;
            }
            this.af = this.var_int_a;
            this.ag = this.var_int_b;
            if (this.var_boolean_e && f.boolean_a()) {
                if (this.var_int_q == 4) {
                    f.var_int_arr_a[44] = this.var_int_a + f.var_int_x >> 4;
                    f.var_int_arr_a[45] = (this.var_int_b + f.var_int_y >> 4) - 64;
                } else {
                    f.var_int_arr_a[44] = (this.var_int_a + f.var_int_x >> 4) + this.var_int_n;
                    f.var_int_arr_a[45] = (this.var_int_b + f.var_int_y >> 4) + this.var_int_o;
                }
                f.var_boolean_arr_a[4] = true;
            }
            block0 : switch (this.var_int_q) {
                case 0: {
                    return;
                }
                case 3: {
                    f.void_a(this.var_int_a >> 4, this.var_int_b >> 4, false);
                    var1_1 = this.boolean_c();
                    var2_12 = d.B;
                    var3_17 = d.C;
                    var4_24 = d.a(this.var_int_a + var2_12, this.var_int_b + var3_17, false) == false ? 1 : 0;
                    if (var4_24 == 0) {
                        this.var_int_a += var2_12;
                        this.var_int_b += var3_17;
                    } else {
                        var4_24 = 0;
                        if (var2_12 != 0 && var3_17 != 0) {
                            if (d.a(d.var_d_c.var_int_a + var2_12, d.var_d_c.var_int_b, true)) {
                                d.var_d_c.var_int_a += var2_12;
                                var4_24 = 1;
                            } else if (d.a(d.var_d_c.var_int_a, d.var_d_c.var_int_b + var3_17, true)) {
                                d.var_d_c.var_int_b += var3_17;
                                var4_24 = 1;
                            }
                        } else if (var3_17 != 0) {
                            if (var3_17 < 0) {
                                if (d.a(d.var_d_c.var_int_a + 64, d.var_d_c.var_int_b - 32, false)) {
                                    d.var_d_c.var_int_a += 64;
                                    d.var_d_c.var_int_b -= 32;
                                    var4_24 = 1;
                                } else if (d.a(d.var_d_c.var_int_a - 64, d.var_d_c.var_int_b - 32, false)) {
                                    d.var_d_c.var_int_a -= 64;
                                    d.var_d_c.var_int_b -= 32;
                                    var4_24 = 1;
                                }
                            } else if (d.a(d.var_d_c.var_int_a + 64, d.var_d_c.var_int_b + 32, false)) {
                                d.var_d_c.var_int_a += 64;
                                d.var_d_c.var_int_b += 32;
                                var4_24 = 1;
                            } else if (d.a(d.var_d_c.var_int_a - 64, d.var_d_c.var_int_b + 32, false)) {
                                d.var_d_c.var_int_a -= 64;
                                d.var_d_c.var_int_b += 32;
                                var4_24 = 1;
                            }
                        } else if (var2_12 != 0) {
                            if (var2_12 < 0) {
                                if (d.a(d.var_d_c.var_int_a - 64, d.var_d_c.var_int_b + 32, false)) {
                                    d.var_d_c.var_int_a -= 64;
                                    d.var_d_c.var_int_b += 32;
                                    var4_24 = 1;
                                } else if (d.a(d.var_d_c.var_int_a - 64, d.var_d_c.var_int_b - 32, false)) {
                                    d.var_d_c.var_int_a -= 64;
                                    d.var_d_c.var_int_b -= 32;
                                    var4_24 = 1;
                                }
                            } else if (d.a(d.var_d_c.var_int_a + 64, d.var_d_c.var_int_b + 32, false)) {
                                d.var_d_c.var_int_a += 64;
                                d.var_d_c.var_int_b += 32;
                                var4_24 = 1;
                            } else if (d.a(d.var_d_c.var_int_a + 64, d.var_d_c.var_int_b - 32, false)) {
                                d.var_d_c.var_int_a += 64;
                                d.var_d_c.var_int_b -= 32;
                                var4_24 = 1;
                            }
                        }
                        if (var4_24 == 0) {
                            var6_29 = this.var_int_b + var3_17;
                            var5_31 = this.var_int_a + var2_12;
                            var3_18 = this;
                            var2_12 = var5_31 >> 4;
                            var4_24 = var6_29 >> 4;
                            var5_31 = f.int_b(var2_12, var4_24);
                            var4_24 = var2_12 = f.int_c(var2_12, var4_24);
                            var2_12 = var5_31;
                            var5_32 = null;
                            if (f.boolean_a(var2_12, var4_24) && (f.int_a(var2_12, var4_24) & 2) != 0) {
                                var6_29 = 0;
                                while (var5_32 == null && var6_29 < f.var_int_arr_a[3]) {
                                    var7_37 = f.var_d_arr_a[var6_29];
                                    if (var7_37 != null && (var7_37.var_int_q == 4 || var7_37.var_int_q == 19) && f.int_b(var8_38 = var7_37.var_int_a >> 4, var9_39 = var7_37.var_int_b >> 4) == var2_12 && f.int_c(var8_38, var9_39) == var4_24) {
                                        var5_32 = var7_37;
                                    }
                                    if (var5_32 != null) continue;
                                    ++var6_29;
                                }
                            }
                            if ((var2_13 = var5_32) != null) {
                                var4_24 = 0;
                                if (var2_13.var_int_q == 4) {
                                    if (var2_13.var_int_arr_d[26] == 155) {
                                        var4_24 = 1;
                                    }
                                } else if (var2_13.var_int_q == 19 && var2_13.var_int_arr_d[3] == 1 && var2_13.var_int_arr_d[5] == var3_18.var_short_a) {
                                    var4_24 = 1;
                                }
                                if (var4_24 != 0) {
                                    var4_24 = var3_18.var_int_a;
                                    var5_33 = var3_18.var_int_b;
                                    var3_18.b(var2_13.var_int_a, var2_13.var_int_b);
                                    var2_13.b(var4_24, var5_33);
                                }
                            }
                        }
                        if (!d.a(d.var_d_c.var_int_a, d.var_d_c.var_int_b, true)) {
                            d.var_d_c.var_int_a = d.var_d_c.af;
                            d.var_d_c.var_int_b = d.var_d_c.ag;
                        }
                    }
                    switch (d.var_int_z) {
                        case 4: {
                            f.void_f();
                            break;
                        }
                        case 10: {
                            f.void_f();
                            if (d.A != 3 || (this.var_int_arr_d[12] = this.var_int_arr_d[12] - 1) > 0) break;
                            var4_24 = f.int_e(this.var_int_arr_d[11]);
                            if (this.boolean_h() && var4_24 >= 0) {
                                this.g(var4_24);
                                break;
                            }
                            d.var_int_z = 0;
                            this.b(0 + this.var_int_l);
                            this.ap = 0;
                            break;
                        }
                        case 5: {
                            if (var1_1 == 0 && d.Q != 255) break;
                            d.var_boolean_i = true;
                            this.c(4);
                            d.A = 6;
                            break;
                        }
                        case 6: {
                            if (var1_1 == 0 && d.Q != 255) break;
                            d.var_boolean_i = true;
                            this.c(4);
                            d.A = 0;
                            break;
                        }
                        case 2: {
                            if (var1_1 == 0 && d.E >= 0) break;
                            if (d.E >= 0 && d.F > 1) {
                                --d.F;
                                d.var_d_c.b(1);
                                d.var_d_c.b(d.E);
                                break;
                            }
                            f.boolean_b(false);
                            d.I = 0;
                            this.c(0);
                            break;
                        }
                        case 3: {
                            if (this.boolean_h()) {
                                if (d.at == this.var_int_a && d.au == this.var_int_b) {
                                    var1_2 = this;
                                    this.var_int_a = var1_2.int_a(false);
                                    var1_2 = this;
                                    this.var_int_b = var1_2.int_b(false);
                                    d.at = 0;
                                    d.au = 0;
                                    ++this.ap;
                                    break;
                                }
                                d.at = this.var_int_a;
                                d.au = this.var_int_b;
                                var4_24 = this.int_a(true);
                                var1_1 = this.int_b(true);
                                this.f(var4_24, var1_1);
                                if (!this.boolean_a(var4_24, var1_1, 4)) break;
                                ++this.ap;
                                d.at = 0;
                                d.au = 0;
                                break;
                            }
                            if (d.ab != -1) {
                                this.var_int_a = d.ab;
                                this.var_int_b = d.ac;
                            }
                            d.ac = -1;
                            d.ab = -1;
                            this.c(d.A);
                            this.ap = 0;
                            break;
                        }
                        case 9: {
                            this.var_boolean_b = true;
                            if (this.boolean_h()) {
                                var1_3 = this;
                                var4_24 = var1_3.int_a(false);
                                var1_3 = this;
                                var1_4 = var1_3.int_b(false);
                                var2_12 = 1;
                                if (this.boolean_e()) {
                                    var2_12 = (int)f.boolean_a(this, var4_24 >> 4, var1_4 >> 4);
                                }
                                if (var2_12 != 0) {
                                    this.f(var4_24, var1_4);
                                    if (!this.boolean_a(var4_24, var1_4, 0)) break;
                                    ++this.ap;
                                    if (!this.boolean_e() || this.boolean_h()) break;
                                    this.k();
                                    break;
                                }
                                if (f.var_d_c != this) break;
                                f.void_e();
                                break;
                            }
                            if (f.var_d_c != this) break;
                            f.void_e();
                            break;
                        }
                        case 12: {
                            break;
                        }
                        case 11: {
                            if (var1_1 == 0 && !this.var_boolean_b) break;
                            this.c(0);
                            break;
                        }
                        default: {
                            if (!f.boolean_c() && !f.boolean_b()) {
                                if ((f.var_int_G & 246750) <= 0) {
                                    if (f.var_int_arr_a[0] == 0) {
                                        this.c(0);
                                    }
                                } else if (f.var_int_arr_a[0] == 0) {
                                    var3_19 = this;
                                    var5_34 = -1;
                                    var6_29 = -1;
                                    var2_12 = 8;
                                    d.B = 0;
                                    d.C = 0;
                                    if ((f.var_int_G & 65600) > 0) {
                                        var3_19.var_int_l = 1;
                                        var3_19.var_int_m = 0;
                                        var5_34 = 0;
                                    } else if ((f.var_int_G & 32784) > 0) {
                                        var3_19.var_int_m = 1;
                                        var5_34 = 1;
                                        var3_19.var_int_l = 1;
                                    }
                                    if ((f.var_int_G & 131328) > 0) {
                                        var3_19.var_int_l = 1;
                                        var6_29 = 1;
                                    } else if ((f.var_int_G & 16388) > 0) {
                                        var3_19.var_int_l = 0;
                                        var6_29 = 0;
                                    }
                                    if ((f.var_int_G & 2) > 0) {
                                        var3_19.var_int_l = 0;
                                        var6_29 = 0;
                                        var3_19.var_int_m = 1;
                                        var5_34 = 1;
                                    } else if ((f.var_int_G & 8) > 0) {
                                        var3_19.var_int_l = 0;
                                        var6_29 = 0;
                                        var3_19.var_int_m = 0;
                                        var5_34 = 0;
                                    } else if ((f.var_int_G & 128) > 0) {
                                        var3_19.var_int_l = 1;
                                        var6_29 = 1;
                                        var3_19.var_int_m = 1;
                                        var5_34 = 1;
                                    } else if ((f.var_int_G & 512) > 0) {
                                        var3_19.var_int_l = 1;
                                        var6_29 = 1;
                                        var3_19.var_int_m = 0;
                                        var5_34 = 0;
                                    }
                                    if (f.var_byte_arr_b[35] >= 70 && d.av < 4) {
                                        var2_12 = 4;
                                        ++d.av;
                                    }
                                    if (var5_34 > -1) {
                                        d.B = (var2_12 << 4) * d.var_int_arr_s[var3_19.var_int_m];
                                    }
                                    if (var6_29 > -1) {
                                        d.C = (var2_12 << 4) * d.var_int_arr_t[var3_19.var_int_l];
                                    }
                                    if (d.B != 0 && d.C != 0) {
                                        d.B = 2 * d.B / 3;
                                        d.C /= 3;
                                    } else {
                                        d.B = 4 * d.B / 5;
                                        d.C = 4 * d.C / 5;
                                    }
                                    if (d.B != 0 || d.C != 0) {
                                        d.var_boolean_l = false;
                                        f.var_int_n = 1;
                                        var3_19.c(1);
                                    }
                                    if (f.var_boolean_a && ++d.as > 5) {
                                        f.var_boolean_a = false;
                                    }
                                }
                                if ((f.var_int_F & 262176) > 0 && f.var_int_arr_a[0] == 0 && d.V >= 0) {
                                    var4_25 = null;
                                    var1_1 = f.int_b(d.V);
                                    if (var1_1 > -1) {
                                        var4_25 = f.var_d_arr_a[var1_1];
                                    }
                                    if (var4_25 != null) {
                                        if (var4_25.var_int_q != 5) {
                                            d.var_d_c.n(var4_25.var_int_a);
                                            var5_35 = var4_25.var_int_b;
                                            var3_20 = d.var_d_c;
                                            if (var5_35 > var3_20.var_int_b - 720) {
                                                var3_20.var_int_l = 1;
                                            } else if (var5_35 < var3_20.var_int_b - 720) {
                                                var3_20.var_int_l = 0;
                                            }
                                        }
                                        switch (var4_25.var_int_q) {
                                            case 5: 
                                            case 8: {
                                                if (f.var_int_m != 0 || var4_25.var_int_arr_d[0] != 2 || (var4_25.var_int_k & 4096) == 0) break;
                                                if (var4_25.var_int_q == 8) {
                                                    if (var4_25.var_int_arr_d[4] <= 0) {
                                                        f.void_a(var4_25.var_int_arr_d[5], var4_25.var_int_arr_d[6], var4_25.var_int_arr_d[7], var4_25.var_int_arr_d[8], -1);
                                                        break;
                                                    }
                                                    f.void_a(var4_25.var_int_arr_d[4], var4_25.var_int_arr_d[5], var4_25.var_int_arr_d[6], var4_25.var_int_arr_d[7]);
                                                    break;
                                                }
                                                if (var4_25.var_int_arr_d[5] <= 0) {
                                                    f.void_a(var4_25.var_int_arr_d[6], var4_25.var_int_arr_d[7], var4_25.var_int_arr_d[8], var4_25.var_int_arr_d[9], -1);
                                                    break;
                                                }
                                                f.void_a(var4_25.var_int_arr_d[5], var4_25.var_int_arr_d[6], var4_25.var_int_arr_d[7], var4_25.var_int_arr_d[8]);
                                                break;
                                            }
                                            case 1: 
                                            case 2: 
                                            case 19: {
                                                d.var_d_c.var_boolean_b = true;
                                                d.var_d_c.b(0 + d.var_d_c.var_int_l);
                                                f.void_a(var4_25.var_int_s, false);
                                                d.H = d.V;
                                                break;
                                            }
                                            case 4: {
                                                d.var_boolean_l = true;
                                                d.var_d_c.var_boolean_b = true;
                                                d.var_d_c.b(0 + d.var_d_c.var_int_l);
                                                d.var_d_d = var4_25;
                                                f.var_int_l = 1;
                                                if (var4_25.var_int_s > 0) {
                                                    f.void_a(var4_25, 8);
                                                    break;
                                                }
                                                d.var_boolean_h = true;
                                                f.void_a(var4_25, 7);
                                            }
                                        }
                                    }
                                }
                            }
                            if (d.var_int_z == 0) {
                                f.void_c();
                                break;
                            }
                            f.var_int_s = 0;
                        }
                    }
                    f.void_a(this.var_int_a >> 4, this.var_int_b >> 4, true);
                    return;
                }
                case 5: 
                case 8: {
                    if ((this.var_int_k & 4096) != 0) {
                        var1_5 = d.var_d_c.var_int_a;
                        var2_14 = d.var_d_c.var_int_b;
                        var3_21 = f.var_int_arr_n;
                        if (this.var_int_q == 8) {
                            if (var1_5 < this.var_int_arr_r[0]) {
                                this.var_int_k &= -16385;
                                break;
                            }
                            if (var1_5 > this.var_int_arr_r[2]) {
                                this.var_int_k &= -16385;
                                break;
                            }
                            if (var2_14 < this.var_int_arr_r[1]) {
                                this.var_int_k &= -16385;
                                break;
                            }
                            if (var2_14 > this.var_int_arr_r[3]) {
                                this.var_int_k &= -16385;
                                break;
                            }
                        } else {
                            if (this.var_int_arr_d[1] == 64) {
                                var3_21[0] = this.var_int_a;
                                var3_21[1] = this.var_int_b;
                                var3_21[2] = this.var_int_a + (this.var_int_arr_d[3] << 4 << 4);
                                var3_21[3] = this.var_int_b - (this.var_int_arr_d[3] << 3 << 4);
                                var3_21[4] = this.var_int_a + (this.var_int_arr_d[3] << 4 << 4) + (this.var_int_arr_d[2] << 4 << 4);
                                var3_21[5] = this.var_int_b - (this.var_int_arr_d[3] << 3 << 4) + (this.var_int_arr_d[2] << 3 << 4);
                                var3_21[6] = this.var_int_a + (this.var_int_arr_d[2] << 4 << 4);
                                var3_21[7] = this.var_int_b + (this.var_int_arr_d[2] << 3 << 4);
                            } else {
                                var3_21[0] = this.var_int_a;
                                var3_21[1] = this.var_int_b;
                                var3_21[2] = this.var_int_a + (this.var_int_arr_d[1] % 8 + 1 << 4 << 4);
                                var3_21[3] = this.var_int_b - (this.var_int_arr_d[1] % 8 + 1 << 3 << 4);
                                var3_21[4] = this.var_int_a + (this.var_int_arr_d[1] % 8 + 1 << 4 << 4) + (this.var_int_arr_d[1] / 8 + 1 << 4 << 4);
                                var3_21[5] = this.var_int_b - (this.var_int_arr_d[1] % 8 + 1 << 3 << 4) + (this.var_int_arr_d[1] / 8 + 1 << 3 << 4);
                                var3_21[6] = this.var_int_a + (this.var_int_arr_d[1] / 8 + 1 << 4 << 4);
                                var3_21[7] = this.var_int_b + (this.var_int_arr_d[1] / 8 + 1 << 3 << 4);
                            }
                            if (!d.a(var1_5, var2_14, var3_21)) {
                                this.var_int_k &= -16385;
                                break;
                            }
                        }
                        if (f.var_int_arr_a[0] != 2) {
                            this.v();
                        }
                    }
                    return;
                }
                case 4: {
                    f.var_int_arr_d[7] = this.var_int_arr_d[14];
                    var1_6 = this.boolean_c();
                    var2_15 = 0;
                    if (d.var_d_c.boolean_a(this, true) && (f.var_int_arr_a[0] == 1 || f.var_int_arr_a[0] == 5 || f.var_int_arr_a[0] == 4 || f.var_int_arr_a[0] == 9 || d.var_boolean_h || this.var_boolean_u)) {
                        var2_15 = 1;
                    }
                    if (this.var_boolean_u) {
                        var6_30 = this;
                        if (var6_30.var_boolean_v) {
                            var6_30.void_a(d.var_d_c, false);
                            if (var6_30.var_int_arr_d[15] != 3) {
                                var6_30.u();
                            }
                        }
                    }
                    v0 = var3_22 = this.var_int_arr_d[28] == 2 && this.var_int_arr_d[24] == this.var_int_arr_d[26] ? 1 : 0;
                    if (var2_15 == 0 && (this.var_int_arr_d[28] == 0 || var3_22 != 0)) {
                        var4_26 = 0;
                        if (this.var_int_arr_d[44] != 0 && this.var_int_arr_d[45] == 0) {
                            this.var_int_arr_d[38] = 0;
                            this.ah = this.var_int_a;
                            this.ai = this.var_int_b;
                            this.t();
                            this.var_int_arr_d[45] = 1;
                            var4_26 = 1;
                        } else if (this.var_int_arr_d[44] == 0 && this.var_int_arr_d[45] == 1) {
                            this.s();
                            this.var_int_arr_d[45] = 2;
                            var4_26 = 1;
                        }
                        if (var4_26 == 0 && this.var_int_arr_d[37] > 0) {
                            if (this.var_int_arr_d[38] == 0) {
                                if (this.boolean_a(this.var_int_arr_d[34], this.var_int_arr_d[37])) {
                                    this.l(this.var_int_arr_d[37]);
                                    this.g(this.var_int_arr_d[37]);
                                    this.var_int_arr_d[38] = 1;
                                    var4_26 = 1;
                                }
                            } else if (this.var_int_arr_d[15] != 3 && this.var_int_arr_d[15] != 10 && (this.var_int_arr_d[15] != 6 || this.var_int_arr_d[15] == 6 && this.var_int_arr_d[16] != 10) && this.var_int_arr_d[34] != -1) {
                                this.g(this.var_int_arr_d[34]);
                                var4_26 = 1;
                            }
                        }
                        if (var4_26 != 0 && var3_22 != 0) {
                            this.var_int_arr_d[15] = this.var_int_arr_d[30];
                            this.var_int_arr_d[28] = 0;
                        }
                    }
                    switch (this.var_int_arr_d[15]) {
                        case 0: {
                            this.var_boolean_b = true;
                            this.var_int_arr_d[30] = 0;
                            break block0;
                        }
                        case 8: {
                            if (var2_15 == 0) {
                                this.var_boolean_b = true;
                                if (this.var_int_arr_d[28] != 3) {
                                    var4_26 = (f.var_byte_arr_e[this.var_int_arr_d[24] * 6 + 2] & 255) << 8 | f.var_byte_arr_e[this.var_int_arr_d[24] * 6 + 2 + 1] & 255;
                                    if (this.var_int_arr_d[25] >= var4_26) {
                                        this.var_int_arr_d[25] = 0;
                                    }
                                    if (f.a((f.var_byte_arr_e[this.var_int_arr_d[24] * 6] & 255) << 8 | f.var_byte_arr_e[this.var_int_arr_d[24] * 6 + 1] & 255, f.var_byte_arr_e, f.var_int_k, this.var_int_arr_d[25])) {
                                        if (this.var_int_arr_d[15] != 3 && this.var_int_arr_d[15] != 6) {
                                            this.var_int_arr_d[25] = this.var_int_arr_d[25] + 1;
                                        }
                                        this.var_int_arr_d[20] = 6;
                                        break block0;
                                    }
                                }
                            }
                            ** GOTO lbl632
                        }
                        case 6: {
                            if (this.var_int_arr_d[16] != 8 && this.var_int_arr_d[16] != 11) {
                                this.var_int_arr_d[30] = 6;
                            }
                            if (var1_6) {
                                this.var_int_arr_d[15] = 0;
                                this.var_int_h = 0;
                                this.var_int_i = 0;
                                this.q();
                                break block0;
                            }
                            ** GOTO lbl632
                        }
                        case 1: {
                            switch (this.var_int_arr_d[17]) {
                                case 4: {
                                    if (d.O <= 0) ** GOTO lbl454
                                    --d.O;
                                    ** GOTO lbl632
lbl454:
                                    // 1 sources

                                    this.var_int_arr_d[15] = 4;
                                    this.var_boolean_b = false;
                                    if (d.P == 255) break block203;
                                    d.var_boolean_f = true;
                                    this.b(d.P);
                                    ** GOTO lbl632
                                }
                                case 5: {
                                    if (d.R <= 0) ** GOTO lbl464
                                    --d.R;
                                    ** GOTO lbl632
lbl464:
                                    // 1 sources

                                    this.var_int_arr_d[15] = 5;
                                    this.var_boolean_b = false;
                                    if (d.S == 255) break block203;
                                    this.b(d.S);
                                    ** GOTO lbl632
                                }
                                case 0: {
                                    if (d.var_boolean_i) {
                                        if (f.var_java_lang_String_a != "") {
                                            f.void_a(f.var_java_lang_String_a);
                                            var4_26 = f.var_byte_arr_f[d.var_d_d.var_int_arr_d[12] * 231];
                                            if (var4_26 < 0) {
                                                var4_26 += 256;
                                            }
                                            f.var_java_lang_String_arr_a[0] = f.a(f.var_byte_arr_c, var4_26);
                                            f.var_int_arr_a[6] = d.var_d_d.var_int_arr_d[22];
                                            f.void_a(180, 36, -1, -1, -1);
                                            f.void_d();
                                            f.void_b();
                                            f.void_b(1);
                                            f.var_java_lang_String_a = "";
                                        }
                                        d.var_boolean_j = true;
                                        this.var_int_arr_d[15] = 0;
                                        this.var_int_arr_d[28] = 0;
                                        f.c(this);
                                    } else {
                                        break;
                                    }
                                }
                            }
                            break block0;
                        }
                        case 10: {
                            if (var2_15 != 0 || d.boolean_a(this)) {
                                if (d.boolean_a(this)) {
                                    v1 = this;
                                    this = d.var_d_c;
                                    var1_7 = v1;
                                    v1.void_a(this, true);
                                    break block0;
                                }
                            } else {
                                this.var_int_arr_d[30] = 10;
                                if (this.var_int_arr_d[45] == 0 && (var4_26 = f.int_f(this.var_int_arr_d[34])) >= 0) {
                                    this.b(var4_26);
                                }
                                var4_26 = 0;
                                if (this.var_int_arr_d[35] <= 0) {
                                    var4_26 = 1;
                                } else {
                                    this.var_int_arr_d[35] = this.var_int_arr_d[35] - 1;
                                }
                                if (var4_26 != 0) {
                                    var4_26 = 1;
                                    if (this.var_int_arr_d[45] != 0) {
                                        if (this.var_int_arr_d[45] == 2 && this.var_int_arr_d[44] == 0) {
                                            this.var_int_arr_d[45] = 0;
                                        } else {
                                            var6_30 = this;
                                            if (var6_30.var_int_arr_d[45] == 1) {
                                                if (var6_30.var_int_arr_d[44] != 0) {
                                                    var6_30.t();
                                                    var6_30.var_int_arr_d[45] = 1;
                                                } else {
                                                    var6_30.s();
                                                    var6_30.var_int_arr_d[45] = 2;
                                                }
                                            } else if (var6_30.var_int_arr_d[45] == 2 && var6_30.var_int_arr_d[44] != 0) {
                                                var6_30.t();
                                                var6_30.var_int_arr_d[45] = 1;
                                            }
                                            var4_26 = 0;
                                        }
                                    }
                                    if (var4_26 != 0 && this.var_int_arr_d[34] >= 0 && f.int_e(this.var_int_arr_d[34]) >= 0) {
                                        this.g(f.int_e(this.var_int_arr_d[34]));
                                        var4_26 = 0;
                                    }
                                    if (var4_26 != 0 && this.var_int_arr_d[37] > 0) {
                                        if (this.boolean_a(this.var_int_arr_d[34], this.var_int_arr_d[37])) {
                                            this.l(this.var_int_arr_d[37]);
                                            this.g(this.var_int_arr_d[37]);
                                        }
                                        var4_26 = 0;
                                    }
                                    if (var4_26 == 0) break block0;
                                    this.var_int_arr_d[15] = 0;
                                    this.var_int_arr_d[30] = 0;
                                    this.r();
                                    this.b(d.X + this.var_int_l);
                                    this.ap = 0;
                                    this.q();
                                    break block0;
                                }
                            }
                            ** GOTO lbl632
                        }
                        case 4: {
                            if (var1_6 || d.P == 255) {
                                d.var_boolean_j = true;
                                this.b(1);
                                this.var_int_arr_d[15] = this.var_int_arr_d[30];
                                break block0;
                            }
                            ** GOTO lbl632
                        }
                        case 5: {
                            if (var1_6 || d.S == 255) {
                                d.g(this);
                                this.var_int_arr_d[15] = 1;
                                this.var_int_arr_d[17] = 0;
                                break block0;
                            }
                            ** GOTO lbl632
                        }
                        case 12: {
                            if (this.var_int_arr_d[24] == this.var_int_arr_d[26]) {
                                d.h(this);
                                break block0;
                            }
                            this.var_int_arr_d[15] = 8;
                            break block0;
                        }
                        case 11: {
                            if (this.var_int_arr_d[24] == this.var_int_arr_d[26]) {
                                var6_30 = this;
                                var2_15 = 0;
                                if (var6_30.var_int_arr_d[32] > -1) {
                                    var4_27 = f.var_d_arr_a[var6_30.var_int_arr_d[32]];
                                    do {
                                        if (var4_27.var_int_arr_d[24] != var4_27.var_int_arr_d[26] || var4_27.var_int_arr_d[15] == 11) continue;
                                        var2_15 = 1;
                                    } while ((var4_27 = f.var_d_arr_a[var4_27.var_int_arr_d[32]]) != var6_30 && var4_27 != null && var2_15 == 0);
                                }
                                if (var2_15 == 0) {
                                    d.h(this);
                                    break block0;
                                }
                            }
                            this.var_int_arr_d[15] = 8;
                            break block0;
                        }
                        case 3: {
                            var4_26 = 0;
                            if ((!this.var_boolean_u || this.var_boolean_v) && !d.boolean_a(this) || f.var_d_c != null && f.var_d_c.var_short_a == this.var_short_a) ** GOTO lbl586
                            if (d.boolean_a(this)) {
                                v2 = this;
                                this = d.var_d_c;
                                var1_8 = v2;
                                v2.void_a(this, true);
                                break block0;
                            }
                            ** GOTO lbl632
lbl586:
                            // 1 sources

                            this.var_int_arr_d[30] = 3;
                            this.var_int_arr_d[28] = 0;
                            if (!this.boolean_h()) ** GOTO lbl624
                            this.x();
                            this.var_boolean_b = true;
                            var1_9 = this;
                            var2_15 = var1_9.int_a(false);
                            var1_9 = this;
                            var3_22 = var1_9.int_b(false);
                            var5_36 = true;
                            if (this.boolean_e()) {
                                var5_36 = f.boolean_a(this, var2_15 >> 4, var3_22 >> 4);
                            }
                            if (!var5_36) ** GOTO lbl614
                            this.f(var2_15, var3_22);
                            if (this.boolean_a(var2_15, var3_22, 0)) {
                                ++this.ap;
                                if (this.var_int_arr_d[45] != 0) {
                                    if (!this.boolean_h()) {
                                        var6_30 = this;
                                        var6_30.var_int_arr_d[34] = -1;
                                        var6_30.var_int_arr_d[15] = 10;
                                        var6_30.var_int_arr_d[17] = 3;
                                        if (var6_30.var_int_arr_d[42] >= 0) {
                                            var6_30.b(var6_30.var_int_l == 0 ? var6_30.var_int_arr_d[42] : var6_30.var_int_arr_d[43]);
                                        }
                                    }
                                } else if (this.boolean_e() && !this.boolean_h()) {
                                    this.k();
                                }
                            }
                            ** GOTO lbl625
lbl614:
                            // 1 sources

                            if (f.var_d_c != this) ** GOTO lbl617
                            f.void_e();
                            ** GOTO lbl625
lbl617:
                            // 1 sources

                            if (this.var_int_arr_d[26] != 155 || this.var_int_arr_d[24] != 155) ** GOTO lbl622
                            this.var_int_arr_d[49] = this.var_int_arr_d[49] + 1;
                            if (this.var_int_arr_d[49] <= 20) ** GOTO lbl625
                            this.var_int_arr_d[49] = 0;
                            ** GOTO lbl624
lbl622:
                            // 1 sources

                            this.b(this.var_int_l == 0 ? this.var_int_arr_d[42] : this.var_int_arr_d[43]);
                            ** GOTO lbl625
lbl624:
                            // 2 sources

                            var4_26 = 1;
lbl625:
                            // 6 sources

                            if (var4_26 != 0) {
                                this.var_int_arr_d[15] = 0;
                                this.var_int_arr_d[30] = 0;
                                this.r();
                                this.b(d.X + this.var_int_l);
                                this.ap = 0;
                                this.q();
                            }
                        }
lbl632:
                        // 15 sources

                        default: {
                            return;
                        }
                    }
                }
                case 19: {
                    if (this.var_int_arr_d[6] != 0) break;
                    f.void_a(this.var_int_a >> 4, this.var_int_b >> 4, true);
                    switch (this.var_int_arr_d[2]) {
                        case 1: {
                            if (this.boolean_h()) {
                                this.x();
                                var1_10 = this;
                                var3_23 = var1_10.int_a(false);
                                var1_10 = this;
                                var4_28 = var1_10.int_b(false);
                                if (f.boolean_a(this, var3_23 >> 4, var4_28 >> 4)) {
                                    this.f(var3_23, var4_28);
                                    if (!this.boolean_a(var3_23, var4_28, 0)) break;
                                    ++this.ap;
                                    break;
                                }
                                this.b(0);
                                break;
                            }
                            this.ap = 0;
                            this.m(5);
                            break;
                        }
                        case 0: {
                            if (this.var_int_arr_d[4] > 0) {
                                this.var_int_arr_d[4] = this.var_int_arr_d[4] - 1;
                                break;
                            }
                            if (this.var_int_arr_d[3] != 1 || !(var2_16 = f.a(this, var1_11 = f.var_d_arr_a[f.int_b(this.var_int_arr_d[5])], f.var_int_arr_i))) break;
                            this.e(f.var_int_arr_i[0], f.var_int_arr_i[1]);
                        }
                    }
                    this.var_int_k = this.var_int_k & -2 | 1 & this.var_int_m;
                }
            }
        }
    }

    final boolean boolean_a() {
        try {
            int n = this.var_int_h;
            int[] nArray = f.a(this.a_a(), this.var_int_g, n, this.var_int_k);
            int[] nArray2 = nArray;
            nArray[0] = nArray[0] + (this.var_int_a >> 4);
            nArray2[1] = nArray2[1] + (this.var_int_b >> 4);
            nArray2[2] = nArray2[2] + nArray2[0];
            nArray2[3] = nArray2[3] + nArray2[1];
            f.void_a(f.var_int_arr_m, f.var_int_arr_h);
            return f.boolean_a(nArray2, f.var_int_arr_m);
        }
        catch (Exception exception) {
            return false;
        }
    }

    final void a(Graphics graphics) {
        this.a(graphics, false, 2);
    }

    private void a(Graphics graphics, int n, int n2) {
        if (V != this.var_int_e && f.boolean_a()) {
            int n3 = f.var_byte_arr_b[1801] & 0xFF;
            n3 *= 12;
            if ((n3 = (f.var_byte_arr_g[n3 + 4] & 0xFF) << 8 | f.var_byte_arr_g[n3 + 4 + 1] & 0xFF) != f.var_int_C && this.var_boolean_e) {
                f.var_a_a.a(graphics, 129 + f.var_int_A % 5, n + this.var_int_n, n2 + this.var_int_o, 0, 0, 0);
            }
        }
    }

    final void a(Graphics graphics, boolean bl, int n) {
        if (this.var_boolean_c || !var_boolean_arr_a[this.var_int_f] && this.var_int_q != 5) {
            return;
        }
        switch (this.var_int_q) {
            case 0: {
                return;
            }
            case 1: {
                boolean bl2;
                int n2;
                int n3 = this.var_int_a + f.var_int_x >> 4;
                int n4 = this.var_int_b + f.var_int_y >> 4;
                var_a_arr_a[this.var_int_f].void_a(this.var_int_arr_d[1]);
                if (n2 == 2) {
                    bl2 = false;
                }
                if (!bl2) {
                    if (n2 != 1) {
                        var_a_arr_a[this.var_int_f].a(graphics, this.var_int_h, n3, n4, this.var_int_k, 0, 0);
                    } else {
                        int n5 = this.var_int_a >> 4;
                        n2 = this.var_int_b >> 4;
                        f.a(graphics, var_a_arr_a[this.var_int_f], -1, this.var_int_h, this.var_int_k, n5, n2);
                    }
                } else {
                    int n6 = this.var_int_a >> 4;
                    n2 = this.var_int_b >> 4;
                    f.a(var_a_arr_a[this.var_int_f], -1, this.var_int_h, this.var_int_k, n6, n2, 0, 0);
                }
                if (V == this.var_short_a) {
                    if ((f.var_int_arr_a[0] != 0 || var_int_z != 0 && var_int_z != 1) && (f.var_int_arr_a[0] != 1 || f.var_int_arr_a[6] != -2)) break;
                    f.var_a_a.a(graphics, 160 + f.var_int_A % 5, n3 + this.var_int_n, n4 + this.var_int_o, 0, 0, 0);
                    return;
                }
                this.a(graphics, n3, n4);
                return;
            }
            case 2: {
                if (f.var_int_arr_a[0] == 10 || f.var_int_arr_a[0] == 22 || f.var_int_arr_a[0] == 7 || f.var_int_arr_a[0] == 26) {
                    this.p();
                }
                int n7 = this.var_int_a + f.var_int_x >> 4;
                int n8 = this.var_int_b + f.var_int_y >> 4;
                var_a_arr_a[this.var_int_f].void_a(this.var_int_arr_d[1]);
                this.a(graphics, n7, n8, this.var_int_k, 0, 0);
                if (!this.var_boolean_d) break;
                if (V == this.var_short_a) {
                    if ((f.var_int_arr_a[0] != 0 || var_int_z != 0 && var_int_z != 1) && (f.var_int_arr_a[0] != 1 || f.var_int_arr_a[6] != -2)) break;
                    f.var_a_a.a(graphics, 160 + f.var_int_A % 5, n7 + this.var_int_n, n8 + this.var_int_o, 0, 0, 0);
                    return;
                }
                this.a(graphics, n7, n8);
                return;
            }
            case 19: {
                if (f.var_int_arr_a[0] == 10 || f.var_int_arr_a[0] == 22 || f.var_int_arr_a[0] == 7 || f.var_int_arr_a[0] == 26) {
                    this.p();
                }
                int n9 = this.var_int_a + f.var_int_x >> 4;
                int n10 = this.var_int_b + f.var_int_y >> 4;
                var_a_arr_a[this.var_int_f].void_a(this.var_int_arr_d[1]);
                this.a(graphics, n9, n10, this.var_int_k, 0, 0);
                if (this.var_boolean_d) {
                    if (V == this.var_short_a) {
                        if (f.var_int_arr_a[0] == 0 && (var_int_z == 0 || var_int_z == 1) || f.var_int_arr_a[0] == 1 && f.var_int_arr_a[6] == -2) {
                            f.var_a_a.a(graphics, 160 + f.var_int_A % 5, n9 + this.var_int_n, n10 + this.var_int_o, 0, 0, 0);
                        }
                    } else {
                        this.a(graphics, n9, n10);
                    }
                }
                if (this.var_int_q != 19) break;
                return;
            }
            case 3: 
            case 4: {
                int n2;
                if (!bl) {
                    boolean bl3;
                    if (f.var_int_arr_a[0] == 10 || f.var_int_arr_a[0] == 22 || f.var_int_arr_a[0] == 7 || f.var_int_arr_a[0] == 26) {
                        this.p();
                    }
                    int n11 = this.var_int_a + f.var_int_x >> 4;
                    n2 = this.var_int_b + f.var_int_y >> 4;
                    f.var_boolean_b = true;
                    f.var_int_arr_j = this.var_int_arr_d;
                    if (this.var_int_q == 3 && I == 1) {
                        bl3 = false;
                        n2 = 0;
                    }
                    this.a(graphics, (int)(bl3 + (f.int_a() >> 4)), n2, this.var_int_m, 0, 0);
                    f.var_boolean_b = false;
                    return;
                }
                int n12 = this.var_int_a >> 4;
                n2 = this.var_int_b >> 4;
                f.var_boolean_b = true;
                f.var_int_arr_j = this.var_int_arr_d;
                f.a(this.a_a(), this.var_int_g, this.var_int_h, this.var_int_m, n12, n2, 0, 0);
                f.var_boolean_b = false;
                return;
            }
            case 7: 
            case 18: {
                int n13 = this.var_int_a + f.var_int_x >> 4;
                int n14 = this.var_int_b + f.var_int_y >> 4;
                this.a(graphics, n13, n14, this.var_int_k, 0, 0);
            }
        }
    }

    private void p() {
        for (int i = this.aj + (int)f.var_long_a; i >= 70; i -= 70) {
            --this.var_int_i;
        }
    }

    final void void_b(boolean bl) {
        this.var_boolean_c = true;
        f.void_a();
    }

    public final boolean boolean_b() {
        return this.var_boolean_q;
    }

    public static void void_e() {
        if (var_boolean_arr_a != null) {
            for (int i = 0; i < 1111; ++i) {
                if (!var_boolean_arr_a[i]) continue;
                if (var_a_arr_a[i] == null) {
                    d.var_boolean_arr_a[i] = false;
                    continue;
                }
                for (int j = 0; j < d.var_a_arr_a[i].var_int_b; ++j) {
                    var_a_arr_a[i].void_b(j);
                }
            }
        }
    }

    /*
     * Enabled force condition propagation
     * Lifted jumps to return sites
     */
    public final void b(Graphics graphics) {
        int n = this.var_int_a + f.var_int_x >> 4;
        int n2 = this.var_int_b + f.var_int_y >> 4;
        if (this.var_int_q == 4) {
            if (this.var_boolean_u) {
                if (var_boolean_f && d.var_d_d.var_short_a == this.var_short_a) {
                    if (f.var_int_f >= 0 && this.var_d_a.var_int_g >= 0 && !this.var_d_a.boolean_c()) {
                        this.var_d_a.a(graphics, n, n2 - 64, 1 - this.var_int_m, 0, 0);
                        if (this.var_d_a.boolean_c() && T >= 0) {
                            f.void_e(T);
                        }
                    } else if (f.var_int_e >= 0) {
                        f.var_d_a.a(graphics, n, n2 - 64, d.var_d_c.var_int_m, 0, 0);
                    }
                }
            } else if ((this.var_int_arr_d[15] == 6 && this.var_int_arr_d[16] == 8 || this.var_int_arr_d[15] == 8 || f.boolean_a(this)) && f.var_int_arr_a[0] != 5 && this.var_d_b.var_int_g >= 0) {
                if (this.var_d_a.var_int_g >= 0 && !this.var_d_a.boolean_c() && this.var_d_b.var_int_g != 2) {
                    this.var_d_a.a(graphics, n, n2 - 64, 1 - this.var_int_m, 0, 0);
                } else {
                    if (this.var_d_b.boolean_c()) {
                        if (this.var_int_arr_d[47] > 0) {
                            this.var_int_arr_d[47] = this.var_int_arr_d[47] - 1;
                        } else {
                            this.var_int_arr_d[47] = 100 + f.int_d(f.var_java_util_Random_a.nextInt() % 100);
                            this.var_d_b.void_f();
                        }
                    }
                    this.var_d_b.a(graphics, n, n2 - 64, 1 - this.var_int_m, 0, 0);
                }
            } else {
                this.var_d_a.a(f.int_g(var_int_v, f.var_int_i), false);
                this.var_d_a.void_f();
                this.var_int_arr_d[47] = 100 + f.int_d(f.var_java_util_Random_a.nextInt() % 100);
                this.var_d_b.var_boolean_b = false;
            }
            if ((this.var_int_g == 56 || this.var_int_g == 57) && this.ad >= -1) {
                f.var_a_a.a(graphics, 329 + f.var_int_A % 9, n, n2 - 64, 0, 0, 0);
            }
        }
        if (this.var_int_q != 3 || f.var_int_E != 4) return;
        if (f.var_byte_arr_b[36] < 30) {
            f.var_a_a.a(graphics, 323 + f.var_int_A % 5, n, n2 - 80, 0, 0, 0);
        }
        if (V >= 0) {
            d d2;
            int n3 = f.int_b(V);
            if (n3 <= -1 || (d2 = f.var_d_arr_a[n3]) == null) return;
            switch (d2.var_int_q) {
                case 1: 
                case 2: 
                case 19: {
                    ++D;
                    return;
                }
                case 4: {
                    D = 200;
                    if (var_int_z != 6 || !var_boolean_g) return;
                    if (f.var_int_h >= 0 && this.var_d_a.var_int_g >= 0 && !this.var_d_a.boolean_c()) {
                        this.var_d_a.a(graphics, n, n2 - 64, d.var_d_d.var_int_m, 0, 0);
                        return;
                    }
                    if (f.var_int_g < 0) return;
                    f.var_d_b.a(graphics, n, n2 - 64, d.var_d_d.var_int_m, 0, 0);
                }
                default: {
                    return;
                }
            }
        }
        if (var_int_z != 0 || f.var_int_arr_a[0] != 0) return;
        if (f.var_byte_arr_b[35] >= 70) {
            D = 100;
            return;
        }
        if (f.var_byte_arr_b[37] >= 70) {
            D = 101;
            return;
        }
        if (f.var_byte_arr_b[34] >= 70) {
            D = 102;
            return;
        }
        if (f.var_byte_arr_b[36] >= 30) return;
        D = 103;
    }

    public final void void_f() {
        this.var_int_h = 0;
        this.var_int_i = 0;
    }

    public final void b(int n) {
        if (this.var_int_g != n) {
            this.var_int_g = n;
            this.void_f();
        }
    }

    public final void a(int n, boolean bl) {
        this.b(n);
        this.var_boolean_b = bl;
    }

    public final a a_a() {
        switch (((d)object).var_int_q) {
            case 7: {
                Object object = f.var_a_a;
                break;
            }
            case 18: {
                Object object = f.var_a_b;
                break;
            }
            case -1: {
                Object object = ((d)object).var_a_a;
                break;
            }
            default: {
                Object object = var_a_arr_a[((d)object).var_int_f];
            }
        }
        return object;
    }

    public final int a(Graphics graphics, int n, int n2, int n3, int n4, int n5) {
        a a2 = this.a_a();
        int n6 = (a2.var_short_arr_a[this.var_int_g] + this.var_int_h) * 5;
        int n7 = a2.var_byte_arr_c[n6] & 0xFF;
        n4 = (n3 & 1) != 0 ? 0 + a2.var_byte_arr_c[n6 + 2] : 0 - a2.var_byte_arr_c[n6 + 2];
        n5 = (n3 & 2) != 0 ? 0 + a2.var_byte_arr_c[n6 + 3] : 0 - a2.var_byte_arr_c[n6 + 3];
        this.var_int_j = n3 ^ a2.var_byte_arr_c[n6 + 4] & 0xF;
        a2.a(graphics, n7 |= (a2.var_byte_arr_c[n6 + 4] & 0xC0) << 2, n - n4, n2 - n5, n3 ^ a2.var_byte_arr_c[n6 + 4] & 0xF, n4, n5);
        this.aj = (int)((long)this.aj + f.var_long_a);
        while (this.aj >= 70) {
            if (++this.var_int_i >= (a2.var_byte_arr_c[n6 + 1] & 0xFF)) {
                if (++this.var_int_h >= a2.int_a(this.var_int_g)) {
                    if (this.var_boolean_b) {
                        this.var_int_i = 0;
                        this.var_int_h = 0;
                    } else {
                        --this.var_int_h;
                    }
                } else {
                    this.var_int_i = 0;
                }
            }
            this.aj -= 70;
        }
        return this.var_int_h;
    }

    public final boolean boolean_c() {
        int n = (this.a_a().var_short_arr_a[this.var_int_g] + this.var_int_h) * 5;
        if (!(this.var_int_q != 4 && this.var_int_q != 3 || f.var_int_E != 4 || this.boolean_a())) {
            this.var_int_h = this.a_a().int_a(this.var_int_g) - 1;
            this.var_int_i = this.a_a().var_byte_arr_c[n + 1] & 0xFF;
        }
        return !this.var_boolean_b && this.var_int_h + 1 == this.a_a().int_a(this.var_int_g) && this.var_int_i >= (this.a_a().var_byte_arr_c[n + 1] & 0xFF);
    }

    final void void_g() {
        this.c(0);
        B = 0;
        C = 0;
        f.void_c(1000, 246750);
    }

    final void c(int n) {
        if (n != aq) {
            aq = n;
        }
        var_int_z = n;
        int n2 = -1;
        switch (n) {
            case 0: 
            case 4: {
                av = 0;
                n2 = f.var_byte_arr_b[3000] > 0 ? 5 : (f.int_c(10) > 80 ? 15 : (f.boolean_a(true) ? f.var_int_arr_e[f.var_int_o] : Y));
                B = 0;
                C = 0;
                this.var_boolean_b = true;
                break;
            }
            case 1: {
                n2 = f.var_byte_arr_b[3000] > 0 ? (this.var_int_l == 0 ? 8 : 9) : (f.int_c(10) > 80 ? (this.var_int_l == 0 ? 16 : 17) : (this.var_int_l == 0 ? Z : aa));
                this.var_boolean_b = true;
                break;
            }
            case 8: {
                this.var_int_l = 1;
                this.n(d.var_d_d.var_int_a);
                this.b(1);
                d d2 = var_d_c;
                d d3 = var_d_d;
                d3.void_a(d2, true);
                f.boolean_a(d.var_d_d.var_int_s);
                d.d(var_d_d);
                break;
            }
            case 7: {
                this.var_int_l = 1;
                this.n(d.var_d_d.var_int_a);
                this.b(1);
                f.void_b(5);
                if (var_boolean_k) {
                    var_boolean_k = false;
                    break;
                }
                f.d(var_d_d);
                f.void_g();
                break;
            }
            case 5: {
                var_boolean_i = false;
                var_boolean_j = false;
                this.n(d.var_d_d.var_int_a);
                this.var_int_l = 1;
                d.var_d_d.var_int_arr_d[15] = 1;
                d.var_d_d.var_int_arr_d[17] = 4;
                this.var_boolean_b = false;
                this.b(N);
                break;
            }
            case 6: {
                var_boolean_i = false;
                var_boolean_j = false;
                d.var_d_d.var_int_arr_d[15] = 1;
                d.var_d_d.var_int_arr_d[17] = 5;
                this.var_boolean_b = false;
                if (Q == 255) break;
                var_boolean_g = true;
                this.b(Q);
                break;
            }
            case 2: {
                this.var_boolean_b = false;
                if (E >= 0) {
                    var_d_c.b(E);
                    break;
                }
                var_d_c.b(1);
            }
        }
        if (n != 1) {
            B = 0;
            C = 0;
        }
        if (n2 != -1) {
            this.b(n2);
        }
    }

    final void d(int n) {
        if (var_int_z == 0) {
            this.c(n);
            A = -1;
            return;
        }
        A = n;
    }

    final void a(Graphics graphics, int n, int n2, int n3, int n4) {
        f.var_boolean_b = true;
        f.var_int_arr_j = this.var_int_arr_d;
        this.ak = n;
        int n5 = n2;
        int n6 = n3;
        int n7 = n4;
        n4 = 0;
        n3 = 0;
        int n8 = 0;
        n2 = n7;
        n = n6;
        n8 = n5;
        d d2 = this;
        int n9 = (d.var_a_arr_a[d2.var_int_f].var_short_arr_a[d2.ak] + d2.al) * 5;
        int n10 = d.var_a_arr_a[d2.var_int_f].var_byte_arr_c[n9] & 0xFF;
        n3 = 0 - d.var_a_arr_a[d2.var_int_f].var_byte_arr_c[n9 + 2];
        n4 = 0 - d.var_a_arr_a[d2.var_int_f].var_byte_arr_c[n9 + 3];
        var_a_arr_a[d2.var_int_f].b(graphics, n10 |= (d.var_a_arr_a[d2.var_int_f].var_byte_arr_c[n9 + 4] & 0xC0) << 2, n - n3, n2 - n4, 0 ^ d.var_a_arr_a[d2.var_int_f].var_byte_arr_c[n9 + 4] & 0xF, n3, n4);
        if (++d2.am >= (d.var_a_arr_a[d2.var_int_f].var_byte_arr_c[n9 + 1] & 0xFF)) {
            if (++d2.al >= var_a_arr_a[d2.var_int_f].int_a(d2.ak)) {
                if (d2.var_boolean_b) {
                    d2.am = 0;
                    d2.al = 0;
                } else {
                    --d2.al;
                }
            } else {
                d2.am = 0;
            }
        }
        int cfr_ignored_0 = d2.al;
        f.var_boolean_b = false;
    }

    static void e(int n) {
        if (var_boolean_l) {
            return;
        }
        W = V;
        V = n;
    }

    /*
     * Unable to fully structure code
     */
    static boolean a(int var0, int var1_1, boolean var2_2) {
        block45: {
            var3_3 = d.V;
            if (f.boolean_a(var0, var1_1, true)) {
                return false;
            }
            if (var2_2 || d.var_int_z == 3 || d.var_int_z == 7) break block45;
            d.aw = 0x7FFFFFFF;
            d.var_boolean_s = false;
            var4_4 = 0;
            for (var5_5 = 0; var5_5 < f.var_int_arr_a[3]; ++var5_5) {
                block46: {
                    var6_9 = f.var_d_arr_a[var5_5];
                    if (var6_9 == null || var6_9.var_int_q != 1 && var6_9.var_int_q != 2 && var6_9.var_int_q != 19 && (var6_9.var_int_q != 4 || var6_9.var_boolean_c)) continue;
                    var7_13 = f.var_int_arr_m;
                    if (var6_9.var_int_r != 0 && var6_9.var_int_q == 4) {
                        var7_13[0] = var6_9.var_int_a - 640;
                        var7_13[1] = var6_9.var_int_b - 320;
                        var7_13[2] = var6_9.var_int_a + 640;
                        var7_13[3] = var6_9.var_int_b + 320;
                    } else {
                        var7_13[0] = var6_9.var_int_a - (var6_9.var_int_r << 4);
                        var7_13[1] = var6_9.var_int_b - (var6_9.var_int_r << 4);
                        var7_13[2] = var6_9.var_int_a + (var6_9.var_int_r << 4);
                        var7_13[3] = var6_9.var_int_b + (var6_9.var_int_r << 4);
                    }
                    if (!d.b(d.var_d_c.var_int_a, d.var_d_c.var_int_b, (int[])var7_13) || d.var_int_z == 3) break block46;
                    var7_13 = var6_9;
                    var10_20 = d.var_d_c;
                    var8_15 = var10_20.var_int_m == 1 && var7_13.var_int_a <= var10_20.var_int_a || var10_20.var_int_m == 0 && var7_13.var_int_a >= var10_20.var_int_a ? 1 : 0;
                    if (var8_15 == 0 && d.var_boolean_s) ** GOTO lbl-1000
                    if (var8_15 != 0 && !d.var_boolean_s) {
                        d.aw = f.int_a(var10_20.var_int_a, var10_20.var_int_b, var7_13.var_int_a, var7_13.var_int_b);
                        d.var_boolean_s = true;
                        v0 = true;
                    } else {
                        var9_19 = f.int_a(var10_20.var_int_a, var10_20.var_int_b, var7_13.var_int_a, var7_13.var_int_b);
                        if (var9_19 < d.aw) {
                            d.aw = var9_19;
                            v0 = true;
                        } else lbl-1000:
                        // 2 sources

                        {
                            v0 = false;
                        }
                    }
                    if (v0) {
                        var4_4 = 1;
                        if (d.var_int_z == 0 || d.var_int_z == 1) {
                            d.e(var6_9.var_short_a);
                        } else if (var3_3 == var6_9.var_short_a) {
                            d.e(d.W);
                        }
                    }
                }
                if (var6_9.var_int_q != 4) continue;
                var8_15 = var7_14 = f.int_a(d.var_d_c.var_int_a, d.var_d_c.var_int_b, var6_9.var_int_a, var6_9.var_int_b);
                var7_13 = var6_9;
                if (var8_15 > f.var_int_z * f.var_int_z) continue;
                var9_19 = var7_13.var_int_arr_d[24];
                var6_10 = -1;
                if (var8_15 <= 10000) {
                    if (var7_13.var_int_arr_d[46] <= 0) {
                        if (d.var_boolean_m) {
                            var8_16 = f.int_arr_a((d)var7_13, var8_15);
                            var10_21 = var8_16[1];
                            if (var10_21 >= var7_13.var_int_arr_d[31]) {
                                var6_10 = var8_16[0];
                            }
                        } else {
                            var6_10 = -1;
                        }
                        var7_13.var_int_arr_d[46] = 100 + f.int_d(f.var_java_util_Random_a.nextInt() % 200);
                    } else {
                        var7_13.var_int_arr_d[46] = var7_13.var_int_arr_d[46] - (int)f.var_long_a;
                        var6_10 = var7_13.var_int_arr_d[24];
                    }
                }
                if (var6_10 < 0) {
                    var6_10 = var7_13.var_int_arr_d[26];
                }
                var7_13.i(var6_10);
                if (var7_13.var_int_arr_d[24] == 2) continue;
                if (var7_13.var_int_arr_d[24] != var7_13.var_int_arr_d[26]) {
                    var6_11 = var7_13;
                    if (var6_11.var_int_arr_d[32] > -1 && f.var_int_arr_a[0] == 0 && (var8_17 = d.int_a((d)var6_11) > -1)) {
                        var8_18 = f.var_d_arr_a[var6_11.var_int_arr_d[32]];
                        do {
                            if (var8_18.var_boolean_u || var8_18.var_int_arr_d[24] != var8_18.var_int_arr_d[26] || var8_18.var_int_arr_d[15] == 11) continue;
                            var8_18.var_int_arr_d[15] = 11;
                            d.h(var8_18);
                        } while ((var8_18 = f.var_d_arr_a[var8_18.var_int_arr_d[32]]) != var6_11 && var8_18 != null);
                    }
                }
                if (!var7_13.var_boolean_u && var7_13.var_int_arr_d[15] != 8 && var7_13.var_int_arr_d[28] != 3 && var7_13.var_int_arr_d[28] != 4 && var7_13.var_int_arr_d[28] != 2 && var7_13.var_int_arr_d[15] != 3) {
                    var7_13.var_int_arr_d[30] = var7_13.var_int_arr_d[34] != -1 ? 10 : var7_13.var_int_arr_d[15];
                    var7_13.var_int_arr_d[15] = 8;
                    var7_13.var_int_arr_d[25] = 0;
                    var7_13.var_int_arr_d[28] = 2;
                    continue;
                }
                if (var9_19 == var7_13.var_int_arr_d[24] || var7_13.var_int_arr_d[15] == 8 || f.var_int_arr_a[0] != 0 || var7_13 == d.var_d_d) continue;
                var7_13.var_int_arr_d[15] = 8;
                var7_13.var_int_arr_d[25] = 0;
                var7_13.var_int_arr_d[28] = 2;
            }
            for (var5_5 = 0; var5_5 < f.var_int_arr_a[3]; ++var5_5) {
                var6_9 = f.var_d_arr_a[var5_5];
                if (var6_9 == null || var6_9.var_int_q != 5 && var6_9.var_int_q != 8 || var6_9.var_int_arr_d[0] != 2 || (var6_9.var_int_k & 4096) == 0) continue;
                if (var6_9.var_int_q == 5) {
                    var7_13 = f.var_int_arr_n;
                    if (var6_9.var_int_arr_d[1] == 64) {
                        var7_13[0] = var6_9.var_int_a;
                        var7_13[1] = var6_9.var_int_b;
                        var7_13[2] = var6_9.var_int_a + (var6_9.var_int_arr_d[3] << 4 << 4);
                        var7_13[3] = var6_9.var_int_b - (var6_9.var_int_arr_d[3] << 3 << 4);
                        var7_13[4] = var6_9.var_int_a + (var6_9.var_int_arr_d[3] << 4 << 4) + (var6_9.var_int_arr_d[2] << 4 << 4);
                        var7_13[5] = var6_9.var_int_b - (var6_9.var_int_arr_d[3] << 3 << 4) + (var6_9.var_int_arr_d[2] << 3 << 4);
                        var7_13[6] = var6_9.var_int_a + (var6_9.var_int_arr_d[2] << 4 << 4);
                        var7_13[7] = var6_9.var_int_b + (var6_9.var_int_arr_d[2] << 3 << 4);
                    } else {
                        var7_13[0] = var6_9.var_int_a;
                        var7_13[1] = var6_9.var_int_b;
                        var7_13[2] = var6_9.var_int_a + (var6_9.var_int_arr_d[1] % 8 + 1 << 4 << 4);
                        var7_13[3] = var6_9.var_int_b - (var6_9.var_int_arr_d[1] % 8 + 1 << 3 << 4);
                        var7_13[4] = var6_9.var_int_a + (var6_9.var_int_arr_d[1] % 8 + 1 << 4 << 4) + (var6_9.var_int_arr_d[1] / 8 + 1 << 4 << 4);
                        var7_13[5] = var6_9.var_int_b - (var6_9.var_int_arr_d[1] % 8 + 1 << 3 << 4) + (var6_9.var_int_arr_d[1] / 8 + 1 << 3 << 4);
                        var7_13[6] = var6_9.var_int_a + (var6_9.var_int_arr_d[1] / 8 + 1 << 4 << 4);
                        var7_13[7] = var6_9.var_int_b + (var6_9.var_int_arr_d[1] / 8 + 1 << 3 << 4);
                    }
                    if (!d.a(var0, var1_1, (int[])var7_13)) continue;
                    d.e(var6_9.var_short_a);
                    var4_4 = 1;
                    continue;
                }
                if (var6_9.var_int_q != 8 || !d.b(var0, var1_1, var6_9.var_int_arr_r)) continue;
                d.e(var6_9.var_short_a);
                var4_4 = 1;
            }
            if (var4_4 == 0) {
                d.var_boolean_l = false;
                d.e(-1);
            }
            if (f.var_int_D < 2 && d.V >= 0 && f.var_int_arr_a[0] == 0) {
                var5_6 = null;
                var6_12 = f.int_b(d.V);
                if (var6_12 > -1) {
                    var5_6 = f.var_d_arr_a[var6_12];
                }
                if (var5_6 != null) {
                    if (var5_6.var_int_q == 4) {
                        d.B = 0;
                        d.C = 0;
                        if (var3_3 != d.V && d.V > 0 && f.var_int_arr_a[0] != 2) {
                            f.var_int_arr_a[37] = f.int_l(var5_6.var_int_arr_d[12]);
                            f.var_int_p = 0;
                        }
                        f.void_a(1);
                    } else if ((var5_6.var_int_q == 2 || var5_6.var_int_q == 19 || var5_6.var_int_q == 1 || var5_6.var_int_q == 5) && f.var_int_D == 0) {
                        d.B = 0;
                        d.C = 0;
                        f.void_a(0);
                    }
                }
                return true;
            }
            if (var3_3 != d.V && d.V > 0) {
                var5_7 = f.var_d_arr_a[f.int_b(d.V)];
                if (var5_7.var_int_q == 4 && f.var_int_arr_a[0] != 2 && f.var_int_arr_a[0] != 1) {
                    f.var_int_arr_a[37] = f.int_l(var5_7.var_int_arr_d[12]);
                }
            }
        }
        for (var4_4 = 0; var4_4 < f.var_int_arr_a[3]; ++var4_4) {
            var5_8 = f.var_d_arr_a[var4_4];
            if (var5_8 == null) continue;
            if (var5_8.var_int_q == 4 && !var5_8.var_boolean_c) {
                d.var_d_c.var_int_arr_r[0] = var5_8.var_int_a - 128;
                d.var_d_c.var_int_arr_r[1] = var5_8.var_int_b - 128;
                d.var_d_c.var_int_arr_r[2] = var5_8.var_int_a + 128;
                d.var_d_c.var_int_arr_r[3] = var5_8.var_int_b + 128;
                if (!d.b(var0, var1_1, d.var_d_c.var_int_arr_r)) continue;
                return false;
            }
            if (var5_8.var_int_q == 8 && var5_8.var_int_arr_d[0] == 0 && var2_2) {
                if (!d.b(d.var_d_c.var_int_a, d.var_d_c.var_int_b, var5_8.var_int_arr_r)) continue;
                return false;
            }
            if (var5_8.var_int_q != 5 || var5_8.var_int_arr_d[0] != 0 || !var2_2) continue;
            var6_9 = f.var_int_arr_n;
            if (var5_8.var_int_arr_d[1] == 64) {
                var6_9[0] = var5_8.var_int_a;
                var6_9[1] = var5_8.var_int_b;
                var6_9[2] = var5_8.var_int_a + (var5_8.var_int_arr_d[3] << 4 << 4);
                var6_9[3] = var5_8.var_int_b - (var5_8.var_int_arr_d[3] << 3 << 4);
                var6_9[4] = var5_8.var_int_a + (var5_8.var_int_arr_d[3] << 4 << 4) + (var5_8.var_int_arr_d[2] << 4 << 4);
                var6_9[5] = var5_8.var_int_b - (var5_8.var_int_arr_d[3] << 3 << 4) + (var5_8.var_int_arr_d[2] << 3 << 4);
                var6_9[6] = var5_8.var_int_a + (var5_8.var_int_arr_d[2] << 4 << 4);
                var6_9[7] = var5_8.var_int_b + (var5_8.var_int_arr_d[2] << 3 << 4);
            } else {
                var6_9[0] = var5_8.var_int_a;
                var6_9[1] = var5_8.var_int_b;
                var6_9[2] = var5_8.var_int_a + (var5_8.var_int_arr_d[1] % 8 + 1 << 4 << 4);
                var6_9[3] = var5_8.var_int_b - (var5_8.var_int_arr_d[1] % 8 + 1 << 3 << 4);
                var6_9[4] = var5_8.var_int_a + (var5_8.var_int_arr_d[1] % 8 + 1 << 4 << 4) + (var5_8.var_int_arr_d[1] / 8 + 1 << 4 << 4);
                var6_9[5] = var5_8.var_int_b - (var5_8.var_int_arr_d[1] % 8 + 1 << 3 << 4) + (var5_8.var_int_arr_d[1] / 8 + 1 << 3 << 4);
                var6_9[6] = var5_8.var_int_a + (var5_8.var_int_arr_d[1] / 8 + 1 << 4 << 4);
                var6_9[7] = var5_8.var_int_b + (var5_8.var_int_arr_d[1] / 8 + 1 << 3 << 4);
            }
            if (!d.a(var0, var1_1, (int[])var6_9)) continue;
            return false;
        }
        if (var0 < f.int_b()) {
            return false;
        }
        if (var1_1 < f.int_c()) {
            return false;
        }
        if (var0 >= f.int_d() << 4) {
            return false;
        }
        return var1_1 < f.int_e() << 4;
    }

    final void a(int n, int n2, int n3, int n4) {
        if (this.var_int_q == 3) {
            if (n != -1) {
                X = n;
            }
            if (n2 != -1) {
                Y = n2;
            }
            if (n3 != -1) {
                Z = n3;
            }
            if (n4 != -1) {
                aa = n4;
            }
        }
    }

    public final boolean boolean_a(d d2, boolean bl) {
        block2: {
            block3: {
                block5: {
                    block4: {
                        if (d2 == null) break block2;
                        if (!bl) break block3;
                        if (d3.boolean_a(d2, false)) break block4;
                        if (!(V == -1)) break block5;
                        d d3 = d2;
                        if (!(d3.var_short_a == W)) break block5;
                    }
                    return true;
                }
                return false;
            }
            return d2.var_short_a == V;
        }
        return false;
    }

    private static boolean boolean_a(d d2) {
        return d2.var_short_a == ar;
    }

    public final boolean boolean_d() {
        return this.var_e_a.a() > 0;
    }

    private void q() {
        switch (this.var_int_arr_d[20]) {
            case 1: {
                f.boolean_a(this.var_int_arr_d[21]);
                this.var_int_arr_d[20] = 0;
                return;
            }
            case 2: {
                f.void_a(this.var_int_arr_d[21], false);
                this.var_int_arr_d[20] = 0;
                return;
            }
            case 3: {
                f.void_a(this.var_int_arr_d[21], true);
                this.var_int_arr_d[20] = 0;
                return;
            }
            case 4: {
                f.a((f.var_byte_arr_d[this.var_int_arr_d[21] * 6] & 0xFF) << 8 | f.var_byte_arr_d[this.var_int_arr_d[21] * 6 + 1] & 0xFF, (f.var_byte_arr_d[this.var_int_arr_d[21] * 6 + 2] & 0xFF) << 8 | f.var_byte_arr_d[this.var_int_arr_d[21] * 6 + 2 + 1] & 0xFF, f.var_byte_arr_d, f.var_int_j);
                this.var_int_arr_d[20] = 0;
                return;
            }
            case 5: {
                f.a((f.var_byte_arr_e[this.var_int_arr_d[21] * 6] & 0xFF) << 8 | f.var_byte_arr_e[this.var_int_arr_d[21] * 6 + 1] & 0xFF, (f.var_byte_arr_e[this.var_int_arr_d[21] * 6 + 2] & 0xFF) << 8 | f.var_byte_arr_e[this.var_int_arr_d[21] * 6 + 2 + 1] & 0xFF, f.var_byte_arr_e, f.var_int_k);
                this.var_int_arr_d[20] = 0;
                return;
            }
            case 6: {
                this.var_int_arr_d[15] = this.var_int_arr_d[16];
                this.var_int_arr_d[25] = this.var_int_arr_d[25] + 1;
                this.var_int_arr_d[20] = 0;
            }
        }
    }

    private void l(int n) {
        int n2 = f.var_int_arr_f[n] << 4;
        n = f.var_int_arr_g[n] << 4;
        if (f.boolean_c(this.var_int_arr_d[12], 3)) {
            f.void_c(this.var_int_arr_d[12]);
            d.f(this);
            int n3 = (f.byte_a(this.var_int_arr_d[12], 25) << 2) / 100;
            this.var_int_arr_d[48] = n3 + 4;
        }
        this.b(n2, n);
    }

    private static void f(d d2) {
        int n = d2.var_int_arr_d[12] * 231 + 1;
        for (int i = 0; i < 10; ++i) {
            d2.var_int_arr_d[i] = f.var_byte_arr_f[n + i];
        }
        if (d2.var_int_arr_d[1] == -1) {
            d2.var_int_arr_d[1] = f.var_byte_arr_b[1];
        }
    }

    /*
     * Unable to fully structure code
     */
    private boolean boolean_a(int var1_1, int var2_3) {
        var3_4 = f.var_int_arr_f[var2_3] << 4;
        var4_5 = f.var_int_arr_g[var2_3] << 4;
        var5_6 = f.int_b(f.var_int_arr_f[var2_3], f.var_int_arr_g[var2_3]);
        var6_7 = f.int_c(f.var_int_arr_f[var2_3], f.var_int_arr_g[var2_3]);
        f.void_a(this.var_int_a >> 4, this.var_int_b >> 4, false);
        if (this.boolean_a() && (var1_1 <= 0 || f.var_short_arr_b[var1_1] <= 0)) ** GOTO lbl-1000
        var1_2 = this;
        var7_8 = var1_2.var_int_a;
        var8_9 = var1_2.var_int_b;
        var1_2.var_int_a = var3_4;
        var1_2.var_int_b = var4_5;
        var3_4 = (int)var1_2.boolean_a();
        var1_2.var_int_a = var7_8;
        var1_2.var_int_b = var8_9;
        if ((var3_4 == 0 || f.var_short_arr_b[var2_3] > 0) && (f.int_a(var5_6, var6_7) & 2) == 0) {
            v0 = 1;
        } else lbl-1000:
        // 2 sources

        {
            v0 = 0;
        }
        var1_1 = v0;
        f.void_a(this.var_int_a >> 4, this.var_int_b >> 4, true);
        return (boolean)var1_1;
    }

    private void r() {
        if (this.var_int_q != 3) {
            this.var_int_arr_d[40] = 6;
            this.var_int_arr_d[41] = 7;
            this.var_int_arr_d[42] = 0;
            this.var_int_arr_d[43] = 1;
        }
    }

    private void c(int n, int n2, int n3, int n4) {
        if (n >= 0) {
            this.var_int_arr_d[40] = n;
        }
        if (n2 >= 0) {
            this.var_int_arr_d[41] = n2;
        } else if (this.var_int_arr_d[40] >= 0) {
            this.var_int_arr_d[41] = this.var_int_arr_d[40] + 1;
        }
        if (n3 >= 0) {
            this.var_int_arr_d[42] = n3;
        }
        if (n4 >= 0) {
            this.var_int_arr_d[43] = n4;
            return;
        }
        if (this.var_int_arr_d[42] >= 0) {
            this.var_int_arr_d[43] = this.var_int_arr_d[42] + 1;
        }
    }

    final void b(int n, int n2, int n3, int n4) {
        this.var_int_arr_d[44] = 1;
        this.r();
        this.c(n, -1, n3, -1);
    }

    final void void_h() {
        this.var_int_arr_d[44] = 0;
    }

    private void s() {
        this.d(this.ah, this.ai);
        this.var_int_arr_d[16] = this.var_int_arr_d[15];
        this.var_int_arr_d[15] = 3;
        this.var_int_arr_d[34] = -1;
        this.var_int_arr_d[35] = 100;
    }

    private void t() {
        f.var_int_arr_a[43] = 30;
        int[] nArray = new int[2];
        boolean bl = f.a(this, var_d_c, nArray);
        if (bl) {
            this.d(nArray[0], nArray[1]);
            this.var_int_arr_d[16] = this.var_int_arr_d[15];
            this.var_int_arr_d[15] = 3;
            this.var_int_arr_d[34] = -1;
            this.var_int_arr_d[35] = 100;
        }
    }

    private void u() {
        int n = f.byte_a(this.var_int_arr_d[12], 39);
        byte by = f.byte_b(this.var_int_arr_d[12], 4);
        if (by < n && f.int_a(by) >= 0) {
            n = f.int_a(by);
            this.b(f.int_f(n, 1));
        }
    }

    final void f(int n) {
        int n2 = this.var_int_arr_d[12];
        if (this.var_boolean_v) {
            f.void_b(n2, f.int_m(n2) + n);
            this.u();
            d d2 = this;
            n2 = 0;
            int n3 = f.byte_a(d2.var_int_arr_d[12], 39);
            int n4 = f.byte_b(d2.var_int_arr_d[12], 4);
            if (n4 < n3 && f.int_a(n4) >= 0 && f.int_f(n3 = f.int_a(n4), 2) > 0) {
                f.void_a(146, d2.var_int_arr_d[14], 8888, -1, -1);
                n2 = 1;
            }
            this.var_boolean_x |= n2;
            if (this.var_boolean_w) {
                d2 = this;
                n2 = f.byte_a(d2.var_int_arr_d[12], 39);
                byte by = f.byte_b(d2.var_int_arr_d[12], 4);
                n3 = by;
                if (by < n2 && f.int_a(n3) >= 0) {
                    n4 = f.int_a(n3);
                    d2.var_boolean_y = f.int_f(n4, 5) != 0;
                    d2.d_a().var_boolean_y = d2.var_boolean_y;
                }
            }
        }
    }

    private boolean boolean_b(d d2) {
        int n = this.ad;
        int n2 = d2.var_int_arr_d[14];
        return n == n2;
    }

    final void i() {
        if (this.var_boolean_u) {
            this.var_int_arr_d[28] = 3;
        }
    }

    final void j() {
        if (this.var_boolean_u) {
            this.var_int_arr_d[15] = 0;
            this.var_int_arr_d[28] = 0;
        }
    }

    final void void_a(d d2) {
        d d3 = d2;
        d d4 = this;
        int n = d4.var_int_arr_d[12];
        byte by = f.byte_a(n, 1);
        byte by2 = f.var_byte_arr_b[0];
        int n2 = d3.var_int_arr_d[12];
        byte by3 = f.byte_a(n2, 1);
        this.var_boolean_v = d4.boolean_a() && n != n2 && ((f.boolean_c(n, 4) || f.boolean_c(n, 1)) && by3 == by || d4.boolean_b(d3) && by2 == by);
        this.var_boolean_w = this.boolean_b(d2);
        if (d2 == this) {
            this.var_boolean_u = true;
            this.boolean_g();
            d4 = this;
            if (d4.var_short_a == ar) {
                ar = -1;
            }
            this.void_a(var_d_c, false);
            d.g(this);
            this.var_boolean_x = false;
            this.ax = this.var_int_a;
            this.ay = this.var_int_b;
            return;
        }
        if (this.var_boolean_v || this.var_boolean_w) {
            this.var_boolean_u = true;
            this.boolean_g();
            this.void_a(var_d_c, true);
            if (this.var_boolean_v) {
                this.var_boolean_x = false;
                this.ax = this.var_int_a;
                this.ay = this.var_int_b;
                this.u();
            }
        }
    }

    final void void_b(d d2) {
        if (d2 == this) {
            this.w();
            if (this.boolean_f() && !this.var_boolean_z && this.var_boolean_y) {
                this.var_boolean_z = true;
                this.var_boolean_y = false;
                d2 = this.d_a();
                int n = this.ax - d2.ax;
                int n2 = this.ay - d2.ay;
                this.c(this.ax + n / 2, this.ay + n2 / 2);
            }
        } else if (this.var_boolean_v || this.var_boolean_w) {
            int n;
            this.w();
            if (this.var_boolean_v) {
                d2 = this;
                n = f.byte_a(d2.var_int_arr_d[12], 39);
                byte by = f.byte_b(d2.var_int_arr_d[12], 4);
                if (by < n && f.int_a(by) >= 0) {
                    n = f.int_a(by);
                    n = f.int_f(n, 3);
                    d2.b(n, true);
                }
                d2 = this;
                n = f.byte_a(d2.var_int_arr_d[12], 39);
                by = f.byte_b(d2.var_int_arr_d[12], 4);
                if (by < n && f.int_a(by) >= 0) {
                    n = f.int_a(by);
                    by = f.byte_b(d2.var_int_arr_d[12], 0);
                    if (by > (n = f.int_f(n, 4))) {
                        f.a(d2.var_int_arr_d[12], 0, (byte)n);
                    }
                }
            }
            if (this.var_boolean_v && (this.var_boolean_x || !this.var_boolean_z && this.var_boolean_y)) {
                int n3 = this.ax;
                n = this.ay;
                if (this.var_boolean_w && !this.var_boolean_z && this.var_boolean_y) {
                    this.var_boolean_z = true;
                    this.var_boolean_y = false;
                    d d3 = this.d_a();
                    int n4 = this.ax - d3.ax;
                    int n5 = this.ay - d3.ay;
                    n3 += n4;
                    n += n5;
                }
                this.c(n3, n);
            }
        }
        this.var_boolean_v = false;
        this.var_boolean_u = false;
        this.var_boolean_w = false;
    }

    private static int int_a(d d2) {
        int n = -1;
        if (d2.var_int_arr_d[24] != d2.var_int_arr_d[26] && d2.var_int_arr_d[24] != -1) {
            int n2 = (f.var_byte_arr_e[d2.var_int_arr_d[24] * 6 + 2] & 0xFF) << 8 | f.var_byte_arr_e[d2.var_int_arr_d[24] * 6 + 2 + 1] & 0xFF;
            int n3 = (f.var_byte_arr_e[d2.var_int_arr_d[24] * 6] & 0xFF) << 8 | f.var_byte_arr_e[d2.var_int_arr_d[24] * 6 + 1] & 0xFF;
            n3 = n3 * 10 + f.var_int_k * 6;
            int n4 = -1;
            int n5 = 0;
            while (n5 < n2 && n4 != 166) {
                n4 = (f.var_byte_arr_e[n3] & 0xFF) << 8 | f.var_byte_arr_e[n3 + 1] & 0xFF;
                if (n4 == 166) {
                    n = (f.var_byte_arr_e[n3 + 4] & 0xFF) << 8 | f.var_byte_arr_e[n3 + 4 + 1] & 0xFF;
                    continue;
                }
                ++n5;
                n3 += 10;
            }
        }
        return n;
    }

    private static void g(d d2) {
        int n = 1;
        int n2 = d.int_a(d2);
        if (n2 > -1) {
            n = n2;
        }
        d2.b(n);
    }

    private boolean boolean_e() {
        int n = 34;
        if (this.var_int_q == 3) {
            n = 11;
        }
        return this.var_int_arr_d[n] != -1;
    }

    public final void k() {
        int n = 34;
        int n2 = 35;
        if (this.var_int_q == 3) {
            n = 11;
            n2 = 12;
        }
        this.r();
        int n3 = f.int_f(this.var_int_arr_d[n]);
        if (n3 >= 0) {
            this.b(n3);
        }
        this.var_int_arr_d[n2] = f.int_g(this.var_int_arr_d[n]);
        if (this.var_int_q == 4) {
            this.var_int_arr_d[15] = 10;
            this.var_int_arr_d[17] = 3;
            return;
        }
        var_int_z = 10;
        A = 3;
    }

    public final void g(int n) {
        if (n < 0) {
            return;
        }
        int n2 = f.var_int_arr_f[n] << 4;
        int n3 = f.var_int_arr_g[n] << 4;
        this.d(n2, n3);
        if (this.var_int_q == 4) {
            this.var_int_arr_d[16] = this.var_int_arr_d[15];
            this.var_int_arr_d[15] = 3;
            this.r();
            this.c(f.int_j(n), f.int_k(n), f.int_h(n), f.int_i(n));
        } else {
            aq = var_int_z;
            var_int_z = 9;
        }
        n2 = 34;
        n3 = 35;
        if (this.var_int_q == 3) {
            n2 = 11;
            n3 = 12;
        }
        this.var_int_arr_d[n2] = n;
        this.var_int_arr_d[n3] = 0;
    }

    private boolean boolean_f() {
        return this.ad >= 0;
    }

    private d d_a() {
        if (this.boolean_f()) {
            return f.d_a(this.ad);
        }
        return null;
    }

    public final void h(int n) {
        this.b(n, true);
    }

    private void b(int n, boolean bl) {
        while (true) {
            d3.var_int_arr_d[26] = n;
            if (!bl || !d3.boolean_f()) break;
            d d2 = d3.d_a();
            if (d3.var_boolean_t) break;
            d3.var_boolean_t = true;
            d2.var_boolean_t = true;
            d2.var_int_l = d3.var_int_l;
            d2.var_int_m = d3.var_int_m;
            bl = false;
            n = 156;
            d d3 = d2;
        }
    }

    public final void i(int n) {
        int n2 = this.var_int_arr_d[24];
        if (n != n2) {
            var_int_v = -1;
            this.var_d_b.var_int_g = -1;
        }
        this.var_int_arr_d[24] = n;
    }

    private static void h(d d2) {
        int n = 1;
        if (d2.var_int_arr_d[34] != -1 && d2.var_int_arr_d[42] >= 0) {
            int n2 = n = d2.var_int_l == 0 ? d2.var_int_arr_d[42] : d2.var_int_arr_d[43];
        }
        if (d2.var_int_g != n) {
            d2.b(n);
        }
    }

    static void c(d d2) {
        d2.var_int_arr_d[15] = 0;
        d2.var_int_arr_d[28] = 0;
        if (d2.var_int_arr_d[32] > -1) {
            d d3 = f.var_d_arr_a[d2.var_int_arr_d[32]];
            do {
                if (d3.var_int_arr_d[15] != 12) continue;
                d3.var_int_arr_d[15] = 8;
            } while ((d3 = f.var_d_arr_a[d3.var_int_arr_d[32]]) != d2 && d3 != null);
        }
    }

    static void d(d d2) {
        if (d2.var_int_arr_d[32] > -1) {
            d d3 = f.var_d_arr_a[d2.var_int_arr_d[32]];
            do {
                if (d3.var_int_arr_d[24] != d3.var_int_arr_d[26] || d3.var_int_arr_d[15] == 12) continue;
                d3.var_int_arr_d[15] = 12;
                d.h(d3);
            } while ((d3 = f.var_d_arr_a[d3.var_int_arr_d[32]]) != d2 && d3 != null);
        }
    }

    private void v() {
        if ((this.var_int_k & 0x4000) != 0) {
            return;
        }
        this.var_int_k |= 0x4000;
        if ((this.var_int_k & 0x2000) != 0) {
            this.var_int_k &= 0xFFFFEFFF;
        }
        switch (this.var_int_arr_d[0]) {
            case 0: {
                this.var_int_k &= 0xFFFFBFFF;
                int n = d.var_d_c.var_int_a;
                int n2 = d.var_d_c.var_int_b;
                d.var_d_c.var_int_a = d.var_d_c.af;
                d.var_d_c.var_int_b = d.var_d_c.ag;
                if (this.var_int_q == 8) {
                    if (B != 0 && C != 0) {
                        if (d.a(d.var_d_c.var_int_a + B, d.var_d_c.var_int_b, true)) {
                            d.var_d_c.var_int_a += B;
                        } else if (d.a(d.var_d_c.var_int_a, d.var_d_c.var_int_b + C, true)) {
                            d.var_d_c.var_int_b += C;
                        }
                    } else if (C != 0) {
                        d.var_d_c.var_int_a = Math.abs(this.var_int_arr_r[0] - d.var_d_c.var_int_a) < Math.abs(this.var_int_arr_r[2] - d.var_d_c.var_int_a) ? (d.var_d_c.var_int_a -= 64) : (d.var_d_c.var_int_a += 64);
                    } else if (B != 0) {
                        d.var_d_c.var_int_b = Math.abs(this.var_int_arr_r[1] - d.var_d_c.var_int_b) < Math.abs(this.var_int_arr_r[3] - d.var_d_c.var_int_b) ? (d.var_d_c.var_int_b -= 32) : (d.var_d_c.var_int_b += 32);
                    }
                    if (!d.a(d.var_d_c.var_int_a, d.var_d_c.var_int_b, true)) {
                        d.var_d_c.var_int_a = d.var_d_c.af;
                        d.var_d_c.var_int_b = d.var_d_c.ag;
                    }
                } else if (B != 0 && C != 0) {
                    if (B > 0 && C > 0) {
                        if (d.a(d.var_d_c.var_int_a - 256, d.var_d_c.var_int_b + 128, true)) {
                            d.var_d_c.var_int_a -= 64;
                            d.var_d_c.var_int_b += 32;
                        }
                    } else if (B < 0 && C > 0) {
                        if (d.a(d.var_d_c.var_int_a + 256, d.var_d_c.var_int_b + 128, true)) {
                            d.var_d_c.var_int_a += 64;
                            d.var_d_c.var_int_b += 32;
                        }
                    } else if (B > 0 && C < 0) {
                        if (d.a(d.var_d_c.var_int_a - 256, d.var_d_c.var_int_b - 128, true)) {
                            d.var_d_c.var_int_a -= 64;
                            d.var_d_c.var_int_b -= 32;
                        }
                    } else if (B < 0 && C < 0 && d.a(d.var_d_c.var_int_a + 256, d.var_d_c.var_int_b - 128, true)) {
                        d.var_d_c.var_int_a += 64;
                        d.var_d_c.var_int_b -= 32;
                    }
                    if (d.a(n, n2, true)) {
                        d.var_d_c.var_int_a = d.var_d_c.af;
                        d.var_d_c.var_int_b = d.var_d_c.ag;
                    }
                } else {
                    if (C != 0) {
                        if (d.a(d.var_d_c.var_int_a + 256, n2, true)) {
                            d.var_d_c.var_int_a += 64;
                            d.var_d_c.var_int_b = C > 0 ? (d.var_d_c.var_int_b += 32) : (d.var_d_c.var_int_b -= 32);
                        } else if (d.a(d.var_d_c.var_int_a - 256, n2, true)) {
                            d.var_d_c.var_int_a -= 64;
                            d.var_d_c.var_int_b = C > 0 ? (d.var_d_c.var_int_b += 32) : (d.var_d_c.var_int_b -= 32);
                        }
                    } else if (B != 0) {
                        if (d.a(d.var_d_c.var_int_a, d.var_d_c.var_int_b + 128, true)) {
                            d.var_d_c.var_int_b += 32;
                            d.var_d_c.var_int_a = B > 0 ? (d.var_d_c.var_int_a += 64) : (d.var_d_c.var_int_a -= 64);
                        } else if (d.a(d.var_d_c.var_int_a, d.var_d_c.var_int_b - 128, true)) {
                            d.var_d_c.var_int_b -= 32;
                            d.var_d_c.var_int_a = B > 0 ? (d.var_d_c.var_int_a += 64) : (d.var_d_c.var_int_a -= 64);
                        }
                    }
                    if (d.a(n, n2, true)) {
                        d.var_d_c.var_int_a = d.var_d_c.af;
                        d.var_d_c.var_int_b = d.var_d_c.ag;
                    }
                }
                f.void_a(n >> 4, n2 >> 4, false);
                f.void_a(d.var_d_c.var_int_a >> 4, d.var_d_c.var_int_b >> 4, true);
                return;
            }
            case 1: 
            case 2: {
                boolean bl = true;
                if (this.var_int_arr_d[0] == 2) {
                    bl = false;
                    this.var_int_k &= 0xFFFFBFFF;
                    ++D;
                }
                if (!bl) break;
                if (this.var_int_q == 8) {
                    if (this.var_int_arr_d[4] <= 0) {
                        f.void_a(this.var_int_arr_d[5], this.var_int_arr_d[6], this.var_int_arr_d[7], this.var_int_arr_d[8], -1);
                        return;
                    }
                    f.void_a(this.var_int_arr_d[4], this.var_int_arr_d[5], this.var_int_arr_d[6], this.var_int_arr_d[7]);
                    return;
                }
                if (this.var_int_arr_d[5] <= 0) {
                    f.void_a(this.var_int_arr_d[6], this.var_int_arr_d[7], this.var_int_arr_d[8], this.var_int_arr_d[9], -1);
                    return;
                }
                f.void_a(this.var_int_arr_d[5], this.var_int_arr_d[6], this.var_int_arr_d[7], this.var_int_arr_d[8]);
            }
        }
    }

    private void e(int n, int n2) {
        this.b(this.var_int_l == 0 ? 3 : 2);
        this.var_int_k = this.var_int_k & 0xFFFFFFFE | 1 & this.var_int_m;
        this.d(n, n2);
        this.var_int_arr_d[2] = 1;
    }

    private void m(int n) {
        this.b(0);
        this.var_int_k = this.var_int_k & 0xFFFFFFFE | 1 & this.var_int_m;
        this.var_int_arr_d[4] = n;
        this.var_int_arr_d[2] = 0;
    }

    final void j(int n) {
        this.var_int_arr_d[5] = n;
        this.var_int_arr_d[3] = 1;
        d d2 = f.var_d_arr_a[f.int_b(this.var_int_arr_d[5])];
        this.e(d2.var_int_a, d2.var_int_b);
    }

    final void k(int n) {
        this.var_int_arr_d[5] = n;
        this.var_int_arr_d[3] = 2;
        d d2 = f.var_d_arr_a[f.int_b(this.var_int_arr_d[5])];
        this.e(d2.var_int_a, d2.var_int_b);
    }

    final void l() {
        this.var_int_arr_d[3] = 0;
        this.m(0);
    }

    final void m() {
        this.var_int_arr_d[6] = 1;
    }

    final void n() {
        this.var_int_arr_d[6] = 0;
    }

    private static boolean a(int n, int n2, int[] nArray) {
        for (int i = 0; i < nArray.length; i += 2) {
            int n3 = nArray[i + 1];
            int n4 = nArray[(i + 2) % nArray.length];
            int n5 = nArray[i];
            int n6 = nArray[(i + 3) % nArray.length];
            if ((n2 - n3) * (n4 - n5) - (n6 - n3) * (n - n5) >= 0) continue;
            return false;
        }
        return true;
    }

    private void n(int n) {
        if (n < this.var_int_a) {
            this.var_int_m = 1;
            return;
        }
        if (n > this.var_int_a) {
            this.var_int_m = 0;
        }
    }

    final void e(d d2) {
        this.void_a(d2, true);
    }

    private void void_a(d d2, boolean bl) {
        if (this.var_int_q == 4 && f.int_a(this, 2, 7) == 1) {
            return;
        }
        this.n(d2.var_int_a);
        this.var_int_l = 1;
        if (bl) {
            this.b(0 + this.var_int_l);
        }
    }

    final void void_a(int n, int n2) {
        this.var_int_m = n;
        this.var_int_l = n2;
    }

    private boolean boolean_g() {
        boolean bl = false;
        if (this.an == -1) {
            this.an = this.var_int_m;
            bl = true;
        }
        if (this.ao == -1) {
            this.ao = this.var_int_l;
            bl = true;
        }
        return bl;
    }

    private void w() {
        if (this.an != -1) {
            this.var_int_m = this.an;
        }
        if (this.ao != -1) {
            this.var_int_l = this.ao;
        }
        this.ao = -1;
        this.an = -1;
    }

    final void b(int n, int n2) {
        f.void_a(this.var_int_a >> 4, this.var_int_b >> 4, false);
        this.var_int_a = n;
        this.var_int_b = n2;
        f.void_a(this.var_int_a >> 4, this.var_int_b >> 4, true);
    }

    private void f(int n, int n2) {
        block17: {
            int n3;
            d d2;
            block15: {
                block16: {
                    block14: {
                        f.void_a(this.var_int_a >> 4, this.var_int_b >> 4, false);
                        n = n - this.var_int_a >> 4;
                        n2 = n2 - this.var_int_b >> 4;
                        int n4 = 8;
                        if (this.var_int_q == 4) {
                            n4 = this.var_int_arr_d[48];
                        } else if (this.var_int_q == 19) {
                            n4 = 9;
                        }
                        if (Math.abs(n) > n4) {
                            n /= Math.abs(n);
                            n *= n4;
                        }
                        if (Math.abs(n2) > n4) {
                            n2 /= Math.abs(n2);
                            n2 *= n4;
                        }
                        if (n > 0) {
                            this.var_int_m = 0;
                        } else if (n < 0) {
                            this.var_int_m = 1;
                        }
                        if (n2 > 0) {
                            this.var_int_l = 1;
                        } else if (n2 < 0) {
                            this.var_int_l = 0;
                        }
                        n = (this.var_int_a >> 4) + n << 4;
                        n2 = (this.var_int_b >> 4) + n2 << 4;
                        this.var_int_a = n;
                        this.var_int_b = n2;
                        if (this.var_int_q != 3) break block14;
                        d2 = this;
                        n3 = 6 + this.var_int_l;
                        break block15;
                    }
                    if (this.var_int_q != 4) break block16;
                    this.b(this.var_int_l == 0 ? this.var_int_arr_d[40] : this.var_int_arr_d[41]);
                    break block17;
                }
                if (this.var_int_q != 19) break block17;
                d2 = this;
                n3 = this.var_int_l == 0 ? 3 : 2;
            }
            d2.b(n3);
        }
        f.void_a(this.var_int_a >> 4, this.var_int_b >> 4, true);
    }

    final void c(int n, int n2) {
        this.d(n, n2);
        if (this.var_int_arr_d[15] != 6) {
            this.var_int_arr_d[16] = this.var_int_arr_d[15];
        }
        this.var_int_arr_d[15] = 3;
    }

    private static boolean b(int n, int n2, int[] nArray) {
        if (n < nArray[0]) {
            return false;
        }
        if (n > nArray[2]) {
            return false;
        }
        if (n2 < nArray[1]) {
            return false;
        }
        return n2 <= nArray[3];
    }

    private boolean boolean_a(int n, int n2, int n3) {
        if (Math.abs(this.var_int_a - n) > n3 << 4) {
            return false;
        }
        return Math.abs(this.var_int_b - n2) <= n3 << 4;
    }

    /*
     * Unable to fully structure code
     */
    final void void_a(int var1_1, int var2_2, int var3_3) {
        switch (this.var_int_q) {
            case 5: 
            case 8: {
                switch (var1_1) {
                    case 10: {
                        this.var_int_k &= -16385;
                        this.v();
                        return;
                    }
                    case 11: {
                        this.var_int_k |= 4096;
                        this.var_int_k &= -16385;
                        return;
                    }
                    case 12: {
                        this.var_int_k &= -4097;
                        return;
                    }
                }
            }
        }
        switch (var1_1) {
            case 20: {
                this.var_boolean_c = false;
                ** GOTO lbl90
            }
            case 21: {
                this.var_boolean_c = true;
                ** GOTO lbl90
            }
            case 22: {
                this.var_boolean_p = true;
                return;
            }
            case 23: {
                this.var_boolean_p = false;
                return;
            }
            case 24: {
                this.var_int_q = 0;
                return;
            }
            case 27: {
                f.void_b(this);
                return;
            }
            case 26: {
                if (this.var_int_q != 1 || (this.var_int_k & 8192) == 0) break;
                var1_1 = 0;
                var2_2 = 0;
                while (var2_2 < f.var_short_arr_a.length && var1_1 == 0) {
                    if (f.var_short_arr_a[var2_2] == this.var_int_f) {
                        var1_1 = 1;
                    } else {
                        for (var3_3 = 0; var3_3 < f.var_byte_arr_arr_arr_a[var2_2].length; ++var3_3) {
                            if (f.var_byte_arr_arr_arr_a[var2_2][var3_3].length <= 2 || (var4_5 = f.var_short_arr_a[f.var_byte_arr_arr_arr_a[var2_2][var3_3][2]]) != this.var_int_f) continue;
                            var1_1 = 1;
                        }
                    }
                    if (var1_1 != 0) continue;
                    ++var2_2;
                }
                if (var1_1 == 0) break;
                var3_3 = f.var_byte_arr_b[3100 + (var2_2 << 1)];
                this.var_int_h = f.var_byte_arr_arr_arr_a[var2_2][var3_3][0];
                if ((this.var_int_k & 512) != 0) {
                    ++this.var_int_h;
                }
                this.var_int_arr_d[1] = f.var_byte_arr_arr_arr_a[var2_2][var3_3][1];
                var4_6 = d.var_a_arr_a[this.var_int_f];
                for (var1_1 = 0; var1_1 < var4_6.var_int_b; ++var1_1) {
                    var4_6.void_b(var1_1);
                }
                this.var_int_f = f.var_byte_arr_arr_arr_a[var2_2][var3_3].length > 2 ? f.var_short_arr_a[f.var_byte_arr_arr_arr_a[var2_2][var3_3][2]] : f.var_short_arr_a[var2_2];
                var4_6 = d.var_a_arr_a[this.var_int_f];
                var1_1 = 0;
                for (var2_2 = 0; var2_2 < f.var_int_arr_a[3]; ++var2_2) {
                    var3_4 = f.var_d_arr_a[var2_2];
                    if (var3_4 == null || var3_4.var_int_f != this.var_int_f) continue;
                    var1_1 |= 1 << var3_4.var_int_arr_d[1];
                }
                d.var_int_arr_a[this.var_int_f] = var1_1;
                for (var2_2 = 0; var2_2 < var4_6.var_int_b; ++var2_2) {
                    if ((var1_1 >> var2_2 & 1) == 0) continue;
                    var4_6.a(var2_2, 0, -1, -1);
                }
                var4_6.var_int_a = d.ae;
                ** GOTO lbl90
            }
            case 25: {
                this.var_byte_a = (byte)var2_2;
                return;
            }
            case 131: {
                this.var_int_m = var2_2;
                this.var_int_l = var3_3;
                return;
            }
            case 262: {
                switch (this.var_int_q) {
                    case 1: {
                        this.var_int_h = var2_2;
                        break;
                    }
                    case 2: 
                    case 19: {
                        this.b(var2_2);
                    }
                }
                if (var3_3 > -1) {
                    this.var_int_arr_d[1] = var3_3;
                }
lbl90:
                // 6 sources

                f.void_a(this);
            }
        }
    }

    /*
     * Unable to fully structure code
     */
    private void x() {
        block12: {
            block13: {
                var1_1 = this.var_int_q == 4 ? 39 : 7;
                var2_2 = this.var_e_a.a();
                var4_3 = var2_2 = var2_2 - 1 - this.ap;
                var3_4 = this;
                var5_7 = -1;
                var6_8 = var3_4.var_e_a.a();
                if (var4_3 > 0 && var6_8 > 0) {
                    var7_9 = var3_4.var_e_a.int_a(var4_3 - 1) - var3_4.var_e_a.int_a(var4_3);
                    var8_10 = var3_4.var_e_a.int_b(var4_3 - 1) - var3_4.var_e_a.int_b(var4_3);
                    f.void_a(var3_4.var_int_a >> 4, var3_4.var_int_b >> 4, false);
                    var6_8 = var4_3;
                    var11_11 = 0;
                    var12_12 = 0;
                    var13_13 = 0;
                    while (var11_11 == 0 && var12_12 == 0 && var13_13 == 0) {
                        var9_14 = var3_4.var_e_a.int_a(var6_8 - 1) - var3_4.var_e_a.int_a(var6_8);
                        var10_15 = var3_4.var_e_a.int_b(var6_8 - 1) - var3_4.var_e_a.int_b(var6_8);
                        var14_16 = var3_4.var_e_a.int_a(var6_8);
                        if ((f.int_a(var14_16, var15_17 = var3_4.var_e_a.int_b(var6_8)) & 2) != 0) {
                            var12_12 = 1;
                            continue;
                        }
                        if (var9_14 != var7_9 || var10_15 != var8_10) {
                            var11_11 = 1;
                            continue;
                        }
                        if (var6_8 - 1 == 0 || var4_3 - var6_8 > 6) {
                            var13_13 = 1;
                            continue;
                        }
                        --var6_8;
                    }
                    f.void_a(var3_4.var_int_a >> 4, var3_4.var_int_b >> 4, true);
                    if (var12_12 != 0) {
                        var5_7 = var6_8;
                    }
                }
                if ((var3_5 = var5_7) >= 0 && f.int_d(var3_5 - var2_2) <= 1 && this.var_int_arr_d[var1_1] > 5) {
                    this.var_int_arr_d[var1_1] = 5;
                }
                if (this.var_int_arr_d[var1_1] > 0) {
                    v0 = var1_1;
                    this.var_int_arr_d[v0] = this.var_int_arr_d[v0] - 1;
                }
                if (var3_5 < 0 || this.var_int_arr_d[var1_1] > 0) break block12;
                var5_7 = var3_5;
                var4_3 = var2_2;
                var3_6 = this;
                var6_8 = var3_6.var_e_a.int_a(var4_3 - 1) - var3_6.var_e_a.int_a(var4_3);
                var7_9 = var3_6.var_e_a.int_b(var4_3 - 1) - var3_6.var_e_a.int_b(var4_3);
                v1 = var8_10 = f.int_d(f.int_f()) % 2 == 0 ? -1 : 1;
                if (var6_8 == 0 || var7_9 == 0) break block13;
                var6_8 = var8_10;
                ** GOTO lbl-1000
            }
            v2 = var6_8 = var6_8 == 0 ? var8_10 : 0;
            if (var7_9 == 0) {
                v3 = var8_10;
            } else lbl-1000:
            // 2 sources

            {
                v3 = 0;
            }
            var9_14 = v3;
            var10_15 = f.int_d(var5_7 - var4_3) <= 0 ? 1 : 0;
            var11_11 = var10_15 != 0 ? var4_3 : var4_3 - 1;
            for (var12_12 = var11_11; var12_12 >= var5_7 - 1; --var12_12) {
                var13_13 = var3_6.var_e_a.int_a(var12_12) + var6_8;
                var14_16 = var3_6.var_e_a.int_b(var12_12) + var9_14;
                var15_17 = var12_12 > 0 ? var3_6.var_e_a.int_a(var12_12 - 1) : var13_13;
                v4 = var2_2 = var12_12 > 0 ? var3_6.var_e_a.int_b(var12_12 - 1) : var14_16;
                if (var13_13 < 0 || var13_13 >= f.var_int_a || var14_16 < 0 || var14_16 >= f.var_int_b || f.int_d(var15_17 - var13_13) > 1 || f.int_d(var2_2 - var14_16) > 1 || (f.int_a(var13_13, var14_16) & 1) != 0) continue;
                var3_6.var_e_a.a(var12_12, var13_13);
                var3_6.var_e_a.b(var12_12, var14_16);
            }
        }
        if (this.var_int_arr_d[var1_1] <= 0) {
            this.var_int_arr_d[var1_1] = 10 + f.int_d(f.int_f()) % 11;
        }
    }

    public final void d(int n, int n2) {
        int n3 = this.var_int_a >> 4;
        int n4 = this.var_int_b >> 4;
        int n5 = n3;
        int n6 = n4;
        n4 = n2 >>= 4;
        n3 = n >>= 4;
        n2 = n6;
        n = n5;
        if (this.var_e_a == null) {
            d d2 = this;
            this.var_e_a = new e();
            d2.var_e_a.a(f.var_int_a, f.var_int_b, f.var_byte_arr_a, 10, 10, 0, 8, 3, 0);
        }
        this.ap = 0;
        int n7 = f.int_b(n, n2);
        n = f.int_c(n, n2);
        n2 = f.int_b(n3, n4);
        int n8 = f.int_c(n3, n4);
        boolean bl = f.boolean_b(n3, n4);
        if (bl) {
            f.void_a(n3, n4, false);
        }
        int n9 = n7;
        d d3 = this;
        int n10 = d3.var_int_m == 1 ? 2 : 3;
        d3.var_e_a.a(n9, n, n10, n2, n8);
        boolean bl2 = d3.var_e_a.a() > 0;
        if (bl) {
            f.void_a(n3, n4, true);
        }
    }

    private int int_a(boolean bl) {
        int n = this.var_e_a.a();
        n = n - 1 - this.ap;
        int n2 = f.int_d(this.var_e_a.int_a(n), this.var_e_a.int_b(n));
        n2 = n2 + 2 << 4;
        if (this == var_d_c && bl && n == 0 && var_d_d != null) {
            n2 = this.var_int_a < d.var_d_d.var_int_a ? Math.max(n2, d.var_d_d.var_int_a - 400) : Math.min(n2, d.var_d_d.var_int_a + 400);
        }
        return n2;
    }

    private int int_b(boolean bl) {
        int n = this.var_e_a.a();
        n = n - 1 - this.ap;
        int n2 = f.int_e(this.var_e_a.int_a(n), this.var_e_a.int_b(n));
        n2 = n2 + 4 << 4;
        if (this == var_d_c && bl && n == 0 && var_d_d != null) {
            n2 = this.var_int_b < d.var_d_d.var_int_b ? Math.max(n2, d.var_d_d.var_int_b - 80) : Math.min(n2, d.var_d_d.var_int_b + 80);
        }
        return n2;
    }

    private boolean boolean_h() {
        return this.ap < this.var_e_a.a();
    }

    static {
        int[] nArray = new int[]{1, 1, 1, 1, 1, 1111, 1, 1, 1};
        var_a_arr_a = null;
        var_boolean_arr_a = null;
        var_boolean_arr_b = null;
        var_int_arr_a = null;
        var_int_arr_b = null;
        var_int_arr_c = null;
        var_int_v = -1;
        var_int_w = 0;
        var_int_x = 0;
        var_int_arr_e = new int[64];
        var_int_arr_f = new int[64];
        var_int_arr_g = new int[64];
        var_int_arr_h = new int[64];
        var_int_arr_i = new int[64];
        var_int_y = 0;
        var_int_arr_j = new int[64];
        var_int_arr_k = new int[64];
        var_int_arr_l = new int[64];
        var_int_arr_m = new int[64];
        var_int_arr_n = new int[64];
        var_int_arr_o = new int[64];
        var_int_arr_p = new int[64];
        var_int_arr_q = new int[64];
        var_boolean_h = false;
        var_boolean_arr_c = null;
        D = 0;
        F = 1;
        var_boolean_i = false;
        var_boolean_j = false;
        var_boolean_k = false;
        V = -1;
        W = -1;
        ar = -1;
        as = 0;
        at = 0;
        au = 0;
        av = 0;
        X = 0;
        Y = 1;
        Z = 6;
        aa = 7;
        ab = -1;
        ac = -1;
        var_int_arr_s = new int[]{1, -1};
        var_int_arr_t = new int[]{-1, 1};
        aw = Integer.MAX_VALUE;
        var_boolean_s = false;
        var_boolean_l = false;
        var_boolean_m = true;
        var_boolean_n = false;
        ae = -1;
        var_boolean_o = false;
    }
}


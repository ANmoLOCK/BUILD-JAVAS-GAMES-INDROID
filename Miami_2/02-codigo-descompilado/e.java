/*
 * Decompiled with CFR 0.152.
 */
final class e {
    private static int[] var_int_arr_a;
    private static int var_int_a;
    private static short[] var_short_arr_a;
    private static short[] var_short_arr_b;
    private static short[] var_short_arr_c;
    private static short[] var_short_arr_d;
    private static short[] var_short_arr_e;
    private int var_int_b;
    private int var_int_c;
    private int var_int_d;
    private int var_int_e;
    private int var_int_f;
    private int g;
    private byte[] var_byte_arr_a;
    private int h;
    private int i;
    private short[] var_short_arr_f;
    private int j;
    private int k;

    public final void a(int n, int n2, byte[] byArray, int n3, int n4, int n5, int n6, int n7, int n8) {
        var_int_a = n * n2;
        this.var_int_f = n;
        this.g = n2;
        this.var_byte_arr_a = byArray;
        this.h = n7;
        this.i = n8;
        this.var_int_b = 10;
        this.var_int_c = n4;
        this.var_int_d = 0;
        this.var_int_e = 8;
        var_short_arr_a = new short[var_int_a];
        var_short_arr_b = new short[var_int_a];
        var_short_arr_c = new short[var_int_a];
        var_short_arr_d = new short[var_int_a];
        var_short_arr_e = new short[var_int_a];
        this.k = -1;
        this.var_short_arr_f = new short[var_int_a];
        this.j = -1;
    }

    public final void a(int n, int n2, int n3, int n4, int n5) {
        int n6;
        for (n6 = 0; n6 < var_int_a; ++n6) {
            e.var_short_arr_a[n6] = -1;
            e.var_short_arr_b[n6] = -1;
            e.var_short_arr_c[n6] = -1;
            e.var_short_arr_d[n6] = 0;
            e.var_short_arr_e[n6] = 0;
        }
        this.k = -1;
        for (n6 = 0; n6 < var_int_a; ++n6) {
            this.var_short_arr_f[n6] = 0;
        }
        n = n2 * this.var_int_f + n;
        while (n != -1) {
            this.void_b(n);
            e.var_short_arr_d[n] = -1;
            e.var_short_arr_e[n] = -1;
            n2 = n % this.var_int_f;
            int n7 = n / this.var_int_f;
            if (n2 == n4 && n7 == n5) break;
            for (int i = 0; i < this.var_int_e; ++i) {
                int n8 = var_int_arr_a[i << 1];
                int n9 = var_int_arr_a[(i << 1) + 1];
                int n10 = n8 != 0 && n9 != 0 ? this.var_int_c : this.var_int_b;
                if ((n8 += n2) < 0 || n8 >= this.var_int_f || (n9 += n7) < 0 || n9 >= this.g) continue;
                if (i >= 4) {
                    if (i == 4) {
                        if ((this.var_byte_arr_a[n - 1] & this.h) != 0 || (this.var_byte_arr_a[n - this.var_int_f] & this.h) != 0) {
                            continue;
                        }
                    } else if (i == 5) {
                        if ((this.var_byte_arr_a[n + 1] & this.h) != 0 || (this.var_byte_arr_a[n - this.var_int_f] & this.h) != 0) {
                            continue;
                        }
                    } else if (i != 6 ? i == 7 && ((this.var_byte_arr_a[n + 1] & this.h) != 0 || (this.var_byte_arr_a[n + this.var_int_f] & this.h) != 0) : (this.var_byte_arr_a[n - 1] & this.h) != 0 || (this.var_byte_arr_a[n + this.var_int_f] & this.h) != 0) continue;
                }
                n6 = n9 * this.var_int_f + n8;
                int n11 = this.var_byte_arr_a[n9 * this.var_int_f + n8];
                if ((n11 & this.h) != 0) continue;
                int n12 = n11 & this.i;
                if (var_short_arr_d[n6] == -1) continue;
                n11 = n3 == i ? 0 : this.var_int_d;
                n11 = var_short_arr_d[n] + n10 + n11 + n12;
                n8 = Math.abs(n8 - n4);
                n9 = Math.abs(n9 - n5);
                n8 = n8 > n9 ? this.var_int_c * n9 + this.var_int_b * (n8 - n9) : this.var_int_c * n8 + this.var_int_b * (n9 - n8);
                if (var_short_arr_b[n6] == -1 && var_short_arr_c[n6] == -1 && this.k != n6) {
                    e.var_short_arr_a[n6] = (short)n;
                    e.var_short_arr_d[n6] = (short)n11;
                    e.var_short_arr_e[n6] = (short)n8;
                    this.void_a(n6);
                    continue;
                }
                if (var_short_arr_d[n6] <= n11) continue;
                e.var_short_arr_a[n6] = (short)n;
                e.var_short_arr_d[n6] = (short)n11;
                this.void_b(n6);
                this.void_a(n6);
            }
            n = this.k;
            if (n == -1) continue;
            n2 = var_short_arr_a[n];
            if (n % this.var_int_f != n2 % this.var_int_f) {
                if (n % this.var_int_f > n2 % this.var_int_f) {
                    n3 = 3;
                    continue;
                }
                n3 = 2;
                continue;
            }
            if (n / this.var_int_f > n2 / this.var_int_f) {
                n3 = 1;
                continue;
            }
            n3 = 0;
        }
        if (n == -1) {
            this.j = -1;
            return;
        }
        this.j = 0;
        while (n != -1) {
            this.var_short_arr_f[this.j++] = (short)n;
            n = var_short_arr_a[n];
        }
        --this.j;
    }

    public final int a() {
        return this.j + 1;
    }

    public final int int_a(int n) {
        return this.var_short_arr_f[n] % this.var_int_f;
    }

    public final int int_b(int n) {
        return this.var_short_arr_f[n] / this.var_int_f;
    }

    public final void a(int n, int n2) {
        this.var_short_arr_f[n] = (short)(this.int_b(n) * this.var_int_f + n2);
    }

    public final void b(int n, int n2) {
        this.var_short_arr_f[n] = (short)(n2 * this.var_int_f + this.int_a(n));
    }

    private void void_a(int n) {
        if (this.k == -1) {
            this.k = n;
            return;
        }
        int n2 = var_short_arr_d[n] + var_short_arr_e[n];
        int n3 = this.k;
        while (n3 != -1) {
            int n4 = var_short_arr_d[n3] + var_short_arr_e[n3];
            if (n2 < n4) {
                if (var_short_arr_b[n3] == -1) {
                    this.k = n;
                } else {
                    short s = var_short_arr_b[n3];
                    e.var_short_arr_c[s] = (short)n;
                }
                e.var_short_arr_b[n] = var_short_arr_b[n3];
                e.var_short_arr_c[n] = (short)n3;
                e.var_short_arr_b[n3] = (short)n;
                return;
            }
            if (var_short_arr_c[n3] == -1) {
                e.var_short_arr_c[n3] = (short)n;
                e.var_short_arr_b[n] = (short)n3;
                return;
            }
            n3 = var_short_arr_c[n3];
        }
    }

    private void void_b(int n) {
        short s;
        if (n >= var_short_arr_c.length) {
            return;
        }
        if (var_short_arr_c[n] != -1) {
            s = var_short_arr_c[n];
            e.var_short_arr_b[s] = var_short_arr_b[n];
        }
        if (this.k == n) {
            this.k = var_short_arr_c[n];
        } else if (var_short_arr_b[n] != -1) {
            s = var_short_arr_b[n];
            e.var_short_arr_c[s] = var_short_arr_c[n];
        }
        e.var_short_arr_b[n] = -1;
        e.var_short_arr_c[n] = -1;
    }

    static {
        var_int_arr_a = new int[]{0, -1, 0, 1, -1, 0, 1, 0, -1, -1, 1, -1, -1, 1, 1, 1};
        var_int_a = 1000;
    }
}


/*
 * Decompiled with CFR 0.152.
 */
final class c {
    private static int var_int_a;
    private static boolean var_boolean_a;
    private static int[] var_int_arr_a;

    c() {
    }

    static boolean a(int[] nArray) {
        boolean bl;
        block2: {
            block3: {
                bl = false;
                if (f.var_int_F == 0) break block2;
                if ((f.var_int_F & nArray[var_int_a]) <= 0) break block3;
                if (++var_int_a < nArray.length) break block2;
                bl = true;
            }
            var_int_a = 0;
        }
        return bl;
    }

    static void a(d d2) {
        if (var_boolean_a) {
            int n = 0;
            if ((f.var_int_F & 8) > 0) {
                n = 5;
            }
            if ((f.var_int_F & 2) > 0) {
                n = -5;
            }
            if (n != 0) {
                int n2 = d2.var_int_arr_d[12];
                f.void_a(n2, f.int_l(n2) + n);
                f.var_int_q = 0;
                f.var_int_p = -1000;
                f.var_int_r = -1000;
                return;
            }
        } else if (c.a(var_int_arr_a)) {
            var_boolean_a = true;
            f.void_e(29);
            f.var_int_q = 0;
            f.var_int_p = -1000;
            f.var_int_r = -1000;
        }
    }

    static {
        var_int_a = 0;
        var_boolean_a = false;
        var_int_arr_a = new int[]{128, 2, 512, 8};
    }
}


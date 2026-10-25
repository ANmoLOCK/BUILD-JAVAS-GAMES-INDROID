/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.microedition.lcdui.Canvas
 *  javax.microedition.lcdui.Command
 *  javax.microedition.lcdui.CommandListener
 *  javax.microedition.lcdui.Displayable
 *  javax.microedition.lcdui.Font
 *  javax.microedition.lcdui.Graphics
 *  javax.microedition.lcdui.Image
 *  javax.microedition.midlet.MIDlet
 *  javax.microedition.rms.RecordStore
 */
import java.io.InputStream;
import java.util.Hashtable;
import javax.microedition.lcdui.Canvas;
import javax.microedition.lcdui.Command;
import javax.microedition.lcdui.CommandListener;
import javax.microedition.lcdui.Displayable;
import javax.microedition.lcdui.Font;
import javax.microedition.lcdui.Graphics;
import javax.microedition.lcdui.Image;
import javax.microedition.midlet.MIDlet;
import javax.microedition.rms.RecordStore;

public final class b
implements Runnable,
CommandListener {
    private static String var_java_lang_String_a;
    private static String var_java_lang_String_b;
    private static String var_java_lang_String_c;
    private static int var_int_a;
    private static String var_java_lang_String_d;
    private static Font var_javax_microedition_lcdui_Font_a;
    private static int var_int_b;
    private static int var_int_c;
    private static int var_int_d;
    private static int var_int_e;
    private static int var_int_f;
    private static int var_int_g;
    private static int var_int_h;
    private static boolean[] var_boolean_arr_a;
    private static int[] var_int_arr_a;
    private static int var_int_i;
    private static int var_int_j;
    private static int var_int_k;
    private static int var_int_l;
    private static int m;
    private static int n;
    private static int o;
    private static int p;
    private static int q;
    private static int r;
    private static int s;
    private static int t;
    private static int u;
    private static int v;
    private static int w;
    private static int x;
    private static int y;
    private static int z;
    private static int A;
    private static int B;
    private static int C;
    private static int D;
    private static int E;
    private static int F;
    private static int G;
    private static int H;
    private static int I;
    private static int[] var_int_arr_b;
    private static byte[][] var_byte_arr_arr_a;
    private static int J;
    private static byte[] var_byte_arr_a;
    private static int K;
    private static int L;
    private static int M;
    private static int N;
    private static int O;
    private static Image[] var_javax_microedition_lcdui_Image_arr_a;
    private static int P;
    private static int[] var_int_arr_c;
    private static int Q;
    private static int R;
    private static boolean var_boolean_a;
    private static final String[] var_java_lang_String_arr_a;
    private static String var_java_lang_String_e;
    private static boolean var_boolean_b;
    private static boolean var_boolean_c;
    private static String[] var_java_lang_String_arr_b;
    private static String[] var_java_lang_String_arr_c;
    private static String[] var_java_lang_String_arr_d;
    private static String[] var_java_lang_String_arr_e;
    private static int S;
    private static int T;
    private static String[] var_java_lang_String_arr_f;
    private static short[] var_short_arr_a;
    private static int U;
    private static boolean var_boolean_d;
    private static boolean var_boolean_e;
    private static MIDlet var_javax_microedition_midlet_MIDlet_a;
    private static Canvas var_javax_microedition_lcdui_Canvas_a;
    private static String var_java_lang_String_f;
    private static boolean var_boolean_f;
    private static CommandListener var_javax_microedition_lcdui_CommandListener_a;
    private static b var_b_a;
    private static boolean var_boolean_g;
    private static String var_java_lang_String_g;
    private static boolean var_boolean_h;
    private static int V;
    private static int W;
    private static int X;
    private static int Y;
    private static int Z;
    private static int aa;
    private static Image[] var_javax_microedition_lcdui_Image_arr_b;
    private static Image[] var_javax_microedition_lcdui_Image_arr_c;
    private static Image var_javax_microedition_lcdui_Image_a;
    private static Image var_javax_microedition_lcdui_Image_b;
    private static Image var_javax_microedition_lcdui_Image_c;
    private static Image var_javax_microedition_lcdui_Image_d;
    private static Image var_javax_microedition_lcdui_Image_e;
    private static Image var_javax_microedition_lcdui_Image_f;
    private static Image var_javax_microedition_lcdui_Image_g;
    private static Image var_javax_microedition_lcdui_Image_h;
    private static Image var_javax_microedition_lcdui_Image_i;
    private static Image var_javax_microedition_lcdui_Image_j;
    private static Image[] var_javax_microedition_lcdui_Image_arr_d;
    private static Image var_javax_microedition_lcdui_Image_k;
    private static Image[][] var_javax_microedition_lcdui_Image_arr_arr_a;
    private static String[][] var_java_lang_String_arr_arr_a;
    private static int[][] var_int_arr_arr_a;
    private static int[][] var_int_arr_arr_b;
    private static int[] var_int_arr_d;
    private static int ab;
    private static int ac;
    private static int ad;
    private static int ae;
    private static int af;
    private static int ag;
    private static int ah;
    private static int ai;
    private static int aj;
    private static int ak;
    private static int al;
    private static String[] var_java_lang_String_arr_g;
    private static int[] var_int_arr_e;
    private static boolean[] var_boolean_arr_b;
    private static int am;
    private static int an;
    private static boolean var_boolean_i;
    private static byte var_byte_a;
    private static byte var_byte_b;
    private static boolean var_boolean_j;
    private static int ao;
    private static int ap;
    private static int aq;
    private static int ar;
    private static int as;
    private static int at;
    private static String var_java_lang_String_h;
    private static String var_java_lang_String_i;
    private static String var_java_lang_String_j;
    private static int au;
    private static int av;
    private static int aw;
    private static int ax;
    private static Command var_javax_microedition_lcdui_Command_a;
    private static Command var_javax_microedition_lcdui_Command_b;
    private static int ay;
    private static boolean var_boolean_k;
    private static boolean var_boolean_l;
    private static int az;
    private static int aA;
    private static Hashtable var_java_util_Hashtable_a;
    private static int aB;

    private static boolean boolean_b() {
        b.void_a();
        try {
            InputStream inputStream = b.a("/dataIGP");
            I = inputStream.read() & 0xFF;
            var_int_arr_b = new int[I += (inputStream.read() & 0xFF) << 8];
            int n = 0;
            while (n < I) {
                b.var_int_arr_b[n] = inputStream.read() & 0xFF;
                int n2 = n;
                var_int_arr_b[n2] = var_int_arr_b[n2] + ((inputStream.read() & 0xFF) << 8);
                int n3 = n;
                var_int_arr_b[n3] = var_int_arr_b[n3] + ((inputStream.read() & 0xFF) << 16);
                int n4 = n++;
                var_int_arr_b[n4] = var_int_arr_b[n4] + ((inputStream.read() & 0xFF) << 24);
            }
            inputStream.close();
        }
        catch (Exception exception) {
            return false;
        }
        return true;
    }

    private static void void_a() {
        var_int_arr_b = null;
        var_byte_arr_arr_a = null;
        I = 0;
        System.gc();
    }

    private static byte[] byte_arr_a(int n) {
        if (n < 0 || n >= I - 1) {
            return null;
        }
        int n2 = var_int_arr_b[n + 1] - var_int_arr_b[n];
        if (n2 == 0) {
            return null;
        }
        byte[] byArray = null;
        try {
            InputStream inputStream = b.a("/dataIGP");
            inputStream.skip(2 + 4 * I + var_int_arr_b[n]);
            byArray = new byte[n2];
            for (n = byArray.length; n > 0; n -= inputStream.read(byArray)) {
            }
            inputStream.close();
        }
        catch (Exception exception) {}
        return byArray;
    }

    private static int int_a(byte[] byArray) {
        return (byArray[J++] & 0xFF) + ((byArray[J++] & 0xFF) << 8);
    }

    private static byte[] byte_arr_a(byte[] byArray) {
        int n = b.int_a(byArray);
        byte[] byArray2 = new byte[n];
        System.arraycopy(byArray, J, byArray2, 0, n);
        J += n;
        return byArray2;
    }

    private static Image javax_microedition_lcdui_Image_a(byte[] byArray) {
        byArray = b.byte_arr_a(byArray);
        return Image.createImage((byte[])byArray, (int)0, (int)byArray.length);
    }

    private static String java_lang_String_a(int n) {
        return "" + var_java_lang_String_arr_f[n];
    }

    private static int a(int n, int n2) {
        if (aB != 0) {
            if (n2 == 0 || n2 == M) {
                int n3 = var_byte_arr_a[n * 6 + n2] & 0xFF;
                n = var_byte_arr_a[n * 6 + n2 + 1] & 0xFF;
                n = 0 | (n & 0xFF) << 8;
                return n |= n3 & 0xFF;
            }
            int n4 = var_byte_arr_a[n * 6 + n2] & 0xFF;
            return n4;
        }
        return var_byte_arr_a[(n << 2) + n2] & 0xFF;
    }

    private static void a(int n, Graphics graphics, int n2, int n3, int n4) {
        b.a(b.java_lang_String_a(n), graphics, au, n2, n3, n4);
    }

    private static void a(String string, Graphics graphics, int n, int n2, int n3, int n4) {
        b.a(string, graphics, n2, n3, n4);
    }

    private static void a(String string, Graphics graphics, int n, int n2, int n3) {
        char c2;
        int n4;
        b.var_int_arr_c[0] = 0;
        R = 0;
        int n5 = 0;
        int n6 = string.length();
        int n7 = 0;
        if (au <= 176 && var_int_arr_e[X] == 4) {
            n7 += 2;
        }
        for (n4 = 0; n4 < n6; ++n4) {
            c2 = string.charAt(n4);
            if (c2 == '\n' && n5 < 10 || c2 == '\\' && string.charAt(++n4) == 'N') {
                int n8 = n5;
                var_int_arr_c[n8] = var_int_arr_c[n8] - var_int_h;
                if (var_int_arr_c[n5] > R) {
                    R = var_int_arr_c[n5];
                }
                b.var_int_arr_c[++n5] = 0;
                continue;
            }
            if (c2 == '\u0000' || c2 == '\u0001') continue;
            int n9 = n5;
            var_int_arr_c[n9] = var_int_arr_c[n9] + (b.a(c2, N) + var_int_h);
        }
        int n10 = n5;
        var_int_arr_c[n10] = var_int_arr_c[n10] - var_int_h;
        if (var_int_arr_c[n5] > R) {
            R = var_int_arr_c[n5];
        }
        Q = (n5 + 1) * K + n5 * (n7 + 0);
        if (!var_boolean_a) {
            n2 += (n7 + 0) * n5 / 2;
            n5 = 0;
            if ((n3 & 0x20) != 0) {
                n2 -= Q;
            } else if ((n3 & 2) != 0) {
                n2 -= Q >> 1;
            }
            int n11 = n;
            boolean bl = true;
            boolean bl2 = false;
            b.a(graphics, 0, 0, au, av);
            for (n4 = 0; n4 < n6; ++n4) {
                c2 = string.charAt(n4);
                if (bl) {
                    n11 = n;
                    if ((n3 & 8) != 0) {
                        n11 = n - var_int_arr_c[n5];
                    } else if ((n3 & 1) != 0) {
                        n11 = n - (var_int_arr_c[n5] >> 1);
                    }
                    bl = false;
                }
                if (c2 == '\n' && n5 < 10 || c2 == '\\' && string.charAt(++n4) == 'N') {
                    n2 += K + n7 - 2;
                    ++n5;
                    bl = true;
                    bl2 = true;
                    continue;
                }
                if (bl2) {
                    bl2 = false;
                    char c3 = string.charAt(n4 - 2);
                    if (c3 == ' ') {
                        n11 -= b.a(c3, N) + var_int_h >> 1;
                    }
                    if (c2 == ' ') {
                        n11 += b.a(c2, N) + var_int_h >> 1;
                        continue;
                    }
                }
                b.a(graphics, n11, n2, b.a(c2, N), b.a(c2, O));
                int n12 = n2;
                int n13 = n11;
                int n14 = b.a(c2, O);
                int n15 = b.a(c2, N);
                int n16 = b.a(c2, M);
                int n17 = b.a(c2, 0);
                Image image = var_javax_microedition_lcdui_Image_arr_a[P];
                Graphics graphics2 = graphics;
                graphics2.drawRegion(image, n17, n16, n15, n14, 0, n13, n12, 20);
                n11 += b.a(c2, N) + var_int_h;
            }
            b.a(graphics, 0, 0, au, av);
            P = 1;
            return;
        }
        var_boolean_a = false;
    }

    public static void a(MIDlet object, Canvas canvas, int n, int n2) {
        MIDlet mIDlet = object;
        object = null;
        object = mIDlet;
        String cfr_ignored_0 = "initialize(midlet = " + object + ", game = " + canvas + ", screenWidth = " + n + ", screenHeight = " + n2 + ", cmdListener = " + null + ")";
        au = n;
        av = n2;
        aw = au >> 1;
        ax = av >> 1;
        var_int_e = av * 5 / 100;
        var_int_f = av / 2;
        var_int_g = av * 93 / 100;
        if (2 > au) {
            var_int_c = 2;
        }
        if (2 > au) {
            var_int_d = 2;
        }
        if (var_javax_microedition_midlet_MIDlet_a == null && canvas != null) {
            var_javax_microedition_midlet_MIDlet_a = object;
            var_javax_microedition_lcdui_Canvas_a = canvas;
            b.void_b();
            object = var_java_lang_String_b;
            String cfr_ignored_1 = (String)object + "";
        }
    }

    private static boolean boolean_a(String string, int n) {
        if (string == null) {
            return (n & 1) == 0;
        }
        string = string.trim();
        return !((n & 1) != 0 && string.length() == 0 || (n & 2) != 0 && string.toUpperCase().compareTo("DEL") == 0 || (n & 4) != 0 && (string.toUpperCase().compareTo("NO") == 0 || string.toUpperCase().compareTo("0") == 0));
    }

    private static String a(String string, String string2, String string3) {
        String string4 = "";
        try {
            if (string3 != null && string != null && string2 != null) {
                int n = string.indexOf(string2 + "=");
                string3 = string3.trim();
                if (n >= 0 && string3.length() > 0) {
                    int n2 = string.indexOf(";", n += string2.length() + 1);
                    if (n2 < 0) {
                        n2 = string.length();
                    }
                    string4 = string.substring(n, n2);
                    if ((string4 = string4.trim()).length() == 0 || string4.compareTo("0") == 0 || string4.toUpperCase().compareTo("NO") == 0) {
                        string4 = "";
                    } else if (string4.toUpperCase().compareTo("DEL") != 0 && string2.compareTo("OP") != 0) {
                        int n3 = string3.indexOf("XXXX");
                        string4 = n3 >= 0 ? string3.substring(0, n3) + string4 + string3.substring(n3 + "XXXX".length()) : string3;
                    }
                }
            }
        }
        catch (Exception exception) {
            string4 = "";
        }
        return string4;
    }

    private static void a(int n, String string, int n2, String string2, String string3) {
        try {
            if (var_boolean_c) {
                String string4 = string2;
                string = b.a(var_javax_microedition_midlet_MIDlet_a.getAppProperty(string4), string, string3);
            } else {
                String string5 = "URL-" + string;
                string = var_javax_microedition_midlet_MIDlet_a.getAppProperty(string5);
            }
            boolean bl = b.boolean_a(string, 7);
            if (bl && (string.toUpperCase().compareTo("NO") != 0 || string.toUpperCase().compareTo("0") != 0)) {
                b.var_boolean_arr_b[n] = true;
                b.var_java_lang_String_arr_g[n] = string;
                if (var_boolean_arr_b[n] && n != var_int_l) {
                    ++am;
                    b.var_int_arr_e[n] = 4;
                    if (var_boolean_b) {
                        int n3 = n;
                        var_java_lang_String_arr_g[n3] = var_java_lang_String_arr_g[n3] + "&ctg=SC" + (am < 10 ? "0" : "") + am;
                    }
                }
            }
            return;
        }
        catch (Exception exception) {
            return;
        }
    }

    private static void a(int n, String[] stringArray, int n2, String string) {
        String string2;
        int n3 = stringArray.length;
        b.var_java_lang_String_arr_arr_a[n] = new String[n3];
        b.var_int_arr_arr_a[n] = new int[n3];
        b.var_int_arr_arr_b[n] = new int[n3];
        int n4 = 0;
        if (var_boolean_arr_a[0]) {
            return;
        }
        String string3 = "";
        if (var_boolean_c) {
            try {
                string2 = string;
                string = var_javax_microedition_midlet_MIDlet_a.getAppProperty(string2);
                if (n != 2) {
                    string3 = var_java_lang_String_e;
                } else if (var_java_lang_String_j.length() > 0 && var_boolean_b) {
                    string3 = var_java_lang_String_j + "&ctg=XXXX";
                } else if (var_java_lang_String_j.length() > 0) {
                    string3 = var_java_lang_String_j;
                }
            }
            catch (Exception exception) {}
        }
        for (int i = 0; i < stringArray.length; ++i) {
            try {
                int n5;
                string2 = "";
                if (n != 2 && i == n3 - 1) {
                    if (!var_boolean_c) {
                        string2 = var_java_lang_String_arr_a[n];
                        string2 = var_javax_microedition_midlet_MIDlet_a.getAppProperty(string2);
                    } else if (var_java_lang_String_j.length() > 0) {
                        string2 = "IGP-CATEGORIES";
                        string2 = b.a(var_javax_microedition_midlet_MIDlet_a.getAppProperty(string2), stringArray[i], var_java_lang_String_j + (var_boolean_b ? "&ctg=XXXX" : ""));
                    }
                } else if (var_boolean_c) {
                    string2 = stringArray[i].compareTo("GLDT") == 0 ? b.a(string, stringArray[i], var_java_lang_String_e) : (stringArray[i].compareTo("CATALOG") == 0 ? var_java_lang_String_j : b.a(string, stringArray[i], string3));
                } else {
                    string2 = var_java_lang_String_arr_a[n] + "-" + stringArray[i];
                    string2 = var_javax_microedition_midlet_MIDlet_a.getAppProperty(string2);
                }
                if (!b.boolean_a(string2, 7)) continue;
                b.var_java_lang_String_arr_arr_a[n][n4] = string2;
                b.var_int_arr_arr_a[n][n4++] = i;
                b.var_int_arr_arr_b[n][i] = n5 = n2 - (stringArray.length - 1) + i;
                continue;
            }
            catch (Exception exception) {}
        }
        if (n4 > 0) {
            b.var_boolean_arr_b[b.m + n] = true;
            b.var_int_arr_d[n] = n4;
        }
    }

    private static String[] java_lang_String_arr_a(byte[] byArray) {
        String[] stringArray = new String[b.int_a(byArray)];
        for (int i = 0; i < stringArray.length; ++i) {
            int n = b.int_a(byArray);
            stringArray[i] = new String(byArray, J, n);
            J += n;
        }
        return stringArray;
    }

    private static void void_b() {
        String[] stringArray;
        Object[] objectArray;
        try {
            int n;
            boolean bl = b.boolean_b();
            if (!bl) {
                var_boolean_h = false;
                return;
            }
            objectArray = b.byte_arr_a(0);
            b.int_a(objectArray);
            int n2 = b.int_a(objectArray);
            new String((byte[])objectArray, J, n2);
            J += n2;
            var_java_lang_String_arr_b = b.java_lang_String_arr_a(objectArray);
            stringArray = b.java_lang_String_arr_a(objectArray);
            var_java_lang_String_arr_c = b.java_lang_String_arr_a(objectArray);
            var_java_lang_String_arr_d = b.java_lang_String_arr_a(objectArray);
            var_java_lang_String_arr_e = b.java_lang_String_arr_a(objectArray);
            for (n = 0; n < var_boolean_arr_a.length; ++n) {
                b.var_boolean_arr_a[n] = b.int_a(objectArray) == 1;
            }
            try {
                n = b.int_a(objectArray);
                var_java_lang_String_c = new String((byte[])objectArray, J, n);
                if (var_java_lang_String_c.equals("2.0z")) {
                    aB = 2;
                    M = 2;
                    N = 4;
                    O = 5;
                }
                if (!var_java_lang_String_c.startsWith(var_java_lang_String_a)) {
                    String cfr_ignored_0 = "Invalid dataIGP file, dataIGP file IGP Version : " + var_java_lang_String_c;
                    String cfr_ignored_1 = "IGP Class version : " + var_java_lang_String_a;
                }
            }
            catch (Exception exception) {
                var_boolean_h = false;
            }
            b.void_a();
        }
        catch (Exception exception) {
            var_boolean_h = false;
            return;
        }
        objectArray = stringArray;
        int n = (stringArray.length - 1 > 0 ? objectArray.length - 1 : 0) + 4;
        q = ++n;
        r = q + 1;
        s = r + 1;
        t = s + 1;
        u = t + 1;
        v = u + 1;
        w = v + 1;
        x = w + 1;
        y = x + 1;
        z = y + 1;
        A = z + 1;
        B = A + 1;
        n = C = B + 1;
        if (var_java_lang_String_arr_c.length > 1) {
            D = n + 1;
            E = D + (var_java_lang_String_arr_c.length - 1);
        } else {
            E = n + 1;
        }
        n = E;
        if (var_java_lang_String_arr_d.length > 1) {
            F = n + 1;
            G = F + (var_java_lang_String_arr_d.length - 1);
        } else {
            G = n + 1;
        }
        S = stringArray.length;
        var_javax_microedition_lcdui_Image_arr_d = new Image[S];
        T = S + 1 + 1 + 1 + 1 + (var_boolean_arr_a[0] ? 1 : 0);
        for (n = 0; n < var_boolean_arr_a.length; ++n) {
            b.var_int_arr_a[n] = var_boolean_arr_a[n] ? ++var_int_k : --var_int_j;
        }
        var_int_i = ++var_int_k;
        var_java_lang_String_arr_g = new String[T];
        var_boolean_arr_b = new boolean[T];
        var_int_arr_e = new int[T];
        for (n = 0; n < var_boolean_arr_b.length; ++n) {
            b.var_boolean_arr_b[n] = false;
        }
        var_int_l = S;
        m = var_int_l + 1;
        b.n = m + 1;
        o = b.n + 1;
        p = o + 1;
        var_java_lang_String_arr_arr_a = new String[3][];
        var_int_arr_arr_a = new int[3][];
        var_int_arr_arr_b = new int[3][];
        var_int_arr_d = new int[3];
        try {
            String string = "URL-TEMPLATE-GAME";
            var_java_lang_String_e = var_javax_microedition_midlet_MIDlet_a.getAppProperty(string).trim();
            var_boolean_c = true;
            if (var_java_lang_String_e.indexOf("ingameads.gameloft.com/redir") != -1) {
                var_boolean_b = true;
            }
        }
        catch (Exception exception) {}
        for (n = 0; n < S; ++n) {
            b.a(n, stringArray[n], 7, "IGP-PROMOS", var_java_lang_String_e);
        }
        try {
            String string = "URL-OPERATOR";
            String string2 = var_javax_microedition_midlet_MIDlet_a.getAppProperty(string);
            if (b.boolean_a(string2, 7)) {
                var_java_lang_String_j = string2;
            }
            string = "URL-PT";
            var_java_lang_String_h = var_javax_microedition_midlet_MIDlet_a.getAppProperty(string);
        }
        catch (Exception exception) {}
        if (!var_boolean_arr_a[0]) {
            if (var_boolean_c) {
                if (b.boolean_a(var_java_lang_String_j, 7)) {
                    b.a(S, "PROMO", 7, "IGP-CATEGORIES", var_java_lang_String_j + (var_boolean_b ? "&ctg=XXXX" : ""));
                }
            } else {
                String string = "URL-PROMO";
                String string3 = var_javax_microedition_midlet_MIDlet_a.getAppProperty(string);
                if (string3 != null) {
                    string3.trim();
                    string = "URL-PROMO";
                    if (b.boolean_a(var_javax_microedition_midlet_MIDlet_a.getAppProperty(string), 7)) {
                        b.var_java_lang_String_arr_g[b.var_int_l] = string3;
                        b.var_boolean_arr_b[b.var_int_l] = true;
                        b.var_int_arr_e[b.var_int_l] = 5;
                    }
                }
            }
        }
        b.a(0, var_java_lang_String_arr_c, E, "IGP-WN");
        b.a(1, var_java_lang_String_arr_d, G, "IGP-BS");
        if (!var_boolean_arr_a[0]) {
            if (var_boolean_c) {
                String string = "IGP-CATEGORIES";
                if (b.boolean_a(b.a(var_javax_microedition_midlet_MIDlet_a.getAppProperty(string), "OP", var_java_lang_String_j), 7)) {
                    if (b.boolean_a(var_java_lang_String_j, 7)) {
                        b.var_boolean_arr_b[b.o] = true;
                    }
                    b.var_java_lang_String_arr_g[b.o] = var_java_lang_String_j;
                }
            } else if (b.boolean_a(var_java_lang_String_j, 7)) {
                b.var_java_lang_String_arr_g[b.o] = var_java_lang_String_j;
                b.var_boolean_arr_b[b.o] = true;
            }
            if (var_boolean_arr_b[o] && var_boolean_b) {
                int n3 = o;
                var_java_lang_String_arr_g[n3] = var_java_lang_String_arr_g[n3] + "&ctg=CCTL";
            }
        }
        if (var_boolean_arr_a[0]) {
            try {
                if (b.boolean_a(var_java_lang_String_j, 7)) {
                    b.var_java_lang_String_arr_g[b.p] = var_java_lang_String_j;
                    b.var_boolean_arr_b[b.p] = true;
                }
            }
            catch (Exception exception) {}
        }
        if ((al = b.int_b()) > 0) {
            var_boolean_h = true;
        }
        String cfr_ignored_2 = "isAvailable = " + var_boolean_h;
    }

    public static boolean boolean_a() {
        return (var_boolean_h && b.int_b() > 0 ? 0 : -1) != -1;
    }

    public static void void_a(String string, int n) {
        String cfr_ignored_0 = "enterIGP(loadingMsg = " + string + ", appLanguage = " + 0 + " (" + var_java_lang_String_arr_b[0] + ")";
        n = 0;
        if (n >= 0 && n < var_java_lang_String_arr_b.length) {
            at = n <= var_java_lang_String_arr_b.length ? n : 0;
            var_java_lang_String_i = string;
            Z = -1;
            V = 0;
            Y = -1;
            X = 0;
            ae = 0;
            af = 0;
            var_int_arr_c = new int[10];
            var_boolean_g = true;
            var_javax_microedition_lcdui_Font_a = Font.getFont((int)0, (int)0, (int)8);
            var_byte_a = 0;
            var_byte_b = 0;
            new Thread(new b()).start();
        }
        aa = 4 + T;
        string = null;
        try {
            string = RecordStore.openRecordStore((String)"igp19", (boolean)false);
        }
        catch (Exception exception) {
            try {
                string = RecordStore.openRecordStore((String)"igp19", (boolean)true);
            }
            catch (Exception exception2) {}
        }
        try {
            if (string != null) {
                string.closeRecordStore();
            }
        }
        catch (Exception exception) {}
        X = b.int_c();
        if (var_boolean_f) {
            var_javax_microedition_lcdui_Canvas_a.setCommandListener((CommandListener)var_b_a);
        }
    }

    private static int int_b() {
        int n = 0;
        for (int i = 0; i < var_boolean_arr_b.length; ++i) {
            if (!var_boolean_arr_b[i]) continue;
            ++n;
        }
        return n;
    }

    private static int int_c() {
        for (int i = 0; i < var_boolean_arr_b.length; ++i) {
            if (!var_boolean_arr_b[i]) continue;
            return i;
        }
        return -1;
    }

    private static void void_c() {
        if (var_java_lang_String_h == null) {
            return;
        }
        int n = var_java_lang_String_h.length();
        if (n <= 0) {
            var_java_lang_String_h = null;
            return;
        }
        boolean bl = false;
        int n2 = 0;
        int n3 = 0;
        int n4 = 0;
        int n5 = 1;
        String string = "";
        var_java_lang_String_h = var_java_lang_String_h.toUpperCase();
        for (int i = 0; i < n; ++i) {
            char c2 = var_java_lang_String_h.charAt(i);
            if (c2 >= ' ' && c2 <= 'z' || c2 == '\u0082' || c2 == '\n') {
                if (c2 == '\n') {
                    bl = true;
                } else if (i < n - 1 && c2 == '\\' && (var_java_lang_String_h.charAt(i + 1) == 'n' || var_java_lang_String_h.charAt(i + 1) == 'N')) {
                    bl = true;
                    ++i;
                }
                if (bl) {
                    if (string.length() > 0) {
                        if (++n5 == 3) {
                            string = null;
                            break;
                        }
                        string = string + '\n';
                        n3 = 0;
                    } else {
                        string = string + "";
                    }
                    bl = false;
                } else {
                    string = string + c2;
                    n3 += b.a(c2, N);
                    if (c2 == ' ') {
                        n2 = string.length() - 1;
                        n4 = n3;
                    }
                }
                if (n3 < au) continue;
                if (n5 < 3) {
                    if (n2 == i) {
                        string = string + "\n";
                        n3 = 0;
                    } else if (n2 != 0) {
                        string = string.substring(0, n2) + "\n" + string.substring(n2 + 1, string.length());
                        n3 -= n4;
                    } else {
                        string = null;
                        break;
                    }
                    ++n5;
                    continue;
                }
                string = null;
                break;
            }
            string = null;
            break;
        }
        if (string != null && !b.boolean_a(string, 7)) {
            string = null;
        }
        var_java_lang_String_h = string;
    }

    private static void void_a(int n) {
        byte[] byArray = null;
        J = 0;
        switch (n) {
            case -1: {
                var_javax_microedition_lcdui_Image_arr_b = new Image[H];
                var_javax_microedition_lcdui_Image_arr_c = new Image[T];
                Image[][] imageArrayArray = new Image[3][];
                var_javax_microedition_lcdui_Image_arr_arr_a = imageArrayArray;
                imageArrayArray[0] = new Image[var_java_lang_String_arr_c.length];
                b.var_javax_microedition_lcdui_Image_arr_arr_a[1] = new Image[var_java_lang_String_arr_d.length];
                b.var_javax_microedition_lcdui_Image_arr_arr_a[2] = new Image[var_java_lang_String_arr_e.length];
                return;
            }
            case 0: {
                b.boolean_b();
                return;
            }
            case 1: {
                int n2;
                byArray = b.byte_arr_a(n);
                for (int i = 0; i < at; ++i) {
                    n = b.int_a(byArray);
                    J += n;
                }
                b.int_a(byArray);
                n = b.int_a(byArray);
                var_java_lang_String_arr_f = new String[n];
                byte[] byArray2 = new byte[n];
                System.arraycopy(byArray, J, byArray2, 0, n);
                J += n;
                b.int_a(byArray);
                int n3 = byArray[J++] & 0xFF | (byArray[J++] & 0xFF) << 8;
                var_short_arr_a = new short[n3];
                for (n2 = 0; n2 < n3 - 1; ++n2) {
                    b.var_short_arr_a[n2] = (short)((byArray[J++] & 0xFF) + ((byArray[J++] & 0xFF) << 8));
                }
                b.var_short_arr_a[n3 - 1] = (short)n;
                for (n2 = 0; n2 < n3; ++n2) {
                    n = n2 == 0 ? 0 : var_short_arr_a[n2 - 1] & 0xFFFF;
                    int n4 = (var_short_arr_a[n2] & 0xFFFF) - n;
                    if (n4 == 0) continue;
                    try {
                        b.var_java_lang_String_arr_f[n2] = new String(byArray2, n, n4, "UTF-8");
                        continue;
                    }
                    catch (Exception exception) {}
                }
                if (!var_boolean_f) break;
                var_javax_microedition_lcdui_Command_a = new Command(b.java_lang_String_a(w), 4, 1);
                var_javax_microedition_lcdui_Command_b = new Command(b.java_lang_String_a(x), 2, 1);
                n = 1;
                n = 1;
                if (var_javax_microedition_lcdui_Command_b != null) {
                    var_javax_microedition_lcdui_Canvas_a.removeCommand(var_javax_microedition_lcdui_Command_b);
                }
                if (var_javax_microedition_lcdui_Command_a != null) {
                    var_javax_microedition_lcdui_Canvas_a.removeCommand(var_javax_microedition_lcdui_Command_a);
                }
                var_javax_microedition_lcdui_Canvas_a.addCommand(var_javax_microedition_lcdui_Command_a);
                var_javax_microedition_lcdui_Canvas_a.addCommand(var_javax_microedition_lcdui_Command_b);
                return;
            }
            case 2: {
                var_javax_microedition_lcdui_Image_arr_a = new Image[3];
                byArray = b.byte_arr_a(n);
                byte[] byArray3 = new byte[byArray.length];
                System.arraycopy(byArray, 0, byArray3, 0, byArray.length);
                n = b.int_a(byArray);
                J = 0;
                b.var_javax_microedition_lcdui_Image_arr_a[0] = b.javax_microedition_lcdui_Image_a(byArray);
                b.var_javax_microedition_lcdui_Image_arr_a[1] = b.a(byArray3, 2, n, 1, 46319);
                b.var_javax_microedition_lcdui_Image_arr_a[2] = b.a(byArray3, 2, n, 1, 0xFF0000);
                int n5 = b.int_a(byArray);
                n = b.int_a(byArray);
                var_byte_arr_a = new byte[(n + 1) * (4 + aB)];
                n = n5 / (6 + aB);
                for (int i = 0; i < n; ++i) {
                    int n6 = b.int_a(byArray);
                    System.arraycopy(byArray, J, var_byte_arr_a, n6 *= 4 + aB, 4 + aB);
                    J += 4 + aB;
                }
                K = var_byte_arr_a[32 * (4 + aB) + O];
                var_int_h = K == 13 ? 0 : -1;
                b.void_c();
                return;
            }
            case 3: {
                byArray = b.byte_arr_a(n);
                for (int i = 0; i < H; ++i) {
                    if (i == 13 || i == 12) continue;
                    b.var_javax_microedition_lcdui_Image_arr_b[i] = b.javax_microedition_lcdui_Image_a(byArray);
                }
                return;
            }
            case 4: {
                for (int i = 0; i < S; ++i) {
                    b.var_javax_microedition_lcdui_Image_arr_c[i] = b.javax_microedition_lcdui_Image_a(b.byte_arr_a(n));
                }
                break;
            }
            case 5: {
                byArray = b.byte_arr_a(n);
                byte[] byArray4 = b.byte_arr_a(byArray);
                int n7 = byArray4.length;
                int n8 = 0;
                byte[] byArray5 = byArray4;
                b.var_javax_microedition_lcdui_Image_arr_c[b.var_int_l] = Image.createImage((byte[])byArray4, (int)n8, (int)n7);
                for (n8 = 0; n8 < at; ++n8) {
                    b.javax_microedition_lcdui_Image_a(byArray);
                }
                var_javax_microedition_lcdui_Image_a = b.javax_microedition_lcdui_Image_a(byArray);
                return;
            }
            case 6: 
            case 7: {
                int n9 = (n == 6 ? var_java_lang_String_arr_c.length : var_java_lang_String_arr_d.length) - 1;
                int n10 = n == 6 ? 0 : 1;
                byArray = b.byte_arr_a(n);
                for (int i = 0; i < n9; ++i) {
                    b.var_javax_microedition_lcdui_Image_arr_arr_a[n10][i] = b.javax_microedition_lcdui_Image_a(byArray);
                }
                b.var_javax_microedition_lcdui_Image_arr_arr_a[n10][i] = var_javax_microedition_lcdui_Image_arr_b[11];
                b.var_javax_microedition_lcdui_Image_arr_c[n == 6 ? b.m : b.n] = var_javax_microedition_lcdui_Image_arr_b[10];
                return;
            }
            case 8: {
                byArray = b.byte_arr_a(n);
                b.var_javax_microedition_lcdui_Image_arr_c[b.o] = b.javax_microedition_lcdui_Image_a(byArray);
                if (!var_java_lang_String_arr_b[at].equals("JP") && !var_java_lang_String_arr_b[at].equals("DOCOMO") || var_javax_microedition_lcdui_Image_b != null) break;
                var_javax_microedition_lcdui_Image_b = b.javax_microedition_lcdui_Image_a(byArray);
                return;
            }
            default: {
                if (n == var_int_arr_a[0]) {
                    byArray = b.byte_arr_a(n);
                    b.var_javax_microedition_lcdui_Image_arr_c[b.p] = b.javax_microedition_lcdui_Image_a(byArray);
                    return;
                }
                if (n != var_int_i) break;
                b.void_a();
            }
        }
    }

    private static void b(boolean bl) {
        int n;
        for (n = 0; n < var_javax_microedition_lcdui_Image_arr_arr_a.length; ++n) {
            if (var_javax_microedition_lcdui_Image_arr_arr_a[n] == null) continue;
            for (int i = 0; i < var_javax_microedition_lcdui_Image_arr_arr_a[n].length; ++i) {
                b.var_javax_microedition_lcdui_Image_arr_arr_a[n][i] = null;
            }
        }
        for (n = 0; n < var_javax_microedition_lcdui_Image_arr_c.length; ++n) {
            b.var_javax_microedition_lcdui_Image_arr_c[n] = null;
        }
        var_javax_microedition_lcdui_Image_a = null;
        if (bl) {
            b.void_a();
            var_byte_arr_a = null;
            var_javax_microedition_lcdui_Image_arr_a = null;
            for (n = 0; n < H; ++n) {
                b.var_javax_microedition_lcdui_Image_arr_b[n] = null;
            }
            var_javax_microedition_lcdui_Image_arr_b = null;
            var_short_arr_a = null;
            var_java_lang_String_arr_f = null;
            var_int_arr_c = null;
            var_java_lang_String_i = null;
            var_javax_microedition_lcdui_Image_arr_c = null;
            var_javax_microedition_lcdui_Image_arr_arr_a = null;
            var_javax_microedition_lcdui_Image_c = null;
            var_javax_microedition_lcdui_Image_d = null;
            var_javax_microedition_lcdui_Image_e = null;
            var_javax_microedition_lcdui_Image_f = null;
            var_javax_microedition_lcdui_Image_g = null;
            var_javax_microedition_lcdui_Image_h = null;
            var_javax_microedition_lcdui_Image_i = null;
            var_javax_microedition_lcdui_Image_j = null;
            var_javax_microedition_lcdui_Image_k = null;
            for (n = 0; n < var_javax_microedition_lcdui_Image_arr_d.length; ++n) {
                b.var_javax_microedition_lcdui_Image_arr_d[n] = null;
            }
        }
        System.gc();
    }

    public static void a(boolean bl) {
        if (bl) {
            if (V == 0 || V == 2) {
                Y = V;
                V = 5;
                return;
            }
        } else if (V == 5) {
            V = Y;
            Z = -1;
        }
    }

    public static int int_a() {
        return V;
    }

    public static boolean boolean_a(int n) {
        if (!var_boolean_h) {
            return true;
        }
        W = n;
        switch (V) {
            case 0: {
                if (Z >= aa) {
                    V = 1;
                    b.d();
                } else {
                    b.void_a(Z);
                }
                ++Z;
                break;
            }
            case 1: {
                switch (W) {
                    case 26: {
                        V = 4;
                        break;
                    }
                    case 23: {
                        if (al <= 1) break;
                        X = X == 0 ? T - 1 : --X;
                        while (!var_boolean_arr_b[X]) {
                            if (X == 0) {
                                X = T - 1;
                                continue;
                            }
                            --X;
                        }
                        var_boolean_d = true;
                    }
                    case 24: {
                        if (al <= 1) break;
                        if (!var_boolean_d) {
                            X = X == T - 1 ? 0 : ++X;
                            while (!var_boolean_arr_b[X]) {
                                if (X == T - 1) {
                                    X = 0;
                                    continue;
                                }
                                ++X;
                            }
                            var_boolean_e = true;
                        }
                        ae = 0;
                        af = 0;
                        b.d();
                        break;
                    }
                    case 32: {
                        if (!var_boolean_j || af >= ac - 1 || ++af - ae < ad) break;
                        ++ae;
                        break;
                    }
                    case 21: {
                        if (!var_boolean_j || af <= 0 || --af - ae >= 0) break;
                        --ae;
                        break;
                    }
                    case 25: 
                    case 27: {
                        V = 6;
                    }
                }
                break;
            }
            case 6: {
                String string = var_java_lang_String_arr_g[X];
                if (var_boolean_j) {
                    string = var_java_lang_String_arr_arr_a[ab][af];
                }
                if (string == null || string.length() <= 0) break;
                if (var_boolean_b) {
                    int n2 = string.indexOf("&lg=");
                    string = n2 == -1 ? string + "&lg=" + var_java_lang_String_arr_b[at] : string.substring(0, n2) + "&lg=" + var_java_lang_String_arr_b[at] + string.substring(n2 + "&lg=".length() + 2);
                }
                var_java_lang_String_g = string;
                break;
            }
            case 2: {
                b.b(false);
                n = X;
                Z = var_int_arr_e[n] == 4 ? var_int_arr_e[n] : (n == var_int_l ? 5 : (n == m ? 6 : (n == b.n ? 7 : (n == o ? 8 : (n == p ? var_int_arr_a[0] : -1)))));
                b.void_a(Z);
                V = 1;
                break;
            }
            case 5: {
                break;
            }
            case 3: {
                switch (W) {
                    case 26: {
                        V = 1;
                        var_java_lang_String_f = null;
                        break;
                    }
                    case 25: 
                    case 27: {
                        var_java_lang_String_g = null;
                    }
                }
                break;
            }
            case 4: {
                b.b(true);
                if (var_boolean_f) {
                    var_javax_microedition_lcdui_Canvas_a.setCommandListener(var_javax_microedition_lcdui_CommandListener_a);
                    if (var_javax_microedition_lcdui_Command_b != null) {
                        var_javax_microedition_lcdui_Canvas_a.removeCommand(var_javax_microedition_lcdui_Command_b);
                        var_javax_microedition_lcdui_Command_b = null;
                    }
                    if (var_javax_microedition_lcdui_Command_a != null) {
                        var_javax_microedition_lcdui_Canvas_a.removeCommand(var_javax_microedition_lcdui_Command_a);
                        var_javax_microedition_lcdui_Command_a = null;
                    }
                }
                var_boolean_g = false;
                return true;
            }
        }
        return false;
    }

    private static void d() {
        an = X;
        af = 0;
        ac = 0;
        ae = 0;
        var_boolean_j = false;
        boolean bl = var_boolean_i = var_java_lang_String_arr_g[X] != null && var_java_lang_String_arr_g[X].length() > 0 && var_java_lang_String_arr_g[X].compareTo("DEL") != 0;
        if (X == m) {
            ab = 0;
            var_boolean_j = true;
            var_boolean_i = false;
        }
        if (X == n) {
            ab = 1;
            var_boolean_j = true;
            var_boolean_i = false;
        }
        if (X == o || X == p) {
            var_boolean_i = true;
        }
        ao = s;
        if (var_int_arr_e[X] == 4) {
            ao = t;
        }
        if (var_boolean_j) {
            ac = var_int_arr_d[ab];
        }
    }

    public static void a(Graphics graphics) {
        if (!var_boolean_h) {
            return;
        }
        Graphics graphics2 = graphics;
        b.a(graphics, 0, 0, au, av);
        b.a(graphics2, 0, 0, au, av);
        switch (V) {
            case 0: {
                graphics.setColor(0);
                graphics.fillRect(0, 0, au, av);
                int n = aa;
                int n2 = Z;
                int n3 = au * 3 / 4;
                int n4 = ax;
                Graphics graphics3 = graphics;
                if (n2 > n) {
                    n2 = n;
                }
                int n5 = (au - n3) / 2;
                graphics3.setColor(0xFFFFFF);
                graphics3.drawRect(n5, n4, n3, 6);
                int n6 = (n3 - 2 - 2) * n2 / n + 1;
                graphics3.setColor(0xFF0000);
                graphics3.fillRect(n5 + 1 + 1, n4 + 1 + 1, n6, 3);
                if (var_java_lang_String_i == null || var_java_lang_String_i.trim().equals("")) break;
                graphics.setColor(0xFFFFFF);
                graphics.setFont(var_javax_microedition_lcdui_Font_a);
                graphics.drawString(var_java_lang_String_i, aw, ax - 5, 33);
                return;
            }
            case 1: {
                b.b(graphics2);
                if (System.currentTimeMillis() % 1000L <= 500L) break;
                Graphics graphics4 = graphics;
                if (var_boolean_i) {
                    graphics4.setColor(var_int_b);
                    if (var_boolean_arr_a[0]) {
                        graphics4.setColor(0xFF7F00);
                    }
                    P = 0;
                    graphics4.fillRect(ar, as, ap, aq + 1);
                    b.a(ao, graphics4, aw, as + (aq >> 1), 3);
                }
                return;
            }
            case 2: {
                graphics.setFont(var_javax_microedition_lcdui_Font_a);
                int n = var_javax_microedition_lcdui_Font_a.getHeight();
                graphics.setColor(255);
                graphics.fillRect(0, ax - n - 5, au, n << 1);
                graphics.setColor(0xFFFFFF);
                graphics.drawString(var_java_lang_String_i, aw, ax, 65);
                return;
            }
            case 5: {
                return;
            }
            case 3: {
                b.b(graphics2);
                int n = av * 40 / 100;
                int n7 = au;
                int n8 = -220209185;
                int n9 = av - (n << 1);
                int n10 = n7;
                int n11 = n;
                int n12 = 0;
                Graphics graphics5 = graphics;
                int[] nArray = new int[n10 * n9];
                for (n12 = 0; n12 < nArray.length; ++n12) {
                    nArray[n12] = n8;
                }
                graphics5.drawRGB(nArray, 0, n10, 0, n11, n10, n9, true);
                graphics.setColor(39423);
                graphics.drawRect(0, n, n7 - 1, av - (n << 1) - 1);
                graphics.drawRect(1, n + 1, n7 - 3, av - (n << 1) - 3);
                b.a(C, graphics, aw, ax, 3);
                b.c(graphics);
            }
        }
    }

    private static void b(Graphics graphics) {
        int n;
        int n2;
        int n3;
        int n4;
        int n5;
        var_boolean_a = true;
        b.a(ao, null, 0, 0, 3);
        int n6 = b.a(32, N) / 2;
        int n7 = b.a(32, O) / 3;
        ap = R + n6;
        aq = Q + n7;
        if ((Q + aq) % 2 != 0) {
            ++aq;
        }
        ar = aw - ap / 2;
        if (var_int_arr_e[X] == 4 || X == p) {
            as = var_int_f - aq / 2;
        } else if (X == var_int_l || X == o) {
            as = var_int_g - aq / 2;
        }
        if (var_boolean_arr_a[0] && X == p) {
            as = av * 80 / 100;
        }
        graphics.setColor(0xFFFFFF);
        if (var_boolean_arr_a[0]) {
            graphics.setColor(0);
        }
        graphics.fillRect(0, 0, au, av);
        if (var_boolean_j) {
            Graphics graphics2 = graphics;
            n7 = var_int_e;
            if (av > 128) {
                b.a(graphics2, var_javax_microedition_lcdui_Image_arr_c[X], aw, var_int_e, 17);
                n7 += var_javax_microedition_lcdui_Image_arr_c[X].getHeight();
            }
            n5 = n7;
            P = 2;
            b.a(an, graphics2, aw, n5, 17);
            n4 = Math.max(2 * K, var_javax_microedition_lcdui_Image_arr_arr_a[ab][var_int_arr_arr_a[ab][0]].getHeight());
            var_boolean_a = true;
            b.a(an, null, 0, 0, 0);
            n3 = n5 + Q;
            n5 = n7 = av * 7 / 100;
            n2 = av / 2 - n3 << 1;
            n = av - var_javax_microedition_lcdui_Image_arr_b[8].getHeight() - 2 - n3;
            ad = ac;
            if (n2 / n4 >= ac) {
                n3 = n3 + n2 / 2 - ad * n4 / 2;
            } else {
                if (n / n4 < ac) {
                    ad = (n - n5 * 2) / n4;
                }
                n3 = n3 + n / 2 - ad * n4 / 2;
            }
            n = n3;
            if (ad < ac) {
                if (ae > 0) {
                    b.a(graphics2, aw, n - n5, n7, 0xFFFFFF, true, false);
                }
                if (ae + ad < ac) {
                    b.a(graphics2, aw, n + ad * n4 + n5, n7, 0xFFFFFF, true, true);
                }
            }
            n = n3 + n4 / 2 + 1;
            aj = au - 3 * var_javax_microedition_lcdui_Image_arr_b[5].getWidth();
            ah = (au >> 1) - (aj >> 1);
            n7 = au / 100;
            n5 = ah + n7;
            n7 = n5 + var_javax_microedition_lcdui_Image_arr_arr_a[ab][0].getWidth() + n7;
            for (n2 = ae; n2 < ae + ad; ++n2) {
                int n8 = var_int_arr_arr_a[ab][n2];
                b.a(graphics2, var_javax_microedition_lcdui_Image_arr_arr_a[ab][n8], n5, n, 6);
                if (ab == 2 || n8 == var_int_arr_arr_b[ab].length - 1) {
                    P = 2;
                }
                b.a(b.java_lang_String_a(var_int_arr_arr_b[ab][n8]), graphics2, n7, n, 6);
                n += n4;
            }
            ag = af - ae;
            ai = n3 + n4 * ag;
            ak = n4;
            graphics2.setColor(16545540);
            graphics2.drawRect(ah, ai, aj, ak);
        } else if (X == p) {
            n = au / 2;
            n6 = (av << 3) / 100;
            b.a(graphics, var_javax_microedition_lcdui_Image_arr_c[p], n, n6, 17);
            var_boolean_a = true;
            b.a(q, null, 0, 0, 0);
            n7 = Q;
            n5 = as - var_javax_microedition_lcdui_Image_arr_c[X].getHeight();
            Math.abs((n5 - n7) / 3);
            if (var_boolean_arr_a[0]) {
                P = 0;
            }
            b.a(b.java_lang_String_a(r), graphics, au - (var_javax_microedition_lcdui_Image_arr_b[4].getWidth() + 8 << 1), au / 2, av * 60 / 100, 3);
        } else if (X == var_int_l) {
            n = av >= 128 ? 1 : 0;
            n6 = var_java_lang_String_h != null && var_java_lang_String_h.length() > 0 ? 1 : 0;
            n7 = n != 0 ? var_javax_microedition_lcdui_Image_arr_b[10].getHeight() : 0;
            n5 = var_int_e + n7 * 3 / 5;
            if (var_javax_microedition_lcdui_Image_arr_c[var_int_l].getWidth() > 220) {
                graphics.setColor(0xCCCCCC);
                graphics.fillRect(aw + 20, n5, 3, 54);
                n5 += 54;
            } else if (var_javax_microedition_lcdui_Image_arr_c[var_int_l].getWidth() > 140) {
                graphics.setColor(0xD7D7D7);
                graphics.fillRect(aw + 14, n5, 2, 37);
                n5 += 37;
            } else if (var_javax_microedition_lcdui_Image_arr_c[var_int_l].getWidth() > 100) {
                graphics.setColor(14465464);
                graphics.fillRect(aw + 11, n5, 1, 26);
                n5 += 26;
            }
            b.a(graphics, var_javax_microedition_lcdui_Image_arr_c[var_int_l], aw, n5 += var_javax_microedition_lcdui_Image_arr_c[var_int_l].getHeight(), 33);
            b.a(graphics, var_javax_microedition_lcdui_Image_a, aw + (var_javax_microedition_lcdui_Image_arr_c[var_int_l].getWidth() >> 1) + 1, n5, 40);
            if (n != 0) {
                b.a(graphics, var_javax_microedition_lcdui_Image_arr_b[10], aw, var_int_e, 17);
            }
            if (n6 != 0) {
                P = 2;
                n4 = as - n5;
                n3 = 3;
                if (K << 1 > n4) {
                    n5 += K / 3;
                    n3 = 17;
                } else {
                    n5 += n4 / 2;
                }
                b.a(var_java_lang_String_h, graphics, au, aw, n5, n3);
            }
        } else if (X == o) {
            n = av >= 128 ? 1 : 0;
            n6 = var_javax_microedition_lcdui_Image_arr_c[X].getWidth() * 70 / 100;
            n7 = var_javax_microedition_lcdui_Image_arr_c[X].getHeight() >> 1;
            n5 = (au >> 1) - (n6 >> 1);
            n4 = (av >> 1) - (n7 >> 1);
            n3 = n6;
            n2 = n7;
            int n9 = n5;
            int n10 = n4;
            int n11 = n3;
            int n12 = n2;
            n2 = 0;
            n5 = 15812117;
            n7 = 16437549;
            n3 = n12;
            n4 = n11;
            n5 = n10;
            n7 = n9;
            Graphics graphics3 = graphics;
            if (n5 + n3 > av) {
                n3 = av - n5;
            }
            if (n7 + n4 > au) {
                n4 = au - n7;
            }
            for (n2 = n5; n2 < n5 + n3; ++n2) {
                int n13 = 250 + (n2 - n5) * -9 / n3;
                int n14 = 209 + (n2 - n5) * -139 / n3;
                int n15 = 45 + (n2 - n5) * -24 / n3;
                graphics3.setColor(n13, n14, n15);
                graphics3.drawLine(n7, n2, n7 + n4, n2);
            }
            int n16 = av / 2;
            b.a(graphics, var_javax_microedition_lcdui_Image_arr_c[X], aw, n16, 3);
            if (n != 0) {
                b.a(graphics, var_javax_microedition_lcdui_Image_arr_b[10], aw, var_int_e, 17);
            }
            if (var_javax_microedition_lcdui_Image_b == null) {
                var_boolean_a = true;
                b.a(b.java_lang_String_a(an), null, 0, 0, 0, 0);
                n = P;
                P = 0;
                b.a(b.java_lang_String_a(an), graphics, var_javax_microedition_lcdui_Image_arr_c[X].getWidth() / 2, aw, n16 -= Q / 2, 17);
                P = n;
            } else {
                b.a(graphics, var_javax_microedition_lcdui_Image_b, aw, av / 2, 3);
            }
        } else {
            var_boolean_a = true;
            b.a(b.java_lang_String_a(an), graphics, 0, 0, 0, 0);
            n = var_javax_microedition_lcdui_Image_arr_c[X].getHeight();
            n6 = 0;
            n7 = 0;
            n5 = 0;
            if (R > au - (var_javax_microedition_lcdui_Image_arr_b[9].getWidth() << 1)) {
                n6 = var_javax_microedition_lcdui_Image_arr_b[9].getHeight();
            }
            n4 = n + Q + n6;
            n3 = Math.max(0, av - n4);
            if (Q > K << 1 && n3 / 3 > K / 2) {
                n4 = n + (K << 1) + n6;
                n3 = Math.max(0, av - n4);
                n5 = 1;
            }
            n2 = n3 / 3;
            if (n6 > 0) {
                n6 = av - var_javax_microedition_lcdui_Image_arr_b[9].getHeight();
                n4 = n + Q;
                n3 = Math.max(0, av - n4);
                if (Q > K << 1 && n3 / 3 > Q - (K << 1)) {
                    n4 = n + (K << 1);
                    n3 = Math.max(0, av - n4);
                    n5 = 1;
                }
                if ((n4 = (n = n3 / 3) * 2 + Q + var_javax_microedition_lcdui_Image_arr_c[X].getHeight()) < n6) {
                    n2 = n;
                }
            }
            n = n6 = n2;
            b.a(graphics, var_javax_microedition_lcdui_Image_arr_c[X], aw, n, 17);
            n6 += n2 + var_javax_microedition_lcdui_Image_arr_c[X].getHeight();
            if (var_boolean_arr_a[0]) {
                P = 0;
            }
            if (n5 != 0) {
                n7 = -(K / 2);
            }
            b.a(b.java_lang_String_a(an), graphics, 0, aw, n6 + n7, 17);
        }
        b.c(graphics);
        if (al > 1) {
            n = Math.abs((int)(System.currentTimeMillis() / 80L % 8L) - 4);
            int n17 = 5;
            n7 = 7;
            n5 = 1;
            n4 = 3;
            if (var_boolean_d) {
                n17 = 4;
                n5 = 0;
                ++U;
            }
            if (var_boolean_e) {
                n7 = 6;
                n4 = 2;
                ++U;
            }
            n3 = n + 1 + var_javax_microedition_lcdui_Image_arr_b[n17].getWidth();
            n2 = n3 - var_javax_microedition_lcdui_Image_arr_b[n17].getWidth() * 20 / 100;
            b.a(graphics, var_javax_microedition_lcdui_Image_arr_b[n17], n3, ax, 10);
            b.a(graphics, var_javax_microedition_lcdui_Image_arr_b[n5], n2, ax, 10);
            b.a(graphics, var_javax_microedition_lcdui_Image_arr_b[n7], au - n3, ax, 6);
            b.a(graphics, var_javax_microedition_lcdui_Image_arr_b[n4], au - n2, ax, 6);
            if (U > 4) {
                var_boolean_d = false;
                var_boolean_e = false;
                U = 0;
            }
        }
    }

    /*
     * WARNING - void declaration
     */
    private static void a(Graphics graphics, int n, int n2, int n3, int n4, boolean bl, boolean bl2) {
        void var6_7;
        int n5;
        int n6 = n5 = var6_7 != false ? -1 : 1;
        if (n3 % 2 == 0) {
            --n3;
        }
        graphics.setColor(46319);
        b.a(graphics, n, n2, n - (n3 >> 1), n2 + n5 * (n3 >> 1), n + (n3 >> 1), n2 + n5 * (n3 >> 1));
        graphics.setColor(n4);
        b.a(graphics, n, n2 + n5, n - (n3 >> 1) + 2, n2 + n5 * (n3 >> 1) - n5, n + (n3 >> 1) - 2, n2 + n5 * (n3 >> 1) - n5);
    }

    private static void c(Graphics graphics) {
        int n = av - 2;
        int n2 = var_int_c;
        int n3 = au - var_int_d;
        if (var_boolean_f) {
            return;
        }
        var_byte_a = (byte)(var_byte_a | 1);
        if (((var_byte_a = (byte)(var_byte_a | 2)) & 1) != 0) {
            b.a(graphics, var_javax_microedition_lcdui_Image_arr_b[9], n2, n, 36);
        }
        if ((var_byte_a & 2) != 0) {
            b.a(graphics, var_javax_microedition_lcdui_Image_arr_b[8], n3, n, 40);
        }
    }

    private static Image a(byte[] byArray, int n, int n2, int n3, int n4) {
        long l;
        int n5;
        n = 0;
        for (n3 = 2; n == 0 && n3 < n2 + 2; ++n3) {
            if ((byArray[n3] & 0xFF) != 80 || (byArray[n3 + 1] & 0xFF) != 76 || (byArray[n3 + 2] & 0xFF) != 84 || (byArray[n3 + 3] & 0xFF) != 69) continue;
            n = n3;
        }
        n3 = (byArray[n - 4] << 24 & 0xFF000000) + (byArray[n - 3] << 16 & 0xFF0000) + (byArray[n - 2] << 8 & 0xFF00) + (byArray[n - 1] & 0xFF);
        byArray[n + 4 + 3] = (byte)(n4 >> 16 & 0xFF);
        byArray[n + 4 + 3 + 1] = (byte)(n4 >> 8 & 0xFF);
        byArray[n + 4 + 3 + 2] = (byte)n4;
        byte[] byArray2 = new byte[n3 + 4];
        System.arraycopy(byArray, n, byArray2, 0, n3 + 4);
        long[] lArray = new long[256];
        for (n5 = 0; n5 < 256; ++n5) {
            l = n5;
            for (int i = 0; i < 8; ++i) {
                if ((l & 1L) == 1L) {
                    l = 0xEDB88320L ^ l >> 1;
                    continue;
                }
                l >>= 1;
            }
            lArray[n5] = l;
        }
        l = 0xFFFFFFFFL;
        for (n5 = 0; n5 < byArray2.length; ++n5) {
            l = lArray[(int)(l ^ (long)byArray2[n5]) & 0xFF] ^ l >> 8;
        }
        byArray[n + 4 + n3] = (byte)(((l ^= 0xFFFFFFFFL) & 0xFFFFFFFFFF000000L) >> 24);
        byArray[n + 4 + n3 + 1] = (byte)((l & 0xFF0000L) >> 16);
        byArray[n + 4 + n3 + 2] = (byte)((l & 0xFF00L) >> 8);
        byArray[n + 4 + n3 + 3] = (byte)(l & 0xFFL);
        System.gc();
        n = 2;
        return Image.createImage((byte[])byArray, (int)n, (int)n2);
    }

    private static void a(Graphics graphics, int n, int n2, int n3, int n4, int n5, int n6) {
        graphics.fillTriangle(n, n2, n3, n4, n5, n6);
    }

    private static void a(Graphics graphics, Image image, int n, int n2, int n3) {
        graphics.drawImage(image, n, n2, n3);
    }

    private static void a(Graphics graphics, int n, int n2, int n3, int n4) {
        n = Math.max(n, 0);
        n2 = Math.max(n2, 0);
        n3 = Math.min(n3, au);
        n4 = Math.min(n4, av);
        graphics.setClip(n, n2, n3, n4);
    }

    public final void run() {
        while (var_boolean_g) {
            try {
                if (var_java_lang_String_g != null) {
                    var_java_lang_String_d = var_java_lang_String_g;
                    if (var_java_lang_String_d != null && var_java_lang_String_d.length() > 0) {
                        String string = var_java_lang_String_d;
                        var_java_lang_String_d = null;
                        String cfr_ignored_0 = "urlPlatformRequest = " + (String)string;
                        try {
                            var_javax_microedition_midlet_MIDlet_a.platformRequest(string);
                            Thread.sleep(200L);
                        }
                        catch (Exception exception) {}
                        V = 1;
                        var_javax_microedition_midlet_MIDlet_a.notifyDestroyed();
                    }
                    var_java_lang_String_g = null;
                }
                Thread.sleep(1000L);
            }
            catch (Exception exception) {}
        }
    }

    public final void commandAction(Command command, Displayable displayable) {
        if (var_boolean_f) {
            if (command == var_javax_microedition_lcdui_Command_a) {
                b.boolean_a(25);
                return;
            }
            if (command == var_javax_microedition_lcdui_Command_b) {
                b.boolean_a(26);
            }
        }
    }

    private static InputStream a(String string) {
        return "a".getClass().getResourceAsStream(string);
    }

    static {
        var_java_lang_String_a = "2.0";
        var_java_lang_String_b = "IGP-Signature=" + var_java_lang_String_a;
        var_java_lang_String_c = "";
        var_int_a = 0;
        var_int_b = 13568256;
        var_int_c = 2;
        var_int_d = 2;
        var_int_h = 0;
        var_boolean_arr_a = new boolean[1];
        var_int_arr_a = new int[1];
        var_int_j = -1;
        var_int_k = 8;
        H = 14;
        L = 0;
        M = 1;
        N = 2;
        O = 3;
        var_java_lang_String_arr_a = new String[]{"URL-WN", "URL-BS", "URL"};
        var_java_lang_String_arr_b = new String[0];
        var_boolean_f = false;
        var_javax_microedition_lcdui_CommandListener_a = null;
        var_b_a = null;
        var_boolean_g = false;
        var_java_lang_String_g = null;
        var_boolean_h = false;
        al = -1;
        am = 0;
        ay = 0;
        var_boolean_k = false;
        var_boolean_l = false;
        az = -1;
        aA = -1;
        var_java_util_Hashtable_a = new Hashtable();
        aB = 0;
    }
}


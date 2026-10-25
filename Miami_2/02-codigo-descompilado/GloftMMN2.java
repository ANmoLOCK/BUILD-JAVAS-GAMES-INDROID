/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.microedition.lcdui.Display
 *  javax.microedition.lcdui.Displayable
 *  javax.microedition.midlet.MIDlet
 */
import javax.microedition.lcdui.Display;
import javax.microedition.lcdui.Displayable;
import javax.microedition.midlet.MIDlet;

public final class GloftMMN2
extends MIDlet {
    public static GloftMMN2 var_GloftMMN2_a;
    public static f var_f_a;
    private static Display var_javax_microedition_lcdui_Display_a;

    public GloftMMN2() {
        var_GloftMMN2_a = this;
    }

    public final void startApp() {
        if (var_javax_microedition_lcdui_Display_a == null) {
            var_javax_microedition_lcdui_Display_a = Display.getDisplay((MIDlet)this);
        }
        if (var_f_a == null) {
            var_f_a = new f();
            var_javax_microedition_lcdui_Display_a.setCurrent((Displayable)var_f_a);
            f.void_j();
            return;
        }
        var_javax_microedition_lcdui_Display_a.setCurrent((Displayable)var_f_a);
        f.void_i();
    }

    public final void pauseApp() {
        f.void_h();
    }

    public final void destroyApp(boolean bl) {
        if (var_f_a != null) {
            var_f_a = null;
        }
        this.notifyDestroyed();
    }

    static {
        var_f_a = null;
        var_javax_microedition_lcdui_Display_a = null;
    }
}


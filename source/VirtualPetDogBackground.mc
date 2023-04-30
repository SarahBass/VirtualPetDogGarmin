import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
class Background extends Ui.Drawable {

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc) as Void {
        // Set the background color then call to clear the screen
        dc.setColor(Gfx.COLOR_TRANSPARENT, getApp().getProperty("BackgroundColor") as Number);
        dc.clear();
    }

}

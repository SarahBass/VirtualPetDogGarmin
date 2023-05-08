import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Math;
import Toybox.Application.Storage;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Position;
using Toybox.Time;
using Toybox.Math;
using Toybox.Time.Gregorian;
using Toybox.System; 
using Toybox.UserProfile;
using Toybox.ActivityMonitor;
using Toybox.SensorHistory;
using Toybox.Position;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;

class BlobbyPetView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

  
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }


    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        
        var timeFormat = "$1$:$2$";
        var profile = UserProfile.getProfile();
       var mySettings = System.getDeviceSettings();
        var myStats = System.getSystemStats();
        var info = ActivityMonitor.getInfo();
       var clockTime = System.getClockTime();
       var centerX = (dc.getWidth()) / 2;
       var centerY = (dc.getHeight()) / 2;
       var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
       var hours = clockTime.hour;
               if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {   
                timeFormat = "$1$:$2$";
                hours = hours.format("%02d");  
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        var weekdayArray = ["Day", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"] as Array<String>;
        var heart = "--";
         var monthArray = ["Month", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"] as Array<String>;
            var AMPM = "";       
    if (!System.getDeviceSettings().is24Hour) {
        if (clockTime.hour > 12) {
                AMPM = "N";
            }else{
                AMPM = "M";
            }}
        
        
        
        var time = View.findDrawableById("TimeLabel") as Text;
        var dateText = View.findDrawableById("DateLabel") as Text;
        var batteryText = View.findDrawableById("batteryLabel") as Text;
        var heartText = View.findDrawableById("heartLabel") as Text;
        var stepText = View.findDrawableById("stepsLabel") as Text;
        var calorieText = View.findDrawableById("caloriesLabel") as Text;
        time.setText(timeString+AMPM );
        dateText.setText(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year);
        batteryText.setText("= " + Lang.format("$1$",[((myStats.battery)).format("%2d")]) + "%");
        heartText.setText("+ "+heart);
        stepText.setText("^ "+info.steps);
        calorieText.setText("~ "+info.calories);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setPenWidth(10);
        var outercolor = 0x9AFF90;
        var innercolor = 0x48FF35;
        var animate = 1;
        if (today.sec%2 == 0){animate = 0.75;}else {animate =1;}
        var animate2 = 1;
        if (today.sec%2 == 0){animate2 = 0.95;}else {animate2 =1;}
        //Draw Baby 
        dc.setColor(outercolor , Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(centerX, (centerY*3)*animate2/5, (centerX*1.25)/3, centerY/4);
        dc.setColor(innercolor, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(centerX, (centerY*3)*animate2/5, (centerX*1.25)/3, centerY/4);
        dc.setColor(outercolor, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(centerX, (centerY*1.25)*animate2/5, ((centerX)/6)*animate2, (centerY/8)*animate2);
        dc.setColor(innercolor, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(centerX, (centerY*1.25)*animate2/5, ((centerX)/6)*animate2, (centerY/8)*animate2);
        
        //Draw Face

        //eyes
        dc.setPenWidth(5);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawArc((centerX*15)/20, ((centerY*3)*animate2/5), centerX/13, Graphics.ARC_CLOCKWISE, 360, 180);
        dc.drawArc((centerX*12)/10, ((centerY*3)*animate2/5), centerX/13, Graphics.ARC_CLOCKWISE, 360, 180);
        //cheeks
        dc.setColor(0xEF1EB8, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse((centerX*13)/20, ((centerY*7)*animate2)/10, centerX/15, centerY/30);
        dc.fillEllipse((centerX*26)/20, ((centerY*7)*animate2)/10, centerX/15, centerY/30);
        //mouth
    
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle((centerX*19)/20, (centerY*7)*animate2/10, (centerX/18)*animate);
        dc.setColor(outercolor, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle((centerX*19)/20, (centerY*7)*animate2/10, (centerX/23)*animate);
 
if (mySettings.screenShape == 1){
dc.setPenWidth(30);
dc.setColor(0x272727, Graphics.COLOR_TRANSPARENT);
dc.drawCircle(centerX, centerY, centerX);
dc.setColor(0x48FF35, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerY, centerX, Graphics.ARC_CLOCKWISE, 180, 138);
dc.setColor(0xFFFF35, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerY, centerX, Graphics.ARC_CLOCKWISE, 135, 92);
dc.setColor(0xEF1EB8, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerY, centerX, Graphics.ARC_CLOCKWISE, 90, 48);
dc.setColor(0x00F7EE, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerY, centerX, Graphics.ARC_CLOCKWISE, 45, 0);
dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerY, centerX, Graphics.ARC_CLOCKWISE, 358, 357 - (info.steps/56));
}else 
{
  dc.setPenWidth(15);
  dc.setColor(0x272727, Graphics.COLOR_TRANSPARENT);
  dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
  dc.setColor(0x48FF35, Graphics.COLOR_TRANSPARENT);
  dc.drawLine(0, 0, dc.getWidth(), 0);
  dc.setColor(0xFFFF35, Graphics.COLOR_TRANSPARENT);
  dc.drawLine(dc.getWidth(), dc.getHeight(), 0, dc.getHeight());
  dc.setColor(0xEF1EB8, Graphics.COLOR_TRANSPARENT);
  dc.drawLine(0, 0, 0, dc.getHeight());
  dc.setColor(0x00F7EE, Graphics.COLOR_TRANSPARENT);
  dc.drawLine(dc.getWidth(), 0, dc.getWidth(), dc.getHeight());
}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}

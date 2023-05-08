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
       // var profile = UserProfile.getProfile();
       var mySettings = System.getDeviceSettings();
        var myStats = System.getSystemStats();
        var info = ActivityMonitor.getInfo();
       var clockTime = System.getClockTime();
       var centerX = (dc.getWidth()) / 2;
       var centerY = (dc.getHeight());
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
         //   var AMPM = "";       
    /*if (!System.getDeviceSettings().is24Hour) {
        if (clockTime.hour > 12) {
                AMPM = "N";
            }else{
                AMPM = "M";
            }}*/
        var TempMetric = System.getDeviceSettings().temperatureUnits;
         var TEMP;
     if(Toybox.Weather.getCurrentConditions() != null){ TEMP= Toybox.Weather.getCurrentConditions().feelsLikeTemperature;}
     else {TEMP = 61;}
    var FC;
    var cond;
    if (Toybox.Weather.getCurrentConditions() != null){ cond = Toybox.Weather.getCurrentConditions().condition;}
    else{cond = 0;}

    if (TempMetric == System.UNIT_METRIC){  
    FC = "C";
    }else{
    TEMP = (((((TEMP)*9)/5)+32).toNumber()); 
    FC = "F";   
    }
        
        
        var timeText = View.findDrawableById("TimeLabel") as Text;
        var dateText = View.findDrawableById("DateLabel") as Text;
        var batteryText = View.findDrawableById("batteryLabel") as Text;
        var heartText = View.findDrawableById("heartLabel") as Text;
        var stepText = View.findDrawableById("stepsLabel") as Text;
        var calorieText = View.findDrawableById("caloriesLabel") as Text;
        var temperatureText = View.findDrawableById("tempLabel") as Text;
        var temperatureText1 = View.findDrawableById("tempLabel1") as Text;
        dateText.locY = (((System.getDeviceSettings().screenHeight)*23/30));
        timeText.locY = (((System.getDeviceSettings().screenHeight)/30));
        batteryText.locX = (((System.getDeviceSettings().screenWidth)/30));
        heartText.locX = (((System.getDeviceSettings().screenWidth)*28/30));
        stepText.locX = (((System.getDeviceSettings().screenWidth)*2/30));
        stepText.locY = (((System.getDeviceSettings().screenHeight)*8/30));
        calorieText.locX = (((System.getDeviceSettings().screenWidth)*27/30));
        calorieText.locY = (((System.getDeviceSettings().screenHeight)*8/30));
        temperatureText.locY = (((System.getDeviceSettings().screenHeight)*23/30));
        temperatureText1.locY = (((System.getDeviceSettings().screenHeight)*23/30));
        timeText.setText(timeString);
        dateText.setText(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year);
        batteryText.setText(" = " + Lang.format("$1$",[((myStats.battery)).format("%2d")]) + "%");
        heartText.setText(heart+" + ");
        stepText.setText(" ^ "+info.steps);
        calorieText.setText(info.calories+" ~ ");
        temperatureText.setText(weather(cond));
        temperatureText1.setText(TEMP+FC);
        
        View.onUpdate(dc);

        
        dc.setPenWidth(10);
        var grow = 1;
        
        var fakesteps =2000;
        //0-1000 egg
        //1000-2000 no head change
        //2000 + growth
        if (fakesteps>2000){grow = 1 + fakesteps/5000;}else{grow = 1;}
        var ColorArrayInner = [Graphics.COLOR_WHITE,0x48FF35,0xFFFF35,0xEF1EB8,0x00F7EE,0x9AFF90,0xFFB2EB,0x9AFFFB,Graphics.COLOR_WHITE,0x48FF35,0xFFFF35,0x00F7EE,0x9AFF90,0xFFB2EB,0x9AFFFB ];
        var ColorArrayOuter = [0x48FF35, 0x9AFF90,Graphics.COLOR_WHITE,0xFFB2EB,0x9AFFFB,0x48FF35,0xEF1EB8,0x00F7EE ];
        var outercolor = ColorArrayOuter[today.day_of_week];
        var innercolor = ColorArrayInner[today.day_of_week];
        //3 pink is a problem with cheeks
        var animate = 1;
        if (today.sec%2 == 0){animate = 0.75;}else {animate =1;}
        var animate2 = 1;
        if (today.sec%2 == 0){animate2 = 0.95;}else {animate2 =1;}
        var animate3 = 1;
        if (today.sec%2 == 0){animate3 = 1.05;}else {animate3 =1;}
        //Draw Body 
        dc.setColor(outercolor , Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(centerX, ((centerY*3)*animate2/5), (centerX*1.25)/3, centerX/4);
       if (info.steps >2000){
        dc.drawEllipse(centerX*0.4*animate2, (centerY*4)*animate2/5, (centerX*1.25)/9, centerX/14);
        dc.drawEllipse(centerX*1.6*animate3, (centerY*4)*animate2/5, (centerX*1.25)/9, centerX/14);
       }else{}
        dc.setColor(innercolor, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(centerX, (centerY*3)*animate2/5, (centerX*1.25)/3, centerX/4);
        if (info.steps >2000){
        dc.fillEllipse((centerX*0.4)*animate2, (centerY*4)*animate2/5, (centerX*1.25)/9, centerX/14);
        dc.fillEllipse(centerX*1.6*animate3, (centerY*4)*animate2/5, (centerX*1.25)/9, centerX/14);
        }else{}
        //Draw Top of Head
       
       


        if ((today.day)%4 == 0){
        dc.setColor(outercolor, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(centerX, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerX/8)*animate2*grow);
        dc.setColor(innercolor, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(centerX, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerX/8)*animate2*grow);
        }else if (today.day%4 ==1){
       dc.setColor(outercolor, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(centerX*0.75, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerX/8)*animate2*grow);
        dc.drawEllipse(centerX*1.25, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerX/8)*animate2*grow);
        dc.setColor(innercolor, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(centerX*0.75, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerX/8)*animate2*grow);  
        dc.fillEllipse(centerX*1.25, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerX/8)*animate2*grow);
        }else if(today.day%4 ==2){
        dc.setColor(outercolor, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(centerX*0.75, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerX/8)*animate2*grow);
        dc.drawEllipse(centerX*1.25, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerX/8)*animate2*grow);
        dc.drawEllipse(centerX*1, (centerY*1.25)*animate2/53, ((centerX)/6)*animate2*grow, (centerX/8)*animate2*grow);
        dc.setColor(innercolor, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(centerX*0.75, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerY/8)*animate2*grow);  
        dc.fillEllipse(centerX*1.25, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerY/8)*animate2*grow);
        dc.fillEllipse(centerX*1, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerY/8)*animate2*grow);
        } else if(today.day%4 ==3){
        dc.setColor(outercolor, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(centerX, (centerY*1.5)*animate2/3, ((centerX)/9)*animate2*grow, (centerX/6)*animate2*grow);
        dc.setColor(innercolor, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(centerX, (centerY*1.5)*animate2/3, ((centerX)/9)*animate2*grow, (centerX/6)*animate2*grow);   
        }else {
        dc.setColor(outercolor, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(centerX, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerX/8)*animate2*grow);
        dc.setColor(innercolor, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(centerX, (centerY*1.25)*animate2/3, ((centerX)/6)*animate2*grow, (centerX/8)*animate2*grow);
        }





        //Draw Face
        dc.setPenWidth(5);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        //eyes
        if (today.min%5==0){
        dc.drawArc((centerX*15)/20, ((centerY*3)*animate2/5), centerX/13, Graphics.ARC_CLOCKWISE, 360, 180);
        dc.drawArc((centerX*12)/10, ((centerY*3)*animate2/5), centerX/13, Graphics.ARC_CLOCKWISE, 360, 180);
        } else if (today.min%5==1){
        dc.drawArc((centerX*15)/20, ((centerY*13)*animate2/20), centerX/13, Graphics.ARC_CLOCKWISE, 180, 360);
        dc.drawArc((centerX*12)/10, ((centerY*13)*animate2/20), centerX/13, Graphics.ARC_CLOCKWISE, 180, 360);
    
        } else if (today.min%5==2){

        dc.drawLine((centerX*13)/20, ((centerY*3)*animate2/5), (centerX*16)/20, ((centerY*13)*animate2/20));
        dc.drawLine((centerX*23)/20, ((centerY*13)*animate2/20), (centerX*26)/20, ((centerY*3)*animate2/5));
        } else if (today.min%5==3){
        dc.drawLine((centerX*14)/20, ((centerY*3)*animate2/5), (centerX*17)/20, ((centerY*3)*animate2/5));
        dc.drawLine((centerX*22)/20, ((centerY*3)*animate2/5), (centerX*25)/20, ((centerY*3)*animate2/5));
        } else if (today.min%5==4){
        dc.fillEllipse(centerX*0.75, (centerY*6)*animate2/10, ((centerX)/25), (centerX/20));  
        dc.fillEllipse(centerX*1.15, (centerY*6)*animate2/10, ((centerX)/25), (centerX/20));
        } else{
        dc.drawArc((centerX*15)/20, ((centerY*3)*animate2/5), centerX/13, Graphics.ARC_CLOCKWISE, 360, 180);
        dc.drawArc((centerX*12)/10, ((centerY*3)*animate2/5), centerX/13, Graphics.ARC_CLOCKWISE, 360, 180);
        }
        
        
        
        
        //cheeks
        dc.setColor(0xEF1EB8, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse((centerX*13)/20, ((centerY*13)*animate2)/20, centerX/15, centerX/30);
        dc.fillEllipse((centerX*26)/20, ((centerY*13)*animate2)/20, centerX/15, centerX/30);
        
        
        //mouth
        if (today.min%3==0){
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle((centerX*19)/20, (centerY*13)*animate2/20, (centerX/18)*animate);
        dc.setColor(outercolor, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle((centerX*19)/20, (centerY*13)*animate2/20, (centerX/23)*animate);}
        else if (today.min%3==1){
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawArc((centerX), (centerY*13)*animate2/20, (centerX/18), Graphics.ARC_CLOCKWISE, 360, 180);
        dc.drawArc((centerX*18)/20, (centerY*13)*animate2/20, (centerX/18), Graphics.ARC_CLOCKWISE, 360, 180);
         }else if (today.min%3==2){
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawArc((centerX*19)/20, (centerY*13)*animate2/20, (centerX/18)*animate, Graphics.ARC_CLOCKWISE, 360, 180);
         }else{
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle((centerX*19)/20, (centerY*7)*animate2/10, (centerX/18)*animate);
        dc.setColor(outercolor, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle((centerX*19)/20, (centerY*7)*animate2/10, (centerX/23)*animate);}

        //spots
         dc.setColor(ColorArrayInner[today.day_of_week+2], Graphics.COLOR_TRANSPARENT);
         dc.fillEllipse((centerX), ((centerY*17)*animate2)/40, (centerX/25)*animate2*grow, (centerX/20)*animate2*grow);
         dc.setColor(ColorArrayInner[today.day_of_week+3], Graphics.COLOR_TRANSPARENT);
         dc.fillEllipse((centerX), ((centerY*15)*animate2)/40, (centerX/26)*animate2*grow, (centerX/24)*animate2*grow);
         dc.setColor(ColorArrayInner[today.day_of_week+4], Graphics.COLOR_TRANSPARENT);
         dc.fillEllipse((centerX*43)/40, ((centerY*16)*animate2)/40, (centerX/30)*animate2*grow, (centerX/26)*animate2*grow);
 
if (mySettings.screenShape == 1){
dc.setPenWidth(30);
//0x555555 for 64 bit color and 16 bit color - only AMOLED can show 0x272727
dc.setColor(0x555555, Graphics.COLOR_TRANSPARENT);
dc.drawCircle(centerX, centerX, centerX);
dc.setColor(0x48FF35, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerX, centerX, Graphics.ARC_CLOCKWISE, 90, 47);
dc.setColor(0xFFFF35, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerX, centerX, Graphics.ARC_CLOCKWISE, 45, 2);
dc.setColor(0xEF1EB8, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerX, centerX, Graphics.ARC_CLOCKWISE, 0, 317);
dc.setColor(0x00F7EE, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerX, centerX, Graphics.ARC_CLOCKWISE, 315, 270);
dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerX, centerX, Graphics.ARC_CLOCKWISE, 268, 266 - (info.steps/56));
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

/*
                   _   _             
 __ __ _____ __ _| |_| |_  ___ _ _  
 \ V  V / -_) _` |  _| ' \/ -_) '_| 
  \_/\_/\___\__,_|\__|_||_\___|_|   
                                    
 
 */   
       
function weather(cond) {
  if (cond == 0 || cond == 40){return "b";}//sun
  else if (cond == 50 || cond == 49 ||cond == 47||cond == 45||cond == 44||cond == 42||cond == 31||cond == 27||cond == 26||cond == 25||cond == 24||cond == 21||cond == 18||cond == 15||cond == 14||cond == 13||cond == 11||cond == 3){return "a";}//rain
  else if (cond == 52||cond == 20||cond == 2||cond == 1){return "e";}//cloud
  else if (cond == 5 || cond == 8|| cond == 9|| cond == 29|| cond == 30|| cond == 33|| cond == 35|| cond == 37|| cond == 38|| cond == 39){return "g";}//wind
  else if (cond == 51 || cond == 48|| cond == 46|| cond == 43|| cond == 10|| cond == 4){return "i";}//snow
  else if (cond == 32 || cond == 37|| cond == 41|| cond == 42){return "f";}//whirl
  else {return "c";}
}
    function onHide() as Void {}

    function onExitSleep() as Void {}
 
    function onEnterSleep() as Void {}

}

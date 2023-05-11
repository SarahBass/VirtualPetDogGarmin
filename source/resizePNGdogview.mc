import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Weather;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Time.Gregorian;

class VirtualPetNothingView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }


    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

 
    function onShow() as Void {
    }

    
    function onUpdate(dc as Dc) as Void {
        var mySettings = System.getDeviceSettings();
       var myStats = System.getSystemStats();
       var info = ActivityMonitor.getInfo();
       var timeFormat = "$1$:$2$";
       var clockTime = System.getClockTime();
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
        var monthArray = ["Month", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"] as Array<String>;
 
 var userBattery = "-";
   if (myStats.battery != null){userBattery = Lang.format("$1$",[((myStats.battery.toNumber())).format("%2d")]);}else{userBattery="-";} 

   var userSTEPS = 0;
   if (info.steps != null){userSTEPS = info.steps.toNumber();}else{userSTEPS=0;} 

  

     var userCAL = 0;
   if (info.calories != null){userCAL = info.calories.toNumber();}else{userCAL=0;}  
   
   var getCC = Toybox.Weather.getCurrentConditions();
    var TEMP = "--";
    var FC = "-";
     if(getCC != null && getCC.temperature!=null){     
        if (System.getDeviceSettings().temperatureUnits == 0){  
    FC = "C";
    TEMP = getCC.temperature.format("%d");
    }else{
    TEMP = (((getCC.temperature*9)/5)+32).format("%d"); 
    FC = "F";   
    }}
     else {TEMP = "--";}
    
    var cond;
    if (getCC != null){ cond = getCC.condition.toNumber();}
    else{cond = 0;}//sun
    
   //Get and show Heart Rate Amount

var userHEART = "--";
if (getHeartRate() == null){userHEART = "--";}
else if(getHeartRate() == 255){userHEART = "--";}
else{userHEART = getHeartRate().toString();}

       var centerX = (dc.getWidth()) / 2;
       //var centerY = (dc.getHeight());


        var timeText = View.findDrawableById("TimeLabel") as Text;
        var dateText = View.findDrawableById("DateLabel") as Text;
        var batteryText = View.findDrawableById("batteryLabel") as Text;
        var heartText = View.findDrawableById("heartLabel") as Text;
        var stepText = View.findDrawableById("stepsLabel") as Text;
        var calorieText = View.findDrawableById("caloriesLabel") as Text;
        var temperatureText = View.findDrawableById("tempLabel") as Text;
        var temperatureText1 = View.findDrawableById("tempLabel1") as Text;
        
        if (System.getDeviceSettings().screenHeight > 299){
        var connectTextP = View.findDrawableById("connectLabelP") as Text;
        var connectTextB = View.findDrawableById("connectLabelB") as Text;
        connectTextP.locY = (((System.getDeviceSettings().screenHeight)*25.5/30));
        connectTextB.locY = (((System.getDeviceSettings().screenHeight)*25.5/30));
         if (mySettings.phoneConnected == true){connectTextP.setColor(0x48FF35);}
    else{connectTextP.setColor(0xEF1EB8);}
    if (myStats.charging == true){connectTextB.setColor(0x48FF35);}
    else{connectTextB.setColor(0xEF1EB8);}
        connectTextP.setText("  #  ");
        connectTextB.setText("  @  ");
        }else { }

        dateText.locY = (((System.getDeviceSettings().screenHeight)*23/30));
        timeText.locY = (((System.getDeviceSettings().screenHeight)/30));
        
        if(mySettings.screenShape != 1){
          
        batteryText.locX = (((System.getDeviceSettings().screenWidth)/30));
        heartText.locX = (((System.getDeviceSettings().screenWidth)*28/30));
        stepText.locX = (((System.getDeviceSettings().screenWidth)*3/30));
        stepText.locY = (((System.getDeviceSettings().screenHeight)*7/30));
        calorieText.locX = (((System.getDeviceSettings().screenWidth)*27/30));
        calorieText.locY = (((System.getDeviceSettings().screenHeight)*7/30));
        temperatureText.locY = (((System.getDeviceSettings().screenHeight)*19/30));
        temperatureText1.locY = (((System.getDeviceSettings().screenHeight)*20/30));
        temperatureText.locX = (((System.getDeviceSettings().screenWidth)*3/30));
        temperatureText1.locX = (((System.getDeviceSettings().screenWidth)*27/30));
        }else{
        batteryText.locX = (((System.getDeviceSettings().screenWidth)/30));
        heartText.locX = (((System.getDeviceSettings().screenWidth)*28/30));
        stepText.locX = (((System.getDeviceSettings().screenWidth)*3/30));
        stepText.locY = (((System.getDeviceSettings().screenHeight)*10/30));
        calorieText.locX = (((System.getDeviceSettings().screenWidth)*27/30));
        calorieText.locY = (((System.getDeviceSettings().screenHeight)*10/30));
        temperatureText.locY = (((System.getDeviceSettings().screenHeight)*17/30));
        temperatureText1.locY = (((System.getDeviceSettings().screenHeight)*17/30));
        temperatureText.locX = (((System.getDeviceSettings().screenWidth)*3/30));
        temperatureText1.locX = (((System.getDeviceSettings().screenWidth)*27/30));
        }
    
        timeText.setText(timeString);
        dateText.setText(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year);
        batteryText.setText(" = "+userBattery+"%");
        heartText.setText(userHEART+" + ");
        stepText.setText(" ^ "+userSTEPS);
        calorieText.setText(userCAL+" ~ ");
        temperatureText.setText(weather(cond));
        temperatureText1.setText(TEMP+" "+FC+" ");
        var dog = dogPhase(today.sec, today.min);
        var object = object(userSTEPS, today.month);
        View.onUpdate(dc);
        
       
        dog.draw(dc);
        object.draw(dc); 
        if (mySettings.screenShape == 1){
          if(System.getDeviceSettings().screenHeight < 301){dc.setPenWidth(22);}
          else{dc.setPenWidth(30);}

//0x555555 for 64 bit color and 16 bit color - only AMOLED can show 0x272727
dc.setColor(0x272727, Graphics.COLOR_TRANSPARENT);
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
dc.drawArc(centerX, centerX, centerX, Graphics.ARC_CLOCKWISE, 268, 266 - (userSTEPS/56));
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


    function onHide() as Void { }

    
    function onExitSleep() as Void {}

    
    function onEnterSleep() as Void {}

function weather(cond) {
  if (cond == 0 || cond == 40){return "b";}//sun
  else if (cond == 50 || cond == 49 ||cond == 47||cond == 45||cond == 44||cond == 42||cond == 31||cond == 27||cond == 26||cond == 25||cond == 24||cond == 21||cond == 18||cond == 15||cond == 14||cond == 13||cond == 11||cond == 3){return "a";}//rain
  else if (cond == 52||cond == 20||cond == 2||cond == 1){return "e";}//cloud
  else if (cond == 5 || cond == 8|| cond == 9|| cond == 29|| cond == 30|| cond == 33|| cond == 35|| cond == 37|| cond == 38|| cond == 39){return "g";}//wind
  else if (cond == 51 || cond == 48|| cond == 46|| cond == 43|| cond == 10|| cond == 4){return "i";}//snow
  else if (cond == 32 || cond == 37|| cond == 41|| cond == 42){return "f";}//whirlwind 
  else {return "c";}//suncloudrain 
}


private function getHeartRate() {
  // initialize it to null
  var heartRate = null;

  // Get the activity info if possible
  var info = Activity.getActivityInfo();
  if (info != null) {
    heartRate = info.currentHeartRate;
  } else {
    // Fallback to `getHeartRateHistory`
    var latestHeartRateSample = ActivityMonitor.getHeartRateHistory(1, true).next();
    if (latestHeartRateSample != null) {
      heartRate = latestHeartRateSample.heartRate;
    }
  }

  // Could still be null if the device doesn't support it
  return heartRate;
}

function object(userSTEPS, month){
 var mySettings = System.getDeviceSettings();
      var venus2X =  mySettings.screenWidth *0.25 ;
      var venus2Y =  mySettings.screenHeight *0.18 ;
var objectARRAY=[
      (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.jan,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.feb,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mar,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.apr,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.may,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (  new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.jun,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
           ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.jul,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
             (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.aug,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.sep,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.oct,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.nov,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dec,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
     ];
var smallobjectARRAY=[
      (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smalljan,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smallfeb,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smallmar,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smallapr,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
              (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smallmay,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (  new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smalljun,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
           ( new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smalljul,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
             (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smallaug,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smallsep,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smalloct,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smallnov,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.smalldec,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
     ];

if (System.getDeviceSettings().screenHeight < 301){return smallobjectARRAY[(month-1)];}
else{
return objectARRAY[(month-1)];}
}

function dogPhase(seconds, minutes){
  var mySettings = System.getDeviceSettings();
  var size= 0;//0: normal 200 px 1:small 100 px 2:Large 200px 3:square
var growX = 1; //0.75 for grow large 1.25 for shrink small 1 for normal or square
var growY = 1;
      if (System.getDeviceSettings().screenHeight < 301){
        size=1;
        growX=1.25;
        growY=growX*growX;
      }else if (System.getDeviceSettings().screenHeight > 390){
        size=2;
        growX=0.85;
        growY=growX*growX;
      }else if (mySettings.screenShape != 1){
        size=3;
        growX=0.80;
        growY=1;
      }else{
        size=0;
        growX=1;
        growY=1;
      }

  var venus2X =  mySettings.screenWidth *0.25*growX ;
  var venus2Y =  mySettings.screenHeight *0.18*growY ;

 var smalldogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog0,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog1,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog2,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog3,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALLDog4,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
 ];
        
   var bigdogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog0,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog1,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog2,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog3,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIGDog4,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
 ];      

   var dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog0,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog1,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog2,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog3,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Dog4,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
 ]; 

if (size ==1){
if (minutes%4 == 0){
  if(seconds%2==0){return smalldogARRAY[1]; }else{return smalldogARRAY[0];}
}else if (minutes%4 == 1){
  if(seconds%2==0){return smalldogARRAY[1];}else{return smalldogARRAY[2];}
}else if (minutes%4 == 2){
  if(seconds%2==0){return smalldogARRAY[1];}else{return smalldogARRAY[3];}
}else{
if(seconds%2==0){return smalldogARRAY[0];}else{return smalldogARRAY[4];}
}
}else if(size==2){
if (minutes%4 == 0){
  if(seconds%2==0){return bigdogARRAY[1]; }else{return bigdogARRAY[0];}
}else if (minutes%4 == 1){
  if(seconds%2==0){return bigdogARRAY[1];}else{return bigdogARRAY[2];}
}else if (minutes%4 == 2){
  if(seconds%2==0){return bigdogARRAY[1];}else{return bigdogARRAY[3];}
}else{
if(seconds%2==0){return bigdogARRAY[0];}else{return bigdogARRAY[4];}
}}
else{
  if (minutes%4 == 0){
  if(seconds%2==0){return dogARRAY[1]; }else{return dogARRAY[0];}
}else if (minutes%4 == 1){
  if(seconds%2==0){return dogARRAY[1];}else{return dogARRAY[2];}
}else if (minutes%4 == 2){
  if(seconds%2==0){return dogARRAY[1];}else{return dogARRAY[3];}
}else{
if(seconds%2==0){return dogARRAY[0];}else{return dogARRAY[4];}
}
}
}

}
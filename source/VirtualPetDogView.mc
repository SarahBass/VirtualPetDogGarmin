/*                                             *
   _____ __        *       _       __      __       __  
  / ___// /_____ ______   | |     / /___ _/ /______/ /_  *
  \__ \/ __/ __ `/ ___/   | | /| / / __ `/ __/ ___/ __ \
 ___/ / /_/ /_/ / /   *   | |/ |/ / /_/ / /_/ /__/ / / / *
/____/\__/\__,_/_/        |__/|__/\__,_/\__/\___/_/ /_/ 
                                                                                                                                                                 
  /\   File: VirtualStarPetView.mc              *                         
  \/   Contains: Most Important Code     /\
       Created for Garmin Venu 2 Series  \/           *
       Author : Sarah Bass                        
*/

/*-------------------------------------------------------------
  _                     _      
 (_)_ __  _ __  ___ _ _| |_ ___
 | | '  \| '_ \/ _ \ '_|  _(_-<
 |_|_|_|_| .__/\___/_|  \__/__/
         |_|                   
----------------------------------------------------------------*/
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

 	
//--------------------------------------------------//
/*            
  Program Outline:
   Class{ 
      Initialize Global Variables
      Initialize Bitmaps : function initialize()
      Initialize Layout : function onLayout()
      Update Scene : function onUpdate()
      Additional Functions :
         Moon phase
         Weather
         Heart Rate
         Zodiac Sign
         Bitmap Functions
         Void Garmin Functions 
    }    
*/
//---------------------------------------------------//
class VirtualPetDogView extends Ui.WatchFace {
var mySettings = System.getDeviceSettings();
var sensorIter = getIterator();
const venus2X = LAYOUT_HALIGN_CENTER;
const venus2Y = 145;
const venus2XL = 50;
const venus2XR =  mySettings.screenWidth *0.5;
/*
  _      _ _   _      _ _        
 (_)_ _ (_) |_(_)__ _| (_)______ 
 | | ' \| |  _| / _` | | |_ / -_)
 |_|_||_|_|\__|_\__,_|_|_/__\___|
                                 
*/

    function initialize() {
      WatchFace.initialize();
      View.initialize();}
   
    function onLayout(dc) as Void {setLayout(Rez.Layouts.WatchFace(dc));}

    function onShow() as Void {} 
   
    function onUpdate(dc) as Void {
/*
               _      _    _        
 __ ____ _ _ _(_)__ _| |__| |___ ___
 \ V / _` | '_| / _` | '_ \ / -_|_-<
  \_/\__,_|_| |_\__,_|_.__/_\___/__/
                                    
*/
        

        var profile = UserProfile.getProfile();
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var mySettings = System.getDeviceSettings();
        var myStats = System.getSystemStats();
        var info = ActivityMonitor.getInfo();
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var timeStamp= new Time.Moment(Time.today().value());
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
    var monthArray = ["Month", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"] as Array<String>;
    var weekdayArray = ["Day", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"] as Array<String>;
    var chinesehoroscope = ["r", "q", "j", "s", "h", "K", "k", "m", "d", "o","p","L"] as Array<String>; 
    var heart = "";
    if (clockTime.sec%2 == 0){if (sensorIter != null) {
     heart =(sensorIter.next().data);
    }else { heart = "--";}}else {heart = "--";}


  
  var positions;
        if (Toybox.Weather.getCurrentConditions().observationLocationPosition == null){
        positions=new Position.Location( 
    {
        :latitude => 33.684566,
        :longitude => -117.826508,
        :format => :degrees
    }
    );
    }else{
      positions= Toybox.Weather.getCurrentConditions().observationLocationPosition;
    }
    
  

  var sunrise = Time.Gregorian.info(Toybox.Weather.getSunrise(positions, timeStamp), Time.FORMAT_MEDIUM);
        
	var sunriseHour;
  if (Toybox.Weather.getSunrise(positions, timeStamp) == null){sunriseHour = 6;}
    else {sunriseHour= sunrise.hour;}
         if (!System.getDeviceSettings().is24Hour) {
            if (sunriseHour > 12) {
                sunriseHour = (sunriseHour - 12).abs();
            }
        } else {
           
                timeFormat = "$1$:$2$";
                sunriseHour = sunriseHour.format("%02d");
        }
        
    var sunset;
    var sunsetHour;
    sunset = Time.Gregorian.info(Toybox.Weather.getSunset(positions, timeStamp), Time.FORMAT_MEDIUM);
    if (Toybox.Weather.getSunset(positions, timeStamp) == null){sunsetHour = 6;}
    else {sunsetHour= sunset.hour ;}
        
	
         if (!System.getDeviceSettings().is24Hour) {
            if (sunsetHour > 12) {
                sunsetHour = (sunsetHour - 12).abs();
            }
        } else {
            
                timeFormat = "$1$:$2$";
                sunsetHour = sunsetHour.format("%02d");
        }

    var AMPM = "";       
    if (!System.getDeviceSettings().is24Hour) {
        if (clockTime.hour > 12) {
                AMPM = "N";
            }else{
                AMPM = "M";
            }}

    
    var TempMetric = System.getDeviceSettings().temperatureUnits;
    var TEMP;
     if(Toybox.Weather.getCurrentConditions() != null){ TEMP= Toybox.Weather.getCurrentConditions().feelsLikeTemperature;}
     else {TEMP = 61;}
    var FC;
    var cond;
    if (Toybox.Weather.getCurrentConditions() != null){ cond = Toybox.Weather.getCurrentConditions().condition;}
    else{cond = 0;}

    if (TempMetric == System.UNIT_METRIC){  
    FC = "D";
    }else{
    TEMP = (((((TEMP)*9)/5)+32).toNumber()); 
    FC = "A";   
    }

        var timeText = View.findDrawableById("TimeLabel") as Text;
        var dateText = View.findDrawableById("DateLabel") as Text;
        var batteryText = View.findDrawableById("batteryLabel") as Text;
        var heartText = View.findDrawableById("heartLabel") as Text;
        var stepText = View.findDrawableById("stepsLabel") as Text;
        var calorieText = View.findDrawableById("caloriesLabel") as Text;
        var horoscopeText = View.findDrawableById("horoscopeLabel") as Text;
        var sunriseText = View.findDrawableById("sunriseLabel") as Text;
        var sunsetText = View.findDrawableById("sunsetLabel") as Text;
        var sunriseTextSU = View.findDrawableById("sunriseLabelSU") as Text;
        var sunsetTextSD = View.findDrawableById("sunsetLabelSD") as Text;
        var temperatureText = View.findDrawableById("tempLabel") as Text;
        var connectTextP = View.findDrawableById("connectLabelP") as Text;
        var connectTextB = View.findDrawableById("connectLabelB") as Text;
        var venus2YS;
        if (clockTime.sec%2==0){venus2YS=(mySettings.screenHeight *0.22)+2;}
        else{venus2YS=mySettings.screenHeight *0.22;} 
       var star = starPhase(info.steps,venus2YS);
       var mouth = mouthPhase(clockTime.min, clockTime.sec,venus2YS);
       var eyes = eyesPhase(clockTime.min,venus2YS); 
       var goal = goalPhase(info.steps,venus2YS); 
       var moonnumber = getMoonPhase(today.year, ((today.month)-1), today.day);  
       var moon1 = moonArrFun(moonnumber);

        sunriseText.setText(sunriseHour + ":" + sunrise.min.format("%02u")+"AM");
        sunsetText.setText(sunsetHour + ":" + sunset.min.format("%02u")+"PM");
        temperatureText.setText(weather(cond)+TEMP+FC);
        timeText.setText(timeString+AMPM );
        dateText.setText(weekdayArray[today.day_of_week]+" , "+ monthArray[today.month]+" "+ today.day +" " +today.year);
        batteryText.setText(Lang.format("$1$",[((myStats.battery)).format("%2d")]) + "%"+ " =  ");
        heartText.setText(heart+" +  ");
        stepText.setText(info.steps+" ^  ");
        calorieText.setText(info.calories+" ~  ");
        sunriseTextSU.setText("l");
        sunsetTextSD.setText("n");
        horoscopeText.setText(chinesehoroscope[((((today.year).toNumber())%12).toNumber())] + ""+ chinesehoroscope[((((profile.birthYear).toNumber())%12).toNumber())] + "" + getHoroscope((today.month-1), today.day));
        connectTextP.setText("  #  ");
        connectTextB.setText("  @  ");
          
    if (mySettings.phoneConnected == true){connectTextP.setColor(0x48FF35);}
    else{connectTextP.setColor(0xEF1EB8);}
    if (myStats.charging == true){connectTextB.setColor(0x48FF35);}
    else{connectTextB.setColor(0xEF1EB8);}
    
/*
  _    _ _                   
 | |__(_) |_ _ __  __ _ _ __ 
 | '_ \ |  _| '  \/ _` | '_ \
 |_.__/_|\__|_|_|_\__,_| .__/
                       |_|   
*/        
       
      
        View.onUpdate(dc);
        moon1.draw(dc);
        star.draw(dc);
        eyes.draw(dc);
        mouth.draw(dc);
        goal.draw(dc);


var centerX = (dc.getWidth()) / 2;
var centerY = (dc.getHeight()) / 2;

if (mySettings.screenShape == 1){
dc.setPenWidth(30);
dc.setColor(0x272727, Graphics.COLOR_TRANSPARENT);
dc.drawCircle(centerX, centerY, centerX);
dc.setColor(0x48FF35, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerY, centerX, Graphics.ARC_CLOCKWISE, 90, 47);
dc.setColor(0xFFFF35, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerY, centerX, Graphics.ARC_CLOCKWISE, 45, 2);
dc.setColor(0xEF1EB8, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerY, centerX, Graphics.ARC_CLOCKWISE, 0, 317);
dc.setColor(0x00F7EE, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerY, centerX, Graphics.ARC_CLOCKWISE, 315, 270);
dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
dc.drawArc(centerX, centerY, centerX, Graphics.ARC_CLOCKWISE, 268, 266 - (info.steps/56));
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
 /*
              _                 _      _       
  ___ _ _  __| |  _  _ _ __  __| |__ _| |_ ___ 
 / -_) ' \/ _` | | || | '_ \/ _` / _` |  _/ -_)
 \___|_||_\__,_|  \_,_| .__/\__,_\__,_|\__\___|
                      |_|                      
*/

 }

/*
  _  _              _     ___      _       
 | || |___ __ _ _ _| |_  | _ \__ _| |_ ___ 
 | __ / -_) _` | '_|  _| |   / _` |  _/ -_)
 |_||_\___\__,_|_|  \__| |_|_\__,_|\__\___|
                                           
*/
function getIterator() {
    // Check device for SensorHistory compatibility
    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getHeartRateHistory)) {
        return Toybox.SensorHistory.getHeartRateHistory({});
    }
    return null;
}
  
/*
  __  __                 ___ _                 
 |  \/  |___  ___ _ _   | _ \ |_  __ _ ___ ___ 
 | |\/| / _ \/ _ \ ' \  |  _/ ' \/ _` (_-</ -_)
 |_|  |_\___/\___/_||_| |_| |_||_\__,_/__/\___|
 
*/
function getMoonPhase(year, month, day) {

      var c=0;
      var e=0;
      var jd=0;
      var b=0;

      if (month < 3) {
        year--;
        month += 12;
      }

      ++month; 

      c = 365.25 * year;

      e = 30.6 * month;

      jd = c + e + day - 694039.09; 

      jd /= 29.5305882; 

      b = (jd).toNumber(); 

      jd -= b; 

      b = Math.round(jd * 8); 

      if (b >= 8) {
        b = 0; 
      }
     
      return (b).toNumber();
    }

     /*
     0 => New Moon
     1 => Waxing Crescent Moon
     2 => Quarter Moon
     3 => Waxing Gibbous Moon
     4 => Full Moon
     5 => Waning Gibbous Moon
     6 => Last Quarter Moon
     7 => Waning Crescent Moon
     */
function moonArrFun(moonnumber){
  var moonArray= [
          (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.newmoon,//0
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.waxcres,//1
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.firstquar,//2
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
                (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.waxgib,//3
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
                (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.full,//4
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
                (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.wangib,//5
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.thirdquar,//6
            :locX=> venus2XL,
            :locY=> venus2Y
        })),
           (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.wancres,//7
            :locX=> venus2XL,
            :locY=> venus2Y,
        })),
        ];
        return moonArray[moonnumber];
}

/*
  ____        _ _           __  __         _   _    
 |_  /___  __| (_)__ _ __  |  \/  |___ _ _| |_| |_  
  / // _ \/ _` | / _` / _| | |\/| / _ \ ' \  _| ' \ 
 /___\___/\__,_|_\__,_\__| |_|  |_\___/_||_\__|_||_|
                                                    
*/

function getHoroscope(month, day) {

     if (month == 0) {
        if (day > 0 && day < 19) {
          return "B";//"Cap";
        } else {
          return "v";//"Aqu";
        }
      } else if (month == 1) {
        if (day > 1 && day < 18) {
          return "B";//"Cap";
        } else {
          return "@";//"Pis";
        }
      } else if (month == 2) {
        if (day > 1 && day < 20) {
          return "@";//"Pis";
        } else {
          return "w";//"Ari";
        }
      } else if (month == 3) {
        if (day > 1 && day < 19) {
          return "w";//"Ari";
        } else {
          return "F";//"Tau";
        }
      } else if (month == 4) {
        return "F";//"Tau";
      } else if (month == 5) {
        if (day > 1 && day < 20) {
          return "x";//"Gem";
        } else {
          return "C";//"Can";
        }
      } else if (month == 6) {
        if (day > 1 && day < 22) {
          return "C";//"Can";
        } else {
          return "y";//"Leo";
        }
      } else if (month == 7) {
        if (day > 1 && day < 22) {
          return "y";//"Leo";
        } else {
          return "H";//"Vir";
        }
      } else if (month == 8) {
        if (day > 1 && day < 22) {
          return "H";//"Vir";
        } else {
          return "z";//"Lib";
        }
      } else if (month == 9) {
        if (day > 1 && day < 22) {
          return "z";//"Lib";
        } else {
          return "G";//"Sco";
        }
      } else if (month == 10) {
        if (day > 1 && day < 21) {
          return "G";//"Sco";
        } else {
          return "E";//"Sag";
        }
      } else if (month == 11) {
        if (day > 1 && day < 21) {
          return "E";//"Sag";
        } else {
          return "B";//"Cap";
        }
      } else {
        return "w";//"Ari";
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

/*
  _    _ _                   
 | |__(_) |_ _ __  __ _ _ __ 
 | '_ \ |  _| '  \/ _` | '_ \
 |_.__/_|\__|_|_|_\__,_| .__/
                       |_|   
*/      

 function starPhase(steps,venus2YS){
  if (steps > 1000) {
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.star,
            :locX=> venus2XR,
            :locY=> venus2YS
        });}
        else{
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.egg,
            :locX=> venus2XR,
            :locY=> venus2YS
        });}
 }
 function eyesPhase(minutes,venus2YS){
  if (minutes%2 == 0){
 return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.eyes,
            :locX=> venus2XR,
            :locY=> venus2YS
        });}
  else { return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.eyes1,
            :locX=> venus2XR,
            :locY=> venus2YS
        });}
        }


 function mouthPhase(minutes, seconds,venus2YS){         
    if (minutes%4 == 0){
      if (seconds%2==0){
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mouth1,
            :locX=> venus2XR,
            :locY=> venus2YS
        });
    }
    else {
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mouth3,
            :locX=> venus2XR,
            :locY=> venus2YS
        });
    }  }      
    if (minutes%4 == 1){
      if (seconds%2==0){
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mouth1,
            :locX=> venus2XR,
            :locY=> venus2YS
        });
    }
    else {
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mouth2,
            :locX=> venus2XR,
            :locY=> venus2YS
        });
    }  }
     if (minutes%4 == 2){
      if (seconds%2==0){
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mouth0,
            :locX=> venus2XR,
            :locY=> venus2YS
        });
    }
    else {
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mouth1,
            :locX=> venus2XR,
            :locY=> venus2YS
        });
    } }
        if (minutes%4 == 3){
      if (seconds%2==0){
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mouth2,
            :locX=> venus2XR,
            :locY=> venus2YS
        });
    }
    else {
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mouth1,
            :locX=> venus2XR,
            :locY=> venus2YS
        });
    }  }   
        else{
      if (seconds%2==0){
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mouth0,
            :locX=> venus2XR,
            :locY=> venus2YS
        });
    }
    else {
    return new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.mouth1,
            :locX=> venus2XR,
            :locY=> venus2YS
        });
    }}   
}

function goalPhase(steps,venus2YS){
    var goal = Math.round(steps/1000).toNumber();
    /*
    blank-egg - blank
    baby - 1000-2000 - 1
    elementary - 2000-3000 -2
    middle school 3000-4000 -3
    high school 4000-5000 -4
    graduate 5000-6000 -5
     */
     if (goal > 6) {goal=6;}
    var goalArray = [
     new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.blank,
            :locX=> venus2XR,
            :locY=> venus2YS
        }),
        new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.goal1,
            :locX=> venus2XR,
            :locY=> venus2YS
        }),
            new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.goal2,
            :locX=> venus2XR,
            :locY=> venus2YS
        }),
            new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.goal3,
            :locX=> venus2XR,
            :locY=> venus2YS
        }),
            new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.goal4,
            :locX=> venus2XR,
            :locY=> venus2YS
        }),
                new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.goal5,
            :locX=> venus2XR,
            :locY=> venus2YS
        }),
                        new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.blank,
            :locX=> venus2XR,
            :locY=> venus2YS
        }),
    ];
    return goalArray[goal];
        
        }
    

/*
   ___                _       __   __   _    _  
  / __|__ _ _ _ _ __ (_)_ _   \ \ / /__(_)__| | 
 | (_ / _` | '_| '  \| | ' \   \ V / _ \ / _` | 
  \___\__,_|_| |_|_|_|_|_||_|   \_/\___/_\__,_| 
                                                
*/

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }

}
/*
       Horoscope, Zodiac, and Weather Font:
        A FAR
        B capricorn
        C CELCIUS
        D Celcius
        E SAGIT
        F TAUR
        G SCORP
        H VIRGO
        I LIBRA
        J LEO
        K BULL
        L SHEEP
        M PM
        N AM
        0 :
        a rain
        b sun
        c rainsuncloud
        d dragon
        e cloud
        f whirl
        g wind
        h rat
        i snow
        j dog
        k tiger
        l sun up
        m rabbit
        n sun down
        o snake
        p horse
        q rooster
        r monkey
        s pig
        t male
        u female
        v aquarius
        w aries
        x gemini
        y leo
        z libra
        */

// questionmark=calorie *=heart [=battery ]=steps @=battery #=phone
// = is small battery ^ is small steps ~ is small calories + is small heart

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
using Toybox.Time.Gregorian;
using Toybox.System; 
using Toybox.UserProfile;
using Toybox.ActivityMonitor;
using Toybox.SensorHistory;
using Toybox.Position;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;

class VirtualPetDogView extends Ui.WatchFace {
var sensorIter = getIterator();
var moon1;
 var venus2X = LAYOUT_HALIGN_RIGHT;
    var venus2Y = LAYOUT_VALIGN_CENTER;
    var venus2XL = 20;
    var venus2XM = 35;
    var venumovey =  116;
    var venus2YR = 248;
    var venus2YS = 78;  
    function initialize() {
        WatchFace.initialize();
         View.initialize();
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
var fulldateString = Lang.format(
    "$1$ $2$",
    [
        today.month,
        today.day,
    ] 
);

var dayString = Lang.format(
    "$1$",
[
today.day_of_week
]);
// 0 => New Moon
  // 1 => Waxing Crescent Moon
  // 2 => Quarter Moon
  // 3 => Waxing Gibbous Moon
  // 4 => Full Moon
  // 5 => Waning Gibbous Moon
  // 6 => Last Quarter Moon
  // 7 => Waning Crescent Moon
  var moonnumber = getMoonPhase(2023, 3, 25);
  // var moonnumber = getMoonPhase(today.year, today.month, today.day);

  
  //Moon Bitmpas
  switch (moonnumber){
           case 0:  
            moon1 = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.newmoon,
            :locX=> venus2XL,
            :locY=> venus2Y
        });
        break;
            case 1:  
            moon1 = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.waxcres,
            :locX=> venus2XL,
            :locY=> venus2Y
        }); 
           case 2:  
            moon1 = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.firstquar,
            :locX=> venus2XL,
            :locY=> venus2Y
        });
        break;
           case 3:  
            moon1 = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.waxgib,
            :locX=> venus2XL,
            :locY=> venus2Y
        });
        break;
            case 4:  
            moon1 = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.full,
            :locX=> venus2XL,
            :locY=> venus2Y
        });
        break;
           case 5:  
            moon1 = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.wangib,
            :locX=> venus2XL,
            :locY=> venus2Y
        });
        break;
           case 6:  
            moon1 = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.thirdquar,
            :locX=> venus2XL,
            :locY=> venus2Y
        });
        break;
           case 7:  
            moon1 = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.wancres,
            :locX=> venus2XL,
            :locY=> venus2Y
        });
        break;
        default:  
            moon1 = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.full,
            :locX=> venus2XL,
            :locY=> venus2Y
        });}

    }
/*
  _                    _   
 | |__ _ _  _ ___ _  _| |_ 
 | / _` | || / _ \ || |  _|
 |_\__,_|\_, \___/\_,_|\__|
         |__/              
*/
    // Load your resources here
    function onLayout(dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        
       

    }

    function onShow() as Void {
    }
/*
                _      _             _            
  _  _ _ __  __| |__ _| |_ ___  __ _(_)_____ __ __
 | || | '_ \/ _` / _` |  _/ -_) \ V / / -_) V  V /
  \_,_| .__/\__,_\__,_|\__\___|  \_/|_\___|\_/\_/ 
      |_|                                         
   All Strings and Images are Drawn and Called here
*/    
   
    function onUpdate(dc) as Void {
/*
               _      _    _        
 __ ____ _ _ _(_)__ _| |__| |___ ___
 \ V / _` | '_| / _` | '_ \ / -_|_-<
  \_/\__,_|_| |_\__,_|_.__/_\___/__/
                                    
*/
        // Variables for Data-------------------------------------------
       var goal = 5000; 
       var profile = UserProfile.getProfile();
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min;
        var seconds = clockTime.sec;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
    var minString = clockTime.min.format("%02d");
    
    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var dateString = Lang.format(
    "$1$-$2$-$3$",
    [
        today.month,
        today.day,
        today.year
    ] 
    );
    var mySettings = System.getDeviceSettings();
    var myStats = System.getSystemStats();
    //var genderEntry;
    //if (profile.gender== 0){genderEntry= "u";}
    //else {genderEntry= "t";}
    var birthEntry =profile.birthYear;
    var phonestatus = mySettings.phoneConnected;
    var info = ActivityMonitor.getInfo();
    var batterycharging =  myStats.charging;
    var battery = Lang.format("$1$",[((myStats.battery)).format("%2d")]);
    var batterylife = Lang.format("$1$",[(myStats.batteryInDays).format("%2d")]);
    var steps = (info.steps);
    var calories = info.calories;
    var heart = "";
    if (seconds%2 == 0){if (sensorIter != null) {
     heart =(sensorIter.next().data);
    }else { heart = "--";}}else {heart = "--";}
 	
    var timeStamp= new Time.Moment(Time.today().value());
         
	var positions = Activity.Info.currentLocation;
        if (positions == null){
        positions=new Position.Location( 
    {
        :latitude => 33.684566,
        :longitude => -117.826508,
        :format => :degrees
    }
    );
    }
    var sunrise = Time.Gregorian.info(Toybox.Weather.getSunrise(positions, timeStamp), Time.FORMAT_MEDIUM);
        
	var sunriseHour = sunrise.hour;
         if (!System.getDeviceSettings().is24Hour) {
            if (sunrise.hour > 12) {
                sunriseHour = (hours - 12).abs();
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                sunriseHour = sunrise.hour.format("%02d");
            }
        }
        

    var sunset = Time.Gregorian.info(Toybox.Weather.getSunset(positions, timeStamp), Time.FORMAT_MEDIUM);
        
	var sunsetHour = sunset.hour;
         if (!System.getDeviceSettings().is24Hour) {
            if (sunset.hour > 12) {
                sunsetHour = (hours - 12).abs();
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                sunsetHour = sunset.hour.format("%02d");
            }
        }

    var AMPM = "";       
    if (!System.getDeviceSettings().is24Hour) {
        if (clockTime.hour > 12) {
                AMPM = "N";
            }else{
                AMPM = "M";
            }}

  /*
    if (phonestatus == true){connectTextP.setText.color = (Graphics.COLOR_GREEN);}
    else{}
    if (batterycharging == true){}
    else{}
    */
    
    var TempMetric = System.getDeviceSettings().temperatureUnits;

    var TEMP = Toybox.Weather.getCurrentConditions().feelsLikeTemperature;
    var FC = "C";
    var cond = Toybox.Weather.getCurrentConditions().condition;

    if (TempMetric == System.UNIT_METRIC){
    TEMP = Toybox.Weather.getCurrentConditions().feelsLikeTemperature;
    FC = "C";
    }else{
    TEMP = ((((((Toybox.Weather.getCurrentConditions().feelsLikeTemperature).toDouble())*9)/5)+32).toNumber()); 
    FC = "A";   
    }
    var horoscopeYear = getChineseYear(today.year);
    var horoscopeBirth =getChineseYear(birthEntry);
    var monthZodiac = getHoroscope(today.month, today.day);
        
    // Variables of text From Layout-------------------------------------------
        var timeText = View.findDrawableById("TimeLabel") as Text;
        var AMPMText = View.findDrawableById("AMLabel") as Text;
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
        var weatherText = View.findDrawableById("weatherLabel") as Text;
    // Variables for Data END-------------------------------------------
/*
          _     _           _   
  ___ ___| |_  | |_ _____ _| |_ 
 (_-</ -_)  _| |  _/ -_) \ /  _|
 /__/\___|\__|  \__\___/_\_\\__|
                                
Set Text Values from Data Variables 
*/
//---------------------------TEXT---------------------------------------------

        sunriseText.setText(sunriseHour + ":" + sunrise.min.format("%02u")+"AM");
        sunsetText.setText(sunsetHour + ":" + sunset.min.format("%02u")+"PM");
        temperatureText.setText(TEMP+FC);
        timeText.setText(hours + ":" + minString );
        AMPMText.setText(AMPM);
        dateText.setText(dateString);
        batteryText.setText(battery + "%"+"{");
        heartText.setText(heart+"^");
        stepText.setText(steps+"~");
        calorieText.setText(calories+"_");
        sunriseTextSU.setText("l");
        sunsetTextSD.setText("n");
        weatherText.setText(weather(cond));
        horoscopeText.setText(horoscopeYear + ""+ horoscopeBirth + "" + monthZodiac);
        connectTextP.setText("]");
        connectTextB.setText("{");
       //---------------------------TEXT--------------------------------------------- 
      
        View.onUpdate(dc);
        moon1.draw(dc);
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
     _    _                    _                                     
  __| |_ (_)_ _  ___ ___ ___  | |_  ___ _ _ ___ ___ __ ___ _ __  ___ 
 / _| ' \| | ' \/ -_|_-</ -_) | ' \/ _ \ '_/ _ (_-</ _/ _ \ '_ \/ -_)
 \__|_||_|_|_||_\___/__/\___| |_||_\___/_| \___/__/\__\___/ .__/\___|
                                                          |_|        
  */  

//Takes in Year % 12 and Gives A Rough Chinese Horoscope
//Not Totally Accurate if Month falls in January or February


function getChineseYear(year){
    var value = ((((year).toNumber())%12).toNumber());
        switch(value){
            case 0:
                return "r";//"mon";
                  //break;
            case 1:
                return "q";//"roo";
                //break;  
            case 2:
                return "j";//"dog";
                //break;  
            case 3:
                return "s";//"pig";
                //break;  
            case 4:
                return "h";//"rat";
                //break;  
            case 5:
                return "K";//"ox";
                //break;  
            case 6:
                return "k";//"tig";
                //break;            
            case 7:
                return "m";//"rab";
                //break;
            case 8:
                return "d";//"dra";
                //break;
            case 9:
                return "o";//"sna";
                //break;
            case 10:
                return "p";//"hor";
                //break;
            case 11:
                return "L";//"goa";
                //break;                         
            default:
            return "d";
            }
    }
/*
  __  __                 ___ _                 
 |  \/  |___  ___ _ _   | _ \ |_  __ _ ___ ___ 
 | |\/| / _ \/ _ \ ' \  |  _/ ' \/ _` (_-</ -_)
 |_|  |_\___/\___/_||_| |_| |_||_\__,_/__/\___|
 This is based on a Farmers Almanac -
 Which Moonphases are 3 Days Each instead of Modern 1 Day
 
*/
function getMoonPhase(year, month, day) {

      var c = 0;
      var e = 0;
      var jd = 0;
      var b = 0;

      if (month < 3) {
        year--;
        month += 12;
      }

      ++month;

      c = 365.25 * year;

      e = 30.6 * month;

      jd = c + e + day - 694039.09; //jd is total days elapsed

      jd /= 29.5305882; //divide by the moon cycle

      b = (jd).toNumber(); //int(jd) -> b, take integer part of jd

      jd -= b; //subtract integer part to leave fractional part of original jd

      b = Math.round(jd * 8); //scale fraction from 0-8 and round

      if (b >= 8) {
        b = 0; //0 and 8 are the same so turn 8 into 0
      }
     //Return a Monkey C Number
      return (b).toNumber();
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
        //cond is condition number
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
   ___                _       __   __   _    _  
  / __|__ _ _ _ _ __ (_)_ _   \ \ / /__(_)__| | 
 | (_ / _` | '_| '  \| | ' \   \ V / _ \ / _` | 
  \___\__,_|_| |_|_|_|_|_||_|   \_/\___/_\__,_| 
                                                
*/
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
/*
       Horoscope, Zodiac, and Weather Font:
        A FAR
        B capricorn
        C CELCIUS
        D C
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
//DinFont Symbols {=battery _or[=calorie ]=phone ^=heart steps=< add space too change :

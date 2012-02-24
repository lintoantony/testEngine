﻿/*@author Linto (linto.k.a@teamaol.com)*/package com.linto.utils{    import flash.display.Sprite;    import flash.events.Event;    import flash.events.TimerEvent;    import flash.text.TextField;    import flash.utils.Timer;    import flash.utils.getTimer;        import org.osmf.events.TimeEvent;
    public class TimerUtil extends Sprite {				private var interval:Number = 1000; // 1 second		public static const ON_TIME_ENDS:String = "onTimeEnds";				private var timeTimer:Timer;		private var startTime:Number;		private var elapsedTime:Number;				private var outputTxt:TextField;				private var remaining:Number;		private var totalAvailableTime:Number = 0;        public function TimerUtil() {			this.initTimer();        }				public function setEndTime(timeInMin:Number):void{			this.totalAvailableTime = timeInMin*60*60*1000;			trace("((((((((((((((((((((((( this.totalAvailableTime = "+this.totalAvailableTime+ " : timeInMin = "+timeInMin);		}				private function initTimer():void{			this.timeTimer = new Timer(interval);			this.timeTimer.addEventListener(TimerEvent.TIMER, onTimeTimer);		}				public function startTimer(outputTxt:TextField):void{			this.outputTxt = outputTxt;			this.startTime = getTimer();			this.timeTimer.start();		}		public function stopTimer():void{			this.timeTimer.stop();		}				private function onTimeTimer(evt:TimerEvent):void{			this.elapsedTime = getTimer() - this.startTime;									if(this.totalAvailableTime != 0){				if(this.elapsedTime >= this.totalAvailableTime){					this.dispatchEvent(new Event(TimerUtil.ON_TIME_ENDS));				}			}			var output:String = timeToString(this.elapsedTime);						/*			if(this.totalAvailableTime != 0){				var output1:String = timeToString(this.totalAvailableTime);				trace(" this.elapsedTime = "+output+ " this.totalAvailableTime = "+output1);			}			*/			//trace("output = "+output);			this.outputTxt.text = output;		}				private function timeToString(timeToConvert:Number):String{						var hours:String;			var minutes:String;			var seconds:String;			var hundredths:String;						var elapsed_hours:Number;			var elapsed_minutes:Number;			var elapsed_seconds:Number;			var elapsed_fs:Number;						elapsed_hours = Math.floor(timeToConvert/3600000);			remaining = timeToConvert-(elapsed_hours*3600000);			elapsed_minutes = Math.floor(remaining/60000);			remaining = remaining-(elapsed_minutes*60000);			elapsed_seconds = Math.floor(remaining/1000);			remaining = remaining-(elapsed_seconds*1000);			elapsed_fs = Math.floor(remaining/10);			if (elapsed_hours<10) {				hours = "0"+elapsed_hours.toString();			} else {				hours = elapsed_hours.toString();			}			if (elapsed_minutes<10) {				minutes = "0"+elapsed_minutes.toString();			} else {				minutes = elapsed_minutes.toString();			}			if (elapsed_seconds<10) {				seconds = "0"+elapsed_seconds.toString();			} else {				seconds = elapsed_seconds.toString();			}			if (elapsed_fs<10) {				hundredths = "0"+elapsed_fs.toString();			} else {				hundredths = elapsed_fs.toString();			}						if((hours as Number) > 0){				return hours+":"+minutes+":"+seconds;			}else{				return minutes+":"+seconds;			}						//return hours+":"+minutes+":"+seconds+":"+hundredths;		}		    }}
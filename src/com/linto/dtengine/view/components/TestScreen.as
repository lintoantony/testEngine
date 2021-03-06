﻿/*
@author Linto K Antony <lintoka123@gmail.com>
*/
package com.linto.dtengine.view.components{
	import com.linto.dtengine.model.ConfigProxy;
	import com.linto.dtengine.model.DataProxy;
	import com.linto.events.CustEvent;
	import com.linto.utils.ServerComm;
	import com.linto.utils.SoundEffects;
	import com.linto.utils.TimerUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.SoundMixer;
	import flash.net.*;
	import flash.text.TextFormat;
	import flash.utils.*;
	
	import org.osmf.elements.AudioElement;
	import org.osmf.elements.ImageElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.URLResource;
	import org.osmf.utils.URL;
	
	public class TestScreen extends Sprite {
		
		public var playerSprite:MediaPlayerSprite;
		
		private static const MAX_OPTIONS:int = 5;
		
		public static const ON_PREV_PRESS:String = "onPrevPress";
		public static const ON_NEXT_PRESS:String = "onNextPress";
		public static const ON_FINISH_PRESS:String = "onFinishPress";

		public var id:String;
		private var dataXml:XML;
		private var screenHolder:MovieClip;
		private var dataProxyRef:DataProxy;
		private var configProxyRef:ConfigProxy;
		private var optionArr:Array = ["A", "B", "C", "D", "E"];
		
		private var timerUtil:TimerUtil;
		
		private var sfx:SoundEffects;
		private var totalAvailableTime:Number;
		
		private var qFontSize:Number = 16;;
		private var aFontSize:Number = 14;
		private var fontChangeCount:Number = 0;
		
		private var isClickedBut:String = "";
		
		private var scrollPaneInterval:uint;
		
		private var reviewBar:MovieClip;
		
		public function TestScreen( id:String, params:Array=null ) {
			this.id = id;
			this.timerUtil = new TimerUtil();
		}
		
		private function onTimeEnds(evt:Event):void{
			this.timerUtil.stopTimer();
			this.onFinish();
		}
		
		public function setProxyRef(dataProxyRef:DataProxy, configProxyRef:ConfigProxy):void{
			this.dataProxyRef = dataProxyRef;
			this.configProxyRef = configProxyRef;
		}
		
		public function initialize(dataXml:XML):void{

			this.screenHolder = new MovieClip();
			this.screenHolder.name = "screenHolder";
			this.screenHolder.x = 0;
			this.screenHolder.y = 80;
			this.addChild(this.screenHolder);
			
			if(this.sfx == null){
				this.sfx = SoundEffects.getInstance(this.screenHolder);
				this.sfx.initMuteButton(this.screenHolder);
				this.sfx.setMuteButPos(670, -60);
			}
			
			this.dataXml = dataXml;
			this.attachElements();
			
			
			if(this.configProxyRef.testTypeModeIndx == 1){
				this.calculateAvailableTime();
			}else{
				this.timerUtil.setEndTime(0);
				this.timerUtil.removeEventListener(TimerUtil.ON_TIME_ENDS, onTimeEnds);
			}
		}
		
		private function calculateAvailableTime():void{
			this.totalAvailableTime = this.configProxyRef.timePerQuestion * this.configProxyRef.userSelectedQCount;
			
			this.timerUtil.setEndTime(this.totalAvailableTime);
			this.timerUtil.addEventListener(TimerUtil.ON_TIME_ENDS, onTimeEnds, false, 0, true);
		}
		
		private function attachElements():void{
			// Progress Bar
			/*
			var progressBar:ProgressBar = new ProgressBar();
			progressBar.name = "progressBar";
			progressBar.x = 38;
			progressBar.y = 2;
			this.screenHolder.addChild(progressBar);
			*/
			
			// Font increase decrese buttons
			var fontButHolder:MovieClip = new MovieClip();
			fontButHolder.name = "fontButHolder";
			fontButHolder.x = 55;
			fontButHolder.y = 0;
			this.screenHolder.addChild(fontButHolder);
			
			var fontIncreaseBut:FontBut = new FontBut();
			fontIncreaseBut.name = "fontIncreaseBut";
			fontIncreaseBut.label.mouseEnabled = false;
			fontIncreaseBut.label.text = "A+";
			fontButHolder.addChild(fontIncreaseBut);
			fontIncreaseBut.buttonMode = true;
			fontIncreaseBut.addEventListener(MouseEvent.CLICK, onFontButClick, false, 0, true);
			
			var fontDecreaseBut:FontBut = new FontBut();
			fontDecreaseBut.name = "fontDecreaseBut";
			fontDecreaseBut.label.mouseEnabled = false;
			fontDecreaseBut.label.text = "A-";
			fontDecreaseBut.x = fontIncreaseBut.x + fontIncreaseBut.width;
			fontButHolder.addChild(fontDecreaseBut);
			fontDecreaseBut.buttonMode = true;
			fontDecreaseBut.addEventListener(MouseEvent.CLICK, onFontButClick, false, 0, true);
			
			
			// Question Text
			var questionHolder:QuestionHolder = new QuestionHolder();
			questionHolder.name = "questionHolder";
			questionHolder.x = -10;
			questionHolder.y = 30;
			this.screenHolder.addChild(questionHolder);
			
				
			// Instruction
			var instrTxt:InstrTxt = new InstrTxt();
			instrTxt.name = "instrTxt";
			instrTxt.x = 50;
			instrTxt.y = questionHolder.y + questionHolder.height + 55;
			instrTxt.label.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="select")[0].text();
			this.screenHolder.addChild(instrTxt);
			
			// Options
			//this.attachOptions(this.dataProxyRef.currentQuestionIndex);
			
			// Buttons
			var navButs:NavButs = new NavButs();
			navButs.name = "navButs";
			navButs.x = instrTxt.x + 100;
			navButs.y = 400;
			this.screenHolder.addChild(navButs);
			
			navButs.prevBut.label.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="prev")[0].text();
			navButs.prevBut.label.mouseEnabled = false;
			navButs.prevBut.buttonMode = true;
			navButs.prevBut.addEventListener(MouseEvent.CLICK, onButClick, false, 0, true);
			navButs.prevBut.addEventListener(MouseEvent.MOUSE_OVER, onButOver, false, 0, true);
			navButs.prevBut.addEventListener(MouseEvent.MOUSE_OUT, onButOut, false, 0, true);
			
			navButs.nextBut.label.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="next")[0].text();
			navButs.nextBut.label.mouseEnabled = false;
			navButs.nextBut.buttonMode = true;
			navButs.nextBut.addEventListener(MouseEvent.CLICK, onButClick, false, 0, true);
			navButs.nextBut.addEventListener(MouseEvent.MOUSE_OVER, onButOver, false, 0, true);
			navButs.nextBut.addEventListener(MouseEvent.MOUSE_OUT, onButOut, false, 0, true);
			
			
			if(this.configProxyRef.testTypeModeIndx == 1){
				navButs.finishBut.label.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="finish")[0].text();
			}else{
				navButs.finishBut.label.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="summaryBut")[0].text();
			}
			navButs.finishBut.label.mouseEnabled = false;
			navButs.finishBut.buttonMode = true;
			navButs.finishBut.addEventListener(MouseEvent.CLICK, onButClick, false, 0, true);
			navButs.finishBut.addEventListener(MouseEvent.MOUSE_OVER, onButOver, false, 0, true);
			navButs.finishBut.addEventListener(MouseEvent.MOUSE_OUT, onButOut, false, 0, true);
			
			
			// Audio Button
			
			// Timer
			var timerTxt:TimerTxt = new TimerTxt();
			timerTxt.name = "timerTxt";
			timerTxt.x = 775;
			timerTxt.y = -65;
			timerTxt.label.text = "";
			this.screenHolder.addChild(timerTxt);
			this.timerUtil.startTimer(timerTxt.label);
			
			// Image
			/*
			var imageBox:ImageBox = new ImageBox();
			imageBox.name = "imageBox";
			imageBox.x = 650;
			imageBox.y = 125;
			this.screenHolder.addChild(imageBox);
			*/
			
			var supportMediaButton:SupportMediaButton = new SupportMediaButton();
			supportMediaButton.name = "supportMediaButton";
			supportMediaButton.x = 760;
			supportMediaButton.y = 66;
			this.screenHolder.addChild(supportMediaButton);

			// Question Status
			var qProgress:QProgress = new QProgress();
			qProgress.name = "qProgress";
			qProgress.x = supportMediaButton.x;
			qProgress.y = supportMediaButton.y + supportMediaButton.height + 100;
			this.screenHolder.addChild(qProgress);
			qProgress.nomTxt.text = "0";
			//qProgress.denomTxt.text = this.dataXml.item.length();
			qProgress.denomTxt.text = String(this.configProxyRef.userSelectedQCount);
			qProgress.visible = true;
			// If it is Practice mode.
			if(configProxyRef.testTypeModeIndx == 1){
				qProgress.visible = false;
			}
			
			// Explanation Txt
			/*
			var explanationTxt:ExplanationTxt = new ExplanationTxt();
			explanationTxt.name = "explanationTxt";
			explanationTxt.x = 150;
			this.screenHolder.addChild(explanationTxt);
			*/
			
			// Remarks button
			var remarksBut:RemarksBut = new RemarksBut();
			remarksBut.name = "remarksBut";
			remarksBut.x = 150;
			this.screenHolder.addChild(remarksBut);
			remarksBut.visible = false;
			
			// Report Bug
			var reportBugMc:ReportBugMc = new ReportBugMc();
			reportBugMc.name = "reportBugMc";
			reportBugMc.x = 820;
			reportBugMc.y = 480;
			reportBugMc.label.mouseEnabled = false;
			reportBugMc.label.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="bug")[0].text();
			this.screenHolder.addChild(reportBugMc);
			reportBugMc.buttonMode = true;
			reportBugMc.addEventListener(MouseEvent.CLICK, onBugReport);
			
			var supportMediaHolder:SupportMediaHolder = new SupportMediaHolder();
			supportMediaHolder.name = "supportMediaHolder";
			supportMediaHolder.x = 10;
			supportMediaHolder.y = 0;
			supportMediaHolder.visible = false;
			supportMediaHolder.closeButton.addEventListener(MouseEvent.CLICK, hideSupportMedia);
			this.screenHolder.addChild(supportMediaHolder);
			
			this.createReviewBar();
			
			this.renderQuestion();

			this.populateReviewBar(this.dataProxyRef.reviewPageIndex);
		}
		
		public function attachAndPlayMedia(mediaType:String, mediaUrl:String):MediaPlayerSprite{
			
			//sprite that contains a MediaPlayer to manage display and control of MediaElements
			playerSprite = new MediaPlayerSprite();
			
			//creates and sets the MediaElement with a resource and path
			var resource:URLResource = new URLResource( mediaUrl );
			
			var mediaElement:MediaElement;
			switch(mediaType){
				case "video":
					mediaElement = new VideoElement( resource );
					break;
				case "audio":
					mediaElement = new AudioElement( resource );
					break;
				case "image":
					mediaElement = new ImageElement( resource );
					break;
			}
			
			playerSprite.media = mediaElement;
			
			return playerSprite;
		}
		
		private function onFontButClick(evt:MouseEvent):void{
			
			switch(evt.currentTarget.name){
				case "fontIncreaseBut":
					this.aFontSize++;
					this.qFontSize++;
					this.fontChangeCount++;
					break;
				case "fontDecreaseBut":
					this.aFontSize--;
					this.qFontSize--;
					this.fontChangeCount--;
					break;
			}
			var questionHolder:MovieClip = this.screenHolder.getChildByName("questionHolder") as MovieClip;
			var qTxtFrmt:TextFormat = questionHolder.qTxt.getTextFormat();
			qTxtFrmt.size = this.qFontSize;
			questionHolder.qTxt.setTextFormat(qTxtFrmt);
			
			questionHolder.qTxt.y = 56/2 - questionHolder.qTxt.height/2 + 40;
			
			var aTxtFrmt:TextFormat;
			var numOfOptions:int = this.dataXml.item[this.dataProxyRef.currentQuestionIndex].choises.opt.length();
			if(numOfOptions > MAX_OPTIONS){
				numOfOptions = MAX_OPTIONS;
			}
			var thisOpt:MovieClip;
			var optionsHolder:MovieClip;
			for(var i:int=0;i<numOfOptions;i++){
				optionsHolder = this.screenHolder.getChildByName("optionsHolder") as MovieClip;
				thisOpt = optionsHolder.getChildByName("opt_"+i) as MovieClip;
				aTxtFrmt = thisOpt.answerTxt.getTextFormat();
				aTxtFrmt.size = this.aFontSize;
				thisOpt.answerTxt.setTextFormat(aTxtFrmt);
				
				thisOpt.answerTxt.y = 56/2 - thisOpt.answerTxt.height/2;
				
			}
			
			if(this.fontChangeCount >= 3){
				this.fontChangeCount = 3;
				this.enableFontBut("increase", false);
			}else {
				this.enableFontBut("increase", true);
			}
			
			if(this.fontChangeCount <= -3){
				this.fontChangeCount = -3;
				this.enableFontBut("decrease", false);
			}else{
				this.enableFontBut("decrease", true);
			}

		}
		
		private function enableFontBut(button:String, isEnabled:Boolean):void{
			var fontButHolder:MovieClip = this.screenHolder.getChildByName("fontButHolder") as MovieClip;
			var fontBut:FontBut;
			switch(button){
				case "increase":
					fontBut = fontButHolder.getChildByName("fontIncreaseBut") as FontBut;
					break;
				case "decrease":
					fontBut = fontButHolder.getChildByName("fontDecreaseBut") as FontBut;
					break;
			}
			switch(isEnabled){
				case true:
					fontBut.buttonMode = true;
					fontBut.alpha = 1;
					fontBut.addEventListener(MouseEvent.CLICK, onFontButClick, false, 0, true);
					break;
				case false:
					fontBut.buttonMode = false;
					fontBut.alpha = 0.3;
					fontBut.removeEventListener(MouseEvent.CLICK, onFontButClick);
					break;
			}
		}
		
		private function onBugReport(evt:MouseEvent):void{
			var variables:URLVariables = new URLVariables(); 
			//variables.configStr = configStr;
			variables.operation = "SEND_BUG_REPORT";
			
			//params = "?sub="+args.sub+"&lan="+args.lan+"&noq="+args.noq+"&typ="+args.typ;
			var paramObj:Object = new Object();
			paramObj.qno = this.dataProxyRef.currentQuestionId;
			trace("TestScreen.onBugReport : paramObj.qno = "+paramObj.qno);

			var apiUrl:String = ConfigProxy.getApi("BUG", paramObj);
			trace("TestScreen.onBugReport : apiUrl = "+apiUrl);
			
			this.openPage(apiUrl);
		}
		
		private function openPage(url:String):void{
			var request:URLRequest = new URLRequest(url);
			try {
				navigateToURL(request, '_blank'); // second argument is target
			} catch (e:Error) {
				trace("Error occurred!");
			}
		}
		
		private function renderQuestion():void{
			
			this.dataProxyRef.currentQuestionId = this.dataXml.item[this.dataProxyRef.currentQuestionIndex].qno;
			trace("this.dataProxyRef.currentQuestionId = "+this.dataProxyRef.currentQuestionId);
			
			var questionHolder:MovieClip = this.screenHolder.getChildByName("questionHolder") as MovieClip;
			questionHolder.qTxt.autoSize = "left";
			questionHolder.qTxt.text = this.dataXml.item[this.dataProxyRef.currentQuestionIndex].question.text();
			
			var txtFrmt:TextFormat = questionHolder.qTxt.getTextFormat();
			txtFrmt.size = this.qFontSize;
			questionHolder.qTxt.setTextFormat(txtFrmt);
			
			questionHolder.qTxt.y = 56/2 - questionHolder.qTxt.height/2 + 40;
			
			questionHolder.qNumTxt.text = this.dataProxyRef.currentQuestionIndex + 1;
			
			this.clearPreviousQuestion();
			this.attachOptions(this.dataProxyRef.currentQuestionIndex);
			
			// Adjust button y positions based on number of options
			var navButs:NavButs = this.screenHolder.getChildByName("navButs") as NavButs;
			var optionsHolder:MovieClip = this.screenHolder.getChildByName("optionsHolder") as MovieClip;
			//navButs.y = optionsHolder.y + optionsHolder.height + 15;
			navButs.y = 485;
			
			var fontButHolder:MovieClip = this.screenHolder.getChildByName("fontButHolder") as MovieClip;
			fontButHolder.y = navButs.y;
			
			/*
			var imageBox:ImageBox = this.screenHolder.getChildByName("imageBox") as ImageBox;
			imageBox.unloadThumbnail();
			imageBox.loadThumbnail(this.dataXml.item[this.dataProxyRef.currentQuestionIndex].img);
			imageBox.addEventListener(MouseEvent.MOUSE_OVER, onImageOver);
			imageBox.addEventListener(MouseEvent.MOUSE_OUT, onImageOut);
			*/
			
			// TO DO : Here comes the button for support media
			var supportMediaButton:SupportMediaButton = this.screenHolder.getChildByName("supportMediaButton") as SupportMediaButton;
			supportMediaButton.buttonMode = true;
			supportMediaButton.supportType = this.dataXml.item[this.dataProxyRef.currentQuestionIndex].supportMedia.@type;
			supportMediaButton.content = this.dataXml.item[this.dataProxyRef.currentQuestionIndex].supportMedia.text();
			supportMediaButton.gotoAndStop(supportMediaButton.supportType);
			supportMediaButton.addEventListener(MouseEvent.CLICK, onSupportMediaClick);
			
			/*
			var progressBar:ProgressBar = this.screenHolder.getChildByName("progressBar") as ProgressBar; 
			var per:Number = (this.dataProxyRef.currentQuestionIndex+1)/this.configProxyRef.userSelectedQCount;
			progressBar.progressMaskMc.scaleX = per;	
			progressBar.perTxt.text = Math.round(per*100)+"%";
			*/
			
			this.updateNavButtonStates();
			
			/*
			var explanationTxt:ExplanationTxt = this.screenHolder.getChildByName("explanationTxt") as ExplanationTxt;
			explanationTxt.y = navButs.y + navButs.height + 5;
			*/
			var remarksBut:RemarksBut = this.screenHolder.getChildByName("remarksBut") as RemarksBut;
			remarksBut.y = navButs.y;
			remarksBut.buttonMode = true;
			remarksBut.supportType = this.dataXml.item[this.dataProxyRef.currentQuestionIndex].remarks.@type;
			remarksBut.content = this.dataXml.item[this.dataProxyRef.currentQuestionIndex].remarks.text();
			remarksBut.addEventListener(MouseEvent.CLICK, onSupportMediaClick);


		}
		
		private function attachSupportMediaPane():void{
			// Scroll Pane
			
			// Video Player
			
			// Audio player
			
			// Image Loader
			
			// Text Holder
		}
		
		private function showSuppportMedia(type:String, url:String):void{
			// Make scrollPane visible
			var supportMediaHolder:SupportMediaHolder = this.screenHolder.getChildByName("supportMediaHolder") as SupportMediaHolder;
			
			if(supportMediaHolder.visible){
				return;
			}
			
			if(type == "text"){
				trace("Display text content");
				supportMediaHolder.contentPane.source = new TextContent();
			}else{
				//supportMediaHolder.contentPane.addEventListener(Event.COMPLETE, completeHandler);
				supportMediaHolder.contentPane.source = this.attachAndPlayMedia(type, url);
				supportMediaHolder.contentPane.enabled = true;
				supportMediaHolder.contentPane.verticalScrollPolicy = "auto";
			}
			
			var optionsHolder:MovieClip = this.screenHolder.getChildByName("optionsHolder") as MovieClip;
			
			var childIndex1:Number = this.screenHolder.getChildIndex(optionsHolder);
			var childIndex2:Number = this.screenHolder.getChildIndex(supportMediaHolder);
			if(childIndex1 > childIndex2){
				this.screenHolder.swapChildren(optionsHolder, supportMediaHolder);
			}
			
			supportMediaHolder.visible = true;
		}
		
		private function onScrollPaneLoaded():void {
			clearInterval(scrollPaneInterval);
			var supportMediaHolder:SupportMediaHolder = this.screenHolder.getChildByName("supportMediaHolder") as SupportMediaHolder;
			supportMediaHolder.contentPane.update();
			supportMediaHolder.contentPane.invalidate();
			supportMediaHolder.contentPane.refreshPane();
		}
		
		private function hideSupportMedia(evt:MouseEvent):void{
			// Hide all media holders
			
			// Make scrollPane invisible
			var supportMediaHolder:SupportMediaHolder = this.screenHolder.getChildByName("supportMediaHolder") as SupportMediaHolder;
			supportMediaHolder.contentPane.source = null;
			SoundMixer.stopAll();
			
			supportMediaHolder.visible = false;
		}
		
		private function onImageOver(evt:MouseEvent):void{
			var imageBox:ImageBox = this.screenHolder.getChildByName("imageBox") as ImageBox;
			imageBox.scaleX = 1.5;
			imageBox.scaleY = imageBox.scaleX;
		}
		private function onImageOut(evt:MouseEvent):void{
			var imageBox:ImageBox = this.screenHolder.getChildByName("imageBox") as ImageBox;
			imageBox.scaleX = imageBox.scaleY = 1;
		}
		
		private function onSupportMediaClick(evt:MouseEvent):void{
			this.showSuppportMedia(evt.currentTarget.supportType, evt.currentTarget.content);
		}
		
		private function clearPreviousQuestion():void{
			/*
			var explanationTxt:ExplanationTxt = this.screenHolder.getChildByName("explanationTxt") as ExplanationTxt;
			explanationTxt.label.text = "";
			*/
			var remarksBut:RemarksBut = this.screenHolder.getChildByName("remarksBut") as RemarksBut;
			remarksBut.visible = false;
			var optionsHolder:MovieClip = this.screenHolder.getChildByName("optionsHolder") as MovieClip;
			if(optionsHolder != null){
				this.screenHolder.removeChild(optionsHolder);
			}
		}
		
		private function onButClick(evt:MouseEvent):void{
			switch(evt.currentTarget.name){
				case "prevBut":
					this.dataProxyRef.currentQuestionIndex--;
					this.renderQuestion();
					break;
				case "nextBut":
					this.dataProxyRef.currentQuestionIndex++;
					this.renderQuestion();
					break;
				case "finishBut":
					this.dataProxyRef.timeTaken = this.timerUtil.getTimeTaken();
					this.timerUtil.stopTimer();
					this.onFinish();
					break;
			}
		}
		private function onButOver(evt:MouseEvent):void{
			
		}
		private function onButOut(evt:MouseEvent):void{
			
		}
		private function updateNavButtonStates():void{
			var navButs:MovieClip = this.screenHolder.getChildByName("navButs") as MovieClip;
			var xPos1:Number = 0;
			var xPos2:Number = 290;
			var xPos3:Number = 430;
				
			if(this.dataProxyRef.currentQuestionIndex == 0){
				butStates(false, true, false);
				navButs.nextBut.x = xPos3;
			}else if(this.dataProxyRef.currentQuestionIndex == (this.configProxyRef.userSelectedQCount-1)){
				butStates(true, false, true);
				navButs.prevBut.x = xPos2;
				navButs.finishBut.x = xPos3;
			}else{
				butStates(true, true, false);
				navButs.prevBut.x = xPos2;
				navButs.nextBut.x = xPos3;
			}
			
			function butStates(prevBut:Boolean, nextBut:Boolean, finishBut:Boolean):void{
				navButs.prevBut.visible = navButs.prevBut.mouseEnabled = prevBut;
				navButs.nextBut.visible = navButs.nextBut.mouseEnabled = nextBut;
				navButs.finishBut.visible = navButs.finishBut.mouseEnabled = finishBut;
				
				// If it is Practice mode.
				if(configProxyRef.testTypeModeIndx == 0){
					if(nextBut == true){
						navButs.nextBut.gotoAndStop(2);
						navButs.nextBut.label.alpha = 0.2;
						navButs.nextBut.buttonMode = false;
						navButs.nextBut.label.mouseEnabled = false;
						navButs.nextBut.removeEventListener(MouseEvent.CLICK, onButClick);
						navButs.nextBut.removeEventListener(MouseEvent.MOUSE_OVER, onButOver);
						navButs.nextBut.removeEventListener(MouseEvent.MOUSE_OUT, onButOut);
					}
					if(finishBut == true){
						navButs.finishBut.gotoAndStop(2);
						navButs.finishBut.label.alpha = 0.2;
						navButs.finishBut.buttonMode = false;
						navButs.finishBut.label.mouseEnabled = false;
						navButs.finishBut.removeEventListener(MouseEvent.CLICK, onButClick);
						navButs.finishBut.removeEventListener(MouseEvent.MOUSE_OVER, onButOver);
						navButs.finishBut.removeEventListener(MouseEvent.MOUSE_OUT, onButOut);
					}
				}

				if(configProxyRef.testTypeModeIndx == 0){
					navButs.prevBut.visible = navButs.prevBut.mouseEnabled = false;
				}
			}
		}
		
		private function attachOptions(questionIndex:int):void{
			var optionsHolder:MovieClip = new MovieClip();
			optionsHolder.name = "optionsHolder";
			optionsHolder.x = this.screenHolder.getChildByName("instrTxt").x;
			optionsHolder.y = this.screenHolder.getChildByName("instrTxt").y + 25;
			this.screenHolder.addChild(optionsHolder);
			
			var numOfOptions:int = this.dataXml.item[questionIndex].choises.opt.length();
			if(numOfOptions > MAX_OPTIONS){
				numOfOptions = MAX_OPTIONS;
			}
			var thisOpt:AnswerItem;
			var yVal:Number = 0;
			var userSelection:Number;
			for(var i:int=0;i<numOfOptions;i++){
				thisOpt = new AnswerItem();
				thisOpt.name = "opt_"+i;
				thisOpt.y = yVal;
				
				thisOpt.answerTxt.autoSize = "left";
				thisOpt.answerTxt.text = this.dataXml.item[questionIndex].choises.opt[i].text();
				thisOpt.answerTxt.y = 56/2 - thisOpt.answerTxt.height/2;
				
				var txtFrmt:TextFormat = thisOpt.answerTxt.getTextFormat();
				txtFrmt.size = this.aFontSize;
				thisOpt.answerTxt.setTextFormat(txtFrmt);
				
				thisOpt.indicatorMc.optionTxt.text = optionArr[i];
				
				// Added for showing previous selected answer
				
				if(this.configProxyRef.testTypeModeIndx == 1){
					userSelection = this.dataProxyRef.testResultArray[questionIndex].userSelection;
					if(i == userSelection){
						//thisOpt.indicatorMc.gotoAndStop(3);
						thisOpt.gotoAndStop(3);
					}
				}
				
				
				thisOpt.answerTxt.mouseEnabled = false;
				thisOpt.buttonMode = true;
				thisOpt.isClicked = false;
				thisOpt.index = i;
				thisOpt.addEventListener(MouseEvent.MOUSE_OVER, onOptOver, false, 0, true);
				thisOpt.addEventListener(MouseEvent.MOUSE_OUT, onOptOut, false, 0, true);
				thisOpt.addEventListener(MouseEvent.CLICK, onOptClick, false, 0, true);
				optionsHolder.addChild(thisOpt);
				yVal = yVal + thisOpt.height + 4;
			}
		}
		
		private function resetOthers():void{
			var numOfOptions:int = this.dataXml.item[this.dataProxyRef.currentQuestionIndex].choises.opt.length();
			var thisOpt:MovieClip;
			var optionsHolder:MovieClip;
			for(var i:int=0;i<numOfOptions;i++){
				optionsHolder = this.screenHolder.getChildByName("optionsHolder") as MovieClip;
				thisOpt = optionsHolder.getChildByName("opt_"+i) as MovieClip;
				thisOpt.isClicked = false;
				thisOpt.gotoAndStop(1);
			}
		}
		
		private function onOptOver(evt:MouseEvent):void{
			if(evt.currentTarget.isClicked == false){
				evt.currentTarget.gotoAndStop(2);
			}
		}
		private function onOptOut(evt:MouseEvent):void{
			if(evt.currentTarget.isClicked == false){
				evt.currentTarget.gotoAndStop(1);
			}
		}
		private function onOptClick(evt:MouseEvent):void{

			//var explanationTxt:ExplanationTxt = this.screenHolder.getChildByName("explanationTxt") as ExplanationTxt;
			var remarksBut:RemarksBut = this.screenHolder.getChildByName("remarksBut") as RemarksBut;
			
			if(this.configProxyRef.testTypeModeIndx == 0){
				
				//this.disableAll();
				
				var isCorrent:Boolean = this.checkForAnswer(evt.currentTarget.index);
				if(isCorrent == true){
					this.sfx.playSound("CORRECT_VOICE");
					evt.currentTarget.indicatorMc.gotoAndStop(2);
					//explanationTxt.label.text = "You got correct answer!";
					remarksBut.visible = false;
				}else{
					this.sfx.playSound("WRONG_VOICE");
					evt.currentTarget.indicatorMc.gotoAndStop(3);
					this.showCorrectOpt();
					//explanationTxt.label.text = this.dataXml.item[this.dataProxyRef.currentQuestionIndex].remarks.text();
					remarksBut.visible = true;
				}
				this.disableAll();
			}else{
				this.resetOthers();
			}

			evt.currentTarget.isClicked = true;
			evt.currentTarget.gotoAndStop(3);

			this.dataProxyRef.testResultArray[this.dataProxyRef.currentQuestionIndex].userSelection = evt.currentTarget.index as Number;
			
			var qProgress:QProgress = this.screenHolder.getChildByName("qProgress") as QProgress;
			qProgress.nomTxt.text = ""+this.dataProxyRef.getTotalCorrectAnswers();
			qProgress.denomTxt.text = String(this.configProxyRef.userSelectedQCount);
			
			var navButs:NavButs = this.screenHolder.getChildByName("navButs") as NavButs;
			if(navButs.nextBut.visible == true){
				navButs.nextBut.gotoAndStop(1);
				navButs.nextBut.label.alpha = 1;
				navButs.nextBut.buttonMode = true;
				navButs.nextBut.label.mouseEnabled = false;
				navButs.nextBut.addEventListener(MouseEvent.CLICK, onButClick, false, 0, true);
				navButs.nextBut.addEventListener(MouseEvent.MOUSE_OVER, onButOver, false, 0, true);
				navButs.nextBut.addEventListener(MouseEvent.MOUSE_OUT, onButOut, false, 0, true);
			}
			if(navButs.finishBut.visible == true){
				navButs.finishBut.gotoAndStop(1);
				navButs.finishBut.label.alpha = 1;
				navButs.finishBut.buttonMode = true;
				navButs.finishBut.label.mouseEnabled = false;
				navButs.finishBut.addEventListener(MouseEvent.CLICK, onButClick, false, 0, true);
				navButs.finishBut.addEventListener(MouseEvent.MOUSE_OVER, onButOver, false, 0, true);
				navButs.finishBut.addEventListener(MouseEvent.MOUSE_OUT, onButOut, false, 0, true);
			}
			
			trace(evt.currentTarget.index);
		}
		private function showCorrectOpt():void{
			var correctIndx:Number = Number(this.dataXml.item[this.dataProxyRef.currentQuestionIndex].ansIndx);
			var thisOpt:MovieClip;
			var optionsHolder:MovieClip;
			optionsHolder = this.screenHolder.getChildByName("optionsHolder") as MovieClip;
			thisOpt = optionsHolder.getChildByName("opt_"+correctIndx) as MovieClip;
			thisOpt.indicatorMc.gotoAndStop(2);
		}
		private function checkForAnswer(selectedIndx:int):Boolean{
			var correctIndx:Number = Number(this.dataXml.item[this.dataProxyRef.currentQuestionIndex].ansIndx);
			//trace("correctIndx = "+correctIndx+" : selectedIndx = "+selectedIndx);
			if(selectedIndx == correctIndx){
				return true;
			}else{
				return false;
			}
		}
		private function disableAll():void{
			var numOfOptions:int = this.dataXml.item[this.dataProxyRef.currentQuestionIndex].choises.opt.length();
			if(numOfOptions > MAX_OPTIONS){
				numOfOptions = MAX_OPTIONS;
			}
			var thisOpt:MovieClip;
			var optionsHolder:MovieClip;
			for(var i:int=0;i<numOfOptions;i++){
				optionsHolder = this.screenHolder.getChildByName("optionsHolder") as MovieClip;
				thisOpt = optionsHolder.getChildByName("opt_"+i) as MovieClip;
				thisOpt.buttonMode = false;
				thisOpt.removeEventListener(MouseEvent.MOUSE_OVER, onOptOver);
				thisOpt.removeEventListener(MouseEvent.MOUSE_OUT, onOptOut);
				thisOpt.removeEventListener(MouseEvent.CLICK, onOptClick);
			}
		}
		
		private function onFinish():void{

			this.removeScreen();
			
			var custEvt:CustEvent = new CustEvent(TestScreen.ON_FINISH_PRESS);
			this.dispatchEvent(custEvt);
		}
		
		private function removeScreen():void{
			this.screenHolder.removeChild(this.screenHolder.getChildByName("muteButton"));
			this.sfx = null;
			this.removeChild(this.getChildByName("screenHolder"));
		}
		
		private function createReviewBar():void{
			this.reviewBar = new MovieClip();
			this.reviewBar.x = 60;
			this.reviewBar.y = -10;
			this.reviewBar.name = "reviewBar";
			this.screenHolder.addChild(this.reviewBar);
			
			var reviewLabel:ReviewLabel = new ReviewLabel();
			reviewLabel.label.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="review")[0].text();
			this.reviewBar.addChild(reviewLabel);
			
			var prevPageBut:PrevPageBut = new PrevPageBut();
			prevPageBut.x = 75;
			prevPageBut.y = 10;
			this.reviewBar.addChild(prevPageBut);
			prevPageBut.buttonMode = true;
			prevPageBut.addEventListener(MouseEvent.CLICK, onPrevPress, false, 0, true);
			
			var itemsHolder:MovieClip = new MovieClip();
			itemsHolder.name = "itemsHolder";
			itemsHolder.x = prevPageBut.x + prevPageBut.width + 15;
			itemsHolder.y = 13;
			this.reviewBar.addChild(itemsHolder);
			var reviewItem:ReviewItem;
			var xPos:Number = 0;
			for(var i:int=0;i<10;i++){
				reviewItem = new ReviewItem(); 
				reviewItem.name = "reviewItem"+i;
				reviewItem.x = xPos;
				xPos = reviewItem.x + reviewItem.width + 3;
				itemsHolder.addChild(reviewItem);
			}
			
			var nextPageBut:NextPageBut = new NextPageBut();
			nextPageBut.x = itemsHolder.x + itemsHolder.width + 15;
			nextPageBut.y = 10;
			this.reviewBar.addChild(nextPageBut);
			nextPageBut.buttonMode = true;
			nextPageBut.addEventListener(MouseEvent.CLICK, onNextPress, false, 0, true);
			
		}
		
		private function onPrevPress(evt:MouseEvent):void{
			if(this.dataProxyRef.reviewPageIndex != 0){
				this.dataProxyRef.reviewPageIndex--;
				this.populateReviewBar(this.dataProxyRef.reviewPageIndex);
			}
		}
		private function onNextPress(evt:MouseEvent):void{
			
			var totalPages:Number = Math.ceil(this.configProxyRef.userSelectedQCount/10);
			if(this.dataProxyRef.reviewPageIndex != (totalPages - 1)){
				this.dataProxyRef.reviewPageIndex++;
				this.populateReviewBar(this.dataProxyRef.reviewPageIndex);
			}
		}
		
		private function populateReviewBar(pageIndx:int):void{
			
			var reviewItem:ReviewItem;
			var answer:Boolean;
			var itemsHolder:MovieClip = this.reviewBar.getChildByName("itemsHolder") as MovieClip;
			var currIndx:int;
			for(var i:int=0;i<10;i++){
				currIndx = pageIndx*10+i;
				reviewItem = itemsHolder.getChildByName("reviewItem"+i) as ReviewItem; 
				reviewItem.index = currIndx;
				if(currIndx < this.configProxyRef.userSelectedQCount){
					reviewItem.label.text = reviewItem.index + 1;
					reviewItem.label.mouseEnabled = false;
					reviewItem.buttonMode = true;
					/*
					answer = this.dataProxyRef.getQResult(reviewItem.index);
					if(answer == true){
						reviewItem.revIcons.gotoAndStop(1);
					}else{
						reviewItem.revIcons.gotoAndStop(2);
					}
					*/
					reviewItem.revIcons.gotoAndStop(3);
					reviewItem.addEventListener(MouseEvent.CLICK, onRevItemClick, false, 0, true);
					
				}else{
					reviewItem.label.text = "";
					reviewItem.label.mouseEnabled = false;
					reviewItem.buttonMode = false;
					
					reviewItem.revIcons.gotoAndStop(3);
					
					reviewItem.removeEventListener(MouseEvent.CLICK, onRevItemClick);
					
				}
			}
		}
		private function onRevItemClick(evt:MouseEvent):void{
			trace(evt.currentTarget.index);
			this.dataProxyRef.currentQuestionIndex = evt.currentTarget.index;
			this.clearPreviousQuestion();
			this.renderQuestion();
		}
		
	}
}
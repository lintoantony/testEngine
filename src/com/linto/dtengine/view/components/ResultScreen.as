/*
@author Linto K Antony <lintoka123@gmail.com>
*/
package com.linto.dtengine.view.components{
	import com.linto.dtengine.model.ConfigProxy;
	import com.linto.dtengine.model.DataProxy;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.ColorTransform;

	public class ResultScreen extends Sprite {
		
		public static const ON_TRY_AGAIN:String = "onTryAgain";
		private const TOTAL_GRAPH_BARS:int = 8;
		
		public var id:String;
		
		private var reviewBar:MovieClip;
		private var resultHolder:MovieClip;
		private var summaryHolder:MovieClip;
		private var summaryBut:SummaryBut;
		
		private var dataProxyRef:DataProxy;
		private var configProxyRef:ConfigProxy;
		
		
		public function ResultScreen( id:String, params:Array=null ) {
			this.id = id;
		}
		
		public function setProxyRef(dataProxyRef:DataProxy, configProxyRef:ConfigProxy):void{
			this.dataProxyRef = dataProxyRef;
			this.configProxyRef = configProxyRef;
		}
		
		public function initialize():void{
			resultHolder = new MovieClip();
			resultHolder.name = "resultHolder";
			resultHolder.x = 10;
			resultHolder.y = 50;
			this.addChild(resultHolder);

			//if(this.configProxyRef.testTypeModeIndx == 0){
				this.createReviewBar();
			//}
			
			this.attachElements();
			
			this.createSummary();
			this.showSummary(true);
			
			//if(this.configProxyRef.testTypeModeIndx == 0){
				this.populateReviewBar(this.dataProxyRef.reviewPageIndex);
			//}
		}
		
		private function createSummary():void{
			summaryHolder = new MovieClip();
			summaryHolder.name = "summaryHolder";
			summaryHolder.x = 30;
			summaryHolder.y = 100;
			this.resultHolder.addChild(summaryHolder);
			
			var summaryClip:SummaryClip = new SummaryClip();
			summaryClip.name = "summaryClip";
			summaryHolder.addChild(summaryClip);
			
			//if(this.configProxyRef.testTypeModeIndx == 0){
				this.summaryBut = new SummaryBut();
				this.summaryBut.x = 60;
				this.summaryBut.y = 445;
				this.summaryBut.name = "summaryBut";
				this.resultHolder.addChild(this.summaryBut);
				this.summaryBut.label.mouseEnabled = false;
				this.summaryBut.label.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="summaryBut")[0].text();
				this.enableSummaryBut(false);
			//}
			
			var tryAgain:TryAgain = new TryAgain();
			tryAgain.x = 200;
			tryAgain.y = 445;
			tryAgain.name = "tryAgain";
			this.resultHolder.addChild(tryAgain);
			tryAgain.label.mouseEnabled = false;
			tryAgain.label.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="tryAgain")[0].text();
			tryAgain.buttonMode = true;
			tryAgain.addEventListener(MouseEvent.CLICK, onTryAgain);

			
			summaryClip.headerTxt.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="summary")[0].text();
			summaryClip.label1.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="ptd")[0].text();
			summaryClip.label2.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="score")[0].text();
			summaryClip.label3.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="timeText")[0].text();
			summaryClip.label4.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="percentage")[0].text();
			summaryClip.label5.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="result")[0].text();
			
			summaryClip.result1.text = this.configProxyRef.theoryTest;
			summaryClip.result2.text = this.dataProxyRef.getTotalCorrectAnswers()+"/"+this.configProxyRef.userSelectedQCount;
			summaryClip.result3.text = this.dataProxyRef.timeTaken;
			var per:Number = this.dataProxyRef.getTotalCorrectAnswers()/this.configProxyRef.userSelectedQCount*100;
			summaryClip.result4.text =  Math.round(per) +" %";
			var passOrFail:String;
			if(per >= 90){
				passOrFail = this.configProxyRef.configDataXml.labelTexts.label.(@type=="pass")[0].text();
				changeColor(summaryClip.result5Mc, 0x009900);
			}else{
				passOrFail = this.configProxyRef.configDataXml.labelTexts.label.(@type=="fail")[0].text();
				changeColor(summaryClip.result5Mc, 0xff0000);
			}
			summaryClip.result5Mc.result5.text = passOrFail;
			
			// Graph
			summaryClip.graphMc.bars.visible = false;
			summaryClip.graphMc.loading.visible = true;
			this.renderGraph();

		}
		private function onTryAgain(evt:MouseEvent):void{
			this.removeScreen();
			
			var finishEvent:Event = new Event(ResultScreen.ON_TRY_AGAIN);
			this.dispatchEvent(finishEvent);
		}
		
		private function renderGraph():void{
			this.dataProxyRef.loadGraphData();
		}
		
		public function drawGraph():void{
			//trace("this.dataProxyRef.graphXmlData = "+this.dataProxyRef.graphXmlData);
			
			var totalItems:int = this.dataProxyRef.graphXmlData.item.length();
			if(totalItems > TOTAL_GRAPH_BARS){
				totalItems = TOTAL_GRAPH_BARS;
			}
			var summaryClip:SummaryClip = this.summaryHolder.getChildByName("summaryClip") as SummaryClip;
			
			hideAll();

			var percentage:Number;
			var thisBar:MovieClip;
			for(var i:int=1;i<=totalItems;i++){
				percentage =  Number(this.dataProxyRef.graphXmlData.item[i-1]);
				thisBar = summaryClip.graphMc.bars["bar"+i] as MovieClip;
				//trace("thisBar = "+thisBar);
				thisBar.scaleY = percentage/100;
				thisBar.visible = true;
				if(percentage >= 90){
					changeColor(thisBar, 0x009900);
				}else{
					changeColor(thisBar, 0xff0000);
				}
			}
			summaryClip.graphMc.loading.visible = false;
			summaryClip.graphMc.bars.visible = true;
		}
		private function hideAll():void{
			var summaryClip:SummaryClip = this.summaryHolder.getChildByName("summaryClip") as SummaryClip;
			for(var i:int=1;i<=TOTAL_GRAPH_BARS;i++){
				summaryClip.graphMc.bars["bar"+i].visible = false;
			}
		}
		
		private function changeColor(mc:MovieClip, color:Number):void{
			var ct:ColorTransform = mc.transform.colorTransform;
			ct.color = color;
			mc.transform.colorTransform = ct;
		}

		/*
		private function renderGraph():void{
			var summaryClip:SummaryClip = this.summaryHolder.getChildByName("summaryClip") as SummaryClip;
			summaryClip.graphMc.bar1.visible = false;
			summaryClip.graphMc.bar2.visible = false;
			summaryClip.graphMc.bar3.visible = false;
			summaryClip.graphMc.bar4.visible = false;
			summaryClip.graphMc.bar5.visible = false;
			summaryClip.graphMc.bar6.visible = false;
			summaryClip.graphMc.bar7.visible = false;
			summaryClip.graphMc.bar8.visible = false;
			
			var totalQs:Number = this.dataProxyRef.getTotalNumOfQs();
			var correctCount:Number = 0;
			var correctAnsIndx:Number;
			var userSelection:Number;
			var setCount:int = 1;
			var per:Number;
			for(var i:int=0;i<totalQs;i++){
				
				if(i%10==0 && i!=0){
					per = correctCount/10;
					
					summaryClip.graphMc["bar"+setCount].scaleY = per;
					summaryClip.graphMc["bar"+setCount].visible = true;
					
					correctCount = 0;
					setCount++;	
				}
				
				correctAnsIndx = this.dataProxyRef.testResultArray[i].correctAnsIndx;
				userSelection = this.dataProxyRef.testResultArray[i].userSelection;
				if(userSelection == correctAnsIndx){
					correctCount++;
				}
			}
			
		}
		*/
		private function enableSummaryBut(isEnabled:Boolean):void{
			this.summaryBut.buttonMode = isEnabled;
			if(isEnabled == true){
				this.summaryBut.gotoAndStop(1);
				this.summaryBut.addEventListener(MouseEvent.CLICK, onSummaryClick, false, 0, true);
			}else{
				this.summaryBut.gotoAndStop(2);
				this.summaryBut.removeEventListener(MouseEvent.CLICK, onSummaryClick);
			}
			this.summaryBut.label.mouseEnabled = false;
		}
		private function onSummaryClick(evt:MouseEvent):void{
			this.showSummary(true);
			this.enableSummaryBut(false);
		}
		private function showSummary(isVisible:Boolean):void{
			summaryHolder.visible = isVisible;
			if(isVisible == true){
				this.removeReview();
			}
		}
		
		private function createReviewBar():void{
			this.reviewBar = new MovieClip();
			this.reviewBar.x = 60;
			this.reviewBar.y = 20;
			this.reviewBar.name = "reviewBar";
			this.resultHolder.addChild(this.reviewBar);
			
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
					answer = this.dataProxyRef.getQResult(reviewItem.index);
					if(answer == true){
						reviewItem.revIcons.gotoAndStop(1);
					}else{
						reviewItem.revIcons.gotoAndStop(2);
					}
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
			//if(this.configProxyRef.testTypeModeIndx == 0){
				this.enableSummaryBut(true);
			//}
			this.showSummary(false);
			this.clearPreviousQuestion();
			this.attachOptions(evt.currentTarget.index);
		}
		
		private function attachElements():void{
			
			// Question Text
			var questionHolder:QuestionHolder = new QuestionHolder();
			questionHolder.name = "questionHolder";
			questionHolder.x = 0;
			questionHolder.y = 60;
			this.resultHolder.addChild(questionHolder);
			questionHolder.visible = false;
			
			// Instruction
			var instrTxt:InstrTxt = new InstrTxt();
			instrTxt.name = "instrTxt";
			instrTxt.x = 55;
			instrTxt.y = questionHolder.y + questionHolder.height + 46;
			instrTxt.label.text = this.configProxyRef.configDataXml.labelTexts.label.(@type=="selected")[0].text();
			this.resultHolder.addChild(instrTxt);
			instrTxt.visible = false;
			
			// Image
			var imageBox:ImageBox = new ImageBox();
			imageBox.name = "imageBox";
			imageBox.x = 648;
			imageBox.y = questionHolder.y + 90;
			this.resultHolder.addChild(imageBox);
			imageBox.visible = false;
			
		}
		
		private function attachOptions(questionIndex:int):void{
			
			var questionHolder:MovieClip = this.resultHolder.getChildByName("questionHolder") as MovieClip;
			questionHolder.qTxt.autoSize = "left";
			questionHolder.qTxt.text = this.dataProxyRef.xmlData.item[questionIndex].question.text();
			questionHolder.qTxt.y = 56/2 - questionHolder.qTxt.height/2 + 40;
			questionHolder.qNumTxt.text = questionIndex + 1;
			questionHolder.visible = true;
			
			var instrTxt:InstrTxt = this.resultHolder.getChildByName("instrTxt") as InstrTxt;
			instrTxt.visible = true;
			
			var optionArr:Array = ["A", "B", "C", "D", "E"];
			
			var optionsHolder:MovieClip = new MovieClip();
			optionsHolder.name = "optionsHolder";
			optionsHolder.x = 60;
			optionsHolder.y = 190;
			this.resultHolder.addChild(optionsHolder);
			
			var numOfOptions:int = this.dataProxyRef.xmlData.item[questionIndex].choises.opt.length();
			if(numOfOptions > 5){
				numOfOptions = 5;
			}
			var thisOpt:AnswerItem;
			var yVal:Number = 0;
			var correctAnsIndx:Number;
			var userSelection:Number;
			for(var i:int=0;i<numOfOptions;i++){
				thisOpt = new AnswerItem();
				thisOpt.name = "opt_"+i;
				thisOpt.y = yVal;
				
				thisOpt.answerTxt.autoSize = "left";
				thisOpt.answerTxt.text = this.dataProxyRef.xmlData.item[questionIndex].choises.opt[i].text();
				thisOpt.answerTxt.y = 56/2 - thisOpt.answerTxt.height/2;
				
				thisOpt.indicatorMc.optionTxt.text = optionArr[i];
				
				correctAnsIndx = this.dataProxyRef.testResultArray[questionIndex].correctAnsIndx;
				userSelection = this.dataProxyRef.testResultArray[questionIndex].userSelection;
				if(i == correctAnsIndx){
					thisOpt.indicatorMc.gotoAndStop(2);
					if(i == userSelection){
						thisOpt.gotoAndStop(3);
					}
				}else if(i == userSelection){
					thisOpt.indicatorMc.gotoAndStop(3);
					thisOpt.gotoAndStop(3);
				}
				
				thisOpt.answerTxt.mouseEnabled = false;
				optionsHolder.addChild(thisOpt);
				yVal = yVal + thisOpt.height + 4;
			}
		}
		
		private function clearPreviousQuestion():void{
			var optionsHolder:MovieClip = this.resultHolder.getChildByName("optionsHolder") as MovieClip;
			if(optionsHolder != null){
				this.resultHolder.removeChild(optionsHolder);
			}
		}
		
		private function removeReview():void{
			this.clearPreviousQuestion();
			
			var questionHolder:MovieClip = this.resultHolder.getChildByName("questionHolder") as MovieClip;
			questionHolder.visible = false;
			
			var instrTxt:InstrTxt = this.resultHolder.getChildByName("instrTxt") as InstrTxt;
			instrTxt.visible = false;
			
			var imageBox:ImageBox = this.resultHolder.getChildByName("imageBox") as ImageBox;
			imageBox.unloadThumbnail();
			imageBox.visible = false;
		}
		private function removeScreen():void{
			this.removeChild(this.getChildByName("resultHolder"));
		}
	}
}
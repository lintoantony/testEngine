/*
@author Linto K Antony <lintoka123@gmail.com>
*/
package com.linto.dtengine.view.components{
    import com.linto.dtengine.model.ConfigProxy;
    import com.linto.events.CustEvent;
    
    import fl.controls.ComboBox;
    import fl.data.DataProvider;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
	
	
    public class ConfigScreen extends Sprite {
		
		public static const APP_WIDTH:int = 832;
		public static const APP_HEIGHT:int = 622;

		public static const ON_START_PRESS:String = "onStartPress";
		
		public var id:String;
		private var aCb:ComboBox;
		private var configDataXml:XML;
		private var dpArrays:Array;
		private var optionsHolder:MovieClip;
		private var configProxyRef:ConfigProxy;
		private var bgClip:BgClip;
		private var header:Header;
		private var footer:Footer;
		
        public function ConfigScreen( id:String, params:Array=null ) {
			this.id = id;
        }
		
		public function initialize(dataXml:XML):void{
			
			this.configDataXml = dataXml;
			
			this.setBg();
			this.setHeaderFooterImage();
			this.createOptionsPanel();
			this.addButtonAndLabels();
			
		}
		
		public function setProxyRef(configProxyRef:ConfigProxy):void{
			this.configProxyRef = configProxyRef;
		}
		
		private function setBg():void{
			if(bgClip == null){
				bgClip = new BgClip();
				bgClip.name = "bgClip";
				this.addChild(bgClip);
			}
		}
		
		private function setHeaderFooterImage():void{
			//Header
			if(header == null){
				header = new Header();
				header.name = "header";
				header.x = 35;
				header.y = 10;
				header.label.mouseEnabled = false;
				
				this.addChild(header);
			}
			header.label.text = this.configDataXml.appHeading.text();

			// Logo
			var imageBox:ImageBox = new ImageBox();
			imageBox.name = "imageBox";
			imageBox.x = APP_WIDTH - 190;
			imageBox.y = APP_HEIGHT - 160;
			this.addChild(imageBox);
			imageBox.setCellSize(200,200);
			imageBox.loadThumbnail(this.configDataXml.logoUrl.text());
			//imageBox.visible = false;
			
			//Footer
			if(footer == null){
				footer = new Footer();
				footer.x = APP_WIDTH - footer.width - 25;
				footer.y = APP_HEIGHT - footer.height - 8;
				footer.label.mouseEnabled = false;
				footer.label.text = this.configDataXml.labelTexts.label.(@type=="copyright")[0].text();
				this.addChild(footer);
			}
		}
		
		public function changeHeader(label:String):void{
			var header:Header = this.getChildByName("header") as Header;
			header.label.text = label;
		}
		
		private function createOptionsPanel():void{
			// Options holder
			optionsHolder = new MovieClip();
			optionsHolder.name = "optionsHolder";
			optionsHolder.y = 70;
			this.addChild(optionsHolder);
			
			var optionsBg:OptionsBg = new OptionsBg();
			optionsHolder.addChild(optionsBg);

			var numOfOptions:int = this.configDataXml.userOptions.option.length();
			var dpArray:Array;
			var itemObj:Object;
			var numOfItems:int;
			var label:String;
			var xPos:Number;
			var yPos:Number;
			var width:Number = 160;
			var labelMc:MovieClip;
			for(var i:int=0;i<numOfOptions;i++){
				dpArray = new Array();
				numOfItems = this.configDataXml.userOptions.option[i].choices.item.length();
				for(var j:int=0;j<numOfItems;j++){
					itemObj = new Object();
					itemObj.label = this.configDataXml.userOptions.option[i].choices.item[j].text();
					itemObj.data = this.configDataXml.userOptions.option[i].choices.item[j].@id;
					
					//trace("itemObj.label = "+itemObj.label);
					//trace("itemObj.data = "+itemObj.data);
					
					dpArray.push(itemObj);
				}
				label = this.configDataXml.userOptions.option[i].label.text();
				
				switch(i){
					case 0:
						xPos = 150;
						yPos = 30;
						break;
					case 1:
						xPos = 470;
						yPos = 30;
						break;
					case 2:
						xPos = 150;
						yPos = 80;
						break;
					case 3:
						xPos = 470;
						yPos = 80;
						break;
				}
				
				labelMc = new OptionsLabel();
				labelMc.x = xPos - labelMc.width - 5;
				labelMc.y = yPos + 1;
				labelMc.label.mouseEnabled = false;
				labelMc.label.text = label;
				optionsHolder.addChild(labelMc);
				
				this.addComboBox(dpArray, "Select One Option", xPos, yPos, width, i);
				
			}
			
			optionsHolder.x = 760/2 - optionsHolder.width/2;
		}
		
		private function addButtonAndLabels():void{
			//Start button
			var startBut:StartBut = new StartBut();
			startBut.name = "startBut";
			startBut.x = optionsHolder.x + optionsHolder.width/2 - startBut.width/2 + 30;
			startBut.y = optionsHolder.y + optionsHolder.height + 30;
			startBut.label.mouseEnabled = false;
			startBut.label.text = this.configDataXml.labelTexts.label.(@type=="start")[0].text();
			startBut.buttonMode = true;
			startBut.addEventListener(MouseEvent.CLICK, onStartTest, false, 0, true);
			this.addChild(startBut);
			
			//Instruction
			var instrLabel:InstrLabel = new InstrLabel();
			instrLabel.name = "instrLabel";
			instrLabel.x = startBut.x + startBut.width/2 - instrLabel.width/2 - 30;
			instrLabel.y = startBut.y + startBut.height - 70;
			instrLabel.label.text = this.configDataXml.labelTexts.label.(@type=="instruction")[0].text();
			instrLabel.label.mouseEnabled = false;
			this.addChild(instrLabel);
			
			//Terms & conditions
			var termsMc:TermsMc = new TermsMc();
			termsMc.name = "termsMc";
			termsMc.x = 35;
			termsMc.y = 390;
			termsMc.headline.text = this.configDataXml.terms.label.text();
			termsMc.contents.text = "";
			var numOfLines:int = this.configDataXml.terms.list.item.length();
			for(var i:int=0;i<numOfLines;i++){
				termsMc.contents.text += (this.configDataXml.terms.list.item[i].text()+"\n");
			}
			
			termsMc.headline.mouseEnabled = false;
			termsMc.contents.mouseEnabled = false;
			this.addChild(termsMc);
		}
			
		private function addComboBox(dpArray:Array, prompt:String, xPos:Number, yPos:Number, width:Number, indx:int):void{
			var aCb:ComboBox = new ComboBox(); 
			aCb.name = "cb_"+indx;
			aCb.dropdownWidth = width; 
			aCb.width = width;
			aCb.move(xPos, yPos); 
			//aCb.prompt = prompt; 
			aCb.dataProvider = new DataProvider(dpArray); 
			aCb.addEventListener(Event.CHANGE, changeHandler, false, 0, true);
			
			aCb.selectedIndex = 0;
			aCb.selectedItem = dpArray[0].data;
			
			optionsHolder.addChild(aCb);
		}
		private function changeHandler(event:Event):void { 
			//ComboBox(event.target).selectedItem.data; 
		}
		private function onStartTest(evt:MouseEvent):void{
			var optionVal:String;
			var numOfOptions:int = this.configDataXml.userOptions.option.length();
			var thisCb:ComboBox;
			var selectedIndex:Number;
			var sendString:String = "";
			var sepChar:String;
			for(var i:int=0;i<numOfOptions;i++){
				thisCb = optionsHolder.getChildByName("cb_"+i) as ComboBox;

				if(i == 0){
					sepChar = "";
				}else{
					sepChar = ",";
				}
				
				if(thisCb.selectedIndex == -1){
					sendString = sendString + sepChar + 1;
				}else{
					sendString = sendString + sepChar + thisCb.selectedItem.data;
				}
			}
			trace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sendString = "+sendString);
			
			this.configProxyRef.storeUserConfigs(sendString);
			
			var custEvt:CustEvent = new CustEvent(ConfigScreen.ON_START_PRESS);
			custEvt.data = sendString;
			this.dispatchEvent(custEvt);
			
			this.removeScreen();
		}
		
		private function removeScreen():void{
			this.removeChild(this.getChildByName("optionsHolder"));
			this.removeChild(this.getChildByName("startBut"));
			this.removeChild(this.getChildByName("instrLabel"));
			this.removeChild(this.getChildByName("termsMc"));
			this.removeChild(this.getChildByName("imageBox") as MovieClip);
			
			var bgClip:BgClip = this.getChildByName("bgClip") as BgClip;
		}

    }
}
/*
By Linto K Antony <lintoka123@gmail.com>
*/
package com.linto.dtengine.model{
	
	import com.linto.dtengine.ApplicationFacade;
	import com.linto.utils.ServerComm;
	import com.linto.utils.XMLLoader;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class DataProxy extends Proxy implements IProxy{
		
		public static const NAME:String = 'DataProxy';
		
		private var xmlLoader:XMLLoader;
		private var dataXml:XML;
		
		public var currentQuestionIndex:int = 0;
		public var reviewPageIndex:int = 0;
		
		public var testResultArray:Array;
		
		public function DataProxy( ){
			super( NAME, Number(0) );
		}
		
		public function resetValues():void{
			currentQuestionIndex = 0;
			reviewPageIndex = 0;
			testResultArray = new Array();
		}
		
		public function loadData(configOptions:String):void{
			
			// configOptions -> "1,2,1,3"
			
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var apiUrl:String = configProxy.serverApiUrl;
			
			// XML file loading
			this.xmlLoader = new XMLLoader();
			this.xmlLoader.addEventListener(Event.COMPLETE, onDataLoadComplete);
			this.xmlLoader.load(apiUrl);
			
			// XML output from PHP API
			/*
			var variables:URLVariables = new URLVariables(); 
			variables.configStr = configStr;
			variables.operation = "LOAD_TEST_DATA";
			
			var serverComm:ServerComm = new ServerComm();
			serverComm.addEventListener(Event.COMPLETE, onDataLoadComplete);
			serverComm.sendAndLoad(apiUrl, variables);
			*/
			
		}

		public function get xmlData():XML{
			return this.dataXml;
		}

		protected function onDataLoadComplete(event:Event):void{
			
			// LOCAL XML LOADING
			this.dataXml = this.xmlLoader.getXML();

			// PHP loading
			/*
			var xmlDat:XML = new XML(event.target.data.dataXmlString);
			this.testXml = xmlDat;
			*/
			
			var numOfQs:int = this.dataXml.item.length();
			var thisObj:AnsVo;
			this.testResultArray = new Array();
			for(var i:int=0;i<numOfQs;i++){
				thisObj = new AnsVo();
				thisObj.correctAnsIndx = this.dataXml.item[i].ansIndx;
				
				thisObj.userSelection = -1;
				this.testResultArray.push(thisObj);
			}
			
			//trace("this.dataXml = "+this.dataXml);
			this.sendNotification(ApplicationFacade.TEST_DATA_LOADED);
		}
		
		public function getTotalNumOfQs():Number{
			return Number(this.dataXml.item.length());
		}
		
		public function getTotalCorrectAnswers():int{
			var numOfQs:int = this.dataXml.item.length();
			var thisObj:AnsVo;
			var count:int = 0;
			for(var i:int=0;i<numOfQs;i++){
				thisObj = this.testResultArray[i];
				
				var correctAnsIndx:Number = thisObj.correctAnsIndx;
				var userSelection:Number = thisObj.userSelection; 
				
				trace("~~~~~~~~~~~~~~correctAnsIndx = "+correctAnsIndx+" : userSelection = "+userSelection);
				
				if(userSelection == correctAnsIndx){
					count++;
				}
			}
			return count;
		}
		
		public function getQResult(qIndex:int):Boolean{
			var correctAnsIndx:Number = this.testResultArray[qIndex].correctAnsIndx;
			var userSelection:Number = this.testResultArray[qIndex].userSelection; 
			trace("correctAnsIndx = "+correctAnsIndx+" : userSelection = "+userSelection);
			if(userSelection == correctAnsIndx){
				return true;
			}else{
				return false;
			}
		}
		
	}
}
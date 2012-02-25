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
		private var graphXmlLoader:XMLLoader;
		private var dataXml:XML;
		private var graphXml:XML;
		
		public var currentQuestionIndex:int = 0;
		public var currentQuestionId:String = "-1";
		public var reviewPageIndex:int = 0;
		
		
		public var testResultArray:Array;
		public var timeTaken:String = "";
		
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
			var apiUrl:String;
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			if(ConfigProxy.TO_DEPLOY == false){
				
				apiUrl = configProxy.serverApiUrl;
				
				// XML file loading
				this.xmlLoader = new XMLLoader();
				this.xmlLoader.addEventListener(Event.COMPLETE, onDataLoadComplete);
				this.xmlLoader.load(apiUrl);
			}else{
			
				// XML output from PHP API
				
				var variables:URLVariables = new URLVariables(); 
				//variables.configStr = configStr;
				variables.operation = "LOAD_TEST_DATA";

				//params = "?sub="+args.sub+"&lan="+args.lan+"&noq="+args.noq+"&typ="+args.typ;
				var paramObj:Object = new Object();
				paramObj.sub = configProxy.theoryTestIndx+1;
				paramObj.lan = configProxy.languageIndx+1;
				paramObj.noq = configProxy.userSelectedQCount;
				paramObj.typ = configProxy.testTypeModeIndx+1;
				
				trace("DataProxy.loadData : paramObj.sub = "+paramObj.sub);
				trace("DataProxy.loadData : paramObj.lan = "+paramObj.lan);
				trace("DataProxy.loadData : paramObj.noq = "+paramObj.noq);
				trace("DataProxy.loadData : paramObj.typ = "+paramObj.typ);
				
				apiUrl = ConfigProxy.getApi("QUESTIONS", paramObj);
				
				trace("DataProxy.loadData : apiUrl = "+apiUrl);
				
				var serverComm:ServerComm = new ServerComm();
				serverComm.addEventListener(Event.COMPLETE, onDataLoadComplete);
				serverComm.sendAndLoad(apiUrl, variables);
				
			}
			
		}

		public function get xmlData():XML{
			return this.dataXml;
		}

		protected function onDataLoadComplete(event:Event):void{
			
			if(ConfigProxy.TO_DEPLOY == false){
				// LOCAL XML LOADING
				this.dataXml = this.xmlLoader.getXML();
			}else{
				// PHP loading
				this.dataXml = XML(unescape(event.target.data));
				trace("output from php DataProxy.onDataLoadComplete: this.dataXml = " + this.dataXml);
			}
			
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
				
				//trace("~~~~~~~~~~~~~~correctAnsIndx = "+correctAnsIndx+" : userSelection = "+userSelection);
				
				if(userSelection == correctAnsIndx){
					count++;
				}
			}
			return count;
		}
		
		public function getQResult(qIndex:int):Boolean{
			var correctAnsIndx:Number = this.testResultArray[qIndex].correctAnsIndx;
			var userSelection:Number = this.testResultArray[qIndex].userSelection; 
			//trace("correctAnsIndx = "+correctAnsIndx+" : userSelection = "+userSelection);
			if(userSelection == correctAnsIndx){
				return true;
			}else{
				return false;
			}
		}
		
		public function loadGraphData():void{
			
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var graphDataUrl:String = configProxy.graphDataUrl;
			
			if(ConfigProxy.TO_DEPLOY == false){
				// XML file loading
				graphXmlLoader = new XMLLoader();
				graphXmlLoader.addEventListener(Event.COMPLETE, onGraphLoadComplete);
				graphXmlLoader.load(graphDataUrl);
			}else{
				// XML output from PHP API
				var variables:URLVariables = new URLVariables(); 
				//variables.configStr = configStr;
				variables.operation = "LOAD_GRAPH_DATA";
				
				//UpdateResult.php?uid=110&sub=2&mark=13&result=Y
				var paramObj:Object = new Object();
				paramObj.uid = configProxy.USER_ID;
				paramObj.sub = configProxy.theoryTestIndx+1;
				
				var per:Number = this.getTotalCorrectAnswers()/configProxy.userSelectedQCount*100;
				paramObj.mark = per;
				
				var passOrFail:String;
				if(per >= 90){
					passOrFail = "Y";
				}else{
					passOrFail = "N";
				}
				paramObj.result = passOrFail;
				
				trace("DataProxy.loadData : paramObj.uid = "+paramObj.uid);
				trace("DataProxy.loadData : paramObj.sub = "+paramObj.sub);
				trace("DataProxy.loadData : paramObj.mark = "+paramObj.mark);
				trace("DataProxy.loadData : paramObj.result = "+paramObj.result);
				
				var apiUrl:String = ConfigProxy.getApi("SUBMIT", paramObj);
				
				trace("DataProxy.loadData : apiUrl = "+apiUrl);
				
				var serverComm:ServerComm = new ServerComm();
				serverComm.addEventListener(Event.COMPLETE, onGraphLoadComplete);
				serverComm.sendAndLoad(apiUrl, variables);
				
			}
			
		}
		
		public function get graphXmlData():XML{
			return this.graphXml;
		}
		
		protected function onGraphLoadComplete(event:Event):void{
			
			if(ConfigProxy.TO_DEPLOY == false){
				// LOCAL XML LOADING
				this.graphXml = this.graphXmlLoader.getXML();
			}else{
				// PHP loading
				this.graphXml = XML(unescape(event.target.data));
				trace("output from php DataProxy.onGraphLoadComplete: this.graphXml = " + this.graphXml);
			}
			
			this.sendNotification(ApplicationFacade.GRAPH_DATA_LOADED);
		}
		
	}
}
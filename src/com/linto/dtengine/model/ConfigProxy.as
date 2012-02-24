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

    public class ConfigProxy extends Proxy implements IProxy{
        
		public static const NAME:String = 'ConfigProxy';
		
		public var timePerQuestion:Number = 1.2;
		
		private var configDataUrl:String = "";
		private var apiUrl:String = "";
		
		private var xmlLoader:XMLLoader;
		private var configXml:XML;
		private var testXml:XML;
		
		public var theoryTestIndx:Number;
		public var testTypeModeIndx:Number;
		public var numOfQuestionsIndx:Number;
		public var languageIndx:Number;
		
		public var userSelectedQCount:Number;
		
		public var theoryTest:String;
		public var testTypeMode:String;
		public var numOfQuestions:String;
		public var language:String;
		
        public function ConfigProxy( ){
            super( NAME, Number(0) );
        }

		/**
		 * Set configuration url
		 */
		public function set loadUrl( url:String ):void{
			configDataUrl = url;
		}
		
	    /**
		 * Get data url
		 */
		public function get serverApiUrl():String{
			return apiUrl;
		}
		
		public function loadData():void{
			
			// XML file loading
			this.xmlLoader = new XMLLoader();
			this.xmlLoader.addEventListener(Event.COMPLETE, onDataLoadComplete);
			this.xmlLoader.load(configDataUrl);
			
			// XML output from PHP API
			/*
			var variables:URLVariables = new URLVariables(); 
			variables.configStr = configStr;
			variables.operation = "LOAD_CONFIG_DATA";
			
			var serverComm:ServerComm = new ServerComm();
			serverComm.addEventListener(Event.COMPLETE, onDataLoadComplete);
			serverComm.sendAndLoad(apiUrl, variables);
			*/
			
		}
		
		public function get configDataXml():XML{
			return this.configXml;
		}
		
		public function storeUserConfigs(configStr:String):void{
			
			var configArr:Array = configStr.split(",");
			
			this.theoryTestIndx = Number(configArr[0]) - 1;
			this.testTypeModeIndx = Number(configArr[1]) - 1;
			this.numOfQuestionsIndx = Number(configArr[2]) - 1;
			this.languageIndx = Number(configArr[3]) - 1;
			
			
			trace("this.theoryTestIndx = "+this.theoryTestIndx);
			trace("this.testTypeModeIndx = "+this.testTypeModeIndx);
			trace("this.numOfQuestionsIndx = "+this.numOfQuestionsIndx);
			trace("this.languageIndx = "+this.languageIndx);
			
			
			this.theoryTest = this.configXml.userOptions.option[0].choices.item[this.theoryTestIndx].text();
			this.testTypeMode = this.configXml.userOptions.option[1].choices.item[this.testTypeModeIndx].text();
			this.numOfQuestions = this.configXml.userOptions.option[2].choices.item[this.numOfQuestionsIndx].text();
			this.language = this.configXml.userOptions.option[3].choices.item[this.languageIndx].text();
			
			this.userSelectedQCount = Number(this.numOfQuestions.substring(0,this.numOfQuestions.indexOf(" ")));
			
			/*
			trace("this.theoryTest = "+this.theoryTest);
			trace("this.testTypeMode = "+this.testTypeMode);
			trace("this.numOfQuestions = "+this.numOfQuestions);
			trace("this.language = "+this.language);
			*/
		}
		
		protected function onDataLoadComplete(event:Event):void{
			this.configXml = this.xmlLoader.getXML();
			this.apiUrl = this.configXml.serverApi.text();
			//trace("this.configXml = "+this.configXml);
			this.sendNotification(ApplicationFacade.CONFIG_DATA_LOADED);
		}

		
     }
}
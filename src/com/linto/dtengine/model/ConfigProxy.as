/*
By Linto K Antony <lintoka123@gmail.com>
*/
package com.linto.dtengine.model{
    
	import com.linto.dtengine.ApplicationFacade;
	import com.linto.utils.ServerComm;
	import com.linto.utils.XMLLoader;
	
	import flash.events.Event;
	import flash.net.*;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

    public class ConfigProxy extends Proxy implements IProxy{
		
		public static const TO_DEPLOY:Boolean = false;
		
		//public static const SERVER_API_BASE_URL:String = "http://www.ccssoft.net/testing/sgdt/questions/";
		public static const SERVER_API_BASE_URL:String = "http://www.sgdrivetest.com/sgdt/questions/";
        
		public var USER_ID:String = "";
		
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
		
		public var graphDataUrl:String;
		
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
			
			if(TO_DEPLOY == false){
				// XML file loading
				this.xmlLoader = new XMLLoader();
				this.xmlLoader.addEventListener(Event.COMPLETE, onDataLoadComplete);
				this.xmlLoader.load(configDataUrl);
			}else{
				// XML output from PHP API
				
				var variables:URLVariables = new URLVariables();
				variables.operation = "LOAD_CONFIG_DATA";
				
				var apiUrl:String = ConfigProxy.getApi("CONFIG", {});
				
				var serverComm:ServerComm = new ServerComm();
				serverComm.addEventListener(Event.COMPLETE, onDataLoadComplete);
				serverComm.sendAndLoad(apiUrl, variables);
			}
		}
		
		public static function getApi(type:String, args:Object):String{
			var apiUrl:String;
			var fileName:String;
			var params:String;
			switch(type){
				case "CONFIG":
					fileName = "QuestionConfigList.php";
					params = "";
					break;
				case "QUESTIONS":
					
					/*
					QuestionsList.php?sub=<subejectType>&lan=<LanguageID>&noq=<Number of questions>&typ=<TestTypeID>
					
					<subejectType> -> will be the Subject type they trying to attempt (numeric)
					<lan> -> will be the language selection
					<Number of questions> -> will be replaced by Number of question selection.
					<TestTypeID> - Will be replaced by the test type (Practice or test mode)

					Example : QuestionsList.php?sub=1&lan=1&noq=10& typ=1
					*/
					
					fileName = "QuestionsList.php";
					params = "?sub="+args.sub+"&lan="+args.lan+"&noq="+args.noq+"&typ="+args.typ;
					
					break;
				case "SUBMIT":
					
					/*
					
					UpdateResult.php?uid=<UserID>&sub=<subejectType>&mark=<score>&result=<result>
					
					<UserID> -> will be the actual the user id
					<subejectType> -> will be the Subject type they have attempted.
					<score>      -> Mark Scored
					<result> - Pass or Fail (pass means pls send the value ‘Y’ otherwise fail ‘N’)
					
					Example :
					
					UpdateResult.php?uid=110&sub=2&mark=13&result=Y
					UpdateResult.php?uid=110&sub=2&mark=13&result=N
					
					*/
					
					fileName = "UpdateResult.php";
					params = "?uid="+args.uid+"&sub="+args.sub+"&mark="+args.mark+"&result="+args.result;
					
					break;
				case "BUG":
					
					/*
					
					ReportBug.php?qno=<questionNo>
					
					<questionNo> -> will be the actual the question number
					
					Example : ReportBug.php?qno=120
					
					*/
					
					fileName = "ReportBug.php"
					params = "?qno="+args.qno;
					
					break;
			}
			
			apiUrl = SERVER_API_BASE_URL + fileName + params;
			
			return apiUrl;
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
			
			if(TO_DEPLOY == false){
				this.configXml = this.xmlLoader.getXML();
				this.USER_ID = this.configXml.UserID.text();
				trace("::::::::::::::::::::: this.USER_ID = "+this.USER_ID);
				this.apiUrl = this.configXml.serverApi.text();
				this.graphDataUrl = this.configXml.graphApi.text();
				//trace("this.configXml = "+this.configXml);
				this.sendNotification(ApplicationFacade.CONFIG_DATA_LOADED);
			}else{
				this.configXml = XML(unescape(event.target.data));
				this.USER_ID = this.configXml.UserID.text();
				trace("::::::::::::::::::::: this.USER_ID = "+this.USER_ID);
				trace("output from php ConfigProxy.onDataLoadComplete: this.configXml = " + this.configXml);
				this.sendNotification(ApplicationFacade.CONFIG_DATA_LOADED);

			}
		}

		
     }
}
/*
By Linto K Antony <lintoka123@gmail.com>
*/
package com.linto.dtengine.model{
    
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import com.linto.dtengine.ApplicationFacade;

    public class GlobalDataProxy extends Proxy implements IProxy{
        
		public static const NAME:String = 'GlobalDataProxy';
		
		private var configDataUrl:String = "";
		private var testDataUrl:String = "";
		
        public function ConfigProxy( ){
            super( NAME, Number(0) );
        }

		/**
		 * Set configuration url
		 */
		public function set configUrl( url:String ):void{
			configDataUrl = url;
		}
		
	    /**
		 * Get data url
		 */
		public function get dataUrl():String{
			return testDataUrl;
		}
		
		public function loadConfigData():void{
			this.xmlLoader = new XMLLoader();
			this.xmlLoader.addEventListener(Event.COMPLETE, onDataLoadComplete);
			this.xmlLoader.load(configDataUrl);
		}
		
		protected function onDataLoadComplete(event:Event):void{
			this.configXml = this.xmlLoader.getXML();
			
			this.sendNotification(ApplicationFacade.CONFIG_DATA_LOADED);
			
		}
		
     }
}
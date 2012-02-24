package com.linto.utils{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Sprite;

	public class ServerComm extends Sprite{
		
		public function ServerComm(){
		}
		
		public function sendAndLoad(apiUrl:String, urlVariables:URLVariables):void{
			
			var request:URLRequest = new URLRequest(apiUrl); 
			request.method = URLRequestMethod.POST; 
 
			request.data = urlVariables; 
			
			var loader:URLLoader = new URLLoader(request); 
			loader.addEventListener(Event.COMPLETE, onRequestComplete); 
			loader.dataFormat = URLLoaderDataFormat.VARIABLES; 
			loader.load(request); 
			
		}
		
		protected function onRequestComplete(event:Event):void{
			dispatchEvent(event);
		}
		
	}
	
}
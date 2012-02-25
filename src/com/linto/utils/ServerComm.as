package com.linto.utils{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.*;

	public class ServerComm extends Sprite{
		
		public var data:Object;
		
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
			var loader:URLLoader = URLLoader(event.target);
			data = loader.data;
			dispatchEvent(event);
		}
		
	}
	
}
package com.linto.utils{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Sprite;

	public class XMLLoader extends Sprite{
		
		protected var loader:URLLoader;
		protected var xml:XML;
		
		public function XMLLoader(){
			super();
		}
		
		public function load(path:String):void{
			
			trace("path = "+path);
			
			if(path == null) throw new Error(this+" path is null.");
						 
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.load(new URLRequest(path));
			
		}
		
		protected function onComplete(event:Event):void{
			xml = XML(URLLoader(event.target).data);
			dispatchEvent(event);
		}
		
		protected function onError(event:Event):void{
			dispatchEvent(event);
		}
		
		public function getXML():XML{
			return xml;
		}
		
		public function setXML(xmlData:XML):void{
			xml = xmlData;
		}
		
	}
	
}
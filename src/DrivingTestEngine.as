package
{
	import com.linto.dtengine.ApplicationFacade;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	[SWF(backgroundColor='#c4e0ee', frameRate='30', widht='832', height='622')]
	
	public class DrivingTestEngine extends Sprite
	{
		public function DrivingTestEngine(){
			
			Security.allowDomain("*");
			
			// FOR LOCAL TESTING
			var globalVars:Object = new Object();
			globalVars.stageRef = this.stage;
			globalVars.appConfigXml = "xmls/dtEngineConfig.xml";
			
			this.setGlobalVars(globalVars);
			
		}
		
		public function setGlobalVars(globalVars:Object):void{
			trace("DrivingTestEngine : setGlobalVars");
			ApplicationFacade.getInstance().startup( globalVars );
		}
		
	}
}
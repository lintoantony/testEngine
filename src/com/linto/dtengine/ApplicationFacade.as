/*
 PureMVC AS3 / Flash Demo - HelloFlash
 By Cliff Hall <clifford.hall@puremvc.org>
 Copyright(c) 2007-08, Some rights reserved.
 */
package com.linto.dtengine
{
    import com.linto.dtengine.controller.LoadConfigCommand;
    import com.linto.dtengine.controller.LoadDataCommand;
    import com.linto.dtengine.controller.SendDataCommand;
    import com.linto.dtengine.controller.StartupCommand;
    
    import org.puremvc.as3.interfaces.IFacade;
    import org.puremvc.as3.patterns.facade.Facade;
    
    public class ApplicationFacade extends Facade implements IFacade
    {
        // Notification name constants
        public static const STARTUP:String  		= "startup";
		public static const LOAD_CONFIG:String 		= "loadConfig";
		public static const LOAD_DATA:String 		= "loadData";
		public static const SEND_DATA:String 		= "sendData";
		
		
        public static const STAGE_ADD_SPRITE:String	= "stageAddSprite";
        public static const SPRITE_SCALE:String 	= "spriteScale";
		public static const SPRITE_DROP:String		= "spriteDrop"
		
			
		// Event Strings
		public static const CONFIG_DATA_LOADED:String = "configDataLoaded";
		public static const CONFIG_SCREEN_ADDED:String = "configScreenAdded";
		public static const TEST_DATA_LOADED:String = "testDataLoaded";
		public static const ON_FINISH_TEST:String = "onFinishTest";
		public static const ON_HEADER_CHANGE:String = "onHeaderChange";
		public static const ON_TRY_AGAIN:String = "onTryAgain";

		/**
         * Singleton ApplicationFacade Factory Method
         */
        public static function getInstance() : ApplicationFacade {
            if ( instance == null ) instance = new ApplicationFacade( );
            return instance as ApplicationFacade;
        }

        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController( ) : void 
        {
            super.initializeController();            
            registerCommand( STARTUP, StartupCommand );
			registerCommand( LOAD_CONFIG, LoadConfigCommand );
			registerCommand( LOAD_DATA, LoadDataCommand );
			registerCommand( SEND_DATA, SendDataCommand );
        }
        
        public function startup( globalVars:Object ):void{
        	sendNotification( STARTUP, globalVars );
        }
		public function loadConfig( configDataUrl:String ):void{
			sendNotification( LOAD_CONFIG, configDataUrl );
		}
		public function loadData(configOptions:String):void{
			sendNotification( LOAD_DATA, configOptions);
		}

    }
}
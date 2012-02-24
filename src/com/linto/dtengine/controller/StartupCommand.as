/*
 PureMVC AS3 / Flash Demo - HelloFlash
 By Cliff Hall <clifford.hall@puremvc.org>
 Copyright(c) 2007-08, Some rights reserved.
 */
package com.linto.dtengine.controller
{
    import com.linto.dtengine.ApplicationFacade;
    import com.linto.dtengine.model.SpriteDataProxy;
    import com.linto.dtengine.view.StageMediator;
    
    import flash.display.Stage;
    
    import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;

    public class StartupCommand extends SimpleCommand implements ICommand
    {
        /**
         * Register the Proxies and Mediators.
         * 
         * Get the View Components for the Mediators from the app,
         * which passed a reference to itself on the notification.
         */
        override public function execute( note:INotification ) : void    
        {
			
			// Registering Proxies 
			//facade.registerProxy(new SpriteDataProxy());
			
			// Registering Mediators
			var globalVars:Object = note.getBody() as Object;
			
	    	var stage:Stage = globalVars.stageRef.stage as Stage;

            facade.registerMediator( new StageMediator( stage ) );
			
			var configDataUrl:String = globalVars.appConfigXml;
			sendNotification( ApplicationFacade.STAGE_ADD_SPRITE, configDataUrl );

        }
    }
}
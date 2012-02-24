/*
 PureMVC AS3 / Flash Demo - HelloFlash
 By Cliff Hall <clifford.hall@puremvc.org>
 Copyright(c) 2007-08, Some rights reserved.
 */
package com.linto.dtengine.view
{
    import com.linto.dtengine.ApplicationFacade;
    import com.linto.dtengine.model.ConfigProxy;
    import com.linto.dtengine.model.DataProxy;
    import com.linto.dtengine.model.SpriteDataProxy;
    import com.linto.dtengine.view.HelloSpriteMediator;
    import com.linto.dtengine.view.components.ConfigScreen;
    import com.linto.dtengine.view.components.StageScreen;
    import com.linto.dtengine.view.components.TestScreen;
	import com.linto.dtengine.view.components.ResultScreen;
    
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    /**
     * A Mediator for interacting with the Stage.
     */
    public class StageMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = 'StageMediator';

        /**
         * Constructor. 
         */
        public function StageMediator( viewComponent:Object ) 
        {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            super( NAME, viewComponent );
    
			// Retrieve reference to frequently consulted Proxies
			//spriteDataProxy = facade.retrieveProxy( SpriteDataProxy.NAME ) as SpriteDataProxy;
			
            // Listen for events from the view component 
            //stage.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
            //stage.addEventListener( MouseEvent.MOUSE_WHEEL, handleMouseWheel );
            
        }


        /**
         * List all notifications this Mediator is interested in.
         * <P>
         * Automatically called by the framework when the mediator
         * is registered with the view.</P>
         * 
         * @return Array the list of Nofitication names
         */
        override public function listNotificationInterests():Array 
        {
            return [ ApplicationFacade.STAGE_ADD_SPRITE,
					 ApplicationFacade.CONFIG_DATA_LOADED
					
                   ];
        }

        /**
         * Handle all notifications this Mediator is interested in.
         * <P>
         * Called by the framework when a notification is sent that
         * this mediator expressed an interest in when registered
         * (see <code>listNotificationInterests</code>.</P>
         * 
         * @param INotification a notification 
         */
        override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) {
                
                // Create a new HelloSprite, 
				// Create and register its HelloSpriteMediator
				// and finally add the HelloSprite to the stage
                case ApplicationFacade.STAGE_ADD_SPRITE:

					var configDataUrl:String = note.getBody() as String;
					ApplicationFacade.getInstance().loadConfig( configDataUrl );
					
                    break;
				case ApplicationFacade.CONFIG_DATA_LOADED:
					
					trace("Config Data Loaded");
					
					// INITIALIZING AND ATTACHING COMPONENTS
					
					// Configuration Screen
					var configScreen:ConfigScreen = new ConfigScreen( "ConfigScreen" );
					facade.registerMediator(new ConfigMediator( configScreen ));
					stage.addChild( configScreen );
					
					// Test Screen
					
					// Registering Proxies 
					facade.registerProxy(new DataProxy());
					
					var testScreen:TestScreen = new TestScreen( "TestScreen" );
					testScreen.setProxyRef(facade.retrieveProxy(DataProxy.NAME) as DataProxy, facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy);
					facade.registerMediator(new TestMediator( testScreen ));
					stage.addChild( testScreen );
					
					// Result Screen
					var resultScreen:ResultScreen = new ResultScreen( "ResultScreen" );
					resultScreen.setProxyRef(facade.retrieveProxy(DataProxy.NAME) as DataProxy, facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy);
					facade.registerMediator(new ResultMediator( resultScreen ));
					stage.addChild( resultScreen );
					
					
					this.sendNotification(ApplicationFacade.CONFIG_SCREEN_ADDED);
					
					break;
				
            }
        }

		// The user has released the mouse over the stage
        private function handleMouseUp(event:MouseEvent):void
		{
			sendNotification( ApplicationFacade.SPRITE_DROP );
		}
                    
		// The user has released the mouse over the stage
        private function handleMouseWheel(event:MouseEvent):void
		{
			sendNotification( ApplicationFacade.SPRITE_SCALE, event.delta );
		}
                    
        /**
         * Cast the viewComponent to its actual type.
         * 
         * <P>
         * This is a useful idiom for mediators. The
         * PureMVC Mediator class defines a viewComponent
         * property of type Object. </P>
         * 
         * <P>
         * Here, we cast the generic viewComponent to 
         * its actual type in a protected mode. This 
         * retains encapsulation, while allowing the instance
         * (and subclassed instance) access to a 
         * strongly typed reference with a meaningful
         * name.</P>
         * 
         * @return stage the viewComponent cast to flash.display.Stage
         */
        protected function get stage():Stage{
            return viewComponent as Stage;
        }
		
		private var spriteDataProxy:SpriteDataProxy;
    }
}
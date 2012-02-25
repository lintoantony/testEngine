/*
@author Linto K Antony <lintoka123@gmail.com>
*/
package com.linto.dtengine.view
{
    import com.linto.dtengine.ApplicationFacade;
    import com.linto.dtengine.model.ConfigProxy;
    import com.linto.dtengine.view.components.ConfigScreen;
    import com.linto.events.CustEvent;
    
    import flash.events.Event;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    /**
     * A Mediator for interacting with the ConfigScreen.
     */
    public class ConfigMediator extends Mediator implements IMediator
    {
       
	   /**
         * Constructor. 
         */
        public function ConfigMediator( viewComponent:Object ) 
        {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            //
            // *** Note that the name of the mediator is the same as the
            // *** id of the ConfigScreen it stewards. It does not use a
            // *** fixed 'NAME' constant as most single-use mediators do
            super( ConfigScreen(viewComponent).id, viewComponent );
    
			// Retrieve reference to frequently consulted Proxies
			configProxy = facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy;

			configScreen.setProxyRef(configProxy);
			
			// Listen for events from the view component 
			configScreen.addEventListener(ConfigScreen.ON_START_PRESS, onStartPress);
            
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
            return [ 
            		 ApplicationFacade.CONFIG_SCREEN_ADDED,
					 ApplicationFacade.ON_HEADER_CHANGE
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
                
                case ApplicationFacade.CONFIG_SCREEN_ADDED:
					
					configScreen.initialize(configProxy.configDataXml);
					
                    break;
				case ApplicationFacade.ON_HEADER_CHANGE:
					
					//trace("~~~~~~~~~~~~~IVIDE VANNU : this.configProxy.theoryTest = 	"+this.configProxy.theoryTest);
					
					configScreen.changeHeader(this.configProxy.theoryTest);
					
					break;

            }
        }
		private function onStartPress(evt:CustEvent):void{
			//trace("?????????????????????????????????????????evt.data = "+evt.data);
			
			// Code for Showing Preloader
			
			
			// Loading test data
			ApplicationFacade.getInstance().loadData(evt.data as String);
			
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
         * @return stage the viewComponent cast to ConfigScreen
         */
        protected function get configScreen():ConfigScreen
        {
            return viewComponent as ConfigScreen;
        }

		private var configProxy:ConfigProxy;
    }
}
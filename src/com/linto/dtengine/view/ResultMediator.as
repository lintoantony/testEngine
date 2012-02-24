/*
@author Linto K Antony <lintoka123@gmail.com>
*/
package com.linto.dtengine.view
{
	import com.linto.dtengine.ApplicationFacade;
	import com.linto.dtengine.model.DataProxy;
	import com.linto.dtengine.view.components.ResultScreen;
	import com.linto.events.CustEvent;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * A Mediator for interacting with the ResultScreen.
	 */
	public class ResultMediator extends Mediator implements IMediator
	{
		
		/**
		 * Constructor. 
		 */
		public function ResultMediator( viewComponent:Object ) 
		{
			// pass the viewComponent to the superclass where 
			// it will be stored in the inherited viewComponent property
			//
			// *** Note that the name of the mediator is the same as the
			// *** id of the TestScreen it stewards. It does not use a
			// *** fixed 'NAME' constant as most single-use mediators do
			super( ResultScreen(viewComponent).id, viewComponent );
			
			// Retrieve reference to frequently consulted Proxies
			dataProxy = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
			
			// Listen for events from the view component 
			resultScreen.addEventListener(ResultScreen.ON_TRY_AGAIN, onTryAgain);
			
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
				ApplicationFacade.ON_FINISH_TEST
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
				
				case ApplicationFacade.ON_FINISH_TEST:
					
					resultScreen.initialize();
					
					break;
			}
		}
		
		private function onTryAgain(evt:Event):void{
			
			this.dataProxy.resetValues();
			
			this.sendNotification(ApplicationFacade.CONFIG_SCREEN_ADDED);
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
		 * @return stage the viewComponent cast to ResultScreen
		 */
		protected function get resultScreen():ResultScreen
		{
			return viewComponent as ResultScreen;
		}
		
		private var dataProxy:DataProxy;
	}
}
/*
By Linto K Antony <lintoka123@gmail.com>
*/
package com.linto.dtengine.controller
{
	import flash.display.Stage;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import com.linto.dtengine.ApplicationFacade;
	import com.linto.dtengine.model.DataProxy;
	
	public class LoadDataCommand extends SimpleCommand implements ICommand
	{
		
		private var dataProxy:DataProxy;
		
		override public function execute( note:INotification ) : void{

			// Retrieve reference to frequently consulted Proxies
			dataProxy = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
			
			dataProxy.loadData(note.getBody() as String);
		}
	}
}
/*
By Linto K Antony <lintoka123@gmail.com>
*/
package com.linto.dtengine.controller
{
	import com.linto.dtengine.ApplicationFacade;
	import com.linto.dtengine.model.ConfigProxy;
	
	import flash.display.Stage;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadConfigCommand extends SimpleCommand implements ICommand
	{
		
		private var configProxy:ConfigProxy;
		
		override public function execute( note:INotification ) : void{
			
			// Registering Proxies 
			facade.registerProxy(new ConfigProxy());
			
			
			// Retrieve reference to frequently consulted Proxies
			configProxy = facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy;
			configProxy.loadUrl = note.getBody() as String;
			
			configProxy.loadData();

		}
	}
}
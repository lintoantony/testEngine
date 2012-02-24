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

    public class SendDataCommand extends SimpleCommand implements ICommand
    {

        override public function execute( note:INotification ) : void{
			//sendNotification( ApplicationFacade.STAGE_ADD_SPRITE );
        }
    }
}
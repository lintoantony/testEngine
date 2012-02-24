//LINTO
package com.linto.utils {
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SoundEffects {
	
	
		protected static var singleton:SoundEffects;
		private var holder:Sprite;
		private var soundEffectsEnabled:Boolean = true;
		
		private var muteButton:MuteButton;
			
		private var correctVoice:CorrectVoice;
		private var wrongVoice:WrongVoice;

		// SoundChannel objects for each sound - for stoping each sound seperately when required
		private var correctVoiceChannel:SoundChannel;
		private var wrongVoiceChannel:SoundChannel;
		

		/**
		 * this.singleton constructor.  Can only be called by the static getInstance method.
		 * 
		 * @param caller	The function to call the constructor function
		 */
		public function SoundEffects( holder:Sprite, caller:Function = null )	{	
            if( caller != SoundEffects.getInstance )
                throw new Error ( "this.singleton is a singleton class, use getInstance() instead" );
            if ( SoundEffects.singleton != null )
                throw new Error( "Only one this.singleton instance should be instantiated" );	
			this.holder = holder;
			init();
		}

        
		/**
         * Creates a new instance of SoundEffects if one does not currently exist.
         * 
         * @return SoundEffects
         */
        public static function getInstance( holder:Sprite ):SoundEffects {	
            if ( singleton == null ) singleton = new SoundEffects( holder, arguments.callee );
            return singleton;   
        }
		
		private function init():void {
			//this.initMuteButton();
			this.initSounds();
		}
		public function setMuteButPos(xPos:Number, yPos:Number):void{
			muteButton.x = xPos;
			muteButton.y = yPos;
		}
		public function initMuteButton(muteHolder:MovieClip):void{
			this.muteButton = new MuteButton();
			this.muteButton.name = "muteButton";
			muteButton.gotoAndStop(1);
			muteButton.buttonMode = true;
			muteButton.addEventListener(MouseEvent.CLICK, onMuteClick, false, 0, true);
			muteHolder.addChild(muteButton);
		}

		public function showMuteButton(isVisible:Boolean):void{
			this.muteButton.visible = isVisible;
		}
		
		private function onMuteClick(evt:MouseEvent):void{
			switch(this.soundEffectsEnabled){
				case true:
					evt.target.gotoAndStop(2);
					this.soundEffectsEnabled = false;
					break;
				case false:
					evt.target.gotoAndStop(1);
					this.soundEffectsEnabled = true;
					break;
			}
		}
		
		private function initSounds():void{
			correctVoice = new CorrectVoice();
			wrongVoice = new WrongVoice();
		}			

		public function playSound(id:String):void{
			if(this.soundEffectsEnabled == true){
				var thisSound:Sound;
				switch(id){
					case "CORRECT_VOICE":
						thisSound = correctVoice;
						this.correctVoiceChannel = thisSound.play(0, 0);
						break;
					case "WRONG_VOICE":
						thisSound = wrongVoice;
						this.wrongVoiceChannel = thisSound.play(0, 0);
						break;
					default:
						break;
				}
			}
		}
		public function stopSound(id:String):void{
			if(this.soundEffectsEnabled == true){

				switch(id){
					case "CORRECT_VOICE":
						if(this.correctVoiceChannel != null){
							this.correctVoiceChannel.stop();
						}
						break;
					case "WRONG_VOICE":
						if(this.wrongVoiceChannel != null){
							this.wrongVoiceChannel.stop();
						}
						break;
					default:
						break;
				}
			}
		}
	}
}
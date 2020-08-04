package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class FPSMeter extends Component
   {
       
      
      protected var _label:Label;
      
      protected var _startTime:int;
      
      protected var _frames:int;
      
      protected var _prefix:String = "";
      
      protected var _fps:int = 0;
      
      public function FPSMeter(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "FPS:")
      {
         super(param1,param2,param3);
         _prefix = param4;
         _frames = 0;
         _startTime = getTimer();
         setSize(50,20);
         if(stage != null)
         {
            addEventListener("enterFrame",onEnterFrame);
         }
         addEventListener("removedFromStage",onRemovedFromStage);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         _label = new Label(this,0,0);
      }
      
      override public function draw() : void
      {
         _label.text = _prefix + _fps.toString();
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         _frames = Number(_frames) + 1;
         var _loc3_:int = getTimer();
         var _loc2_:int = _loc3_ - _startTime;
         if(_loc2_ >= 1000)
         {
            _fps = Math.round(_frames * 1000 / _loc2_);
            _frames = 0;
            _startTime = _loc3_;
            draw();
         }
      }
      
      protected function onRemovedFromStage(param1:Event) : void
      {
         stop();
      }
      
      public function stop() : void
      {
         removeEventListener("enterFrame",onEnterFrame);
      }
      
      public function start() : void
      {
         addEventListener("enterFrame",onEnterFrame);
      }
      
      public function set prefix(param1:String) : void
      {
         _prefix = param1;
      }
      
      public function get prefix() : String
      {
         return _prefix;
      }
      
      public function get fps() : int
      {
         return _fps;
      }
   }
}

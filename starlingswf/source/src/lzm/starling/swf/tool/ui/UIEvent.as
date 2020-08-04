package lzm.starling.swf.tool.ui
{
   import flash.events.Event;
   
   public class UIEvent extends Event
   {
       
      
      public var data:Object;
      
      public function UIEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

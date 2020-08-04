package lzm.starling.swf.tool.ui
{
   import com.bit101.components.PushButton;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import lzm.starling.swf.tool.utils.WebUtils;
   
   public class UpdateUi extends BaseUI
   {
       
      
      private var _mustUpdte:Boolean;
      
      public function UpdateUi(param1:Boolean)
      {
         super();
         _mustUpdte = param1;
         loadUi("update.xml");
      }
      
      override protected function loadXMLComplete(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         x = (stage.stageWidth - width) / 2;
         y = (stage.stageHeight - height) / 2;
         if(_mustUpdte)
         {
            _loc3_ = uiConfig.getCompById("noBtn") as PushButton;
            _loc3_.parent.removeChild(_loc3_);
            _loc2_ = uiConfig.getCompById("yesBtn") as PushButton;
            _loc2_.label = "更新";
         }
      }
      
      public function onYes(param1:Event) : void
      {
      }
      
      public function onNo(param1:Event) : void
      {
         onClose(null);
      }
      
      public function onClose(param1:Event) : void
      {
         parent.removeChild(this);
      }
   }
}

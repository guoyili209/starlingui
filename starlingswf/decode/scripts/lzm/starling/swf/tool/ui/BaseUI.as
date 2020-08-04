package lzm.starling.swf.tool.ui
{
   import com.bit101.utils.MinimalConfigurator;
   import flash.display.Sprite;
   import flash.events.Event;
   import lzm.ToolConstant;
   
   public class BaseUI extends Sprite
   {
       
      
      protected var uiConfig:MinimalConfigurator;
      
      public function BaseUI()
      {
         super();
      }
      
      public function loadUi(param1:String) : void
      {
         uiConfig = new MinimalConfigurator(this);
         uiConfig.loadXML("assets/ui/" + ToolConstant.language + "/" + param1);
         uiConfig.addEventListener("complete",loadXMLComplete);
      }
      
      protected function loadXMLComplete(param1:Event) : void
      {
      }
   }
}

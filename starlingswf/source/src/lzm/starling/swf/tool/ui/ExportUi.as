package lzm.starling.swf.tool.ui
{
   import com.bit101.components.CheckBox;
   import com.bit101.components.ComboBox;
   import com.bit101.components.InputText;
   import com.bit101.components.NumericStepper;
   import com.bit101.components.Window;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filesystem.File;
   import lzm.starling.STLConstant;
   import lzm.util.LSOManager;
   
   public class ExportUi extends BaseUI
   {
       
      
      private var _window:Window;
      
      private var _exportScale:NumericStepper;
      
      private var _isMerger:CheckBox;
      
      private var _isBat:CheckBox;
      
      private var _paddingValue:NumericStepper;
      
      private var _isMergerBigImage:CheckBox;
      
      private var _isAnySize:CheckBox;
      
      private var _bigImageWidth:InputText;
      
      private var _bigImageHeight:InputText;
      
      private var _exportPlatform:ComboBox;
      
      private var _bgSprite:Sprite;
    
       public function ExportUi()
       {
           super();
           addEventListener("addedToStage",addToStage);
           loadUi("export.xml");
       }
      
      private var _exportPath:String;
      
      override protected function loadXMLComplete(param1:Event) : void
      {
         _window = uiConfig.getCompById("window") as Window;
         _exportScale = uiConfig.getCompById("exportScale") as NumericStepper;
         _isMerger = uiConfig.getCompById("isMerger") as CheckBox;
         _isBat = uiConfig.getCompById("isBat") as CheckBox;
         _paddingValue = uiConfig.getCompById("paddingValue") as NumericStepper;
         _isMergerBigImage = uiConfig.getCompById("isMergerBigImage") as CheckBox;
         _isAnySize = uiConfig.getCompById("isAnySize") as CheckBox;
         _bigImageWidth = uiConfig.getCompById("bigImageWidth") as InputText;
         _bigImageHeight = uiConfig.getCompById("bigImageHeight") as InputText;
         _exportPlatform = uiConfig.getCompById("exportPlatform") as ComboBox;
         _exportPlatform.items = ["Starling","Egret"];
         _exportPlatform.selectedIndex = 0;
         _bgSprite = new Sprite();
         _bgSprite.graphics.beginFill(0,0.7);
         _bgSprite.graphics.drawRect(0,0,100,100);
         _bgSprite.graphics.endFill();
         addChildAt(_bgSprite,0);
      }
      
      private function addToStage(param1:Event) : void
      {
         _bgSprite.width = stage.stageWidth;
         _bgSprite.height = stage.stageHeight;
         _window.x = (_bgSprite.width - _window.width) / 2;
         _window.y = _bgSprite.height * 0.2;
      }
      
      public function onClose(param1:Event) : void
      {
         parent.removeChild(this);
      }
      
      public function onExport(param1:Event) : void
      {
         var _loc3_:String = LSOManager.get("oldExportPath");
         var _loc2_:File = _loc3_ == null?new File():new File(_loc3_);
         _loc2_.browseForDirectory("输出路径");
         _loc2_.addEventListener("select",selectExportPathOk);         
      }
      
      private function selectExportPathOk(param1:Event) : void
      {
         var _loc2_:File = param1.target as File;
         _loc2_.removeEventListener("select",selectExportPathOk);
         _exportPath = _loc2_.url;
         dispatchEvent(new Event("export"));
         onClose(null);         
      }
      
      
      public function get isMerger() : Boolean
      {
         return _isMerger.selected;
      }
      
      public function get isBat() : Boolean
      {
         return _isBat.selected;
      }
      
      public function get isMergerBigImage() : Boolean
      {
         return _isMergerBigImage.selected;
      }
      
      public function get isAnySize() : Boolean
      {
         return _isAnySize.selected;
      }
      
      public function get exportScale() : int
      {
         return _exportScale.value;
      }
      
      public function get padding() : int
      {
         return _paddingValue.value;
      }
      
      public function get exportPath() : String
      {
         return _exportPath;
      }
      
      public function get bigImageWidth() : int
      {
         return int(_bigImageWidth.text);
      }
      
      public function get bigImageHeight() : int
      {
         return int(_bigImageHeight.text);
      }
      
      public function get format() : String
      {
         return _exportPlatform.selectedItem as String;
      }
   }
}

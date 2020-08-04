package lzm.atf.tool
{
   import com.bit101.components.CheckBox;
   import com.bit101.components.HUISlider;
   import com.bit101.components.InputText;
   import com.bit101.components.PushButton;
   import com.bit101.components.TextArea;
   import com.bit101.utils.MinimalConfigurator;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filesystem.File;
   import flash.utils.setTimeout;
   import lzm.ToolConstant;
   import lzm.atf.tool.utils.OSUtil;
   
   public class UIPanel extends Sprite
   {
       
      
      private var _config:MinimalConfigurator;
      
      private var _platform:Array;
      
      private var _platformIndex:int = 3;
      
      private var _logTextArea:TextArea;
      
      public function UIPanel()
      {
         _platform = ["p","d","e",""];
         super();
         _config = new MinimalConfigurator(this);
         _config.loadXML("assets/atftool/" + ToolConstant.language + "/" + "ATFToolUI.xml");
         _config.addEventListener("complete",loadXmlComplete);
      }
      
      private function loadXmlComplete(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _config.getCompById("p" + _loc2_).addEventListener("click",onSelectPlatform(_loc2_));
            _loc2_++;
         }
         _logTextArea = _config.getCompById("logs") as TextArea;
         _logTextArea.editable = false;
      }
      
      public function onSelectSource(param1:MouseEvent) : void
      {
         var _loc2_:File = new File();
         _loc2_.browseForDirectory("选择源路径");
         _loc2_.addEventListener("select",selectSourceComplete);
      }
      
      private function selectSourceComplete(param1:Event) : void
      {
         var _loc2_:File = param1.target as File;
         _loc2_.removeEventListener("select",selectSourceComplete);
         if(OSUtil.isMac())
         {
            sourceDir = _loc2_.nativePath + "/";
         }
         else if(OSUtil.isWindows())
         {
            sourceDir = _loc2_.nativePath + "\\";
         }
      }
      
      public function onSelectExport(param1:MouseEvent) : void
      {
         var _loc2_:File = new File();
         _loc2_.browseForDirectory("选择输出路径");
         _loc2_.addEventListener("select",selectExportComplete);
      }
      
      private function selectExportComplete(param1:Event) : void
      {
         var _loc2_:File = param1.target as File;
         _loc2_.removeEventListener("select",selectExportComplete);
         if(OSUtil.isMac())
         {
            exportDir = _loc2_.nativePath + "/";
         }
         else if(OSUtil.isWindows())
         {
            exportDir = _loc2_.nativePath + "\\";
         }
      }
      
      public function onExport(param1:MouseEvent) : void
      {
         if(exportDir == "" || sourceDir == "")
         {
            return;
         }
         dispatchEvent(new Event("Export"));
      }
      
      private function onSelectPlatform(param1:int) : Function
      {
         index = param1;
         return function(param1:MouseEvent):void
         {
            _platformIndex = index;
         };
      }
      
      public function set sourceDir(param1:String) : void
      {
         (_config.getCompById("sourceDir") as InputText).text = param1;
      }
      
      public function get sourceDir() : String
      {
         return (_config.getCompById("sourceDir") as InputText).text;
      }
      
      public function set exportDir(param1:String) : void
      {
         (_config.getCompById("exportDir") as InputText).text = param1;
      }
      
      public function get exportDir() : String
      {
         return (_config.getCompById("exportDir") as InputText).text;
      }
      
      public function get platform() : String
      {
         return _platform[_platformIndex];
      }
      
      public function get compress() : Boolean
      {
         return (_config.getCompById("compress") as CheckBox).selected;
      }
      
      public function get mips() : Boolean
      {
         return (_config.getCompById("mips") as CheckBox).selected;
      }
      
      public function get mergerXml() : Boolean
      {
         return (_config.getCompById("merger") as CheckBox).selected;
      }
      
      public function get quality() : int
      {
         return (_config.getCompById("quality") as HUISlider).value;
      }
      
      public function get to_square() : Boolean
      {
         return (_config.getCompById("to_square") as CheckBox).selected;
      }
      
      public function get copy_configs() : Boolean
      {
         return (_config.getCompById("copy_configs") as CheckBox).selected;
      }
      
      public function get converChilds() : Boolean
      {
         return (_config.getCompById("converChilds") as CheckBox).selected;
      }
      
      public function log(param1:String) : void
      {
         text = param1;
         _logTextArea.text = _logTextArea.text + text;
      }
      
      public function clearLogs() : void
      {
         _logTextArea.text = "";
      }
      
      public function set exportBtnEnabled(param1:Boolean) : void
      {
         (_config.getCompById("export") as PushButton).enabled = param1;
      }
   }
}

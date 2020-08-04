package lzm.starling.swf.tool.ui
{
   import com.bit101.components.CheckBox;
   import com.bit101.components.ColorChooser;
   import com.bit101.components.ComboBox;
   import com.bit101.components.HUISlider;
   import com.bit101.components.InputText;
   import com.bit101.components.Label;
   import com.bit101.components.PushButton;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.net.FileFilter;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.setTimeout;
   import lzm.atf.tool.ATFTool;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.tool.asset.Assets;
   import lzm.starling.swf.tool.utils.ExportUtil;
   import lzm.starling.swf.tool.utils.ImageUtil;
   import lzm.starling.swf.tool.utils.SysUtils;
   import lzm.starling.swf.tool.utils.Util;
   import lzm.starling.swf.tool.utils.WebUtils;
   import lzm.util.LSOManager;
   import starling.core.Starling;
   import starling.textures.Texture;
   
   public class MainUi extends BaseUI
   {
       
      
      private var _compNames:Array;
      
      private var _compSelectEvents:Array;
      
      private var _comps:Array;
      
      private var _selectSwfSource:PushButton;
      
      private var _refreshSwfSource:PushButton;
      
      private var _switchSwfComboBox:ComboBox;
      
      private var _compNamesComboBox:ComboBox;
      
      private var _compsComboBox:ComboBox;
      
      private var _bgColorChooser:ColorChooser;
      
      private var _fpsValue:HUISlider;
      
      private var _exportBtn:PushButton;
      
      private var _exportOption:ExportUi;
      
      private var _selectFiles:Array;
      
      private var _selectFileNames:Array;
      
      private var _atfTool:ATFTool;
      
      public function MainUi()
      {
         _compNames = ["Image","Sprite","MovieClip","Button","S9Image","ShapeImage","Component","Particle"];
         _compSelectEvents = ["selectImage","selectSprite","selectMovieClip","selectButton","selectScale9","selectShapeImage","selectComponents","selectParticle"];
         super();
         _exportOption = new ExportUi();
         _exportOption.addEventListener("export",export);
         loadUi("main.xml");
      }
      
      override protected function loadXMLComplete(param1:Event) : void
      {
         _selectSwfSource = uiConfig.getCompById("selectSwfSource") as PushButton;
         _refreshSwfSource = uiConfig.getCompById("refreshSwfSource") as PushButton;
         _switchSwfComboBox = uiConfig.getCompById("switchSwf") as ComboBox;
         _compNamesComboBox = uiConfig.getCompById("compNames") as ComboBox;
         _compsComboBox = uiConfig.getCompById("comps") as ComboBox;
         _bgColorChooser = uiConfig.getCompById("bgColor") as ColorChooser;
         _fpsValue = uiConfig.getCompById("fpsValue") as HUISlider;
         _fpsValue.value = 30;
         _exportBtn = uiConfig.getCompById("exportBtn") as PushButton;
         var _loc2_:PushButton = uiConfig.getCompById("openAlipay") as PushButton;
         _loc2_.labelComponent.textField.textColor = 16711680;
         (uiConfig.getCompById("versionText") as Label).text = "V" + SysUtils.version;
      }
      
      public function onSelectSwfSource(param1:Event) : void
      {
         var _loc3_:String = LSOManager.get("oldSelectFilesPath");
         var _loc2_:File = _loc3_ == null?new File():new File(_loc3_);
         _loc2_.browseForOpenMultiple("选择swf",[new FileFilter("Flash","*.swf")]);
         _loc2_.addEventListener("selectMultiple",selectSwfOK);
      }
      
      private function selectSwfOK(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc4_:int = 0;
         param1.target.removeEventListener("select",selectSwfOK);
         _selectFiles = param1["files"];
         _selectFileNames = [];
         var _loc3_:int = _selectFiles.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _selectFiles[_loc4_];
            _selectFileNames.push(_loc2_.name.split(".")[0]);
            _loc4_++;
         }
         LSOManager.put("oldSelectFilesPath",_loc2_.parent.url);
         _switchSwfComboBox.enabled = true;
         _switchSwfComboBox.items = _selectFileNames;
         _switchSwfComboBox.selectedIndex = 0;
      }
      
      private function loadSwf() : void
      {
         Loading.instance.show();
         var _loc1_:Loader = new Loader();
         _loc1_.contentLoaderInfo.addEventListener("complete",loadSwfComplete);
         _loc1_.load(new URLRequest(currentSelectFileUrl));
      }
      
      private function loadSwfComplete(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc5_:int = 0;
         Loading.instance.hide();
         Util.swfScale = Number((uiConfig.getCompById("swfScale") as InputText).text);
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         _loc2_.removeEventListener("complete",loadSwfComplete);
         _refreshSwfSource.enabled = true;
         _exportBtn.enabled = true;
         _fpsValue.enabled = true;
         Assets.init();
         Assets.swfUtil.parse(_loc2_.content.loaderInfo.applicationDomain);
         Assets.swf = new Swf(Assets.swfUtil.getSwfData(),Assets.asset,_fpsValue.value);
         var _loc4_:int = Assets.swfUtil.exportImages.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = Assets.swfUtil.exportImages[_loc5_];
            Assets.asset.addTexture(_loc3_,Texture.fromBitmapData(ImageUtil.getBitmapdata(Assets.swfUtil.getClass(_loc3_),1)));
            _loc5_++;
         }
         Assets.swfUtil.imageNames.sort();
         Assets.swfUtil.spriteNames.sort();
         Assets.swfUtil.movieClipNames.sort();
         Assets.swfUtil.buttonNames.sort();
         Assets.swfUtil.s9Names.sort();
         Assets.swfUtil.shapeImgNames.sort();
         Assets.swfUtil.componentNames.sort();
         Assets.swfUtil.particleNames.sort();
         _comps = [Assets.swfUtil.imageNames,Assets.swfUtil.spriteNames,Assets.swfUtil.movieClipNames,Assets.swfUtil.buttonNames,Assets.swfUtil.s9Names,Assets.swfUtil.shapeImgNames,Assets.swfUtil.componentNames,Assets.swfUtil.particleNames];
         _compNamesComboBox.enabled = true;
         _compNamesComboBox.selectedIndex = -1;
         _compNamesComboBox.items = _compNames;
         _compsComboBox.items = [];
         _compsComboBox.selectedIndex = -1;
         _compsComboBox.enabled = false;
         _loc2_.loader.unloadAndStop();
      }
      
      public function onRefreshSwfSource(param1:Event) : void
      {
         dispatchEvent(new UIEvent("onRefresh"));
         loadSwf();
      }
      
      public function onSwitchSwf(param1:Event) : void
      {
         e = param1;
         Assets.openTempFile(currentSelectFileUrl,function():void
         {
            onRefreshSwfSource(null);
         });
      }
      
      public function onAddCustomComponents(param1:Event) : void
      {
         var _loc3_:String = LSOManager.get("oldComponentsPath");
         var _loc2_:File = _loc3_ == null?new File():new File(_loc3_);
         _loc2_.browseForOpenMultiple("选择swf",[new FileFilter("Flash","*.swf")]);
         _loc2_.addEventListener("selectMultiple",addCustomComponentsOK);
      }
      
      private function addCustomComponentsOK(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         param1.target.removeEventListener("select",selectSwfOK);
         var _loc2_:Array = param1["files"];
         var _loc5_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc4_];
            _loc5_.push(_loc3_.url);
            _loc4_++;
         }
         LSOManager.put("oldComponentsPath",_loc3_.parent.url);
         Assets.componentsAsset.addComponents(_loc5_);
      }
      
      public function onSelectCompName(param1:Event) : void
      {
         if(_compNamesComboBox.selectedIndex == -1)
         {
            return;
         }
         var _loc3_:int = _compNamesComboBox.selectedIndex;
         var _loc2_:Array = _comps[_loc3_];
         _compsComboBox.selectedIndex = -1;
         if(_loc2_.length > 0)
         {
            _compsComboBox.items = _loc2_;
            _compsComboBox.enabled = true;
         }
         else
         {
            _compsComboBox.items = [];
            _compsComboBox.enabled = false;
         }
      }
      
      public function onSelectComp(param1:Event) : void
      {
         var _loc2_:* = null;
         if(_compsComboBox.selectedItem)
         {
            _loc2_ = new UIEvent(_compSelectEvents[_compNamesComboBox.selectedIndex]);
            _loc2_.data = {"name":_compsComboBox.selectedItem};
            dispatchEvent(_loc2_);
         }
      }
      
      public function onColorChange(param1:Event) : void
      {
         var _loc2_:* = _bgColorChooser.value;
         stage.color = _loc2_;
         Starling.current.stage.color = _loc2_;
      }
      
      public function onIsDrag(param1:Event) : void
      {
         var _loc2_:UIEvent = new UIEvent("onIsDrag");
         _loc2_.data = {"value":(uiConfig.getCompById("isDrag") as CheckBox).selected};
         dispatchEvent(_loc2_);
      }
      
      public function onFpsChange(param1:Event) : void
      {
         Assets.swf.fps = _fpsValue.value;
      }
      
      public function onOpenTutorials(param1:Event) : void
      {
      }
      
      public function onOpenMoney(param1:Event) : void
      {
      }
      
      public function onOpenAlipay(param1:Event) : void
      {
      }
      
      public function onExportBtn(param1:Event) : void
      {
         stage.addChild(_exportOption);
      }
      
      private function get currentSelectFileName() : String
      {
         return _selectFileNames[_switchSwfComboBox.selectedIndex];
      }
      
      private function get currentSelectFileUrl() : String
      {
         return _selectFiles[_switchSwfComboBox.selectedIndex].url;
      }
      
      private function get currentSelectFile() : File
      {
         return _selectFiles[_switchSwfComboBox.selectedIndex];
      }
      
      private function export(param1:Event) : void
      {
         e = param1;
         exportOver = function():void
         {
            Assets.openTempFile(currentSelectFile.url,function():void
            {
               Loading.instance.hide();
            });
         };
         Loading.instance.show();
         Util.swfScale = Number((uiConfig.getCompById("swfScale") as InputText).text);
      }
      
      public function onOpenAtfTool(param1:Event) : void
      {
         if(_atfTool == null)
         {
            _atfTool = new ATFTool();
         }
         addChild(_atfTool);
      }
   }
}

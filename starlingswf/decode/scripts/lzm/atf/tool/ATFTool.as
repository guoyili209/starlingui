package lzm.atf.tool
{
   import com.bit101.components.Window;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import lzm.ToolConstant;
   import lzm.atf.tool.utils.BitmapUtil;
   import lzm.atf.tool.utils.MergerUtil;
   import lzm.atf.tool.utils.png2atfUtil;
   import lzm.starling.STLConstant;
   
   public class ATFTool extends Sprite
   {
       
      
      private var ui:UIPanel;
      
      private var sourceDir:String;
      
      private var exportDir:String;
      
      private var platform:String;
      
      private var compress:Boolean;
      
      private var mips:Boolean;
      
      private var quality:int;
      
      private var to_square:Boolean;
      
      private var exportFiles:Vector.<File>;
      
      private var _bgSprite:Sprite;
      
      private var _window:Window;
      
      private var sourceFile:String;
      
      private var exportFile:String;
      
      private var reImageBytes:ByteArray;
      
      private var reFile:File;
      
      public function ATFTool()
      {
         super();
         _bgSprite = new Sprite();
         _bgSprite.graphics.beginFill(0,0.7);
         _bgSprite.graphics.drawRect(0,0,100,100);
         _bgSprite.graphics.endFill();
         addChild(_bgSprite);
         _window = new Window(this,0,0,"ATF导出工具");
         _window.hasCloseButton = true;
         _window.width = 500;
         if(ToolConstant.language == "en")
         {
            _window.width = 540;
         }
         _window.height = 434;
         _window.addEventListener("close",onClose);
         ui = new UIPanel();
         ui.addEventListener("Export",onExport);
         _window.addChild(ui);
         addEventListener("addedToStage",addToStage);
      }
      
      private function addToStage(param1:Event) : void
      {
         _bgSprite.width = stage.stageWidth;
         _bgSprite.height = stage.stageHeight;
         _window.x = (_bgSprite.width - _window.width) / 2;
         _window.y = _bgSprite.height * 0.2;
         STLConstant.currnetAppRoot.touchable = false;
      }
      
      private function onClose(param1:Event) : void
      {
         parent.removeChild(this);
         STLConstant.currnetAppRoot.touchable = true;
      }
      
      private function onExport(param1:Event) : void
      {
         e = param1;
         ui.exportBtnEnabled = false;
         sourceDir = ui.sourceDir;
         exportDir = ui.exportDir;
         platform = ui.platform;
         compress = ui.compress;
         mips = ui.mips;
         quality = ui.quality;
         to_square = ui.to_square;
         exportFiles = new Vector.<File>();
         ergodicDirectory(new File(sourceDir));
         ui.clearLogs();
         ui.log("开始导出ATF...\n");
         ui.log("总共选择了" + exportFiles.length + "个文件.\n");
         if(exportFiles.length == 0)
         {
            ui.log("导出完毕.\n");
            ui.exportBtnEnabled = true;
         }
         else
         {
            setTimeout(function():void
            {
               startExport(exportFiles.pop());
            },600);
         }
      }
      
      private function ergodicDirectory(param1:File) : void
      {
         var _loc2_:* = null;
         var _loc6_:int = 0;
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc7_:Array = param1.getDirectoryListing();
         var _loc4_:int = _loc7_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc2_ = _loc7_[_loc6_];
            if(_loc2_.isDirectory && ui.converChilds)
            {
               createDir(_loc2_);
               ergodicDirectory(_loc2_);
            }
            else if(_loc2_.extension != "png" && _loc2_.extension != "jpg")
            {
               if(_loc2_.extension == "xml" && ui.mergerXml)
               {
                  _loc3_ = new File(_loc2_.nativePath.replace(".xml",".png"));
                  _loc5_ = new File(_loc2_.nativePath.replace(".xml",".jpg"));
                  if(_loc3_.exists || _loc5_.exists)
                  {
                     copyFile(_loc2_);
                  }
               }
               else if(ui.copy_configs)
               {
                  copyFile(_loc2_);
               }
            }
            else
            {
               exportFiles.push(_loc2_);
            }
            _loc6_++;
         }
      }
      
      private function createDir(param1:File) : void
      {
         var _loc3_:String = param1.nativePath.replace(sourceDir,exportDir);
         var _loc2_:File = new File(_loc3_);
         if(!_loc2_.exists)
         {
            _loc2_.createDirectory();
         }
      }
      
      private function copyFile(param1:File) : void
      {
         var _loc3_:String = param1.nativePath.replace(sourceDir,exportDir);
         var _loc2_:File = new File(_loc3_);
         if(!_loc2_.exists)
         {
            param1.copyTo(_loc2_,true);
         }
      }
      
      private function startExport(param1:File) : void
      {
         file = param1;
         converCallBack = function(param1:ByteArray, param2:File):void
         {
            b = param1;
            f = param2;
            converAtfCallBack = function():void
            {
               var _loc1_:* = null;
               var _loc3_:* = null;
               var _loc2_:* = null;
               if(reImageBytes)
               {
                  _loc1_ = new FileStream();
                  _loc1_.open(reFile,"write");
                  _loc1_.writeBytes(reImageBytes);
                  _loc1_.close();
               }
               if(ui.mergerXml)
               {
                  _loc3_ = exportFile.replace(".atf",".xml");
                  _loc2_ = new File(_loc3_);
                  if(_loc2_.exists)
                  {
                     MergerUtil.mergerAtf_Xml(new File(exportFile),_loc2_);
                  }
               }
               if(exportFiles.length > 0)
               {
                  startExport(exportFiles.pop());
               }
               else
               {
                  ui.log("导出完毕.\n");
                  ui.exportBtnEnabled = true;
               }
            };
            reImageBytes = b;
            reFile = f;
            sourceFile = file.nativePath;
            exportFile = sourceFile.replace(sourceDir,exportDir);
            exportFile = exportFile.replace("." + file.extension,".atf");
            png2atfUtil.converAtf(sourceDir,sourceFile,exportFile,platform,compress,mips,quality,converAtfCallBack,logCallBack);
         };
         logCallBack = function(param1:String):void
         {
            ui.log(param1);
         };
         ui.log("\n" + file.name + "开始导出...剩余:" + exportFiles.length + "个文件...\n");
         BitmapUtil.converBitmapToPowerOf2(file,to_square,converCallBack,logCallBack);
         reImageBytes = null;
         reFile = null;
      }
   }
}

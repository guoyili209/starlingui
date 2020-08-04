package lzm.starling
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import lzm.util.Mobile;
   import starling.core.Starling;
   import starling.utils.RectangleUtil;
   
   public class STLStarup extends Sprite
   {
       
      
      protected var _statusBarHeight:Number = 0;
      
      protected var _mStarling:Starling;
      
      public function STLStarup()
      {
         super();
      }
      
      protected function initStarlingWithWH(param1:Class, param2:int, param3:int, param4:int = 480, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:String = "auto") : void
      {
         mainClass = param1;
         width = param2;
         height = param3;
         HDWidth = param4;
         debug = param5;
         isPc = param6;
         pullUp = param7;
         stage3DProfile = param8;
         STLConstant.nativeStage = stage;
         STLConstant.StageWidth = width;
         STLConstant.StageHeight = height;
         Starling.handleLostContext = !Mobile.isIOS();
         var stageFullScreenWidth:Number = !!isPc?stage.stageWidth:stage.fullScreenWidth;
         var stageFullScreenHeight:Number = !!isPc?stage.stageHeight:stage.fullScreenHeight;
         if(pullUp)
         {
            var viewPort:Rectangle = new Rectangle(0,0,stageFullScreenWidth,stageFullScreenHeight);
         }
         else
         {
            viewPort = RectangleUtil.fit(new Rectangle(0,0,width,height),new Rectangle(0,0,stageFullScreenWidth,stageFullScreenHeight),"showAll");
         }
         viewPort.y = _statusBarHeight;
         viewPort.height = viewPort.height - _statusBarHeight;
         STLConstant.scale = viewPort.width > HDWidth?2:1;
         _mStarling = new Starling(STLRootClass,stage,viewPort,null,"auto",stage3DProfile);
         _mStarling.antiAliasing = 0;
         _mStarling.stage.stageWidth = width;
         _mStarling.stage.stageHeight = height;
         _mStarling.enableErrorChecking = Capabilities.isDebugger;
         _mStarling.addEventListener("rootCreated",function():*
         {
            var /*UnknownSlot*/:* = function(param1:Object, param2:STLRootClass):void
            {
               STLConstant.currnetAppRoot = param2;
               _mStarling.removeEventListener("rootCreated",onRootCreated);
               _mStarling.start();
               if(debug)
               {
                  _mStarling.showStatsAt("right");
               }
               param2.start(mainClass);
            };
            return function(param1:Object, param2:STLRootClass):void
            {
               STLConstant.currnetAppRoot = param2;
               _mStarling.removeEventListener("rootCreated",onRootCreated);
               _mStarling.start();
               if(debug)
               {
                  _mStarling.showStatsAt("right");
               }
               param2.start(mainClass);
            };
         }());
         trace("handleLostContext:" + Starling.handleLostContext);
         trace("Scale:" + STLConstant.scale);
         trace("StageWidth:" + STLConstant.StageWidth);
      }
      
      protected function initStarling(param1:Class, param2:int = 480, param3:Boolean = false, param4:Boolean = false, param5:String = "auto") : void
      {
         mainClass = param1;
         HDWidth = param2;
         debug = param3;
         isPc = param4;
         stage3DProfile = param5;
         STLConstant.nativeStage = stage;
         Starling.handleLostContext = !Mobile.isIOS();
         var viewPort:Rectangle = new Rectangle(0,0,!!isPc?stage.stageWidth:stage.fullScreenWidth,!!isPc?stage.stageHeight:stage.fullScreenHeight);
         viewPort.y = _statusBarHeight;
         viewPort.height = viewPort.height - _statusBarHeight;
         STLConstant.scale = viewPort.width > HDWidth?2:1;
         STLConstant.StageWidth = viewPort.width * (1 / STLConstant.scale);
         STLConstant.StageHeight = viewPort.height * (1 / STLConstant.scale);
         _mStarling = new Starling(STLRootClass,stage,viewPort,null,"auto",stage3DProfile);
         _mStarling.antiAliasing = 0;
         _mStarling.stage.stageWidth = STLConstant.StageWidth;
         _mStarling.stage.stageHeight = STLConstant.StageHeight;
         _mStarling.enableErrorChecking = Capabilities.isDebugger;
         _mStarling.addEventListener("rootCreated",function():*
         {
            var /*UnknownSlot*/:* = function(param1:Object, param2:STLRootClass):void
            {
               STLConstant.currnetAppRoot = param2;
               _mStarling.removeEventListener("rootCreated",onRootCreated);
               _mStarling.start();
               if(debug)
               {
                  _mStarling.showStatsAt("right");
               }
               param2.start(mainClass);
            };
            return function(param1:Object, param2:STLRootClass):void
            {
               STLConstant.currnetAppRoot = param2;
               _mStarling.removeEventListener("rootCreated",onRootCreated);
               _mStarling.start();
               if(debug)
               {
                  _mStarling.showStatsAt("right");
               }
               param2.start(mainClass);
            };
         }());
         trace("handleLostContext:" + Starling.handleLostContext);
         trace("Scale:" + STLConstant.scale);
         trace("StageWidth:" + STLConstant.StageWidth);
      }
   }
}

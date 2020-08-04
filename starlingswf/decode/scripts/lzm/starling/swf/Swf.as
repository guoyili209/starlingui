package lzm.starling.swf
{
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import lzm.starling.swf.blendmode.SwfBlendMode;
   import lzm.starling.swf.components.ComponentConfig;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfParticleSyetem;
   import lzm.starling.swf.display.SwfScale9Image;
   import lzm.starling.swf.display.SwfShapeImage;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.filter.SwfFilter;
   import lzm.util.Clone;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.text.TextField;
   import starling.textures.Texture;
   import starling.utils.AssetManager;
   
   public class Swf
   {
      
      public static const dataKey_Sprite:String = "spr";
      
      public static const dataKey_Image:String = "img";
      
      public static const dataKey_MovieClip:String = "mc";
      
      public static const dataKey_TextField:String = "text";
      
      public static const dataKey_Button:String = "btn";
      
      public static const dataKey_Scale9:String = "s9";
      
      public static const dataKey_ShapeImg:String = "shapeImg";
      
      public static const dataKey_Component:String = "comp";
      
      public static const dataKey_Particle:String = "particle";
      
      public static const ANGLE_TO_RADIAN:Number = 0.017453292519943295;
      
      public static var starlingRoot:Sprite;
      
      private static var _isInit:Boolean = false;
       
      
      public var textureSmoothing:String = "bilinear";
      
      private const createFuns:Object = {
         "img":createImage,
         "spr":createSprite,
         "mc":createMovieClip,
         "text":createTextField,
         "btn":createButton,
         "s9":createS9Image,
         "shapeImg":createShapeImage,
         "comp":createComponent,
         "particle":createParticle
      };
      
      private var _assets:AssetManager;
      
      private var _swfDatas:Object;
      
      private var _swfUpdateManager:SwfUpdateManager;
      
      private var _passedTime:Number;
      
      private var _particleXML:Object;
      
      public function Swf(param1:ByteArray, param2:AssetManager, param3:int = 24)
      {
         super();
         if(!_isInit)
         {
            throw new Error("要使用Swf，请先调用Swf.init");
         }
         var _loc4_:ByteArray = Clone.clone(param1);
         _loc4_.uncompress();
         this._swfDatas = JSON.parse(new String(_loc4_));
         this._assets = param2;
         this._swfUpdateManager = new SwfUpdateManager(param3,starlingRoot);
         this._passedTime = 1000 / param3 * 0.001;
         this._particleXML = {};
         _loc4_.clear();
      }
      
      public static function init(param1:Sprite) : void
      {
         if(_isInit)
         {
            return;
         }
         _isInit = true;
         Swf.starlingRoot = param1;
      }
      
      public function get swfData() : Object
      {
         return _swfDatas;
      }
      
      public function get assets() : AssetManager
      {
         return _assets;
      }
      
      public function get swfUpdateManager() : SwfUpdateManager
      {
         return _swfUpdateManager;
      }
      
      public function set fps(param1:int) : void
      {
         _passedTime = 1000 / param1 * 0.001;
         _swfUpdateManager.fps = param1;
      }
      
      public function get fps() : int
      {
         return _swfUpdateManager.fps;
      }
      
      public function get passedTime() : Number
      {
         return _passedTime;
      }
      
      public function createDisplayObject(param1:String) : DisplayObject
      {
         var _loc2_:* = null;
         var _loc5_:int = 0;
         var _loc4_:* = createFuns;
         for(var _loc3_ in createFuns)
         {
            if(_swfDatas[_loc3_] && _swfDatas[_loc3_][param1])
            {
               _loc2_ = createFuns[_loc3_];
               return _loc2_(param1);
            }
         }
         return null;
      }
      
      public function hasSprite(param1:String) : Boolean
      {
         return _swfDatas["spr"][param1] != null;
      }
      
      public function createSprite(param1:String, param2:Array = null, param3:Array = null) : SwfSprite
      {
         var _loc8_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc9_:int = 0;
         if(param3 == null)
         {
            param3 = _swfDatas["spr"][param1];
         }
         var _loc5_:SwfSprite = new SwfSprite();
         var _loc4_:int = param3.length;
         _loc9_ = 0;
         while(_loc9_ < _loc4_)
         {
            _loc8_ = param3[_loc9_];
            _loc7_ = createFuns[_loc8_[1]];
            if(_loc7_ != null)
            {
               _loc6_ = _loc7_(_loc8_[0],_loc8_);
               _loc6_.name = _loc8_[9];
               if(_loc6_ is DisplayObject)
               {
                  _loc6_.x = _loc8_[2];
                  _loc6_.y = _loc8_[3];
                  if(_loc8_[1] != "s9" && _loc8_[1] != "shapeImg")
                  {
                     _loc6_.scaleX = _loc8_[4];
                     _loc6_.scaleY = _loc8_[5];
                  }
                  _loc6_.skewX = _loc8_[6] * 0.0174532925199433;
                  _loc6_.skewY = _loc8_[7] * 0.0174532925199433;
                  _loc6_.alpha = _loc8_[8];
                  if(_loc6_ is ISwfComponent && _loc8_[10] != null)
                  {
                     _loc6_.editableProperties = _loc8_[10];
                  }
                  _loc5_.addChild(_loc6_ as DisplayObject);
               }
               else if(_loc6_ is ISwfComponent)
               {
                  _loc5_.addComponent(_loc6_ as ISwfComponent);
               }
            }
            _loc9_++;
         }
         if(param2 != null)
         {
            _loc5_.filter = SwfFilter.createFilter(param2[10]);
            SwfBlendMode.setBlendMode(_loc5_,param2[11]);
         }
         _loc5_.data = param2;
         _loc5_.spriteData = param3;
         _loc5_.classLink = param1;
         return _loc5_;
      }
      
      public function hasMovieClip(param1:String) : Boolean
      {
         return _swfDatas["mc"][param1] != null;
      }
      
      public function createMovieClip(param1:String, param2:Array = null) : SwfMovieClip
      {
         var _loc3_:* = null;
         var _loc11_:* = null;
         var _loc8_:int = 0;
         var _loc10_:* = null;
         var _loc12_:int = 0;
         var _loc4_:Object = _swfDatas["mc"][param1];
         var _loc9_:Object = _loc4_["objCount"];
         var _loc6_:Object = {};
         var _loc14_:int = 0;
         var _loc13_:* = _loc9_;
         for(var _loc5_ in _loc9_)
         {
            _loc11_ = _loc9_[_loc5_][0];
            _loc8_ = _loc9_[_loc5_][1];
            _loc3_ = _loc6_[_loc5_] == null?[]:_loc6_[_loc5_];
            _loc12_ = 0;
            while(_loc12_ < _loc8_)
            {
               _loc10_ = createFuns[_loc11_];
               if(_loc10_ != null)
               {
                  _loc3_.push(_loc10_(_loc5_,null));
               }
               _loc12_++;
            }
            _loc6_[_loc5_] = _loc3_;
         }
         var _loc7_:SwfMovieClip = new SwfMovieClip(_loc4_["frames"],_loc4_["labels"],_loc6_,this,_loc4_["frameEvents"]);
         _loc7_.loop = _loc4_["loop"];
         if(param2 != null)
         {
            _loc7_.filter = SwfFilter.createFilter(param2[10]);
            SwfBlendMode.setBlendMode(_loc7_,param2[11]);
         }
         _loc7_.classLink = param1;
         return _loc7_;
      }
      
      public function hasImage(param1:String) : Boolean
      {
         return _swfDatas["img"][param1] != null;
      }
      
      public function createImage(param1:String, param2:Array = null) : SwfImage
      {
         var _loc4_:Texture = _assets.getTexture(param1);
         if(_loc4_ == null)
         {
            throw new Error("Texture \"" + param1 + "\" not exist");
         }
         var _loc3_:Array = _swfDatas["img"][param1];
         var _loc5_:SwfImage = new SwfImage(_loc4_);
         _loc5_.smoothing = textureSmoothing;
         _loc5_.pivotX = _loc3_[0];
         _loc5_.pivotY = _loc3_[1];
         if(param2 != null)
         {
            _loc5_.filter = SwfFilter.createFilter(param2[10]);
            SwfBlendMode.setBlendMode(_loc5_,param2[11]);
         }
         _loc5_.classLink = param1;
         return _loc5_;
      }
      
      public function hasButton(param1:String) : Boolean
      {
         return _swfDatas["btn"][param1] != null;
      }
      
      public function createButton(param1:String, param2:Array = null) : SwfButton
      {
         var _loc3_:Array = _swfDatas["btn"][param1];
         var _loc5_:Sprite = createSprite(null,null,_loc3_);
         var _loc4_:SwfButton = new SwfButton(_loc5_);
         if(param2 != null)
         {
            _loc4_.filter = SwfFilter.createFilter(param2[10]);
            SwfBlendMode.setBlendMode(_loc4_,param2[11]);
         }
         _loc4_.classLink = param1;
         return _loc4_;
      }
      
      public function hasS9Image(param1:String) : Boolean
      {
         return _swfDatas["s9"][param1] != null;
      }
      
      public function createS9Image(param1:String, param2:Array = null) : SwfScale9Image
      {
         var _loc4_:Array = _swfDatas["s9"][param1];
         var _loc3_:Texture = _assets.getTexture(param1);
         var _loc6_:Scale9Textures = new Scale9Textures(_loc3_,new Rectangle(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]));
         var _loc5_:SwfScale9Image = new SwfScale9Image(_loc6_,1);
         if(param2 != null)
         {
            _loc5_.width = param2[10];
            _loc5_.height = param2[11];
            _loc5_.filter = SwfFilter.createFilter(param2[12]);
            SwfBlendMode.setBlendMode(_loc5_,param2[13]);
         }
         _loc5_.classLink = param1;
         return _loc5_;
      }
      
      public function hasShapeImage(param1:String) : Boolean
      {
         return _swfDatas["shapeImg"][param1] != null;
      }
      
      public function createShapeImage(param1:String, param2:Array = null) : SwfShapeImage
      {
         var _loc3_:Array = _swfDatas["shapeImg"][param1];
         var _loc4_:SwfShapeImage = new SwfShapeImage(_assets.getTexture(param1));
         if(param2 != null)
         {
            _loc4_.setSize(param2[10],param2[11]);
            _loc4_.filter = SwfFilter.createFilter(param2[12]);
            SwfBlendMode.setBlendMode(_loc4_,param2[13]);
         }
         _loc4_.classLink = param1;
         return _loc4_;
      }
      
      public function createTextField(param1:String, param2:Array = null) : TextField
      {
         var _loc4_:* = null;
         var _loc3_:TextField = new TextField(2,2,"");
         if(param2 != null)
         {
            _loc3_.width = param2[10];
            _loc3_.height = param2[11];
            _loc3_.fontName = param2[12];
            _loc3_.color = param2[13];
            _loc3_.fontSize = param2[14];
            _loc3_.hAlign = param2[15];
            _loc3_.italic = param2[16];
            _loc3_.bold = param2[17];
            _loc3_.text = param2[18];
            _loc4_ = SwfFilter.createTextFieldFilter(param2[19]);
            if(_loc4_)
            {
               _loc3_.nativeFilters = _loc4_;
            }
            SwfBlendMode.setBlendMode(_loc3_,param2[20]);
         }
         return _loc3_;
      }
      
      public function hasComponent(param1:String) : Boolean
      {
         return _swfDatas["comp"][param1] != null;
      }
      
      public function createComponent(param1:String, param2:Array = null) : *
      {
         var _loc3_:Array = _swfDatas["comp"][param1];
         var _loc6_:SwfSprite = createSprite(param1,param2,_loc3_);
         var _loc5_:Class = ComponentConfig.getComponentClass(param1);
         if(_loc5_ == null)
         {
            return _loc6_;
         }
         var _loc4_:ISwfComponent = new _loc5_();
         _loc4_.initialization(_loc6_);
         if(param2 != null)
         {
            if(_loc4_ is DisplayObject)
            {
               _loc4_["filter"] = SwfFilter.createFilter(param2[11]);
               SwfBlendMode.setBlendMode(_loc4_ as DisplayObject,param2[12]);
            }
         }
         return _loc4_;
      }
      
      public function hasParticle(param1:String) : Boolean
      {
         return _swfDatas["particle"][param1];
      }
      
      public function createParticle(param1:String, param2:Array = null) : SwfParticleSyetem
      {
         var _loc7_:Array = _swfDatas["particle"][param1];
         var _loc4_:String = _loc7_[1];
         var _loc5_:Texture = _assets.getTexture(_loc4_);
         if(_loc5_ == null)
         {
            throw new Error("Texture \"" + param1 + "\" not exist");
         }
         var _loc6_:XML = _particleXML[param1];
         if(_loc6_ == null)
         {
            _loc6_ = new XML(_loc7_[0]);
            _particleXML[param1] = _loc6_;
         }
         var _loc3_:SwfParticleSyetem = new SwfParticleSyetem(_loc6_,_loc5_,this);
         _loc3_.classLink = param1;
         return _loc3_;
      }
      
      public function mergerSwfData(param1:Object) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc8_:int = 0;
         var _loc7_:* = param1;
         for(_loc3_ in param1)
         {
            _loc4_ = param1[_loc3_];
            var _loc6_:int = 0;
            var _loc5_:* = _loc4_;
            for(_loc2_ in _loc4_)
            {
               this._swfDatas[_loc3_][_loc2_] = _loc4_[_loc2_];
            }
         }
      }
      
      public function mergerSwfDataBytes(param1:ByteArray) : void
      {
         var _loc2_:ByteArray = Clone.clone(param1);
         _loc2_.uncompress();
         mergerSwfData(JSON.parse(new String(_loc2_)));
         _loc2_.clear();
      }
      
      public function dispose(param1:Boolean) : void
      {
         _swfUpdateManager.dispose();
         if(param1)
         {
            _assets.purge();
            _assets.clearRuntimeLoadTexture();
         }
         _assets = null;
         _swfDatas = null;
         _swfUpdateManager = null;
      }
   }
}

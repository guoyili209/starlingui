package starling.text
{
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import starling.display.Image;
   import starling.display.QuadBatch;
   import starling.display.Sprite;
   import starling.textures.Texture;
   import starling.utils.cleanMasterString;
   
   public class BitmapFont
   {
      
      public static const NATIVE_SIZE:int = -1;
      
      public static const MINI:String = "mini";
      
      private static const CHAR_SPACE:int = 32;
      
      private static const CHAR_TAB:int = 9;
      
      private static const CHAR_NEWLINE:int = 10;
      
      private static const CHAR_CARRIAGE_RETURN:int = 13;
      
      private static var sLines:Array = [];
       
      
      private var mTexture:Texture;
      
      private var mChars:Dictionary;
      
      private var mName:String;
      
      private var mSize:Number;
      
      private var mLineHeight:Number;
      
      private var mBaseline:Number;
      
      private var mOffsetX:Number;
      
      private var mOffsetY:Number;
      
      private var mHelperImage:Image;
      
      public function BitmapFont(param1:Texture = null, param2:XML = null)
      {
         super();
         if(param1 == null && param2 == null)
         {
            param1 = MiniBitmapFont.texture;
            param2 = MiniBitmapFont.xml;
         }
         mName = "unknown";
         mBaseline = 14;
         mSize = 14;
         mLineHeight = 14;
         mOffsetY = 0;
         mOffsetX = 0;
         mTexture = param1;
         mChars = new Dictionary();
         mHelperImage = new Image(param1);
         if(param2)
         {
            parseFontXml(param2);
         }
      }
      
      public function dispose() : void
      {
         if(mTexture)
         {
            mTexture.dispose();
         }
      }
      
      private function parseFontXml(param1:XML) : void
      {
         var _loc12_:int = 0;
         var _loc14_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:* = null;
         var _loc8_:* = null;
         var _loc10_:* = null;
         var _loc16_:int = 0;
         var _loc5_:int = 0;
         var _loc11_:Number = NaN;
         var _loc3_:Number = mTexture.scale;
         var _loc13_:Rectangle = mTexture.frame;
         var _loc15_:Number = !!_loc13_?_loc13_.x:0;
         var _loc17_:Number = !!_loc13_?_loc13_.y:0;
         mName = cleanMasterString(param1.info.@face);
         mSize = parseFloat(param1.info.@size) / _loc3_;
         mLineHeight = parseFloat(param1.common.@lineHeight) / _loc3_;
         mBaseline = parseFloat(param1.common.@base) / _loc3_;
         if(param1.info.@smooth.toString() == "0")
         {
            smoothing = "none";
         }
         if(mSize <= 0)
         {
            trace("[Starling] Warning: invalid font size in \'" + mName + "\' font.");
            mSize = mSize == 0?16:Number(mSize * -1);
         }
         var _loc19_:int = 0;
         var _loc18_:* = param1.chars.char;
         for each(var _loc9_ in param1.chars.char)
         {
            _loc12_ = parseInt(_loc9_.@id);
            _loc14_ = parseFloat(_loc9_.@xoffset) / _loc3_;
            _loc4_ = parseFloat(_loc9_.@yoffset) / _loc3_;
            _loc7_ = parseFloat(_loc9_.@xadvance) / _loc3_;
            _loc2_ = new Rectangle();
            _loc2_.x = parseFloat(_loc9_.@x) / _loc3_ + _loc15_;
            _loc2_.y = parseFloat(_loc9_.@y) / _loc3_ + _loc17_;
            _loc2_.width = parseFloat(_loc9_.@width) / _loc3_;
            _loc2_.height = parseFloat(_loc9_.@height) / _loc3_;
            _loc8_ = Texture.fromTexture(mTexture,_loc2_);
            _loc10_ = new BitmapChar(_loc12_,_loc8_,_loc14_,_loc4_,_loc7_);
            addChar(_loc12_,_loc10_);
         }
         var _loc21_:int = 0;
         var _loc20_:* = param1.kernings.kerning;
         for each(var _loc6_ in param1.kernings.kerning)
         {
            _loc16_ = parseInt(_loc6_.@first);
            _loc5_ = parseInt(_loc6_.@second);
            _loc11_ = parseFloat(_loc6_.@amount) / _loc3_;
            if(_loc5_ in mChars)
            {
               getChar(_loc5_).addKerning(_loc16_,_loc11_);
            }
         }
      }
      
      public function getChar(param1:int) : BitmapChar
      {
         return mChars[param1];
      }
      
      public function addChar(param1:int, param2:BitmapChar) : void
      {
         mChars[param1] = param2;
      }
      
      public function getCharIDs(param1:Vector.<int> = null) : Vector.<int>
      {
         if(param1 == null)
         {
            param1 = new Vector.<int>(0);
         }
         var _loc4_:int = 0;
         var _loc3_:* = mChars;
         for(param1[param1.length] in mChars)
         {
         }
         return param1;
      }
      
      public function hasChars(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 == null)
         {
            return true;
         }
         var _loc2_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = param1.charCodeAt(_loc4_);
            if(_loc3_ != 32 && _loc3_ != 9 && _loc3_ != 10 && _loc3_ != 13 && getChar(_loc3_) == null)
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      public function createSprite(param1:Number, param2:Number, param3:String, param4:Number = -1, param5:uint = 16777215, param6:String = "center", param7:String = "center", param8:Boolean = true, param9:Boolean = true) : Sprite
      {
         var _loc14_:int = 0;
         var _loc15_:* = null;
         var _loc12_:* = null;
         var _loc11_:Vector.<CharLocation> = arrangeChars(param1,param2,param3,param4,param6,param7,param8,param9);
         var _loc10_:int = _loc11_.length;
         var _loc13_:Sprite = new Sprite();
         _loc14_ = 0;
         while(_loc14_ < _loc10_)
         {
            _loc15_ = _loc11_[_loc14_];
            _loc12_ = _loc15_.char.createImage();
            _loc12_.x = _loc15_.x;
            _loc12_.y = _loc15_.y;
            var _loc16_:* = _loc15_.scale;
            _loc12_.scaleY = _loc16_;
            _loc12_.scaleX = _loc16_;
            _loc12_.color = param5;
            _loc13_.addChild(_loc12_);
            _loc14_++;
         }
         CharLocation.rechargePool();
         return _loc13_;
      }
      
      public function fillQuadBatch(param1:QuadBatch, param2:Number, param3:Number, param4:String, param5:Number = -1, param6:uint = 16777215, param7:String = "center", param8:String = "center", param9:Boolean = true, param10:Boolean = true) : void
      {
         var _loc13_:int = 0;
         var _loc14_:* = null;
         var _loc12_:Vector.<CharLocation> = arrangeChars(param2,param3,param4,param5,param7,param8,param9,param10);
         var _loc11_:int = _loc12_.length;
         mHelperImage.color = param6;
         _loc13_ = 0;
         while(_loc13_ < _loc11_)
         {
            _loc14_ = _loc12_[_loc13_];
            mHelperImage.texture = _loc14_.char.texture;
            mHelperImage.readjustSize();
            mHelperImage.x = _loc14_.x;
            mHelperImage.y = _loc14_.y;
            var _loc15_:* = _loc14_.scale;
            mHelperImage.scaleY = _loc15_;
            mHelperImage.scaleX = _loc15_;
            param1.addImage(mHelperImage);
            _loc13_++;
         }
         CharLocation.rechargePool();
      }
      
      private function arrangeChars(param1:Number, param2:Number, param3:String, param4:Number = -1, param5:String = "center", param6:String = "center", param7:Boolean = true, param8:Boolean = true) : Vector.<CharLocation>
      {
         var _loc31_:* = null;
         var _loc20_:int = 0;
         var _loc13_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc9_:* = 0;
         var _loc26_:* = 0;
         var _loc35_:* = NaN;
         var _loc33_:* = NaN;
         var _loc29_:* = undefined;
         var _loc28_:int = 0;
         var _loc24_:Boolean = false;
         var _loc17_:int = 0;
         var _loc14_:* = null;
         var _loc15_:int = 0;
         var _loc18_:int = 0;
         var _loc34_:int = 0;
         var _loc16_:* = undefined;
         var _loc30_:int = 0;
         var _loc27_:* = null;
         var _loc19_:Number = NaN;
         var _loc22_:int = 0;
         if(param3 == null || param3.length == 0)
         {
            return CharLocation.vectorFromPool();
         }
         if(param4 < 0)
         {
            param4 = param4 * -mSize;
         }
         var _loc25_:Boolean = false;
         while(!_loc25_)
         {
            sLines.length = 0;
            _loc10_ = param4 / mSize;
            _loc13_ = param1 / _loc10_;
            _loc23_ = param2 / _loc10_;
            if(mLineHeight <= _loc23_)
            {
               _loc9_ = -1;
               _loc26_ = -1;
               _loc35_ = 0;
               _loc33_ = 0;
               _loc29_ = CharLocation.vectorFromPool();
               _loc20_ = param3.length;
               _loc28_ = 0;
               for(; _loc28_ < _loc20_; _loc28_++)
               {
                  _loc24_ = false;
                  _loc17_ = param3.charCodeAt(_loc28_);
                  _loc14_ = getChar(_loc17_);
                  if(_loc17_ == 10 || _loc17_ == 13)
                  {
                     _loc24_ = true;
                  }
                  else if(_loc14_ == null)
                  {
                     trace("[Starling] Missing character: " + _loc17_);
                  }
                  else
                  {
                     if(_loc17_ == 32 || _loc17_ == 9)
                     {
                        _loc9_ = _loc28_;
                     }
                     if(param8)
                     {
                        _loc35_ = Number(_loc35_ + _loc14_.getKerning(_loc26_));
                     }
                     _loc31_ = CharLocation.instanceFromPool(_loc14_);
                     _loc31_.x = _loc35_ + _loc14_.xOffset;
                     _loc31_.y = _loc33_ + _loc14_.yOffset;
                     _loc29_[_loc29_.length] = _loc31_;
                     _loc35_ = Number(_loc35_ + _loc14_.xAdvance);
                     _loc26_ = _loc17_;
                     if(_loc31_.x + _loc14_.width > _loc13_)
                     {
                        if(!(param7 && _loc9_ == -1))
                        {
                           _loc15_ = _loc9_ == -1?1:Number(_loc28_ - _loc9_);
                           _loc18_ = _loc29_.length - _loc15_;
                           _loc29_.splice(_loc18_,_loc15_);
                           if(_loc29_.length != 0)
                           {
                              _loc28_ = _loc28_ - _loc15_;
                              _loc24_ = true;
                           }
                           break;
                        }
                        break;
                     }
                  }
                  if(_loc28_ == _loc20_ - 1)
                  {
                     sLines[sLines.length] = _loc29_;
                     _loc25_ = true;
                  }
                  else if(_loc24_)
                  {
                     sLines[sLines.length] = _loc29_;
                     if(_loc9_ == _loc28_)
                     {
                        _loc29_.pop();
                     }
                     if(_loc33_ + 2 * mLineHeight <= _loc23_)
                     {
                        _loc29_ = CharLocation.vectorFromPool();
                        _loc35_ = 0;
                        _loc33_ = Number(_loc33_ + mLineHeight);
                        _loc9_ = -1;
                        _loc26_ = -1;
                        continue;
                     }
                     break;
                  }
               }
            }
            if(param7 && !_loc25_ && param4 > 3)
            {
               param4 = param4 - 1;
            }
            else
            {
               _loc25_ = true;
            }
         }
         var _loc21_:Vector.<CharLocation> = CharLocation.vectorFromPool();
         var _loc12_:int = sLines.length;
         var _loc32_:Number = _loc33_ + mLineHeight;
         var _loc11_:int = 0;
         if(param6 == "bottom")
         {
            _loc11_ = _loc23_ - _loc32_;
         }
         else if(param6 == "center")
         {
            _loc11_ = (_loc23_ - _loc32_) / 2;
         }
         _loc34_ = 0;
         while(_loc34_ < _loc12_)
         {
            _loc16_ = sLines[_loc34_];
            _loc20_ = _loc16_.length;
            if(_loc20_ != 0)
            {
               _loc30_ = 0;
               _loc27_ = _loc16_[_loc16_.length - 1];
               _loc19_ = _loc27_.x - _loc27_.char.xOffset + _loc27_.char.xAdvance;
               if(param5 == "right")
               {
                  _loc30_ = _loc13_ - _loc19_;
               }
               else if(param5 == "center")
               {
                  _loc30_ = (_loc13_ - _loc19_) / 2;
               }
               _loc22_ = 0;
               while(_loc22_ < _loc20_)
               {
                  _loc31_ = _loc16_[_loc22_];
                  _loc31_.x = _loc10_ * (_loc31_.x + _loc30_ + mOffsetX);
                  _loc31_.y = _loc10_ * (_loc31_.y + _loc11_ + mOffsetY);
                  _loc31_.scale = _loc10_;
                  if(_loc31_.char.width > 0 && _loc31_.char.height > 0)
                  {
                     _loc21_[_loc21_.length] = _loc31_;
                  }
                  _loc22_++;
               }
            }
            _loc34_++;
         }
         return _loc21_;
      }
      
      public function get name() : String
      {
         return mName;
      }
      
      public function get size() : Number
      {
         return mSize;
      }
      
      public function get lineHeight() : Number
      {
         return mLineHeight;
      }
      
      public function set lineHeight(param1:Number) : void
      {
         mLineHeight = param1;
      }
      
      public function get smoothing() : String
      {
         return mHelperImage.smoothing;
      }
      
      public function set smoothing(param1:String) : void
      {
         mHelperImage.smoothing = param1;
      }
      
      public function get baseline() : Number
      {
         return mBaseline;
      }
      
      public function set baseline(param1:Number) : void
      {
         mBaseline = param1;
      }
      
      public function get offsetX() : Number
      {
         return mOffsetX;
      }
      
      public function set offsetX(param1:Number) : void
      {
         mOffsetX = param1;
      }
      
      public function get offsetY() : Number
      {
         return mOffsetY;
      }
      
      public function set offsetY(param1:Number) : void
      {
         mOffsetY = param1;
      }
      
      public function get texture() : Texture
      {
         return mTexture;
      }
   }
}

import starling.text.BitmapChar;

class CharLocation
{
   
   private static var sInstancePool:Vector.<CharLocation> = new Vector.<CharLocation>(0);
   
   private static var sVectorPool:Array = [];
   
   private static var sInstanceLoan:Vector.<CharLocation> = new Vector.<CharLocation>(0);
   
   private static var sVectorLoan:Array = [];
    
   
   public var char:BitmapChar;
   
   public var scale:Number;
   
   public var x:Number;
   
   public var y:Number;
   
   function CharLocation(param1:BitmapChar)
   {
      super();
      reset(param1);
   }
   
   public static function instanceFromPool(param1:BitmapChar) : CharLocation
   {
      var _loc2_:CharLocation = sInstancePool.length > 0?sInstancePool.pop():new CharLocation(param1);
      _loc2_.reset(param1);
      sInstanceLoan[sInstanceLoan.length] = _loc2_;
      return _loc2_;
   }
   
   public static function vectorFromPool() : Vector.<CharLocation>
   {
      var _loc1_:Vector.<CharLocation> = sVectorPool.length > 0?sVectorPool.pop():new Vector.<CharLocation>(0);
      _loc1_.length = 0;
      sVectorLoan[sVectorLoan.length] = _loc1_;
      return _loc1_;
   }
   
   public static function rechargePool() : void
   {
      var _loc2_:* = null;
      var _loc1_:* = undefined;
      while(sInstanceLoan.length > 0)
      {
         _loc2_ = sInstanceLoan.pop();
         _loc2_.char = null;
         sInstancePool[sInstancePool.length] = _loc2_;
      }
      while(sVectorLoan.length > 0)
      {
         _loc1_ = sVectorLoan.pop();
         _loc1_.length = 0;
         sVectorPool[sVectorPool.length] = _loc1_;
      }
   }
   
   private function reset(param1:BitmapChar) : CharLocation
   {
      this.char = param1;
      return this;
   }
}

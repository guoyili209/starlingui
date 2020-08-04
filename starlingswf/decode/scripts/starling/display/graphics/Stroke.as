package starling.display.graphics
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.display.graphics.util.TriangleUtil;
   import starling.textures.Texture;
   import starling.utils.MatrixUtil;
   
   public class Stroke extends Graphic
   {
      
      protected static const c_degenerateUseNext:uint = 1;
      
      protected static const c_degenerateUseLast:uint = 2;
      
      protected static var sCollissionHelper:StrokeCollisionHelper = null;
       
      
      protected var _line:Vector.<StrokeVertex>;
      
      protected var _numVertices:int;
      
      protected var _hasDegenerates:Boolean = false;
      
      public function Stroke()
      {
         super();
         clear();
      }
      
      protected static function createPolyLinePreAlloc(param1:Vector.<StrokeVertex>, param2:Vector.<Number>, param3:Vector.<uint>, param4:Boolean) : void
      {
         var _loc45_:* = NaN;
         _loc45_ = 3.14159265358979;
         var _loc38_:* = false;
         var _loc15_:* = false;
         var _loc43_:int = 0;
         var _loc26_:Boolean = false;
         var _loc16_:* = 0;
         var _loc17_:* = 0;
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc7_:* = null;
         var _loc22_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc46_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc48_:Number = NaN;
         var _loc49_:Number = NaN;
         var _loc10_:* = NaN;
         var _loc11_:* = NaN;
         var _loc35_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc25_:* = 0;
         var _loc18_:int = param1.length;
         var _loc27_:int = 0;
         var _loc47_:int = 0;
         var _loc32_:* = 0;
         var _loc31_:* = 0;
         var _loc12_:uint = 0;
         var _loc40_:uint = 0;
         _loc43_ = 0;
         while(_loc43_ < _loc18_)
         {
            _loc40_ = _loc43_;
            if(param4)
            {
               _loc12_ = param1[_loc43_].degenerate;
               if(_loc12_ != 0)
               {
                  _loc40_ = _loc12_ == 2?_loc43_ - 1:Number(_loc43_ + 1);
               }
               _loc38_ = Boolean(_loc40_ == 0 || param1[_loc40_ - 1].degenerate > 0);
               _loc15_ = Boolean(_loc40_ == _loc18_ - 1 || param1[_loc40_ + 1].degenerate > 0);
            }
            else
            {
               _loc38_ = _loc40_ == 0;
               _loc15_ = _loc40_ == _loc18_ - 1;
            }
            _loc26_ = _loc38_ == false && _loc15_ == false;
            _loc16_ = uint(!!_loc38_?_loc40_:_loc40_ - 1);
            _loc17_ = uint(!!_loc15_?_loc40_:_loc40_ + 1);
            _loc6_ = param1[_loc16_];
            _loc5_ = param1[_loc40_];
            _loc7_ = param1[_loc17_];
            _loc22_ = _loc5_.thickness;
            _loc19_ = _loc6_.x;
            _loc20_ = _loc6_.y;
            _loc34_ = _loc5_.x;
            _loc33_ = _loc5_.y;
            _loc44_ = _loc7_.x;
            _loc46_ = _loc7_.y;
            _loc14_ = _loc34_ - _loc19_;
            _loc13_ = _loc33_ - _loc20_;
            _loc48_ = _loc44_ - _loc34_;
            _loc49_ = _loc46_ - _loc33_;
            if(_loc26_ == false)
            {
               if(_loc15_)
               {
                  _loc44_ = _loc44_ + _loc14_;
                  _loc46_ = _loc46_ + _loc13_;
                  _loc48_ = _loc44_ - _loc34_;
                  _loc49_ = _loc46_ - _loc33_;
               }
               if(_loc38_)
               {
                  _loc19_ = _loc19_ - _loc48_;
                  _loc20_ = _loc20_ - _loc49_;
                  _loc14_ = _loc34_ - _loc19_;
                  _loc13_ = _loc33_ - _loc20_;
               }
            }
            _loc10_ = Number(Math.sqrt(_loc14_ * _loc14_ + _loc13_ * _loc13_));
            _loc11_ = Number(Math.sqrt(_loc48_ * _loc48_ + _loc49_ * _loc49_));
            _loc35_ = _loc22_ * 0.5;
            if(_loc26_)
            {
               if(_loc10_ == 0)
               {
                  _loc10_ = _loc32_;
               }
               else
               {
                  _loc32_ = _loc10_;
               }
               if(_loc11_ == 0)
               {
                  _loc11_ = _loc31_;
               }
               else
               {
                  _loc31_ = _loc11_;
               }
               _loc8_ = (_loc14_ * _loc48_ + _loc13_ * _loc49_) / (_loc10_ * _loc11_);
               _loc21_ = Math.acos(_loc8_);
               _loc35_ = _loc35_ / Math.sin((3.14159265358979 - _loc21_) * 0.5);
               if(_loc35_ > _loc22_ * 4)
               {
                  _loc35_ = _loc22_ * 4;
               }
               if(_loc35_ != _loc35_)
               {
                  _loc35_ = _loc22_ * 0.5;
               }
            }
            _loc36_ = -_loc13_ / _loc10_;
            _loc37_ = _loc14_ / _loc10_;
            _loc23_ = -_loc49_ / _loc11_;
            _loc24_ = _loc48_ / _loc11_;
            _loc39_ = _loc36_ + _loc23_;
            _loc41_ = _loc37_ + _loc24_;
            _loc42_ = 1 / Math.sqrt(_loc39_ * _loc39_ + _loc41_ * _loc41_) * _loc35_;
            _loc39_ = _loc39_ * _loc42_;
            _loc41_ = _loc41_ * _loc42_;
            _loc30_ = _loc34_ + _loc39_;
            _loc29_ = _loc33_ + _loc41_;
            _loc9_ = !!_loc12_?_loc30_:Number(_loc34_ - _loc39_);
            _loc28_ = !!_loc12_?_loc29_:Number(_loc33_ - _loc41_);
            _loc27_++;
            param2[_loc27_] = _loc30_;
            _loc27_++;
            param2[_loc27_] = _loc29_;
            _loc27_++;
            param2[_loc27_] = 0;
            _loc27_++;
            param2[_loc27_] = _loc5_.r2;
            _loc27_++;
            param2[_loc27_] = _loc5_.g2;
            _loc27_++;
            param2[_loc27_] = _loc5_.b2;
            _loc27_++;
            param2[_loc27_] = _loc5_.a2;
            _loc27_++;
            param2[_loc27_] = _loc5_.u;
            _loc27_++;
            param2[_loc27_] = 1;
            _loc27_++;
            param2[_loc27_] = _loc9_;
            _loc27_++;
            param2[_loc27_] = _loc28_;
            _loc27_++;
            param2[_loc27_] = 0;
            _loc27_++;
            param2[_loc27_] = _loc5_.r1;
            _loc27_++;
            param2[_loc27_] = _loc5_.g1;
            _loc27_++;
            param2[_loc27_] = _loc5_.b1;
            _loc27_++;
            param2[_loc27_] = _loc5_.a1;
            _loc27_++;
            param2[_loc27_] = _loc5_.u;
            _loc27_++;
            param2[_loc27_] = 0;
            if(_loc43_ < _loc18_ - 1)
            {
               _loc25_ = _loc43_ << 1;
               _loc47_++;
               param3[_loc47_] = _loc25_;
               _loc47_++;
               param3[_loc47_] = _loc25_ + 2;
               _loc47_++;
               param3[_loc47_] = _loc25_ + 1;
               _loc47_++;
               param3[_loc47_] = _loc25_ + 1;
               _loc47_++;
               param3[_loc47_] = _loc25_ + 2;
               _loc47_++;
               param3[_loc47_] = _loc25_ + 3;
            }
            _loc43_++;
         }
      }
      
      protected static function createPolyLine(param1:Vector.<StrokeVertex>, param2:Vector.<Number>, param3:Vector.<uint>, param4:int) : void
      {
         var _loc37_:* = NaN;
         _loc37_ = 3.14159265358979;
         var _loc33_:int = 0;
         var _loc16_:* = 0;
         var _loc28_:* = 0;
         var _loc25_:Boolean = false;
         var _loc23_:Boolean = false;
         var _loc26_:* = 0;
         var _loc30_:* = 0;
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc8_:* = null;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc41_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc43_:int = 0;
         var _loc31_:Function = Math.sqrt;
         var _loc39_:Function = Math.sin;
         var _loc32_:int = param1.length;
         _loc33_ = 0;
         while(_loc33_ < _loc32_)
         {
            _loc16_ = uint(param1[_loc33_].degenerate);
            _loc28_ = uint(_loc33_);
            if(_loc16_ != 0)
            {
               _loc28_ = uint(_loc16_ == 2?_loc33_ - 1:Number(_loc33_ + 1));
            }
            _loc25_ = _loc28_ == 0 || param1[_loc28_ - 1].degenerate > 0;
            _loc23_ = _loc28_ == _loc32_ - 1 || param1[_loc28_ + 1].degenerate > 0;
            _loc26_ = uint(!!_loc25_?_loc28_:_loc28_ - 1);
            _loc30_ = uint(!!_loc23_?_loc28_:_loc28_ + 1);
            _loc6_ = param1[_loc26_];
            _loc5_ = param1[_loc28_];
            _loc8_ = param1[_loc30_];
            _loc34_ = _loc6_.x;
            _loc35_ = _loc6_.y;
            _loc17_ = _loc5_.x;
            _loc15_ = _loc5_.y;
            _loc36_ = _loc8_.x;
            _loc38_ = _loc8_.y;
            _loc22_ = _loc17_ - _loc34_;
            _loc21_ = _loc15_ - _loc35_;
            _loc40_ = _loc36_ - _loc17_;
            _loc42_ = _loc38_ - _loc15_;
            if(_loc23_)
            {
               _loc36_ = _loc36_ + _loc22_;
               _loc38_ = _loc38_ + _loc21_;
               _loc40_ = _loc36_ - _loc17_;
               _loc42_ = _loc38_ - _loc15_;
            }
            if(_loc25_)
            {
               _loc34_ = _loc34_ - _loc40_;
               _loc35_ = _loc35_ - _loc42_;
               _loc22_ = _loc17_ - _loc34_;
               _loc21_ = _loc15_ - _loc35_;
            }
            _loc13_ = _loc31_(_loc22_ * _loc22_ + _loc21_ * _loc21_);
            _loc14_ = _loc31_(_loc40_ * _loc40_ + _loc42_ * _loc42_);
            _loc19_ = _loc5_.thickness * 0.5;
            if(!(_loc25_ || _loc23_))
            {
               _loc11_ = (_loc22_ * _loc40_ + _loc21_ * _loc42_) / (_loc13_ * _loc14_);
               _loc19_ = _loc19_ / _loc39_((3.14159265358979 - Math.acos(_loc11_)) * 0.5);
               if(_loc19_ > _loc5_.thickness * 4)
               {
                  _loc19_ = _loc5_.thickness * 4;
               }
               if(isNaN(_loc19_))
               {
                  _loc19_ = _loc5_.thickness * 0.5;
               }
            }
            _loc18_ = -_loc21_ / _loc13_;
            _loc20_ = _loc22_ / _loc13_;
            _loc41_ = -_loc42_ / _loc14_;
            _loc44_ = _loc40_ / _loc14_;
            _loc24_ = _loc18_ + _loc41_;
            _loc27_ = _loc20_ + _loc44_;
            _loc29_ = 1 / _loc31_(_loc24_ * _loc24_ + _loc27_ * _loc27_) * _loc19_;
            _loc24_ = _loc24_ * _loc29_;
            _loc27_ = _loc27_ * _loc29_;
            _loc10_ = _loc17_ + _loc24_;
            _loc9_ = _loc15_ + _loc27_;
            _loc12_ = !!_loc16_?_loc10_:Number(_loc17_ - _loc24_);
            _loc7_ = !!_loc16_?_loc9_:Number(_loc15_ - _loc27_);
            param2.push(_loc10_,_loc9_,0,_loc5_.r2,_loc5_.g2,_loc5_.b2,_loc5_.a2,_loc5_.u,1,_loc12_,_loc7_,0,_loc5_.r1,_loc5_.g1,_loc5_.b1,_loc5_.a1,_loc5_.u,0);
            if(_loc33_ < _loc32_ - 1)
            {
               _loc43_ = param4 + (_loc33_ << 1);
               param3.push(_loc43_,_loc43_ + 2,_loc43_ + 1,_loc43_ + 1,_loc43_ + 2,_loc43_ + 3);
            }
            _loc33_++;
         }
      }
      
      protected static function fixUpPolyLine(param1:Vector.<StrokeVertex>) : int
      {
         if(param1.length > 0 && param1[0].degenerate > 0)
         {
            throw new Error("Degenerate on first line vertex");
         }
         var _loc2_:int = param1.length - 1;
         while(_loc2_ > 0 && param1[_loc2_].degenerate > 0)
         {
            param1.pop();
            _loc2_--;
         }
         return param1.length;
      }
      
      public static function strokeCollideTest(param1:Stroke, param2:Stroke, param3:Point, param4:Vector.<Point> = null) : Boolean
      {
         var _loc9_:int = 0;
         var _loc12_:* = null;
         var _loc11_:* = null;
         var _loc6_:int = 0;
         var _loc13_:* = null;
         var _loc16_:* = null;
         if(param1 == null || param2 == null || param1._line == null || param1._line == null)
         {
            return false;
         }
         if(sCollissionHelper == null)
         {
            sCollissionHelper = new StrokeCollisionHelper();
         }
         sCollissionHelper.testIntersectPoint.x = 0;
         sCollissionHelper.testIntersectPoint.y = 0;
         param3.x = 0;
         param3.y = 0;
         var _loc15_:Boolean = false;
         if(param1.parent == param2.parent)
         {
            _loc15_ = true;
         }
         param1.getBounds(!!_loc15_?param1.parent:param1.stage,sCollissionHelper.bounds1);
         param2.getBounds(!!_loc15_?param2.parent:param2.stage,sCollissionHelper.bounds2);
         if(sCollissionHelper.bounds1.intersects(sCollissionHelper.bounds2) == false)
         {
            return false;
         }
         if(param3 == null)
         {
            param3 = new Point();
         }
         var _loc8_:int = param1._line.length;
         var _loc5_:int = param2._line.length;
         var _loc14_:Boolean = false;
         if(sCollissionHelper.s2v0Vector == null || sCollissionHelper.s2v0Vector.length < _loc5_)
         {
            sCollissionHelper.s2v0Vector = new Vector.<Point>(_loc5_,true);
            sCollissionHelper.s2v1Vector = new Vector.<Point>(_loc5_,true);
         }
         var _loc10_:int = 0;
         var _loc7_:int = 0;
         if(param4 != null)
         {
            _loc7_ = param4.length;
         }
         _loc9_ = 1;
         while(_loc9_ < _loc8_)
         {
            _loc12_ = param1._line[_loc9_ - 1];
            _loc11_ = param1._line[_loc9_];
            sCollissionHelper.localPT1.setTo(_loc12_.x,_loc12_.y);
            sCollissionHelper.localPT2.setTo(_loc11_.x,_loc11_.y);
            if(_loc15_)
            {
               param1.localToParent(sCollissionHelper.localPT1,sCollissionHelper.globalPT1);
               param1.localToParent(sCollissionHelper.localPT2,sCollissionHelper.globalPT2);
            }
            else
            {
               param1.localToGlobal(sCollissionHelper.localPT1,sCollissionHelper.globalPT1);
               param1.localToGlobal(sCollissionHelper.localPT2,sCollissionHelper.globalPT2);
            }
            _loc6_ = 1;
            while(_loc6_ < _loc5_)
            {
               _loc13_ = param2._line[_loc6_ - 1];
               _loc16_ = param2._line[_loc6_];
               if(_loc9_ == 1)
               {
                  sCollissionHelper.localPT3.setTo(_loc13_.x,_loc13_.y);
                  sCollissionHelper.localPT4.setTo(_loc16_.x,_loc16_.y);
                  if(_loc15_)
                  {
                     param2.localToParent(sCollissionHelper.localPT3,sCollissionHelper.globalPT3);
                     param2.localToParent(sCollissionHelper.localPT4,sCollissionHelper.globalPT4);
                  }
                  else
                  {
                     param2.localToGlobal(sCollissionHelper.localPT3,sCollissionHelper.globalPT3);
                     param2.localToGlobal(sCollissionHelper.localPT4,sCollissionHelper.globalPT4);
                  }
                  if(sCollissionHelper.s2v0Vector[_loc6_] == null)
                  {
                     sCollissionHelper.s2v0Vector[_loc6_] = new Point(sCollissionHelper.globalPT3.x,sCollissionHelper.globalPT3.y);
                     sCollissionHelper.s2v1Vector[_loc6_] = new Point(sCollissionHelper.globalPT4.x,sCollissionHelper.globalPT4.y);
                  }
                  else
                  {
                     sCollissionHelper.s2v0Vector[_loc6_].x = sCollissionHelper.globalPT3.x;
                     sCollissionHelper.s2v0Vector[_loc6_].y = sCollissionHelper.globalPT3.y;
                     sCollissionHelper.s2v1Vector[_loc6_].x = sCollissionHelper.globalPT4.x;
                     sCollissionHelper.s2v1Vector[_loc6_].y = sCollissionHelper.globalPT4.y;
                  }
               }
               else
               {
                  sCollissionHelper.globalPT3.x = sCollissionHelper.s2v0Vector[_loc6_].x;
                  sCollissionHelper.globalPT3.y = sCollissionHelper.s2v0Vector[_loc6_].y;
                  sCollissionHelper.globalPT4.x = sCollissionHelper.s2v1Vector[_loc6_].x;
                  sCollissionHelper.globalPT4.y = sCollissionHelper.s2v1Vector[_loc6_].y;
               }
               if(TriangleUtil.lineIntersectLine(sCollissionHelper.globalPT1.x,sCollissionHelper.globalPT1.y,sCollissionHelper.globalPT2.x,sCollissionHelper.globalPT2.y,sCollissionHelper.globalPT3.x,sCollissionHelper.globalPT3.y,sCollissionHelper.globalPT4.x,sCollissionHelper.globalPT4.y,sCollissionHelper.testIntersectPoint))
               {
                  if(param4 != null && _loc10_ < _loc7_ - 1)
                  {
                     if(_loc15_)
                     {
                        param1.parent.localToGlobal(sCollissionHelper.testIntersectPoint,param4[_loc10_]);
                     }
                     else
                     {
                        param4[_loc10_].x = sCollissionHelper.testIntersectPoint.x;
                        param4[_loc10_].y = sCollissionHelper.testIntersectPoint.y;
                     }
                     _loc10_++;
                     param4[_loc10_].x = NaN;
                     param4[_loc10_].y = NaN;
                  }
                  if(sCollissionHelper.testIntersectPoint.length > param3.length)
                  {
                     if(_loc15_)
                     {
                        param1.parent.localToGlobal(sCollissionHelper.testIntersectPoint,param3);
                     }
                     else
                     {
                        param3.x = sCollissionHelper.testIntersectPoint.x;
                        param3.y = sCollissionHelper.testIntersectPoint.y;
                     }
                  }
                  _loc14_ = true;
               }
               _loc6_++;
            }
            _loc9_++;
         }
         return _loc14_;
      }
      
      public function get numVertices() : int
      {
         return _numVertices;
      }
      
      override public function dispose() : void
      {
         clear();
         super.dispose();
      }
      
      public function clear() : void
      {
         if(minBounds)
         {
            var _loc1_:* = Infinity;
            minBounds.y = _loc1_;
            minBounds.x = _loc1_;
            _loc1_ = -Infinity;
            maxBounds.y = _loc1_;
            maxBounds.x = _loc1_;
         }
         if(_line)
         {
            StrokeVertex.returnInstances(_line);
            _line.length = 0;
         }
         else
         {
            _line = new Vector.<StrokeVertex>();
         }
         _numVertices = 0;
         setGeometryInvalid();
         _hasDegenerates = false;
      }
      
      public function addDegenerates(param1:Number, param2:Number) : void
      {
         if(_numVertices < 1)
         {
            return;
         }
         var _loc3_:StrokeVertex = _line[_numVertices - 1];
         addVertexInternal(_loc3_.x,_loc3_.y,0);
         setLastVertexAsDegenerate(2);
         addVertexInternal(param1,param2,0);
         setLastVertexAsDegenerate(1);
         _hasDegenerates = true;
      }
      
      protected function setLastVertexAsDegenerate(param1:uint) : void
      {
         _line[_numVertices - 1].degenerate = param1;
         _line[_numVertices - 1].u = 0;
      }
      
      public function lineTo(param1:Number, param2:Number, param3:Number = 1, param4:uint = 16777215, param5:Number = 1) : void
      {
         addVertexInternal(param1,param2,param3,param4,param5,param4,param5);
      }
      
      public function moveTo(param1:Number, param2:Number, param3:Number = 1, param4:uint = 16777215, param5:Number = 1.0) : void
      {
         addDegenerates(param1,param2);
      }
      
      public function modifyVertexPosition(param1:int, param2:Number, param3:Number) : void
      {
         var _loc4_:StrokeVertex = _line[param1];
         _loc4_.x = param2;
         _loc4_.y = param3;
         if(isInvalid == false)
         {
            setGeometryInvalid();
         }
      }
      
      public function fromBounds(param1:Rectangle, param2:int = 1) : void
      {
         clear();
         addVertex(param1.x,param1.y,param2);
         addVertex(param1.x + param1.width,param1.y,param2);
         addVertex(param1.x + param1.width,param1.y + param1.height,param2);
         addVertex(param1.x,param1.y + param1.height,param2);
         addVertex(param1.x,param1.y,param2);
      }
      
      public function addVertex(param1:Number, param2:Number, param3:Number = 1, param4:uint = 16777215, param5:Number = 1, param6:uint = 16777215, param7:Number = 1) : void
      {
         addVertexInternal(param1,param2,param3,param4,param5,param6,param7);
      }
      
      protected function addVertexInternal(param1:Number, param2:Number, param3:Number = 1, param4:uint = 16777215, param5:Number = 1, param6:uint = 16777215, param7:Number = 1) : void
      {
         var _loc20_:* = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc13_:* = 0;
         var _loc11_:Vector.<Texture> = _material.textures;
         if(_loc11_.length > 0 && _line.length > 0)
         {
            _loc20_ = _line[_line.length - 1];
            _loc9_ = param1 - _loc20_.x;
            _loc10_ = param2 - _loc20_.y;
            _loc8_ = Math.sqrt(_loc9_ * _loc9_ + _loc10_ * _loc10_);
            _loc13_ = Number(_loc20_.u + _loc8_ / _loc11_[0].width);
         }
         var _loc18_:Number = (param4 >> 16) / 255;
         var _loc17_:Number = ((param4 & 65280) >> 8) / 255;
         var _loc14_:Number = (param4 & 255) / 255;
         var _loc19_:Number = (param6 >> 16) / 255;
         var _loc16_:Number = ((param6 & 65280) >> 8) / 255;
         var _loc15_:Number = (param6 & 255) / 255;
         var _loc12_:StrokeVertex = StrokeVertex.getInstance();
         _line[_numVertices] = _loc12_;
         _loc12_.x = param1;
         _loc12_.y = param2;
         _loc12_.r1 = _loc18_;
         _loc12_.g1 = _loc17_;
         _loc12_.b1 = _loc14_;
         _loc12_.a1 = param5;
         _loc12_.r2 = _loc19_;
         _loc12_.g2 = _loc16_;
         _loc12_.b2 = _loc15_;
         _loc12_.a2 = param7;
         _loc12_.u = _loc13_;
         _loc12_.v = 0;
         _loc12_.thickness = param3;
         _loc12_.degenerate = 0;
         _numVertices = Number(_numVertices) + 1;
         if(param1 < minBounds.x)
         {
            minBounds.x = param1;
         }
         else if(param1 > maxBounds.x)
         {
            maxBounds.x = param1;
         }
         if(param2 < minBounds.y)
         {
            minBounds.y = param2;
         }
         else if(param2 > maxBounds.y)
         {
            maxBounds.y = param2;
         }
         if(maxBounds.x == -Infinity)
         {
            maxBounds.x = param1;
         }
         if(maxBounds.y == -Infinity)
         {
            maxBounds.y = param2;
         }
         if(isInvalid == false)
         {
            setGeometryInvalid();
         }
      }
      
      public function getVertexPosition(param1:int, param2:Point = null) : Point
      {
         var _loc3_:* = param2;
         if(_loc3_ == null)
         {
            _loc3_ = new Point();
         }
         _loc3_.x = _line[param1].x;
         _loc3_.y = _line[param1].y;
         return _loc3_;
      }
      
      override protected function buildGeometry() : void
      {
         buildGeometryPreAllocatedVectors();
      }
      
      protected function buildGeometryOriginal() : void
      {
         var _loc3_:* = NaN;
         _loc3_ = 0.111111111111111;
         if(_line == null || _line.length == 0)
         {
            return;
         }
         vertices = new Vector.<Number>();
         indices = new Vector.<uint>();
         var _loc1_:int = 0;
         var _loc2_:int = vertices.length;
         _numVertices = fixUpPolyLine(_line);
         createPolyLine(_line,vertices,indices,_loc1_);
         _loc1_ = _loc1_ + (vertices.length - _loc2_) * 0.111111111111111;
      }
      
      protected function buildGeometryPreAllocatedVectors() : void
      {
         var _loc5_:* = NaN;
         _loc5_ = 0.111111111111111;
         if(_line == null || _line.length == 0)
         {
            return;
         }
         var _loc3_:int = 0;
         _numVertices = fixUpPolyLine(_line);
         var _loc2_:int = _line.length * 18;
         var _loc1_:int = (_line.length - 1) * 6;
         if(vertices == null || _loc2_ != vertices.length)
         {
            vertices = new Vector.<Number>(_loc2_,true);
         }
         if(indices == null || _loc1_ != indices.length)
         {
            indices = new Vector.<uint>(_loc1_,true);
         }
         createPolyLinePreAlloc(_line,vertices,indices,_hasDegenerates);
         _loc3_ = _loc3_ + (vertices.length - 0) * 0.111111111111111;
      }
      
      override protected function shapeHitTestLocalInternal(param1:Number, param2:Number) : Boolean
      {
         var _loc12_:int = 0;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc6_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc11_:Number = NaN;
         if(_line == null)
         {
            return false;
         }
         if(_line.length < 2)
         {
            return false;
         }
         var _loc5_:int = _line.length;
         _loc12_ = 1;
         while(_loc12_ < _loc5_)
         {
            _loc4_ = _line[_loc12_ - 1];
            _loc3_ = _line[_loc12_];
            _loc6_ = (_loc3_.x - _loc4_.x) * (_loc3_.x - _loc4_.x) + (_loc3_.y - _loc4_.y) * (_loc3_.y - _loc4_.y);
            _loc10_ = ((param1 - _loc4_.x) * (_loc3_.x - _loc4_.x) + (param2 - _loc4_.y) * (_loc3_.y - _loc4_.y)) / _loc6_;
            if(!(_loc10_ < 0 || _loc10_ > 1))
            {
               _loc9_ = _loc4_.x + _loc10_ * (_loc3_.x - _loc4_.x);
               _loc7_ = _loc4_.y + _loc10_ * (_loc3_.y - _loc4_.y);
               _loc8_ = (param1 - _loc9_) * (param1 - _loc9_) + (param2 - _loc7_) * (param2 - _loc7_);
               _loc11_ = _loc4_.thickness * (1 - _loc10_) + _loc3_.thickness * _loc10_;
               _loc11_ = _loc11_ + _precisionHitTestDistance;
               if(_loc8_ <= _loc11_ * _loc11_)
               {
                  return true;
               }
            }
            _loc12_++;
         }
         return false;
      }
      
      public function localToParent(param1:Point, param2:Point = null) : Point
      {
         return MatrixUtil.transformCoords(transformationMatrix,param1.x,param1.y,param2);
      }
   }
}

import flash.geom.Point;
import flash.geom.Rectangle;

class StrokeCollisionHelper
{
    
   
   public var localPT1:Point;
   
   public var localPT2:Point;
   
   public var localPT3:Point;
   
   public var localPT4:Point;
   
   public var globalPT1:Point;
   
   public var globalPT2:Point;
   
   public var globalPT3:Point;
   
   public var globalPT4:Point;
   
   public var bounds1:Rectangle;
   
   public var bounds2:Rectangle;
   
   public var testIntersectPoint:Point;
   
   public var s1v0Vector:Vector.<Point> = null;
   
   public var s1v1Vector:Vector.<Point> = null;
   
   public var s2v0Vector:Vector.<Point> = null;
   
   public var s2v1Vector:Vector.<Point> = null;
   
   function StrokeCollisionHelper()
   {
      localPT1 = new Point();
      localPT2 = new Point();
      localPT3 = new Point();
      localPT4 = new Point();
      globalPT1 = new Point();
      globalPT2 = new Point();
      globalPT3 = new Point();
      globalPT4 = new Point();
      bounds1 = new Rectangle();
      bounds2 = new Rectangle();
      testIntersectPoint = new Point();
      super();
   }
}

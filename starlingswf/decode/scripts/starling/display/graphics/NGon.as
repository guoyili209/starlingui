package starling.display.graphics
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import starling.display.graphics.util.TriangleUtil;
   
   public class NGon extends Graphic
   {
      
      private static var _uv:Point;
       
      
      private const DEGREES_TO_RADIANS:Number = 0.017453292519943295;
      
      private var _radius:Number;
      
      private var _innerRadius:Number;
      
      private var _startAngle:Number;
      
      private var _endAngle:Number;
      
      private var _numSides:int;
      
      private var _color:uint = 16777215;
      
      public function NGon(param1:Number = 100, param2:int = 10, param3:Number = 0, param4:Number = 0, param5:Number = 360)
      {
         super();
         this.radius = param1;
         this.numSides = param2;
         this.innerRadius = param3;
         this.startAngle = param4;
         this.endAngle = param5;
         var _loc6_:* = -param1;
         minBounds.y = _loc6_;
         minBounds.x = _loc6_;
         _loc6_ = param1;
         maxBounds.y = _loc6_;
         maxBounds.x = _loc6_;
         if(!_uv)
         {
            _uv = new Point();
         }
      }
      
      private static function buildSimpleNGon(param1:Number, param2:int, param3:Vector.<Number>, param4:Vector.<uint>, param5:Matrix, param6:uint) : void
      {
         var _loc13_:int = 0;
         var _loc19_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc12_:int = 0;
         _uv.x = 0;
         _uv.y = 0;
         if(param5)
         {
            _uv = param5.transformPoint(_uv);
         }
         var _loc16_:Number = (param6 >> 16) / 255;
         var _loc7_:Number = ((param6 & 65280) >> 8) / 255;
         var _loc10_:Number = (param6 & 255) / 255;
         param3.push(0,0,0,_loc16_,_loc7_,_loc10_,1,_uv.x,_uv.y);
         _loc12_++;
         var _loc9_:Number = 3.14159265358979 * 2 / param2;
         var _loc20_:Number = Math.cos(_loc9_);
         var _loc17_:Number = Math.sin(_loc9_);
         var _loc14_:* = 0;
         var _loc11_:* = 1;
         _loc13_ = 0;
         while(_loc13_ < param2)
         {
            _loc19_ = _loc14_ * param1;
            _loc18_ = -_loc11_ * param1;
            _uv.x = _loc19_;
            _uv.y = _loc18_;
            if(param5)
            {
               _uv = param5.transformPoint(_uv);
            }
            param3.push(_loc19_,_loc18_,0,_loc16_,_loc7_,_loc10_,1,_uv.x,_uv.y);
            _loc12_++;
            param4.push(0,_loc12_ - 1,_loc13_ == param2 - 1?1:_loc12_);
            _loc8_ = _loc17_ * _loc11_ + _loc20_ * _loc14_;
            _loc15_ = _loc20_ * _loc11_ - _loc17_ * _loc14_;
            _loc11_ = _loc15_;
            _loc14_ = _loc8_;
            _loc13_++;
         }
      }
      
      private static function buildHoop(param1:Number, param2:Number, param3:int, param4:Vector.<Number>, param5:Vector.<uint>, param6:Matrix, param7:uint) : void
      {
         var _loc14_:int = 0;
         var _loc20_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc13_:int = 0;
         var _loc10_:Number = 3.14159265358979 * 2 / param3;
         var _loc21_:Number = Math.cos(_loc10_);
         var _loc18_:Number = Math.sin(_loc10_);
         var _loc15_:* = 0;
         var _loc12_:* = 1;
         var _loc17_:Number = (param7 >> 16) / 255;
         var _loc8_:Number = ((param7 & 65280) >> 8) / 255;
         var _loc11_:Number = (param7 & 255) / 255;
         _loc14_ = 0;
         while(_loc14_ < param3)
         {
            _loc20_ = _loc15_ * param2;
            _loc19_ = -_loc12_ * param2;
            _uv.x = _loc20_;
            _uv.y = _loc19_;
            if(param6)
            {
               _uv = param6.transformPoint(_uv);
            }
            param4.push(_loc20_,_loc19_,0,_loc17_,_loc8_,_loc11_,1,_uv.x,_uv.y);
            _loc13_++;
            _loc20_ = _loc15_ * param1;
            _loc19_ = -_loc12_ * param1;
            _uv.x = _loc20_;
            _uv.y = _loc19_;
            if(param6)
            {
               _uv = param6.transformPoint(_uv);
            }
            param4.push(_loc20_,_loc19_,0,_loc17_,_loc8_,_loc11_,1,_uv.x,_uv.y);
            _loc13_++;
            if(_loc14_ == param3 - 1)
            {
               param5.push(_loc13_ - 2,_loc13_ - 1,0,0,_loc13_ - 1,1);
            }
            else
            {
               param5.push(_loc13_ - 2,_loc13_,_loc13_ - 1,_loc13_,_loc13_ + 1,_loc13_ - 1);
            }
            _loc9_ = _loc18_ * _loc12_ + _loc21_ * _loc15_;
            _loc16_ = _loc21_ * _loc12_ - _loc18_ * _loc15_;
            _loc12_ = _loc16_;
            _loc15_ = _loc9_;
            _loc14_++;
         }
      }
      
      private static function buildFan(param1:Number, param2:Number, param3:Number, param4:int, param5:Vector.<Number>, param6:Vector.<uint>, param7:Matrix, param8:uint) : void
      {
         var _loc18_:int = 0;
         var _loc13_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc17_:int = 0;
         param5.push(0,0,0,1,1,1,1,0.5,0.5);
         _loc17_++;
         var _loc19_:Number = 3.14159265358979 * 2 / param4;
         var _loc16_:Number = param2 / _loc19_;
         _loc16_ = _loc16_ < 0?-Math.ceil(-_loc16_):int(_loc16_);
         _loc16_ = _loc16_ * _loc19_;
         var _loc21_:Number = (param8 >> 16) / 255;
         var _loc14_:Number = ((param8 & 65280) >> 8) / 255;
         var _loc15_:Number = (param8 & 255) / 255;
         _loc18_ = 0;
         while(_loc18_ <= param4 + 1)
         {
            _loc13_ = _loc16_ + _loc18_ * _loc19_;
            _loc23_ = _loc13_ + _loc19_;
            if(_loc23_ >= param2)
            {
               _loc25_ = Math.sin(_loc13_) * param1;
               _loc24_ = -Math.cos(_loc13_) * param1;
               _loc22_ = _loc13_ - _loc19_;
               if(_loc13_ < param2 && _loc23_ > param2)
               {
                  _loc11_ = Math.sin(_loc23_) * param1;
                  _loc12_ = -Math.cos(_loc23_) * param1;
                  _loc20_ = (param2 - _loc13_) / _loc19_;
                  _loc25_ = _loc25_ + _loc20_ * (_loc11_ - _loc25_);
                  _loc24_ = _loc24_ + _loc20_ * (_loc12_ - _loc24_);
               }
               else if(_loc13_ > param3 && _loc22_ < param3)
               {
                  _loc9_ = Math.sin(_loc22_) * param1;
                  _loc10_ = -Math.cos(_loc22_) * param1;
                  _loc20_ = (param3 - _loc22_) / _loc19_;
                  _loc25_ = _loc9_ + _loc20_ * (_loc25_ - _loc9_);
                  _loc24_ = _loc10_ + _loc20_ * (_loc24_ - _loc10_);
               }
               _uv.x = _loc25_;
               _uv.y = _loc24_;
               if(param7)
               {
                  _uv = param7.transformPoint(_uv);
               }
               param5.push(_loc25_,_loc24_,0,_loc21_,_loc14_,_loc15_,1,_uv.x,_uv.y);
               _loc17_++;
               if(param5.length > 18)
               {
                  param6.push(0,_loc17_ - 2,_loc17_ - 1);
               }
               if(_loc13_ >= param3)
               {
                  break;
               }
            }
            _loc18_++;
         }
      }
      
      private static function buildArc(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<Number>, param7:Vector.<uint>, param8:Matrix, param9:uint) : void
      {
         var _loc27_:int = 0;
         var _loc26_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc15_:int = 0;
         var _loc28_:Number = 3.14159265358979 * 2 / param5;
         var _loc24_:Number = param3 / _loc28_;
         _loc24_ = _loc24_ < 0?-Math.ceil(-_loc24_):int(_loc24_);
         _loc24_ = _loc24_ * _loc28_;
         var _loc30_:Number = (param9 >> 16) / 255;
         var _loc20_:Number = ((param9 & 65280) >> 8) / 255;
         var _loc23_:Number = (param9 & 255) / 255;
         _loc27_ = 0;
         while(_loc27_ <= param5 + 1)
         {
            _loc26_ = _loc24_ + _loc27_ * _loc28_;
            _loc22_ = _loc26_ + _loc28_;
            if(_loc22_ >= param3)
            {
               _loc31_ = Math.sin(_loc26_);
               _loc11_ = Math.cos(_loc26_);
               _loc34_ = _loc31_ * param2;
               _loc33_ = -_loc11_ * param2;
               _loc14_ = _loc31_ * param1;
               _loc25_ = -_loc11_ * param1;
               _loc16_ = _loc26_ - _loc28_;
               if(_loc26_ < param3 && _loc22_ > param3)
               {
                  _loc31_ = Math.sin(_loc22_);
                  _loc11_ = Math.cos(_loc22_);
                  _loc17_ = _loc31_ * param2;
                  _loc19_ = -_loc11_ * param2;
                  _loc10_ = _loc31_ * param1;
                  _loc21_ = -_loc11_ * param1;
                  _loc29_ = (param3 - _loc26_) / _loc28_;
                  _loc34_ = _loc34_ + _loc29_ * (_loc17_ - _loc34_);
                  _loc33_ = _loc33_ + _loc29_ * (_loc19_ - _loc33_);
                  _loc14_ = _loc14_ + _loc29_ * (_loc10_ - _loc14_);
                  _loc25_ = _loc25_ + _loc29_ * (_loc21_ - _loc25_);
               }
               else if(_loc26_ > param4 && _loc16_ < param4)
               {
                  _loc31_ = Math.sin(_loc16_);
                  _loc11_ = Math.cos(_loc16_);
                  _loc12_ = _loc31_ * param2;
                  _loc13_ = -_loc11_ * param2;
                  _loc32_ = _loc31_ * param1;
                  _loc18_ = -_loc11_ * param1;
                  _loc29_ = (param4 - _loc16_) / _loc28_;
                  _loc34_ = _loc12_ + _loc29_ * (_loc34_ - _loc12_);
                  _loc33_ = _loc13_ + _loc29_ * (_loc33_ - _loc13_);
                  _loc14_ = _loc32_ + _loc29_ * (_loc14_ - _loc32_);
                  _loc25_ = _loc18_ + _loc29_ * (_loc25_ - _loc18_);
               }
               _uv.x = _loc34_;
               _uv.y = _loc33_;
               if(param8)
               {
                  _uv = param8.transformPoint(_uv);
               }
               param6.push(_loc34_,_loc33_,0,_loc30_,_loc20_,_loc23_,1,_uv.x,_uv.y);
               _loc15_++;
               _uv.x = _loc14_;
               _uv.y = _loc25_;
               if(param8)
               {
                  _uv = param8.transformPoint(_uv);
               }
               param6.push(_loc14_,_loc25_,0,_loc30_,_loc20_,_loc23_,1,_uv.x,_uv.y);
               _loc15_++;
               if(param6.length > 27)
               {
                  param7.push(_loc15_ - 3,_loc15_ - 2,_loc15_ - 1,_loc15_ - 3,_loc15_ - 4,_loc15_ - 2);
               }
               if(_loc26_ >= param4)
               {
                  break;
               }
            }
            _loc27_++;
         }
      }
      
      public function get endAngle() : Number
      {
         return _endAngle;
      }
      
      public function set endAngle(param1:Number) : void
      {
         _endAngle = param1;
         setGeometryInvalid();
      }
      
      public function get startAngle() : Number
      {
         return _startAngle;
      }
      
      public function set startAngle(param1:Number) : void
      {
         _startAngle = param1;
         setGeometryInvalid();
      }
      
      public function get radius() : Number
      {
         return _radius;
      }
      
      public function set color(param1:uint) : void
      {
         _color = param1;
         setGeometryInvalid();
      }
      
      public function set radius(param1:Number) : void
      {
         param1 = param1 < 0?0:Number(param1);
         _radius = param1;
         var _loc2_:Number = Math.max(_radius,_innerRadius);
         var _loc3_:* = -_loc2_;
         minBounds.y = _loc3_;
         minBounds.x = _loc3_;
         _loc3_ = _loc2_;
         maxBounds.y = _loc3_;
         maxBounds.x = _loc3_;
         setGeometryInvalid();
      }
      
      public function get innerRadius() : Number
      {
         return _innerRadius;
      }
      
      public function set innerRadius(param1:Number) : void
      {
         param1 = param1 < 0?0:Number(param1);
         _innerRadius = param1;
         var _loc2_:Number = Math.max(_radius,_innerRadius);
         var _loc3_:* = -_loc2_;
         minBounds.y = _loc3_;
         minBounds.x = _loc3_;
         _loc3_ = _loc2_;
         maxBounds.y = _loc3_;
         maxBounds.x = _loc3_;
         setGeometryInvalid();
      }
      
      public function get numSides() : int
      {
         return _numSides;
      }
      
      public function set numSides(param1:int) : void
      {
         param1 = param1 < 3?3:param1;
         _numSides = param1;
         setGeometryInvalid();
      }
      
      override protected function buildGeometry() : void
      {
         vertices = new Vector.<Number>();
         indices = new Vector.<uint>();
         var _loc3_:Number = _startAngle;
         var _loc6_:Number = _endAngle;
         var _loc4_:int = _loc3_ < 0?-1:1;
         var _loc2_:int = _loc6_ < 0?-1:1;
         _loc3_ = _loc3_ * _loc4_;
         _loc6_ = _loc6_ * _loc2_;
         _loc6_ = _loc6_ % 360;
         _loc6_ = _loc6_ * _loc2_;
         _loc3_ = _loc3_ % 360;
         if(_loc6_ < _loc3_)
         {
            _loc6_ = _loc6_ + 360;
         }
         _loc3_ = _loc3_ * (_loc4_ * 0.0174532925199433);
         _loc6_ = _loc6_ * 0.0174532925199433;
         if(_loc6_ - _loc3_ > 3.14159265358979 * 2)
         {
            _loc6_ = _loc6_ - 3.14159265358979 * 2;
         }
         var _loc1_:Number = _innerRadius < _radius?_innerRadius:Number(_radius);
         var _loc5_:Number = _radius > _innerRadius?_radius:Number(_innerRadius);
         var _loc7_:Boolean = _loc3_ != 0 || _loc6_ != 0;
         if(_loc1_ == 0 && !_loc7_)
         {
            buildSimpleNGon(_loc5_,_numSides,vertices,indices,_uvMatrix,_color);
         }
         else if(_loc1_ != 0 && !_loc7_)
         {
            buildHoop(_loc1_,_loc5_,_numSides,vertices,indices,_uvMatrix,_color);
         }
         else if(_loc1_ == 0)
         {
            buildFan(_loc5_,_loc3_,_loc6_,_numSides,vertices,indices,_uvMatrix,_color);
         }
         else
         {
            buildArc(_loc1_,_loc5_,_loc3_,_loc6_,_numSides,vertices,indices,_uvMatrix,_color);
         }
      }
      
      override protected function shapeHitTestLocalInternal(param1:Number, param2:Number) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc13_:int = 0;
         var _loc12_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc3_:int = indices.length;
         if(_loc3_ < 2)
         {
            validateNow();
            _loc3_ = indices.length;
            if(_loc3_ < 2)
            {
               return false;
            }
         }
         if(_innerRadius == 0 && _radius > 0 && _startAngle == 0 && _endAngle == 360 && _numSides > 20)
         {
            if(Math.sqrt(param1 * param1 + param2 * param2) < _radius)
            {
               return true;
            }
            return false;
         }
         _loc4_ = 2;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = indices[_loc4_ - 2];
            _loc13_ = indices[_loc4_ - 1];
            _loc12_ = indices[_loc4_ - 0];
            _loc6_ = vertices[9 * _loc5_ + 0];
            _loc7_ = vertices[9 * _loc5_ + 1];
            _loc11_ = vertices[9 * _loc13_ + 0];
            _loc8_ = vertices[9 * _loc13_ + 1];
            _loc9_ = vertices[9 * _loc12_ + 0];
            _loc10_ = vertices[9 * _loc12_ + 1];
            if(TriangleUtil.isPointInTriangle(_loc6_,_loc7_,_loc11_,_loc8_,_loc9_,_loc10_,param1,param2))
            {
               return true;
            }
            _loc4_ = _loc4_ + 3;
         }
         return false;
      }
   }
}

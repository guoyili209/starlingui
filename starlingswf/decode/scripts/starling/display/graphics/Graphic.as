package starling.display.graphics
{
   import flash.display3D.Context3D;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.VertexBuffer3D;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.materials.IMaterial;
   import starling.display.materials.StandardMaterial;
   import starling.display.shaders.fragment.VertexColorFragmentShader;
   import starling.display.shaders.vertex.StandardVertexShader;
   import starling.errors.AbstractMethodError;
   import starling.errors.MissingContextError;
   import starling.events.Event;
   
   public class Graphic extends DisplayObject
   {
      
      protected static const VERTEX_STRIDE:int = 9;
      
      protected static var sHelperMatrix:Matrix = new Matrix();
      
      protected static var defaultVertexShaderDictionary:Dictionary = new Dictionary(true);
      
      protected static var defaultFragmentShaderDictionary:Dictionary = new Dictionary(true);
      
      private static var sGraphicHelperRect:Rectangle = new Rectangle();
      
      private static var sGraphicHelperPoint:Point = new Point();
      
      private static var sGraphicHelperPointTR:Point = new Point();
      
      private static var sGraphicHelperPointBL:Point = new Point();
       
      
      protected var _material:IMaterial;
      
      protected var vertexBuffer:VertexBuffer3D;
      
      protected var indexBuffer:IndexBuffer3D;
      
      protected var vertices:Vector.<Number>;
      
      protected var indices:Vector.<uint>;
      
      protected var _uvMatrix:Matrix;
      
      protected var isInvalid:Boolean = false;
      
      protected var uvsInvalid:Boolean = false;
      
      protected var hasValidatedGeometry:Boolean = false;
      
      protected var minBounds:Point;
      
      protected var maxBounds:Point;
      
      protected var _precisionHitTest:Boolean = false;
      
      protected var _precisionHitTestDistance:Number = 0;
      
      public function Graphic()
      {
         super();
         indices = new Vector.<uint>();
         vertices = new Vector.<Number>();
         var _loc2_:Starling = Starling.current;
         var _loc1_:StandardVertexShader = defaultVertexShaderDictionary[_loc2_];
         if(_loc1_ == null)
         {
            _loc1_ = new StandardVertexShader();
            defaultVertexShaderDictionary[_loc2_] = _loc1_;
         }
         var _loc3_:VertexColorFragmentShader = defaultFragmentShaderDictionary[_loc2_];
         if(_loc3_ == null)
         {
            _loc3_ = new VertexColorFragmentShader();
            defaultFragmentShaderDictionary[_loc2_] = _loc3_;
         }
         _material = new StandardMaterial(_loc1_,_loc3_);
         minBounds = new Point();
         maxBounds = new Point();
         if(Starling.current)
         {
            Starling.current.addEventListener("context3DCreate",onContextCreated);
         }
      }
      
      private function onContextCreated(param1:Event) : void
      {
         hasValidatedGeometry = false;
         isInvalid = true;
         uvsInvalid = true;
         _material.restoreOnLostContext();
      }
      
      override public function dispose() : void
      {
         if(Starling.current)
         {
            Starling.current.removeEventListener("context3DCreate",onContextCreated);
            super.dispose();
         }
         if(vertexBuffer)
         {
            vertexBuffer.dispose();
            vertexBuffer = null;
         }
         if(indexBuffer)
         {
            indexBuffer.dispose();
            indexBuffer = null;
         }
         if(material)
         {
            material.dispose();
            material = null;
         }
         vertices = null;
         indices = null;
         _uvMatrix = null;
         minBounds = null;
         maxBounds = null;
         hasValidatedGeometry = false;
      }
      
      public function set material(param1:IMaterial) : void
      {
         _material = param1;
      }
      
      public function get material() : IMaterial
      {
         return _material;
      }
      
      public function get uvMatrix() : Matrix
      {
         return _uvMatrix;
      }
      
      public function set uvMatrix(param1:Matrix) : void
      {
         _uvMatrix = param1;
         uvsInvalid = true;
         hasValidatedGeometry = false;
      }
      
      public function shapeHitTest(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Point = globalToLocal(new Point(param1,param2));
         return _loc3_.x >= minBounds.x && _loc3_.x <= maxBounds.x && _loc3_.y >= minBounds.y && _loc3_.y <= maxBounds.y;
      }
      
      public function set precisionHitTest(param1:Boolean) : void
      {
         _precisionHitTest = param1;
      }
      
      public function get precisionHitTest() : Boolean
      {
         return _precisionHitTest;
      }
      
      public function set precisionHitTestDistance(param1:Number) : void
      {
         _precisionHitTestDistance = param1;
      }
      
      public function get precisionHitTestDistance() : Number
      {
         return _precisionHitTestDistance;
      }
      
      protected function shapeHitTestLocalInternal(param1:Number, param2:Number) : Boolean
      {
         return param1 >= minBounds.x - _precisionHitTestDistance && param1 <= maxBounds.x + _precisionHitTestDistance && param2 >= minBounds.y - _precisionHitTestDistance && param2 <= maxBounds.y + _precisionHitTestDistance;
      }
      
      override public function hitTest(param1:Point, param2:Boolean = false) : DisplayObject
      {
         if(param2 && (visible == false || touchable == false))
         {
            return null;
         }
         if(minBounds == null || maxBounds == null)
         {
            return null;
         }
         if(getBounds(this,sGraphicHelperRect).containsPoint(param1))
         {
            if(_precisionHitTest)
            {
               if(shapeHitTestLocalInternal(param1.x,param1.y))
               {
                  return this;
               }
            }
            else
            {
               return this;
            }
         }
         return null;
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         if(param2 == null)
         {
            param2 = new Rectangle();
         }
         if(param1 == this)
         {
            param2.x = minBounds.x;
            param2.y = minBounds.y;
            param2.right = maxBounds.x;
            param2.bottom = maxBounds.y;
            if(_precisionHitTest)
            {
               param2.x = param2.x - _precisionHitTestDistance;
               param2.y = param2.y - _precisionHitTestDistance;
               param2.width = param2.width + _precisionHitTestDistance * 2;
               param2.height = param2.height + _precisionHitTestDistance * 2;
            }
            return param2;
         }
         getTransformationMatrix(param1,sHelperMatrix);
         var _loc5_:Matrix = sHelperMatrix;
         sGraphicHelperPointTR.x = minBounds.x + (maxBounds.x - minBounds.x);
         sGraphicHelperPointTR.y = minBounds.y;
         sGraphicHelperPointBL.x = minBounds.x;
         sGraphicHelperPointBL.y = minBounds.y + (maxBounds.y - minBounds.y);
         var _loc4_:Point = sHelperMatrix.transformPoint(minBounds);
         sGraphicHelperPointTR = sHelperMatrix.transformPoint(sGraphicHelperPointTR);
         var _loc3_:Point = sHelperMatrix.transformPoint(maxBounds);
         sGraphicHelperPointBL = sHelperMatrix.transformPoint(sGraphicHelperPointBL);
         param2.x = Math.min(_loc4_.x,_loc3_.x,sGraphicHelperPointTR.x,sGraphicHelperPointBL.x);
         param2.y = Math.min(_loc4_.y,_loc3_.y,sGraphicHelperPointTR.y,sGraphicHelperPointBL.y);
         param2.right = Math.max(_loc4_.x,_loc3_.x,sGraphicHelperPointTR.x,sGraphicHelperPointBL.x);
         param2.bottom = Math.max(_loc4_.y,_loc3_.y,sGraphicHelperPointTR.y,sGraphicHelperPointBL.y);
         if(_precisionHitTest)
         {
            param2.x = param2.x - _precisionHitTestDistance;
            param2.y = param2.y - _precisionHitTestDistance;
            param2.width = param2.width + _precisionHitTestDistance * 2;
            param2.height = param2.height + _precisionHitTestDistance * 2;
         }
         return param2;
      }
      
      protected function buildGeometry() : void
      {
         throw new AbstractMethodError();
      }
      
      protected function applyUVMatrix() : void
      {
         var _loc2_:int = 0;
         if(!vertices)
         {
            return;
         }
         if(!_uvMatrix)
         {
            return;
         }
         var _loc1_:Point = new Point();
         _loc2_ = 0;
         while(_loc2_ < vertices.length)
         {
            _loc1_.x = vertices[_loc2_ + 7];
            _loc1_.y = vertices[_loc2_ + 8];
            _loc1_ = _uvMatrix.transformPoint(_loc1_);
            vertices[_loc2_ + 7] = _loc1_.x;
            vertices[_loc2_ + 8] = _loc1_.y;
            _loc2_ = _loc2_ + 9;
         }
      }
      
      public function validateNow() : void
      {
         if(hasValidatedGeometry)
         {
            return;
         }
         hasValidatedGeometry = true;
         if(vertexBuffer && (isInvalid || uvsInvalid))
         {
            vertexBuffer.dispose();
            indexBuffer.dispose();
         }
         if(isInvalid)
         {
            buildGeometry();
            applyUVMatrix();
         }
         else if(uvsInvalid)
         {
            applyUVMatrix();
         }
      }
      
      protected function setGeometryInvalid() : void
      {
         isInvalid = true;
         hasValidatedGeometry = false;
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         var _loc4_:int = 0;
         validateNow();
         if(indices == null || indices.length < 3)
         {
            return;
         }
         if(isInvalid || uvsInvalid)
         {
            _loc4_ = vertices.length / 9;
            vertexBuffer = Starling.context.createVertexBuffer(_loc4_,9);
            vertexBuffer.uploadFromVector(vertices,0,_loc4_);
            indexBuffer = Starling.context.createIndexBuffer(indices.length);
            indexBuffer.uploadFromVector(indices,0,indices.length);
            uvsInvalid = false;
            isInvalid = false;
         }
         param1.finishQuadBatch();
         var _loc3_:Context3D = Starling.context;
         if(_loc3_ == null)
         {
            throw new MissingContextError();
         }
         RenderSupport.setBlendFactors(false,this.blendMode == "auto"?param1.blendMode:this.blendMode);
         _material.drawTriangles(Starling.context,param1.mvpMatrix3D,vertexBuffer,indexBuffer,param2 * this.alpha);
         _loc3_.setTextureAt(0,null);
         _loc3_.setTextureAt(1,null);
         _loc3_.setVertexBufferAt(0,null);
         _loc3_.setVertexBufferAt(1,null);
         _loc3_.setVertexBufferAt(2,null);
      }
   }
}

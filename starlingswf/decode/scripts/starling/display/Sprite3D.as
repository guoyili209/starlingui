package starling.display
{
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import starling.core.RenderSupport;
   import starling.events.Event;
   import starling.utils.MathUtil;
   import starling.utils.MatrixUtil;
   import starling.utils.rad2deg;
   
   public class Sprite3D extends DisplayObjectContainer
   {
      
      private static const E:Number = 1.0E-5;
      
      private static var sHelperPoint:Vector3D = new Vector3D();
      
      private static var sHelperPointAlt:Vector3D = new Vector3D();
      
      private static var sHelperMatrix:Matrix3D = new Matrix3D();
       
      
      private var mRotationX:Number;
      
      private var mRotationY:Number;
      
      private var mScaleZ:Number;
      
      private var mPivotZ:Number;
      
      private var mZ:Number;
      
      private var mTransformationMatrix:Matrix;
      
      private var mTransformationMatrix3D:Matrix3D;
      
      private var mTransformationChanged:Boolean;
      
      public function Sprite3D()
      {
         super();
         mScaleZ = 1;
         mZ = 0;
         mPivotZ = 0;
         mRotationY = 0;
         mRotationX = 0;
         mTransformationMatrix = new Matrix();
         mTransformationMatrix3D = new Matrix3D();
         setIs3D(true);
         addEventListener("added",onAddedChild);
         addEventListener("removed",onRemovedChild);
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         if(is2D)
         {
            super.render(param1,param2);
         }
         else
         {
            param1.finishQuadBatch();
            param1.pushMatrix3D();
            param1.transformMatrix3D(this);
            super.render(param1,param2);
            param1.finishQuadBatch();
            param1.popMatrix3D();
         }
      }
      
      override public function hitTest(param1:Point, param2:Boolean = false) : DisplayObject
      {
         if(is2D)
         {
            return super.hitTest(param1,param2);
         }
         if(param2 && (!visible || !touchable))
         {
            return null;
         }
         sHelperMatrix.copyFrom(transformationMatrix3D);
         sHelperMatrix.invert();
         stage.getCameraPosition(this,sHelperPoint);
         MatrixUtil.transformCoords3D(sHelperMatrix,param1.x,param1.y,0,sHelperPointAlt);
         MathUtil.intersectLineWithXYPlane(sHelperPoint,sHelperPointAlt,param1);
         return super.hitTest(param1,param2);
      }
      
      private function onAddedChild(param1:Event) : void
      {
         recursivelySetIs3D(param1.target as DisplayObject,true);
      }
      
      private function onRemovedChild(param1:Event) : void
      {
         recursivelySetIs3D(param1.target as DisplayObject,false);
      }
      
      private function recursivelySetIs3D(param1:DisplayObject, param2:Boolean) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 is Sprite3D)
         {
            return;
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc3_ = param1 as DisplayObjectContainer;
            _loc4_ = _loc3_.numChildren;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               recursivelySetIs3D(_loc3_.getChildAt(_loc5_),param2);
               _loc5_++;
            }
         }
         param1.setIs3D(param2);
      }
      
      private function updateMatrices() : void
      {
         mTransformationMatrix3D.identity();
         mTransformationMatrix3D.appendScale(scaleX || 0.00001,scaleY || 0.00001,mScaleZ || 0.00001);
         mTransformationMatrix3D.appendRotation(rad2deg(mRotationX),Vector3D.X_AXIS);
         mTransformationMatrix3D.appendRotation(rad2deg(mRotationY),Vector3D.Y_AXIS);
         mTransformationMatrix3D.appendRotation(rad2deg(rotation),Vector3D.Z_AXIS);
         mTransformationMatrix3D.appendTranslation(x,y,mZ);
         mTransformationMatrix3D.prependTranslation(-pivotX,-pivotY,-mPivotZ);
         if(is2D)
         {
            MatrixUtil.convertTo2D(mTransformationMatrix3D,mTransformationMatrix);
         }
         else
         {
            mTransformationMatrix.identity();
         }
      }
      
      private final function get is2D() : Boolean
      {
         return mZ > -0.00001 && mZ < 0.00001 && mRotationX > -0.00001 && mRotationX < 0.00001 && mRotationY > -0.00001 && mRotationY < 0.00001 && mPivotZ > -0.00001 && mPivotZ < 0.00001;
      }
      
      override public function get transformationMatrix() : Matrix
      {
         if(mTransformationChanged)
         {
            updateMatrices();
            mTransformationChanged = false;
         }
         return mTransformationMatrix;
      }
      
      override public function set transformationMatrix(param1:Matrix) : void
      {
         .super.transformationMatrix = param1;
         mZ = 0;
         mPivotZ = 0;
         mRotationY = 0;
         mRotationX = 0;
         mTransformationChanged = true;
      }
      
      override public function get transformationMatrix3D() : Matrix3D
      {
         if(mTransformationChanged)
         {
            updateMatrices();
            mTransformationChanged = false;
         }
         return mTransformationMatrix3D;
      }
      
      override public function set x(param1:Number) : void
      {
         .super.x = param1;
         mTransformationChanged = true;
      }
      
      override public function set y(param1:Number) : void
      {
         .super.y = param1;
         mTransformationChanged = true;
      }
      
      public function get z() : Number
      {
         return mZ;
      }
      
      public function set z(param1:Number) : void
      {
         mZ = param1;
         mTransformationChanged = true;
      }
      
      override public function set pivotX(param1:Number) : void
      {
         .super.pivotX = param1;
         mTransformationChanged = true;
      }
      
      override public function set pivotY(param1:Number) : void
      {
         .super.pivotY = param1;
         mTransformationChanged = true;
      }
      
      public function get pivotZ() : Number
      {
         return mPivotZ;
      }
      
      public function set pivotZ(param1:Number) : void
      {
         mPivotZ = param1;
         mTransformationChanged = true;
      }
      
      override public function set scaleX(param1:Number) : void
      {
         .super.scaleX = param1;
         mTransformationChanged = true;
      }
      
      override public function set scaleY(param1:Number) : void
      {
         .super.scaleY = param1;
         mTransformationChanged = true;
      }
      
      public function get scaleZ() : Number
      {
         return mScaleZ;
      }
      
      public function set scaleZ(param1:Number) : void
      {
         mScaleZ = param1;
         mTransformationChanged = true;
      }
      
      override public function set skewX(param1:Number) : void
      {
         throw new Error("3D objects do not support skewing");
      }
      
      override public function set skewY(param1:Number) : void
      {
         throw new Error("3D objects do not support skewing");
      }
      
      override public function set rotation(param1:Number) : void
      {
         .super.rotation = param1;
         mTransformationChanged = true;
      }
      
      public function get rotationX() : Number
      {
         return mRotationX;
      }
      
      public function set rotationX(param1:Number) : void
      {
         mRotationX = MathUtil.normalizeAngle(param1);
         mTransformationChanged = true;
      }
      
      public function get rotationY() : Number
      {
         return mRotationY;
      }
      
      public function set rotationY(param1:Number) : void
      {
         mRotationY = MathUtil.normalizeAngle(param1);
         mTransformationChanged = true;
      }
      
      public function get rotationZ() : Number
      {
         return rotation;
      }
      
      public function set rotationZ(param1:Number) : void
      {
         rotation = param1;
      }
   }
}

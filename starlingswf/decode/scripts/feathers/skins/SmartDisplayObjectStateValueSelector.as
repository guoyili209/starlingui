package feathers.skins
{
   import feathers.display.Scale3Image;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale3Textures;
   import feathers.textures.Scale9Textures;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.textures.ConcreteTexture;
   import starling.textures.SubTexture;
   import starling.textures.Texture;
   
   public class SmartDisplayObjectStateValueSelector extends StateWithToggleValueSelector
   {
       
      
      protected var _displayObjectProperties:Object;
      
      protected var _handlers:Dictionary;
      
      public function SmartDisplayObjectStateValueSelector()
      {
         _handlers = new Dictionary(true);
         super();
         this.setValueTypeHandler(Texture,textureValueTypeHandler);
         this.setValueTypeHandler(ConcreteTexture,textureValueTypeHandler);
         this.setValueTypeHandler(SubTexture,textureValueTypeHandler);
         this.setValueTypeHandler(Scale9Textures,scale9TextureValueTypeHandler);
         this.setValueTypeHandler(Scale3Textures,scale3TextureValueTypeHandler);
         this.setValueTypeHandler(Number,uintValueTypeHandler);
      }
      
      public static function textureValueTypeHandler(param1:Texture, param2:DisplayObject = null) : DisplayObject
      {
         var _loc3_:* = null;
         if(param2 && Object(param2).constructor === Image)
         {
            _loc3_ = Image(param2);
            _loc3_.texture = param1;
            _loc3_.readjustSize();
         }
         if(!_loc3_)
         {
            _loc3_ = new Image(param1);
         }
         return _loc3_;
      }
      
      public static function scale3TextureValueTypeHandler(param1:Scale3Textures, param2:DisplayObject = null) : DisplayObject
      {
         var _loc3_:* = null;
         if(param2 && Object(param2).constructor === Scale3Image)
         {
            _loc3_ = Scale3Image(param2);
            _loc3_.textures = param1;
            _loc3_.readjustSize();
         }
         if(!_loc3_)
         {
            _loc3_ = new Scale3Image(param1);
         }
         return _loc3_;
      }
      
      public static function scale9TextureValueTypeHandler(param1:Scale9Textures, param2:DisplayObject = null) : DisplayObject
      {
         var _loc3_:* = null;
         if(param2 && Object(param2).constructor === Scale9Image)
         {
            _loc3_ = Scale9Image(param2);
            _loc3_.textures = param1;
            _loc3_.readjustSize();
         }
         if(!_loc3_)
         {
            _loc3_ = new Scale9Image(param1);
         }
         return _loc3_;
      }
      
      public static function uintValueTypeHandler(param1:uint, param2:DisplayObject = null) : DisplayObject
      {
         var _loc3_:* = null;
         if(param2 && Object(param2).constructor === Quad)
         {
            _loc3_ = Quad(param2);
         }
         if(!_loc3_)
         {
            _loc3_ = new Quad(1,1,param1);
         }
         _loc3_.color = param1;
         return _loc3_;
      }
      
      public function get displayObjectProperties() : Object
      {
         if(!this._displayObjectProperties)
         {
            this._displayObjectProperties = {};
         }
         return this._displayObjectProperties;
      }
      
      public function set displayObjectProperties(param1:Object) : void
      {
         this._displayObjectProperties = param1;
      }
      
      override public function setValueForState(param1:Object, param2:Object, param3:Boolean = false) : void
      {
         var _loc4_:* = null;
         if(param1 !== null)
         {
            _loc4_ = Class(param1.constructor);
            if(this._handlers[_loc4_] == null)
            {
               throw new ArgumentError("Handler for value type " + _loc4_ + " has not been set.");
            }
         }
         super.setValueForState(param1,param2,param3);
      }
      
      override public function updateValue(param1:Object, param2:Object, param3:Object = null) : Object
      {
         var _loc8_:* = null;
         var _loc6_:* = null;
         var _loc7_:Object = super.updateValue(param1,param2);
         if(_loc7_ === null)
         {
            return null;
         }
         var _loc5_:Function = this.valueToValueTypeHandler(_loc7_);
         if(_loc5_ != null)
         {
            _loc8_ = _loc5_(_loc7_,param3);
            var _loc10_:int = 0;
            var _loc9_:* = this._displayObjectProperties;
            for(var _loc4_ in this._displayObjectProperties)
            {
               _loc6_ = this._displayObjectProperties[_loc4_];
               _loc8_[_loc4_] = _loc6_;
            }
            return _loc8_;
         }
         throw new ArgumentError("Invalid value: ",_loc7_);
      }
      
      public function setValueTypeHandler(param1:Class, param2:Function) : void
      {
         this._handlers[param1] = param2;
      }
      
      public function getValueTypeHandler(param1:Class) : Function
      {
         return this._handlers[param1] as Function;
      }
      
      public function clearValueTypeHandler(param1:Class) : void
      {
      }
      
      protected function valueToValueTypeHandler(param1:Object) : Function
      {
         var _loc2_:Class = Class(param1.constructor);
         return this._handlers[_loc2_] as Function;
      }
   }
}

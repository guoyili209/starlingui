package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.ITextRenderer;
   import feathers.skins.IStyleProvider;
   import flash.display.BitmapData;
   import flash.filters.BitmapFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.events.Event;
   import starling.textures.ConcreteTexture;
   import starling.textures.Texture;
   import starling.utils.getNextPowerOfTwo;
   
   public class TextFieldTextRenderer extends FeathersControl implements ITextRenderer
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_RECTANGLE:Rectangle = new Rectangle();
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var textField:TextField;
      
      protected var textSnapshot:Image;
      
      protected var textSnapshots:Vector.<Image>;
      
      protected var _textSnapshotOffsetX:Number = 0;
      
      protected var _textSnapshotOffsetY:Number = 0;
      
      protected var _previousActualWidth:Number = NaN;
      
      protected var _previousActualHeight:Number = NaN;
      
      protected var _snapshotWidth:int = 0;
      
      protected var _snapshotHeight:int = 0;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _hasMeasured:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _isHTML:Boolean = false;
      
      protected var _textFormat:TextFormat;
      
      protected var _disabledTextFormat:TextFormat;
      
      protected var _styleSheet:StyleSheet;
      
      protected var _embedFonts:Boolean = false;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _snapToPixels:Boolean = true;
      
      private var _antiAliasType:String = "advanced";
      
      private var _background:Boolean = false;
      
      private var _backgroundColor:uint = 16777215;
      
      private var _border:Boolean = false;
      
      private var _borderColor:uint = 0;
      
      private var _condenseWhite:Boolean = false;
      
      private var _displayAsPassword:Boolean = false;
      
      private var _gridFitType:String = "pixel";
      
      private var _sharpness:Number = 0;
      
      private var _thickness:Number = 0;
      
      protected var _maxTextureDimensions:int = 2048;
      
      protected var _nativeFilters:Array;
      
      protected var _useGutter:Boolean = false;
      
      public function TextFieldTextRenderer()
      {
         super();
         this.isQuickHitAreaEnabled = true;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return TextFieldTextRenderer.globalStyleProvider;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._text == param1)
         {
            return;
         }
         if(param1 === null)
         {
            param1 = "";
         }
         this._text = param1;
         this.invalidate("data");
      }
      
      public function get isHTML() : Boolean
      {
         return this._isHTML;
      }
      
      public function set isHTML(param1:Boolean) : void
      {
         if(this._isHTML == param1)
         {
            return;
         }
         this._isHTML = param1;
         this.invalidate("data");
      }
      
      public function get textFormat() : TextFormat
      {
         return this._textFormat;
      }
      
      public function set textFormat(param1:TextFormat) : void
      {
         if(this._textFormat == param1)
         {
            return;
         }
         this._textFormat = param1;
         this.invalidate("styles");
      }
      
      public function get disabledTextFormat() : TextFormat
      {
         return this._disabledTextFormat;
      }
      
      public function set disabledTextFormat(param1:TextFormat) : void
      {
         if(this._disabledTextFormat == param1)
         {
            return;
         }
         this._disabledTextFormat = param1;
         this.invalidate("styles");
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
      
      public function set styleSheet(param1:StyleSheet) : void
      {
         if(this._styleSheet == param1)
         {
            return;
         }
         this._styleSheet = param1;
         this.invalidate("styles");
      }
      
      public function get embedFonts() : Boolean
      {
         return this._embedFonts;
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         if(this._embedFonts == param1)
         {
            return;
         }
         this._embedFonts = param1;
         this.invalidate("styles");
      }
      
      public function get baseline() : Number
      {
         if(!this.textField)
         {
            return 0;
         }
         var _loc1_:* = 0;
         if(this._useGutter)
         {
            _loc1_ = 2;
         }
         return _loc1_ + this.textField.getLineMetrics(0).ascent;
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this._wordWrap == param1)
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate("styles");
      }
      
      public function get snapToPixels() : Boolean
      {
         return this._snapToPixels;
      }
      
      public function set snapToPixels(param1:Boolean) : void
      {
         this._snapToPixels = param1;
      }
      
      public function get antiAliasType() : String
      {
         return this._antiAliasType;
      }
      
      public function set antiAliasType(param1:String) : void
      {
         if(this._antiAliasType == param1)
         {
            return;
         }
         this._antiAliasType = param1;
         this.invalidate("styles");
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function set background(param1:Boolean) : void
      {
         if(this._background == param1)
         {
            return;
         }
         this._background = param1;
         this.invalidate("styles");
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         if(this._backgroundColor == param1)
         {
            return;
         }
         this._backgroundColor = param1;
         this.invalidate("styles");
      }
      
      public function get border() : Boolean
      {
         return this._border;
      }
      
      public function set border(param1:Boolean) : void
      {
         if(this._border == param1)
         {
            return;
         }
         this._border = param1;
         this.invalidate("styles");
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function set borderColor(param1:uint) : void
      {
         if(this._borderColor == param1)
         {
            return;
         }
         this._borderColor = param1;
         this.invalidate("styles");
      }
      
      public function get condenseWhite() : Boolean
      {
         return this._condenseWhite;
      }
      
      public function set condenseWhite(param1:Boolean) : void
      {
         if(this._condenseWhite == param1)
         {
            return;
         }
         this._condenseWhite = param1;
         this.invalidate("styles");
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(this._displayAsPassword == param1)
         {
            return;
         }
         this._displayAsPassword = param1;
         this.invalidate("styles");
      }
      
      public function get gridFitType() : String
      {
         return this._gridFitType;
      }
      
      public function set gridFitType(param1:String) : void
      {
         if(this._gridFitType == param1)
         {
            return;
         }
         this._gridFitType = param1;
         this.invalidate("styles");
      }
      
      public function get sharpness() : Number
      {
         return this._sharpness;
      }
      
      public function set sharpness(param1:Number) : void
      {
         if(this._sharpness == param1)
         {
            return;
         }
         this._sharpness = param1;
         this.invalidate("data");
      }
      
      public function get thickness() : Number
      {
         return this._thickness;
      }
      
      public function set thickness(param1:Number) : void
      {
         if(this._thickness == param1)
         {
            return;
         }
         this._thickness = param1;
         this.invalidate("data");
      }
      
      public function get maxTextureDimensions() : int
      {
         return this._maxTextureDimensions;
      }
      
      public function set maxTextureDimensions(param1:int) : void
      {
         if(Starling.current.profile == "baselineConstrained")
         {
            param1 = getNextPowerOfTwo(param1);
         }
         if(this._maxTextureDimensions == param1)
         {
            return;
         }
         this._maxTextureDimensions = param1;
         this._needsNewTexture = true;
         this.invalidate("size");
      }
      
      public function get nativeFilters() : Array
      {
         return this._nativeFilters;
      }
      
      public function set nativeFilters(param1:Array) : void
      {
         if(this._nativeFilters == param1)
         {
            return;
         }
         this._nativeFilters = param1;
         this.invalidate("styles");
      }
      
      public function get useGutter() : Boolean
      {
         return this._useGutter;
      }
      
      public function set useGutter(param1:Boolean) : void
      {
         if(this._useGutter == param1)
         {
            return;
         }
         this._useGutter = param1;
         this.invalidate("styles");
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         var _loc2_:* = null;
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
         if(this.textSnapshots)
         {
            _loc1_ = this.textSnapshots.length;
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ = this.textSnapshots[_loc3_];
               _loc2_.texture.dispose();
               this.removeChild(_loc2_,true);
               _loc3_++;
            }
            this.textSnapshots = null;
         }
         this.textField = null;
         this._previousActualWidth = NaN;
         this._previousActualHeight = NaN;
         this._needsNewTexture = false;
         this._snapshotWidth = 0;
         this._snapshotHeight = 0;
         super.dispose();
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         if(this.textSnapshot)
         {
            if(this._snapToPixels)
            {
               this.getTransformationMatrix(this.stage,HELPER_MATRIX);
               this.textSnapshot.x = this._textSnapshotOffsetX + Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
               this.textSnapshot.y = this._textSnapshotOffsetY + Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
            }
            else
            {
               this.textSnapshot.x = this._textSnapshotOffsetX;
               this.textSnapshot.y = this._textSnapshotOffsetY;
            }
         }
         super.render(param1,param2);
      }
      
      public function measureText(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:* = this.explicitWidth !== this.explicitWidth;
         var _loc3_:* = this.explicitHeight !== this.explicitHeight;
         if(!_loc2_ && !_loc3_)
         {
            param1.x = this.explicitWidth;
            param1.y = this.explicitHeight;
            return param1;
         }
         if(!this._isInitialized)
         {
            this.initializeInternal();
         }
         this.commit();
         param1 = this.measure(param1);
         return param1;
      }
      
      override protected function initialize() : void
      {
         var _loc1_:Number = NaN;
         if(!this.textField)
         {
            this.textField = new TextField();
            _loc1_ = Starling.contentScaleFactor;
            this.textField.scaleX = _loc1_;
            this.textField.scaleY = _loc1_;
            this.textField.mouseWheelEnabled = false;
            this.textField.mouseEnabled = false;
            this.textField.selectable = false;
            this.textField.multiline = true;
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("size");
         this.commit();
         this._hasMeasured = false;
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layout(_loc1_);
      }
      
      protected function commit() : void
      {
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("state");
         if(_loc3_)
         {
            this.textField.antiAliasType = this._antiAliasType;
            this.textField.background = this._background;
            this.textField.backgroundColor = this._backgroundColor;
            this.textField.border = this._border;
            this.textField.borderColor = this._borderColor;
            this.textField.condenseWhite = this._condenseWhite;
            this.textField.displayAsPassword = this._displayAsPassword;
            this.textField.gridFitType = this._gridFitType;
            this.textField.sharpness = this._sharpness;
            this.textField.thickness = this._thickness;
            this.textField.filters = this._nativeFilters;
         }
         if(_loc1_ || _loc3_ || _loc2_)
         {
            this.textField.wordWrap = this._wordWrap;
            this.textField.embedFonts = this._embedFonts;
            if(this._styleSheet)
            {
               this.textField.styleSheet = this._styleSheet;
            }
            else
            {
               this.textField.styleSheet = null;
               if(!this._isEnabled && this._disabledTextFormat)
               {
                  this.textField.defaultTextFormat = this._disabledTextFormat;
               }
               else if(this._textFormat)
               {
                  this.textField.defaultTextFormat = this._textFormat;
               }
            }
            if(this._isHTML)
            {
               this.textField.htmlText = this._text;
            }
            else
            {
               this.textField.text = this._text;
            }
         }
      }
      
      protected function measure(param1:Point = null) : Point
      {
         var _loc5_:Number = NaN;
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc3_:* = this.explicitWidth !== this.explicitWidth;
         var _loc8_:* = this.explicitHeight !== this.explicitHeight;
         this.textField.autoSize = "left";
         this.textField.wordWrap = false;
         var _loc7_:Number = Starling.contentScaleFactor;
         var _loc4_:* = 4;
         if(this._useGutter)
         {
            _loc4_ = 0;
         }
         var _loc6_:Number = this.explicitWidth;
         if(_loc3_)
         {
            _loc5_ = this.textField.width;
            _loc6_ = this.textField.width / _loc7_ - _loc4_;
            if(_loc6_ < this._minWidth)
            {
               _loc6_ = this._minWidth;
            }
            else if(_loc6_ > this._maxWidth)
            {
               _loc6_ = this._maxWidth;
            }
         }
         if(!_loc3_ || this.textField.width / _loc7_ - _loc4_ > _loc6_)
         {
            this.textField.width = _loc6_ + _loc4_;
            this.textField.wordWrap = this._wordWrap;
         }
         var _loc2_:Number = this.explicitHeight;
         if(_loc8_)
         {
            _loc2_ = this.textField.height / _loc7_ - _loc4_;
            if(_loc2_ < this._minHeight)
            {
               _loc2_ = this._minHeight;
            }
            else if(_loc2_ > this._maxHeight)
            {
               _loc2_ = this._maxHeight;
            }
         }
         this.textField.autoSize = "none";
         this.textField.width = this.actualWidth + _loc4_;
         this.textField.height = this.actualHeight + _loc4_;
         param1.x = _loc6_;
         param1.y = _loc2_;
         this._hasMeasured = true;
         return param1;
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc11_:* = false;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc3_:* = null;
         var _loc10_:* = false;
         var _loc9_:Boolean = this.isInvalid("styles");
         var _loc5_:Boolean = this.isInvalid("data");
         var _loc8_:Boolean = this.isInvalid("state");
         var _loc7_:Number = Starling.contentScaleFactor;
         var _loc2_:* = 4;
         if(this._useGutter)
         {
            _loc2_ = 0;
         }
         if(!this._hasMeasured && this._wordWrap)
         {
            this.textField.autoSize = "left";
            this.textField.wordWrap = false;
            if(this.textField.width / _loc7_ - _loc2_ > this.actualWidth)
            {
               this.textField.wordWrap = true;
            }
            this.textField.autoSize = "none";
            this.textField.width = this.actualWidth + _loc2_;
         }
         if(param1)
         {
            this.textField.width = this.actualWidth + _loc2_;
            this.textField.height = this.actualHeight + _loc2_;
            _loc11_ = Starling.current.profile != "baselineConstrained";
            _loc4_ = this.actualWidth * _loc7_;
            if(_loc11_)
            {
               if(_loc4_ > this._maxTextureDimensions)
               {
                  this._snapshotWidth = int(_loc4_ / this._maxTextureDimensions) * this._maxTextureDimensions + _loc4_ % this._maxTextureDimensions;
               }
               else
               {
                  this._snapshotWidth = _loc4_;
               }
            }
            else if(_loc4_ > this._maxTextureDimensions)
            {
               this._snapshotWidth = int(_loc4_ / this._maxTextureDimensions) * this._maxTextureDimensions + getNextPowerOfTwo(_loc4_ % this._maxTextureDimensions);
            }
            else
            {
               this._snapshotWidth = getNextPowerOfTwo(_loc4_);
            }
            _loc6_ = this.actualHeight * _loc7_;
            if(_loc11_)
            {
               if(_loc6_ > this._maxTextureDimensions)
               {
                  this._snapshotHeight = int(_loc6_ / this._maxTextureDimensions) * this._maxTextureDimensions + _loc6_ % this._maxTextureDimensions;
               }
               else
               {
                  this._snapshotHeight = _loc6_;
               }
            }
            else if(_loc6_ > this._maxTextureDimensions)
            {
               this._snapshotHeight = int(_loc6_ / this._maxTextureDimensions) * this._maxTextureDimensions + getNextPowerOfTwo(_loc6_ % this._maxTextureDimensions);
            }
            else
            {
               this._snapshotHeight = getNextPowerOfTwo(_loc6_);
            }
            _loc3_ = !!this.textSnapshot?this.textSnapshot.texture.root:null;
            this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || this._snapshotWidth != _loc3_.width || this._snapshotHeight != _loc3_.height;
         }
         if(_loc9_ || _loc5_ || _loc8_ || this._needsNewTexture || this.actualWidth != this._previousActualWidth || this.actualHeight != this._previousActualHeight)
         {
            this._previousActualWidth = this.actualWidth;
            this._previousActualHeight = this.actualHeight;
            _loc10_ = this._text.length > 0;
            if(_loc10_)
            {
               this.addEventListener("enterFrame",enterFrameHandler);
            }
            if(this.textSnapshot)
            {
               this.textSnapshot.visible = _loc10_ && this._snapshotWidth > 0 && this._snapshotHeight > 0;
            }
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:* = this.explicitWidth !== this.explicitWidth;
         var _loc2_:* = this.explicitHeight !== this.explicitHeight;
         if(!_loc1_ && !_loc2_)
         {
            return false;
         }
         this.measure(HELPER_POINT);
         return this.setSizeInternal(HELPER_POINT.x,HELPER_POINT.y,false);
      }
      
      protected function measureNativeFilters(param1:BitmapData, param2:Rectangle = null) : Rectangle
      {
         var _loc8_:int = 0;
         var _loc13_:* = null;
         var _loc3_:* = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc10_:Number = NaN;
         if(!param2)
         {
            param2 = new Rectangle();
         }
         var _loc11_:* = 0;
         var _loc12_:* = 0;
         var _loc6_:* = 0;
         var _loc14_:* = 0;
         var _loc9_:int = this._nativeFilters.length;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc13_ = this._nativeFilters[_loc8_];
            _loc3_ = param1.generateFilterRect(param1.rect,_loc13_);
            _loc4_ = _loc3_.x;
            _loc5_ = _loc3_.y;
            _loc7_ = _loc3_.width;
            _loc10_ = _loc3_.height;
            if(_loc11_ > _loc4_)
            {
               _loc11_ = _loc4_;
            }
            if(_loc12_ > _loc5_)
            {
               _loc12_ = _loc5_;
            }
            if(_loc6_ < _loc7_)
            {
               _loc6_ = _loc7_;
            }
            if(_loc14_ < _loc10_)
            {
               _loc14_ = _loc10_;
            }
            _loc8_++;
         }
         param2.setTo(_loc11_,_loc12_,_loc6_,_loc14_);
         return param2;
      }
      
      protected function texture_onRestore() : void
      {
         this.refreshSnapshot();
      }
      
      protected function refreshSnapshot() : void
      {
         var _loc12_:* = null;
         var _loc2_:* = NaN;
         var _loc15_:* = NaN;
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc14_:* = null;
         var _loc1_:int = 0;
         var _loc9_:* = 0;
         if(this._snapshotWidth <= 0 || this._snapshotHeight <= 0)
         {
            return;
         }
         var _loc5_:Number = Starling.contentScaleFactor;
         HELPER_MATRIX.identity();
         HELPER_MATRIX.scale(_loc5_,_loc5_);
         var _loc11_:Number = this._snapshotWidth;
         var _loc10_:Number = this._snapshotHeight;
         var _loc13_:* = 0;
         var _loc7_:* = 0;
         var _loc16_:int = -1;
         var _loc8_:Boolean = this._nativeFilters && this._nativeFilters.length > 0 && _loc11_ <= this._maxTextureDimensions && _loc10_ <= this._maxTextureDimensions;
         var _loc17_:* = Number(2 * _loc5_);
         if(this._useGutter)
         {
            _loc17_ = 0;
         }
         do
         {
            _loc2_ = _loc11_;
            if(_loc2_ > this._maxTextureDimensions)
            {
               _loc2_ = Number(this._maxTextureDimensions);
            }
            do
            {
               _loc15_ = _loc10_;
               if(_loc15_ > this._maxTextureDimensions)
               {
                  _loc15_ = Number(this._maxTextureDimensions);
               }
               if(!_loc12_ || _loc12_.width != _loc2_ || _loc12_.height != _loc15_)
               {
                  if(_loc12_)
                  {
                     _loc12_.dispose();
                  }
                  _loc12_ = new BitmapData(_loc2_,_loc15_,true,16711935);
               }
               else
               {
                  _loc12_.fillRect(_loc12_.rect,16711935);
               }
               HELPER_MATRIX.tx = -(_loc13_ + _loc17_);
               HELPER_MATRIX.ty = -(_loc7_ + _loc17_);
               HELPER_RECTANGLE.setTo(0,0,this.actualWidth * _loc5_,this.actualHeight * _loc5_);
               _loc12_.draw(this.textField,HELPER_MATRIX,null,null,HELPER_RECTANGLE);
               if(_loc8_)
               {
                  this.measureNativeFilters(_loc12_,HELPER_RECTANGLE);
                  if(_loc12_.rect.equals(HELPER_RECTANGLE))
                  {
                     this._textSnapshotOffsetX = 0;
                     this._textSnapshotOffsetY = 0;
                  }
                  else
                  {
                     HELPER_MATRIX.tx = HELPER_MATRIX.tx - HELPER_RECTANGLE.x;
                     HELPER_MATRIX.ty = HELPER_MATRIX.ty - HELPER_RECTANGLE.y;
                     _loc3_ = new BitmapData(HELPER_RECTANGLE.width,HELPER_RECTANGLE.height,true,16711935);
                     this._textSnapshotOffsetX = HELPER_RECTANGLE.x;
                     this._textSnapshotOffsetY = HELPER_RECTANGLE.y;
                     HELPER_RECTANGLE.x = 0;
                     HELPER_RECTANGLE.y = 0;
                     _loc3_.draw(this.textField,HELPER_MATRIX,null,null,HELPER_RECTANGLE);
                     _loc12_.dispose();
                     _loc12_ = _loc3_;
                  }
               }
               else
               {
                  this._textSnapshotOffsetX = 0;
                  this._textSnapshotOffsetY = 0;
               }
               if(!this.textSnapshot || this._needsNewTexture)
               {
                  _loc6_ = Texture.fromBitmapData(_loc12_,false,false,_loc5_);
                  _loc6_.root.onRestore = texture_onRestore;
               }
               _loc4_ = null;
               if(_loc16_ >= 0)
               {
                  if(!this.textSnapshots)
                  {
                     this.textSnapshots = new Vector.<Image>(0);
                  }
                  else if(this.textSnapshots.length > _loc16_)
                  {
                     _loc4_ = this.textSnapshots[_loc16_];
                  }
               }
               else
               {
                  _loc4_ = this.textSnapshot;
               }
               if(!_loc4_)
               {
                  _loc4_ = new Image(_loc6_);
                  this.addChild(_loc4_);
               }
               else if(this._needsNewTexture)
               {
                  _loc4_.texture.dispose();
                  _loc4_.texture = _loc6_;
                  _loc4_.readjustSize();
               }
               else
               {
                  _loc14_ = _loc4_.texture;
                  _loc14_.root.uploadBitmapData(_loc12_);
               }
               if(_loc16_ >= 0)
               {
                  this.textSnapshots[_loc16_] = _loc4_;
               }
               else
               {
                  this.textSnapshot = _loc4_;
               }
               _loc4_.x = _loc13_ / _loc5_;
               _loc4_.y = _loc7_ / _loc5_;
               _loc16_++;
               _loc7_ = Number(_loc7_ + _loc15_);
               _loc10_ = _loc10_ - _loc15_;
            }
            while(_loc10_ > 0);
            
            _loc13_ = Number(_loc13_ + _loc2_);
            _loc11_ = _loc11_ - _loc2_;
            _loc7_ = 0;
            _loc10_ = this._snapshotHeight;
         }
         while(_loc11_ > 0);
         
         _loc12_.dispose();
         if(this.textSnapshots)
         {
            _loc1_ = this.textSnapshots.length;
            _loc9_ = _loc16_;
            while(_loc9_ < _loc1_)
            {
               _loc4_ = this.textSnapshots[_loc9_];
               _loc4_.texture.dispose();
               _loc4_.removeFromParent(true);
               _loc9_++;
            }
            if(_loc16_ == 0)
            {
               this.textSnapshots = null;
            }
            else
            {
               this.textSnapshots.length = _loc16_;
            }
         }
         this._needsNewTexture = false;
      }
      
      protected function enterFrameHandler(param1:Event) : void
      {
         this.removeEventListener("enterFrame",enterFrameHandler);
         this.refreshSnapshot();
      }
   }
}

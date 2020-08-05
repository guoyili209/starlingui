package lzm.starling.swf.tool.utils {
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.PNGEncoderOptions;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import lzm.starling.swf.tool.asset.Assets;
    import lzm.starling.swf.tool.ui.Loading;

    public class ExportUtil {

        public static const platform_starling:String = "Starling";


        private var _exportFiles:Array;

        private var _exportScale:Number;

        private var _isMerger:Boolean;

        private var _isMergerBigImage:Boolean;

        private var _isAnySize:Boolean;

        private var _padding:Number;

        private var _exportPath:String;

        private var _bigImageWidth:Number;

        private var _bigImageHeight:Number;

        private var _exportPlatform:String = "Starling";

        private var _exportCount:int;

        private var _callBack:Function;

        private var swfUtil:SwfUtil;

        public function ExportUtil() {
            super();
        }

        public function exportFiles(exportFiles:Array, exportScale:Number, isMerger:Boolean, isMergerBigImage:Boolean, padding:Number, exportPath:String, bigImageWidth:Number, bigImageHeight:Number, exportPlatform:String, callBack:Function, isAnySize:Boolean):void {
            _exportFiles = exportFiles;
            _exportScale = exportScale;
            _isMerger = isMerger;
            _isMergerBigImage = isMergerBigImage;
            _isAnySize = isAnySize;
            _padding = padding;
            _exportPath = exportPath;
            _bigImageWidth = bigImageWidth;
            _bigImageHeight = bigImageHeight;
            _exportPlatform = exportPlatform;
            _callBack = callBack;
            _exportCount = _exportFiles.length;
            loadSwf(_exportFiles.shift());
        }

        private function loadSwf(param1:File):void {
            var file:File = param1;
            if(!file){
               Loading.instance.hide(); 
               return;
            }
            Loading.instance.text = "Export..." + (_exportCount - _exportFiles.length) + "/" + _exportCount;
            Assets.openTempFile(file.url, function():void {
                var loadSwfComplete:Function = function(param1:Event):void {
                    loader.contentLoaderInfo.removeEventListener("complete", loadSwfComplete);
                    swfUtil = new SwfUtil();
                    swfUtil.parse(loader.contentLoaderInfo.content.loaderInfo.applicationDomain);
                    exportImages();
                    loadSwf(_exportFiles.shift());
                };
                var exportImages:Function = function():void {
                    var _loc12_:* = null;
                    var _loc18_:* = null;
                    var _loc20_:int = 0;
                    var _loc25_:* = null;
                    var _loc13_:* = null;
                    var _loc17_:* = null;
                    var _loc14_:* = null;
                    var _loc10_:* = null;
                    var _loc15_:* = null;
                    var _loc21_:* = null;
                    var _loc16_:* = null;
                    var _loc19_:* = null;
                    var _loc1_:* = null;
                    var _loc3_:* = null;
                    var _loc5_:String = file.name.split(".")[0];
                    var _loc27_:String = _exportPath + "/" + _loc5_ + "/";
                    var _loc6_:String = _exportPath + "/" + _loc5_ + "/images/";
                    var _loc8_:String = _exportPath + "/" + _loc5_ + "/big_images/";
                    var _loc23_:String = _exportPath + "/" + _loc5_ + "/" + _loc5_ + (_exportPlatform == "Starling" ? ".bytes" : "_swf.json");
                    saveSwfData(_loc23_, swfUtil.getSwfData(_exportPlatform));
                    var _loc26_:Array = swfUtil.exportImages;
                    var _loc7_:int = _loc26_.length;
                    if (_loc7_ == 0) {
                        return;
                    }
                    var _loc9_:Array = [];
                    var _loc11_:Array = [];
                    var _loc2_:Array = [];
                    var _loc24_:Array = [];
                    var _loc4_:Array = [];
                    var _loc22_:Object = {};
                    _loc20_ = 0;
                    while (_loc20_ < _loc7_) {
                        _loc12_ = ImageUtil.getBitmapdata(swfUtil.getClass(_loc26_[_loc20_]), _exportScale);
                        if (_isMerger) {
                            if (isBigImage(_loc12_) && !_isMergerBigImage) {
                                _loc4_.push(_loc26_[_loc20_]);
                                _loc11_.push(_loc12_);
                            } else {
                                _loc18_ = _loc12_.getColorBoundsRect(4278190080, 0, false);
                                _loc9_.push(_loc12_);
                                _loc2_.push(_loc18_);
                                _loc24_.push(_loc26_[_loc20_]);
                                _loc22_[_loc26_[_loc20_]] = new Rectangle(0, 0, _loc18_.width, _loc18_.height);
                            }
                        } else if (isBigImage(_loc12_)) {
                            _loc4_.push(_loc26_[_loc20_]);
                            _loc11_.push(_loc12_);
                        } else {
                            _loc24_.push(_loc26_[_loc20_]);
                            _loc9_.push(_loc12_);
                        }
                        _loc20_++;
                    }
                    if (_isMerger) {
                        _loc25_ = TextureUtil.packTextures(0, _padding, _loc22_);
                        if (_loc25_) {
                            _loc13_ = new BitmapData(_loc25_.width, _loc25_.height, true, 0);
                            _loc17_ = <TextureAtlas />;
                            _loc14_ = {"file": _loc5_ + ".png",
                                    "frames": {}};
                            _loc16_ = new Rectangle();
                            _loc19_ = new Point();
                            _loc7_ = _loc24_.length;
                            _loc20_ = 0;
                            while (_loc20_ < _loc7_) {
                                _loc15_ = _loc24_[_loc20_];
                                _loc21_ = _loc22_[_loc15_];
                                _loc12_ = _loc9_[_loc20_];
                                _loc19_.x = _loc21_.x;
                                _loc19_.y = _loc21_.y;
                                _loc16_ = _loc2_[_loc20_];
                                if (_exportPlatform == "Starling") {
                                    _loc10_ = <SubTexture />;
                                    _loc10_.@name = _loc15_;
                                    _loc10_.@x = _loc19_.x;
                                    _loc10_.@y = _loc19_.y;
                                    _loc10_.@width = _loc16_.width;
                                    _loc10_.@height = _loc16_.height;
                                    if (_loc16_.width < _loc12_.width || _loc16_.height < _loc12_.height) {
                                        _loc10_.@frameX = -_loc16_.x;
                                        _loc10_.@frameWidth = _loc12_.width;
                                        _loc10_.@frameY = -_loc16_.y;
                                        _loc10_.@frameHeight = _loc12_.height;
                                    }
                                    _loc17_.appendChild(_loc10_);
                                }
                                _loc13_.copyPixels(_loc12_, _loc16_, _loc19_);
                                _loc20_++;
                            }
                            if (_isAnySize) {
                                _loc1_ = _loc13_.getColorBoundsRect(4278190080, 0, false);
                                _loc1_.height = _loc1_.height + 1;
                                _loc1_.width = _loc1_.width + 1;
                                _loc3_ = new BitmapData(_loc1_.width, _loc1_.height, true, 0);
                                _loc3_.copyPixels(_loc13_, _loc1_, new Point(0, 0));
                                saveImage(_loc27_ + _loc5_ + ".png", _loc3_);
                            } else {
                                saveImage(_loc27_ + _loc5_ + ".png", _loc13_);
                            }
                            if (_exportPlatform == "Starling") {
                                _loc17_.@imagePath = _loc5_ + ".png";
                                saveXml(_loc27_ + _loc5_ + ".xml", _loc17_.toXMLString());
                            } else if (_exportPlatform == "Egret") {
                                saveXml(_loc27_ + _loc5_ + ".json", JSON.stringify(_loc14_));
                            }
                        }
                    } else {
                        _loc7_ = _loc24_.length;
                        _loc20_ = 0;
                        while (_loc20_ < _loc7_) {
                            saveImage(_loc6_ + _loc24_[_loc20_] + ".png", _loc9_[_loc20_]);
                            _loc20_++;
                        }
                    }
                    _loc7_ = _loc4_.length;
                    _loc20_ = 0;
                    while (_loc20_ < _loc7_) {
                        saveImage(_loc8_ + _loc4_[_loc20_] + ".png", _loc11_[_loc20_]);
                        _loc20_++;
                    }
                };

                var getBitmapDatas:Function = function(param1:Array):void {
                    var _loc2_:* = null;
                    var _loc6_:int = 0;
                    var _loc3_:Array = [];
                    var _loc4_:Array = [];
                    var _loc5_:int = param1.length;
                    _loc6_ = 0;
                    while (_loc6_ < _loc5_) {
                        _loc2_ = ImageUtil.getBitmapdata(swfUtil.getClass(param1[_loc6_]), _exportScale);
                        _loc3_.push(_loc2_);
                        _loc4_.push(param1[_loc6_]);
                        _loc6_++;
                    }
                };
                var loader:Loader = new Loader();
                loader.contentLoaderInfo.addEventListener("complete", loadSwfComplete);
                loader.load(new URLRequest(file.url));
            });
            return;
        }

        private function isBigImage(param1:BitmapData):Boolean {
            if (param1.width > _bigImageWidth * _exportScale && param1.height > _bigImageWidth * _exportScale) {
                return true;
            }
            return false;
        }

        private function saveImage(param1:String, param2:BitmapData):void {
            var _loc3_:* = null;
            var _loc4_:* = null;
            var _loc5_:* = null;
            try {
                _loc3_ = param2.encode(new Rectangle(0, 0, param2.width, param2.height), new PNGEncoderOptions());
                _loc4_ = new File(param1);
                _loc5_ = new FileStream();
                _loc5_.open(_loc4_, "write");
                _loc5_.writeBytes(_loc3_);
                _loc5_.close();
                return;
            } catch (error:Error) {
                trace(param1);
                return;
            }
        }

        private function saveByteArry(param1:String, param2:ByteArray):void {
            var _loc3_:* = null;
            var _loc4_:* = null;
            try {
                _loc3_ = new File(param1);
                _loc4_ = new FileStream();
                _loc4_.open(_loc3_, "write");
                _loc4_.writeBytes(param2);
                _loc4_.close();
                return;
            } catch (error:Error) {
                trace(param1);
                return;
            }
        }

        private function saveXml(param1:String, param2:String):void {
            var _loc3_:ByteArray = new ByteArray();
            _loc3_.writeMultiByte(param2, "utf-8");
            var _loc4_:File = new File(param1);
            var _loc5_:FileStream = new FileStream();
            _loc5_.open(_loc4_, "write");
            _loc5_.writeBytes(_loc3_);
            _loc5_.close();
        }

        private function saveSwfData(param1:String, param2:ByteArray):void {
            var _loc3_:File = new File(param1);
            var _loc4_:FileStream = new FileStream();
            _loc4_.open(_loc3_, "write");
            _loc4_.writeBytes(param2);
            _loc4_.close();
        }
    }
}

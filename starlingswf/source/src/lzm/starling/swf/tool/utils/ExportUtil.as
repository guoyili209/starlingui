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

        private function loadSwf(file:File):void {
            if (!file) {
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
                    var bimapData:* = null;
                    var _loc18_:* = null;
                    var exportImagesArrIndex:int = 0;
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
                    var fileName:String = file.name.split(".")[0];
                    var savePath:String = _exportPath + "/" + fileName + "/";
                    var _loc6_:String = savePath + "images/";
                    var _loc8_:String = savePath + "big_images/";
                    var saveBytes:String = savePath + fileName + ".bytes";
                    saveSwfData(saveBytes, swfUtil.getSwfData(_exportPlatform));
                    var exportImagesArr:Array = swfUtil.exportImages;
                    var exportImagesArrLen:int = exportImagesArr.length;
                    if (exportImagesArrLen == 0) {
                        return;
                    }
                    var _loc9_:Array = [];
                    var _loc11_:Array = [];
                    var _loc2_:Array = [];
                    var _loc24_:Array = [];
                    var _loc4_:Array = [];
                    var _loc22_:Object = {};
                    exportImagesArrIndex = 0;
                    while (exportImagesArrIndex < exportImagesArrLen) {
                        bimapData = ImageUtil.getBitmapdata(swfUtil.getClass(exportImagesArr[exportImagesArrIndex]), _exportScale);
                        if (_isMerger) {
                            if (isBigImage(bimapData) && !_isMergerBigImage) {
                                _loc4_.push(exportImagesArr[exportImagesArrIndex]);
                                _loc11_.push(bimapData);
                            } else {
                                _loc18_ = bimapData.getColorBoundsRect(4278190080, 0, false);
                                _loc9_.push(bimapData);
                                _loc2_.push(_loc18_);
                                _loc24_.push(exportImagesArr[exportImagesArrIndex]);
                                _loc22_[exportImagesArr[exportImagesArrIndex]] = new Rectangle(0, 0, _loc18_.width, _loc18_.height);
                            }
                        } else if (isBigImage(bimapData)) {
                            _loc4_.push(exportImagesArr[exportImagesArrIndex]);
                            _loc11_.push(bimapData);
                        } else {
                            _loc24_.push(exportImagesArr[exportImagesArrIndex]);
                            _loc9_.push(bimapData);
                        }
                        exportImagesArrIndex++;
                    }
                    if (_isMerger) {
                        _loc25_ = TextureUtil.packTextures(0, _padding, _loc22_);
                        if (_loc25_) {
                            _loc13_ = new BitmapData(_loc25_.width, _loc25_.height, true, 0);
                            _loc17_ = <TextureAtlas />;
                            _loc14_ = {"file": fileName + ".png",
                                    "frames": {}};
                            _loc16_ = new Rectangle();
                            _loc19_ = new Point();
                            exportImagesArrLen = _loc24_.length;
                            exportImagesArrIndex = 0;
                            while (exportImagesArrIndex < exportImagesArrLen) {
                                _loc15_ = _loc24_[exportImagesArrIndex];
                                _loc21_ = _loc22_[_loc15_];
                                bimapData = _loc9_[exportImagesArrIndex];
                                _loc19_.x = _loc21_.x;
                                _loc19_.y = _loc21_.y;
                                _loc16_ = _loc2_[exportImagesArrIndex];
                                if (_exportPlatform == "Starling") {
                                    _loc10_ = <SubTexture />;
                                    _loc10_.@name = _loc15_;
                                    _loc10_.@x = _loc19_.x;
                                    _loc10_.@y = _loc19_.y;
                                    _loc10_.@width = _loc16_.width;
                                    _loc10_.@height = _loc16_.height;
                                    if (_loc16_.width < bimapData.width || _loc16_.height < bimapData.height) {
                                        _loc10_.@frameX = -_loc16_.x;
                                        _loc10_.@frameWidth = bimapData.width;
                                        _loc10_.@frameY = -_loc16_.y;
                                        _loc10_.@frameHeight = bimapData.height;
                                    }
                                    _loc17_.appendChild(_loc10_);
                                }
                                _loc13_.copyPixels(bimapData, _loc16_, _loc19_);
                                exportImagesArrIndex++;
                            }
                            if (_isAnySize) {
                                _loc1_ = _loc13_.getColorBoundsRect(4278190080, 0, false);
                                _loc1_.height = _loc1_.height + 1;
                                _loc1_.width = _loc1_.width + 1;
                                _loc3_ = new BitmapData(_loc1_.width, _loc1_.height, true, 0);
                                _loc3_.copyPixels(_loc13_, _loc1_, new Point(0, 0));
                                saveImage(savePath + fileName + ".png", _loc3_);
                            } else {
                                saveImage(savePath + fileName + ".png", _loc13_);
                            }
                            if (_exportPlatform == "Starling") {
                                _loc17_.@imagePath = fileName + ".png";
                                saveXml(savePath + fileName + ".xml", _loc17_.toXMLString());
                            } else if (_exportPlatform == "Egret") {
                                saveXml(savePath + fileName + ".json", JSON.stringify(_loc14_));
                            }
                        }
                    } else {
                        exportImagesArrLen = _loc24_.length;
                        exportImagesArrIndex = 0;
                        while (exportImagesArrIndex < exportImagesArrLen) {
                            saveImage(_loc6_ + _loc24_[exportImagesArrIndex] + ".png", _loc9_[exportImagesArrIndex]);
                            exportImagesArrIndex++;
                        }
                    }
                    exportImagesArrLen = _loc4_.length;
                    exportImagesArrIndex = 0;
                    while (exportImagesArrIndex < exportImagesArrLen) {
                        saveImage(_loc8_ + _loc4_[exportImagesArrIndex] + ".png", _loc11_[exportImagesArrIndex]);
                        exportImagesArrIndex++;
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

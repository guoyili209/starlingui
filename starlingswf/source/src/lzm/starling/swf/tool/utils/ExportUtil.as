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
                    var colorRect:Rectangle = null;
                    var exportImagesArrIndex:int = 0;
                    var exportRect:Rectangle = null;
                    var exportBmpd:BitmapData = null;
                    var exportXml:XML = null;
                    var exportJsonObj:Object = null;
                    var xmlItem:XML = null;
                    var exportSmallImgName:String = null;
                    var exportSmallRect:Rectangle = null;
                    var exportColorRect:Rectangle = null;
                    var exportSmallImgPt:Point = null;
                    var clipColorRect:Rectangle = null;
                    var clipBmpd:BitmapData = null;
                    var fileName:String = file.name.split(".")[0];
                    var savePath:String = _exportPath + "/" + fileName + "/";
                    var saveImagePath:String = savePath + "images/";
                    var saveBigImgPath:String = savePath + "big_images/";
                    var saveBytes:String = savePath + fileName + ".bytes";
                    saveSwfData(saveBytes, swfUtil.getSwfData(_exportPlatform));
                    var exportImagesArr:Array = swfUtil.exportImages;
                    var exportImagesArrLen:int = exportImagesArr.length;
                    if (exportImagesArrLen == 0) {
                        return;
                    }
                    var tempExportSmallBmpdArr:Array = [];
                    var tempExportBigBmpdArr:Array = [];
                    var tempExportColorRectArr:Array = [];
                    var tempExportSmallImagesArr:Array = [];
                    var tempExportBigImagesArr:Array = [];
                    var tempExportSmallImgRectObj:Object = {};
                    exportImagesArrIndex = 0;
                    while (exportImagesArrIndex < exportImagesArrLen) {
                        bimapData = ImageUtil.getBitmapdata(swfUtil.getClass(exportImagesArr[exportImagesArrIndex]), _exportScale);
                        if (_isMerger) {
                            if (isBigImage(bimapData) && !_isMergerBigImage) {
                                tempExportBigImagesArr.push(exportImagesArr[exportImagesArrIndex]);
                                tempExportBigBmpdArr.push(bimapData);
                            } else {
                                colorRect = bimapData.getColorBoundsRect(4278190080, 0, false);
                                tempExportSmallBmpdArr.push(bimapData);
                                tempExportColorRectArr.push(colorRect);
                                tempExportSmallImagesArr.push(exportImagesArr[exportImagesArrIndex]);
                                tempExportSmallImgRectObj[exportImagesArr[exportImagesArrIndex]] = new Rectangle(0, 0, colorRect.width, colorRect.height);
                            }
                        } else if (isBigImage(bimapData)) {
                            tempExportBigImagesArr.push(exportImagesArr[exportImagesArrIndex]);
                            tempExportBigBmpdArr.push(bimapData);
                        } else {
                            tempExportSmallImagesArr.push(exportImagesArr[exportImagesArrIndex]);
                            tempExportSmallBmpdArr.push(bimapData);
                        }
                        exportImagesArrIndex++;
                    }
                    if (_isMerger) {
                        exportRect = TextureUtil.packTextures(0, _padding, tempExportSmallImgRectObj);
                        if (exportRect) {
                            exportBmpd = new BitmapData(exportRect.width, exportRect.height, true, 0);
                            exportXml = <TextureAtlas />;
                            exportJsonObj = {"file": fileName + ".png",
                                    "frames": {}};
                            exportColorRect = new Rectangle();
                            exportSmallImgPt = new Point();
                            exportImagesArrLen = tempExportSmallImagesArr.length;
                            exportImagesArrIndex = 0;
                            while (exportImagesArrIndex < exportImagesArrLen) {
                                exportSmallImgName = tempExportSmallImagesArr[exportImagesArrIndex];
                                exportSmallRect = tempExportSmallImgRectObj[exportSmallImgName];
                                bimapData = tempExportSmallBmpdArr[exportImagesArrIndex];
                                exportSmallImgPt.x = exportSmallRect.x;
                                exportSmallImgPt.y = exportSmallRect.y;
                                exportColorRect = tempExportColorRectArr[exportImagesArrIndex];
                                if (_exportPlatform == "Starling") {
                                    xmlItem = <SubTexture />;
                                    xmlItem.@name = exportSmallImgName;
                                    xmlItem.@x = exportSmallImgPt.x;
                                    xmlItem.@y = exportSmallImgPt.y;
                                    xmlItem.@width = exportColorRect.width;
                                    xmlItem.@height = exportColorRect.height;
                                    if (exportColorRect.width < bimapData.width || exportColorRect.height < bimapData.height) {
                                        xmlItem.@frameX = -exportColorRect.x;
                                        xmlItem.@frameWidth = bimapData.width;
                                        xmlItem.@frameY = -exportColorRect.y;
                                        xmlItem.@frameHeight = bimapData.height;
                                    }
                                    exportXml.appendChild(xmlItem);
                                }
                                exportBmpd.copyPixels(bimapData, exportColorRect, exportSmallImgPt);
                                exportImagesArrIndex++;
                            }
                            if (_isAnySize) {
                                clipColorRect = exportBmpd.getColorBoundsRect(4278190080, 0, false);
                                clipColorRect.height = clipColorRect.height + 1;
                                clipColorRect.width = clipColorRect.width + 1;
                                clipBmpd = new BitmapData(clipColorRect.width, clipColorRect.height, true, 0);
                                clipBmpd.copyPixels(exportBmpd, clipColorRect, new Point(0, 0));
                                saveImage(savePath + fileName + ".png", clipBmpd);
                            } else {
                                saveImage(savePath + fileName + ".png", exportBmpd);
                            }
                            if (_exportPlatform == "Starling") {
                                exportXml.@imagePath = fileName + ".png";
                                saveXml(savePath + fileName + ".xml", exportXml.toXMLString());
                            } else if (_exportPlatform == "Egret") {
                                saveXml(savePath + fileName + ".json", JSON.stringify(exportJsonObj));
                            }
                        }
                    } else {
                        exportImagesArrLen = tempExportSmallImagesArr.length;
                        exportImagesArrIndex = 0;
                        while (exportImagesArrIndex < exportImagesArrLen) {
                            saveImage(saveImagePath + tempExportSmallImagesArr[exportImagesArrIndex] + ".png", tempExportSmallBmpdArr[exportImagesArrIndex]);
                            exportImagesArrIndex++;
                        }
                    }
                    exportImagesArrLen = tempExportBigImagesArr.length;
                    exportImagesArrIndex = 0;
                    while (exportImagesArrIndex < exportImagesArrLen) {
                        saveImage(saveBigImgPath + tempExportBigImagesArr[exportImagesArrIndex] + ".png", tempExportBigBmpdArr[exportImagesArrIndex]);
                        exportImagesArrIndex++;
                    }
                };

                var getBitmapDatas:Function = function(arr:Array):void {
                    var bmpd:* = null;
                    var index:int = 0;
                    var _loc3_:Array = [];
                    var _loc4_:Array = [];
                    var _loc5_:int = arr.length;
                    index = 0;
                    while (index < _loc5_) {
                        bmpd = ImageUtil.getBitmapdata(swfUtil.getClass(arr[index]), _exportScale);
                        _loc3_.push(bmpd);
                        _loc4_.push(arr[index]);
                        index++;
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

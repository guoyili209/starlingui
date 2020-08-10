package lzm.starling.swf.tool.utils {
    import flash.geom.Rectangle;

    public final class TextureUtil {

        private static const HIGHEST:uint = 4294967295;


        public function TextureUtil() {
            super();
        }

        public static function packTextures(nu2N_W:uint, padding:uint, exportImgRectObj:Object, param4:Boolean = false):Rectangle {
            var bool:Boolean = false;
            var wpadding:int = 0;
            var hpadding:int = 0;
            var maxHRect:* = null;
            var preRect:* = null;
            var mextRect:* = null;
            var index:int = 0;
            var count:int = 0;
            // for each(var rect:* in exportImgRectObj)
            // {
            // }
            // if(!rect)
            // {
            //    return null;
            // }
            var nu:uint = 0;
            var rectVec:Vector.<Rectangle> = new Vector.<Rectangle>();
            var maxH:int = 0;
            var maxW:int = 0;
            for each (var rect:* in exportImgRectObj) {
                nu = nu + rect.width * rect.height;
                rectVec.push(rect);
                if (maxW < rect.width) {
                    maxW = rect.width;
                }
                if (maxH < rect.height) {
                    maxH = rect.height;
                }
            }
            rectVec.sort(sortRectList);
            if (nu2N_W == 0) {
                nu2N_W = Math.sqrt(nu);
            }
            nu2N_W = getNearest2N(Math.max(int(rectVec[0].width) + padding, nu2N_W));
            if (nu2N_W < maxH) {
                nu2N_W = nu2N_W * 2;
            }
            if (nu2N_W < maxW) {
                nu2N_W = nu2N_W * 2;
            }
            var nu2N_H:* = 4294967295;
            var rectVec2:Vector.<Rectangle> = new Vector.<Rectangle>();
            rectVec2.push(new Rectangle(0, 0, nu2N_W, nu2N_H));
            do {
                maxHRect = getHighestArea(rectVec2);
                index = rectVec2.indexOf(maxHRect);
                bool = false;
                count = 0;
                for each (rect in rectVec) {
                    wpadding = int(rect.width) + padding;
                    hpadding = int(rect.height) + padding;
                    if (maxHRect.width >= wpadding && maxHRect.height >= hpadding) {
                        bool = true;
                        break;
                    }
                    count++;
                }
                if (bool) {
                    rect.x = maxHRect.x;
                    rect.y = maxHRect.y;
                    rectVec.splice(count, 1);
                    rectVec2.splice(index + 1, 0, new Rectangle(maxHRect.x + wpadding, maxHRect.y, maxHRect.width - wpadding, maxHRect.height));
                    maxHRect.y = maxHRect.y + hpadding;
                    maxHRect.width = wpadding;
                    maxHRect.height = maxHRect.height - hpadding;
                } else {
                    if (index == 0) {
                        mextRect = rectVec2[index + 1];
                    } else if (index == rectVec2.length - 1) {
                        mextRect = rectVec2[index - 1];
                    } else {
                        preRect = rectVec2[index - 1];
                        mextRect = rectVec2[index + 1];
                        mextRect = preRect.height <= mextRect.height ? mextRect : preRect;
                    }
                    if (maxHRect.x < mextRect.x) {
                        mextRect.x = maxHRect.x;
                    }
                    mextRect.width = maxHRect.width + mextRect.width;
                    rectVec2.splice(index, 1);
                }
            } while (rectVec.length > 0);

            nu2N_H = uint(getNearest2N(nu2N_H - getLowestArea(rectVec2).height));
            return new Rectangle(0, 0, nu2N_W, nu2N_H);
        }

        private static function sortRectList(param1:Rectangle, param2:Rectangle):int {
            var _loc3_:uint = param1.width + param1.height;
            var _loc4_:uint = param2.width + param2.height;
            if (_loc3_ == _loc4_) {
                return param1.width > param2.width ? -1 : 1;
            }
            return _loc3_ > _loc4_ ? -1 : 1;
        }

        private static function getNearest2N(nu:uint):uint {
            return !!(nu & nu - 1) ? 1 << nu.toString(2).length : nu;
        }

        private static function getHighestArea(rectVec:Vector.<Rectangle>):Rectangle {
            var maxHRect:* = null;
            var maxH:uint = 0;
            for each (var rect:* in rectVec) {
                if (rect.height > maxH) {
                    maxH = rect.height;
                    maxHRect = rect;
                }
            }
            return maxHRect;
        }

        private static function getLowestArea(rectVec:Vector.<Rectangle>):Rectangle {
            var minHRect:* = null;
            var minH:* = 4294967295;
            for each (var rect:* in rectVec) {
                if (rect.height < minH) {
                    minH = uint(rect.height);
                    minHRect = rect;
                }
            }
            return minHRect;
        }
    }
}

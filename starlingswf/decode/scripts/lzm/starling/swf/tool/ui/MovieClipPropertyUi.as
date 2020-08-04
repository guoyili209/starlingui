package lzm.starling.swf.tool.ui
{
   import com.bit101.components.CheckBox;
   import com.bit101.components.ComboBox;
   import com.bit101.components.Label;
   import flash.events.Event;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.tool.asset.Assets;
   
   public class MovieClipPropertyUi extends BaseUI
   {
       
      
      private var _movieClip:SwfMovieClip;
      
      private var _totalFrames:Label;
      
      private var _labels:ComboBox;
      
      private var _isLoop:CheckBox;
      
      public function MovieClipPropertyUi()
      {
         super();
         loadUi("movieclip_property.xml");
      }
      
      override protected function loadXMLComplete(param1:Event) : void
      {
         _totalFrames = uiConfig.getCompById("totalFrames") as Label;
         _labels = uiConfig.getCompById("labelsComboBox") as ComboBox;
         _isLoop = uiConfig.getCompById("isLoop") as CheckBox;
      }
      
      public function set movieClip(param1:SwfMovieClip) : void
      {
         _movieClip = param1;
         _totalFrames.text = _movieClip.totalFrames + "";
         _labels.selectedIndex = -1;
         _labels.items = _movieClip.labels;
         _labels.enabled = _labels.items.length > 0;
         _isLoop.selected = _movieClip.loop;
      }
      
      public function onSelectLabels(param1:Event) : void
      {
         if(_labels.selectedIndex != -1)
         {
            _movieClip.gotoAndPlay(_labels.selectedItem);
         }
      }
      
      public function onChangeLoop(param1:Event) : void
      {
         _movieClip.loop = _isLoop.selected;
         Assets.swfUtil.movieClipDatas[_movieClip.name]["loop"] = _movieClip.loop;
         Assets.swf.swfData["mc"][_movieClip.name]["loop"] = _movieClip.loop;
         Assets.putTempData(_movieClip.name,_movieClip.loop);
      }
      
      public function onPlay(param1:Event) : void
      {
         _movieClip.play();
      }
   }
}

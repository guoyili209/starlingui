package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Calendar extends Panel
   {
       
      
      protected var _dateLabel:Label;
      
      protected var _day:int;
      
      protected var _dayButtons:Array;
      
      protected var _month:int;
      
      protected var _monthNames:Array;
      
      protected var _selection:Shape;
      
      protected var _year:int;
      
      public function Calendar(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0)
      {
         _dayButtons = [];
         _monthNames = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"];
         super(param1,param2,param3);
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(144,144);
         var _loc1_:Date = new Date();
         setDate(_loc1_);
      }
      
      override protected function addChildren() : void
      {
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:* = null;
         super.addChildren();
         _loc7_ = 0;
         while(_loc7_ < 6)
         {
            _loc6_ = 0;
            while(_loc6_ < 7)
            {
               _loc1_ = new PushButton(this.content,_loc6_ * 24,24 + _loc7_ * 22);
               _loc1_.setSize(23,23);
               _loc1_.addEventListener("click",onDayClick);
               _dayButtons.push(_loc1_);
               _loc6_++;
            }
            _loc7_++;
         }
         _dateLabel = new Label(this.content,25,0);
         _dateLabel.autoSize = true;
         var _loc3_:PushButton = new PushButton(this.content,2,2,"«",onPrevYear);
         _loc3_.setSize(14,14);
         var _loc4_:PushButton = new PushButton(this.content,17,2,"<",onPrevMonth);
         _loc4_.setSize(14,14);
         var _loc2_:PushButton = new PushButton(this.content,108,2,">",onNextMonth);
         _loc2_.setSize(14,14);
         var _loc5_:PushButton = new PushButton(this.content,124,2,"»",onNextYear);
         _loc5_.setSize(14,14);
         _selection = new Shape();
         _selection.graphics.beginFill(0,0.15);
         _selection.graphics.drawRect(1,1,22,22);
         this.content.addChild(_selection);
      }
      
      protected function getEndDay(param1:int, param2:int) : int
      {
         switch(int(param1))
         {
            case 0:
               return 31;
            case 1:
            case 2:
               if(param2 % 400 == 0 || param2 % 100 != 0 && param2 % 4 == 0)
               {
                  return 29;
               }
               return 28;
            default:
            case 4:
            default:
            case 6:
            case 7:
            default:
            case 9:
            default:
            case 11:
               return 30;
         }
      }
      
      public function setDate(param1:Date) : void
      {
         var _loc5_:int = 0;
         var _loc2_:* = null;
         _year = param1.fullYear;
         _month = param1.month;
         _day = param1.date;
         var _loc4_:int = new Date(_year,_month,1).day;
         var _loc3_:int = getEndDay(_month,_year);
         _loc5_ = 0;
         while(_loc5_ < 42)
         {
            _dayButtons[_loc5_].visible = false;
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc2_ = _dayButtons[_loc5_ + _loc4_];
            _loc2_.visible = true;
            _loc2_.label = (_loc5_ + 1).toString();
            _loc2_.tag = _loc5_ + 1;
            if(_loc5_ + 1 == _day)
            {
               _selection.x = _loc2_.x;
               _selection.y = _loc2_.y;
            }
            _loc5_++;
         }
         _dateLabel.text = _monthNames[_month] + "  " + _year;
         _dateLabel.draw();
         _dateLabel.x = (width - _dateLabel.width) / 2;
      }
      
      public function setYearMonthDay(param1:int, param2:int, param3:int) : void
      {
         setDate(new Date(param1,param2,param3));
      }
      
      protected function onNextMonth(param1:MouseEvent) : void
      {
         _month = Number(_month) + 1;
         if(_month > 11)
         {
            _month = 0;
            _year = Number(_year) + 1;
         }
         _day = Math.min(_day,getEndDay(_month,_year));
         setYearMonthDay(_year,_month,_day);
      }
      
      protected function onPrevMonth(param1:MouseEvent) : void
      {
         _month = Number(_month) - 1;
         if(_month < 0)
         {
            _month = 11;
            _year = Number(_year) - 1;
         }
         _day = Math.min(_day,getEndDay(_month,_year));
         setYearMonthDay(_year,_month,_day);
      }
      
      protected function onNextYear(param1:MouseEvent) : void
      {
         _year = Number(_year) + 1;
         _day = Math.min(_day,getEndDay(_month,_year));
         setYearMonthDay(_year,_month,_day);
      }
      
      protected function onPrevYear(param1:MouseEvent) : void
      {
         _year = Number(_year) - 1;
         _day = Math.min(_day,getEndDay(_month,_year));
         setYearMonthDay(_year,_month,_day);
      }
      
      protected function onDayClick(param1:MouseEvent) : void
      {
         _day = param1.target.tag;
         setYearMonthDay(_year,_month,_day);
         dispatchEvent(new Event("select"));
      }
      
      public function get selectedDate() : Date
      {
         return new Date(_year,_month,_day);
      }
      
      public function get month() : int
      {
         return _month;
      }
      
      public function get year() : int
      {
         return _year;
      }
      
      public function get day() : int
      {
         return _day;
      }
   }
}

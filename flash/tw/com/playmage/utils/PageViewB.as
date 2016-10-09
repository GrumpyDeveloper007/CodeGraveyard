package com.playmage.utils
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.playmage.utils.math.Format;
   import com.playmage.framework.PlaymageResourceManager;
   import com.playmage.configs.SkinConfig;
   import flash.display.MovieClip;
   import flash.text.TextFormat;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class PageViewB extends Sprite
   {
      
      public function PageViewB(param1:IFlipPage, param2:Array, param3:int, param4:int = -1)
      {
         super();
         this.delegate = param1;
         _itemsPerPage = param3;
         _pageBean = new PageBean(param2,param3);
         _pageBean.currentPage = -1;
         n();
      }
      
      public function set items(param1:Array) : void
      {
         _pageBean = new PageBean(param1,_itemsPerPage);
         _totalPageLbl.text = _pageBean.totalPage + "";
      }
      
      public function destroy() : void
      {
         _preBtn.removeEventListener(MouseEvent.CLICK,onPreClicked);
         _nextBtn.removeEventListener(MouseEvent.CLICK,onNextClicked);
         _preBtn.destroy();
         _nextBtn.destroy();
      }
      
      private function onPreClicked(param1:MouseEvent) : void
      {
         this.currentPage--;
      }
      
      public function get delegate() : IFlipPage
      {
         return _delegate;
      }
      
      public function set delegate(param1:IFlipPage) : void
      {
         _delegate = param1;
      }
      
      private var _itemsPerPage:int;
      
      public function set currentPage(param1:int) : void
      {
         var _loc2_:* = 0;
         if(param1 != _pageBean.currentPage)
         {
            _pageBean.currentPage = param1;
            _loc2_ = _pageBean.currentPage;
            _curPageLbl.text = _loc2_ + "";
            if(_loc2_ == 1)
            {
               Format.darkView(_preBtn.source);
            }
            else if(!_preBtn.mouseEnabled)
            {
               Format.disdarkView(_preBtn.source);
            }
            
            if(_loc2_ == _pageBean.totalPage)
            {
               Format.darkView(_nextBtn.source);
            }
            else if(!_nextBtn.mouseEnabled)
            {
               Format.disdarkView(_nextBtn.source);
            }
            
            _delegate.updatePage(_loc2_);
         }
      }
      
      private function n() : void
      {
         var _loc1_:MovieClip = PlaymageResourceManager.getClassInstance("PrevBtn",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN) as MovieClip;
         _loc1_.mouseChildren = false;
         _preBtn = new SimpleButtonUtil(_loc1_);
         _preBtn.y = 2;
         this.addChild(_loc1_);
         _preBtn.addEventListener(MouseEvent.CLICK,onPreClicked);
         _loc1_ = PlaymageResourceManager.getClassInstance("NextBtn",SkinConfig.CONTROL_SKIN_URL,SkinConfig.CONTROL_SKIN) as MovieClip;
         _loc1_.mouseChildren = false;
         _nextBtn = new SimpleButtonUtil(_loc1_);
         _nextBtn.x = 62;
         _nextBtn.y = 2;
         this.addChild(_loc1_);
         _nextBtn.addEventListener(MouseEvent.CLICK,onNextClicked);
         var _loc2_:TextFormat = new TextFormat("Arial",10,65535);
         var _loc3_:TextField = new TextField();
         _loc3_.defaultTextFormat = _loc2_;
         _loc3_.text = "/";
         _loc3_.mouseEnabled = false;
         _loc3_.x = 32;
         _loc3_.y = 0;
         _loc3_.width = _loc3_.textWidth + 4;
         _loc3_.height = _loc3_.textHeight + 4;
         this.addChild(_loc3_);
         _totalPageLbl = new TextField();
         _totalPageLbl.defaultTextFormat = _loc2_;
         _totalPageLbl.mouseEnabled = false;
         _totalPageLbl.x = 40;
         _totalPageLbl.y = 0;
         _totalPageLbl.width = 30;
         _totalPageLbl.text = _pageBean.totalPage + "";
         _totalPageLbl.height = _totalPageLbl.textHeight + 4;
         this.addChild(_totalPageLbl);
         _loc2_.align = TextFormatAlign.RIGHT;
         _curPageLbl = new TextField();
         _curPageLbl.defaultTextFormat = _loc2_;
         _curPageLbl.mouseEnabled = false;
         _curPageLbl.width = 20;
         _curPageLbl.x = 10;
         _curPageLbl.y = 0;
         _curPageLbl.text = _pageBean.currentPage + "";
         _curPageLbl.height = _curPageLbl.textHeight + 4;
         this.addChild(_curPageLbl);
      }
      
      private function onNextClicked(param1:MouseEvent) : void
      {
         this.currentPage++;
      }
      
      private var _preBtn:SimpleButtonUtil;
      
      private var _totalPageLbl:TextField;
      
      private var _delegate:IFlipPage;
      
      private var _curPageLbl:TextField;
      
      public function get currentPage() : int
      {
         return _pageBean.currentPage;
      }
      
      private var _nextBtn:SimpleButtonUtil;
      
      public function set totalPage(param1:int) : void
      {
         _pageBean.totalPage = param1;
         _totalPageLbl.text = _pageBean.totalPage + "";
         if(_pageBean.currentPage == param1)
         {
            Format.darkView(_nextBtn.source);
         }
         else
         {
            Format.disdarkView(_nextBtn.source);
         }
         if(_pageBean.currentPage > param1)
         {
            currentPage = param1;
         }
      }
      
      public function get totalPage() : int
      {
         return _pageBean.totalPage;
      }
      
      private var _pageBean:PageBean;
   }
}

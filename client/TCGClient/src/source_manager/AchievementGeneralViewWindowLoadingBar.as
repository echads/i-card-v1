﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package source_manager {
    import mx.core.*;
    import flash.display.*;
    import mx.events.*;
    import flash.geom.*;
    import mx.styles.*;
    import flash.events.*;
    import flash.text.*;
    import mx.binding.*;
    import custom_control1.*;
    import flash.system.*;
    import flash.media.*;
    import spark.effects.*;
    import flash.utils.*;
    import combat_element_script.*;
    import flash.accessibility.*;
    import mx.filters.*;
    import flash.ui.*;
    import flash.net.*;
    import flash.external.*;
    import flash.debugger.*;
    import flash.errors.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.xml.*;

    public class AchievementGeneralViewWindowLoadingBar extends CommonLoadingBar implements IBindingClient {
		use namespace mx_internal;
        private static var _watcherSetupUtil:IWatcherSetupUtil2;

        private var _413245038addEffect:Fade;
        private var _1267520715removeEffect:Fade;
        private var __moduleFactoryInitialized:Boolean = false;
        mx_internal var _bindings:Array;
        mx_internal var _watchers:Array;
        mx_internal var _bindingsByDestination:Object;
        mx_internal var _bindingsBeginWithWord:Object;

        public function AchievementGeneralViewWindowLoadingBar(){
            var target:* = null;
            var watcherSetupUtilClass:* = null;
            this._bindings = [];
            this._watchers = [];
            this._bindingsByDestination = {};
            this._bindingsBeginWithWord = {};
            super();
            var bindings:* = this._AchievementGeneralViewWindowLoadingBar_bindingsSetup();
            var watchers:* = [];
            target = this;
            if (_watcherSetupUtil == null){
                watcherSetupUtilClass = getDefinitionByName("_source_manager_AchievementGeneralViewWindowLoadingBarWatcherSetupUtil");
                var _local2 = watcherSetupUtilClass;
                _local2["init"](null);
            };
            _watcherSetupUtil.setup(this, function (_arg1:String){
                return (target[_arg1]);
            }, function (_arg1:String){
                return (__slot1[_arg1]);
            }, bindings, watchers);
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            this.x = 83;
            this.y = 81;
            this.loadingTitle = "载入成就数据...";
            this._AchievementGeneralViewWindowLoadingBar_Fade1_i();
            this._AchievementGeneralViewWindowLoadingBar_Fade2_i();
            this.addEventListener("initialize", this.___AchievementGeneralViewWindowLoadingBar_CommonLoadingBar1_initialize);
            var i:* = 0;
            while (i < bindings.length) {
                Binding(bindings[i]).execute();
                i = (i + 1);
            };
        }
        public static function set watcherSetupUtil(_arg1:IWatcherSetupUtil2):void{
            AchievementGeneralViewWindowLoadingBar._watcherSetupUtil = _arg1;
        }

        override public function set moduleFactory(_arg1:IFlexModuleFactory):void{
            super.moduleFactory = _arg1;
            if (this.__moduleFactoryInitialized){
                return;
            };
            this.__moduleFactoryInitialized = true;
        }
        override public function initialize():void{
            super.initialize();
        }
        protected function fade1_effectStartHandler(_arg1:EffectEvent):void{
            if (AchievementGeneralViewWindowSourceMgr.getInstance().loadingComplete){
                loadingPercent = 1;
                return;
            };
            AchievementGeneralViewWindowSourceMgr.getInstance().addEventListener(ProgressEvent.PROGRESS, this.loadingProgressHandler);
            AchievementGeneralViewWindowSourceMgr.getInstance().addEventListener(Event.COMPLETE, this.loadingCompleteHandler);
            AchievementGeneralViewWindowSourceMgr.getInstance().loadSwfFile();
        }
        private function loadingProgressHandler(_arg1:ProgressEvent):void{
            loadingPercent = (_arg1.bytesLoaded / _arg1.bytesTotal);
        }
        private function loadingCompleteHandler(_arg1:Event=null):void{
            AchievementGeneralViewWindowSourceMgr.getInstance().removeEventListener(ProgressEvent.PROGRESS, this.loadingProgressHandler);
            AchievementGeneralViewWindowSourceMgr.getInstance().removeEventListener(Event.COMPLETE, this.loadingCompleteHandler);
            loadingPercent = 1;
        }
        private function _AchievementGeneralViewWindowLoadingBar_Fade1_i():Fade{
            var _local1:Fade = new Fade();
            _local1.duration = 300;
            _local1.startDelay = 300;
            _local1.alphaFrom = 0;
            _local1.alphaTo = 1;
            _local1.addEventListener("effectStart", this.__addEffect_effectStart);
            this.addEffect = _local1;
            BindingManager.executeBindings(this, "addEffect", this.addEffect);
            return (_local1);
        }
        public function __addEffect_effectStart(_arg1:EffectEvent):void{
            this.fade1_effectStartHandler(_arg1);
        }
        private function _AchievementGeneralViewWindowLoadingBar_Fade2_i():Fade{
            var _local1:Fade = new Fade();
            _local1.duration = 500;
            _local1.alphaTo = 0;
            this.removeEffect = _local1;
            BindingManager.executeBindings(this, "removeEffect", this.removeEffect);
            return (_local1);
        }
        public function ___AchievementGeneralViewWindowLoadingBar_CommonLoadingBar1_initialize(_arg1:FlexEvent):void{
            alpha = 0;
        }
        private function _AchievementGeneralViewWindowLoadingBar_bindingsSetup():Array{
            var result:* = [];
            result[0] = new Binding(this, null, function (_arg1:*):void{
                this.setStyle("addedEffect", _arg1);
            }, "this.addedEffect", "addEffect");
            result[1] = new Binding(this, null, function (_arg1:*):void{
                this.setStyle("removedEffect", _arg1);
            }, "this.removedEffect", "removeEffect");
            return (result);
        }
        public function get addEffect():Fade{
            return (this._413245038addEffect);
        }
        public function set addEffect(_arg1:Fade):void{
            var _local2:Object = this._413245038addEffect;
            if (_local2 !== _arg1){
                this._413245038addEffect = _arg1;
                if (this.hasEventListener("propertyChange")){
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "addEffect", _local2, _arg1));
                };
            };
        }
        public function get removeEffect():Fade{
            return (this._1267520715removeEffect);
        }
        public function set removeEffect(_arg1:Fade):void{
            var _local2:Object = this._1267520715removeEffect;
            if (_local2 !== _arg1){
                this._1267520715removeEffect = _arg1;
                if (this.hasEventListener("propertyChange")){
                    this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "removeEffect", _local2, _arg1));
                };
            };
        }

    }
}//package source_manager 

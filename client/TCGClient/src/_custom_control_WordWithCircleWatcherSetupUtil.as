﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import mx.core.*;
    import mx.binding.*;
    import custom_control1.*;

    public class _custom_control_WordWithCircleWatcherSetupUtil implements IWatcherSetupUtil2 {

        public static function init(_arg1:IFlexModuleFactory):void{
            WordWithCircle.watcherSetupUtil = new (_custom_control_WordWithCircleWatcherSetupUtil)();
        }

        public function setup(_arg1:Object, _arg2:Function, _arg3:Function, _arg4:Array, _arg5:Array):void{
            _arg5[1] = new PropertyWatcher("_weight", {propertyChange:true}, [_arg4[1]], _arg2);
            _arg5[3] = new PropertyWatcher("_wordText", {propertyChange:true}, [_arg4[4]], _arg2);
            _arg5[2] = new PropertyWatcher("_circleAlpha", {propertyChange:true}, [_arg4[2]], _arg2);
            _arg5[0] = new PropertyWatcher("_color", {propertyChange:true}, [_arg4[0], _arg4[3]], _arg2);
            _arg5[1].updateParent(_arg1);
            _arg5[3].updateParent(_arg1);
            _arg5[2].updateParent(_arg1);
            _arg5[0].updateParent(_arg1);
        }

    }
}//package 

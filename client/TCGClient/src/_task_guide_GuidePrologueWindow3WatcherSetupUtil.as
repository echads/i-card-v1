﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import mx.core.*;
    import mx.binding.*;
    import task_guide.*;

    public class _task_guide_GuidePrologueWindow3WatcherSetupUtil implements IWatcherSetupUtil2 {

        public static function init(_arg1:IFlexModuleFactory):void{
            GuidePrologueWindow3.watcherSetupUtil = new (_task_guide_GuidePrologueWindow3WatcherSetupUtil)();
        }

        public function setup(_arg1:Object, _arg2:Function, _arg3:Function, _arg4:Array, _arg5:Array):void{
            _arg5[0] = new PropertyWatcher("headerText", {propertyChange:true}, [_arg4[0], _arg4[1]], _arg2);
            _arg5[0].updateParent(_arg1);
        }

    }
}//package 

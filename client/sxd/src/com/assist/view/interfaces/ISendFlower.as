﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package com.assist.view.interfaces {
    import flash.display.*;

    public interface ISendFlower {

        function get content():MovieClip;
        function set tip(_arg1:ITip):void;
        function set drag(_arg1:IDrag):void;
        function init():void;
        function clear():void;
        function renderSendFlowerInfo(_arg1:Object, _arg2:Array):void;
        function renderSendFlowerRanking(_arg1:Array):void;
        function set onClose(_arg1:Function):void;
        function set onSendFlower(_arg1:Function):void;
        function set onQueryFlower(_arg1:Function):void;
        function set onTextLink(_arg1:Function):void;
        function set onIsValentineDay(_arg1:Function):void;

    }
}//package com.assist.view.interfaces 

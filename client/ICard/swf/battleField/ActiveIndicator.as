﻿package {
    import flash.utils.*;
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
		import flash.geom.*;
		
    public class ActiveIndicator{
		
			private var _ActiveArr:Array;
			private var _maxTargetNum:int = 10;
			private var _freeIndex:int = 0;
	    public function ActiveIndicator():void{
		    _ActiveArr = [];
		    var n:int = 0;
		    while(n<_maxTargetNum){
		    	var tt:MovieClip = new circle;
		    	_ActiveArr.push(tt);
		    	n++;
		    }
	    }
	    public function get Size():int{
	    	return _freeIndex;
	    }
	    public function IsTarget(realID:int):Boolean{
	    	 var n:int = 0;
		    while(n<_freeIndex){
		    	var tt:MovieClip = _ActiveArr[n];
		    	if(tt.realID == realID)
		    		return true;
		    	n++;
		    }
		    return false;
	    }
		public function SetActiveArr(arr:Array):void{
			var n:int = 0;
			var bSame:Boolean=true;
			if(_freeIndex==arr.length){
				for each(var card0:MovieClip in arr){
					if(card0.realID != _ActiveArr[n].realID){
						bSame = false;
						break;
					}
					n++;
				} 
				if(bSame==true)
				{
					return;
				}
			}
			Empty();
			for each(var card:MovieClip in arr){
				AddIndicator(card);
			}
		}
		
	    public function AddIndicator(card:MovieClip):void{
	    	if(card==null)
	    		return;
	    	if(_freeIndex>=_maxTargetNum)
	    		return;
	    	var indicator:MovieClip = _ActiveArr[_freeIndex];
			indicator.realID = card.realID;
			card.addChildAt(indicator,card.numChildren);
	    	_freeIndex++;
	    }
			public function Empty():void{
				var n:int = 0;
				while(n<_freeIndex){
					var indicator:MovieClip = _ActiveArr[n] as MovieClip;
					indicator.parent.removeChild(indicator);
					n++;
				}
				_freeIndex = 0;
			}
	  
	
    }
}//package 

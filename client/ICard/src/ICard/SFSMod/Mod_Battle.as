//Created by Action Script Viewer - http://www.buraks.com/asv
package ICard.SFSMod {
	
	import ICard.logic.BattleStage;
	
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.*;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.variables.*;
	import com.smartfoxserver.v2.requests.*;

	public class Mod_Battle extends Object{
		
		public var _smartFox : SmartFox;
		private var _battleStage:BattleStage;
		public function Mod_Battle(arg1:SmartFox):void{
			_smartFox = arg1;	
		}
	
		public function onBattleStart(params:ISFSObject):void{
			var meID:int = params.getInt("me");
			var youID:int = params.getInt("you");
			_battleStage.InitGuy(meID,youID);
		}
		public function onBattleStateUpdate(params:ISFSObject):void{
			
		}
		public function onCardUpdate(params:ISFSObject):void{
			var cardArr:ISFSArray = params.getSFSArray("card");
			for (var y:int = 0; y < cardArr.size(); y++)
			{
				var cardObj:ISFSObject = cardArr.getSFSObject(y);
				var keyArr:Array = cardObj.getKeys();
				var cardInfo:Object = new Object;
				for each( var keyVal:String in keyArr)
				{
					cardInfo[keyVal] = cardObj.getInt(keyVal);
				}
				_battleStage.onUpdateCard(cardInfo);
			}
		}
		//����1(srcID);����2(target):Ŀ�꿨{(realID)...},����3(time):��Ӧʱ��(��),����4(attacker),����5(defender);
		public function onCardFight(params:ISFSObject):void{
			var infoObj:ISFSObject = params.getSFSObject("fight");
			var keyArr:Array = infoObj.getKeys();
			var fightInfo:Object = new Object;
			for each( var keyVal:String in keyArr)
			{
					fightInfo[keyVal] = infoObj.getInt(keyVal);
			}
				
			var targetArr:ISFSArray = params.getSFSArray("target");
			var targets:Array = [];
			for (var y:int = 0; y < targetArr.size(); y++)
			{
				var desID:int =  targetArr.getInt(y);
				targets.push_back(desID);
			}
			_battleStage.onCardFight(fightInfo,targets);
		}
		
		//����1(srcID):, ����2(target):{ {realID,hpAdd,def,atk,slot,turn,side} ,...}--�����ÿ����
		public function onCardFightResult(params:ISFSObject):void{
			var srcID:int = params.getInt("srcID");
			var targetArr:ISFSArray = params.getSFSArray("target");
			var targets:Array = [];
			for (var y:int = 0; y < targetArr.size(); y++)
			{
				var targetObj:ISFSObject = targetArr.getSFSObject(y);
				var keyArr:Array = targetObj.getKeys();
				var targetInfo:Object = new Object;
				for each( var keyVal:String in keyArr)
				{
					targetInfo[keyVal] = targetObj.getInt(keyVal);
				}
				targets.push_back(targetInfo);
			}
			_battleStage.onCardFightResult(srcID,targets);
		}
		
		public function QueryStartGame():void{
			var params:ISFSObject = new SFSObject();
			params.putInt("state", 2);
			_smartFox.send( new ExtensionRequest( ICardMsgDef.c2s_client_battle_state_update, params) );
		}
		
		public function QueryUseCard(realID:int,targets:Array):void{
			var params:ISFSObject = new SFSObject();
			params.putInt("srcID", realID);
			if(targets.length >0)
			{
				params.putIntArray("target",targets);
			}
			_smartFox.send( new ExtensionRequest( ICardMsgDef.c2s_battle_card_update, params) );
		}
		public function QueryUpdateCard(realID:int,slot:int):void{
			var params:ISFSObject = new SFSObject();
			params.putInt("realID", realID);
			params.putInt("slot", slot);
			_smartFox.send( new ExtensionRequest( ICardMsgDef.c2s_battle_card_update, params) );
		}		

	}
}//package ICard.protocols 

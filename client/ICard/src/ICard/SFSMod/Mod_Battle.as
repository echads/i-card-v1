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
			_battleStage = BattleStage.getInstance();
		}
	
		public function onBattleStart(params:ISFSObject):void{
			var meID:int = params.getInt("me");
			var youID:int = params.getInt("you");
			var gameID:int = params.getInt("game");
			_battleStage.InitGuy(meID,youID,gameID);
			procCardArr(params);
		}
		
		public function onCardUpdate(params:ISFSObject):void{
			procCardArr(params);
			updateTurnPlayerRes(params);
		}
		//����1(srcID);����2(target):Ŀ�꿨{(realID)...},����3(time):��Ӧʱ��(��),����4(attacker),����5(defender);
		public function onCardFight(params:ISFSObject):void{
			onProcPreActionInfo(params);
		}
		private function updateTurnPlayerRes(params:ISFSObject):void{
			var res:int = params.getInt("res");
			_battleStage.TurnPlayer.CardDB.ResNum = res;
		}
		//����1(srcID):, ����2(target):{ {realID,hpAdd,def,atk,slot,turn,side} ,...}--�����ÿ����
		public function onCardFightResult(params:ISFSObject):void{
			updateTurnPlayerRes(params);
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
				targets.push(targetInfo);
			}
			_battleStage.onCardFightResult(srcID,targets);
		}
		
		public function onCardPlayerLoop(params:ISFSObject):void{
			var playerID:int = params.getInt("playerID");
			var secNum:int = params.getInt("time");
			_battleStage.PlayerLoopFresh(playerID,secNum);
		}
		public function onWaitPlayCard(params:ISFSObject):void{
			var secNum:int = params.getInt("time");
			var playerID:int = params.getInt("playerID");
			_battleStage.WaitPlayerCard(playerID,secNum);
		}
		public function onTurnPlayerLoop(params:ISFSObject):void{
			var playerID:int = params.getInt("playerID");
			var secNum:int = params.getInt("time");
			onProcPreActionInfo(params);
			updateTurnPlayerRes(params);
			_battleStage.TurnPlayerLoop(playerID,secNum);
			//_battleStage.PlayerLoopFresh(playerID,secNum);
		}
		private function onProcPreActionInfo(params:ISFSObject):void{
			var fighterObj:ISFSObject = params.getSFSObject("fight");
			if(fighterObj==null)
				return;
				
			var srcID:int = fighterObj.getInt("srcID");
			var actionType:int = fighterObj.getInt("type");
			var targetArr:Array = params.getIntArray("target");
			_battleStage.PreShowAction(srcID,actionType,targetArr);			
		}
		public function onEndOpOK(params:ISFSObject):void{
			_battleStage.onEndOpOK();
		}
		public function onCardExOp(params:ISFSObject):void{
			var ability:int = params.getInt("ability");
			var card:int = params.getInt("card");
			var playerID:int = params.getInt("playerID");
			var secNum:int = params.getInt("time");
			_battleStage.onCardExOp(playerID,card,ability);
		}
		public function QueryStartGame():void{
			var params:ISFSObject = new SFSObject();
			params.putInt("state", 2);
			_smartFox.send( new ExtensionRequest( ICardMsgDef.c2s_client_battle_state_update, params) );
		}
		
		public function QueryTaskUse(realID:int,targets:Array):void{
			var params:ISFSObject = new SFSObject();
			params.putInt("srcID", realID);
			params.putInt("game",_battleStage.GameID);
			if(targets.length >0)
			{
				params.putIntArray("target",targets);
			}
			_smartFox.send( new ExtensionRequest( ICardMsgDef.c2s_battle_card_taskuse, params) );
		}
		public function QueryFightCard(realID:int,targets:Array):void{
			var params:ISFSObject = new SFSObject();
			params.putInt("srcID", realID);
			params.putInt("game",_battleStage.GameID);
			if(targets && targets.length >0)
			{
				params.putIntArray("target",targets);
			}
			_smartFox.send( new ExtensionRequest( ICardMsgDef.c2s_battle_fight_card, params) );
		}
		public function QueryEndOp():void{
			var params:ISFSObject = new SFSObject();
			params.putInt("game",_battleStage.GameID);
			_smartFox.send( new ExtensionRequest( ICardMsgDef.c2s_end_op, params) );
		}
		public function QueryEnterCard(realID:int):void{
			var params:ISFSObject = new SFSObject();
			params.putInt("realID", realID);
			params.putInt("game",_battleStage.GameID);
			_smartFox.send( new ExtensionRequest( ICardMsgDef.c2s_battle_enter_card, params) );
		}
		public function QueryPlayRes(realID:int):void{
			var params:ISFSObject = new SFSObject();
			params.putInt("realID", realID);
			params.putInt("game",_battleStage.GameID);
			_smartFox.send( new ExtensionRequest( ICardMsgDef.c2s_battle_play_res, params) );
		}	
		
		private function procCardArr(params:ISFSObject):void{
			var cardArr:ISFSArray = params.getSFSArray("card");
			if(cardArr==null)
				return;
			for (var y:int = 0; y < cardArr.size(); y++)
			{
				var cardObj:ISFSObject = cardArr.getSFSObject(y);
				var keyArr:Array = cardObj.getKeys();
				var cardInfo:Object = new Object;
				for each( var keyVal:String in keyArr)
				{
					if(keyVal=="mp")
						var kk:int = 0;
					cardInfo[keyVal] = cardObj.getInt(keyVal);
				}
				_battleStage.onUpdateCard(cardInfo);
			}
		}
	}
}//package ICard.protocols 

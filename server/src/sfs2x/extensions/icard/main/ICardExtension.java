package sfs2x.extensions.icard.main;





import java.util.Enumeration;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

import sfs2x.extensions.icard.beans.CardGameBean;
import sfs2x.extensions.icard.beans.CardInfoStoreBean;
import sfs2x.extensions.icard.beans.CardDeckBean;
import sfs2x.extensions.icard.beans.GameLobbyBean;
import sfs2x.extensions.icard.bsn.GameBsn;
import sfs2x.extensions.icard.bsn.SFSObjectBsn;
import sfs2x.extensions.icard.main.commandHandler.*;
import sfs2x.extensions.icard.main.eventHandler.*;

import sfs2x.extensions.icard.utils.Commands;


import com.smartfoxserver.v2.core.SFSEventType;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.SFSExtension;

public class ICardExtension extends SFSExtension {

	/** Game controller */
	private GameController _gameController = null;
	private static ICardExtension _this = null;
	@Override

	public void init() {
		trace("**************************************");
		trace("* Starting ICard extension");
		CardInfoStoreBean.GetInstance();
		ParentExtension.setInstance(this);
		_this = this;
		// Initialize game controller
		_gameController = new GameController(this);
		_gameController.start();

		//命令handler添加
		//客户端准备
		
		addRequestHandler(Commands.CMD_C2S_CLIENT_BATTLE_STATE_UPDATE,ClientBattleStateUpdateHandle.class);
		addRequestHandler(Commands.CMD_C2S_PLAY_RES,ClientPlayResHandle.class);
		addRequestHandler(Commands.CMD_C2S_ENTER_CARD,ClientEnterCardHandle.class);
		addRequestHandler(Commands.CMD_C2S_FIGHT_CARD,ClientFightCardHandle.class);
		addRequestHandler(Commands.CMD_C2S_END_OP,ClientEndOpHandle.class);
		

		
		//事件handle添加
		// Event handler: join room
		addEventHandler(SFSEventType.USER_JOIN_ROOM, UserJoinedRoomEventHandler.class);

		// Event handler: user leave game room
		addEventHandler(SFSEventType.USER_LEAVE_ROOM, UserLeavedRoomEventHandler.class);

		
		// Event handler: user log out
		addEventHandler(SFSEventType.USER_LOGOUT, UserDisconnectedEventHandler.class);

		// Event handler: user disconnect
		addEventHandler(SFSEventType.USER_DISCONNECT, UserDisconnectedEventHandler.class);
		
		// Event handler: USER_JOIN_ZONE
		addEventHandler(SFSEventType.USER_JOIN_ZONE, UserJoinedZoneEventHandler.class);
		
		// Event handler: ROOM_ADDED
		addEventHandler(SFSEventType.ROOM_ADDED, RoomCreatedEventHandler.class);
		
		// Event handler: ROOM_REMOVED 
		addEventHandler(SFSEventType.ROOM_REMOVED, RoomRemovedEventHandler.class);


		trace("* ICard initialization completed");
		trace("**************************************");
	}
	public static ICardExtension getExt(){
		return _this;
	}
	public void startGame(List<User> players)
	{
		
	}
	public ConcurrentHashMap<Integer, CardGameBean> getGames(){
		return GameLobbyBean.GetInstance().getGameMap();
	}
	public void destroy()
	{
		_gameController.setTimeEventsRunning(false);
		_gameController = null;
		
		removeEventHandler(SFSEventType.USER_JOIN_ROOM);
		removeEventHandler(SFSEventType.USER_LEAVE_ROOM);
		removeEventHandler(SFSEventType.USER_LOGOUT);
		removeEventHandler(SFSEventType.USER_DISCONNECT);
		removeEventHandler(SFSEventType.USER_JOIN_ZONE);
		removeEventHandler(SFSEventType.ROOM_ADDED);
		removeEventHandler(SFSEventType.ROOM_REMOVED);
		removeRequestHandler(Commands.CMD_C2S_CLIENT_BATTLE_STATE_UPDATE);
		removeRequestHandler(Commands.CMD_C2S_CARD_TASKUSE);
		removeRequestHandler(Commands.CMD_C2S_PLAY_RES);
		removeRequestHandler(Commands.CMD_C2S_END_OP);
		removeRequestHandler(Commands.CMD_C2S_EX_OP);

		trace("ICard extension destroyed");
	}
	public void SendGameCommand(String command,ISFSObject params,CardGameBean game){
		trace("send game command",command);
		for (Enumeration<CardDeckBean> e = game.getDeck().elements(); e.hasMoreElements();){
			CardDeckBean site = (CardDeckBean) e.nextElement();
			if(site.getSfsUser()!=null)
				send(command, params, site.getSfsUser());
		}
	}
	public void SendGameCardUpdate(CardGameBean game){
		if(GameBsn.ExistDirtyCard(game)==false)
			return;
		CardDeckBean turnDeck = game.getTurnDeck();
		for(CardDeckBean site :game.getDeck().values())
		{
			if(site.getSfsUser()==null)
				continue;
			ISFSObject params = new SFSObject();
			ISFSArray sfsa = SFSObjectBsn.genDirtyGameArr(game,site.getPlayerID());
			params.putSFSArray("card", sfsa);
			params.putInt("res", turnDeck.getCurRes());
			send(Commands.CMD_S2C_CARD_UPDATE, params, site.getSfsUser());
		}
	}
	
}

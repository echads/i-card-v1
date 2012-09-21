package sfs2x.extensions.icard.beans;

import sfs2x.extensions.icard.bsn.AttrBsn;
import sfs2x.extensions.icard.bsn.BufferBsn;
import sfs2x.extensions.icard.bsn.CardSiteBsn;
import sfs2x.extensions.icard.bsn.CardUseBsn;
import sfs2x.extensions.icard.utils.Constants;

/**
 * BombBean: object describing a bomb on the game map
 * 
 * @author Ing. Ignazio Locatelli
 * @version 1.0
 */
public class CardBean
{
	public final static int HAND_ZONE_ID = 1;
	public final static int RES_ZONE_ID = 2;
	public final static int EQUIP_ZONE_ID = 3;
	public final static int FIGHT_ZONE_ID = 4;
	public final static int GRAVE_ZONE_ID = 5;
	public final static int HERO_ZONE_ID = 6;
	public final static int SUPPORT_ZONE_ID = 7;
	public final static int ATTACH_ZONE_ID = 8;
	
	public final static int ZONE_DIRTY_BIT = 0;
	public final static int HP_DIRTY_BIT = 1;
	public final static int TURN_DIRTY_BIT = 2;
	public final static int ATK_DIRTY_BIT = 3;
	public final static int DEF_DIRTY_BIT = 4;
	public final static int COST_DIRTY_BIT = 5;
	public final static int SIDE_DIRTY_BIT = 6;
	public final static int CARDID_DIRTY_BIT = 7;
	public final static int BUF_DIRTY_BIT = 8;
	
	private int _realID;
	private int _cardID;
	private int _zoneID;
	private CardDeckBean _deck;
	private int _turn;
	private int _side;
	private int _addHp;
	private int _dirtyFlag=0;
	private int _loopNum=0;
	private CardInfoBean _info;
	private BufferStoreBean _bufStore;
	public CardBean(int realID, int cardID,int zoneID,CardDeckBean deck)
	{
		_realID = realID;
		_cardID = cardID;
		_zoneID = zoneID;
		_deck = deck;
		setDirtyFlagBit(ZONE_DIRTY_BIT);
		setDirtyFlagBit(CARDID_DIRTY_BIT);
		_info = CardInfoStoreBean.GetInstance().getCardInfo(cardID);
		_bufStore = new BufferStoreBean();
	}
	/* GETTERS & SETTERS */
	public BufferStoreBean getBufStore(){
		return _bufStore;
	}
	public void AddBuf(CardAbilityBean ability,int realID){
		_bufStore.AddBuf(ability,realID);
		setDirtyFlagBit(BUF_DIRTY_BIT);
	}
	public void DelBuf(int realID){
		_bufStore.DelBuf(realID);
		setDirtyFlagBit(BUF_DIRTY_BIT);
	}
	public int getOwner(){
		return _deck.getPlayerID();
	}
	public int getCardID() {
		return _cardID;
	}
	public int getClientCardID(Boolean bOwner){
		if(bOwner==false){
			if(_zoneID==CardBean.HAND_ZONE_ID)
				return Constants.BACK_CARD_ID;			
		}
		return _cardID;
	}
	public void setCardID(int id) {
		_cardID = id;
	}
	public int getCardType(){
		if(_info!=null)
			return _info.getType();
		return -1;
	}
	public CardInfoBean getInfo(){
		return _info;
	}
	public int getRealID() {
		return _realID;
	}

	public void setRealID(int id) {
		_realID = id;
	}
	public int getZoneID(){
		return _zoneID;
	}
	public boolean getIsPlayZone(){
		return (_zoneID==CardBean.EQUIP_ZONE_ID ||
				_zoneID==CardBean.FIGHT_ZONE_ID ||
				_zoneID==CardBean.HERO_ZONE_ID ||
				_zoneID==CardBean.SUPPORT_ZONE_ID||
				_zoneID==CardBean.ATTACH_ZONE_ID);
	}
	public void setZoneID(int id){
		_zoneID = id;
		setDirtyFlagBit(ZONE_DIRTY_BIT);
	}
	public int getTurn() {
		return _turn;
	}

	public void setTurn(int val) {
		_turn = val;
		setDirtyFlagBit(TURN_DIRTY_BIT);
	}
	public int getSide() {
		return _side;
	}

	public void setSide(int val) {
		_side = val;
		setDirtyFlagBit(SIDE_DIRTY_BIT);
	}
	public boolean IsHero(){
		return (_zoneID==CardBean.HERO_ZONE_ID);
	}
	public boolean IsPointUnable(){
		if(AttrBsn.IsExistAttr(_cardID,CardAttrBean.POINT_UNABLE))
			return true;
		return BufferBsn.IsExistBuf(this,CardAbilityBean.BUF_POINT_UNABLE,CardAbilityBean.WHEN_ALL);
	}
	public boolean IsResetEnable(){
		return (BufferBsn.IsExistBuf(this, CardAbilityBean.BUF_SIDE,CardAbilityBean.WHEN_ALL)==false);
	}
	public boolean IsInstant(){
		if(AttrBsn.IsExistAttr(_cardID,CardAttrBean.INSTANT))
			return true;
		return BufferBsn.IsExistBuf(this,CardAbilityBean.BUF_AT_ONCE,CardAbilityBean.WHEN_ALL);
	}
	public boolean IsHidden(){
		if(AttrBsn.IsExistAttr(_cardID,CardAttrBean.HIDE))
			return true;
		return BufferBsn.IsExistBuf(this,CardAbilityBean.BUF_HIDDEN,CardAbilityBean.WHEN_ALL);
	}
	public boolean IsDistAtk(int when){
		if(AttrBsn.IsExistAttr(_cardID,CardAttrBean.DIST_ATK))
			return true;
		return BufferBsn.IsExistBuf(this,CardAbilityBean.BUF_ATK_DIST,when);
	}
	public boolean IsAtkUnable(int when){
		return BufferBsn.IsExistBuf(this,CardAbilityBean.BUF_ATK_UNABLE,when);
	}
	public boolean IsUnableAtked(int when){
		return BufferBsn.IsExistBuf(this,CardAbilityBean.BUF_UNABLE_ATKED,when);
	}
	public boolean IsGuidable(int when){
		if(AttrBsn.IsExistAttr(_cardID,CardAttrBean.DIST_ATK))
			return true;
		return BufferBsn.IsExistBuf(this,CardAbilityBean.BUF_GUIDE,when);
	}
	public int getCost(){ //费用
		return _info.getBaseCost();
	}
	public int getUseCost(){ //使用（武器，法术）,横置(盟军)费用,英雄翻转
		return _info.getBaseUseCost();
	}
	public int getDef(int when){ //防御力
		return _info.getBaseDefence() + BufferBsn.getAbilityVal(this,when,CardAbilityBean.BUF_DEF_ADD);
	}
	public int getWhich(){
		int which = CardAbilityBean.WHICH_NULL;
		switch(getCardType()){
		case CardInfoBean.HERO:
			which = CardAbilityBean.WHICH_MYHERO;
			break;
		case CardInfoBean.ALLY:
			which = CardAbilityBean.WHICH_MYSOLDIER;
			break;
		case CardInfoBean.WEAPON:
			which = CardAbilityBean.WHICH_MYWEAPON;
			break;
		}
		return which;
	}
	public int getLoopNum(){
		return _loopNum;
	}
	public void IncLoop(){
		if(getIsPlayZone())
			_loopNum++;
	}
	public int getAtk(int when){ //攻击力
		return _info.getBaseAttack() + CardSiteBsn.supportAtkVal(_deck,getWhich(), when) + BufferBsn.getAbilityVal(this,when,CardAbilityBean.BUF_ATK_ADD);
	}
	public void setDead(){
		AddHp(-10000);
		setZoneID(GRAVE_ZONE_ID);
	}
	public int getHp(){  //血量
		return _addHp + _info.getBaseHp() ;
	}
	public void AddHp(int val){
		_addHp += val;
		if(_addHp > (getMaxHp() - _info.getBaseHp()))
			_addHp = getMaxHp() - _info.getBaseHp();
		setDirtyFlagBit(HP_DIRTY_BIT);	
	}
	public Boolean getIsDead(){ 
		return (_addHp + _info.getBaseHp())<=0;
	}
	public int getMaxHp(){ //血上限
		return _info.getBaseHp();
	}
	public void setDirtyFlagBit(int bitPos){
		_dirtyFlag |= 1<< bitPos;
	}
	public int getDirtyFlag(){
		return _dirtyFlag;
	}
	public void setDirtyFlag(int val){
		_dirtyFlag = val;
	}
	public Boolean getDirtyFlagBit(int bitPos){
		int val = _dirtyFlag & (1<<bitPos);
		return (val>0);
	}

	
	
}
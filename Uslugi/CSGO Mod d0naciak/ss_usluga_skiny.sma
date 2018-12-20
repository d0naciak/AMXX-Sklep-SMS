/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <colorchat>
#include <csgo>
#include <smsshop>

new g_iUsluga;

#define NAZWA_DL "Dowolny skin" 				//Nazwa uslugi wyswietlana w menu
#define NAZWA_KR "skiny" 						//nazwa uslugi uzywana w logach, jako okienko MOTD itd.
#define CENA_KR "2,46"						//krotka cena SMS (wstawiaj przecinek, nie kropke!)
#define CENA_DL "2,46 zl SMS / 2 zl przelew / 2 zl PSC"		//dluga cena ktora wyswietlana bedzie w menu

new g_iOstatnioWybranaBron[33];
new g_iOstatnioWybranySkin[33];

public plugin_init() 
{
	new szNazwa[64]; formatex(szNazwa, 63, "Sklep SMS: Usluga %s", NAZWA_DL);
	register_plugin(szNazwa, "1.0", "d0naciak");
	
	g_iUsluga = ss_register_service(NAZWA_DL, NAZWA_KR);
	ss_add_service_qu(g_iUsluga, "-", "0", CENA_DL, CENA_KR);
}	

public ss_buy_service_pre(id, iUsluga, iJednostkaIlosci)
{
	if(iUsluga != g_iUsluga)
		return SS_CONTINUE;
	
	WybierzBron(id);
	return SS_STOP;
}


public WybierzBron(id) {
	
	new iMenu = menu_create("Wybierz bron:", "WybierzBron_Handler"),
	szNazwaBroni[16], szCswId[4];
	
	for(new i = 1; i < 31; i++)
	{
		if(CSGO_BLOCKWPNSKINS & (1<<i) || !csgo_get_skinsnum(i))
			continue;
		
		csgo_get_short_weaponname(i, szNazwaBroni, 15);
		num_to_str(i, szCswId, 3);
		
		menu_additem(iMenu, szNazwaBroni, szCswId);
	}
	
	menu_setprop(iMenu, MPROP_EXIT, MEXIT_NEVER);
	menu_display(id, iMenu);
}

public WybierzBron_Handler(id, iMenu, iItem) {
	if(iItem < 0) {
		return PLUGIN_CONTINUE;
	}
	
	new iAccess, iCb, szCswId[4], szItem[32];
	menu_item_getinfo(iMenu, iItem, iAccess, szCswId, 3, szItem, 31, iCb);
	g_iOstatnioWybranaBron[id] = str_to_num(szCswId);
	
	ColorChat(id, NORMAL, "Wybrales^x03 %s", szItem);
	WybierzSkina(id);
	
	menu_destroy(iMenu);
	return PLUGIN_CONTINUE;
}

public WybierzSkina(id) {
	new iMenu = menu_create("Wybierz skina, ktorego chcesz dodac do oferty:", "WybierzSkina_Handler"),
	iCswId = g_iOstatnioWybranaBron[id],
	szSkin[32], szSkinId[4];
	
	for(new i = 1; i <= csgo_get_skinsnum(iCswId); i++) {
		num_to_str(i, szSkinId, 3);
		csgo_get_skin_name(iCswId, i, szSkin, 31);
			
		menu_additem(iMenu, szSkin, szSkinId);
	}
	
	menu_setprop(iMenu, MPROP_EXIT, MEXIT_NEVER);
	menu_display(id, iMenu);
	return PLUGIN_CONTINUE;
}

public WybierzSkina_Handler(id, iMenu, iItem) {
	remove_task(id);
	
	if(iItem < 0) {
		return PLUGIN_CONTINUE;
	}
	
	new iAccess, iCb, szSkinId[4], szItem[32];
	menu_item_getinfo(iMenu, iItem, iAccess, szSkinId, 3, szItem, 31, iCb);
	g_iOstatnioWybranySkin[id] = str_to_num(szSkinId);
	
	ColorChat(id, NORMAL, "Wybrales^x03 %s", szItem);
	ss_go_to_choosing_pay_method(id);
		
	menu_destroy(iMenu);
	return PLUGIN_CONTINUE;
}

public ss_buy_service_post(id, iUsluga, iJednostkaIlosci)
{
	if(iUsluga != g_iUsluga)
		return SS_CONTINUE;
	
	new iCswId = g_iOstatnioWybranaBron[id], iSkinId = g_iOstatnioWybranySkin[id];
	csgo_set_user_skins(id, iCswId, iSkinId, csgo_get_user_skins(id, iCswId, iSkinId) + 1);
	
	ss_finalize_user_service(id);
	
	return SS_CONTINUE;
}


/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/

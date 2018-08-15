/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <codmod>
#include <colorchat>
#include <smsshop>

new g_iUsluga;

#define NAZWA_DL "Dowolny perk" 					//Nazwa uslugi wyswietlana w menu
#define NAZWA_KR "perk" 					//nazwa uslugi uzywana w logach, jako okienko MOTD itd.
#define CENA_KR "7,38"						//krotka cena SMS (wstawiaj przecinek, nie kropke!)
#define CENA_DL "7,38 zl SMS / 5 zl przelew / 5 zl PSC"		//dluga cena ktora wyswietlana bedzie w menu

new g_iOstatnioWybranyPerk[33];

public plugin_init() 
{
	new szNazwa[64]; formatex(szNazwa, 63, "Sklep SMS: Usluga %s", NAZWA_DL);
	register_plugin(szNazwa, "1.0", "d0naciak");
	
	g_iUsluga = ss_register_service(NAZWA_DL, NAZWA_KR);
	ss_add_service_qu(g_iUsluga, "-", "0", CENA_KR, CENA_DL);
	
}

public ss_buy_service_pre(id, iUsluga, iJednostkaIlosci)
{
	if(iUsluga != g_iUsluga)
		return SS_CONTINUE;

	new szNazwa[64], iIloscPerkow = cod_get_perks_num();
	new iMenu = menu_create("Ktory perk chcesz kupic?", "WybierzPerk_Handler");
	
	for(new i = 1; i <= iIloscPerkow; i++)
	{
		cod_get_perk_name(i, szNazwa, 63);
		menu_additem(iMenu, szNazwa);
	}
	
	menu_display(id, iMenu);
	return SS_STOP;
}

public WybierzPerk_Handler(id, iMenu, iItem)
{
	if(iItem == MENU_EXIT)
	{
		menu_destroy(iMenu);
		return PLUGIN_CONTINUE;
	}
	
	if(iItem < 0)
		return PLUGIN_CONTINUE;
	

	new iIdPerku = g_iOstatnioWybranyPerk[id] = iItem+1, szNazwaPerku[64];
	
	cod_get_perk_name(iIdPerku, szNazwaPerku, 63);
	ColorChat(id, GREEN, "[SKLEP]^x01 Wybrano perk^x03 %s", szNazwaPerku);

	ss_go_to_choosing_pay_method(id);
	menu_destroy(iMenu);

	return PLUGIN_CONTINUE;
}

public ss_buy_service_post(id, iUsluga, iJednostkaIlosci)
{
	if(iUsluga != g_iUsluga)
		return SS_CONTINUE;
	
	cod_set_user_perk(id, g_iOstatnioWybranyPerk[id]);
	ss_finalize_user_service(id);
	
	return SS_CONTINUE;
}

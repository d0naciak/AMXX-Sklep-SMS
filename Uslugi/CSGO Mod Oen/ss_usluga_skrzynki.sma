/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <smsshop>

native set_player_case_ak47(id, ile);
native set_player_case_m4a1(id, ile);
native set_player_case_awp(id, ile);
native set_player_case_dgl(id, ile);
native set_player_case_famas(id, ile);
native set_player_case_usp(id, ile);
native set_player_case_glock(id, ile);
native set_player_case_mp5(id, ile);
native get_player_case_ak47(id);
native get_player_case_m4a1(id);
native get_player_case_awp(id);
native get_player_case_dgl(id);
native get_player_case_famas(id);
native get_player_case_usp(id);
native get_player_case_glock(id);
native get_player_case_mp5(id);
	
new g_iUsluga;

#define NAZWA_DL "Dowolna skrzynka" 				//Nazwa uslugi wyswietlana w menu
#define NAZWA_KR "skrzynki" 						//nazwa uslugi uzywana w logach, jako okienko MOTD itd.
#define CENA_KR "7,38"						//krotka cena SMS (wstawiaj przecinek, nie kropke!)
#define CENA_DL "7,38 zl SMS / 5 zl przelew / 5 zl PSC"		//dluga cena ktora wyswietlana bedzie w menu


new const g_szJednostkaIlosci[][][] = {
	{ "10", "10 skrzynek" },
	{ "20", "20 skrzynek" },
	{ "40", "40 skrzynek" },
	{ "50", "50 skrzynek" }
	//Wypisz tutaj po kolei jednostke ilosci uslug
	//Format: "kr. jednostka", "dl. jednostka"
	//dluga jednostka - wyswietlana jest w np. menu
	//krotka jednostka - wykorzystywana w skryptach
	//Pamietaj ze ostatnia linijka nie ma na koncu po klamrze przecinka!
}

new const g_szCena[][][] = {
	{ "1,23", "1,23 zl SMS / 1 zl przelew / 1 zl PSC" },
	{ "3,69", "3,69 zl SMS / 2 zl przelew / 2 zl PSC" },
	{ "7,38", "7,38 zl SMS / 6 zl przelew / 6 zl PSC" },
	{ "11,07", "11,07 zl SMS / 9 zl przelew / 9 zl PSC" }
	//Wypisz tutaj w takiej samej kolejnosci jak dlugosci uslug ich ceny
	//Format: "kr. cena", "dl. cena"
	//krotka cena - cena SMSa uslugi - zlotowki i grosze oddzielone przecinkiem
	//dluga cena - cena wyswietlana w menu
	//Pamietaj ze ostatnia linijka nie ma na koncu po klamrze przecinka!
}
new g_iOstatnioWybranaSkrzynka[33];

public plugin_init() 
{
	new szNazwa[64]; formatex(szNazwa, 63, "Sklep SMS: Usluga %s", NAZWA_DL);
	register_plugin(szNazwa, "1.0", "d0naciak");
	
	g_iUsluga = ss_register_service(NAZWA_DL, NAZWA_KR);
	
	for(new i = 0; i < sizeof g_szJednostkaIlosci; i++)
		ss_add_service_qu(g_iUsluga, g_szJednostkaIlosci[i][1], g_szJednostkaIlosci[i][0], g_szCena[i][1], g_szCena[i][0]);
}	

public ss_buy_service_pre(id, iUsluga, iJednostkaIlosci)
{
	if(iUsluga != g_iUsluga)
		return SS_CONTINUE;
	
	WybierzSkrzynke(id);
	return SS_STOP;
}


public WybierzSkrzynke(id) {
	
	new iMenu = menu_create("Wybierz skrzynke:", "WybierzSkrzynke_Handler");
	
	menu_additem(iMenu, "Skrzynka ze skinami AK47");
	menu_additem(iMenu, "Skrzynka ze skinami M4A1");
	menu_additem(iMenu, "Skrzynka ze skinami AWP");
	menu_additem(iMenu, "Skrzynka ze skinami Deagle");
	menu_additem(iMenu, "Skrzynka ze skinami Famas");
	menu_additem(iMenu, "Skrzynka ze skinami USP");
	menu_additem(iMenu, "Skrzynka ze skinami Glock 18");
	menu_additem(iMenu, "Skrzynka ze skinami MP5");
	menu_setprop(iMenu, MPROP_EXIT, MEXIT_NEVER);
	menu_display(id, iMenu);
}

public WybierzSkrzynke_Handler(id, iMenu, iItem) {
	switch(iItem) {
		case MENU_EXIT: {
			menu_destroy(iMenu);
		}
		
		case MENU_BACK, MENU_MORE: {
			return PLUGIN_CONTINUE;
		}
		
		default: {
			g_iOstatnioWybranaSkrzynka[id] = iItem;
			ss_go_to_choosing_pay_method(id);
			
			menu_destroy(iMenu);
		}
	}
	
	return PLUGIN_CONTINUE;
}
public ss_buy_service_post(id, iUsluga, iJednostkaIlosci)
{
	if(iUsluga != g_iUsluga)
		return SS_CONTINUE;
	
	switch(g_iOstatnioWybranaSkrzynka[id]) {
		case 0: set_player_case_ak47(id, get_player_case_ak47(id) + str_to_num(g_szJednostkaIlosci[iJednostkaIlosci][0]));
		case 1: set_player_case_m4a1(id, get_player_case_m4a1(id) + str_to_num(g_szJednostkaIlosci[iJednostkaIlosci][0]));
		case 2: set_player_case_awp(id, get_player_case_awp(id) + str_to_num(g_szJednostkaIlosci[iJednostkaIlosci][0]));
		case 3: set_player_case_dgl(id, get_player_case_dgl(id) + str_to_num(g_szJednostkaIlosci[iJednostkaIlosci][0]));
		case 4: set_player_case_famas(id, get_player_case_famas(id) + str_to_num(g_szJednostkaIlosci[iJednostkaIlosci][0]));
		case 5: set_player_case_usp(id, get_player_case_usp(id) + str_to_num(g_szJednostkaIlosci[iJednostkaIlosci][0]));
		case 6: set_player_case_glock(id, get_player_case_glock(id) + str_to_num(g_szJednostkaIlosci[iJednostkaIlosci][0]));
		case 7: set_player_case_mp5(id, get_player_case_mp5(id) + str_to_num(g_szJednostkaIlosci[iJednostkaIlosci][0]));
	}
	
	ss_finalize_user_service(id);
	
	return SS_CONTINUE;
}



/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <csgo>
#include <smsshop>

new g_iUsluga;

#define NAZWA_DL "Euro" 				//Nazwa uslugi wyswietlana w menu
#define NAZWA_KR "euro" 				//nazwa uslugi uzywana w logach, jako okienko MOTD itd.


new const g_szJednostkaIlosci[][][] = {
	{ "500", "5.00 Euro" },
	{ "1200", "12.00 Euro" },
	{ "2500", "25.00 Euro" }
	//Wypisz tutaj po kolei jednostke ilosci uslug
	//Format: "kr. jednostka", "dl. jednostka"
	//dluga jednostka - wyswietlana jest w np. menu
	//krotka jednostka - wykorzystywana w skryptach
	//Pamietaj ze ostatnia linijka nie ma na koncu po klamrze przecinka!
}

new const g_szCena[][][] = {
	{ "2,46", "2,46 zl SMS" },
	{ "4,92", "4,92 zl SMS" },
	{ "6,15", "6,15 zl SMS / 3,50 zl przelew / 4 zl PSC" }
	//Wypisz tutaj w takiej samej kolejnosci jak dlugosci uslug ich ceny
	//Format: "kr. cena", "dl. cena"
	//krotka cena - cena SMSa uslugi - zlotowki i grosze oddzielone przecinkiem
	//dluga cena - cena wyswietlana w menu
	//Pamietaj ze ostatnia linijka nie ma na koncu po klamrze przecinka!
}

public plugin_init() 
{
	new szNazwa[64]; formatex(szNazwa, 63, "Sklep SMS: Usluga %s", NAZWA_DL);
	register_plugin(szNazwa, "1.0", "d0naciak");
	
	g_iUsluga = ss_register_service(NAZWA_DL, NAZWA_KR);
	
	for(new i = 0; i < sizeof g_szJednostkaIlosci; i++)
		ss_add_service_qu(g_iUsluga, g_szJednostkaIlosci[i][1], g_szJednostkaIlosci[i][0], g_szCena[i][1], g_szCena[i][0]);
}

public ss_buy_service_post(id, iUsluga, iJednostkaIlosci)
{
	if(iUsluga != g_iUsluga)
		return SS_CONTINUE;
	
	csgo_set_user_euro(id, csgo_get_user_euro(id) + str_to_num(g_szJednostkaIlosci[iJednostkaIlosci][0]));
	
	ss_finalize_user_service(id);
	
	return SS_CONTINUE;
}

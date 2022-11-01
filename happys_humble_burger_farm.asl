state("Happy's Humble Burger Farm", "1.16.3")
{
    float xPos : "mono-2.0-bdwgc.dll", 0x497DE8, 0xA8, 0xE70, 0x1E0, 0x0, 0x138;        //starts at -1.031000137 (in Apartment)
    float yPos : "mono-2.0-bdwgc.dll", 0x497DE8, 0xA8, 0xE70, 0x1E0, 0x0, 0x13C;        //starts at -1342.243408 (in Apartment)
    float zPos : "mono-2.0-bdwgc.dll", 0x497DE8, 0xA8, 0xE70, 0x1E0, 0x0, 0x140;        //starts at 5.091000557 (in Apartment)

    int loadScreen : "UnityPlayer.dll", 0x17DEA88, 0x1420, 0xFD48, 0x78, 0x780;         //3 or 4 if loading, 2 if not
    int bootScreen : "UnityPlayer.dll", 0x17DEA88, 0x1420, 0x8CD8, 0x78, 0x0;           //3 or 4 if loading, 2 if not

    int miscLoadA : "UnityPlayer.dll", 0x1821B70, 0x24;                                 //4 if loading, 1 if not
    int miscLoadB : "UnityPlayer.dll", 0x17DEA80, 0x0, 0xCA90, 0x78, 0x690;	        //4 if loading, 3 if not

    int gameState : "UnityPlayer.dll", 0x1783610;                     			//0 if cutscene, varies if not
}

state("Happy's Humble Burger Farm", "1.17.0")
{
    float xPos : "mono-2.0-bdwgc.dll", 0x497DE8, 0xA8, 0xE70, 0x1E0, 0x0, 0x138;        //starts at -1.031000137 (in Apartment)
    float yPos : "mono-2.0-bdwgc.dll", 0x497DE8, 0xA8, 0xE70, 0x1E0, 0x0, 0x13C;        //starts at -1342.243408 (in Apartment)
    float zPos : "mono-2.0-bdwgc.dll", 0x497DE8, 0xA8, 0xE70, 0x1E0, 0x0, 0x140;        //starts at 5.091000557 (in Apartment)

    int loadScreen : "UnityPlayer.dll", 0x17DEA88, 0x1420, 0xBF8, 0x78, 0xA0;           //3 or 4 if loading, 2 if not
    int bootScreen : "UnityPlayer.dll", 0x17DEA88, 0x1420, 0x3E28, 0x78, 0xA0;          //3 or 4 if loading, 2 if not

    int miscLoadA : "UnityPlayer.dll", 0x1821B70, 0x24;                                 //4 if loading, 1 if not
    int miscLoadB : "UnityPlayer.dll", 0x17DEA80, 0x0, 0xCA90, 0x78, 0x690;		//4 if loading, 3 if not

    int gameState : "UnityPlayer.dll", 0x1783610;                     		        //0 if cutscene, varies if not
}

startup
{
    settings.Add("backpack", false, "Backpack route");
}

init
{
    if (settings["backpack"]) {version = "1.16.3";} else {version = "1.17.0";}

    vars.sOld = 0;
    vars.sNew = 0;
}

update
{
    if ((old.loadScreen == 2 && current.loadScreen != 2) || (old.bootScreen == 2 && current.bootScreen != 2)) {vars.sNew += 1;}
}

start
{
    if (Math.Abs(old.xPos + 1.031000137) < 0.001 &&
        Math.Abs(old.yPos + 1342.200000) < 0.050 &&
        Math.Abs(old.zPos - 5.091000557) < 0.001 &&
		   (Math.Abs(current.xPos + 1.031000137) >= 0.001 ||
            Math.Abs(current.yPos + 1342.200000) >= 0.050 ||
            Math.Abs(current.zPos - 5.091000557) >= 0.001)) {return true;}

}

split
{
    //List numbers here representing how many loading screens pass until each split happens
    
    if (settings["backpack"]) {
        if ((vars.sNew == 2  ||
             vars.sNew == 5  ||
             vars.sNew == 7 
             ) && (vars.sOld != vars.sNew)) {vars.sOld = vars.sNew; return true;} else {vars.sOld = vars.sNew;}
    } else {
        if ((vars.sNew == 5  ||
             vars.sNew == 7  ||
             vars.sNew == 8  ||
             vars.sNew == 18 ||
             vars.sNew == 21 ||
             vars.sNew == 22 ||
             vars.sNew == 26 ||
             vars.sNew == 27
             ) && (vars.sOld != vars.sNew)) {vars.sOld = vars.sNew; return true;} else {vars.sOld = vars.sNew;}
    }
    if (old.gameState == 2 && current.gameState == 0) {return true;}
}

isLoading
{
	return (current.loadScreen == 3 || current.loadScreen == 4 ||
		current.bootScreen == 3 || current.bootScreen == 4 ||
		current.miscLoadA == 4 || current.miscLoadB == 4);
}

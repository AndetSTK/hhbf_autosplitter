state("Happy's Humble Burger Farm")
{
	int loadScreen : "UnityPlayer.dll", 0x17DEA88, 0x1420, 0xBF8, 0x78, 0xA0;         //3 or 4 if loading, 2 if not
	int bootScreen : "UnityPlayer.dll", 0x17DEA88, 0x1420, 0x3E28, 0x78, 0xA0;        //3 or 4 if loading, 2 if not
	float posA : "UnityPlayer.dll", 0x17DEA80, 0x0, 0xAA230, 0x68, 0x30;              //starts at -1.031000137 (after training)
	float posB : "UnityPlayer.dll", 0x17DEA80, 0x0, 0xAA230, 0x68, 0x34;              //starts at -1340.224365 (after training)
	float posC : "UnityPlayer.dll", 0x17DEA80, 0x0, 0xAA230, 0x68, 0x38;              //starts at 5.091000557 (after training)
	
	int loadScreen_BP : "UnityPlayer.dll", 0x17DEA88, 0x1420, 0xFD48, 0x78, 0x780;    //3 or 4 if loading, 2 if not (Backpack version)
	int bootScreen_BP : "UnityPlayer.dll", 0x17DEA88, 0x1420, 0x8CD8, 0x78, 0x0;      //3 or 4 if loading, 2 if not (Backpack version)
	float posA_BP : "UnityPlayer.dll", 0x17DEA80, 0x0, 0x296F8, 0x238, 0x30;          //starts at -1.031000137 (after training)
	float posB_BP : "UnityPlayer.dll", 0x17DEA80, 0x0, 0x296F8, 0x238, 0x34;          //starts at -1340.224365 (after training)
	float posC_BP : "UnityPlayer.dll", 0x17DEA80, 0x0, 0x296F8, 0x238, 0x38;          //starts at 5.091000557 (after training)
	
	int miscLoadA : "UnityPlayer.dll", 0x1821B70, 0x24;                               //4 if loading, 1 if not
	int miscLoadB : "UnityPlayer.dll", 0x17DEA80, 0x0, 0xCA90, 0x78, 0x690;			  //4 if loading, 3 if not
	int scene : "UnityPlayer.dll", 0x1783610;                     					  //0 if cutscene, depends on scene if not

}

startup
{
	settings.Add("backpack", false, "Backpack version");
}

init
{
	vars.sOld = 0;
	vars.sNew = 0;
}

start
{
	if (settings["backpack"]) {
		if (Math.Abs(old.posA_BP + 1.031000137) < 0.001 &&
				Math.Abs(old.posB_BP + 1340.224365) < 0.001 &&
				Math.Abs(old.posC_BP - 5.091000557) < 0.001 &&
				(current.posA_BP != old.posA_BP || current.posB_BP > old.posB_BP || current.posC_BP != old.posC_BP) &&
				(timer.CurrentSplitIndex == -1)) {vars.sOld = 0; vars.sNew = 0; return true;}
	}
	else {
		if (Math.Abs(old.posA + 1.031000137) < 0.001 &&
				Math.Abs(old.posB + 1340.224365) < 0.001 &&
				Math.Abs(old.posC - 5.091000557) < 0.001 &&
				(current.posA != old.posA || current.posB > old.posB || current.posC != old.posC) &&
				(timer.CurrentSplitIndex == -1)) {vars.sOld = 0; vars.sNew = 0; return true;}

	}
}

update
{
	if (settings["backpack"]) {
		if ((old.loadScreen_BP == 2 && current.loadScreen_BP != 2) || (old.bootScreen_BP == 2 && current.bootScreen_BP != 2)) {vars.sNew += 1;}
	} else {
		if ((old.loadScreen == 2 && current.loadScreen != 2) || (old.bootScreen == 2 && current.bootScreen != 2)) {vars.sNew += 1;}
	}
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
	if (old.scene == 2 && current.scene == 0) {return true;}
}

isLoading
{
	if (settings["backpack"]) {
		return (current.loadScreen_BP == 3 ||
				current.loadScreen_BP == 4 ||
				current.bootScreen_BP == 3 ||
				current.bootScreen_BP == 4 ||
				current.miscLoadA == 4 ||
				current.miscLoadB == 4);
	} else {
		return (current.loadScreen == 3 ||
				current.loadScreen == 4 ||
				current.bootScreen == 3 ||
				current.bootScreen == 4 ||
				current.miscLoadA == 4 ||
				current.miscLoadB == 4);
	}
}
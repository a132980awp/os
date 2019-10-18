extern void getChar();
extern void cls();
extern void printChar();
extern void run();
extern void int33();
extern void int34();
extern void int35();
extern void int36();
extern void gettime();
extern void getdate();

extern void date();
extern void time();
extern void to_OUCH(); 
extern void picture();

char ch1,ch2,ch3,ch4;
int yy,mm,dd,hh,mmm,ss,t;

int count = 0;
char commands[100];
char input, pro;
int now = 0;

char tablist[10][100]={"ls","cls","map","help","int21","int33","quit","tab funtion test","",""};

int strlen(char *a);

void tab(int length){
	int i = 0;
	int j = 0;
	int is = 1;
	if(length == 0)
		return;
	for(i = 0;i < 8;i++){
		is = 1;
		if(length >= strlen(tablist[i])){
			is = 0;
			continue; 
		}
		for(j = 0;j < length;j++){
			if(commands[j] != tablist[i][j]){
				is = 0;
				break;
			}
		}	
		if(is == 1){
			for(j = 0;j < strlen(tablist[i]) - length;j++){
				commands[j+length] = tablist[i][j+length];
				printChar(tablist[i][j+length]);
				count = strlen(tablist[i]);
			}
			return;
		}
	}

}

void print(char *str) {
	while(*str != '\0') {
		printChar(*str);
		str++;
	}
}

void printInt(int ans){
	char output[100];
	char temp;
	int i = 0;
	if(ans == 0) {
		output[0] = '0';
		i++;
	}
	while(ans){
		int t = ans%10;
		output[i++] = '0'+t;
		ans/=10;
	}
	output[i] = '\0';
	for(i=0;i<strlen(output)/2;i++){
		temp = output[i];
		output[i] = output[strlen(output)-i-1];
		output[strlen(output)-i-1] = temp;
	}
	print(output);
}

int BCD_decode(int x){
	return x/16*10 + x%16;
}

void getline(char *ptr, int length) {
	int i = 0;
	for(i=0;i<100;i++)
		commands[i] = '\0';
	count = 0;
	if (length == 0) {
		return;
	}
	else {
		getChar();
		while (input != '\n' && input != '\r') {  
			if (input == '\b')
				{
					if (count > 0)
					{
						printChar(input);
						printChar(' ');
						printChar(input);
						ptr[--count] = 0;
					}
				}
			else if(input == '\t')
			{	
				tab(count);
			}
			
			else
			{
				printChar(input);
				ptr[count++] = input;
				if (count == length) {
					ptr[count] = '\0';
					print("\n\r");
					return;
				}
			}
			getChar();
		}
		ptr[count] = '\0';
		print("\n\r");
		return;
	}
}

int strcmp(char *str1, char *str2) {
	while ((*str1) && (*str2)) {
		if (*str1 != *str2) {
			if (*str1 < *str2) return -1;
			return 1;
		}
		++str1;
		++str2;
	}
	return (*str1) - (*str2);
}

int strlen(char *str) {
	int i = 0;
	while(*(str++)) i++;
	return i;
}

int substr(char *src, char *sstr, int pos, int len) {
	int i = pos;
	for (; i < pos + len; ++i) {
		sstr[i - pos] = src[i];
	}
	sstr[pos + len] = '\0';
	return 1;
}

void initial() {
	cls();
	print("Welcome to OS by Liao YongBin (~17341097~)!\n\r");
	print("To get help by enter: help\n\r");
	print("code completed by hit 'tab'\n\r");
	print("<int21> <int33> <int34> <int35> <int36> -- show the int\n\r");
	print("Have a try!\n\n\r");
	return;
}

void ls() {
	print("Program 1 -- size: 1KB, sector number: 5th\n\r");
	print("Program 2 -- size: 1KB, sector number: 6th\n\r");
	print("Program 3 -- size: 1KB, sector number: 7th\n\r");
	print("Program 4 -- size: 1KB, sector number: 8th\n\r");
	print("Program 5 -- size: 1KB, sector number: 9th\n\n\r");
}

void map() {
	print("\n                  Disk Explorer                     \n\n\r");
	print("-------------------------------------------------------------\n\r");
	print(":         :        :         :          :          :        :\n\r");
	print(":    1    :  2-10  :    11   :    12    :    13    :   ...  :\n\r");
	print(":         :        :         :          :          :        :\n\r");
	print(":-----------------------------------------------------------:\n\r");
	print(":         :        :         :          :          :        :\n\r");
	print(": lording :  MyOS  :  Prog1  :  Prog2   :   Prog3  :   ...  :\n\r");
	print(":         :        :         :          :          :        :\n\r");
	print("-------------------------------------------------------------\n\r");
}

void help() {
	print("A list of all supported commands:\n\r");
	print("<cls> -- clean the screen\n\r");
	print("<ls> -- show the information of programs\n\r");
	print("<r> -- run user programs like r 1\n\r");
	print("<q> -- quit user program\n\r");
	print("<map> -- show the information about the prog.\n\r");
	print("<help> -- show all the supported shell commands\n\r");
	print("<int21> <int33> <int34> <int35> <int36> -- show the int\n\n\r");
}

void runprogram(char *comm) {
	int i;
	int flag = 0;
	for (i = 1; i < strlen(comm); ++i) {
		if (comm[i] == ' ') continue;
		else if (comm[i] >= '1' && comm[i] <= '4') {
			pro = comm[i] - '0' + 2;
			if(flag == now){
				now++;
				print("now the program : ");
				printChar(pro);
				run();
			}
			else{
				flag ++;
				continue;
			}
			return;
		}
		else {
			print("invalid program number: ");
			printChar(comm[i]);
			print("\n\n\r");
			return;
		}
	}
	now = 0;
	return;
}

/*·þÎñ³ÌÐò*/
to_upper(char *p)
{
	while(*p != '\0')
	{
		if(*p >= 'a' && *p <= 'z')
		{
			*p = *p - 32;
		}
		p++;
	}
}
void to_time(){
	print("The time is: ");
	gettime();
	hh = BCD_decode(ch1);
	if(hh == 0) print("00");
	else if(hh >0 && hh < 10) printChar('0');
	printInt(hh);
	printChar(':');
	mmm = BCD_decode(ch2);
	if(mmm == 0) print("00");
	else if(mmm > 0 && mmm < 10) printChar('0');
	printInt(mmm);
	printChar(':');
	ss = BCD_decode(ch3);
	if(ss == 0) print("00");
	else if(ss > 0 && ss < 10) printChar('0');
	printInt(ss);
	print("\r\n\r\n");
}
void to_date(){
	print("The date is: ");
	getdate();
	yy = BCD_decode(ch1)*100 + BCD_decode(ch2);
	if(yy == 0) print("0000");
	else if(yy >0 && yy < 10) print("000");
	else if(yy > 10 && yy < 100) print("00");
	else if(yy > 100 && yy < 1000) print("0");
	printInt(yy);
	printChar('/');
	mm = BCD_decode(ch3);
	if(mm == 0) print("00");
	else if(mm > 0 && mm < 10) printChar('0');
	printInt(mm);
	printChar('/');
	dd = BCD_decode(ch4);
	if(dd == 0) print("00");
	else if(dd > 0 && dd < 10) printChar('0');
	printInt(dd);
	print("\r\n\r\n");
}
void to_picture(){	
	print("      ********** * ***********************************       \n\r");	
	print("      ********* *** **       **** ***17341097*********       \n\r");
	print("      ******** ***** ******** **** *******************       \n\r");
	print("      ******* *** *** **    ** **** ******************       \n\r");
	print("      ****** *** * *** **   *** **** *****************       \n\r");
	print("      ***** *** *** *** **  **** **** ****************       \n\r");
	print("      **** *** ***** *** ** ***** **** ***************       \n\r");
	print("      ***** *** *** *** **  **** ****** **************       \n\r");
	print("      ****** *** * *** **   *** ******** *************       \n\r");
	print("      ******* *** *** **    ** ********** ************       \n\r");	
	print("      ******** ***** ******** ************ ***********       \n\r");
	print("      ********* *** **       ************** **********       \n\r");
	print("      ********** * ************************* *********       \n\r");


}
void int21(){		
	cls();		
	print("\r\n         Now, you can run some funtion  to test the 21h:\n\n\r");
	print("        0.ouch  -- to ouch          1.upper -- change the letter to upper\n\r");
	print("        2.date  -- show the date    3.time -- show the time\n\r");
	print("        4.picture -- show a photo   10.quit -- just to quit\r\n\r\n"); 
	while(1){
		print("Please input your choice (the number):"); 
		getline(commands,20);		
	    if(strcmp(commands,"0")==0){
			to_OUCH();
			cls();
		}
		else if(strcmp(commands,"1")==0){
			while(1){
				print("\r\nPlease input a sentence or quit to back:");
				getline(commands,30);
				if(strcmp(commands,"quit")==0) break;
				upper(commands);
				print("\r\nThe upper case is:");
				print(commands);
				print("\r\n");
			}			
		}
		else if(strcmp(commands,"2")==0)date();
		else if(strcmp(commands,"3")==0)time();
		else if(strcmp(commands,"4")==0)picture();
		else if(strcmp(commands,"10")==0)break;	
	}
}

cmain() {		
	char tmp_char[10];	
	initial();
	while(1) {	
		while(now>0)
			runprogram(commands);
		print("root@MyOS:~#");
		getline(commands, 100);
		if (strcmp(commands, "help") == 0) help();
		else if (strcmp(commands, "cls") == 0) cls();
		else if (strcmp(commands, "ls") == 0) ls();
		else if (strcmp(commands, "map") == 0) map();
		else if (strcmp(commands, "int21") == 0) {int21();cls();}
		else if (strcmp(commands, "int33") == 0) {int33();cls();}
		else if (strcmp(commands, "int34") == 0) {int34();cls();}
		else if (strcmp(commands, "int35") == 0) {int35();cls();}
		else if (strcmp(commands, "int36") == 0) {int36();cls();}
		else {
			substr(commands, tmp_char, 0, 1);
			if (strcmp(tmp_char, "r") == 0) {
				runprogram(commands);
			}
			else if (commands[0] == '\0') continue;
			else {
				print("Illegal command: "); 
				print(commands);
				print("\n\n\r");
			}
		}
	}
}

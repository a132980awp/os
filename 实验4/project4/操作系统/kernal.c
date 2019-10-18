extern void getChar();
extern void cls();
extern void printChar();
extern void run();
extern void int33();
extern void int34();
extern void int35();
extern void int36();

char commands[100];
char input, pro;
int now = 0;

void print(char *str) {
	while(*str != '\0') {
		printChar(*str);
		str++;
	}
}

void getline(char *ptr, int length) {
	int count = 0;
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
	print("<int33> <int34> <int35> <int36> -- show the int\n\r");
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
	print("<int33> <int34> <int35> <int36> -- show the int\n\n\r");
}

void runprogram(char *comm) {
	int i;
	int flag = 0;
	for (i = 1; i < strlen(comm); ++i) {
		if (comm[i] == ' ') continue;
		else if (comm[i] >= '1' && comm[i] <= '4') {
			pro = comm[i] - '0' + 10;
			if(flag == now){
				now++;
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

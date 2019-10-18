
extern void print();
extern void stackCopy();
extern void PCB_Restore();

typedef enum PCB_STATUS{PCB_NEW, PCB_READY, PCB_EXIT, PCB_RUNNING, PCB_BLOCKED} PCB_STATUS;
char commands[100];
int count;
typedef struct Register{
	int ss;
	int gs;
	int fs;
	int es;
	int ds;
	int di;
	int si;
	int sp;
	int bp;
	int bx;
	int dx;
	int cx;
	int ax;
	int ip;
	int cs;
	int flags;
} Register;

typedef struct PCB{
	Register regs;
	PCB_STATUS status;
	int ID;
	int FID;
} PCB;

PCB PCB_LIST[10];

PCB *current_process_PCB_ptr, *t_PCB, *sub_PCB;

int first_time;
int kernal_mode = 1;
int process_number = 1;
int current_seg = 0x2000;
int current_process_number = 0;

int sub_ss, f_ss, stack_size;
/*----tab²¹È«----------*/
/*
char tablist[10][100]={"ls","cls","map","help","int21","int33","quit","tab funtion test","amd yes","creat"};
int strlen(char *a);
void tab(int length){
	int i = 0;
	int j = 0;
	int is = 1;
	if(length == 0)
		return;
	for(i = 0;i < 10;i++){
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

}*/
/*tab²¹È«*/ 
PCB *get_current_process_PCB() {
	return &PCB_LIST[current_process_number];
}

void save_PCB(int ax, int bx, int cx, int dx, int sp, int bp, int si, int di, int ds, int es, int fs, int gs, int ss, int ip, int cs, int flags) {
	current_process_PCB_ptr = get_current_process_PCB();
	
	current_process_PCB_ptr->regs.ss = ss;
	current_process_PCB_ptr->regs.gs = gs;
	current_process_PCB_ptr->regs.fs = fs;
	current_process_PCB_ptr->regs.es = es;
	current_process_PCB_ptr->regs.ds = ds;
	current_process_PCB_ptr->regs.di = di;
	current_process_PCB_ptr->regs.si = si;
	current_process_PCB_ptr->regs.sp = sp;
	current_process_PCB_ptr->regs.bp = bp;
	current_process_PCB_ptr->regs.bx = bx;
	current_process_PCB_ptr->regs.dx = dx;
	current_process_PCB_ptr->regs.cx = cx;
	current_process_PCB_ptr->regs.ax = ax;
	current_process_PCB_ptr->regs.ip = ip;
	current_process_PCB_ptr->regs.cs = cs;
	current_process_PCB_ptr->regs.flags = flags;
}

void schedule() {
	int i, flag = 1;
	if (current_process_PCB_ptr->status == PCB_RUNNING)
		current_process_PCB_ptr->status = PCB_READY;
	for (i = 1; i < process_number; ++i) {
		if (PCB_LIST[i].status != PCB_BLOCKED && PCB_LIST[i].status != PCB_EXIT) {
			flag = 0;
			break;
		} 
	}
	if (flag) {
		current_process_number = 0;
		current_process_PCB_ptr = get_current_process_PCB();
		current_process_PCB_ptr->status = PCB_RUNNING;
		kernal_mode = 1;
		return;
	}
	do {
		current_process_number++;
		if (current_process_number >= process_number)
			current_process_number = 1;
	} while (PCB_LIST[current_process_number].status == PCB_BLOCKED || PCB_LIST[current_process_number].status == PCB_EXIT);
	current_process_PCB_ptr = get_current_process_PCB();
	if (current_process_PCB_ptr->status == PCB_NEW)
		first_time = 1;
	current_process_PCB_ptr->status = PCB_RUNNING;
	return;
}

void PCB_initial(PCB *ptr, int process_ID, int seg) {
	ptr->ID = process_ID;
	ptr->FID = 0;
	ptr->status = PCB_NEW;
	ptr->regs.gs = 0x0B800;
	ptr->regs.es = seg;
	ptr->regs.ds = seg;
	ptr->regs.fs = seg;
	ptr->regs.ss = seg;
	ptr->regs.cs = seg;
	ptr->regs.di = 0;
	ptr->regs.si = 0;
	ptr->regs.bp = 0;
	ptr->regs.sp = 0x0100 - 4;
	ptr->regs.bx = 0;
	ptr->regs.ax = 0;
	ptr->regs.cx = 0;
	ptr->regs.dx = 0;
	ptr->regs.ip = 0x0100;
	ptr->regs.flags = 512;
}

void create_new_PCB() {
	if (process_number > 10) return;
	PCB_initial(&PCB_LIST[process_number], process_number, current_seg);
	process_number++;
	current_seg += 0x1000;
}

int do_fork() {
	int sub_ID;
	print("kernal: forking\r\n");
	sub_ID = createSubPCB();
	if (sub_ID == -1) {
		current_process_PCB_ptr->regs.ax = -1;
		return -1;
	}
	sub_PCB = &PCB_LIST[sub_ID];
	current_process_PCB_ptr->regs.ax = sub_ID;
	sub_ss = sub_PCB->regs.ss;
	f_ss = current_process_PCB_ptr->regs.ss;
	stack_size = 0x100;
	stackCopy();
	PCB_Restore();
}

int createSubPCB() {
	if (process_number > 10) return -1;
	t_PCB = &PCB_LIST[process_number];
	t_PCB->ID = process_number;
	t_PCB->status = PCB_READY;
	t_PCB->FID = current_process_number;
	t_PCB->regs.gs = 0xb800;
	t_PCB->regs.es = current_process_PCB_ptr->regs.es;
	t_PCB->regs.ds = current_process_PCB_ptr->regs.ds;
	t_PCB->regs.fs = current_process_PCB_ptr->regs.fs;
	t_PCB->regs.ss = current_seg;
	t_PCB->regs.di = current_process_PCB_ptr->regs.di;
	t_PCB->regs.si = current_process_PCB_ptr->regs.si;
	t_PCB->regs.bp = current_process_PCB_ptr->regs.bp;
	t_PCB->regs.sp = current_process_PCB_ptr->regs.sp;
	t_PCB->regs.ax = 0;
	t_PCB->regs.bx = current_process_PCB_ptr->regs.bx;
	t_PCB->regs.cx = current_process_PCB_ptr->regs.cx;
	t_PCB->regs.dx = current_process_PCB_ptr->regs.dx;
	t_PCB->regs.ip = current_process_PCB_ptr->regs.ip;
	t_PCB->regs.cs = current_process_PCB_ptr->regs.cs;
	t_PCB->regs.flags = current_process_PCB_ptr->regs.flags;
	process_number++;
	current_seg += 0x1000;
	print("kernal: sub process created!\r\n");
	return process_number - 1;
}

void do_wait() {
	print("kernal: waiting...\r\n");
	current_process_PCB_ptr->status = PCB_BLOCKED;
	schedule();
	PCB_Restore();
}

void do_exit(int ss) {
	print("kernal: exiting\r\n");
	PCB_LIST[current_process_number].status = PCB_EXIT;
	PCB_LIST[current_process_PCB_ptr->FID].status = PCB_READY;
	PCB_LIST[current_process_PCB_ptr->FID].regs.ax = ss;
	current_seg -= 0x1000;
	process_number--;
	if (process_number == 1) 
		kernal_mode = 1;
	schedule();
	PCB_Restore();
}

void initial_PCB_settings() {
	process_number = 1;
	current_process_number = 0;
	current_seg = 0x2000;
}

/*
#define nrsemaphore 10
#define nrpcb 10
*/
typedef struct semaphoretype {
    int count;
    int blocked_pcb[10];
    int used, front, tail;
} semaphoretype;

semaphoretype semaphorequeue[10];

int semaGet(int value) {
    int i = 0;
    while (semaphorequeue[i].used == 1 && i < 10) { ++i; }
    if (i < 10) {
        semaphorequeue[i].used = 1;
        semaphorequeue[i].count = value;
        semaphorequeue[i].front = 0;
        semaphorequeue[i].tail = 0;
		PCB_LIST[current_process_number].regs.ax = i;
		PCB_Restore();
		return i;
    }
	else {
		PCB_LIST[current_process_number].regs.ax = -1;
		PCB_Restore();
		return -1;
	}
}

void semaFree(int s) {
	semaphorequeue[s].used = 0;
}

void semaBlock(int s) {
	PCB_LIST[current_process_number].status = PCB_BLOCKED;
	if ((semaphorequeue[s].tail + 1) % 10 == semaphorequeue[s].front) {
		print("kernal: too many blocked processes\r\n");
		return;
	}
	semaphorequeue[s].blocked_pcb[semaphorequeue[s].tail] = current_process_number;
	semaphorequeue[s].tail = (semaphorequeue[s].tail + 1) % 10;
}

void semaWakeUp(int s) {
	int t;
	if (semaphorequeue[s].tail == semaphorequeue[s].front) {
		print("No blocked process to wake up\r\n");
		return;
	}
	t = semaphorequeue[s].blocked_pcb[semaphorequeue[s].front];
	PCB_LIST[t].status = PCB_READY;
	semaphorequeue[s].front = (semaphorequeue[s].front + 1) % 10;
}

void semaP(int s) {
	semaphorequeue[s].count--;
	if (semaphorequeue[s].count < 0) {
		semaBlock(s);
		schedule();
	}
	PCB_Restore();
}

void semaV(int s) {
	semaphorequeue[s].count++;
	if (semaphorequeue[s].count <= 0) {
		semaWakeUp(s);
		schedule();
	}
	PCB_Restore();
}

void initsema() {
	int i;
	for (i = 0; i < 10; ++i) {
		semaphorequeue[i].used = 0;
		semaphorequeue[i].count = 0;
		semaphorequeue[i].front = 0;
		semaphorequeue[i].tail = 0;
	}
}

extern void getChar();
extern void cls();
extern void printChar();
extern void run_process();

char input, sector_number, sector_size;

void print(char *str) {
	while(*str != '\0') {
		printChar(*str);
		str++;
	}
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
			
				;
				/*  tab(count); tab²¹È«*/
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
	print("<r> -- run programs 1 like \"r 1\"\n\r");
	print("<t>    -- test Multi-process cooperation\n\r");
	print("Have a try!\n\n\r");
	return;
}

void ls() {
	print("User Program 1 -- size: 1KB, sector number: 11th\n\r");
	print("User Program 2 -- size: 1KB, sector number: 12th\n\r");
	print("User Program 3 -- size: 1KB, sector number: 13th\n\r");
	print("User Program 4 -- size: 1KB, sector number: 14th\n\r");
	print("Test Program -- size: 1KB, sector number: 15th\n\n\r");
}

void help() {
	print("A list of all supported commands:\n\r");
	print("<cls>  -- clean the screen\n\r");
	print("<ls>   -- show the information of programs\n\r");
	print("<t>    -- test Multi-process cooperation\n\r");
	print("<r>    -- run user programs like r 1234\n\r");
	print("<help> -- show all the supported shell commands\n\n\r");
}

void create_process(char *comm) {
	int i, sum = 0, flag = 0;
	for (i = 1; i < strlen(comm); ++i) {
		if (comm[i] == ' ' || comm[i] >= '1' && comm[i] <= '4') continue;
		else {
			print("invalid program number: ");
			printChar(comm[i]);
			print("\n\n\r");
			return;
		}
	}
	for (i = 1; i < strlen(comm); ++i) {
		if (comm[i] != ' ') flag = 1;
	}
	if (flag == 0) {
		print("invalid input\n\n\r");
		return;
	}
	for (i = 1; i < strlen(comm) && sum < 10; ++i) {
		if (comm[i] == ' ') continue;
		sum++;
		sector_number = comm[i] - '0' + 10;
		sector_size = 1;
		run_process();
	}
	PCB_initial(&PCB_LIST[0], 1, 0x1000);
	kernal_mode = 0;
}

void run_test() {
	sector_number = 15;
	sector_size = 2;
	run_process();
	kernal_mode = 0;
}

cmain() {
	initial_PCB_settings();
	initial();
	kernal_mode = 1;
	while(1) {
		print("root@MyOS:~#");
		getline(commands, 100);
		if (strcmp(commands, "help") == 0) help();
		else if (strcmp(commands, "cls") == 0) cls();
		else if (strcmp(commands, "ls") == 0) ls();
		else if (commands[0] == 'r') create_process(commands);
		else if (strcmp(commands, "t") == 0) run_test();
		else if (commands[0] == '\0') continue;
		else {
			print("Illegal command: ");
			print(commands);
			print("\n\n\r");
		}
	}
}

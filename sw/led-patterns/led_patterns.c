#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <signal.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

static bool keep_running = true;
void intHandler(int){
	keep_running = false;
}

void usage(){
	printf("\nled_patterns -p <pattern> <duration> <pattern> <duration> ...\n\n");
	printf("All patterns must be in hexidecimal. ex: 0x25 is pattern 00011001\n");
	printf("All durations must be given in milliseconds. ex: 5000 is a 5 second duration.\n");
	printf("Patterns or file name must be put after the flags.\n");
	printf("Flags:\n");
	printf("\t-h\t: for help\n");
	printf("\t-p\t: for pattern. The patterns will follow the flags in the format <pattern> <duration>.\n");
	printf("\t-f\t: for file. The file name will follow the flags. A file must be formatted <pattern> <duration> on each line.\n");
	printf("\t-v\t: for verbose. Prints out the pattern in binary followed by the duration.\n"); 
}

int main(int argc, char ** argv){
	struct sigaction act;
	act.sa_handler= intHandler;
	sigaction(SIGINT, &act, NULL);

	//Initialize flags
	bool f_read = false;
	bool p_read = false;
	bool v_flag = false;
	bool error = false;
	//Raise respective flags
	if(argc > 1){
		for(int i = 0; i < argc; i++){
			if(strcmp(argv[i], "-f") == 0 || strcmp(argv[i], "-F") == 0){
				f_read = true;
			}
			if(strcmp(argv[i], "-p") == 0 || strcmp(argv[i], "-P") == 0){
				p_read = true;
			}
			if(strcmp(argv[i], "-v") == 0 || strcmp(argv[i], "-V") == 0){
				v_flag = true;
			}
			if(strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "-H") == 0){
				usage();
				f_read = false;
				p_read = false;
				v_flag = false;
			}
		}
	}
	int argc_offset = (v_flag == true) ? 1 : 0;
	//Throw error if no arguments.	
	if(argc == 1){
		printf("Improper usage. Use -h flag for help.\n");
		usage();
	}
	//Throw error of -p and -f used
	if(f_read && p_read){
		printf("FLAG ERROR: -p and -f flags are mutually exclusive.\n");
		error = true;
	}
	//Throw an error if the wrong number of arguments for -f
	if(f_read && (argc > 3 + argc_offset || argc < 3 + argc_offset)){
		printf("ARGUMENT ERROR: You must only give a single file name <file> after the -f flag.\n");
		error = true;
	}
	//Throw error if -p and odd arguments
	if(p_read && ((argc % 2) != argc_offset)){
		printf("You must have the arguments in format <pattern> <time> following flags if -p flag is used.\n");
		error = true;
	}
	if(error){
		p_read = false;
		f_read = false;
		v_flag = false;
	}else{
		system("./devmem 0xff200008 1");
	}
	//Print out what they want for the v flag.
	if(v_flag){
		if(p_read){
			for(int i = 2 + argc_offset; i < argc; i+= 2){
				printf("LED pattern = ");
				char str_number[10];
				strncpy(str_number, argv[i]+(2), strlen(argv[i]));
				int num = atoi(str_number);
				for(int i = 0; i < 8; i++){
					if(num & 128 >> i){
						printf("%d", 1);
					}else{
						printf("%d", 0);
					}
				}
				printf(" Display time = %s msec\n", argv[i+1]);
			}
		}
		if(f_read){
			FILE *fptr;
			fptr = fopen(argv[3], "r");
			char file_line[100];
			while(fgets(file_line, 100, fptr)){
				printf("LED pattern = ");
				char *token = strtok(file_line, " ");
				char str_number[10];
				strncpy(str_number, token+(2), strlen(token));
				int num = atoi(str_number);
				for(int i = 0; i < 8; i++){
					if(num & 128 >> i){
						printf("%d", 1);
					}else{
						printf("%d", 0);
					}
				}
				token = strtok(NULL, "\n");
				printf(" Display time = %s msec\n", token);
			}
		}
			
	}
	//Do the actual patterns.
	if(p_read){
		while(keep_running){
			for(int i = 2 + argc_offset; i < argc; i+= 2){
				char pattern_command[100];
			        strcpy(pattern_command, "./devmem 0xff200004 ");
				strcat(pattern_command, argv[i]);
				system(pattern_command);
				printf("%s", pattern_command);
				sleep(atoi(argv[i+1]) / 1000);
			}
		}
	}
	if(f_read){
		FILE *fptr;
		while(keep_running){
			fptr = fopen(argv[3], "r");
			char file_line[1000];
			while(fgets(file_line, 1000, fptr)){
				char *token = strtok(file_line, " ");
				char pattern_command[100];
				strcpy(pattern_command, "./devmem 0xff200004 ");
				strcat(pattern_command, token);
				system(pattern_command);
				token = strtok(NULL, "\n");
				sleep(atoi(token) / 1000);
			}
		}
	}
	printf("\nExiting and returning LED patterns.\n");
	system("./devmem 0xff200008 0");
	return (error) ? 1 : 0;
}


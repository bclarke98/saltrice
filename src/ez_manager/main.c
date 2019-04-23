#include <stdio.h>
#include <unistd.h>
#include "ezarch.h"


int main(int argc, char* argv[]){
    int opt;
    CMDHANDLER cmdh = cmd_handler_init_default();

    while((opt = getopt(argc, argv, "")) != -1){

    }
    return 0;
}

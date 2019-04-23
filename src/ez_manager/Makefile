CC = gcc
CFLAGS = -c -g
MAIN = main.o
OBJ = $(MAIN) ezarch.o
DEPS =
LIBS =
EXE = ezarch
ARGS =


all: $(OBJ)
	$(CC) $(OBJ) -o $(EXE) $(LIBS)

%.o: %.cpp $(DEPS)
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(OBJ) $(EXE)

run:
	make all && ./$(EXE) $(ARGS)


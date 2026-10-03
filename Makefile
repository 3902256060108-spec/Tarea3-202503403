AS = aarch64-linux-gnu-as
LD = aarch64-linux-gnu-ld

SRC = src/main.s
OBJ = main.o
TARGET = main

all: $(TARGET)

$(OBJ): $(SRC)
	$(AS) -g -o $(OBJ) $(SRC)

$(TARGET): $(OBJ)
	$(LD) -o $(TARGET) $(OBJ)

run: $(TARGET)
	qemu-aarch64 ./$(TARGET)

clean:
	rm -f $(OBJ) $(TARGET)
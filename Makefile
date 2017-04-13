
CC=gcc

LIBCXL_DIR=/home/${USER}/pslse/libcxl
CXL_DIR=/home/${USER}/pslse/common

CFLAGS= -g -I${LIBCXL_DIR} -I${CXL_DIR} -I.
LFLAGS= -L${LIBCXL_DIR} -lm -lcxl -lpthread -lrt

SRCS=capi-vadd.c
OBJS=$(SRCS:.c=.o)
TARGET=capi-vadd

all: vadd

.PHONY: vadd
vadd: $(TARGET) 

.PHONY: run
run: all
	LD_LIBRARY_PATH=${LIBCXL_DIR} ${PWD}/${TARGET}

$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(LFLAGS) -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	@rm -rf $(TARGET) $(OBJS)


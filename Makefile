
CC=gcc

LIBCXL_DIR=/home/khill/pslse_src/pslse/libcxl

CFLAGS= -g -I${LIBCXL_DIR} -I.
LFLAGS= -L${LIBCXL_DIR} -lm -lcxl -lpthread -lrt

SRCS=capi-vadd.c
OBJS=$(SRCS:.c=.o)
TARGET=capi-vadd

all: vadd

.PHONY: vadd
vadd: $(TARGET) 

$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(LFLAGS) -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	@rm -rf $(TARGET) $(OBJS)


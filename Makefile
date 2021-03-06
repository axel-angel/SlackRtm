CPPFLAGS=-g -pthread 
LDFLAGS=-g -lpthread -lcurl

INC=-I./libwebsockets/build/lib/Headers -I./libwebsockets/lib -I./libwebsockets/build -I./include -I./libwebsockets/lib -I./libwebsockets
LIB=-L./libwebsockets/build/lib

BUILD_DIR = build/
SRC_DIR = cpp/
HEAD_DIR = include/
LIB_DIR = lib/
CC_OUT = -o $(BUILD_DIR)$(notdir $@)

OBJS = $(BUILD_DIR)CSlackRTM.o $(BUILD_DIR)CWebSocket.o $(BUILD_DIR)CSlackWS.o $(BUILD_DIR)CSlackWeb.o

.PHONY: clean examples

all: lib examples

lib: $(LIB_DIR)libslackrtm.a

$(BUILD_DIR)CWebSocket.o: $(SRC_DIR)CWebSocket.cpp $(HEAD_DIR)CWebSocket.h libwebsockets/lib/libwebsockets.a
	g++ $(CPPFLAGS) $(INC) -c $(SRC_DIR)CWebSocket.cpp  $(CC_OUT)

$(BUILD_DIR)CSlackWeb.o: $(SRC_DIR)CSlackWeb.cpp $(HEAD_DIR)CSlackWeb.h libwebsockets/lib/libwebsockets.a
	g++ $(CPPFLAGS) $(INC) -c $(SRC_DIR)CSlackWeb.cpp  $(CC_OUT)
	
$(BUILD_DIR)CSlackWS.o: $(SRC_DIR)CSlackWS.cpp $(HEAD_DIR)CSlackWS.h libwebsockets/lib/libwebsockets.a
	g++ $(CPPFLAGS) $(INC) -c $(SRC_DIR)CSlackWS.cpp  $(CC_OUT)

$(BUILD_DIR)CSlackRTM.o: $(SRC_DIR)CSlackRTM.cpp $(HEAD_DIR)CSlackRTM.h libwebsockets/lib/libwebsockets.a
	g++ $(INC) -Wall -c $(SRC_DIR)CSlackRTM.cpp $(CC_OUT)

$(LIB_DIR)slackrtm.a: $(OBJS)
	ar -cq $(LIB_DIR)slackrtm.a $(OBJS)

libwebsockets/lib/libwebsockets.a: 
	mkdir -p libwebsockets/build
	cd libwebsockets; cmake .; $(MAKE)
	
$(LIB_DIR)libslackrtm.a: $(LIB_DIR)slackrtm.a libwebsockets/lib/libwebsockets.a 
	cp ./libwebsockets/lib/libwebsockets.a $(LIB_DIR)libslackrtm.a
	ar r $(LIB_DIR)libslackrtm.a $(OBJS)

examples: $(LIB_DIR)libslackrtm.a
	cd examples/minimal ; $(MAKE)
	cd examples/mqtt ; $(MAKE)

install: examples
	cp examples/mqtt/SlackMqtt $(DESTDIR)/usr/bin

clean:
	rm -f build/*.o
	rm -f SlackRtmTest
	rm -f lib/*.a
	cd examples/minimal ; $(MAKE) clean
	cd examples/mqtt ; $(MAKE) clean

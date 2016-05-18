# Makefile to compile or check syntax of wrapper, and its tester class
CC=clang++

FRAMEWORKS=-framework Foundation
FRAMEWORKS+=-framework UIKit
FRAMEWORKS+=-framework SystemConfiguration
FRAMEWORKS+=-framework CoreMotion
FRAMEWORKS+=-framework CoreLocation
FRAMEWORKS+=-framework CoreGraphics
FRAMEWORKS+=-framework Security

LIBRARIES:= -lobjc ../pblib.a

SOURCE1=PlaybasisWrapper.mm
SOURCE2=PlaybasisWrapperTester.mm

LIBB=../
LIBINCLUDE=-I../ -I../ui -I../libs/Reachability/ -I../libs/KLCPopup/ -I../libs/MBProgressHUD/ -I../libs/RNCryptor/

CFLAGS1=$(LIBINCLUDE) -arch i386 -Wall -Werror -g -v -c $(SOURCE1) -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator9.3.sdk -std=c++11
CFLAGS2=$(LIBINCLUDE) -arch i386 -Wall -Werror -g -v -c $(SOURCE2) -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator9.3.sdk -std=c++11
LDFLAGS=$(LIBRARIES) $(FRAMEWORKS)
OUTNAME1=PlaybasisWrapper.o
OUTNAME2=PlaybasisWrapperTester.o
EXE=PlaybasisWrapperTester

OUT1=-o $(OUTNAME1)
OUT2=-o $(OUTNAME2)

all:
	$(CC) $(CFLAGS1) $(OUT1)
	$(CC) $(CFLAGS2) $(OUT2)
	#$(CC) $(CFLAGS2) $(LDFLAGS) $(OUT2)
	#$(CC) -arch i386 $(OUTNAME1) $(OUTNAME2) -o $(EXE)

syntax:
	$(CC) $(CFLAGS1) -fsyntax-only

clean:
	rm PlaybasisWrapper.o
	rm PlaybasisWrapperTester.o
	rm -rf PlaybasisWrapper.o.dSYM
	rm -rf PlaybasisWrapperTester.o.dSYM
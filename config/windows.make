PLATFORM_LIBS := -lm -lpcre -lportaudio

PLATFORM_CXXFLAGS :=
PLATFORM_LDFLAGS := --verbose -L/usr/local/lib

PLATFORM_DEFINES := -DTARGET_OS_WINDOWS -DEXT_BOOST
PLATFORM_CXX := g++
PLATFORM_LD := g++

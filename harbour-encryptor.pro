# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-encryptor

CONFIG += sailfishapp

SOURCES += src/harbour-encryptor.cpp

OTHER_FILES += qml/harbour-encryptor.qml \
    qml/cover/* \
    qml/pages/* \
    rpm/* \
    translations/*.ts \
    harbour/* \
    harbour-encryptor.desktop

QML_IMPORT_PATH = .
encryptor.files = harbour
encryptor.path = /usr/share/$${TARGET}
INSTALLS += encryptor

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-encryptor-de.ts

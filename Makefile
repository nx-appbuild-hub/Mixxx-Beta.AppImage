# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)


all: clean
	mkdir --parents $(PWD)/build/Boilerplate.AppDir/bin
	mkdir --parents $(PWD)/build/Boilerplate.AppDir/lib64
	mkdir --parents $(PWD)/build/Boilerplate.AppDir/share

	wget --output-document=$(PWD)/build/build.deb https://downloads.mixxx.org/builds/2.3/release/mixxx-2.3.0-beta-2.3-release-bionic-amd64-latest.deb
	dpkg -x $(PWD)/build/build.deb $(PWD)/build	
	
	wget --output-document=$(PWD)/build/build.deb http://archive.ubuntu.com/ubuntu/pool/main/p/protobuf/libprotobuf-lite10_3.0.0-9.1ubuntu1_amd64.deb
	dpkg -x $(PWD)/build/build.deb $(PWD)/build	

	cp -r --force $(PWD)/build/usr/bin/* 						$(PWD)/build/Boilerplate.AppDir/bin			| true
	cp -r --force $(PWD)/build/usr/lib/* 						$(PWD)/build/Boilerplate.AppDir/lib64 		| true	
	cp -r --force $(PWD)/build/usr/lib64/* 						$(PWD)/build/Boilerplate.AppDir/lib64 		| true
	cp -r --force $(PWD)/build/usr/share/* 						$(PWD)/build/Boilerplate.AppDir/share		| true

	apprepo --destination=$(PWD)/build appdir boilerplate libportaudio2 libportmidi0 libprotobuf-lite17 \
										libqt5x11extras5 libqt5opengl5 libqt5script5 libqt5svg5 libqt5gui5 libqt5scripttools5 libqt5sql5 libqt5xml5 libqt5concurrent5  \
										libqt5widgets5 libqt5gui5 libqt5dbus5 libqt5core5a libqt5network5 libqt5sql5-sqlite \
										libid3tag0 libmodplug1 libchromaprint1 librubberband2 liblilv-0-0 libserd-0-0 libsord-0-0 libsratom-0-0 libopusfile0 \
										libsqlite3-0 libxcb1 libpcre2-16-0 libicu66 libmad0 libhidapi-hidraw0 libhidapi-libusb0 librubberband2 libebur128-1

	echo "exec \$${APPDIR}/bin/mixxx --resourcePath \$${APPDIR}/share/mixxx \"\$${@}\"" >> $(PWD)/build/Boilerplate.AppDir/AppRun
							
	rm --force $(PWD)/build/Boilerplate.AppDir/*.desktop		| true
	rm --force $(PWD)/build/Boilerplate.AppDir/*.svg			| true
	rm --force $(PWD)/build/Boilerplate.AppDir/*.png			| true

	cp -r --force $(PWD)/AppDir/*.desktop	$(PWD)/build/Boilerplate.AppDir/	| true
	cp -r --force $(PWD)/AppDir/*.svg		$(PWD)/build/Boilerplate.AppDir/ 	| true
	cp -r --force $(PWD)/AppDir/*.png		$(PWD)/build/Boilerplate.AppDir/ 	| true

	export ARCH=x86_64 && bin/appimagetool.AppImage $(PWD)/build/Boilerplate.AppDir $(PWD)/Mixxx-Beta.AppImage
	chmod +x $(PWD)/Mixxx-Beta.AppImage

clean:
	rm -rf $(PWD)/build

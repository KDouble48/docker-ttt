FROM ubuntu:16.04

EXPOSE 27015/udp 27015/tcp

ENV STEAM_PATH="/home/steam" \
	SERVER_PATH="/home/steam/server" \
	GROUP_ID=10000 \
	USER_ID=10000 \
	DOCKER_USER=steam \
	\
	WORKSHOP_COLLECTION_ID= \
	INSTALL_CSS=false \
	INSTALL_HL2=false \
	INSTALL_HLDM=false \
	INSTALL_TF2=false \
	\
	CSS_PATH="/home/steam/addons/css" \
	HL2_PATH="/home/steam/addons/hl2" \
	HLDM_PATH="/home/steam/addons/hldm" \
	TF2_PATH="/home/steam/addons/tf2"
	
USER "$USER_ID:$GROUP_ID"

VOLUME "$SERVER_PATH"

ENTRYPOINT ["./home/entrypoint.sh"]
	
COPY ["entrypoint.sh", "installAndMountAddons.sh", "forceWorkshopDownload.sh", "/home/"]

# removed dep. lib32gcc1 libtcmalloc-minimal4:i386 gdb
RUN dpkg --add-architecture i386 && \
	apt-get update -y && \
	apt-get install -y wget tar gzip ca-certificates lib32stdc++6 lib32tinfo5 && \
	groupadd -g $GROUP_ID $DOCKER_USER && \
	useradd -d /home/steam/ -g $GROUP_ID -u $USER_ID -m $DOCKER_USER && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/entrypoint.sh && \
	chmod a=rx /home/entrypoint.sh && \
	chmod a=rx /home/installAndMountAddons.sh && \
	chmod a=rx /home/forceWorkshopDownload.sh && \
	ulimit -n 2048
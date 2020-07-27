docker run \
  --rm \
  -d \
  --name minidlna \
  -p 8200:8200 \
  -p 1900:1900/udp \
  geekduck/minidlna

#docker run -d --name minidlna \
  #--net=host \
  #-p 8200:8200 \
  #-p 1900:1900/udp \
  #-v <PATH_TO_MUSIC_DIR>:/opt/Music \
  #-v <PATH_TO_VIDEOS_DIR>:/opt/Videos \
  #-v <PATH_TO_PICUTRES_DIR>:/opt/Pictures \
  #geekduck/minidlna
ffmpeg -i $1 -c:v prores -profile:v 3 -pix_fmt yuv422p10le -c:a pcm_s16le -movflags +faststart $2.mov

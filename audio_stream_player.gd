extends AudioStreamPlayer


func _ready() -> void:
	play()

# 如果你想在其他地方切换音乐，可以用这个方法
func play_music(new_music: AudioStream) -> void:
	if stream == new_music:
		return # 如果正在放这首歌，就不重头播放了
	stream = new_music
	play()

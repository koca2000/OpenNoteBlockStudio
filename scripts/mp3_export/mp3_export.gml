function mp3_export() {
	// mp3_export()

	var fn, err, a, b;
	fn = string(get_save_filename_ext("MP3 files (*.mp3)|*.mp3", filename_new_ext(filename, "") + ".mp3", filename_path(filename), condstr(language != 1, "Export MP3", "导出MP3")))
	if (fn = "") return 0

	// Start
	err = audio_start(fn)
	if (err < 0) {
	    if (language != 1) message("There was an error when saving as MP3.\nError code: a" + string(err), "Error")
	    else message("导出MP3时发生错误。\n错误代码: a" + string(err), "错误")
	    return 0
	}

	// Add files
	with (obj_instrument) {
	    if (!loaded)
	        continue
	    buffer_save(sound_buffer, temp_file)
	    file_id = audio_file_add(temp_file)
	    if (file_id < 0) {
	        if (language != 1) message("There was an error when saving as MP3.\nError code: b" + string(err), "Error")
			else message("导出MP3时发生错误。\n错误代码: b" + string(err), "错误")
	        return 0
	    }
	}

	// Add sounds
	calculate_locked_layers()
	for (a = 0; a <= enda; a += 1) {
	    if (colamount[a] > 0) {
	        for (b = 0; b <= collast[a]; b += 1) {
	            if (song_exists[a, b] && (lockedlayer[b] = 0 || mp3_includelocked)) {
	                var ins = song_ins[a, b]; 
	                var key = song_key[a, b];
	                var vel = song_vel[a, b]; 
					var pit = song_pit[a, b];
	                if (ins.loaded) {
	                    err = audio_sound_add(ins.file_id,
	                                          a / tempo,
	                                          0.5 * power(1.06, (key + (ins.key + (pit/100) - 78 - 0.23))),
	                                          layervol[b] / 100 / 100 * vel)
	                    if (err < 0) {
	                        if (language != 1) message("There was an error when saving as MP3.\nError code: c" + string(err), "Error")
							else message("导出MP3时发生错误。\n错误代码: c" + string(err), "错误")
	                        return 0
	                    }
	                }
	            }
	        }
	    }
	}

	// Combine
	err = audio_combine()
	if (err < 0) {
	    if (language != 1) message("There was an error when saving as MP3.\nError code: d" + string(err), "Error")
	    else message("导出MP3时发生错误。\n错误代码: d" + string(err), "错误")
	    return 0
	}

	if (language != 1) {if (question("MP3 saved! Do you want to open it?", "MP3 Export")) open_url(fn)}
	else {if (question("MP3已保存！现在打开吗？", "导出MP3")) open_url(fn)}



}

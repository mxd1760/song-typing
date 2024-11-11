extends Node


func just_text_from_data(data):
	var out = ""
	for line in data:
		out += line[1]
		out += '\n'
	return out


func lyrics_from_lrc_file(filename):
	var out = []
	var file = FileAccess.open(filename,FileAccess.READ)
	var reading = true
	while reading:
		var line = file.get_line()
		if line == null or file.eof_reached():
			reading = false
			continue
		if not line.substr(1,2).is_valid_int():
			continue
		var time = line.substr(1,8)
		var min = time.substr(0,2)
		var sec = time.substr(3,2)
		var mill = time.substr(6)
		var timestamp = [min.to_int(),sec.to_int(),mill.to_int()]
		print(timestamp)
		var line_text = line.substr(10)
		print(line_text)
		out.append([timestamp,line_text])
	return out

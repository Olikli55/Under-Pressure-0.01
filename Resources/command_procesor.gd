class_name  CommandProcesor

extends Node
signal clear_signal
@onready var terminal: Terminal= $".."

func process_command(command:String) -> String:
	var words = command.split(".",false,0)
	
	print(words.size())
	var first_word = words[0].to_lower()
	var second_word = ""
	if words.size() > 1:
		second_word = words[1].to_lower()
	match first_word:
		"clear":
			return clear(second_word)
		"gn":
			return generator_switch(second_word)
		"st":
			return get_status(second_word)
		"dr":
			return lock_door(second_word)
		_:
			return "err command? -> %s" %first_word



func generator_switch(second_word: String) -> String:
	if second_word.is_empty():
		return "err blank"
	match second_word:
		"on":
			return "generator switched on"
		"off":
			return "generator switched off"
		_:
			return "err command? -> %s" % second_word

func clear(second_word:String) -> String:
	if second_word.is_empty():
		clear_signal.emit()
		return ""
	else:
		return "err command? -> %s" %second_word

func get_status(second_word:String) -> String:
	return "command to get status in work"
	#if second_word == "all":
		#for stat in submarine.list_of_stats:
			#terminal.command_proces_start("st."+stat)
		#return ""
	#if submarine.get_status(second_word) != null:
		#var st_max_val  = submarine.get_status(second_word)
		#var st_val = submarine.get_max_status(second_word)
		#var st_percentage = (st_max_val / st_val) * 100
		#var string:String = "<"
		#for i in range(19):
			#if i == 9 :
				#string += str(st_percentage,"%")
			#if i <= st_percentage/5:
				#string += "■"
			#else:
				#string += "▢"
		#string += ">"
		#string += "   "+str(st_max_val)+"/"+str(st_val)
		#return string
	#else:
		#return "err st? -> %s" %second_word	

func lock_door(second_word:String) -> String:
	if second_word == "unlock":
		return "unlocked"
	elif second_word == "lock":
		return "locked"
	return "err command? -> %s" %second_word 

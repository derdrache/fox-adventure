extends Node

func is_parent_switch(parent):	
	if parent is Switch || parent is treeStomp: return true
	else: return false

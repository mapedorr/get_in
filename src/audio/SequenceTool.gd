extends Node2D

var index_sound = -1
var select_sound
var canplay
var soundList

export var Volume = 0
export var Pitch = 0

export (bool) var RandomVolume
export (float) var minVolume
export (float) var maxVolume

export (bool) var RandomPitch
export (float) var minPitch
export (float) var maxPitch

func _ready():
	soundList = get_child_count()

func play():
	
	index_sound = index_sound + 1
	if index_sound == soundList:
		index_sound = 0
	select_sound = get_child(index_sound)
	select_sound.play()
	
	
func randomizeVol(Volume, minVolume, maxVolume):
	var ranVol = (rand_range( minVolume, (maxVolume+1)))
	select_sound.set_volume_db(Volume + ranVol)

func randomizePitch(_Pitch, minPitch, maxPitch):
		var ranPitch = (rand_range( minPitch + 1, (maxPitch+1)))
		if (_Pitch + ranPitch > 0):
			select_sound.set_pitch_scale(_Pitch + ranPitch)

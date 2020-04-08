
extends Reference

const Utils = preload('./Utils.gd')
const errors = preload('../assets/translations/errors.en.gd').messages


# @var  Reference
var _target

# @var  Utils.Type
var _type


# @param  Reference  target
func _init(target, type):
	self._target = target
	self._type = type


func getTarget():  # Reference
	return self._target


func getType():  # Utils.Type
	return self._type

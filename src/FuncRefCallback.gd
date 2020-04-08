
extends './AbstractCallback.gd'


# Ensure callback target exists
func ensure():  # boolean
	return self._target.is_valid()


# @param  Variant[]  argv
func call(argv = []):  # Variant
	# Ensure callback target still exists
	if !ensure():
		print(errors['qc.callback.call.ensure_failed'] % [ self._target ])
		return

	# Execute call
	if self._type == Utils.Type.VARIABLE:
		var value = null
		if argv.size():
			value = argv[0]

		self._target.set(self._name, value)
		return self._target.get(self._name)

	elif self._type == Utils.Type.METHOD:
		return self._target.callv(self._name, argv)
	
	print(errors['qc.callback.call.unknown_type'] % [ self._target, self._name ])

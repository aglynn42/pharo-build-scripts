
[

| info lines dict unimplemented sends unsent |

info := (((SmalltalkImage current getSystemAttribute: 3) ifNil: [FileDirectory default] ifNotNilDo: [:path | FileDirectory on: path]) forceNewFileNamed: 'info.txt').

Undeclared removeUnreferencedKeys.

info nextPutAll: 'Undeclared:'; cr.
info nextPutAll: Undeclared asString; cr; cr.

info nextPutAll: 'Undeclared sorted by name:'; cr.

dict := IdentityDictionary new.
Smalltalk allClassesAndTraits do: [:c |
	c localSelectors do: [:sel | 
		dict at: (c compiledMethodAt: sel) put: (c -> sel)].
	c isTrait ifFalse: [
		c class localSelectors do: [:sel | 
			dict at: (c class compiledMethodAt: sel) put: (c class -> sel)]]].

lines := SortedCollection new.

Undeclared associations do: [:assoc |
  info nextPutAll: assoc key; cr.
  [
  ((assoc pointersTo) select: [:ref | ref class = CompiledMethod]) do: [:cm |
     info nextPutAll: ' - ', (dict at: cm ifAbsent: ['method not found']) asString; cr.
     lines add: (dict at: cm) key asString, ' >> ', (dict at: cm) value asString, ' (', assoc key asString, ')'. ] 
  ] ifError: [info nextPutAll: '--error--'; cr.]].

info cr; nextPutAll: 'Undeclared sorted by class:'; cr.     
lines do: [:l | info nextPutAll: l asString; cr.].

info cr.

info nextPutAll: 'Obsolete:'; cr.
info nextPutAll: SystemNavigation default obsoleteClasses asString; cr; cr.

info nextPutAll: 'Unimplemented calls size:'; space.
info nextPutAll: SystemNavigation default allUnimplementedCalls size asString.
info cr; cr.
info nextPutAll: 'Unimplemented calls:'; cr; cr.
unimplemented := SystemNavigation default allUnimplementedCalls asSortedCollection.
sends := OrderedCollection new.
unimplemented do: [:call |
  | pos |
  pos := (call findString:  ' calls: ').
  ((call allButFirst: (pos + 7)) findTokens: ' ') do: [:send |
    sends add: (send asString, ' calledBy: ', (call first: pos))].
  info nextPutAll: call asString; cr.].
info cr.
sends asSortedCollection do: [:call |
  info nextPutAll: call asString; cr.].
  
unsent := SystemNavigation default allUnsentMessages.

info cr; nextPutAll: 'Unsent messages size: '; nextPutAll: unsent size asString; cr; cr.
info cr; nextPutAll: 'Unsent messages:'; cr.
unsent asSortedCollection do: [:message | info nextPutAll: message; cr. ].

info cr; nextPutAll: 'finished...'.

info close.

SmalltalkImage current snapshot: false andQuit: true.


] ifError: [:e |
	| rep |
	rep := FileStream forceNewFileNamed: 'PharoDebug.log'.
	rep nextPutAll: 'info.st'; cr.
	rep nextPutAll: 'Error:'; cr.
	rep nextPutAll: e asString; cr.
	rep nextPutAll: thisContext stack size asString.
	thisContext stack copy withIndexDo: [:stck :i |
		[rep nextPutAll: i asString; space; nextPutAll: stck asString; cr] ifError: []].
	rep close. 
	Smalltalk quitPrimitive] 
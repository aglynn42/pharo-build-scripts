[	

log := ((SmalltalkImage current getSystemAttribute: 3) ifNil: [FileDirectory default] ifNotNilDo: [:path | FileDirectory on: path]) forceNewFileNamed: 'info_loadGopher.txt'.

packagesDir := ((SmalltalkImage current getSystemAttribute: 4) ifNil: [FileDirectory default] ifNotNilDo: [:path | FileDirectory on: path]).

old := Undeclared copy.
oldCalls := SystemNavigation default allUnimplementedCalls.
lastCalls := oldCalls.

#(
  'Network-Kernel' 
  'Network-MIME' 
  'Network-UUID' 
  'Network-Url' 
  'Network-URI' 
  'Network-Protocols'
  'PackageInfo' 
  'System-FileRegistry' 
  'Monticello' 
  'MonticelloConfigurations' 
  'Zinc-HTTP' 
  'Zinc-Patch-HTTPSocket' 
  'Settings-Network'
  'Settings-Monticello'
  'Gofer-Core'
) do: [:package|
  log nextPutAll: 'loading ', package, '...'; cr.
  packagesDir readOnlyFileNamed: package, '.st' do: [:file | file fileInSilently ].
  log nextPutAll: package, ' loaded'; cr.
  log nextPutAll: 'New Undeclared:'; cr.
  log nextPutAll: (Undeclared copyWithoutAll: old) asString; cr.
  log nextPutAll: 'New unimplemented calls:'; cr.
  unimplemented := SystemNavigation default allUnimplementedCalls.
  log nextPutAll: (unimplemented copyWithoutAll: lastCalls) asString; cr.
  lastCalls := unimplemented.
  log nextPutAll: 'Unimplemented calls:'; cr.
  log nextPutAll: (unimplemented copyWithoutAll: oldCalls) asString; cr; cr.
].

"
(Smalltalk globals at: #Gofer) it
  squeaksource: 'Pharo';
  package: 'SUnit';
  load.
"

log close.

SmalltalkImage current snapshot: true andQuit: true.

] ifError: [:e |
	| rep |
	rep := FileStream forceNewFileNamed: 'PharoDebug.log'.
	rep nextPutAll: 'loadGofer.st'; cr.
	rep nextPutAll: 'Error:'; cr.
	rep nextPutAll: e asString; cr.
	rep nextPutAll: thisContext stack size asString; cr.
"	rep nextPutAll: ((thisContext stack copy at: 12) tempsAndValues ) asString; cr."
	thisContext stack copy withIndexDo: [:stck :i |
		[rep nextPutAll: i asString; space; nextPutAll: stck asString; cr] ifError: [:er | rep nextPutAll: er asString; cr]].
	rep close. 
	Smalltalk quitPrimitive.]
  
! 
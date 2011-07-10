
#(
  'SUnit'
  'CompilerTests' 
  'CollectionsTests'
) do: [:packageName |
  ((SmalltalkImage current getSystemAttribute: 3) ifNil: [FileDirectory default] ifNotNilDo: [:path | FileDirectory on: path]) forceNewFileNamed: (packageName, '.st') do: [:file |
    file nextPutAll: (ScriptLoader latestSource: packageName location: 'http://www.squeaksource.com/Pharo')]].

#(
  'HudsonBuildTools'
) do: [:packageName |
  ((SmalltalkImage current getSystemAttribute: 3) ifNil: [FileDirectory default] ifNotNilDo: [:path | FileDirectory on: path]) forceNewFileNamed: (packageName, '.st') do: [:file |
    file nextPutAll: (ScriptLoader latestSource: packageName location: 'http://source.lukas-renggli.ch/hudson')]].

!

SmalltalkImage current snapshot: false andQuit: true.
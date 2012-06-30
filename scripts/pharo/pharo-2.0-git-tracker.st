| color red green yellow 
  updateSelector commitMessage versionString fileTreeRepository gofer 
  mainRepos inboxRepos |

"============================================================================="
Author fullName: 'Mister Foo'.
"============================================================================="
"some helper blocks for error printing"
color := [:colorCode :text|
    FileStream stderr 
        "set the color"
        nextPut: Character escape; nextPut: $[; print: colorCode; nextPut: $m;
        nextPutAll: text; crlf;
        "reset the color"
        nextPut: Character escape; nextPutAll: '[0m'.
].

red := [:text| color value: 31 value: text ].
green := [:text| color value: 32 value: text ].
yellow := [:text| color value: 33 value: text ].
white := [:text| FileStream stderr nextPutAll: text; crlf ].

"============================================================================="

Deprecation  raiseWarning: false.

"keep track of the current mc packages ======================================="
yellow value:'Tracking the currently installed packages'.

mainRepos := MCRepositoryGroup default repositories detect: [ :repos|
	repos asString includesSubString: 'http://ss3.gemstone.com/ss/Pharo20'].
inboxRepos := MCRepositoryGroup default repositories detect: [ :repos|
	repos asString includesSubString: 'PharoInbox'].


packages := MCWorkingCopy allInstances 
    select: [ :wc|
        "remove the inbox from all working copies to speed up comitting"
        wc repositoryGroup removeRepository: inboxRepos.
	    "check if the package is in pharo core"
        wc repositoryGroup repositories anySatisfy: [ :r| r = mainRepos ]]
    thenCollect: [ :wc| wc package name ].

" load filetree =============================================================="
yellow value:'Installing FileTree'.
Gofer new
    url: 'http://ss3.gemstone.com/ss/FileTree';
    package: 'ConfigurationOfFileTree';
    load.
((Smalltalk at: #ConfigurationOfFileTree) project version: '1.0') load.

" create a new filetree repository ==========================================="
yellow value: 'Preparing commit'.
fileTreeRepository := MCFileTreeRepository new directory: FileDirectory default / 'pharo-core'.

" extra the commit message from the current version ========================="
versionString  := SystemVersion current highestUpdate asString.
updateSelector := ('update', versionString) asSymbol.
commitMessage  := ((ScriptLoader methodDict at: updateSelector) 
                    allLiterals select: [ :each| 
                        each isKindOf: ByteString ]) first.

"save all packages into the filetree repository ============================="
yellow value:'Comitting changes to ', fileTreeRepository directory asString.

mainRepos cacheAllFileNamesDuring: [
inboxRepos cacheAllFileNamesDuring: [
    gofer := Gofer new.
    packages do: [ :packageName| gofer package: packageName ].
    gofer repository: fileTreeRepository.
    gofer commit: commitMessage ]].

"output the current version number =========================================="
(FileStream forceNewFileNamed: 'version')
    nextPutAll: versionString;
    close.
"store the commit message in a separate file"
(FileStream forceNewFileNamed: versionString)
    lineEndConvention: #lf;
    nextPutAll: versionString; lf;
    nextPutAll: commitMessage; lf;
    close.

FileStream stdout
    nextPutAll: versionString.

" and we're done ============================================================"
Smalltalk snapshot: false andQuit: true.
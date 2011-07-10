
!ScriptLoader methodsFor: 'cleaning' stamp: 'PavelKrivanek 9/23/2010 10:30'!
cleanUpAfterMorphicInitialization
	"self new cleanUpForRelease"

	Author fullName: 'Mr.Cleaner'.
	DebuggerMethodMap withAllSubclassesDo: [ :each | each voidMapCache ].
"	self cleanUpPackageOrganizer.
	self cleanUpMethods.
"	DataStream initialize.
	GradientFillStyle initPixelRampCache.
	FreeTypeCache clearCurrent.
	ImageMorph classPool at: #DefaultForm put: (Form extent: 1 @ 1 depth: 1).
	Behavior flushObsoleteSubclasses.
	MethodChangeRecord allInstancesDo: [ :x | x noteNewMethod: nil ].
	World cleanseOtherworldlySteppers.
	Smalltalk organization removeEmptyCategories.
	Browser initialize.
	SystemBrowser removeObsolete.
	AppRegistry removeObsolete.
	FileServices removeObsolete.
	ActiveHand instVarNamed: #targetOffset put: 0@0.
	MCFileBasedRepository flushAllCaches.
	MCMethodDefinition shutDown. 
	MCDefinition clearInstances.
	Smalltalk globals
		at: #TTFontDescription
		ifPresent: [ :c | 
			c
				clearDefault;
				clearDescriptions ].
	ExternalDropHandler resetRegisteredHandlers.
	Undeclared removeUnreferencedKeys.
	Smalltalk globals flushClassNameCache.
	ScrollBar initializeImagesCache.
	FreeTypeFontProvider current initialize.
	NaturalLanguageTranslator classPool at: #AllKnownPhrases put: nil.
	FreeTypeFontProvider current initialize.
"	SystemNavigation default
		allObjectsDo: [ :each | 
			(each respondsTo: #releaseCachedState)
				ifTrue: [ each releaseCachedState ] ].
"	3 timesRepeat: [ 
		Smalltalk garbageCollect.
		Symbol compactSymbolTable ].
	HashedCollection rehashAll.
	
	"Remove empty categories, which are not in MC packages, because MC does
	not do this (this script does not make packages dirty)"
	Smalltalk organization removeEmptyCategories.
	Smalltalk
		allClassesAndTraitsDo: [ :class |
			[ :each |
				each
					removeEmptyCategories;
					sortCategories ]
						value: class organization;
						value: class class organization ].
"	PackageOrganizer default packages
		do: [ :each | each methods ifEmpty: [ PackageOrganizer default unregisterPackage: each ] ]
		displayingProgress: 'Cleaning Packages'.
"	Smalltalk organization sortCategories.
	ChangeSet removeChangeSetsNamedSuchThat: [ :each | true ].
	ChangeSet resetCurrentToNewUnnamedChangeSet.
	Smalltalk garbageCollect.
	Author reset! !



[
| accuny prj world |


"accuny := Compiler evaluate: (String fromByteArray: (Base64MimeConverter mimeDecodeToBytes: 
  (FileStream readOnlyFileNamed: (SmalltalkImage current getSystemAttribute: 3))) contents) unzipped.
"
accuny := Compiler evaluate: (FileStream readOnlyFileNamed: 'accuny.txt') contentsOfEntireFile.

TextConstants TextSharedInformation at: #DefaultTextStyle put: accuny.
TextConstants TextSharedInformation at: #Accuny put: accuny.
TextConstants TextSharedInformation at: #DefaultMultiStyle put: accuny.
TextConstants TextSharedInformation at: #DefaultFixedTextStyle put: accuny.

Smalltalk allClasses 
  select: [:class | class sharedPools includes: TextConstants]
  thenDo: [:class | class compileAll. class class compileAll].

CommnadLine initialize.

StrikeFontFixer initialize.
TextStyle initialize.

BalloonBezierSimulation initialize.
BalloonEngineConstants initialize.
BalloonEngine initialize.
Browser initialize.
CommandHistory initialize.
CornerRounder initialize.
CPUWatcher initialize.
Debugger initialize.
DigitalSignatureAlgorithm initialize.
DummySoundSystem initialize.
FileContentsBrowser initialize.
FileList initialize.
FixUnderscores initialize.
FreeTypeCacheConstants initialize.
FreeTypeCache initialize.
"FreeTypeFontProvider initialize."
FreeTypeSettings initialize.
FreeTypeSubPixelAntiAliasedGlyphRenderer initialize.
FT2Constants initialize.
FT2Handle initialize.
GIFReadWriter initialize.
HaloMorph initialize.
HandMorph initialize.
HostSystemMenus initialize.
ChangeList initialize.
ChangeSorter initialize.
CharacterScanner initialize.
ImageMorph initialize.
JPEGHuffmanTable initialize.
JPEGReadStream initialize.
JPEGReadWriter initialize.
LogicalFont initialize.
LongTestCase initialize.
MailAddressTokenizer initialize.
MailComposition initialize.
MczInstaller initialize.
MD5NonPrimitive initialize.
MenuItemMorph initialize.
MenuMorph initialize.
MidiPrimTester initialize.
Morph initialize.
MultiCharacterScanner initialize.
ParagraphEditor initialize.
PNGReadWriter initialize.
PrettyPrinting initialize.
ProcessBrowser initialize.
RealEstateAgent initialize.
RecentMessageSet initialize.
RxMatcher initialize.
RxParser initialize.
RxsPredicate initialize.
SARInstaller initialize.
ScriptLoader initialize.
ScrollBar initialize.
SecureHashAlgorithm initialize.
ServerDirectory initialize.
SHA1 initialize.
ShortIntegerArray initialize.
ShortRunArray initialize.
SimpleEditor initialize.
StandardToolSet initialize.
StrikeFontFixer initialize.
SystemProgressMorph initialize.
SystemWindow initialize.
TestCase initialize.
TextContainer initialize.
TextDiffBuilder initialize.
TextPrinter initialize.
ThemeIcons initialize.
ThumbnailMorph initialize.
TransferMorph initialize.
TTCFontDescription initialize.
TTCFont initialize.
TTCFontSet initialize.
TTFontDescription initialize.
TTFontReader initialize.
UITheme initialize.
VistaryThemeIcons initialize.
WorldState initialize.
ZnByteEncoder initialize.
ZnConstants initialize.
ZnMimeType initialize.
ZnNetworkingUtils initialize.
ZnServer initialize.
ZnSingleThreadedServer initialize.


Cursor initTarget.
Cursor initialize.

DataStream initialize.

BalloonMorph setBalloonColorTo: Color yellow.

prj := Project new.
Project classPool at: #CurrentProject put: prj.

world := PasteUpMorph new.

"prj instVarNamed: #world put: world."
world instVarNamed: #worldState put: WorldState new.

world world addHand: HandMorph new.
world activeHand.

Smalltalk at: #World put: world.
Smalltalk at: #ActiveWorld put: world.
Smalltalk at: #ActiveHand put: world activeHand.
Smalltalk at: #ActiveEvent put: nil.

world viewBox: Display boundingBox.
Sensor flushAllButDandDEvents.
world world handsDo: [:h | h initForEvents].
world borderWidth: 0.

Project spawnNewProcess.

SystemWindow noteTopWindowIn: world.

Display newDepth: 32.
world displayWorldSafely.

UIManager default: MorphicUIManager new.

world displayWorldSafely.

Project uiProcess resume.

MorphicTextEditor register: PluggableTextMorph.

"(Delay forSeconds: 5) wait."

HelpBrowser initialize.
"HostWindowProxy initialize."
LogoImageMorph initialize.
TaskbarMorph initialize.
TextEditor initialize.

"
Gofer it
  squeaksource: 'DejaVu';
  package: 'DejaVuBitmapFonts';
  load.
(Smalltalk globals at: #DejaVuHolder) installFull.
StandardFonts restoreDefaultFonts.
"

PharoTheme beCurrent.

TestRunnerBrowser register: TestRunner.

(world windowsSatisfying: [:w | w model canDiscardEdits]) do: [:w | w delete].

ScriptLoader new cleanUpAfterMorphicInitialization.

Display newDepth: 32.

(World instVarNamed: #worldState) canvas: nil.
SmalltalkEditor initialize.

FreeTypeFontProvider initialize.

SmalltalkImage current snapshot: true andQuit: false.
SmalltalkImage current snapshot: true andQuit: true.

UIManager default restoreDisplay.



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
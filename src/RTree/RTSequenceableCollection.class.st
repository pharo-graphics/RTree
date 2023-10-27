"
Internally uses an OrderedCollection/RSGroup to iterate over the shapes.
This is the reason why is a linear render tree or linear search
"
Class {
	#name : 'RTSequenceableCollection',
	#superclass : 'RTAbstractCollection',
	#instVars : [
		'entries'
	],
	#category : 'RTree-Collections',
	#package : 'RTree',
	#tag : 'Collections'
}

{ #category : 'adding' }
RTSequenceableCollection >> add: anRTEntry [
	entries add: anRTEntry
]

{ #category : 'enumerating' }
RTSequenceableCollection >> do: aBlock [
	entries do: aBlock
]

{ #category : 'finding/searching' }
RTSequenceableCollection >> entriesAtPoint: position [
	| result |
	result := OrderedCollection new.
	entries reverseDo: [ :entry |
		entry addEntriesIn: result position: position.
	].
	^ result
]

{ #category : 'finding/searching' }
RTSequenceableCollection >> entriesAtRectangle: aRectangle [
	^ entries select: [ :each | each encompassingRectangle intersects: aRectangle ]
]

{ #category : 'initialization' }
RTSequenceableCollection >> initialize [
	super initialize.
	entries := OrderedCollection new
]

{ #category : 'shapes - ordering' }
RTSequenceableCollection >> pushBack: anRTEntry [
	entries remove: anRTEntry; addFirst: anRTEntry
]

{ #category : 'shapes - ordering' }
RTSequenceableCollection >> pushFront: anRTEntry [
	entries remove: anRTEntry; add: anRTEntry
]

{ #category : 'removing' }
RTSequenceableCollection >> remove: anRTEntry ifAbsent: anExceptionBlock [
	entries remove: anRTEntry ifAbsent: anExceptionBlock
]

{ #category : 'update' }
RTSequenceableCollection >> updateEntry: anRTEntry [
	anRTEntry resetEncompassingRectangle
]

{ #category : 'update' }
RTSequenceableCollection >> updateEntry: anRTEntry before: anotherRTEntry [
	entries remove: anRTEntry; add: anRTEntry before: anotherRTEntry
]

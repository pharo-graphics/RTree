"
Internally uses an OrderedCollection/RSGroup to iterate over the shapes.
This is the reason why is a linear render tree or linear search
"
Class {
	#name : 'RTSequenceableCollection',
	#superclass : 'RTAbstractCollection',
	#instVars : [
		'group'
	],
	#category : 'RTree',
	#package : 'RTree'
}

{ #category : 'adding' }
RTSequenceableCollection >> add: newObject [
	group add: newObject
]

{ #category : 'adding' }
RTSequenceableCollection >> add: aShape before: otherShape [
	group remove: aShape; add: aShape before: otherShape
]

{ #category : 'enumerating' }
RTSequenceableCollection >> do: aBlock [
	group do: aBlock
]

{ #category : 'initialization' }
RTSequenceableCollection >> initialize [
	super initialize.
	group := OrderedCollection new
]

{ #category : 'shapes - ordering' }
RTSequenceableCollection >> pushBack: aShape [
	group remove: aShape; addFirst: aShape.
]

{ #category : 'shapes - ordering' }
RTSequenceableCollection >> pushFront: aShape [
	group remove: aShape; add: aShape
]

{ #category : 'removing' }
RTSequenceableCollection >> remove: oldObject ifAbsent: anExceptionBlock [
	group remove: oldObject ifAbsent: anExceptionBlock
]

{ #category : 'finding/searching' }
RTSequenceableCollection >> shapesAtPoint: position [
	| result |
	result := OrderedCollection new.
	group reverseDo: [ :shape |
		shape addShapesIn: result position: position.
	].
	^ result
]

{ #category : 'finding/searching' }
RTSequenceableCollection >> shapesAtRectangle: aRectangle [
	^ group select: [ :each | each encompassingRectangle intersects: aRectangle ]
]

{ #category : 'finding/searching' }
RTSequenceableCollection >> updateShape: aShape [
	aShape resetEncompassingRectangle
]

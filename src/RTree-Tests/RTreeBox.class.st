"
Dummy class for tests.
RTreeBox is similar to RSShape or BlElement,
RTreeBox is a graphic component with bounds or encompassing rectangle
The position of the RTreeBox is top left of its encompassing rectangle.
In roassal the position of Shapes is in the center of its encompassing rectangle.
"
Class {
	#name : 'RTreeBox',
	#superclass : 'Object',
	#traits : 'RTWithEncompassingRectangle',
	#classTraits : 'RTWithEncompassingRectangle classTrait',
	#instVars : [
		'model',
		'position',
		'extent',
		'rectangle',
		'parent',
		'children'
	],
	#category : 'RTree-Tests',
	#package : 'RTree-Tests'
}

{ #category : 'accessing' }
RTreeBox class >> model: anObject [
	^ self new
		model: anObject;
		yourself 
	
]

{ #category : 'adding' }
RTreeBox >> add: aRTreeBox [
	children ifNil: [ children := OrderedCollection new ].
	children add: aRTreeBox.
	aRTreeBox parent: self
]

{ #category : 'adding' }
RTreeBox >> addShapesIn: aCollection position: aPoint [
	(self encompassingRectangle containsPoint: aPoint)
		ifTrue: [ aCollection add: self ]
]

{ #category : 'accessing' }
RTreeBox >> encompassingRectangle [
	^ rectangle ifNil: [ rectangle:= position extent: extent ]
]

{ #category : 'accessing' }
RTreeBox >> extent: aPoint [
	extent := aPoint
]

{ #category : 'initialization' }
RTreeBox >> initialize [
	super initialize.
	position := extent := 0 asPoint
]

{ #category : 'accessing' }
RTreeBox >> model [

	^ model
]

{ #category : 'accessing' }
RTreeBox >> model: anObject [

	model := anObject
]

{ #category : 'accessing' }
RTreeBox >> parent [
	^ parent
]

{ #category : 'accessing' }
RTreeBox >> parent: aRTreeBox [
	parent := aRTreeBox
]

{ #category : 'accessing' }
RTreeBox >> position [
	^ position
]

{ #category : 'accessing' }
RTreeBox >> position: aPoint [
	position := aPoint
]

{ #category : 'rectangle' }
RTreeBox >> resetEncompassingRectangle [
	rectangle := nil
]

{ #category : 'accessing' }
RTreeBox >> size: aNumber [
	extent := aNumber asPoint
]

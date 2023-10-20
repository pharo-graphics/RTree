"
Dummy class for tests
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
		'rectangle'
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
RTreeBox >> position [
	^ position
]

{ #category : 'accessing' }
RTreeBox >> position: aPoint [
	position := aPoint
]

{ #category : 'adding' }
RTreeBox >> resetEncompassingRectangle [
	rectangle := nil
]

{ #category : 'accessing' }
RTreeBox >> size: aNumber [
	extent := aNumber asPoint
]

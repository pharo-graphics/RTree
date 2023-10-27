Class {
	#name : 'RTCollectionTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'entryCollection',
		'entryCollectionClass'
	],
	#category : 'RTree-Tests',
	#package : 'RTree-Tests'
}

{ #category : 'building suites' }
RTCollectionTest class >> testParameters [
	| m classesToConsider |
	m := ParametrizedTestMatrix new.
	classesToConsider := RTAbstractCollection subclasses.
	classesToConsider do: [ :cls |
		m addCase: { (#entryCollectionClass: -> cls) }
	].
	^ m
]

{ #category : 'accessing' }
RTCollectionTest >> entryCollection [
	^ entryCollection
]

{ #category : 'accessing' }
RTCollectionTest >> entryCollection: anObject [

	entryCollection := anObject
]

{ #category : 'accessing' }
RTCollectionTest >> entryCollectionClass [

	^ entryCollectionClass
]

{ #category : 'accessing' }
RTCollectionTest >> entryCollectionClass: anObject [
	entryCollectionClass := anObject
]

{ #category : 'running' }
RTCollectionTest >> setUp [
	super setUp.
	entryCollection := self entryCollectionClass new
]

{ #category : 'tests' }
RTCollectionTest >> testGetEntriesFromRectangle [

	| listOfEntries box1 box2 box3 |
	box1 := RTreeBox new
		        size: 20 asPoint;
		        position: -50 asPoint;
		        entryIndex: 1;
		        yourself.
	box2 := RTreeBox new
		        size: 20 asPoint;
		        position: 50 asPoint;
		        entryIndex: 2;
		        yourself.
	box3 := RTreeBox new
		        size: 20 asPoint;
		        entryIndex: 3;
		        yourself.
	entryCollection addAll: {
			box1.
			box2.
			box3 }.
	listOfEntries := entryCollection entriesAtRectangle:
		                (5 asPoint corner: 60 asPoint).
	self assert: listOfEntries asArray equals: {
			box2.
			box3 }
]

{ #category : 'tests' }
RTCollectionTest >> testGetEntriesFromRectangleInParent [

	| listOfEntries box composite |
	box := RTreeBox new
		       size: 20 asPoint;
		       yourself.
	composite := RTreeBox new
		             size: 100;
		             yourself.
	composite add: box.
	entryCollection add: composite.
	listOfEntries := entryCollection entriesAtRectangle:
		                (-5 asPoint corner: 5 asPoint).
	self assert: listOfEntries asArray equals: { composite }
]

{ #category : 'tests' }
RTCollectionTest >> testGetEntriesFromRectangleInParentWithChildOutside [

	| listOfShapes box composite |
	box := RTreeBox new
		size: 20 asPoint;
		position: 120 asPoint;
		yourself.
	composite := RTreeBox new
		size: 100;
		yourself.
	composite add: box.
	entryCollection add: composite.
	listOfShapes := entryCollection entriesAtRectangle:
		                (110 asPoint corner: 130 asPoint).
	self assert: listOfShapes asArray isEmpty
]

{ #category : 'tests' }
RTCollectionTest >> testGetEntryFromRectangle [

	| listOfEntries |
	entryCollection add: (RTreeBox new
			 size: 20 asPoint;
			 yourself).
	listOfEntries := entryCollection entriesAtRectangle:
		                (-5 asPoint corner: 5 asPoint).
	self assert: (listOfEntries includes: entryCollection anyOne)
]

{ #category : 'tests' }
RTCollectionTest >> testIncludes [
	| result |
	entryCollection addAll: { RTreeBox new size: 10. RTreeBox new position: 50@50; size: 10 asPoint}.
	self assert: entryCollection size equals: 2.
	result := entryCollection entriesAtPoint:  -100@ -100.
	self assert: result isEmpty.
	result := entryCollection entryAtPoint: -100@ -100 ifNone: [ nil ].
	self assert: result isNil
]

{ #category : 'tests' }
RTCollectionTest >> testIsEmpty [

	self assert: entryCollection isEmpty
]

{ #category : 'tests' }
RTCollectionTest >> testOneElement [

	entryCollection add: (RTreeBox new size: 10).
	self deny: entryCollection isEmpty
]

{ #category : 'tests' }
RTCollectionTest >> testSortResultArray [

	| shapes a b c d tree e |
	shapes := {
		          ((a := RTreeBox model: 'a') -> { 1. 1 }).
		          ((b := RTreeBox model: 'b') -> { 1. 2 }).
		          ((c := RTreeBox model: 'c') -> { 3. 1 }).
		          ((d := RTreeBox model: 'd') -> { 1. 4 }).
		          ((e := RTreeBox model: 'e') -> { 1. 4. 1 }) }.
	tree := RTreeCollection new.
	tree sortResultList: shapes.

	self assert: (shapes collect: #key) equals: {
			c.
			e.
			d.
			b.
			a }
]

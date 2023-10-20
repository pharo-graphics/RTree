Class {
	#name : 'RTCollectionTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'shapeCollection',
		'shapeCollectionClass'
	],
	#category : 'RTree-Tests',
	#package : 'RTree-Tests'
}

{ #category : 'building suites' }
RTCollectionTest class >> testParameters [
	| m classesToConsider |
	m := ParametrizedTestMatrix new.
	classesToConsider := RSShapeCollection subclasses.
	classesToConsider do: [ :cls |
		m addCase: { (#shapeCollectionClass: -> cls) }
	].
	^ m
]

{ #category : 'running' }
RTCollectionTest >> setUp [
	super setUp.
	shapeCollection := self shapeCollectionClass new
]

{ #category : 'accessing' }
RTCollectionTest >> shapeCollection [
	^ shapeCollection
]

{ #category : 'accessing' }
RTCollectionTest >> shapeCollection: anObject [

	shapeCollection := anObject
]

{ #category : 'accessing' }
RTCollectionTest >> shapeCollectionClass [

	^ shapeCollectionClass
]

{ #category : 'accessing' }
RTCollectionTest >> shapeCollectionClass: anObject [
	shapeCollectionClass := anObject
]

{ #category : 'tests' }
RTCollectionTest >> testGetShapeFromRectangle [

	| listOfShapes |
	shapeCollection add: (RSBox new
			 size: 20 asPoint;
			 yourself).
	listOfShapes := shapeCollection shapesAtRectangle:
		                (-5 asPoint corner: 5 asPoint).
	self assert: (listOfShapes includes: shapeCollection anyOne)
]

{ #category : 'tests' }
RTCollectionTest >> testGetShapesFromRectangle [

	| listOfShapes box1 box2 box3 |
	box1 := RSBox new
		        size: 20 asPoint;
		        position: -50 asPoint;
		        shapeIndex: 1;
		        yourself.
	box2 := RSBox new
		        size: 20 asPoint;
		        position: 50 asPoint;
		        shapeIndex: 2;
		        yourself.
	box3 := RSBox new
		        size: 20 asPoint;
		        shapeIndex: 3;
		        yourself.
	shapeCollection addAll: {
			box1.
			box2.
			box3 }.
	listOfShapes := shapeCollection shapesAtRectangle:
		                (5 asPoint corner: 45 asPoint).
	self assert: listOfShapes asArray equals: {
			box2.
			box3 }
]

{ #category : 'tests' }
RTCollectionTest >> testGetShapesFromRectangleInComposite [

	| listOfShapes box composite |
	box := RSBox new
		       size: 20 asPoint;
		       yourself.
	composite := RSComposite new
		             size: 100;
		             yourself.
	composite add: box.
	shapeCollection add: composite.
	listOfShapes := shapeCollection shapesAtRectangle:
		                (-5 asPoint corner: 5 asPoint).
	self assert: listOfShapes asArray equals: { composite }
]

{ #category : 'tests' }
RTCollectionTest >> testGetShapesFromRectangleInCompositeWithChildOutside [

	| listOfShapes box composite |
	box := RSBox new
		       size: 20 asPoint;
		       position: 80 asPoint;
		       yourself.
	composite := RSComposite new
		             size: 100;
		             yourself.
	composite add: box.
	shapeCollection add: composite.
	listOfShapes := shapeCollection shapesAtRectangle:
		                (85 asPoint corner: 95 asPoint).
	self assert: listOfShapes asArray isEmpty
]

{ #category : 'tests' }
RTCollectionTest >> testIncludes [
	| result |
	shapeCollection addAll: { RSBox new size: 10. RSBox new position: 50@50; size: 10 asPoint}.
	self assert: shapeCollection size equals: 2.
	result := shapeCollection shapesAtPoint:  -100@ -100.
	self assert: result isEmpty.
	result := shapeCollection shapeAtPoint: -100@ -100.
	self assert: result isNil
]

{ #category : 'tests' }
RTCollectionTest >> testIsEmpty [

	self assert: shapeCollection isEmpty
]

{ #category : 'tests' }
RTCollectionTest >> testOneElement [

	shapeCollection add: (RSBox new size: 10).
	self deny: shapeCollection isEmpty
]

{ #category : 'tests' }
RTCollectionTest >> testSortResultArray [

	| shapes a b c d tree e |
	shapes := { 
		          ((a := RSBox model: 'a') -> { 1. 1 }).
		          ((b := RSBox model: 'b') -> { 1. 2 }).
		          ((c := RSBox model: 'c') -> { 3. 1 }).
		          ((d := RSBox model: 'd') -> { 1. 4 }).
		          ((e := RSBox model: 'e') -> { 1. 4. 1 }) }.
	tree := RTreeCollection new.
	tree sortResultList: shapes.

	self assert: (shapes collect: #key) equals: { 
			c.
			e.
			d.
			b.
			a }
]

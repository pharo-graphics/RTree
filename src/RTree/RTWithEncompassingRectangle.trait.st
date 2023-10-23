"
I describe graphic elements with an ecompassing rectangle in its space
"
Trait {
	#name : 'RTWithEncompassingRectangle',
	#instVars : [
		'shapeIndex'
	],
	#category : 'RTree',
	#package : 'RTree'
}

{ #category : 'adding' }
RTWithEncompassingRectangle >> addShapesIn: aCollection position: aPoint [
	self explicitRequirement
]

{ #category : 'accessing' }
RTWithEncompassingRectangle >> encompassingRectangle [
	^ self explicitRequirement
]

{ #category : 'accessing - computed' }
RTWithEncompassingRectangle >> indexesFromRoot [
	"the first element is root element, second its root's children"
	| collection |
	collection := OrderedCollection new.
	self indexesFromRootIn: collection.
	^ collection
]

{ #category : 'accessing - computed' }
RTWithEncompassingRectangle >> indexesFromRootIn: aCollection [
	| aParent |
	aParent := self parent.
	aParent ifNil: [ ^ self ].

	aParent indexesFromRootIn: aCollection.
	aCollection add: self shapeIndex
]

{ #category : 'accessing' }
RTWithEncompassingRectangle >> parent [
	^ self explicitRequirement
]

{ #category : 'rectangle' }
RTWithEncompassingRectangle >> resetEncompassingRectangle [
	^ self explicitRequirement
]

{ #category : 'private' }
RTWithEncompassingRectangle >> shapeIndex [
	^ shapeIndex
]

{ #category : 'private' }
RTWithEncompassingRectangle >> shapeIndex: aNumber [
	shapeIndex := aNumber
]

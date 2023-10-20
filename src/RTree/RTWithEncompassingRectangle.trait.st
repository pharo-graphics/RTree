Trait {
	#name : 'RTWithEncompassingRectangle',
	#category : 'RTree',
	#package : 'RTree'
}

{ #category : 'adding' }
RTWithEncompassingRectangle >> addShapesIn: aCollection position: aPoint [
	self explicitRequirement
]

{ #category : 'adding' }
RTWithEncompassingRectangle >> encompassingRectangle [
	^ self explicitRequirement
]

{ #category : 'adding' }
RTWithEncompassingRectangle >> indexesFromRoot [
	"the first element is root element, second its root's children"
	| collection |
	collection := OrderedCollection new.
	self indexesFromRootIn: collection.
	^ collection
]

{ #category : 'adding' }
RTWithEncompassingRectangle >> indexesFromRootIn: aCollection [
	| aParent |
	aParent := self parent.
	aParent ifNil: [ ^ self ].

	aParent indexesFromRootIn: aCollection.
	aCollection add: self shapeIndex
]

{ #category : 'adding' }
RTWithEncompassingRectangle >> parent [
	^ self explicitRequirement
]

{ #category : 'adding' }
RTWithEncompassingRectangle >> resetEncompassingRectangle [
	^ self explicitRequirement
]

{ #category : 'adding' }
RTWithEncompassingRectangle >> shapeIndex [
	^ self explicitRequirement
]

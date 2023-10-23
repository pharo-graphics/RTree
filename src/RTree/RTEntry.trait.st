"
I describe graphic elements with an ecompassing rectangle in its space
"
Trait {
	#name : 'RTEntry',
	#instVars : [
		'entryIndex'
	],
	#category : 'RTree-Traits',
	#package : 'RTree',
	#tag : 'Traits'
}

{ #category : 'adding' }
RTEntry >> addEntriesIn: aCollection position: aPoint [
	self explicitRequirement
]

{ #category : 'accessing' }
RTEntry >> encompassingRectangle [
	^ self explicitRequirement
]

{ #category : 'private' }
RTEntry >> entryIndex [
	^ entryIndex
]

{ #category : 'private' }
RTEntry >> entryIndex: aNumber [
	entryIndex := aNumber
]

{ #category : 'accessing - computed' }
RTEntry >> indexesFromRoot [
	"the first element is root element, second its root's children"
	| collection |
	collection := OrderedCollection new.
	self indexesFromRootIn: collection.
	^ collection
]

{ #category : 'accessing - computed' }
RTEntry >> indexesFromRootIn: aCollection [
	| aParent |
	aParent := self parent.
	aParent ifNil: [ ^ self ].

	aParent indexesFromRootIn: aCollection.
	aCollection add: self entryIndex
]

{ #category : 'accessing' }
RTEntry >> parent [
	^ self explicitRequirement
]

{ #category : 'rectangle' }
RTEntry >> resetEncompassingRectangle [
	^ self explicitRequirement
]

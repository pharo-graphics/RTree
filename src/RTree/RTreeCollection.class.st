"
An R-tree for Roassal.

Rectangle tree for roassal is a collection that allows
- find shapes in a point
- find shapes in a rectangle
The time searching this elements should be close to log(n)

The tree is balanced, then it does not have the order for the elements. User should define an index `shapeIndex` to keed the order.

Use the inspector to visualize the RTree
"
Class {
	#name : 'RTreeCollection',
	#superclass : 'RTAbstractCollection',
	#instVars : [
		'root'
	],
	#category : 'RTree',
	#package : 'RTree'
}

{ #category : 'visiting' }
RTreeCollection >> accept: visitor [
	root accept: visitor
]

{ #category : 'adding' }
RTreeCollection >> add: newObject [
	root := root addChild: newObject.
	^ newObject
]

{ #category : 'adding' }
RTreeCollection >> add: aShape before: otherShape [
	"do nothing"
]

{ #category : 'private - removing' }
RTreeCollection >> balanceRemovedPath: path [
	"| times |
	times := 0.
	self haltIf: path last value contents model = 53."
	(1 to: path size -2) reverseDo: [ :index | | tree |
		tree := (path at: index) value.
		tree height: (tree left height max: tree right height)+1.
		tree isBalanced ifFalse: [ | toMove brother |
			"times := times + 1."
			tree left height < tree right height ifTrue: [
				toMove := tree left.
				brother := tree right.
			] ifFalse: [
				toMove := tree right.
				brother := tree left ].
			tree fromNode: brother.
			toMove do: [ :shape | tree addChild: shape ].
			"this means that when you remove a node,
			 in order to keed it balanced
			maybe you can move a lot of nodes"
		].
	].
	"(path last value contents model asString, ' - ', times asString, ' times') traceCr."
]

{ #category : 'enumerating' }
RTreeCollection >> do: aBlock [
	root do: aBlock
]

{ #category : 'accessing' }
RTreeCollection >> height [
	^ root height
]

{ #category : 'initialization' }
RTreeCollection >> initialize [
	super initialize.
	root := RTNilNode new
]

{ #category : 'testing' }
RTreeCollection >> isBalanced [
	^ root isBalanced
]

{ #category : 'testing' }
RTreeCollection >> isEmpty [
	^ root isEmpty
]

{ #category : 'testing' }
RTreeCollection >> isTotalBalanced [
	^ root isTotalBalanced
]

{ #category : 'shapes - ordering' }
RTreeCollection >> pushBack: aShape [
	"no need it shape contains its own order"
]

{ #category : 'shapes - ordering' }
RTreeCollection >> pushFront: aShape [
	"no need it aShape contains its own order with aShape shapeIndex"
]

{ #category : 'accessing' }
RTreeCollection >> rectangle [
	^ root rectangle
]

{ #category : 'removing' }
RTreeCollection >> remove: oldObject ifAbsent: anExceptionBlock [
	| path |
	path := root searchPath: oldObject.
	path ifEmpty: [ ^ anExceptionBlock value ].
	path size = 1 ifTrue: [
		root := RTNilNode new.
	] ifFalse: [
		self removeLastNodeInPath: path.
	].

	^ path last value contents
]

{ #category : 'private - removing' }
RTreeCollection >> removeLastNodeInPath: path [
	| last parent isRight brother |
	last := path last.
	parent := path nextToLast value.
	isRight := last key.
	last := last value.
	brother := isRight ifTrue: [ parent left ] ifFalse: [ parent right ].

	parent fromNode: brother.
	path size < 3 ifTrue: [ ^ self ].
	self balanceRemovedPath: path
]

{ #category : 'accessing' }
RTreeCollection >> root [
	^ root
]

{ #category : 'finding/searching' }
RTreeCollection >> shapesAtPoint: aPoint [

	| res |
	"very important to preserv the drawing order"
	res := OrderedCollection new.
	root nodesWithPoint: aPoint list: res.
	res := res collect: [ :s | s -> s indexesFromRoot ].

	self sortResultList: res.

	^ res collect: [ :assoc | assoc key ]
]

{ #category : 'finding/searching' }
RTreeCollection >> shapesAtRectangle: aRectangle [
	| res |
	res := OrderedCollection new.
	root nodesIntersetcsRectangle: aRectangle list: res.
	res sort: [:a :b | a shapeIndex < b shapeIndex ].
	^ res
]

{ #category : 'public' }
RTreeCollection >> shouldSwap: anAssociation and: anAssociation2 [ 
	
	| v1 v2 size|
	v1 := anAssociation value.
	v2 := anAssociation2 value.

	size := v1 size min: v2 size.
	1 to: size do: [ :i| |index1 index2|
		index1 := v1 at: i.
		index2 := v2 at: i.
		index1 = index2 ifFalse: [ 
			^ index1 > index2 ]
	].
	^ v1 size = v2 size 
		ifTrue: [ false ]
		ifFalse: [ v1 size > v2 size  ]

]

{ #category : 'public' }
RTreeCollection >> sortResultList: aCollection [

	aCollection sort: [ :a :b | 
		
		self shouldSwap: a and: b
		 ]
]

{ #category : 'finding/searching' }
RTreeCollection >> updateShape: aShape [

	self remove: aShape.
	aShape resetEncompassingRectangle.
	self add: aShape
]

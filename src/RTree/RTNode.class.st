"
RTree node
"
Class {
	#name : 'RTNode',
	#superclass : 'RTAbstractNode',
	#instVars : [
		'contents',
		'left',
		'right',
		'rectangle',
		'height'
	],
	#category : 'RTree',
	#package : 'RTree'
}

{ #category : 'instance creation' }
RTNode class >> new: anObject [
	^ self basicNew
		fromShape: anObject;
		yourself
]

{ #category : 'visiting' }
RTNode >> accept: visitor [
	visitor visitNode: self
]

{ #category : 'adding' }
RTNode >> add: anObject path: list [

	self isLeaf ifTrue: [
		left := self class new: self contents.
		right := self class new: anObject.
		height := 2.
		contents := nil.
	]ifFalse: [ | leastEnlargementChild |
		leastEnlargementChild := self leastEnlargementChild: anObject.
		list add: (right = leastEnlargementChild) -> leastEnlargementChild.
		leastEnlargementChild add: anObject path: list.
		height := (left height max: right height) + 1.
	].
	rectangle := Rectangle merging: {left rectangle. right rectangle}
]

{ #category : 'adding' }
RTNode >> addChild: newObject [
	| path |
	path := OrderedCollection with: self.
	self add: newObject path: path.
	self checkPath: path.
	^ self
]

{ #category : 'private' }
RTNode >> balanceZ: z y: y x: x [
	| a b c |
	c := z value.
	b := y value.
	a := x value.
	(y key and: [ x key ]) ifTrue: [
		^ self rrrotationZ: c y: b x: a ].
	(y key not and: [ x key not ]) ifTrue: [
		^ self llrotationZ: c y: b x: a ].
	(y key not and: [ x key ]) ifTrue: [
		^ self lrrotationZ: c y: b x: a ].
	"(y key and: [ x key not ])"
	^ self rlrotationZ: c y: b x: a.
	"self notYetImplemented."
]

{ #category : 'adding' }
RTNode >> bulkLoad: aCollection from: a to: b [
	"a and b are indeces, used to copy part of the boxes"
	b < a ifTrue: [ ^ self error: 'should not' ].
	a = b ifTrue: [
		contents := aCollection at: a.
		rectangle := contents encompassingRectangle.
	] ifFalse: [ | mid |
		rectangle := Rectangle merging: ((a to: b) collect: [:i |
			(aCollection at: i) encompassingRectangle ]).
		mid := (a+b/2) asInteger.
		left := self class new.
		left bulkLoad: aCollection from: a to: mid.
		right := self class new.
		right bulkLoad: aCollection from: mid + 1 to: b.
	]
]

{ #category : 'private' }
RTNode >> checkPath: aCollection [
	| recomputeHeight |
	aCollection size < 3 ifTrue: [ ^ self ].
	recomputeHeight := false.
	(1 to: aCollection size - 2) reverseDo: [ :index |
		| assoc |
		assoc := aCollection at: index.
		recomputeHeight ifTrue: [
			assoc value height: (assoc value left height max: assoc value right height)+1
		] ifFalse: [
			(assoc value isBalanced) ifFalse: [ | z y x |
				z := aCollection at: index.
				y := aCollection at: index + 1.
				x := aCollection at: index + 2.
				recomputeHeight := true.
				self balanceZ: z y: y x: x.
			]
		]
	].
	"recomputeHeight ifTrue: [ root computeHeight ]"
]

{ #category : 'accessing' }
RTNode >> children [
	^ {left. right} copyWithout: nil
]

{ #category : 'enumerating' }
RTNode >> childrenDo: aBlock [
	left ifNotNil: aBlock.
	right ifNotNil: aBlock
]

{ #category : 'enumerating' }
RTNode >> collect: aFullBlockClosure [
	| list |
	list := OrderedCollection new.
	self do: [ :each | list add: each ].
	^ list
]

{ #category : 'public' }
RTNode >> computeHeight [
	height := self isLeaf
		ifTrue: [ 1 ]
		ifFalse: [ (left computeHeight max: right computeHeight) + 1 ].
	^ height
]

{ #category : 'public' }
RTNode >> computeRectangle [
	rectangle := Rectangle merging: { left rectangle. right rectangle }.
	height := (left height max: right height) + 1
]

{ #category : 'accessing' }
RTNode >> contents [
	^ contents
]

{ #category : 'accessing' }
RTNode >> contents: aRSShape [
	contents := aRSShape
]

{ #category : 'enumerating' }
RTNode >> do: aBlock [
	self isLeaf
		ifTrue: [ aBlock value: self contents ]
		ifFalse: [
			self childrenDo: [ :child | child do: aBlock ].
			 ]
]

{ #category : 'initialization' }
RTNode >> fromNode: aNode [
	contents := aNode contents.
	left := aNode left.
	right := aNode right.
	rectangle := aNode rectangle.
	height := aNode height
]

{ #category : 'private' }
RTNode >> fromShape: aRSShape [
	contents := aRSShape.
	height := 1.
	rectangle := aRSShape encompassingRectangle
]

{ #category : 'accessing' }
RTNode >> height [
	^ height
]

{ #category : 'accessing' }
RTNode >> height: anInteger [
	height := anInteger
]

{ #category : 'inspector' }
RTNode >> inspectionTree: aBuilder [
    <inspectorPresentationOrder: 1 title: 'Tree Structure'>

    ^ aBuilder newTree
        roots: { self };
        children: [ :each | each children ];
        expandRoots;
        yourself
]

{ #category : 'testing' }
RTNode >> isBalanced [
	^ self isLeaf or: [ (left height - right height) abs <= 1  ]
]

{ #category : 'testing' }
RTNode >> isEmpty [
	^ false
]

{ #category : 'testing' }
RTNode >> isInvalid [
	^ self isLeaf and: [ self contents isNil ]
]

{ #category : 'testing' }
RTNode >> isLeaf [
	^ right isNil and: [ left isNil ]
]

{ #category : 'testing' }
RTNode >> isTotalBalanced [
	^ self isBalanced
		and: [ (left isNil or: [ left isTotalBalanced ])
			and: [ right isNil or: [ right isTotalBalanced ] ] ]
]

{ #category : 'private' }
RTNode >> leastEnlargementChild: anRSShape [
	| minRectangleEnlargement rect leftRect rightRect leftDiff rightDiff area1 area2 |
	minRectangleEnlargement := nil.
	rect := anRSShape encompassingRectangle.
	leftRect := Rectangle merging: {left rectangle. rect }.
	rightRect := Rectangle merging: {right rectangle. rect }.
	area1 := left rectangle area.
	area2 := right rectangle area.
	leftDiff := leftRect area - area1.
	rightDiff := rightRect area - area2.
	^ rightDiff = leftDiff
		ifTrue: [ area1 < area2
				ifTrue: [ left ]
				ifFalse: [ right ] ]
		ifFalse: [
			leftDiff < rightDiff
				ifTrue: [ left ]
				ifFalse: [ right ] ]
]

{ #category : 'accessing' }
RTNode >> left [
	^ left
]

{ #category : 'accessing' }
RTNode >> left: aRSRNode [
	left := aRSRNode
]

{ #category : 'private' }
RTNode >> llrotationZ: z y: y x: x [
	| a3 a4 new |
	a3 := y right.
	a4 := z right.

	new := self class new.
	new left: a3; right: a4; computeRectangle.
	z left: x; right: new; computeRectangle
]

{ #category : 'private' }
RTNode >> lrrotationZ: z y: y x: x [
	| a1 a2 a3 new |
	a1 := y left.
	a2 := x left.
	a3 := x right.
	new := self class new.
	new left: a1; right: a2; computeRectangle.
	y left: new; right: a3; computeRectangle.

	self llrotationZ: z y: y x: new
]

{ #category : 'finding/searching' }
RTNode >> nodesIntersetcsRectangle: aRectangle list: aCollection [
	(self rectangle intersects: aRectangle) ifFalse: [ ^ self ].
	self isLeaf ifTrue: [ aCollection add: self contents ]
	ifFalse: [
		self childrenDo: [ :child |
			child nodesIntersetcsRectangle: aRectangle list: aCollection
			 ] ]
]

{ #category : 'finding/searching' }
RTNode >> nodesWithPoint: aPoint list: aCollection [
	(self rectangle containsPoint: aPoint)
		ifFalse: [ ^ self ].
	self isLeaf ifTrue:[
		self contents addShapesIn: aCollection position: aPoint
	] ifFalse: [
		self childrenDo: [ :child | child nodesWithPoint: aPoint list: aCollection ]
	]
]

{ #category : 'accessing' }
RTNode >> rectangle [
	^ rectangle
]

{ #category : 'accessing' }
RTNode >> rectangle: aRectangle [
	rectangle := aRectangle
]

{ #category : 'accessing' }
RTNode >> right [
	^ right
]

{ #category : 'accessing' }
RTNode >> right: aRSRNode [
	right := aRSRNode
]

{ #category : 'private' }
RTNode >> rlrotationZ: z y: y x: x [
	| a1 a2 a3 a4 new |
	a1 := z left.
	a2 := x left.
	a3 := x right.
	a4 := y right.
	new := self class new.
	new left: a3; right: a4; computeRectangle.
	y left: a2; right: new; computeRectangle.
	self rrrotationZ: z y: y x: new
]

{ #category : 'private' }
RTNode >> rrrotationZ: z y: y x: x [
	"right right rotation"
	| a1 a2 new |
	a1 := z left.
	a2 := y left.
	new := self class new.
	new left: a1; right: a2; computeRectangle.
	z left: new; right: x; computeRectangle
]

{ #category : 'finding/searching' }
RTNode >> searchPath: aRSShape [
	| path |
	path := OrderedCollection new.
	self searchPath: aRSShape rectangle: aRSShape encompassingRectangle in: path dir: nil.
	^ path
]

{ #category : 'finding/searching' }
RTNode >> searchPath: shape rectangle: shapeRect in: path dir: aBoolean [
	(self rectangle containsRect: shapeRect)
		ifFalse: [ ^ self ].
	self isLeaf ifTrue: [
		contents = shape ifTrue: [
			path addFirst: aBoolean -> self
		] ifFalse: [  ]
	] ifFalse: [
		left searchPath: shape rectangle: shapeRect in: path dir: false.
		path ifNotEmpty: [ path addFirst: aBoolean -> self. ^ self ].
		right searchPath: shape rectangle: shapeRect in: path dir: true.
		path ifNotEmpty: [ path addFirst: aBoolean -> self. ].
	 ]
]

{ #category : 'accessing - children' }
RTNode >> withAllChildren [
	| children |
	children := OrderedCollection new.
	self accept: (RTNodeVisitor on: [:node | children add: node ]).
	^ children
]

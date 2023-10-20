Class {
	#name : 'RSRTreeTest',
	#superclass : 'RSTest',
	#instVars : [
		'tree'
	],
	#category : 'RTree-Tests',
	#package : 'RTree-Tests'
}

{ #category : 'accessing' }
RSRTreeTest >> bigTree [
	^ self createTreeWith: 100
]

{ #category : 'accessing' }
RSRTreeTest >> createTreeWith: aNumber [
	| random |
	"do not modify this method"
	tree := self emptyTree.
	random := Random new.
	random seed: 1000.
	1 to: aNumber do: [ :each | | box |
		box := RSBox new.
		box size: 10.
		box model: each.
		box popup.
		box position: random next @ random next * 1000.
		tree add: box.
	].

	^ tree
]

{ #category : 'tests' }
RSRTreeTest >> emptyTree [
	^ RSRTreeShapeCollection new
]

{ #category : 'accessing' }
RSRTreeTest >> leafs [
	^ tree root withAllChildren select: [ :node | node isLeaf ]
]

{ #category : 'running' }
RSRTreeTest >> setUp [
	super setUp.

	tree := self emptyTree
]

{ #category : 'tests - adding' }
RSRTreeTest >> testAddNil [
	self should: [tree add: nil] raise: Error
]

{ #category : 'tests - adding' }
RSRTreeTest >> testAllChildren [
	| list |
	list := tree root withAllChildren.
	self assert: list isEmpty.

	tree add: RSBox new.
	list := tree root withAllChildren.
	self assert: list size equals: 1.
	self assert: (list allSatisfy: [:each | each class = RSRNode ]) .

	tree add: (RSBox new position: 10@10).
	list := tree root withAllChildren.
	self assert: list size equals: 3
]

{ #category : 'tests' }
RSRTreeTest >> testBalanced [
	1 to: 10 do: [ :each | | box |
		box := RSBox new.
		box size: 10.
		box position: each * 10 asPoint.
		tree add: box. ].
	self assert: tree notEmpty.
	self assert: tree size equals: 10.
	self assert: tree isBalanced
]

{ #category : 'tests' }
RSRTreeTest >> testContainsPointInRTree [
	| canvas collection box shape position |
	canvas := RSCanvas new.
	canvas useRTree.
	position := 1000 asPoint.
	box := RSBox new
		size: 100 asPoint;
		position: position;
		yourself.
	collection := canvas shapeCollection.
	canvas add: box.
	self assert: collection notEmpty.
	shape := canvas shapeWithActionForPosition: position.
	self assert: shape isNil.
	shape := collection shapeAtPoint: position.
	self assert: shape equals: box.
	box @ RSDraggable.
	shape := canvas shapeWithActionForPosition: position.
	self assert: shape equals: box
]

{ #category : 'tests' }
RSRTreeTest >> testHeight [
	| b1 b2 b3 b4 |
	b1 := RSBox new size: 10.
	b2 := RSBox new size: 30; position: 30@30.
	b3 := RSBox new size: 10; position: -10@ -10.
	b4 := RSBox new size: 10; position: 50@50.
	self assert: tree height equals: 0.
	tree add: b1.
	self assert: tree height equals: 1.
	tree add: b2.
	self assert: tree height equals: 2.
	tree add: b3.
	self assert: tree height equals: 3.
	tree add: b4.
	self assert: tree height equals: 3
]

{ #category : 'tests' }
RSRTreeTest >> testIsBalanced [
	| boxes |
	self assert: tree isBalanced.
	boxes := (1 to: 10) collect: [ :i | RSBox new size: 10. ].
	RSGridLayout on: boxes.
	self assert: (boxes allSatisfy: [:box |
		tree add: box.
		tree isBalanced ])
]

{ #category : 'tests - adding' }
RSRTreeTest >> testOneElement [
	self assert: tree isEmpty.
	tree add: (RSBox new size: 10).
	self deny: tree isEmpty.
	self assert: tree root contents class equals: RSBox.
	self assert: tree size equals: 1
]

{ #category : 'tests' }
RSRTreeTest >> testOneElementContains [
	| result |
	tree add: (RSBox new size: 10).

	result := tree shapesAtPoint: 0@0.
	self assert: result notEmpty.
	result := tree shapesAtRectangle: (0@0 corner: 100@100).
	self assert: result notEmpty
]

{ #category : 'tests' }
RSRTreeTest >> testOneElementRectangle [
	| box |
	box := RSBox new size: 10.
	tree add: box.
	self assert: tree rectangle equals: box encompassingRectangle
]

{ #category : 'tests - removing' }
RSRTreeTest >> testRemoveLeaf1 [
	| leafs size shapes shape |
	tree := self tree.

	size := tree size.
	leafs := self leafs.
	shapes := leafs collect: [ :each | each contents ] as: RSGroup.
	self assert: leafs notEmpty.
	self assert: tree isBalanced.
	shape := shapes shapeFromModel: 2.
	tree remove: shape.
	self assert: tree isBalanced.
	self assert: size - 1 equals: tree size.
	self assert: (tree shapesAtPoint: (shape position)) isEmpty.

	tree remove: (shapes shapeFromModel: 10).
	self assert: tree isBalanced.
	self assert: size - 2 equals: tree size
]

{ #category : 'tests - removing' }
RSRTreeTest >> testRemoveLeaf2 [
	| leafs shapes shape size |
	tree := self tree.
	size := tree size.
	leafs := self leafs.
	shapes := leafs collect: [ :each | each contents ] as: RSGroup.
	"use the inspector to visualize the node position in the tree"
	shape := shapes shapeFromModel: 1.
	tree remove: shape.

	self assert: tree isBalanced.
	self assert: tree size + 1  equals: size
]

{ #category : 'tests - removing' }
RSRTreeTest >> testRemoveLeaf3 [
	| leafs shapes random toRemove size |
	tree := self bigTree.
	size := tree size.
	leafs := self leafs.
	shapes := leafs collect: [ :each | each contents ] as: RSGroup.

	random := Random new.
	random seed: 444.
	shapes shuffleBy: random.
	toRemove := 1 to: (size / 2) asInteger do: [:index | | shape nodes heights newHeights |
		shape := shapes at: index.
		tree remove: shape.
		self assert: tree size + index equals: size.
		nodes := tree root withAllChildren.
		heights := nodes collect: [ :node | node height ].
		tree root computeHeight.
		newHeights := nodes collect: [ :node | node height ].
		heights with: newHeights do: [ :old :new |
			self assert: old equals: new. ].
		self assert: tree isBalanced.]
]

{ #category : 'tests - removing' }
RSRTreeTest >> testRemoveRootChildren [
	| box |
	tree addAll: { box := RSBox new size: 10. }.
	tree remove: box.
	self assert: tree isEmpty
]

{ #category : 'tests - removing' }
RSRTreeTest >> testRemoveZero [
	| value |
	value := false.
	tree remove: RSBox new ifAbsent: [ value := true ].
	self assert: value
]

{ #category : 'tests' }
RSRTreeTest >> testSearchPath1 [
	| path |
	tree := self emptyTree.
	path := tree root searchPath: (RSBox new).
	self assert: path isEmpty
]

{ #category : 'tests' }
RSRTreeTest >> testSearchPath2 [
	| path shape |
	tree := self emptyTree.
	tree add: (shape := RSBox new model: 1).
	path := tree root searchPath: shape.
	self assert: path asArray equals: { nil -> tree root }
]

{ #category : 'tests' }
RSRTreeTest >> testSearchPath3 [
	| nodes path shapes |
	tree := self tree.
	"tree inspect"
	nodes := self leafs.
	shapes := nodes collect: [ :node | node contents ] as: RSGroup.
	path := tree root searchPath: RSBox new.
	self assert: path isEmpty.
	path := tree root searchPath: (shapes shapeFromModel: 1).
	self assert: path size > 1.
	self assert: path asArray first equals: (nil -> tree root).
	path := tree root searchPath: (shapes shapeFromModel: 10).
	self assert: path size > 1.
	self assert: path asArray first equals: (nil -> tree root)
]

{ #category : 'tests' }
RSRTreeTest >> testSeriousBalance [
	| random canvas |
	random := Random new.
	random seed: 777.
	canvas := RSCanvas new.
	1 to: 100 do: [ :each | | box |
		box := RSBox new.
		box size: 10.
		box model: each.
		box popup.
		box position: (random next @ random next) * 1000.
		canvas add: box.

		tree add: box.
		self assert: tree height equals: tree root computeHeight.
		self assert: tree isTotalBalanced.
	]
]

{ #category : 'tests' }
RSRTreeTest >> testSortResultArray [

	| shapes a b c d e |
	shapes := { 
		          ((a := RSBox model: 'a') -> { 1. 1 }).
		          ((b := RSBox model: 'b') -> { 1. 2 }).
		          ((c := RSBox model: 'c') -> { 3. 1 }).
		          ((d := RSBox model: 'd') -> { 1. 4 }).
		          ((e := RSBox model: 'e') -> { 1. 4. 1 }) }.
	tree := RSRTreeShapeCollection new.
	tree sortResultList: shapes.

	self assert: (shapes collect: #key) equals: { 
			c.
			e.
			d.
			b.
			a }
]

{ #category : 'tests - adding' }
RSRTreeTest >> testThreeElements [
	| b1 b2 b3 |
	b1 := RSBox new size: 10.
	b2 := RSBox new size: 30; position: 30@30.
	b3 := RSBox new size: 10; position: -10@ -10.
	tree addAll: { b1. b2. b3 }.
	self assert: tree notEmpty.
	self assert: tree size equals: 3.
	self assert: tree root contents equals: nil.
	self assert: tree root left notNil.
	self assert: tree root right notNil
]

{ #category : 'tests' }
RSRTreeTest >> testThreeElementsContains [
	| b1 b2 b3 result |
	b1 := RSBox new size: 10; shapeIndex: 2.
	b2 := RSBox new size: 30; position: 30@30; shapeIndex: 1.
	b3 := RSBox new size: 10; position: -10@ -10; shapeIndex: 3.
	tree addAll: { b1. b2. b3 }.

	result := tree shapesAtPoint: 0@0.
	self assert: result first equals: b1.

	result := tree shapesAtPoint: 30@30.
	self assert: result first equals: b2.

	result := tree shapesAtPoint: -10@ -10.
	self assert: result first equals: b3.

	result := tree shapesAtRectangle: (0@0 corner: 10@10).
	self assert: result first equals: b1.

	result := tree shapesAtRectangle: (0@0 corner: 30@30).
	self assert: result size equals: 2.

	result := tree shapesAtRectangle: (-20@ -20 corner: 30@30).
	self assert: result size equals: 3.
	self assert: result asArray equals: { b2. b1. b3 }.
]

{ #category : 'tests - adding' }
RSRTreeTest >> testTwoElements [
	| b1 b2 |
	b1 := RSBox new size: 10.
	b2 := RSBox new size: 30; position: 30@30.
	tree addAll: { b1. b2 }.
	self assert: tree notEmpty.
	self assert: tree size equals: 2.
	self assert: tree root contents equals: nil.
	self assert: tree root left notNil.
	self assert: tree root right notNil
]

{ #category : 'tests' }
RSRTreeTest >> testTwoElementsContains [
	| b1 b2 result |
	b1 := RSBox new size: 10; shapeIndex: 1.
	b2 := RSBox new size: 30; position: 30@30; shapeIndex: 2.
	tree addAll: { b1. b2 }.
	result := tree shapesAtPoint: 0@0.
	self assert: result first equals: b1.

	result := tree shapesAtPoint: 30@30.
	self assert: result first equals: b2.

	result := tree shapesAtRectangle: (0@0 corner: 10@10).
	self assert: result first equals: b1.

	result := tree shapesAtRectangle: (0@0 corner: 30@30).
	self assert: result size equals: 2
]

{ #category : 'tests - adding' }
RSRTreeTest >> testTwoElementsRectangle [
	| b1 b2 group |
	b1 := RSBox new size: 10.
	b2 := RSBox new size: 30; position: 30@30.
	group := RSGroup new.
	group addAll: { b1. b2 }.
	tree addAll: group.
	self assert: tree rectangle equals: group encompassingRectangle
]

{ #category : 'tests' }
RSRTreeTest >> testUpdateExtentShouldUpdateTreeRectangle [
	| canvas collection box oldExtent newExtent |
	canvas := RSCanvas new.
	canvas useRTree.
	collection := canvas shapeCollection.
	oldExtent := 10@10.
	newExtent := 20@20.
	box := RSBox new.
	box extent: oldExtent.
	canvas add: box.
	
	self assert: collection root rectangle equals: box encompassingRectangle.
	box extent: newExtent.
	self assert: box encompassingRectangle extent equals: newExtent.
	self assert: collection root rectangle equals: box encompassingRectangle.
	
]

{ #category : 'tests' }
RSRTreeTest >> testZeroElement [
	self assert: tree isEmpty.
	self assert: tree root isNilNode.
	self assert: tree size equals: 0
]

{ #category : 'tests' }
RSRTreeTest >> testZeroElementContains [
	| result |
	result := tree shapesAtPoint: 0@0.
	self assert: result isEmpty.
	result := tree shapesAtRectangle: (0@0 corner: 100@100).
	self assert: result isEmpty
]

{ #category : 'tests' }
RSRTreeTest >> testZeroElementRectangle [
	self assert: tree rectangle equals: (0@0 corner: 0@0)
]

{ #category : 'accessing' }
RSRTreeTest >> tree [
	^ self createTreeWith: 10
]

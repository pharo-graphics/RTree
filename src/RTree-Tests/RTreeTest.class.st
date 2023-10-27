Class {
	#name : 'RTreeTest',
	#superclass : 'TestCase',
	#instVars : [
		'tree'
	],
	#category : 'RTree-Tests',
	#package : 'RTree-Tests'
}

{ #category : 'accessing' }
RTreeTest >> bigTree [
	^ self newTreeWith: 100
]

{ #category : 'tests' }
RTreeTest >> emptyTree [
	^ RTreeCollection new
]

{ #category : 'accessing' }
RTreeTest >> leafs [
	^ tree root withAllChildren select: [ :node | node isLeaf ]
]

{ #category : 'accessing' }
RTreeTest >> newTree [
	^ self newTreeWith: 10
]

{ #category : 'accessing' }
RTreeTest >> newTreeWith: aNumber [
	| random |
	"do not modify this method"
	tree := self emptyTree.
	random := Random new.
	random seed: 1000.
	1 to: aNumber do: [ :each | | box |
		box := RTreeBox new.
		box size: 10.
		box model: each.
		box position: random next @ random next * 1000.
		tree add: box.
	].

	^ tree
]

{ #category : 'running' }
RTreeTest >> setUp [
	super setUp.

	tree := self emptyTree
]

{ #category : 'tests - adding' }
RTreeTest >> testAddNil [
	self should: [tree add: nil] raise: Error
]

{ #category : 'tests - adding' }
RTreeTest >> testAllChildren [
	| list |
	list := tree root withAllChildren.
	self assert: list isEmpty.

	tree add: RTreeBox new.
	list := tree root withAllChildren.
	self assert: list size equals: 1.
	self assert: (list allSatisfy: [:each | each class = RTNode ]) .

	tree add: (RTreeBox new position: 10@10).
	list := tree root withAllChildren.
	self assert: list size equals: 3
]

{ #category : 'tests' }
RTreeTest >> testBalanced [
	1 to: 10 do: [ :each | | box |
		box := RTreeBox new.
		box size: 10.
		box position: each * 10 asPoint.
		tree add: box. ].
	self assert: tree notEmpty.
	self assert: tree size equals: 10.
	self assert: tree isBalanced
]

{ #category : 'tests' }
RTreeTest >> testHeight [
	| b1 b2 b3 b4 |
	b1 := RTreeBox new size: 10.
	b2 := RTreeBox new size: 30; position: 30@30.
	b3 := RTreeBox new size: 10; position: -10@ -10.
	b4 := RTreeBox new size: 10; position: 50@50.
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
RTreeTest >> testIsBalanced [
	| boxes size |
	self assert: tree isBalanced.
	boxes := (1 to: 10) collect: [ :i | RTreeBox new size: 10. ].
	size := boxes size.
	boxes doWithIndex: [ :box :index | box position: (index // size) @ (index % size) * 10  ].
	self assert: (boxes allSatisfy: [:box |
		tree add: box.
		tree isBalanced ])
]

{ #category : 'tests - adding' }
RTreeTest >> testOneElement [
	self assert: tree isEmpty.
	tree add: (RTreeBox new size: 10).
	self deny: tree isEmpty.
	self assert: tree root contents class equals: RTreeBox.
	self assert: tree size equals: 1
]

{ #category : 'tests' }
RTreeTest >> testOneElementContains [
	| result |
	tree add: (RTreeBox new size: 10).

	result := tree entriesAtPoint: 0@0.
	self assert: result notEmpty.
	result := tree entriesAtRectangle: (0@0 corner: 100@100).
	self assert: result notEmpty
]

{ #category : 'tests' }
RTreeTest >> testOneElementRectangle [
	| box |
	box := RTreeBox new size: 10.
	tree add: box.
	self assert: tree rectangle equals: box encompassingRectangle
]

{ #category : 'tests - removing' }
RTreeTest >> testRemoveLeaf1 [
	| leafs size shapes shape |
	tree := self newTree.

	size := tree size.
	leafs := self leafs.
	shapes := leafs collect: [ :each | each contents ].
	self assert: leafs notEmpty.
	self assert: tree isBalanced.
	shape := shapes detect: [ :s | s model = 2].
	tree remove: shape.
	self assert: tree isBalanced.
	self assert: size - 1 equals: tree size.
	self assert: (tree entriesAtPoint: (shape position)) isEmpty.

	tree remove: (shapes detect: [ :s | s model = 10]).
	self assert: tree isBalanced.
	self assert: size - 2 equals: tree size
]

{ #category : 'tests - removing' }
RTreeTest >> testRemoveLeaf2 [
	| leafs shapes shape size |
	tree := self newTree.
	size := tree size.
	leafs := self leafs.
	shapes := leafs collect: [ :each | each contents ].
	"use the inspector to visualize the node position in the tree"
	shape := shapes detect: [ :each | each model = 1 ].
	tree remove: shape.

	self assert: tree isBalanced.
	self assert: tree size + 1  equals: size
]

{ #category : 'tests - removing' }
RTreeTest >> testRemoveLeaf3 [
	| leafs shapes random toRemove size |
	tree := self bigTree.
	size := tree size.
	leafs := self leafs.
	shapes := leafs collect: [ :each | each contents ].

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
RTreeTest >> testRemoveRootChildren [
	| box |
	tree addAll: { box := RTreeBox new size: 10. }.
	tree remove: box.
	self assert: tree isEmpty
]

{ #category : 'tests - removing' }
RTreeTest >> testRemoveZero [
	| value |
	value := false.
	tree remove: RTreeBox new ifAbsent: [ value := true ].
	self assert: value
]

{ #category : 'tests' }
RTreeTest >> testSearchPath1 [
	| path |
	tree := self emptyTree.
	path := tree root searchPath: RTreeBox new.
	self assert: path isEmpty
]

{ #category : 'tests' }
RTreeTest >> testSearchPath2 [
	| path shape |
	tree := self emptyTree.
	tree add: (shape := RTreeBox new model: 1).
	path := tree root searchPath: shape.
	self assert: path asArray equals: { nil -> tree root }
]

{ #category : 'tests' }
RTreeTest >> testSearchPath3 [
	| nodes path shapes |
	tree := self newTree.
	"tree inspect"
	nodes := self leafs.
	shapes := nodes collect: [ :node | node contents ].
	path := tree root searchPath: RTreeBox new.
	self assert: path isEmpty.
	path := tree root searchPath: (shapes detect: [ :s | s model = 1]).
	self assert: path size > 1.
	self assert: path asArray first equals: (nil -> tree root).
	path := tree root searchPath: (shapes detect: [ :s | s model = 10]).
	self assert: path size > 1.
	self assert: path asArray first equals: (nil -> tree root)
]

{ #category : 'tests' }
RTreeTest >> testSortResultArray [

	| entries a b c d e |
	entries := {
		          ((a := RTreeBox model: 'a') -> { 1. 1 }).
		          ((b := RTreeBox model: 'b') -> { 1. 2 }).
		          ((c := RTreeBox model: 'c') -> { 3. 1 }).
		          ((d := RTreeBox model: 'd') -> { 1. 4 }).
		          ((e := RTreeBox model: 'e') -> { 1. 4. 1 }) }.
	tree := RTreeCollection new.
	tree sortResultList: entries.

	self assert: (entries collect: #key) equals: {
			c.
			e.
			d.
			b.
			a }
]

{ #category : 'tests - adding' }
RTreeTest >> testThreeElements [
	| b1 b2 b3 |
	b1 := RTreeBox new size: 10.
	b2 := RTreeBox new size: 30; position: 30@30.
	b3 := RTreeBox new size: 10; position: -10@ -10.
	tree addAll: { b1. b2. b3 }.
	self assert: tree notEmpty.
	self assert: tree size equals: 3.
	self assert: tree root contents equals: nil.
	self assert: tree root left notNil.
	self assert: tree root right notNil
]

{ #category : 'tests' }
RTreeTest >> testThreeElementsContains [
	| b1 b2 b3 result |
	b1 := RTreeBox new size: 10; entryIndex: 2.
	b2 := RTreeBox new size: 30; position: 30@30; entryIndex: 1.
	b3 := RTreeBox new size: 10; position: -10@ -10; entryIndex: 3.
	tree addAll: { b1. b2. b3 }.

	result := tree entriesAtPoint: 0@0.
	self assert: result first equals: b1.

	result := tree entriesAtPoint: 30@30.
	self assert: result first equals: b2.

	result := tree entriesAtPoint: -10@ -10.
	self assert: result first equals: b3.

	result := tree entriesAtRectangle: (0@0 corner: 10@10).
	self assert: result first equals: b1.

	result := tree entriesAtRectangle: (0@0 corner: 40@40).
	self assert: result size equals: 2.

	result := tree entriesAtRectangle: (-20@ -20 corner: 40@40).
	self assert: result size equals: 3.
	self assert: result asArray equals: { b2. b1. b3 }
]

{ #category : 'tests' }
RTreeTest >> testTotalBalance [
	| random |
	random := Random new.
	random seed: 777.
	1 to: 100 do: [ :each | | box |
		box := RTreeBox new.
		box size: 10.
		box model: each.
		box position: (random next @ random next) * 1000.

		tree add: box.
		self assert: tree height equals: tree root computeHeight.
		self assert: tree isTotalBalanced.
	]
]

{ #category : 'tests - adding' }
RTreeTest >> testTwoElements [
	| b1 b2 |
	b1 := RTreeBox new size: 10.
	b2 := RTreeBox new size: 30; position: 30@30.
	tree addAll: { b1. b2 }.
	self assert: tree notEmpty.
	self assert: tree size equals: 2.
	self assert: tree root contents equals: nil.
	self assert: tree root left notNil.
	self assert: tree root right notNil
]

{ #category : 'tests' }
RTreeTest >> testTwoElementsContains [
	| b1 b2 result |
	b1 := RTreeBox new size: 10; entryIndex: 1.
	b2 := RTreeBox new size: 30; position: 25@ 25; entryIndex: 2.

	tree addAll: { b1. b2 }.
	result := tree entriesAtPoint: 0@0.
	self assert: result first equals: b1.

	result := tree entriesAtPoint: 30@30.
	self assert: result first equals: b2.

	result := tree entriesAtRectangle: (0@0 corner: 10@10).
	self assert: result first equals: b1.

	result := tree entriesAtRectangle: (0@0 corner: 30@30).
	self assert: result size equals: 2
]

{ #category : 'tests - adding' }
RTreeTest >> testTwoElementsRectangle [
	| b1 b2 entries |
	b1 := RTreeBox new size: 10.
	b2 := RTreeBox new size: 30; position: 30@30.
	entries := OrderedCollection new.
	entries addAll: { b1. b2 }.
	tree addAll: entries.
	self assert: tree rectangle equals: (Rectangle merging: {b1 encompassingRectangle. b2 encompassingRectangle})
]

{ #category : 'tests' }
RTreeTest >> testUpdateExtentShouldUpdateTreeRectangle [
	| collection box oldExtent newExtent |
	collection := self emptyTree.
	oldExtent := 10@10.
	newExtent := 20@20.
	box := RTreeBox new.
	box extent: oldExtent.
	collection add: box.

	self assert: collection root rectangle equals: box encompassingRectangle.

	box extent: newExtent.
	collection updateEntry: box.

	self assert: box encompassingRectangle extent equals: newExtent.
	self assert: collection root rectangle equals: box encompassingRectangle
]

{ #category : 'tests' }
RTreeTest >> testZeroElement [
	self assert: tree isEmpty.
	self assert: tree root isNilNode.
	self assert: tree size equals: 0
]

{ #category : 'tests' }
RTreeTest >> testZeroElementContains [
	| result |
	result := tree entriesAtPoint: 0@0.
	self assert: result isEmpty.
	result := tree entriesAtRectangle: (0@0 corner: 100@100).
	self assert: result isEmpty
]

{ #category : 'tests' }
RTreeTest >> testZeroElementRectangle [
	self assert: tree rectangle equals: (0@0 corner: 0@0)
]

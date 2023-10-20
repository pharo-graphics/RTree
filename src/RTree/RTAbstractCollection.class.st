"
RSAbstractRenderTree defines 2 methods to search shapes.

- `shapeAtPoint:`
- `shapesAtRectangle:`
- `bulkload:` when user is going to change the `shapesCollection:` in canvas

subclasses of this tree should override also Collection abstract methods
"
Class {
	#name : 'RTAbstractCollection',
	#superclass : 'Collection',
	#category : 'RTree',
	#package : 'RTree'
}

{ #category : 'examples' }
RTAbstractCollection class >> exampleList [
	"in the inspector add and remove shapes"
	^ StInspectorPresenter openOn: RTSequenceableCollection new.
]

{ #category : 'examples' }
RTAbstractCollection class >> exampleRTree [
	"this has normal method collections with some new more"
	^ StInspectorPresenter openOn: RTreeCollection new.
]

{ #category : 'adding' }
RTAbstractCollection >> add: aShape before: otherShape [
	^ self subclassResponsibility
]

{ #category : 'adding' }
RTAbstractCollection >> bulkLoad: aCollectionOfShapes [
	self addAll: aCollectionOfShapes
]

{ #category : 'shapes - ordering' }
RTAbstractCollection >> pushBack: aShape [
	self subclassResponsibility
]

{ #category : 'shapes - ordering' }
RTAbstractCollection >> pushFront: aShape [
	self subclassResponsibility
]

{ #category : 'finding/searching' }
RTAbstractCollection >> shapeAtPoint: aPoint [
	| result |
	result := self shapesAtPoint: aPoint.
	result ifEmpty: [ ^ nil ].
	^ result anyOne
]

{ #category : 'finding/searching' }
RTAbstractCollection >> shapesAtPoint: position [

	^ self subclassResponsibility
]

{ #category : 'finding/searching' }
RTAbstractCollection >> shapesAtRectangle: aRectangle [
	^ self subclassResponsibility
]

{ #category : 'finding/searching' }
RTAbstractCollection >> updateShape: aShape [
	^ self subclassResponsibility
]

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
	#category : 'RTree-Collections',
	#package : 'RTree',
	#tag : 'Collections'
}

{ #category : 'examples' }
RTAbstractCollection class >> exampleList [
	"in the inspector add and remove shapes"
	^ StInspectorPresenter openOn: RTSequenceableCollection new
]

{ #category : 'examples' }
RTAbstractCollection class >> exampleRTree [
	"this has normal method collections with some new more"
	^ StInspectorPresenter openOn: RTreeCollection new
]

{ #category : 'adding' }
RTAbstractCollection >> bulkLoad: aCollectionOfRTEntry [
	self addAll: aCollectionOfRTEntry
]

{ #category : 'finding/searching' }
RTAbstractCollection >> entriesAtPoint: position [

	^ self subclassResponsibility
]

{ #category : 'finding/searching' }
RTAbstractCollection >> entriesAtRectangle: aRectangle [
	^ self subclassResponsibility
]

{ #category : 'finding/searching' }
RTAbstractCollection >> entryAtPoint: aPoint [
	^ self entryAtPoint: aPoint ifNone: [ self errorNotFound: aPoint ]
]

{ #category : 'finding/searching' }
RTAbstractCollection >> entryAtPoint: aPoint ifNone: aBlock [
	| result |
	result := self entriesAtPoint: aPoint.
	result ifEmpty: [ ^ aBlock value ].
	^ result anyOne
]

{ #category : 'shapes - ordering' }
RTAbstractCollection >> pushBack: anRTEntry [
	self subclassResponsibility
]

{ #category : 'shapes - ordering' }
RTAbstractCollection >> pushFront: anRTEntry [
	self subclassResponsibility
]

{ #category : 'update' }
RTAbstractCollection >> updateEntry: anRTEntry [
	^ self subclassResponsibility
]

{ #category : 'update' }
RTAbstractCollection >> updateEntry: anRTEntry before: anotherRTEntry [
	self subclassResponsibility
]

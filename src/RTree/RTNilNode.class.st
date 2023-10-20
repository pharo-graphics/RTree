"
Nil node for RSRenderTree
"
Class {
	#name : 'RTNilNode',
	#superclass : 'RTAbstractNode',
	#category : 'RTree',
	#package : 'RTree'
}

{ #category : 'adding' }
RTNilNode >> addChild: newObject [
	^ RTNode new: newObject
]

{ #category : 'testing' }
RTNilNode >> isNilNode [
	^ true
]

"
Nil node for RSRenderTree
"
Class {
	#name : 'RTNilNode',
	#superclass : 'RTAbstractNode',
	#category : 'RTree-Nodes',
	#package : 'RTree',
	#tag : 'Nodes'
}

{ #category : 'adding' }
RTNilNode >> addChild: anRTEntry [
	^ RTNode new: anRTEntry
]

{ #category : 'testing' }
RTNilNode >> isNilNode [
	^ true
]

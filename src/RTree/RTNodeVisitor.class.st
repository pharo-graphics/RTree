"
Visitor that works with `RSRNode`
"
Class {
	#name : 'RTNodeVisitor',
	#superclass : 'Object',
	#instVars : [
		'block'
	],
	#category : 'RTree',
	#package : 'RTree'
}

{ #category : 'instance creation' }
RTNodeVisitor class >> on: aBlock [
	^ self basicNew
		block: aBlock;
		yourself
]

{ #category : 'accessing' }
RTNodeVisitor >> block [
	^ block
]

{ #category : 'accessing' }
RTNodeVisitor >> block: aBlock [
	block := aBlock
]

{ #category : 'visiting' }
RTNodeVisitor >> visitNode: aNode [
	block value: aNode.
	aNode childrenDo: [ :child | child accept: self ]
]

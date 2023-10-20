Extension { #name : 'RTNilNode' }

{ #category : '*RTree-Tests' }
RTNilNode class >> example [
	| null |
	null := self new.
	"this object defines nil operations for RNode"
	null do: [ :each | 1/0 ].
	^ StInspectorPresenter openOn: null.
]

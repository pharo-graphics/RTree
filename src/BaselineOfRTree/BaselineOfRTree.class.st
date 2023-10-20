"
Baseline of RTree
"
Class {
	#name : 'BaselineOfRTree',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRTree',
	#package : 'BaselineOfRTree'
}

{ #category : 'baselines' }
BaselineOfRTree >> baseline: spec [
	<baseline>
	"https://github.com/pharo-graphics/RTree"
	spec for: #common do:[ 
		spec
			package: 'RTree';
			package: 'RTree-Tests'.
	].
]

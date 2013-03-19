package cn.royan.hl.bases;

typedef CallBackBase = {
	@:optional var done:Dynamic->Void;
	@:optional var doing:Dynamic->Void;
	@:optional var change:Dynamic->Void;
	@:optional var destory:Dynamic->Void;
	@:optional var down:Dynamic->Void;
	@:optional var up:Dynamic->Void;
	@:optional var over:Dynamic->Void;
	@:optional var out:Dynamic->Void;
	@:optional var click:Dynamic->Void;
}
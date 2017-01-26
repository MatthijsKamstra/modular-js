package;

@:expose
class Main {

	public function new () {
		trace( "Hello 'Main'" );
	}

	static public function main () {
		var app = new Main ();
	}
}

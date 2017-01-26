package;

import sys.FileSystem;
import sys.io.File;

using StringTools;

class Run {

	var hxFileArray:Array<String> = [];

	var isExpose : Bool = false;
	var isDebug : Bool = false;

	var sourceFolder : String = 'src';
	var exportFolder : String = 'bin';

	public function new()
	{
		var args = Sys.args ();
		var current = Sys.getCwd ();

		if(args.indexOf('-expose') != -1) 	isExpose = true;
		if(args.indexOf('-debug') != -1) 	isDebug = true;
		if(args.indexOf('-help') != -1) 	showHelp();
		if(args.indexOf('-source') != -1) 	sourceFolder = args[args.indexOf('-source')+1];
		if(args.indexOf('-export') != -1) 	exportFolder = args[args.indexOf('-export')+1];


		var root = args[args.length-1];
		var debugValue = (isDebug) ? '-debug' : '#-debug';
		var hxml = '# generated hxml-file with modular-js\n-cp $sourceFolder\n$debugValue\n\n--each\n\n';

		getHxFileFrom(root);

		for (i in 0 ... hxFileArray.length) {
			var path = hxFileArray[i];
			var name = path.replace(root, '').replace('src/','').replace('$sourceFolder/','').replace('.hx','');

			if(i!=0) hxml += '--next\n\n';

			hxml += '-js $exportFolder/${name.toLowerCase()}.js\n${name.replace('/','.')}\n\n';
		}

		File.saveContent(root+'/modular.hxml',hxml);
	}

	// will not change `// @:expose`
	function checkForExpose(path:String){
		var content = File.getContent(path);
		if(content.indexOf('@:expose') == -1){
			if(!isExpose) return;
			content = content.replace('class ', '@:expose\nclass ');
			File.saveContent(path, content);
		}
	}

	function getHxFileFrom ( folder:String) :Void{
		var source : Array<String> = FileSystem.readDirectory (folder);
		for (i in 0 ... source.length) {
			var fileName = source[i];
			if (!FileSystem.isDirectory (folder + fileName)){
				if (fileName.endsWith('.hx')){
					checkForExpose(folder + fileName);
					hxFileArray.push(folder + fileName);
				}
			} else {
				getHxFileFrom(folder + fileName+ '/');
			}
		}
	}

	function showHelp(){
		Sys.println('[fixme]');
	}

	static public function main() { var app = new Run();}

}


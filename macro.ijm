setBatchMode(true);

// Path to input image and output image (label mask)
inputDir = "/dockershare/666/in/";
outputDir = "/dockershare/666/out/";

// Functional parameters
method = "Default";

arg = getArgument();
parts = split(arg, ",");

for(i=0; i<parts.length; i++) {
	nameAndValue = split(parts[i], "=");
	if (indexOf(nameAndValue[0], "input")>-1) inputDir=nameAndValue[1];
	if (indexOf(nameAndValue[0], "output")>-1) outputDir=nameAndValue[1];
	if (indexOf(nameAndValue[0], "method")>-1) method=nameAndValue[1];
}

images = getFileList(inputDir);

for(i=0; i<images.length; i++) {
	image = images[i];
	if (endsWith(image, ".tif")) {
		// Open image
		open(inputDir + "/" + image);
		wait(100);
		// Processing
		setAutoThreshold(method + " dark");
		run("Convert to Mask");
		run("Watershed");
		run("Analyze Particles...", "show=[Count Masks] clear include in_situ");
		
		// Export results
		save(outputDir + "/" + image);
		
		// Cleanup
		run("Close All");
	}
}
run("Quit");


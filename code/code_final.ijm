orgName = getTitle();
run("Split Channels");
c1name = "C1-" + orgName;
c2name = "C2-" + orgName;

selectWindow(c1name);
nucorgID = getImageID();
nucrimID = nucseg( nucorgID );

selectWindow(c2name);
c2id = getImageID();
opt = "area mean centroid perimeter shape integrated display redirect=None decimal=3";
run("Set Measurements...", opt);
for (i =0; i < nSlices; i++){
    selectImage( nucrimID );
    setSlice( i + 1 );
    run("Create Selection");
    run("Make Inverse");
    selectImage( c2id );
    setSlice( i + 1 );
    run("Restore Selection");
    run("Measure");
}


function nucseg( orgID ){
    selectImage( orgId );
    run("Gaussian Blur...", "sigma=1.50 stack");
    
    setAutoThreshold("Otsu dark");
    setOption("BlackBackground", true);
    run("Convert to Mask", "method=Otsu background=Dark calculate black");
    run("Analyze Particles...", "size=800-Infinity pixel circularity=0.00-1.00 show=Masks display exclude clear include stack");
    dilateID = getImageID();
    run("Invert LUT");
    options =  "title = dup.tif duplicate range=1-" + nSlices;
    run("Duplicate...", options);
    erodeID = getImageID();
    selectImage(dilateID);
    run("Options...", "iterations=2 count=1 black edm=Overwrite do=Nothing");
    run("Dilate", "stack");
    selectImage(erodeID);
    run("Erode", "stack");
    imageCalculator("Difference create stack", dilateID, erodeID);
    resultID = getImageID();
    selectImage(dilateID);
    close();
    selectImage(erodeID);
    close();
    selectImage(orgID);
    close();
    run("Clear Results");
    return resultID;
}

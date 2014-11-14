﻿/* * Display Types Komorebi Resize * * Ken Frederick * ken.frederick@gmx.de * * http://kennethfrederick.de/ * http://blog.kennethfrederick.de/ * */// -----------------------------------------------------------------------------//// Properties//// -----------------------------------------------------------------------------var document = app.activeDocument;var layer = document.layers['linework'];var scalar = 0.5;var interval = 36*scalar;var radius = 0.8408; // inches// -----------------------------------------------------------------------------//// Methods//// -----------------------------------------------------------------------------////  Setup//(function setup() {})();////  Draw//(function draw() {    var w = document.width;    var h = document.height;    var lines = parseInt(h/52.056);    $.writeln(lines);    var selected = app.activeDocument.selection;    alert( selected.length );    // for (var i=0; i<selected.length; i++) {    //     var select = selected[i];    //     var x = select.left;    //     var y = map(select.top, 0,h, h,0);    //     var width  = Math.abs(select.geometricBounds[3] - select.geometricBounds[1]);    //     var height = Math.abs(select.geometricBounds[2] - select.geometricBounds[0]);    //     var line = parseInt(y % lines);    //     // var r = radius*72;    //     // var ellipse = layer.pathItems.ellipse(    //     //     y, x,    //     //     r, r,    //     //     false, true    //     // );    //     // var color = new RGBColor();    //     // var val = snap(clamp( map(y, h, 0, 0, 170), 0, 255), parseInt(255/lines)*2);    //     // color.red   = val;    //     // color.green = val;    //     // color.blue  = val;    //     // ellipse.fillColor = color;    //     var color = new RGBColor();    //     if ( parseInt(random(0, line)) === 0 ) {    //         color.red   = 255;    //         color.green = 0;    //         color.blue  = 0;    //         // select.remove();    //     }    //     else {    //         color.red   = 0;    //         color.green = 0;    //         color.blue  = 255;    //     }    //     select.fillColor = color;    //     // var offX = Math.abs(select.width-r)/2;    //     // var offY = Math.abs(select.height-r)/2;    //     // ellipse.translate(-offX, offY);    //     // select.remove();    // }})();// -----------------------------------------------------------------------------function random(min, max) {    if (max === undefined) {        max = min;        min = 0;    }    return (min + Math.random() * (max - min));};// ------------------------------------------------------------------------function map(val, istart, istop, ostart, ostop) {    return ostart + (ostop - ostart) * ((val - istart) / (istop - istart));};function clamp(val, min, max) {    return (val < min) ? min : ((val > max) ? max : val);};function round(val, decimalPlaces) {    var multi = Math.pow(10,decimalPlaces);    return Math.round(val * multi)/multi;};function snap(val, snapInc, roundFunction) {    var roundFunction = roundFunction || Math.round;    return round( snapInc * roundFunction(val / snapInc), 2 );};// ------------------------------------------------------------------------function radians(val) {    return val * (Math.PI/180);};
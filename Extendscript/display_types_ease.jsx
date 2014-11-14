﻿/* * Display Types Ease * * Ken Frederick * ken.frederick@gmx.de * * http://kennethfrederick.de/ * http://blog.kennethfrederick.de/ * */// -----------------------------------------------------------------------------//// Properties//// -----------------------------------------------------------------------------var document = app.activeDocument;var layer = document.layers['Layer 1'];var scalar = 0.5;var interval = 36*scalar;// -----------------------------------------------------------------------------//// Methods//// -----------------------------------------------------------------------------////  Setup//(function setup() {})();////  Draw//(function draw() {    var w = document.width;    var h = document.height;    var selected = app.activeDocument.selection;    // alert( selected.slength );    for (var i=0; i<selected.length; i++) {        var select = selected[i];        var x = 0;        var y = 0;        var width  = select.geometricBounds[3] - select.geometricBounds[1];        var height = select.geometricBounds[2] - select.geometricBounds[0];        var offX = 100;        var offY = 100;        // var j = i;        $.writeln( x );        // select.translate(w-x, 0);        select.geometricBounds = [            y + offY,            x + offX,            y + height + offY,            x + width + offX        ];        //for (var j=0; j<select.pageItems.length; j++) {            // $.writeln( select.pageItems[j].geometricBounds );            // var x = select.pageItems[j].geometricBounds[1];            // var y = select.pageItems[j].geometricBounds[0];            // var width  = select.pageItems[j].geometricBounds[3] - x;            // var height = select.pageItems[j].geometricBounds[2] - y;            // var offX = 100;            // var offY = 100;            // var x = 100;            // var y = 100;            // select.pageItems[j].geometricBounds = [            //     y + offY,            //     x + offX,            //     y + height + offY,            //     x + width + offX            // ];            // select.pageItems[j].translate(w-x, 0);            // $.writeln( 'x:\t' + x );        //}    }})();// ------------------------------------------------------------------------function map(val, istart, istop, ostart, ostop) {    return ostart + (ostop - ostart) * ((val - istart) / (istop - istart));};function radians(val) {    return val * (Math.PI/180);};// ------------------------------------------------------------------------var Ease = function() {    return {        /*         * see http://easings.net/de for visual examples         * of each spline method         */        linear: function(t) { return t; },        inQuad: function(t) { return t*t; },        outQuad: function(t) { return t*(2-t); },        inOutQuad: function(t) { return t<.5 ? 2*t*t : -1+(4-2*t)*t; },        inCubic: function(t) { return t*t*t; },        outCubic: function(t) { return (--t)*t*t+1; },        inOutCubic: function(t) { return t<.5 ? 4*t*t*t : (t-1)*(2*t-2)*(2*t-2)+1; },        inQuart: function(t) { return t*t*t*t; },        outQuart: function(t) { return 1-(--t)*t*t*t; },        inOutQuart: function(t) { return t<.5 ? 8*t*t*t*t : 1-8*(--t)*t*t*t; },        inQuint: function(t) { return t*t*t*t*t; },        outQuint: function(t) { return 1+(--t)*t*t*t*t; },        inOutQuint: function(t) { return t<.5 ? 16*t*t*t*t*t : 1+16*(--t)*t*t*t*t; },        inSine: function(t) { return -1*Math.cos(t*(Math.PI/2))+1; },        outSine: function(t) { return 1*Math.sin(t*(Math.PI/2)); },        inOutSine: function(t) { return -0.5*(Math.cos(Math.PI*t)-1); },        inExpo: function(t) { return 1*Math.pow(2, 10*(t-1)); },        outExpo: function(t) { return 1*(-Math.pow(2, -10*t)+1 ); },        inOutExpo: function(t) { t /= 0.5; if (t < 1) return 0.5 * Math.pow(2, 10*(t-1)); t--; return 0.5 * (-Math.pow(2, -10*t)+2); },        inCirc: function(t) { return -1*(Math.sqrt(1-t*t)-1) },        outCirc: function(t) { t--; return 1*Math.sqrt(1-t*t); },        inOutCirc: function(t) { t /= 0.5; if (t<1) { return -0.5*(Math.sqrt(1-t*t)-1); } else { t-=2; return 0.5*(Math.sqrt(1-t*t)+1); } }    };};
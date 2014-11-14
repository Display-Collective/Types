console.log( 'Display Facade' );

/**
 *  Display Façade
 *
 *  Ken Frederick
 *  ken.frederick@gmx.de
 *
 *  http://kennethfrederick.de/
 *  http://blog.kennethfrederick.de/
 *
 */


// ------------------------------------------------------------------------
// Properties
// ------------------------------------------------------------------------
var scalar = 0.25;
var interval = 36*scalar;
var angles = {
    y: 108,
    m: 162,
    c: 90,
    k: 45
};
var halftone;



// ------------------------------------------------------------------------
// Setup
// ------------------------------------------------------------------------
function Setup() {
    view.viewSize = new Size(
        parseInt(2691*scalar),
        parseInt(3420*scalar)
    );

    // var p = new Path.Circle(
    //     view.bounds.center,
    //     100
    // );
    // p.fillColor = 'red';

    halftone = new Halftone(interval, 'black', 45, setRadius);
};



// ------------------------------------------------------------------------
// Update
// ------------------------------------------------------------------------
function Update(event) {
};



// ------------------------------------------------------------------------
// Draw
// ------------------------------------------------------------------------
function Draw() {
    halftone.draw();
};



// ------------------------------------------------------------------------
// Methods
// ------------------------------------------------------------------------
var Halftone = function(interval, color, degree, callback) {
    //
    // Properties
    //
    var w = paper.view.bounds.width;
    var h = paper.view.bounds.height;

    console.log( w + '\t' + h );

    var rad = paper.radians(degree % 90);
    var sinr = Math.sin(rad),
        cosr = Math.cos(rad);
    var ow = w * cosr + h * sinr,
        oh = h * cosr + w * sinr;


    //
    // Methods
    //
    function draw() {
        var display = document.getElementById('canvas').getContext('2d');

        // positioning
        display.translate(w * sinr * sinr, -w * sinr * cosr);
        display.rotate(rad);

        for (var y=0; y<oh; y+=interval) {
            for (var x=0; x<ow; x+=interval) {
                var radius = callback(x, y, interval) || 0;

                if (radius !== 0) {
                    var path = new Path.Circle(
                        new Point(x, y),
                        radius
                    );
                    path.fillColor = getColor(color);
                }
            }
        }

        // todo cleanup?

        // reset
        // display.rotate(-rad);
        // display.translate(-w * sinr * sinr, w * sinr * cosr);
    };

    function getColor(color) {
        if (color === 'k' || color === 'black') {
            return '#000';
        }
        else if (color === 'c' || color === 'cyan') {
            return new Color(0, 1.0, 1.0, 1.0);
        }
        else if (color === 'm' || color === 'magenta') {
            return new Color(1.0, 0, 1.0, 1.0);
        }
        else if (color === 'y' || color === 'yellow') {
            return new Color(1.0, 1.0, 0, 1.0);
        }
        else {
            return color;
        }
    };


    return {
        draw: draw
    }
};

// ------------------------------------------------------------------------
function setRadius(x, y, interval) {
    var w = view.bounds.width;
    var h = view.bounds.height;

    var norm = paper.map(x*y, 0, w*h, 9, 72);
    var r = paper.map(norm, 9, 72, 1, 48);
    var angle = Math.abs((norm % 90) * Math.PI / 180);

    return (norm < 72 && parseInt(Math.random()*r) === 0)
        ? 0
        : Math.sqrt(0.4) * interval * Math.sin(angle);
};

// ------------------------------------------------------------------------
function saveSVG(fileName) {
   if (fileName) {
        console.log('Saving SVG...');
        var url = 'data:image/svg+xml;utf8,' + encodeURIComponent(paper.project.exportSVG({asString:true}));

        var link = document.createElement('a');
        link.download = fileName;
        link.href = url;
        link.click();

        console.log('Ding!');
   }
};



// ------------------------------------------------------------------------
// Events
// ------------------------------------------------------------------------
function onResize(event) {
    // view.size = event.size;
};

// ------------------------------------------------------------------------
function onMouseUp(event) {
};

function onMouseDown(event) {
};

function onMouseMove(event) {
};

function onMouseDrag(event) {
};


// ------------------------------------------------------------------------
function onKeyDown(event) {
    if (event.key === 'e' && event.modifiers.command) {
        var serial = paper.randomInt(999);
        saveSVG('displayFacade_' + serial + '.svg');
    }
};

function onKeyUp(event) {
};






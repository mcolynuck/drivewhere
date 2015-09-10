/**
 * Map object for use with maps within the DriveWhere application.
 * @param div => div element in html which will hold the map.
 * Usage:  myMap = new Map($("#mapDiv").get(0));
 */
function Map(div){
     this.map = null;
     this.startLat = 54.8833;
     this.startLng = -122.6667;
     this.startZoom = 4;
//   this.prevLL = null;
//   this.prevZoom = null;
     this.markers = [];
     this.activeListeners = [];
     this.clickMapListener = null;
     this.trafficLayer = null;
     this.weatherLayer = null;
     this.infoWindow = null;
     this.coordsElm = null;

    var myOptions = {
            zoom: this.startZoom,
            center: new google.maps.LatLng(this.startLat, this.startLng),
            scaleControl: true,
            scaleControlOptions: {
                position: google.maps.ControlPosition.BOTTOM_LEFT
            },
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };

    this.map = new google.maps.Map(div, myOptions);
}


// ------ START ZOOM --------------------

/**
 * Called to zoom into map point at center.
 * @param map -If null, no modifications made.
 * @param lat -If null, center is not changed.
 * @param long -If null, long is not changed.
 * @param zoom -If null, zoom level is not changed.
 */
Map.prototype.zoomToPoint = function(map, lat, long, zoom) {
    if (map) {
        if ( !( lat == null || long == null ) ) {
            this.map.setCenter(new google.maps.LatLng (lat, long));
        }
        if ( zoom != null ){
            this.map.setZoom (zoom);
        }
    }
};


/**
 * Zoom to a specific zoom level.
 * @param zoomLvl - Zoom level recognized by map object (i.e. 1 -> 20)
 */
Map.prototype.zoomIn = function (zoomLvl){
    this.map.setZoom(zoomLvl);
};


/**
 * Zoom to show all markers in map at one time.
 */
Map.prototype.showAllMarkers = function(){
    var that = this,
        ll = [],
        bounds = new google.maps.LatLngBounds();

    for(var i=0; i < this.markers.length; i++){
        bounds.extend(this.markers[i].position);
     }
     this.map.fitBounds(bounds);
     window.setTimeout(function(){that.map.setZoom(that.map.getZoom() - 1);}, 400);
};

// --------- END ZOOM ----------------------------------

// -------- START LAYERS --------------------------------------

/**
 * Add the Drawing Manager tool to the map.
 * Lets you add markers, polygons, circles, etc. to the map.
 */
Map.prototype.addDrawingManager = function(){
  var drawingManager = new google.maps.drawing.DrawingManager({
    drawingMode: google.maps.drawing.OverlayType.MARKER,
    drawingControl: true,
    drawingControlOptions: {
      position: google.maps.ControlPosition.TOP_CENTER,
      drawingModes: [
        google.maps.drawing.OverlayType.MARKER,
        google.maps.drawing.OverlayType.CIRCLE,
        google.maps.drawing.OverlayType.POLYGON,
        google.maps.drawing.OverlayType.POLYLINE,
        google.maps.drawing.OverlayType.RECTANGLE
      ]
    },
    markerOptions: {
//      icon: 'images/beachflag.png'
    },
    circleOptions: {
      fillColor: '#ffff00',
      fillOpacity: 1,
      strokeWeight: 5,
      clickable: false,
      editable: true,
      zIndex: 1
    }
  });
  drawingManager.setMap(this.map);    
};


/**
 * Add the weather layer to the map.
 * This layer is deprecated but still available.
 * @param enable - true/false to turn layer on/off.
 */
Map.prototype.addWeatherLayer = function(enable){
    if(!this.weatherLayer){
        this.weatherLayer = new google.maps.weather.WeatherLayer({
                temperatureUnits: google.maps.weather.TemperatureUnit.CELCIUS});
    }
    if(enable){
        this.weatherLayer.setMap(this.map);
    } else {
        this.weatherLayer.setMap(null);
    }
};


/**
 * Add the traffic layer to the map.
 * @param enable - true/false to turn the layer on/off.
 */
Map.prototype.addTrafficLayer = function(enable){
    if(!this.trafficLayer){
        this.trafficLayer = new google.maps.TrafficLayer();
    }
    if(enable){
        this.trafficLayer.setMap(this.map);
    } else {
        this.trafficLayer.setMap(null);
    }
};

// ------------ END LAYERS -------------------------

// ------------- START MARKERS ------------------------

/**
 * Deletes the most recent marker that was added to the mamp.
 */
Map.prototype.deleteMarker = function(){
    if(this.markers.length > 0){
        var lastMarkerIdx = this.markers.length - 1;

        this.enableMapClickListener(false);
        this.enableMarkerClickListener(false, this.markers[lastMarkerIdx]);
        this.enableMarkerDragDropListener(false, this.markers[lastMarkerIdx]);

        this.markers[lastMarkerIdx].setMap(null);
        this.markers.splice(lastMarkerIdx, 1);

        if(jQuery.inArray("click", this.activeListeners) > -1){
            this.enableMapClickListener(true);
        }
    }
};




/**
 * Places a marker at the given coordinates.
 * Will assign click & drag/drop listeners on marker if they were configured (see: enableMarkerClickListener())
 * @param String coords - Text containing "<longitude> <latitude>".
 *                        May be either space or comma separated values.
 * @param zoomLvl - (Optional) Zoom to level value or leaves zoom unchanged if not given.
 * @param bPan - (Optional) true/false to center the marker in the map.
 * @param title = (Optiona) Text displayed when marker is hovered over.
 * @param content - (Optional) Text/html for the content of the popup window when marker is clicked.
 * return - Marker or null if an error (i.e. coordinates not formatted correctly.)
 */
Map.prototype.addMarker = function(coords, zoomLvl, bPan, title, content){
    var that = this,
        marker = null;

    if(!bPan){
        bPan = true;    // Set default.
    }

    if(!title){
        title = "";     // Set default.
    }

    if(!content){
        content = "";   // Set default.
    }

    if (coords != null && coords != 'undefined'){
        if (coords.split(",").length == 2){
            coordParts = coords.split(",");
        } else if (coords.split(" ").length == 2){
            coordParts = coords.split(" ");
        } else {
            // Cannot determine what's going on.
            alert("Coordinates must be formatted as: Latitude Longitude\nSeparated by space or comma only.");
            return null;
        }

        ll = new google.maps.LatLng(parseFloat(coordParts[0]), parseFloat(coordParts[1]));
        
        // Disable listener on map temporarily.
        this.enableMapClickListener(false);
        
        marker = new google.maps.Marker({
            position: ll,
            draggable: true,    // Only really needed for new & edit maps.
            map: this.map,
            title: title,       // Marker hover text
            content: content,   // Content of info window
            listener: []        // Array of listeners (i.e. ["dragdrop"] = dragDropListener)
        });
        this.markers.push(marker);


        if(this.coordsElm){   // Update coords field if available.
            this.coordsElm.val("" + ll.lat() + " " + ll.lng());
        }

        if(bPan){       // Pan to marker?
            this.map.panTo(ll);
        }

        if (zoomLvl){   // Zoom in on marker?
            this.map.setZoom(zoomLvl);           
        }
        
        // Enable listeners if they were requested in call to enableMarkerClickListener().
        if(jQuery.inArray("click", this.activeListeners) > -1){
            this.enableMapClickListener(true);
        }
        if(jQuery.inArray("dragdrop", this.activeListeners) > -1){
            this.enableMarkerDragDropListener(true, marker);
        }
        if(jQuery.inArray("marker", this.activeListeners) > -1){
            this.enableMarkerClickListener(true, marker);
        }

        return marker;
    }
    return null;
};

// ---------- END MARKERS ------------------------------------

// ---------- START LISTENERS ------------------------------------------

// Constants for listeners
Map.prototype.LISTENER_MAP_CLICK        = "click";
Map.prototype.LISTENER_MARKER_DRAGDROP  = "dragdrop";
Map.prototype.LISTENER_MARKER_CLICK     = "marker";

/**
 * Enable listeners in bulk from array of strings.
 * @param array - Array of listeners to enable. i.e. ["click", "dragdrop"]
 * @param domElm - jQuery element to write coordinates to. (for map click & marker drag/drop listeners)
 */
Map.prototype.enableListeners = function (array, coordsElm){
    var that = this;
    $.each(array, function(index, item){
        if(item == that.LISTENER_MAP_CLICK){
            that.activeListeners.push(that.LISTENER_MAP_CLICK);
            that.enableMapClickListener(true);
            that.coordsElm = coordsElm
        } else if(item == that.LISTENER_MARKER_DRAGDROP){
            that.activeListeners.push(that.LISTENER_MARKER_DRAGDROP);
            that.coordsElm = coordsElm
        } else if(item == that.LISTENER_MARKER_CLICK){
            that.activeListeners.push(that.LISTENER_MARKER_CLICK);
        }
    });
};


/**
 * Listens to click events in map and places marker at that position
 * @param boolean enable -Turns listener on/off using true/false.
 */
Map.prototype.enableMapClickListener = function(enable){
    var that = this;
    function clearListener(){
        google.maps.event.removeListener(that.clickMapListener);
        that.clickMapListener = null;
    }
    if (enable){
        clearListener();
        if(this.map !== null){
            this.clickMapListener = google.maps.event.addListener(this.map, 'click', function(e) {
                that.deleteMarker();
                that.addMarker("" + e.latLng.lat() + ' ' + e.latLng.lng());
            });
        }
    } else {
        clearListener();
    }
}


/**
 * Listens to marker drag-drop events in map and places marker at that position.
 * @param enable - Add/remove listener for drag-drop events with true/false.
 * @param marker - Marker to assign dragend listener to.
 */
Map.prototype.enableMarkerDragDropListener = function(enable, marker){
	var that = this;
    if(marker && !enable){  // Remove listener?
        google.maps.event.removeListener(marker.listener["dragdrop"]);
        marker.listener[this.LISTENER_MARKER_DRAGDROP] = null;
    } else if (marker){
        marker.listener[this.LISTENER_MARKER_DRAGDROP] = google.maps.event.addListener(marker, 'dragend', function(e){
            if(that.coordsElm){   // Update coords field if found.
                that.coordsElm.val(""+e.latLng.lat()+" "+e.latLng.lng());
            }
        });
    }
};


/**
 * Listens for click events on markers and opens the info window.
 * @param marker - Marker to assign click listener on.
 */
Map.prototype.enableMarkerClickListener = function(enable, marker){
    var that = this;
    if (marker && !enable) {
        google.maps.event.removeListener(marker.listener["marker"]);
        marker.listener[this.LISTENER_MARKER_CLICK] = null;
    } else if (marker) {
        if(this.map !== null){
            marker.listener[this.LISTENER_MARKER_CLICK] = google.maps.event.addListener(marker, 'click', function() {
                if(that.infoWindow){
                    that.infoWindow.setMap(null);   // Close previous info window (if open...)
                }
                that.infoWindow = new google.maps.InfoWindow({content: marker.content});
                that.infoWindow.open(that.map, marker);
            });
        }
    } else {
        clearListener();
    }
};

// ------------------ END LISTENERS ----------------------------
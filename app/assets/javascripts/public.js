//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/

var publicMap = null,		// Map on public page.
	reportMap = null;

function initializeMap(){
	if (resizeMap()){	// False if not visible.
		var marker = null;
		publicMap = new Map($("#map").get(0));
		publicMap.enableListeners([publicMap.LISTENER_MARKER_CLICK], $("#coords"));
	
		addMarkers();	
		publicMap.showAllMarkers();

		$(window).resize(resizeMap);	// Handle resizing event
	}
}


/**
 * Delay loading the map immediately as the google library may not be loaded for a few millisecionds.
 * Only has to be done once.
 */
var waited = false;
function report_menu_clicked(){
	function wait_for_it(){
		if($("#report_map_content").is(':visible')){
    		reportMap = new Map($("#report_map").get(0));
   		    reportMap.enableListeners([reportMap.LISTENER_MARKER_DRAGDROP, reportMap.LISTENER_MAP_CLICK], $("#coords"));
    	} else {
    		wait_timer = window.setTimeout(wait_for_it, 100);	// Wait some more...
    	}
    }
    if(!waited){	// Prevent if we've already done this.
    	waited = true;
    	wait_for_it();
    }
}



// Resizes map div to maximize display raea.
function resizeMap(){
	if ($("#content_map").is(':visible')){
	    // Maximize map in surrounding div.    
		var h = $(window).height() - $("#maparea").position().top - 10;
	    $("#map").height(h);
//		$("#maparea").width(parseInt($("#tab_menu").width()) - 0);
		if(publicMap){
    		google.maps.event.trigger(publicMap, 'resize');
    	}
	    return true;
	}
	return false;
}



// Called when the public view is finished loading.
var public_ready = function() {
	initializeMap();

	/* Menu click event. */
	$(".tab_item").on("click", function(event){
		// Which item was clicked?
		var click_id = event.target.id;

		// Don't do anything if clicking on active tab.
		if(jQuery.inArray("tab_active", event.target.classList) == -1){
			// Set item as active
			$(".tab_item").each(function(){
				// Show/Hide content
				if($(this).hasClass("tab_active")){
					$(this).removeClass("tab_active");
					$("#content"+$(this).context.id).toggle();
				}

				// Set active menu item.
				if($(this).context.id == click_id){
					$(this).addClass("tab_active");
					$("#content"+click_id).toggle();
				}
			});

			if(click_id == '_map'){
				// This should clean up the map after a resize when it's hidden.
				if(publicMap){
					google.maps.event.trigger(publicMap.map, "resize");
				}
			}
			if(click_id == '_report'){
				// This should clean up the map after a resize when it's hidden.
				if(reportMap){
					google.maps.event.trigger(reportMap.map, "resize");
				}
			}
		}
	});

	$("#weather_layer").on("click", function(event){
		publicMap.addWeatherLayer(event.target.checked);
	});

	$("#traffic_layer").on("click", function(event){
		publicMap.addTrafficLayer(event.target.checked);
	});

	$(".sidebar").tabSlideOut({
		 tabHandle: '.handle',                    // class of the element that will be your tab
		 pathToTabImage: 'assets/tab_icon.png',  // path to the image for the tab (optionaly can be set using css)
		 imageHeight: '40px',                     // height of tab image
		 imageWidth: '45px',                      // width of tab image (Add pixels to give space to div)
		 tabLocation: 'right',                    // side of screen where tab lives, top, right, bottom, or left
		 speed: 400,                              // speed of animation
		 action: 'click',                         // options: 'click' or 'hover', action to trigger animation
		 topPos: '20px',                          // position from the top
		 fixedPosition: false                     // options: true makes it stick(fixed position) on scroll
	});

};
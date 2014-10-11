//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/

// function initializeMap(div) {    
// console.log("public initializeMap");
//     // Maximize map area
//     $("#map").width($(window).width() - $(".right_side").width() - 1),
// //    $("#map").height($(".right_side").height() - $(".maptop").height());
// // map.height = page.height - banner.height - menu.height
//     createMap(div);
// }


// Resizes map div to maximize display raea.
function resizeMap(){
	if ($("#content_map").is(':visible')){
	    // Maximize map in surrounding div.    
	    $("#map").height($(window).height() - $("#map").position().top - 55);
	    $("#map").width($("#sidebar").position().left - $(_map).position().left);
	    return true;
	}
	return false;
}


function resizeReportMap(){
	if ($("#content_report").is(':visible')){
	    // Maximize map in surrounding div.    
	    // $("#report_map").height($(window).height() - $("#map").position().top - 55);
	    // $("#report_map").width($("#sidebar").position().left - $(_map).position().left);
	    return true;
	}
	return false;
}

var publicMap = null,		// Map on public page.
    reportMap = null;

var public_ready = function() {
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
		}
	});

	$("#weather_layer").on("click", function(event){
		publicMap.addWeatherLayer(event.target.checked);
	});

	$("#traffic_layer").on("click", function(event){
		publicMap.addTrafficLayer(event.target.checked);
	});
};
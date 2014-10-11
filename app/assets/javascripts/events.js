/* Plugin to change select option list in single call */
(function ($, window) {
    $.fn.replaceOptions = function (options) {
        var self, $option;

        this.empty();
        self = this;

        $.each(options, function (index, option) {
            $option = $("<option></option>")
                .attr("value", option.value)
                .text(option.text);
            self.append($option);
        });
    };
})(jQuery, window);



// There is one variable per map in the events pages.
var editMap = null,
    newMap = null,
    showMap = null;


/**
 * Updates the select/options based on the owner id
 */
function updateSelectOptions(newOwnerId) {
    // These are the owner id/value pairs for the select options
    var owner_prefs = JSON.parse($("#owner_prefs").html()),
        related = JSON.parse($("#related_data").html());

    // Build new options using name/value pairs
    function buildOptions(names, prefs) {
        var options = [],
            item = null,
            i = 0,
            x = 0;
        for (i = 0; i < prefs.length; i++) {
            item = prefs[i];
            if (item.owner_id == newOwnerId) {
                for (x = 0; x < item.data.length; x++) {
                    options.push({text: names[item.data[x] - 1].name, value: item.data[x]});
                }
            }
        }
        return options;
    }

    $("#severity").replaceOptions(buildOptions(related.severities, owner_prefs.owner_severities));
    $("#district").replaceOptions(buildOptions(related.districts, owner_prefs.owner_districts));
    $("#event_type").replaceOptions(buildOptions(related.event_types, owner_prefs.owner_event_types));
    $("#traffic_pattern").replaceOptions(buildOptions(related.traffic_patterns, owner_prefs.owner_traffic_patterns));
}


// Set up events for a map after it is created.
function initEventMap(map){
    // Show different prefs if owner is changed.
    $('#owner').change(function () {
        updateSelectOptions($(this).val());
    });

    // Delete marker button
    $("#del_marker").on("click", function(ev){
        map.deleteMarker();
        $("#coords").val("");
        ev.preventDefault();
    });
}


// Edit Event page
var edit_events_ready = function() {
    initEventMap(editMap);
};


// New Event page
var new_events_ready = function(){
    initEventMap(newMap);
};


// Show Event page
var show_events_ready = function(){
    initEventMap(showMap);
};

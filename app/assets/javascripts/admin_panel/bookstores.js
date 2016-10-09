withinControllerScope('bookstores', ['new', 'create', 'edit', 'update'], function(W, D, $){
    function updateMarkerPosition(position, map, title, updateForm) {
        if(updateForm) {
            $('#bookstoreLat').val(position.lat);
            $('#bookstoreLng').val(position.lng);
        }

        return new W.google.maps.Marker({
            position: position,
            map: map,
            title: title
        });
    }

    W.initMap = function () {
        var handler = W.Gmaps.build('Google'),
            currentPosition = { lat: parseFloat($('#bookstoreLat').val()), lng: parseFloat($('#bookstoreLng').val()) },
            bookstoreTitle = $('#bookstoreTitle').val(),
            hasCoordinates = currentPosition.lat && currentPosition.lng;
        handler.buildMap({ provider: {
            zoom: hasCoordinates ? 18 : 6, // set zoom closer if bookstore has been chosen
            center: hasCoordinates ? currentPosition : W.ukraineCenter
        }, internal: {id: 'bookstoreMap'}}, function(){
            // set marker at bookstore position on page load if bookstore has coordinates
            if (currentPosition.lat) updateMarkerPosition(currentPosition, handler.getMap(), bookstoreTitle);

            W.google.maps.event.addListener(handler.getMap(), 'click', function(e) {
                updateMarkerPosition({ lat: e.latLng.lat(), lng: e.latLng.lng() },
                    handler.getMap(), i18n.admin_panel.bookstores.new_bookstore, true);
            });
        });
    };

    // Load the map after google script gets loaded. Doing it with Google API callback does not work
    // when script invocation is placed in <head>. When script is placed in <body>, because of turbolinks it gets
    // loaded multiple times.
    afterConstantLoaded('google', W.initMap.bind(this));
});

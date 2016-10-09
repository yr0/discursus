(function(W, D, $){
    W.isWithinScope = function(controllers, actions) {
        var scope = $('body').data('scope'),
            controllersList = (typeof controllers.join === 'function') ? controllers.join('|') : controllers,
            actionsList = (typeof actions.join === 'function') ? actions.join('|') : actions,
            regexp = new RegExp('^' + controllersList + '.(?:' + actionsList + ')$');
        return !!(scope && scope.match(regexp));
    };

    // used for binding certain JS logic to specific controllers and actions
    W.withinControllerScope = function(controllers, actions, actualFunction) {
        D.addEventListener('turbolinks:load', function () {
            if (!isWithinScope(controllers, actions)) return;
            actualFunction(W, D, $);
        });
    };

    // performs action only after constantName has been loaded - useful for async scripts
    W.afterConstantLoaded = function(constantName, action) {
      var checkInterval = W.setInterval(function(){
          if(typeof W[constantName] !== 'undefined') {
              W.clearInterval(checkInterval);
              action();
          }
      }, 500);
    };
}(window, document, jQuery));

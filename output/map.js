// Generated by CoffeeScript 1.7.1
(function() {
  window.Map = (function() {
    function Map(width, height) {
      var x;
      this.width = width;
      this.height = height;
      this.map = new Array(width);
      this.map = (function() {
        var _i, _results;
        _results = [];
        for (x = _i = 0; 0 <= width ? _i < width : _i > width; x = 0 <= width ? ++_i : --_i) {
          _results.push(this.map[x] = new Array(height));
        }
        return _results;
      }).call(this);
    }

    Map.prototype.at = function(location) {
      return location.on(this.map);
    };

    Map.prototype.setLocation = function(location, symbol) {
      return location.setOn(this.map, symbol);
    };

    Map.prototype.isOpen = function(location) {
      return this.at(location) != null;
    };

    Map.prototype.locations = function() {
      var location, result, x, y, _i, _j, _ref, _ref1;
      result = [];
      for (x = _i = 0, _ref = this.width; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
        for (y = _j = 0, _ref1 = this.height; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
          location = new Location([x, y]);
          if (this.isOpen(location)) {
            result.push(location);
          }
        }
      }
      return result;
    };

    Map.prototype.randomLocation = function() {
      return Util.pickRandom(this.locations());
    };

    return Map;

  })();

}).call(this);

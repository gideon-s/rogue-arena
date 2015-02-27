// Generated by CoffeeScript 1.8.0
(function() {
  window.Colorizor = (function() {
    function Colorizor(colors) {
      this.colors = colors != null ? colors : ["yellow", "red", "orange"];
    }

    Colorizor.prototype.color = function() {
      return Util.pickRandom(this.colors);
    };

    return Colorizor;

  })();

  window.Colors = (function() {
    function Colors() {}

    Colors.fire = new Colorizor(["yellow", "red", "orange"]);

    Colors.cold = new Colorizor(["blue", "MediumAquamarine", "cyan", "DarkBlue", "LightBlue"]);

    Colors.poison = new Colorizor(["blue", "green", "yellow"]);

    Colors.blues = new Colorizor(["purple", "blue", "MediumAquamarine"]);

    return Colors;

  })();

}).call(this);

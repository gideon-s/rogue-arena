
class window.Colorizor 
    constructor: (@colors = ["yellow", "red", "orange"]) ->
    color: () -> Util.pickRandom(@colors)

class window.Colors
    @fire: new Colorizor ["yellow", "red", "orange"]
    @poison: new Colorizor ["blue", "green", "yellow"]
    @blues: new Colorizor ["purple", "blue", "MediumAquamarine"]
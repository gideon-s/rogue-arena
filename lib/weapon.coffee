class window.Weapon
    constructor: (@fireRate, @owner) ->

    fire: (dirIndex) ->
        if @lastFired? and Util.millisSince(@lastFired) < @fireRate
            return
        xyDir = Util.xyDir(dirIndex)
        @shoot(xyDir)
        @lastFired = Util.millis()

class window.Pistol extends window.Weapon
    constructor: (owner) -> super(150, owner)
    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        new Projectile(@owner.game, nextLocation, xyDir, @owner, "yellow", 20)

class window.GrenadeLauncher extends window.Weapon
    constructor: (owner) -> super(500, owner)
    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        new Grenade(@owner.game, nextLocation, xyDir, @owner, "red", 20)

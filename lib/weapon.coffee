class window.Weapon
    constructor: (@fireRate, @owner) ->

    fire: (dirIndex) ->
        if @lastFired? and Util.millisSince(@lastFired) < @fireRate
            return
        xyDir = Util.xyDir(dirIndex)
        @shoot(xyDir)
        @lastFired = Util.millis()

class window.ControlledBlink extends window.Weapon
    constructor:(owner) -> super(200, owner)
    shoot: (xyDir) ->
        destination = @owner.location.addDir xyDir, 8
        @owner.moveTo(destination)

class window.Dart extends window.Weapon
    constructor: (owner) -> super(150, owner)
    shootSound = new Howl(urls: ['./media/button.mp3'])

    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        shootSound.play()
        new Projectile(@owner.game, nextLocation, xyDir, @owner, "yellow", 20)

class window.FireBall extends window.Weapon
    constructor: (owner) -> super(500, owner)
    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        new Ball(@owner.game, nextLocation, xyDir, @owner, "red", 20)

class window.FireWall extends window.Weapon
    constructor: (owner) -> super(2500, owner)
    makeCloud: (loc) ->
        new UnmovingCloud(@owner.game, loc)

    shoot: (xyDir) ->
        main = @owner.location
        main = main.addDir(xyDir, 5)
        leftTurn = [xyDir[1], -xyDir[0]]
        spot = main.addDir(leftTurn, 5)
        _.times 10, (n) =>
            @makeCloud(spot)
            spot = spot.subtractDir(leftTurn)

class window.RescueRay extends window.Weapon
    constructor: (owner) -> super(300, owner)

    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        new RescueProjectile(@owner.game, nextLocation, xyDir, @owner, "white", 7)


class window.MagicMissile extends window.Weapon
    constructor: (owner) -> super(400, owner)
    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        projectile = new Projectile(@owner.game, nextLocation, xyDir, @owner, "white", 100)
        projectile.speed = 2
        projectile

class window.SmokeTrail extends window.Weapon
    constructor: (owner) -> super(200, owner)
    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        purples = new Colorizor(["purple", "blue", "MediumAquamarine"])
        projectile = new Particle(@owner.game, nextLocation, @owner, @maxLife = 15, "purple", purples)
        projectile.speed = 1000
        projectile


class window.KnifeWall extends window.Weapon
    constructor: (owner) -> super(150, owner)
    shoot: (xyDir) ->
            nextLocation = @owner.location.addDir(xyDir)
            for dir in [0..7] 
                new Projectile(@owner.game, nextLocation, Util.xyDir(dir), @owner, "red", 3)

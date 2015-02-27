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
        new Projectile(@owner.game, nextLocation, @owner, 20, "+", "yellow", 20, xyDir)

class window.FireBall extends window.Weapon
    constructor: (owner) -> super(500, owner)
    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        new Ball(@owner.game, nextLocation, xyDir, @owner, 20)

class window.FireWall extends window.Weapon
    constructor: (owner) -> super(500, owner)
    makeCloud: (loc) -> new UnmovingCloud(@owner.game, loc)

    shoot: (xyDir) ->
        main = @owner.location
        main = main.addDir(xyDir, 5)
        leftTurn = Util.leftTurn xyDir
        spot = main.addDir(leftTurn, 5)
        _.times 10, (n) =>
            @makeCloud(spot)
            spot = spot.subtractDir(leftTurn)

class window.ConeOfCold extends window.Weapon
    constructor: (owner) -> super(500, owner)
    shoot: (xyDir) ->
        loc = @owner.location
        sides = -1
        for i in [0...8] 
            if i % 3 == 0
                sides = sides + 1
            loc = loc.addDir(xyDir)
            new ColdCloud(@owner.game, loc, @owner)
            leftLoc = loc
            rightLoc = loc
            _.times sides, =>
                leftLoc = leftLoc.addDir(Util.leftTurn(xyDir))
                new ColdCloud(@owner.game, leftLoc, @owner)
                rightLoc = rightLoc.addDir(Util.rightTurn(xyDir))
                new ColdCloud(@owner.game, rightLoc, @owner)


class window.RescueRay extends window.Weapon
    constructor: (owner) -> super(300, owner)

    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        new RescueProjectile(@owner.game, nextLocation, @owner, 15, "+", "white", 20, xyDir)
        
class window.MagicMissile extends window.Weapon
    constructor: (owner) -> super(500, owner)
    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        new HomingProjectile(@owner.game, nextLocation, @owner, 50, "cyan", xyDir)
        
class window.SmokeTrail extends window.Weapon
    constructor: (owner) -> super(200, owner)
    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        purples = Colors.blues
        projectile = new Particle(@owner.game, nextLocation, @owner, @maxLife = 15, purples, 300)
        projectile.speed = 1000
        projectile


class window.KnifeWall extends window.Weapon
    constructor: (owner) -> super(150, owner)
    shoot: (xyDir) ->
        nextLocation = @owner.location.addDir(xyDir)
        for dir in [0..7] 
            new Projectile(@owner.game, nextLocation, @owner, 3, "+", "red", 20, Util.xyDir(dir))

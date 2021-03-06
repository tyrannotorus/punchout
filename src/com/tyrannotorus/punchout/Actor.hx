﻿package com.tyrannotorus.punchout;
	
	//import code.Ombre;
	import openfl.display.Sprite;
	import openfl.display.Bitmap;
	import openfl.display.BitmapData;
	//import flash.geom.Point;
	//import flash.media.Sound;
	//import flash.media.SoundChannel;
	//import flash.media.SoundTransform;
	
	
class Actor extends Sprite {
		
	public var IDLE			:Int = 0;
	public var WALK			:Int;
	public var WALKUP		:Int;
	public var HOP			:Int;
	public var FALL			:Int;
	public var CROUCH		:Int;
	public var JUMP			:Int;
	public var JUMPATTACK0	:Int;	
	public var RUN			:Int;
	public var RUNATTACK0	:Int;
	public var ATTACK0		:Int;
	public var ATTACK1		:Int;
	public var ATTACK2		:Int;
	public var ATTACK3		:Int;
	public var ATTACK4		:Int;
	public var ATTACK5		:Int;
	public var ATTACK6		:Int;
	public var ATTACK7		:Int;
	public var ATTACK8		:Int;
	public var ATTACK9		:Int;
	public var FACEHIT1		:Int;
	public var FACEHIT2		:Int;
	public var KNOCKUP		:Int;
	public var DEADUP		:Int;
	public var RISEUP		:Int;
	public var BACKHIT1		:Int;
	public var BACKHIT2		:Int;		
	public var KNOCKDOWN	:Int;
	public var DEADDOWN		:Int = 22;
	public var RISEDOWN		:Int;
	public var STUN			:Int;
	public var GRAB			:Int;
	public var GRAPPLE		:Int;
	public var GRAPPLE_F 	:Int;
	public var GRAPPLE_B 	:Int;
	public var GRAPPLE_U 	:Int;
	public var GRAPPLE_D 	:Int;
	public var GRABBED		:Int;
	public var GRAPPLED		:Int;
	public var GRAPPLDE_F 	:Int;
	public var GRAPPLED_B 	:Int;
	public var GRAPPLED_U 	:Int;
	public var GRAPPLED_D 	:Int;
	public var DEAD			:Int = 99;
					
		// Attack combos
	public  var grappling		:Bool;	// To prevent movement during grapple
	private var joystick		:Int;
	private var combochain		:Int;
	private var combos			:Array<Dynamic>;
	private var comboarchive	:Array<Dynamic>;
	private var strikecombos	:Array<Dynamic>;	// COULD BE REPLACED BY JUST STATS.
	private var grapplecombos	:Array<Dynamic>;
	private var jumpcombos		:Array<Dynamic>;
	private var crouchcombos	:Array<Dynamic>;
				
	public var bitmaps		:Array<Array<BitmapData>>;
	private var originals	:Array<Array<BitmapData>>;
	private var palette		:Array<Array<UInt>>;
	private var frames		:Array<Array<Int>>; 		// Frame timings
	private var hit			:Array<Array<Int>>;			// Hit frames
	private var hitpow		:Array<Array<Int>>;			// Hit magnitude/power
	private var hitangle	:Array<Array<Int>>;			// Hit angles
	private var hitvx		:Array<Array<Int>>;			// Hit x-velocities
	private var hitvy		:Array<Array<Int>>;			// Hit y-velocities
	private var hitsp		:Array<Array<Int>>;			// Hit stamina damage
	private var hithp		:Array<Array<Int>>;			// Hit health damage
	private var xshift		:Array<Array<Int>>;  		// x displacement
	private var yshift		:Array<Array<Int>>;  		// y displacement
	private var xshove		:Array<Array<Int>>;  		// Add x momentum
	private var yshove		:Array<Array<Int>>;  		// Add y momentum
	private var flip		:Array<Array<Int>>; 		// flip frames
	//private var sfx			:Array<Array<Sound>>;		// sound effects
		
	//public var sfxtransform	:SoundTransform;
	//public var sfxchannel	:SoundChannel;
		
	public  var cpu			:Int;
	public  var hunterpool	:Array<Actor>;	// Targets hunting you
	public  var targetpool	:Array<Actor>;	// Viable targets to choose from
	private var target		:Actor;				// Targeted actor
	private var victim		:Actor;				// Grappled vicitm
	private var grudge		:Actor;				// Preferred target
	private var target_x	:Int;
	private var target_z	:Int;
	private var target_r	:Int;
		
	public var floormap		:Array<Array<Int>>;
	//public var dropzones	:Array<Point>;
		
	//public var lazer		:Bool;
	public var prone		:Bool;
	//public var projectile	:Projectile;
	private var dead		:Int;
		
	//public var floormap		:Array<Array<Int>>;
	public var difficulty	:Int;
		
	public var a			:Int = 0;	// Current animation
	public var _a			:Int = 0;	// Next animation
	public var f			:Int = 0;	// Frame
	//private var w			:Int;	// Frame width
	//private var h			:Int;	// Frame height
		
	public var actor		:Bitmap;
	public var faction		:Int; // O: Main, 1: Ally, 2: Enemy
	//public var ombre		:Ombre;
		
	private var A			:Int = 16;	// ELLIPSE MAJOR AXIS
	private var B			:Int = 4;	// ELLIPSE MINOR AXIS
	//private var AB			:Int = A*B;	// ELLIPSE VARIABLES
	//private var AA			:Int = A*A;	// ELLIPSE VARIABLES
	//private var BB			:Int = B*B;	// ELLIPSE VARIABLES
		
	// Actor Stats
	public  var actorName	:String;
	public  var health		:Int;
	public  var stamina		:Int;
	public  var recovery	:Int;
	private var willpower	:Int;
	private var walkspeed	:Float;
	private var runspeed	:Int;
	private var attackpower	:Int;
	private var jump		:Int;
	private var jumppower	:Int;
	private var zspeed		:Float;
	private var stats		:Dynamic;
		
	// Actor location and movement variables
	public var elevation	:Int;		// ELEVATION OF ACTOR FOOTING
	public var altitude		:Float;	// ALTITUDE OF ACTOR
	//public var locus		:Point = new Point(0,0);
	public var z_axis		:Int;		
	public var vx			:Int;	// Characters X momentum
	public var vy			:Int;	// Characters Y momentum
	public var vz			:Int;	// Characters X momentum
	public var pushx		:Int;	// Pushed by another actor
	public var pushz		:Int;	// Pushed by another actor
	
	// TEMPORARY VARIABLE HOLDERS
	private var tmpxshift	:Int;	// xshift[a][f] holder should declare these when needed = faster
	private var tmpyshift	:Int;	// yshift[a][f] holder
	private var melee		:Int;	// hitframe[a][f] holder
	private var pursue		:Int;	// hitframe[a][f] holder
		
	private var tick		:Int = 0;		
	private var combo		:Int;
		
	// Heath Display
	//public  var healthbar		:HealthBar;
	private var healthdisplay	:Dynamic;
	private var healthtick		:Int;
						
	public var doubletap	:Int;
		
		
	public function new(actorData:Dynamic):Void {
		
		super();
		
		bitmaps	= new Array<Array<BitmapData>>();
		originals = new Array<Array<BitmapData>>();
		frames = new Array<Array<Int>>();
		palette = new Array<Array<UInt>>();
		hit	= new Array<Array<Int>>();
		hitpow = new Array<Array<Int>>();
		hitangle = new Array<Array<Int>>();
		hitvx = new Array<Array<Int>>();
		hitvy = new Array<Array<Int>>();
		hitsp = new Array<Array<Int>>();
		hithp = new Array<Array<Int>>();
		xshift = new Array<Array<Int>>();
		yshift = new Array<Array<Int>>();
		xshove = new Array<Array<Int>>();
		yshove = new Array<Array<Int>>();
		flip = new Array<Array<Int>>();
		
		// Populate local variables with actionData
		var actionData:Dynamic = Reflect.field(actorData, "actions");
		var fields:Array<String> = Reflect.fields(actionData);
		var fieldName:String;
		var index:Int = 1;
		var idx:Int = 0;
		try{
			for (i in 0...fields.length) {
				
				fieldName = fields[i];
				
				if (fieldName.toUpperCase() == "IDLE") {
					idx = 0;
				} else {
					idx = index++;
				}
				
				trace(i + " " + fields[i] + " setting idx to " + idx + " index:" + index);
				Reflect.setField(Reflect.field(actionData, fieldName), "idx", idx);
				Reflect.setField(this, fields[i].toUpperCase(), idx);
				originals[idx] = Reflect.field(Reflect.field(actionData, fieldName), "bitmaps");
				bitmaps[idx] = Reflect.field(Reflect.field(actionData, fieldName), "bitmaps");
				frames[idx]	= Reflect.field(Reflect.field(actionData, fieldName), "timing");
				//palette[index]		= $actor.actions[action].palette;
				hit[idx] = Reflect.field(Reflect.field(actionData, fieldName), "hit");
				hitpow[idx]	= Reflect.field(Reflect.field(actionData, fieldName), "hitpow");
				hitangle[idx] = Reflect.field(Reflect.field(actionData, fieldName), "hitangle");
				hitvx[idx] = Reflect.field(Reflect.field(actionData, fieldName), "hitvx");
				hitvy[idx] = Reflect.field(Reflect.field(actionData, fieldName), "hitvy");
				hitsp[idx] = Reflect.field(Reflect.field(actionData, fieldName), "hitsp");
				hithp[idx] = Reflect.field(Reflect.field(actionData, fieldName), "hithp");
				xshift[idx] = Reflect.field(Reflect.field(actionData, fieldName), "xshift");
				yshift[idx] = Reflect.field(Reflect.field(actionData, fieldName), "yshift");
				xshove[idx] = Reflect.field(Reflect.field(actionData, fieldName), "xshove");
				yshove[idx] = Reflect.field(Reflect.field(actionData, fieldName), "yshove");
				flip[idx] = Reflect.field(Reflect.field(actionData, fieldName), "flip");
				//sfx[index]			= $actor.actions[action].sfx;
			}

		} catch(e:String) {
			trace("unable to set variable " + e);
			return;
		}
		
		var statsData:Dynamic = Reflect.field(actorData, "stats");
		actorName = Reflect.field(statsData, "NAME");
		
		addChild(actor = new Bitmap());
		actor.bitmapData = bitmaps[0][0];
		cacheAsBitmap = true;
	}
	
		//sfx	= new Array<Array<Sound>>(i, true);
		
		/*
		
		
		
		
		// Extract "combos" datafield:stats
		
		
		//if( $actor )
			//{
				
				// Set class variables according to actor frames
				// excluding IDLE, which is const = 0
				var action:*;
				var vars:Dynamic = {"IDLE":0};
				var i:Int = 1;
				for( action in $actor.actions ) {
					if( action != "IDLE" )
					{vars[action] = i; this[action] = i++;}	
					//trace("vars." + action + ": " + vars[action]);
				}
				
				// Clone frame vectors to class variables
				bitmaps		= new Array<Array<BitmapData>>(i, true);
				originals	= new Array<Array<BitmapData>>(i, true);
				frames		= new Array<Array<Int>>(i, true);
				palette		= new Array<Array<UInt>>(i, true);
				hit			= new Array<Array<Int>>(i, true);
				hitmag		= new Array<Array<Int>>(i, true);
				hitangle	= new Array<Array<Int>>(i, true);
				hitvx		= new Array<Array<Int>>(i, true);
				hitvy		= new Array<Array<Int>>(i, true);
				hitsp		= new Array<Array<Int>>(i, true);
				hithp		= new Array<Array<Int>>(i, true);
				xshift		= new Array<Array<Int>>(i, true);
				yshift		= new Array<Array<Int>>(i, true);
				xshove		= new Array<Array<Int>>(i, true);
				yshove		= new Array<Array<Int>>(i, true);
				flip		= new Array<Array<Int>>(i, true);
				sfx			= new Array<Array<Sound>>(i, true);
		
				for( action in $actor.actions ) {
					originals[ this[action] ]	= $actor.actions[action].bitmaps;
					bitmaps[ this[action] ]		= $actor.actions[action].bitmaps.concat();
					frames[ this[action] ]		= $actor.actions[action].timing.concat();
					palette[ this[action] ]		= $actor.actions[action].palette;
					hit[ this[action] ]			= $actor.actions[action].hit;
					hitmag[ this[action] ]		= $actor.actions[action].hitmag;
					hitangle[ this[action] ]	= $actor.actions[action].hitangle;
					hitvx[ this[action] ]		= $actor.actions[action].hitvx.concat();
					hitvy[ this[action] ]		= $actor.actions[action].hitvy.concat();
					hitsp[ this[action] ]		= $actor.actions[action].hitsp;
					hithp[ this[action] ]		= $actor.actions[action].hithp;
					xshift[ this[action] ]		= $actor.actions[action].xshift;
					yshift[ this[action] ]		= $actor.actions[action].yshift;
					xshove[ this[action] ]		= $actor.actions[action].xshove;
					yshove[ this[action] ]		= $actor.actions[action].yshove;
					flip[ this[action] ]		= $actor.actions[action].flip;
					sfx[ this[action] ]			= $actor.actions[action].sfx;
				}
				
				//trace( hit );
				
				// Stats
				stats = $actor.stats;
				regenStats();
				
				// Projectile to local, if it exists
				if( $actor.projectile.length ) {
					var origin:Array;
					i = $actor.projectile.length;
					while( i-- ) {
						if( $actor.projectile[i]=="redlazer") projectile = new Projectile( 0xFFEEB4B4, 0xFFCD0000 );
						else if( $actor.projectile[i]=="bluelazer") projectile = new Projectile( 0xFF00FCF8, 0xFF0094F0);
						else origin = $actor.projectile[i].split("x");
					}
					projectile.setOrigin( origin );
				}
				
				
				// Combos to class variables
				strikecombos	= Parse.combos( vars, $actor.combos.strikecombos );
				grapplecombos	= Parse.combos( vars, $actor.combos.grapplecombos );
				jumpcombos		= Parse.combos( vars, $actor.combos.jumpcombos );
				crouchcombos	= Parse.combos( vars, $actor.combos.crouchcombos );
				
				//trace("Strike: " + strikecombos);
				//trace("Grapple: " + grapplecombos);
				//trace("Jump: " + jumpcombos);
				//trace("Crouch: " + crouchcombos);
				
				
				// Create palette and swap
				palette = $actor.palette;
				bitmaps = Palette.swap( originals, palette, $pal );
				
				
				
				faction = $faction;
				
				
				// Create name / healthbar
				if( $healthdisplay != null )
				{
					healthdisplay = $healthdisplay;
					healthbar = new HealthBar( healthdisplay, faction );
					healthbar.renew( health, actorName, faction );
					healthbar.num = healthdisplay.addBar( healthbar, faction );
				}
				
				// Character Shadow
				ombre = new Ombre( -2 );
				addChild(ombre);
			
			
				// Character bitmap
				actor = new Bitmap();
				actor.bitmapData = bitmaps[a][f];
				actor.x = -actor.bitmapData.width >> 1;
				actor.y = -actor.bitmapData.height + 3;
				h = actor.bitmapData.height;
				addChild(actor);
				
				//trace("frames.WALK " + frames[WALK]);
			
			//}
		}
		
		
		public function addStat( $attackpower:Int, $jumppower:Int ):void
		{	
			var i:Int
			var ii:Int;
						
			// PUNCHPOWER STATISTIC IS A VALUE BETWEEN 1 AND 20
			// RENDERING AN ACTUAL IN-GAME VALUE RANGE IS 0 TO 4 (+ MAGNITUDE);
			if( $attackpower ) {
				var power:Int = (attackpower += $attackpower) * 0.2;
				trace(actorName + " attackpower is " + attackpower + " (" + power + ")");
				i = hitangle.length;
				while(i--) {
					ii = hitangle[i].length;
					while(ii--) {
						if (hitangle[i][ii]) {
							hitvx[i][ii] = (hitmag[i][ii]+power) * (1-hitangle[i][ii]/180);
							hitvy[i][ii] = (hitmag[i][ii]+power) * hitangle[i][ii]/180;
						}
					}
				}
			}
			
			// Adjust jump frames according to jumppower (range 1 through 20)
			// In-game values of 10 to 18 pixels
			if( JUMP && $jumppower )
			{
				var total:Int = 0;
				jump = (jumppower += $jumppower)/5+8;
				for( i = 0; i < frames[JUMP].length; i++) total += frames[JUMP][i];
				for( i = 0; i < (frames[JUMP].length - 1); i++) frames[JUMP][i] = (frames[JUMP][i]/total)*jump*2;
				frames[JUMP][(frames[JUMP].length-1)] = 1000;
			}					
										
		}
			
			
		
		
		
		// Actor Collision Testing and CPU AI ------------------------------------------------------------------------ //	
		public function collisions( $n:Int, $actorpool:Array<Actor> ):void
		{
			
			// Actor is dead and on ground. Blink out and reset
			if( dead && altitude != altitude )
			{
				deathBlink();
				return;
			}
			
			/* Falling to his death
				if( altitude < elevation ) {
					//if( vx < 0 ) x += ++vx
					//else if( vx > 0 ) x+= --vx;
					//if( vz < 0 ) y += ++vz
					x += vx;
					y += vz;
					actor.y += vy++;
					if( actor.y > 300 ) {altitude = elevation; trace(actorName + " fell to his death"); }//resetActor();  }
				} else {
					deathBlink();
				}
				return;
			}*/
			/*
			var old_x:Int = x; 							
			var old_z:Int = y;
						
			// CPU AI -------------------------------------------------------------
			if( cpu ) {
				
				//trace("cpu called");
				// Make new decision
				if( !--cpu ) {
					cpu = Math.random()*60 + 30;	// decision making interval
					
					if( targetpool.length )
					{
						// Determine distance to target and choose to pursue, or remain
						pursue = Math.random()*2;
						
						if( pursue )
						{
							var l:Int = Math.random()*targetpool.length;
							//if( grudge!=null ) Math.random() < 0.2 ? grudge = null : target = grudge;
							if( target==null ) target = targetpool[l];
							target_x = target.x - old_x;
							target_z = target.y - old_z;
							target_r = Math.sqrt(target_x*target_x + target_z*target_z);
														
							trace("targeting: " +target.actorName);		
						} else {
							target_r = 0;
						}
						
					}
				}
				
				
				if( !target_r ) {
					noKey();
				
				//} else if( target_r < 20 ) {	
				//	punchKey();
				
				
				} else {
					target_x = target.x - old_x;
					target_z = target.y - old_z;
					
					if( target_z<-5 ) upKey();
					else if( target_z>5 ) downKey();
					else if( !projectile.visible ) punchKey();
					
					if( target_x < -20 ) leftKey();
					else if( target_x > 20 )  rightKey();
				}
				
				
				
				/* Target is in attack range...
				if( target_r && target_r < 20 ) {		
					
					// Attack target...
					if (!lazer && !Int(Math.random()*20)) {
						target.x < old_x ? scaleX = 1 : scaleX = -1; 
						punchKey();
						n = 0;
				
					// Stop and wait...
					} else if( Math.random() < 0.1 ) {
						joystick = 1;
						forceAnimation(IDLE);
						n = 0;
					}
				}*/
				
				// Continue moving toward target ...
			/*	
				
									
			}
			
			
			var new_x:Int = old_x + vx; 							
			var new_z:Int = old_z + vz;
			var   _vx:Int = vx > 0 ? -1 : vx < 0 ? 1 : 0;
			var   _vz:Int = vz > 0 ? -1 : vz < 0 ? 1 : 0;
			
			var n:Int = 1;
			var x1:Int, y1:Int;
			var test_altitude:Float = altitude != altitude ? elevation : altitude;
			
			
			// Collision detection, if actor is moving --------------------------------------------
			if( vx || vz )
			{ 	
				
				// Actor vs Actor Collisions ...
				n = $actorpool.length;
				while (n--)
				{
					if (n != $n)
					{
						// Calculate distance between actors
						x1 = new_x - $actorpool[n].x;
						y1 = new_z - $actorpool[n].y;
						var r1:Int = Math.sqrt(x1 * x1 + y1 * y1);
						
						if (r1 <= 30)
						{
							var r2:Int = (AB * r1) / Math.sqrt(BB * x1 * x1 + AA * y1 * y1);
							
							// Actor is inside the collision ellipse of another actor
							if (r1 < r2)																	//
							{																				//
								var facingtarget:Int = scaleX + (x <= $actorpool[n].x ? 1 : -1);
								
								// Initiate grapple if attacker can grapple and victim can be grappled
								if( $actorpool[n].a == STUN && facingtarget && GRAPPLE && $actorpool[n].GRAPPLED ) {
									victim = $actorpool[n];
									vx = vy = victim.vx = victim.vy = 0;
									new_x = victim.x - scaleX * 25;
									new_z = victim.y;// + 3;
									forceAnimation(GRAB, GRAPPLE);
									victim.forceAnimation(victim.GRABBED, victim.GRAPPLED);
									victim.stamina = 3;
									victim.recovery = 0;
									victim.scaleX = -scaleX;
									n = 0;									
																
								// Actor is just walking into another character. Push actor to edge of collision ellipse
								} else if( altitude != altitude ) {
									// GOING UP IS QUICKER THAN DOWN INT IS ROUNDED
									new_x = (r2 * x1 / r1) + $actorpool[n].x;	// PUSH INVADER BACK TO				// 
									new_z = (r2 * y1 / r1) + $actorpool[n].y;	// EDGE OF ELLIPSE					//
									if (y1 > 0) new_z++;
								}
							}																				//
						}																					//
					}																						//
				}
			
			
				// Prevent actor from moving outside floormap ...
				if( new_x >= floormap[0].length) {new_x = floormap[0].length - 1; vx = 0;}
				else if( new_x <= 0) {new_x = 0; vx = 0;}
				if( new_z >= floormap.length) {new_z = floormap.length - 1; vz = 0;}
				else if( new_z <= 0) {new_z = 0; vz = 0;}
				
				//trace( floormap.length + " " + new_z);
			
				//if(cpu) trace("3z:"+new_z);
				// Actor vs Environment collisions ...
				if( floormap[new_z][new_x] > test_altitude ) {
				
					LOOP: do {
							
						do {
						
							// Found free spot found while counting back
							if( floormap[new_z][new_x] <= test_altitude ) {
							
								if( !vz ) {
									if( floormap[new_z+1][new_x] <= test_altitude && floormap[new_z-1][new_x] > test_altitude ) ++new_z;
									else if( floormap[new_z-1][new_x] <= test_altitude && floormap[new_z+1][new_x] > test_altitude ) --new_z;
								}
							
								break LOOP;
							}
							new_z += _vz;
								
						} while (old_z + _vz != new_z);
							
						new_z = old_z + vz;
						new_x += _vx;
				
					} while (old_x + _vx != new_x);
				}
			
			
				// Update elevation
				if( elevation != floormap[new_z][new_x] )
				ombre.fadeTo( elevation = floormap[new_z][new_x] );
			}
									
			
			// Collision test for melee strike ...
			if( melee )
			{
				//trace(actorName + " attacking");
				
				// Firing projectile
				if( melee==255 ) {
					projectile.fire();
			
			
				// Beating grappled victim
				} else if( victim != null ) {
					
					victim.grappleDamage( scaleX, hitvx[a][f], hitvy[a][f], hithp[a][f], hitsp[a][f] );
					
					if( victim.prone ) {
						victim = null;
						_a = IDLE;
					}
				
				// Beating another actor
				} else {
				
					n = $actorpool.length;																	//
					while( n-- ) {			
						if (!$actorpool[n].prone && n != $n)																			//
						{				
							y1 = $actorpool[n].y - new_z;
							
							if (-4 <= y1 && y1 <= 4)
							{
								x1 = $actorpool[n].x - new_x;
								if (x1 > 0) {
									x1 -= hit[a][f];
									if (x1 < 5) $actorpool[n].strikeDamage(
																		   scaleX,
																		   hitvx[a][f],
																		   hitvy[a][f],
																		   hithp[a][f],
																		   hitsp[a][f] );
																			
								} else if (x1 < 0) {
									x1 += hit[a][f];
									if (x1 > -5) $actorpool[n].strikeDamage( 
																			scaleX, 
																			hitvx[a][f], 
																			hitvy[a][f], 
																			hithp[a][f], 
																			hitsp[a][f] );
									
								}
							}
						}
					}
				}
				melee = 0;
			
			// ACTOR VS ACTOR PROJECTILE
			}
			
			
			
						
		
			
			
			
		// CHARACTER IS GROUNDED
		if (altitude != altitude)
		{
			// CHARACTER IS NOW FALLING
			if( test_altitude > elevation )
			{
				altitude = test_altitude;
				vy = 0;
				forceAnimation(FALL, _a);
			}
				// REDUCE MOMENTUMS
			else
			{
				if (vx < 0) vx++;
				else if (vx > 0) vx--;
				//else vx = 0;
				if (vz < 0) vz++;
				else if (vz > 0) vz--;
				//else vz = 0;
			}
		}
			
		// CHARACTER IS IN THE AIR
		if( altitude == altitude )
		{
			// UPDATE ALTITUDE
			altitude -= vy;
								
			// CHECK IF CHARACTER HAS LANDED
			if( altitude < elevation ) {
				
				// Character is falling to his death
				if( dead ) {
					altitude = -1;
					actor.y += vy++;
					x = new_x;
					y = new_z;
					z_axis = new_z - 1;//+ elevation;
					//actor.y = -elevation - h + 3;
					if( actor.y > 300 ) {altitude = NaN; trace(actorName + " fell to his death"); }//resetActor();  
					return;
				
				// Character stepped onto bottomless pit, will now fall to his death
				} else if( elevation == -1 ) {
					if( stats.DEATHCRY ) sfxchannel = stats.DEATHCRY.play(0, 0, sfxtransform);
					healthbar.adjust( health = 0, true );
					altitude = -1;
					healthtick = 60;
					cpu = 0;				
					ombre.visible = false;
					dead = 80;
					f = 5;
					return;
					
				
				// Character has been beaten to death
				} else if( health <= 0 ) {
					//if (actorName=="DARTH VADER") sfxchannel = sfx.dead.play(50, 0, sfxtransform);
					healthbar.adjust( health = 0, true );
					forceAnimation( a==KNOCKUP?DEADUP:DEADDOWN, DEAD );// : forceAnimation( DEADDOWN, DEAD );
				
				// Character has fallen, but is still alive
				} else if( stamina <= 0 ) {
					stamina = 3;
					forceAnimation( a==KNOCKUP?DEADUP:DEADDOWN, CROUCH );// : forceAnimation(DEADDOWN, CROUCH);
							
				// Character is landing from a jump or a fall
				} else {				
					forceAnimation( a==FALL?_a==RUN?RUN:IDLE:CROUCH );
					//a == FALL ? _a == RUN ? forceAnimation( RUN ) : forceAnimation( IDLE ) : forceAnimation( CROUCH );
				}
				
				actor.y = -elevation - h + 3;
				altitude = NaN;
				vy = 0;
				ombre.land();
				if( elevation == -100 ) dead=80;
				trace("landing")
				
				
				
			}
			// MOVE ACTOR SPRITE
			else
			{				
				//vy += 2;
				actor.y += vy++;
			}
		}
			
					
		x = new_x;
		y = new_z
		z_axis = new_z + elevation;
	}

		
		
		// Blinking out dead actor
		private function deathBlink():void
		{
			if( --dead ) {
				if( !f-- ) {
				visible ? visible = false : visible = true;
				f = 5;}
			
			} else {
				resetActor();
			}
		}
		
		
		
		
		public function grappleDamage($direction:Int, $vx:Int, $vy:Int, $hp:Int, $sp:Int):void
		{
			// REDUCE HEALTH
			stamina -= $sp;
			health -= $hp;
			combochain = 0;
			
			// REDUCE HEALTH BAR
			healthbar.adjust( health < 1 ? health = 0 : health );
			if( faction == 2 ) healthdisplay.renew( healthbar.num );
			healthtick = 60;
			
			if( stamina < 0 ){
				recovery = 0;
				prone = true;
				altitude = elevation;
				vx = $vx * $direction;
				vy = -$vy;
				
				if( $sp != 255 ) {
					if( $vy < 0 ) {
						frames[KNOCKDOWN][0] = $vy;
						forceAnimation( KNOCKDOWN );
					} else {
						frames[KNOCKUP][0] = $vy;
						forceAnimation( KNOCKUP );
					}
				}
						
			// CHARACTER IS STILL TAKING A BEATING
			}
		}
		
		
		public function strikeDamage($direction:Int, $vx:Int, $vy:Int, $hp:Int, $sp:Int):void
		{
			// RELEASE GRAPPLE VICTIM, IF ANY
			if( victim ) {
				victim.forceAnimation();
				victim = null;
			}
			
			// Reduce health and stamina
			stamina -= $sp;
			health -= $hp;
			combochain = 0;
			
			// Update healthbar
			healthbar.adjust( health < 1 ? health = 0 : health );
			if( faction == 2 ) healthdisplay.renew( healthbar.num );
			healthtick = 60;
			
			// CHARACTER IS KNOCKED DOWN
			if( stamina < 0 ) {
				recovery = 0;
				prone = true;
				altitude = elevation;
				vx = $vx * $direction;
				vy = -$vy;
				
				if( $direction + scaleX ) {
					frames[KNOCKDOWN][0] = $vy;
					forceAnimation( KNOCKDOWN );
				} else {
					frames[KNOCKUP][0] = $vy;
					forceAnimation( KNOCKUP );
				}
			
			// CHARACTER IS STILL TAKING A BEATING
			} else {
				if( stamina > 0 && health > 0 ) {
					willpower = 60 - (stats.WILLPOWER << 1);
					($direction + scaleX) ? forceAnimation(BACKHIT1) : forceAnimation(FACEHIT1);
					
				} else {
					recovery = stats.RECOVERY;
					stamina = willpower = 0;
					($direction + scaleX) ? forceAnimation(BACKHIT2, STUN) : forceAnimation(FACEHIT2, STUN);
				}
			}
			
		}
		
		
				
		// CHANGE ANIMATION
		private function forceAnimation ($a:Int = IDLE, $_a:Int = IDLE, $now:Bool = false):void
		{
			// New animation request
			if( a!=$a )
			{
				//trace("forcing new Animation, reseting tick, a:" + a + ", $a:"+$a);
				f = tick = 0;	// Reset frame time
				a = $a;			// Set new animation
				_a = $_a;
				if( $now ) actor.bitmapData = bitmaps[a][f];
				combochain == 3 ? combochain = 2 : combochain = 0
			}
		}
		
		
		// Simple Animating Preview functions if Character is part of Online Database
		public function endPreview():void
		{
			f = tick = 0;
			actor.bitmapData = bitmaps[0][0];
		}
		
		public function previewing( e:* ):void
		{
			if( tick++ == frames[0][f] )
			{
				tick = 0;
				if (++f == frames[0].length) f = 0;
			}
			
			// If tick is reset, go to next frame
			if( !tick )
			{
				// SHIFT BITMAP PIXELS
				actor.x -= tmpxshift;
				actor.x += (tmpxshift = xshift[0][f]);
				actor.y -= tmpyshift;
				actor.y += (tmpyshift = yshift[0][f]);
				
				// FLIP FRAME
				scaleX *= flip[0][f];
				
				// Update BitmapData
				actor.bitmapData = bitmaps[0][f];
				//cacheAsBitmap = true;
			}
		}
		
		
		
	*/
		
		public function animate():Void {
			
			//trace("tick: " + tick + ", a:" + a + ", f:" + f + ", timing:"+frames[a][f]);
			
			//if( healthbar.visible && faction == 2 && !--healthtick )
			//healthdisplay.remove( healthbar.num );
			
			//if (dead == true) {
			//	return;
			//}
				
						
			// Willpower determines stamina recovery
			// Should decrease as the beating continues I suppose
			// Unimplemented
			//if( willpower > 0) {
			//	if(--willpower == 0) {
			//		if( ++stamina < 3 )
			//		willpower = 60 - (stats.WILLPOWER << 1);
			//	}
			//}

			// If end of frame, go to next frame
			if(tick == frames[a][f]) {
				
				tick = 0;
				
				// Animation turnover
				if (++f == frames[a].length) {
					
					// If stunned, repeat stun animation until recovery time = 0
					if( recovery > 0) {
						if( --recovery > 0) {
							_a = STUN;
						
						} else { 
							_a = IDLE;
							if ( health <= 0 ) {
								stamina = 1;
								//healthbar.adjust( health = 1 );
							} else {
								stamina = 3;
							}
						}
					} 
					
					if( _a == DEAD ) {
						_a = a;
						f = 1;
						tick = dead = 80;
					
					} else {
						combochain = (combochain == 3) ? 2 : 0;
						f = 0;
						a = _a;
						
						//if (_a == CROUCH || RISEUP && _a == RISEUP || RISEDOWN && _a == RISEDOWN) {
						//	prone = false;
						//}
						_a = IDLE;
						//++combo;
					}
										
				}
			}
			
			// IMPLEMENT NEW FRAME IF TICK HAS BEEN RESET
			if ( tick++ == 0) {
				
				// ADD ADDITIONAL X VELOCITY
				vx += Std.int(scaleX * xshove[a][f]);
				
				// ADD ADDITIONAL Y VELOCITY
				if (yshove[a][f] > 0) {
					vy += yshove[a][f];
					if( altitude != altitude ) altitude = elevation;
				}
				
				// SHIFT BITMAP PIXELS
				actor.x -= tmpxshift;
				actor.x += (tmpxshift = xshift[a][f]);
				actor.y -= tmpyshift;
				actor.y += (tmpyshift = yshift[a][f]);
				
				// FLIP FRAME
				scaleX *= flip[a][f];
				
				// HIT FRAME
				melee = hit[a][f];
				//hit[a][f] == 255 ? shoot = 255 : melee = hit[a][f];
				
				// PLAY SFX
				//if( sfx[a][f] != null )
				//sfxchannel = sfx[a][f].play( 0, 0, sfxtransform );
				
				// UPDATE BITMAPDATA
				actor.bitmapData = bitmaps[a][f];
			}
		}
		
		/*
				
		public function noKey() :void
		{
			//trace("nokey");
			joystick = 1;
			switch( a )
			{
				case WALK:
				case RUN:	forceAnimation(); break;
			}
		}
		
		public function rightKey():void {
			if( doubletap==2 ) {
				doubletap=0;
				switch( a ) {
					case IDLE:
					case WALK:
					case RUN :	xMove( runspeed, 1, RUN );	break;
					//case JUMP:  if (xmomentum = 0) xMove (1,1,JUMP); break;
				}
			} else {
				switch( a ) {
					case IDLE:
					case WALK: xMove( walkspeed, 1, WALK ); 	break;
					case RUN : xMove( runspeed, 1, RUN );		break;
					case JUMP: if( !vx ) xMove( 1, 1, JUMP );	break;
				}
				//else if (a == 4)	xMove (speed,1,JUMPATTACK);//JUMP / JUMPATTACK / JUMPKICK
				//else if (a == 5)	xMove (speed,1,JUMPKICK);//JUMP / JUMPATTACK / JUMPKICK
			}
			scaleX == 1 ? joystick = 3 : joystick = 2;
		}
		
		public function leftKey():void {
			if( doubletap==-2 ) {
				doubletap=0;
				switch( a ) {
					case IDLE:
					case WALK:
					case RUN : xMove( -runspeed, -1, RUN ); break;
				}
			} else {
				switch( a ) {
					case IDLE:
					case WALK: xMove( -walkspeed, -1, WALK ); 	break;
					case RUN : xMove( -runspeed, -1, RUN ); 	break;
					case JUMP: if( !vx ) xMove( -1, -1, JUMP );	break;
				}
				//else if (a == 4)	xMove (speed,0,-1,4);//JUMP / JUMPATTACK / JUMPKICK
				//else if (a == 5)	xMove (speed,0,-1,5);//JUMP / JUMPATTACK / JUMPKICK
			}
			scaleX == -1 ? joystick = 3 : joystick = 2;
		}
		
		public function upKey():void
		{
			joystick = 4;
			switch( a ) {
				case IDLE:
				case WALK: 		zMove( -zspeed, WALK ); break;
				case RUN : 		zMove( -zspeed, RUN );	break;
				case JUMP: 		vz = -zspeed;			break;
				//case JUMPATTACK:	zMove (-zspeed,JUMPATTACK);	break;
				//case JUMPKICK:  zMove (-zspeed,JUMPKICK);	break;
			}
		}
		
		public function downKey():void
		{
			joystick = 5;
			switch( a )
			{
				case IDLE:
				case WALK: 	zMove( zspeed, WALK ); 	break;
				case RUN : 	zMove( zspeed, RUN );	break;
				case JUMP: 	vz = zspeed;			break;
			//case JUMPATTACK:	zMove (zspeed,JUMPATTACK);	break;
			//case JUMPKICK:  zMove (zspeed,JUMPKICK);	break;
			}
		}
		
		public function punchKey():void
		{
			if( combochain == 2 ) {
				// CAN ONLY REPEAT STRIKING COMBOS INFINITELY, HALT ALL OTHERS IF COMBO SUCCESSOR NOT FOUND
				combochain = 3;
				combos[ joystick ] ? combos = combos[joystick] : combos[1] ? combos = combos[1] : comboarchive[joystick] ? combos = comboarchive[joystick] : combos = comboarchive[1];
				_a = combos[0];
				if( victim ) victim._a = _a + 5; // DEPRECIATED!!!!!
				//trace("STAMINA " + victim.stamina);
				//if (victim) trace("VICTIM" + victim.elevation);
					
			} else if( combochain == 0 ) {
				
				switch( a ) {
					case IDLE:
					case WALK:
					case WALKUP:
						
						if( strikecombos.length ) {
							combos = comboarchive = strikecombos;
							comboarchive[joystick] ? combos = comboarchive[joystick] : combos = comboarchive[1];
							combochain = 3;
							forceAnimation(combos[0], IDLE);
						} break;
						
					case GRAPPLE:
					
						if( grapplecombos.length ) {
							combos = comboarchive = grapplecombos;
							comboarchive[joystick] ? combos = comboarchive[joystick] : combos = comboarchive[1];
							combochain = 3;
							forceAnimation(combos[0], GRAPPLE);
							victim.forceAnimation(a + 5, GRAPPLED);
						} break;
						
					case JUMP:
					
						if( jumpcombos.length ) {
							combos = comboarchive = jumpcombos;
							comboarchive[joystick] ? combos = comboarchive[joystick] : combos = comboarchive[1];
							combochain = 3;
							forceAnimation(combos[0], FALL);
						} break;
						
					case CROUCH:
					
						if( crouchcombos.length ) {
							combos = comboarchive = crouchcombos;
							comboarchive[joystick] ? combos = comboarchive[joystick] : combos = comboarchive[1];
							combochain = 2;
							_a = combos[0];
						} break;
				}
			}
				
		}
		
				
		public function jumpKey() :void
		{
			if( JUMP && altitude != altitude )
			{
				switch( a )
				{
					case IDLE:
					case WALK:
					case RUN:
						if (vx < 0) vx-=2;		// GIVE X MOMENTUM A TINY BOOST
						else if (vx > 0) vx+=2; 	// GIVE X MOMENTUM A TINY BOOST
						vy = -jump;
						altitude = elevation;
						forceAnimation(JUMP, CROUCH);
				}
			}
		}
		
		
		private function xMove( $speed:Float, $scaleX:Int, $animation:Int ):void
		{
			vx = $speed;
			scaleX = $scaleX;
			forceAnimation( _a = $animation );
		}
		
		private function yMove( $speed:Float, $scale:Int, $animation:Int ):void
		{
			scaleX = $scale;
			y += $speed;
			forceAnimation( _a = $animation );
		}
		
		private function zMove( $speed:Float, $animation:Int ):void
		{
			vz = $speed;
			forceAnimation( _a = $animation );
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
/*
		private function parseCombos (o:Dynamic) :void {
			
			//PARSE COMBOS INTO FORMAT P:ATTACK1, K:KICK1, P:ATTACK1 P:RIGHTCROSS, 
			var combosArray:Array = [];
			for (var i:* in o) {
				var a:Array = i.toLowerCase().split("");
				var m:Array = o[i].split(" ").join("").split(",");
				for (var j:Int = 0; j < a.length; j++) {
					if (a[j]=="u" || a[j]=="r" || a[j]=="d") {
						var s:String = a.splice(j, 1);
						a[j] = s + a[j];
					}
				}
				var s2:String = a[0] + ":" + m[0];
				for (j = 1; j < a.length; j++) s2 += " " + a[j] + ":" + m[j];
				combosArray.push(s2);
			}
			
			
			trace(combosArray);
			//combo[0] = ATTACK1
		}*/
		
		
		
	/*
		
		// STILL USED FOR PROJECTILES
		public function isHit( $direction:Int, $sdmg:Int = 1, $hdmg:Int = 1):void
		{
			// REDUCE HEALTH BAR
			health -= $hdmg;
			healthbar.adjust( health < 1 ? health = 0 : health );
			if (faction == 2) healthdisplay.renew( healthbar.num );
			healthtick = 60;
			
					
			if( !stamina ){//a == STUN) {
				recovery = 0;
				prone = true;
				altitude = elevation;
				vy = -4;
				if( $direction + scaleX ) {
					vx = 3 * $direction;
					frames[KNOCKDOWN][0] = -vy;
					forceAnimation(KNOCKDOWN);
				} else {
					vx = 4 * $direction;
					frames[KNOCKUP][0] = -vy;
					forceAnimation(KNOCKUP);
				}
			
			} else {
				stamina -= $sdmg;
				if (stamina > 0 && health > 0){
					willpower = 60 - (stats.WILLPOWER << 1);
					($direction + scaleX) ? forceAnimation(BACKHIT1) : forceAnimation(FACEHIT1);
					
				} else {
					recovery = stats.RECOVERY;
					stamina = willpower = 0;
					($direction + scaleX) ? forceAnimation(BACKHIT2, STUN) : forceAnimation(FACEHIT2, STUN);
				}
			}
		}
		
		
		
		
		
		public function resetActor():void
		{
			// swap in random palette
			bitmaps = Palette.swap( originals, palette );
			
			regenStats();
			altitude = 100;
						
			// Reset healthbar with random name and amount of health
			if( faction==2 ) {
				healthbar.renew( health = Int(Math.random()*14)+4, actorName, faction );
				healthbar.visible = false;
			} else {
				healthbar.renew( health, actorName, faction );
				healthbar.visible = true;
			}
			
			var pt:Int = dropzones.length*Math.random();
			x = dropzones[pt].x;
			y = dropzones[pt].y;
			
			ombre.renew( elevation = floormap[y][x] );
			
			vx = vy = vz = 0;
			
			if( faction ) cpu = cpu = Math.random()*60 + 30;
			
			z_axis = elevation + y;
			
			actor.y -= altitude;
			a = FALL;
			visible = ombre.visible = true
		}
		
		private function regenStats():void
		{
			// Reset Stats...
			actorName	= stats.NAME is Array ? stats.NAME[Int(Math.random()*stats.NAME.length)] : stats.NAME;
			health		= stats.HEALTH;
			stamina 	= 3;
			walkspeed	= stats.WALKSPEED;
			zspeed		= 1;
			runspeed	= stats.RUNSPEED;
			attackpower	= stats.ATTACKPOWER;
			jumppower	= stats.JUMPPOWER;
			willpower	= 0;
			recovery	= 0;
			
			trace(actorName + " JUMP: "+ JUMP);
			
			// Adjust jump frames according to jumppower
			if( JUMP )
			{
				jump = jumppower*0.2+8;
				var total:Int = 0;
				for (var i:Int = 0; i < frames[JUMP].length; i++) total += frames[JUMP][i];
				for(i = 0; i < (frames[JUMP].length - 1); i++) frames[JUMP][i] = (frames[JUMP][i]/total)*jump*2;
				frames[JUMP][(frames[JUMP].length-1)] = 1000;
			}
			
			// Adjust hit velocities
			var power:Float = attackpower * 0.2;
			i = hitmag.length;
			while(i--) {
				var ii:Int = hitmag[i].length;
				while(ii--) {
					if( hitmag[i][ii] ) {
						hitvx[i][ii] = (hitmag[i][ii]+power) * (1-hitangle[i][ii]/180);
						hitvy[i][ii] = (hitmag[i][ii]+power) * hitangle[i][ii]/180;
					}
				}
			}
						
			// Regen Variables
			prone = false;
			//lazer = false;
			dead = melee = elevation = pursue = tick = a = _a = f = vx = vy = 0;
			vy = NaN;
		}
		
		
		
		public function paletteSwap( $pal:Int = -1 ):void
		{
			bitmaps = Palette.swap( originals, palette, $pal );
		}
	*/	
		
	
}

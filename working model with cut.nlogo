breed[ red-blood r-cell]
breed[ white-blood w-cell]
breed[ platelets platelet]
breed[ viruses virus]
breed[ antibodies antibody]
breed[ cuts cut]
turtles-own [age]
globals[ 
  txcor tycor]

to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
 
  __clear-all-and-reset-ticks
  ask patches [if pxcor < 10 and pxcor > -10 and pycor < 10 and pycor > -10 [set pcolor brown]]
  ask patches [ if pxcor < 4 and pxcor > -4 and pycor < 29 and pycor > 20 [ set pcolor 124]]
  ask patches [ if pxcor < 4 and pxcor > -4 and pycor > -29 and pycor < -20 [ set pcolor 13]]

  set-default-shape red-blood "circle"
   create-red-blood 2100
    [ set color red
      set size .5
      set age random (120)
      setxy random-xcor random-ycor ]
  set-default-shape white-blood "circle"
    create-white-blood 3
    [ set color white
      set size 2
      set age random (1460)
      setxy random-xcor random-ycor ]
    set-default-shape platelets "pentagon"
    create-platelets 120
    [ set color orange
      set size 1
      set age random (6)
      setxy random-xcor random-ycor ]
    create-antibodies 20
    [set color yellow
      set size 1.5
      set age random (10)
      setxy random-xcor random-ycor
    ]
      set-default-shape antibodies "default"
end

to go
  if count turtles = 0 [stop]
  ask red-blood
  [
    setcolor
    avoidcollision
    setheading
    bleed
    move
    set age age + 1
    death
  ]
  ask white-blood
  [
    avoidcollision
    setheading
    move
    heal
    find
    move
    heal
    find
    move
    heal
    find
    set age age + 1
    death
  ]
  ask antibodies
  [
    avoidcollision
    setheading
    hunt
    move
    hunt
    move
    hunt 
    move
    set age age + 1
    death
  ]
  ask platelets
  [
    avoidcollision
    setheading
    clog
    move
    set age age + 1
    death
  ]
  ask viruses 
  [
    avoidcollision
    kill
    setheading
    virusspread
    move 
    set age age + 1
    death
  ]    
  
  produce  
  tick  
end

to move
  fd 1
  if pcolor = brown
  [
    back 1
  ]
  
end

to death
  ask red-blood 
  [  if age > (120)[die]]
  ask white-blood
  [ if age > (1460) [die]]
  ask platelets
  [ if age > (6) [die]]
  ask viruses 
  [if age > (120) [die]]
  ask antibodies
  [if age > (25) [die]]
  ask cuts
  [if age > (cut-age) [die]]
end

to produce
  set-default-shape red-blood "circle"
  create-red-blood (red-cell-production-rate)
      [ set color red
      set size .5
      set age 0
        ifelse random 2 = 1
      [
      setxy (random 22 + 10) random-ycor
      ]
      [
        setxy (random 22 - 32) random-ycor
      ]      
       ]
  set-default-shape white-blood "circle"
    if ticks mod (white-cell-production-rate) = 0
    [ create-white-blood 1
     [ set color white
       set size 2
       set age 0
        ifelse random 2 = 1
      [
      setxy (random 22 + 10) random-ycor
      ]
      [
        setxy (random 22 - 32) random-ycor
      ]      
       ]
        ] 
  set-default-shape antibodies "default"
  create-antibodies 0
  [ set color yellow
    set size 1.5
    set age 0
  ]
   
    set-default-shape platelets "pentagon"
    create-platelets (platelet-production-rate)
    [ set color orange
      set size 1
      set age 0
      ifelse random 2 = 1
      [
      setxy (random 22 + 10) random-ycor
      ]
      [
        setxy (random 22 - 32) random-ycor
      ]      
       ]
    set-default-shape viruses "x" 
    if random virus-production-rate = 1
    [create-viruses 1
      [
     set color green
      set size 1.5
      set age 0
        ifelse random 2 = 1
      [
      setxy (random 22 + 10) random-ycor
      ]
      [
        setxy (random 22 - 32) random-ycor
      ]      
       ]      
    ]
   
end

to setheading
  if xcor > 0 and (ycor) < xcor and (ycor) > (xcor * -1)
  [ set heading (-20 + random 40)
  ]
  if (ycor) >= xcor and (ycor) > (xcor * -1)
  [ set heading (250 + random 40)
  ]
  if xcor <= 0 and ycor > xcor and ycor < (xcor * -1)
  [ set heading (160 + random 40)
  ]
  if ycor < xcor and ycor < (xcor * -1)
  [ set heading (70 + random 40)
  ]
 
end

to setcolor
  if xcor > 0 
  [ set color red
  ]
  if xcor <= 0 
  [ set color blue
  ]
end

to avoidcollision
  if pcolor = brown
  [
    if xcor > 0 and (ycor) < xcor and (ycor) > (xcor * -1)
    [ 
      set xcor (random 22 + 10)
    ]
    if (ycor) >= xcor and (ycor) > (xcor * -1)
    [ 
      set ycor (random 22 + 10)
    ]
    if xcor <= 0 and ycor > xcor and ycor < (xcor * -1)
    [
      set xcor (random 22 - 32)
    ]
    if ycor < xcor and ycor < (xcor * -1)
    [ 
      set ycor (random 22 - 32)
    ]
  ]
end

to virusspread
  if random (virus-spread-rate) = 1
  [ hatch 3 ]
end
     

to hunt
  ask antibodies
  [
  if any? viruses in-radius 10
 [ face one-of viruses in-radius 10 
 ]  ]
end

to find
  ask white-blood
   [
  if any? viruses in-radius 15
 [ face one-of viruses in-radius 15
 ]  ]
   end
   
to kill
  ask viruses
 [ if any? antibodies in-radius 1
  [
    set txcor xcor
    set tycor ycor
    die
  ]
 ]
 ask antibodies
   [if abs (xcor - txcor) < 2
    [if abs (ycor - tycor) < 2
  [die
  ]
 ]
 ]
end

to heal  
  ask white-blood
  [
    if any? viruses in-radius 12
  [hatch-antibodies random 3
    [set color yellow
    set size 1.5
    set age random 25]
  ]
  ]
end 
to scratch
  set-default-shape cuts "square"
  create-cuts 1
 [set size 7
   set age 0
   set color 123
   set heading 90
   set xcor 20
   ;; ((random 64) - 32) 
   set ycor 10
   ;;((random 64) - 32)
 ]
create-cuts 1
 [set size 7
   set age 0
   set color 123
   set heading 90
   set xcor 20
   ;; ((random 64) - 32) 
   set ycor 12
   ;;((random 64) - 32)
 ]
 create-cuts 1
 [set size 7
   set age 0
   set color 123
   set heading 90
   set xcor 20
   ;; ((random 64) - 32) 
   set ycor 14
   ;;((random 64) - 32)
 ]
 create-cuts 1
 [set size 7
   set age 0
   set color 123
   set heading 90
   set xcor 20
   ;; ((random 64) - 32) 
   set ycor 16
   ;;((random 64) - 32)
 ]
 create-cuts 1
 [set size 7
   set age 0
   set color 123
   set heading 90
   set xcor 20
   ;; ((random 64) - 32) 
   set ycor 18
   ;;((random 64) - 32)
 ]
end

to medicine
  create-antibodies 20
 [ set color yellow
      set size 1.5
      set age random (10)
      setxy random-xcor random-ycor
 ]
end

to bleed
  if any? cuts in-radius 3
  [
    face one-of cuts
  ]
  if any? cuts in-radius 1
  [
    die
  ]
end

to clog
  if any? cuts in-radius 10
  [
    face one-of cuts
  ]
  if any? cuts in-radius 1
  [
    ask one-of cuts in-radius 1
    [set age age + 1
    ]
    die
  ]
end
;; Correct Ratios of production
;; Red: 18, Platelets: 18, White : 486
 
 

 
@#$#@#$#@
GRAPHICS-WINDOW
209
15
1064
891
32
32
13.0
1
10
1
1
1
0
0
0
1
-32
32
-32
32
0
0
1
ticks
30.0

BUTTON
34
33
97
66
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
118
33
181
66
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1080
17
1565
347
Healthy Blood Count
NIL
NIL
0.0
1000.0
0.0
4000.0
false
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot count red-blood"
"pen-1" 1.0 0 -7500403 true "" "plot count white-blood"
"pen-2" 1.0 0 -955883 true "" "plot count platelets"
"pen-3" 1.0 0 -14439633 true "" "plot count antibodies"
"pen-4" 1.0 0 -6459832 true "" ""

SLIDER
3
73
204
106
red-cell-production-rate
red-cell-production-rate
1
40
18
1
1
NIL
HORIZONTAL

SLIDER
3
110
203
143
platelet-production-rate
platelet-production-rate
1
40
18
1
1
NIL
HORIZONTAL

SLIDER
4
150
202
183
white-cell-production-rate
white-cell-production-rate
1
486
486
1
1
NIL
HORIZONTAL

SLIDER
8
196
180
229
Virus-spread-rate
Virus-spread-rate
0
100
100
1
1
NIL
HORIZONTAL

SLIDER
15
246
199
279
virus-production-rate
virus-production-rate
0
100
100
1
1
NIL
HORIZONTAL

PLOT
1079
358
1568
638
Viruses
NIL
NIL
0.0
500.0
0.0
50.0
true
false
"" ""
PENS
"default" 1.0 0 -14439633 true "" "plot count viruses"

BUTTON
19
298
82
331
Cut
scratch
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
104
302
192
335
Medicine
medicine
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1079
649
1567
898
virus hunters
NIL
NIL
0.0
300.0
0.0
30.0
true
false
"" ""
PENS
"default" 1.0 0 -14439633 true "" "plot count antibodies"
"pen-1" 1.0 0 -16449023 true "" "plot count white-blood"

SLIDER
15
352
187
385
cut-age
cut-age
0
10
6
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS THE MODEL?

Our model is based on a section of a healthy blood system.
## HOW DOES IT WORK

Our model is based on simple rules that every agent follows. Each agent is a type of cell that is naturaly occuring in a healthy blood system. 

The simple rules that we gave our agents are:
1) Agents move in our model based on numbers and headings we give based on their position in the netlogo world (see example 1). 
2) Agents are given a production and death rate based on our research.
3) Red blood cells are programed to change color in order to illustrate the oxygen content in a blood system.
4) White blood cell agents are given simple rules to create antibodies when they detect a virus in the area.
5) Antibody agents are given simple rules to hunt down, and kill, any virus that comes within a certain radius.
![example](file:example1.png)
		EXAMPLE 1

Each agent is supposed to represent and function as it would in a healthy blood system.
## HOW TO USE IT

Set up: creates all agents and colors patches accordingly
Go: starts the model
Sliders: 
	Red-cell-production-rate: controls the reproduction rate of red blood cells (directly proportional)
	Platelet-production-rate: controls the production rate of platelets 
(directly proportional)
	White-cell-production-rate: controls the reproduction rate of white blood cells (inversely proportional)
	Virus-spread-rate: controls the rate at which a virus spreads once created (inversely proportional)
	virus-production-rate: controls the production rate of viruses
(inversely proportional)
	
	

## THINGS TO NOTICE

The agents circulate counter-clockwise
Blood cells turn blue as they drop off oxygen
Blood cells turn red as they get loaded with blood
The world is square

## THINGS TO TRY

Changing the sliders will change the ratio of healthy blood

## EXTENDING THE MODEL

We would like to add more viruses and different ways the body reacts to these viruses.

## CREDITS AND REFERENCES

blood transfusion rejection website:
http://www.nlm.nih.gov/medlineplus/ency/article/001303.htm
asprin model
http://en.wikipedia.org/wiki/Aspirin

This section could contain a reference to the model's URL on the web if it has one, as well as any other necessary credits or references.
http://www.americasblood.org/go.cfm?do=page.view&pid=12
http://users.rcn.com/jkimball.ma.ultranet/BiologyPages/B/Blood.html

## CURRENT OBJECTIVES
compair with other blood models
get sources
medicine
create power point
write final report
make report board
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 135 255 255

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rectangle
false
0
Rectangle -6459832 true false 135 15 165 285

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
true
0
Rectangle -7500403 true true 90 90 210 210

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

y
true
0
Line -1184463 false 75 45 150 150
Line -1184463 false 150 150 225 45
Line -1184463 false 150 150 150 240
Line -1184463 false 75 45 150 150
Line -1184463 false 75 45 150 150
Line -1184463 false 75 45 150 150
Line -1184463 false 75 45 150 150
Line -1184463 false 75 45 150 150
Line -1184463 false 75 45 150 150
Line -1184463 false 75 45 150 150
Line -1184463 false 75 45 150 150
Line -1184463 false 75 45 150 150
Line -1184463 false 75 45 150 150
Line -1184463 false 75 45 150 150
Line -1184463 false 75 45 150 150
Line -1184463 false 90 45 165 150
Line -1184463 false 90 45 165 150
Line -1184463 false 60 45 135 150
Line -1184463 false 60 45 135 150

@#$#@#$#@
NetLogo 5.0RC4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="300"/>
    <exitCondition>ticks = 100</exitCondition>
    <metric>count red-blood</metric>
    <metric>count white-blood</metric>
    <metric>count platelets</metric>
    <steppedValueSet variable="cut-age" first="1" step="1" last="10"/>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@

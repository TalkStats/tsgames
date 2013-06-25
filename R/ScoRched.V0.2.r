########################################################################
#  ScoRched.V0.2.r
#  
#  Copyright 2013 Marco Visser <marco.d.visser@gmail.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
########################################################################  

#type scoRched to pley!

scoRched=function(fps=45,mass=1){

	.plot_menu()

	#choose game
	cat("\n","Choose menu item","\n") # prompt
	userchoice<-scan(n=1,what = double(0),quiet=T)
	availablegames=c(".rungame",".rungame",
	".rungame")
	wordlist=get(availablegames[userchoice])
	# initialize game
	print("Game start")
	.rungame(fps=fps,mass=mass)
}

.plot_menu=function(){
par(mar=c(0,0,0,0),bg="black",fg="white")
plot(0,0,ylim=c(-1,1),xlim=c(-1,1),type='n',
xaxt='n',yaxt='n')

	menulist=c(
	"Welcome to scoRched! v. 0.2",
	"scoRched is a clone of",
	"scorched earth classic by Wendell Hicken",
	"MENU: choose from the following",
	"(in order of difficulty)",
	"1) Flat world, earth gravity, no wind",
	"2) NOT AVAILABLE YET",
	"",
	"version 0.2 by Marco Visser")

	x=c(0,0,0,0,0,0,0,0,0)
	y=c(0.8,0.7,0.6,0.2,0.1,-0.2,-0.4,-0.6,-0.9)
	sizelist=c(1.2,0.9,0.9,1.1,1,1,1,1,0.7)
	text(x,y,menulist,cex=sizelist,col='white')
}

#Make play field v 0.1
.makeplyfld=function(limits=c(0,2000,0,300),landh=10){
# limits = level limits
# landh= land height
par(xaxt='n',yaxt='n',mar=c(1,1,1,1),fg='black',bg='white')
plot(0,0,col='white',xlim=limits[1:2],ylim=limits[3:4])
#sky
adj=-1e6
polygon(x=c(limits[1]+adj,limits[1]+adj,limits[2]-adj,limits[2]-adj),
y=c(limits[3]-adj,limits[3]+adj,limits[3]+adj,limits[3]-adj),
col='lightblue')
adj=-1000
#ground (not interactive yet)
polygon(x=c(limits[1]+adj,limits[1]+adj,limits[2]-adj,limits[2]-adj),
y=c(limits[3]+adj,limits[3]+landh,limits[3]+landh,limits[3]+adj),
col='green')

# place base player
points(0,landh,pch=17,col="blue")
# place base AI
points(2000,landh,pch=17,col="red")

}

#trajectory of projectile
.traproj=function(r,h0=1,a=10,g=9.81,v=100,w=-10,mass=1){
# r distance
# h0 = initial height
# a = angle of launch, in degrees
# g = gravitational constant (9.81 on earth)
# v launch velocity
# w = wind factor
# mass = projectile mass
a=a*(pi/180)
h0+{r*tan(a)}-{(g*mass*r^2)/(2*(v*cos(a))^2)}
}

# distance projectile flew
.projd=function(v=100,a=10,h0=10,g=9.81,mass=1){
#parameters as in traproj
a=a*(pi/180)
{(v*cos(a))/(g*mass)}*{v*sin(a)+sqrt(((v*sin(a))^2)+2*(g*mass)*h0)} 
}

# animate shot
.anishot=function(limits=c(0,2000,0,300),landh=10,
h0=1,a=10,g=9.81,v=100,w=-10,mass=1,aniframes=50,player='player'){

if(player=="player"){
impactd=.projd(v=v,a=a,h0=h0-landh,g=g,mass=mass)
frames=seq(1,impactd,impactd/aniframes)
for(i in frames){
curve(.traproj(x,h0=h0+landh,a=a,g=g,v=v,w=w,mass=mass),0,i,add=T)
Sys.sleep(1/aniframes)
}
explosion(impactd,landh,r=10*mass)
Sys.sleep(1)
}

if(player=="AI"){
if(.projd(v=v,a=a,h0=h0-landh,g=g,mass=mass)<=limits[2]){
impactd=limits[2]-.projd(v=v,a=a,h0=h0-landh,g=g)
frames=seq(impactd,limits[2],impactd/aniframes)
n=length(frames)
for(i in frames[n:1]){
curve(.traproj(x-impactd,h0=h0+landh,a=a,g=g,v=v,w=w,mass=mass),i,2010,add=T)
Sys.sleep(0.6/aniframes)
}
explosion(impactd,landh,r=10*mass)
Sys.sleep(1)
}
}

}

# 'smart' AI shot handler

# animate shot
.AIanishot=function(impactdata,limits=c(0,2000,0,300),landh=10,
h0=1,a=10,g=9.81,v=100,w=-10,mass=1,aniframes=50){

# AI decision making 
if(is.null(impactdata)){

if(.projd(v=v,a=a,h0=h0-landh,g=g,mass=mass)<=limits[2]){
impactd=limits[2]-.projd(v=v,a=a,h0=h0-landh,g=g)
frames=seq(impactd,limits[2],impactd/aniframes)
n=length(frames)
for(i in frames[n:1]){
curve(.traproj(x-impactd,h0=h0+landh,a=a,g=g,v=v,w=w,mass=mass),i,2010,add=T)
Sys.sleep(0.6/aniframes)
}
explosion(impactd,landh,r=10*mass)
Sys.sleep(1)
}
}

}



#fire function by Weicheng Zhu the R package animation 2.0-0. 
.fire=function(centre = c(0, 0), r = 1:5, theta = seq(0, 2 * pi, length = 100), l.col = rgb(1, 1, 0), lwd = 5, ...) {
        x <- centre[1] + outer(r, theta, function(r, theta) r * sin(theta))
        y <- centre[2] + outer(r, theta, function(r, theta) r * cos(theta))
        matplot(x, y, type = "l", lty = 1, col = l.col, add = T, lwd = lwd, ...)
    }


explosion=function(x,y,r=10){
# explosion graphic
# x = x location
# y = y location
# r - radius
.fire(centre=c(x,y),r=1:r,l.col=heat.colors(100)
,theta = seq(-pi/2, pi/2, length = 40))
}

# run game 

.rungame=function(landh=10,g=9.81,r=10,fps=10,mass=1){
hit=FALSE
h0=1
landh=10
while(hit==FALSE){
#starts game
.makeplyfld(landh=10)
#choose angle in degrees
cat("\n","Choose angle (degrees [0,90])","\n") # prompt
usera<-scan(n=1,what = double(0),quiet=T)
# Power
cat("\n","Choose power ([1,300])","\n") # prompt
userv<-scan(n=1,what = double(0),quiet=T)
#animate shot
.anishot(v=userv,a=usera,aniframes=fps,mass=mass)
# did the player hit the enemy?
hitd=.projd(v=userv,a=usera,h0=h0-landh,g=g)
hitradius=10*mass
hit=ifelse((hitd>2000-hitradius)&(hitd<2000+hitradius),TRUE,FALSE)
if(hit==FALSE) {text(1000,200,"PLAYER MIS!",col="RED")}
if(hit==TRUE){text(1000,200,"PLAYER WIN",col="darkgreen");break}
Sys.sleep(1.5)
# Enemy's turn
.makeplyfld(landh=10)
curve(.traproj(x,a=usera,v=userv,h0=h0+landh,mass=mass),
col='gray50',add=T,lty='dotted')
AIa=runif(1,20,45)
AIv=runif(1,100,200)

.anishot(v=AIv,a=AIa,player="AI",aniframes=fps,mass=mass)
# did the AI hit the player?
hitradius=10*mass
hitd=.projd(v=userv,a=usera,h0=h0-landh,g=g)
hit=ifelse((hitd>2000-hitradius)&(hitd<2000+hitradius),TRUE,FALSE)

if(hit==FALSE) {text(1000,200,"A.I. MIS!",col="darkgreen")}
Sys.sleep(1.5)

if(hit==TRUE){
text(1000,200,"A.I. WIN",col="RED")
break}

}

}


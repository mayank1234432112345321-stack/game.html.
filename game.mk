
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Royal Ball Casino</title>
<style>
*{box-sizing:border-box}
body{
 margin:0;min-height:100vh;color:white;
 font-family:Arial,sans-serif;text-align:center;
 background:radial-gradient(ellipse at top,#253c32,#080d0c 70%);
}
header{padding:25px 12px}
h1{
 color:#f5d47b;font-size:35px;
 text-shadow:0 0 20px #c99b39;
 margin:5px;
}
.sub{color:#b8b8b8;letter-spacing:3px;font-size:11px}
.panel{
 max-width:850px;margin:15px auto;padding:25px 15px;
 background:linear-gradient(145deg,#17251f,#101714);
 border:1px solid #94732e;border-radius:20px;
 box-shadow:0 0 35px #0009;
}
h2{color:#f5d47b;font-size:19px}
.balls{
 display:flex;justify-content:center;flex-wrap:wrap;gap:18px;
 margin:25px 0;
}
.ball{
 width:65px;height:65px;border-radius:50%;
 border:3px solid #ffffff55;cursor:pointer;
 box-shadow:inset -9px -9px 15px #0008,
 inset 7px 7px 12px #ffffff77,0 5px 15px #0008;
 transition:.2s;
}
.ball:hover{transform:translateY(-7px) scale(1.08)}
.ball.selected{
 outline:3px solid #f5d47b;
 outline-offset:6px;transform:scale(1.1);
}
.red{background:radial-gradient(circle at 30% 25%,#ff9999,#d50000 65%,#620000)}
.yellow{background:radial-gradient(circle at 30% 25%,#fff5ad,#ffc400 65%,#986400)}
.blue{background:radial-gradient(circle at 30% 25%,#a6d8ff,#0875e5 65%,#052a70)}
.green{background:radial-gradient(circle at 30% 25%,#b4ffad,#12a34a 65%,#06451d)}
.white{background:radial-gradient(circle at 30% 25%,#fff,#d7d7d7 65%,#888)}
.black{background:radial-gradient(circle at 30% 25%,#888,#292929 65%,#050505)}
button{
 background:linear-gradient(135deg,#f9e4a0,#c18a25);
 border:0;border-radius:30px;padding:14px 35px;
 color:#201605;font-weight:bold;font-size:15px;
 cursor:pointer;box-shadow:0 4px 15px #b98a3055;
}
button:disabled{opacity:.4;cursor:not-allowed}
.draw-area{display:flex;justify-content:center;gap:45px;flex-wrap:wrap;margin:30px 0}
.draw-box{min-width:110px}
.draw-ball{
 width:90px;height:90px;border-radius:50%;
 margin:15px auto;border:3px solid #b99445;
 background:radial-gradient(circle at 30% 25%,#777,#242424 70%);
 box-shadow:0 0 20px #d2a34355;
}
#result{font-size:20px;font-weight:bold;color:#f5d47b;min-height:30px}
#message{color:#ccc;min-height:25px}
.stats{display:flex;justify-content:center;gap:35px;margin:20px}
.stat strong{display:block;color:#f5d47b;font-size:25px}
@keyframes spin{
 0%{transform:rotate(0deg) scale(.8)}
 50%{transform:rotate(180deg) scale(1.15)}
 100%{transform:rotate(360deg) scale(1)}
}
.spinning{animation:spin .65s ease-in-out infinite}
footer{padding:20px;color:#888;font-size:12px}
</style>
</head>
<body>
<header>
 <h1>♛ ROYAL BALL ♛</h1>
 <div class="sub">THE ULTIMATE COLOR CHALLENGE</div>
</header>

<div class="panel">
 <h2>SELECT YOUR LUCKY BALL</h2>
 <p style="color:#aaa">Choose one of the six colors</p>

 <div class="balls" id="choices">
  <div class="ball red" data-color="Red"></div>
  <div class="ball yellow" data-color="Yellow"></div>
  <div class="ball blue" data-color="Blue"></div>
  <div class="ball green" data-color="Green"></div>
  <div class="ball white" data-color="White"></div>
  <div class="ball black" data-color="Black"></div>
 </div>

 <button id="play" disabled>SPIN & DRAW</button>

 <div class="draw-area">
  <div class="draw-box">
   <h3>YOUR CHOICE</h3>
   <div class="draw-ball" id="yourBall"></div>
   <div id="yourName">Not Selected</div>
  </div>
  <div class="draw-box">
   <h3>LUCKY DRAW</h3>
   <div class="draw-ball" id="drawBall"></div>
   <div id="drawName">Waiting...</div>
  </div>
 </div>

 <div id="result">WELCOME TO ROYAL BALL</div>
 <div id="message">Select a ball to begin!</div>

 <div class="stats">
  <div class="stat">WINS<strong id="wins">0</strong></div>
  <div class="stat">LOSSES<strong id="losses">0</strong></div>
  <div class="stat">ROUNDS<strong id="rounds">0</strong></div>
 </div>

 <button id="again" style="display:none">PLAY AGAIN</button>
</div>

<footer>ROYAL BALL • A COLOR GUESSING GAME • FOR ENTERTAINMENT ONLY</footer>

<script>
const colors=["Red","Yellow","Blue","Green","White","Black"];
let selected=null,wins=0,losses=0,rounds=0,busy=false;

const yourBall=document.getElementById("yourBall");
const drawBall=document.getElementById("drawBall");
const play=document.getElementById("play");
const again=document.getElementById("again");

function setBall(el,color){
 el.className="draw-ball";
 el.classList.add(color.toLowerCase());
}

document.querySelectorAll(".ball").forEach(ball=>{
 ball.addEventListener("click",()=>{
  if(busy)return;
  document.querySelectorAll(".ball").forEach(b=>b.classList.remove("selected"));
  ball.classList.add("selected");
  selected=ball.dataset.color;
  play.disabled=false;
  document.getElementById("yourName").textContent=selected;
  setBall(yourBall,selected);
  document.getElementById("result").textContent="READY TO PLAY?";
  document.getElementById("message").textContent="Press Spin & Draw!";
 });
});

play.addEventListener("click",()=>{
 if(!selected||busy)return;
 busy=true;
 play.disabled=true;
 again.style.display="none";
 document.getElementById("result").textContent="DRAWING...";
 document.getElementById("message").textContent="The lucky ball is coming!";
 drawBall.className="draw-ball spinning";
 let count=0;
 const animation=setInterval(()=>{
  let temp=colors[Math.floor(Math.random()*6)];
  setBall(drawBall,temp);
  drawBall.classList.add("spinning");
  count++;
  if(count>=12){
   clearInterval(animation);
   const result=colors[Math.floor(Math.random()*6)];
   drawBall.className="draw-ball";
   setBall(drawBall,result);
   document.getElementById("drawName").textContent=result;
   rounds++;
   if(result===selected){
    wins++;
    document.getElementById("result").textContent="🏆 CONGRATULATIONS! YOU WON!";
    document.getElementById("message").textContent="Amazing! Both colors matched!";
   }else{
    losses++;
    document.getElementById("result").textContent="SORRY, YOU LOSE!";
    document.getElementById("message").textContent="Try again! Choose another color.";
   }
   document.getElementById("wins").textContent=wins;
   document.getElementById("losses").textContent=losses;
   document.getElementById("rounds").textContent=rounds;
   again.style.display="inline-block";
   busy=false;
  }
 },120);
});

again.addEventListener("click",()=>{
 selected=null;
 document.querySelectorAll(".ball").forEach(b=>b.classList.remove("selected"));
 setBall(yourBall,"");
 setBall(drawBall,"");
 document.getElementById("yourName").textContent="Not Selected";
 document.getElementById("drawName").textContent="Waiting...";
 document.getElementById("result").textContent="NEXT ROUND!";
 document.getElementById("message").textContent="Choose your lucky color!";
 play.disabled=true;
 again.style.display="none";
});
</script>
</body>
</html>

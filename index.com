<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>The Guide — National Park Serbia</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;800;900&family=Space+Mono:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">
<style>
  :root{
    --bg-black:#050705;
    --bezel:#d7cfba;
    --bezel-dark:#a89f88;
    --bezel-shadow:#8c8368;
    --olive:#7f8a58;
    --olive-dark:#4d5636;
    --olive-deep:#333c22;
    --teal:#356456;
    --teal-dark:#22453b;
    --navy:#132029;
    --navy-2:#0c161d;
    --amber:#dc9f24;
    --amber-bright:#f4bd45;
    --cyan:#39ddc9;
    --red:#bf3b2b;
    --paper:#e9e3cf;
    --font-display: "Orbitron", "Arial Black", Arial, sans-serif;
    --font-mono: "Space Mono", ui-monospace, "SF Mono", "Cascadia Mono", "Courier New", monospace;
  }
  *{box-sizing:border-box;}
  html,body{margin:0;padding:0;}
  body{
    background:
      radial-gradient(ellipse 900px 500px at 50% -8%, rgba(57,221,201,0.10), transparent 60%),
      radial-gradient(ellipse 700px 500px at 90% 100%, rgba(220,159,36,0.07), transparent 60%),
      var(--bg-black);
    font-family: var(--font-mono);
    color:var(--paper);
    display:flex;
    justify-content:center;
    padding:28px 14px 60px;
    min-height:100vh;
  }

  /* ============ DEVICE BEZEL ============ */
  .device{
    width:100%;
    max-width:900px;
    background:
      radial-gradient(120% 140% at 20% 0%, #efe9d8 0%, var(--bezel) 42%, var(--bezel-dark) 100%);
    border-radius:26px;
    padding:22px;
    box-shadow:
      0 0 0 1px var(--bezel-shadow),
      0 30px 70px rgba(0,0,0,0.65),
      inset 0 1px 0 rgba(255,255,255,0.5);
    position:relative;
  }
  .device::before{
    content:"";
    position:absolute; inset:8px;
    border-radius:20px;
    pointer-events:none;
    box-shadow: inset 0 0 18px rgba(0,0,0,0.18);
  }
  .device::after{
    content:"";
    position:absolute; inset:-1px;
    border-radius:27px;
    pointer-events:none;
    box-shadow: 0 0 0 1px rgba(57,221,201,0.35), 0 0 40px rgba(57,221,201,0.10);
  }
  .hud-corner{
    position:absolute; width:16px; height:16px;
    pointer-events:none; z-index:3;
    border:2px solid var(--cyan);
    opacity:.55;
    filter: drop-shadow(0 0 4px rgba(57,221,201,.6));
  }
  .hud-corner.tl{ top:10px; left:10px; border-right:none; border-bottom:none; border-radius:6px 0 0 0; }
  .hud-corner.tr{ top:10px; right:10px; border-left:none; border-bottom:none; border-radius:0 6px 0 0; }
  .hud-corner.bl{ bottom:10px; left:10px; border-right:none; border-top:none; border-radius:0 0 0 6px; }
  .hud-corner.br{ bottom:10px; right:10px; border-left:none; border-top:none; border-radius:0 0 6px 0; }
  .device-top{
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:2px 10px 14px;
    font-family: Arial, Helvetica, sans-serif;
    font-weight:800;
    letter-spacing:.14em;
    font-size:11px;
    color:#5b5439;
  }
  .device-top .brand{ display:flex; align-items:center; gap:8px;}
  .device-top .brand .dot{
    width:8px;height:8px;border-radius:50%;
    background:var(--cyan);
    box-shadow:0 0 8px var(--cyan), 0 0 2px #fff;
  }

  /* ============ SCREEN ============ */
  .screen{
    background: linear-gradient(180deg, var(--navy) 0%, var(--navy-2) 100%);
    border-radius:14px;
    box-shadow: inset 0 0 0 2px #000, inset 0 2px 30px rgba(0,0,0,0.6);
    overflow:hidden;
    position:relative;
  }
  .scanlines{
    position:absolute; inset:0;
    pointer-events:none;
    background: repeating-linear-gradient(
      to bottom,
      rgba(255,255,255,0.035) 0px,
      rgba(255,255,255,0.035) 1px,
      transparent 1px,
      transparent 3px
    );
    mix-blend-mode:overlay;
    z-index:50;
  }
  .glow-edge{
    position:absolute; inset:0;
    pointer-events:none;
    box-shadow: inset 0 0 60px rgba(57,221,201,0.06);
    z-index:49;
  }

  /* status bar, styled after the IMPROBABILITY / THEORY readout */
  .statusbar{
    display:flex;
    align-items:stretch;
    height:34px;
    font-family: Arial, Helvetica, sans-serif;
    font-weight:800;
    font-size:11px;
    letter-spacing:.09em;
    position:relative;
    z-index:2;
  }
  .statusbar .seg{
    display:flex; align-items:center; justify-content:center;
    padding:0 14px;
  }
  .statusbar .seg-shade{
    background:var(--amber);
    color:var(--navy-2);
    flex:1 1 auto;
    justify-content:flex-start;
    gap:10px;
  }
  .statusbar .seg-shade b{ color:#1c1400; }
  .meter{
    width:140px; height:9px;
    background:rgba(0,0,0,0.35);
    border-radius:5px;
    overflow:hidden;
    box-shadow: inset 0 0 0 1px rgba(0,0,0,0.4);
  }
  .meter i{
    display:block; height:100%;
    background: linear-gradient(90deg,#8dd94a,#c7e34d);
    width:14%;
    transition: width .35s ease;
  }
  .statusbar .seg-label{
    background:var(--navy-2);
    color:var(--cyan);
    text-shadow:0 0 6px rgba(57,221,201,.6);
    min-width:150px;
  }

  /* header block */
  .titleblock{
    position:relative; z-index:2;
    padding:26px 30px 10px;
    text-align:center;
  }
  .titleblock .eyebrow{
    font-family: Arial, Helvetica, sans-serif;
    font-size:11px; letter-spacing:.3em;
    color:var(--cyan);
    text-shadow:0 0 8px rgba(57,221,201,.5);
    margin-bottom:10px;
  }
  .titleblock h1{
    margin:0;
    font-family: var(--font-display);
    font-weight:900;
    font-size: clamp(28px, 6.4vw, 46px);
    letter-spacing:.03em;
    color:var(--amber-bright);
    text-shadow: 0 0 22px rgba(220,159,36,.55), 0 0 46px rgba(220,159,36,.25), 0 2px 0 rgba(0,0,0,.6);
    line-height:1.1;
  }
  .titleblock .sub{
    margin-top:8px;
    font-size:12.5px;
    color:#9fb0a8;
    font-style:italic;
  }
  .titleblock .guidetag{
    margin-top:14px;
    display:inline-block;
    font-family: Arial, Helvetica, sans-serif;
    font-weight:800;
    font-size:10.5px;
    letter-spacing:.18em;
    color:var(--navy-2);
    background:var(--amber);
    padding:4px 10px;
    border-radius:3px;
  }

  /* intro entry text, olive panel like the on-screen "book page" */
  .entrytext{
    position:relative; z-index:2;
    margin:18px 24px 0;
    background: linear-gradient(180deg, var(--olive) 0%, var(--olive-dark) 100%);
    border-radius:8px;
    padding:20px 22px;
    box-shadow: inset 0 0 0 1px rgba(0,0,0,.25), 0 8px 18px rgba(0,0,0,.35);
    font-size:14.5px;
    line-height:1.65;
    color:#f2f1e2;
  }
  .entrytext .cap{
    color:var(--amber-bright);
    font-weight:700;
    font-family:Arial, Helvetica, sans-serif;
    letter-spacing:.03em;
  }
  .typecursor{
    display:inline-block; width:8px; height:15px;
    background:var(--amber-bright);
    margin-left:2px;
    vertical-align:middle;
    animation:blink 1s steps(1) infinite;
  }
  @keyframes blink{50%{opacity:0;}}

  /* ============ SIMULATOR — signature element ============ */
  .sim-wrap{
    position:relative; z-index:2;
    margin:22px 24px 0;
    background:var(--navy-2);
    border-radius:10px;
    box-shadow: inset 0 0 0 1px rgba(255,255,255,.06);
    padding:16px 18px 20px;
  }
  .sim-head{
    display:flex; justify-content:space-between; align-items:baseline;
    font-family:Arial, Helvetica, sans-serif;
    margin-bottom:10px;
    flex-wrap:wrap; gap:6px;
  }
  .sim-head .name{
    font-weight:800; letter-spacing:.06em; font-size:12.5px;
    color:var(--red);
    text-shadow:0 0 10px rgba(191,59,43,.5);
  }
  .sim-head .readout{
    font-size:11px; color:var(--cyan);
  }
  .stage{
    position:relative;
    height:200px;
    border-radius:8px;
    overflow:hidden;
    background: linear-gradient(180deg,#cfd9b3 0%, #b9c592 62%, #9aa876 100%);
    box-shadow: inset 0 0 0 1px rgba(0,0,0,.3);
  }
  .stage .ground-line{
    position:absolute; left:0; right:0; bottom:44px; height:1px;
    background:rgba(0,0,0,0.08);
  }
  .politician{
    position:absolute; bottom:44px; left:8%;
    transform-origin:bottom left;
    transition: transform .25s ease;
  }
  .politician .tower{
    width:26px; border-radius:4px 4px 0 0;
    background: linear-gradient(180deg,#8a2a20,var(--red));
    box-shadow:0 0 14px rgba(191,59,43,.35);
  }
  .politician .head{
    width:20px; height:20px; border-radius:50%;
    background:var(--red);
    margin:0 0 -2px 3px;
    box-shadow:0 0 10px rgba(191,59,43,.5);
  }
  .shadow-cast{
    position:absolute; bottom:44px; left:calc(8% + 13px);
    height:2px;
    background: linear-gradient(90deg, rgba(10,10,5,0.75), rgba(10,10,5,0));
    transform-origin:left center;
    transition: width .25s ease, height .25s ease, opacity .25s ease;
    opacity:.85;
    filter: blur(0.3px);
  }
  .critter{
    position:absolute; bottom:44px;
    display:flex; flex-direction:column; align-items:center;
    transition: opacity .3s ease, transform .3s ease, filter .3s ease;
    font-family:Arial, Helvetica, sans-serif;
  }
  .critter .icon{ transition: transform .3s ease, filter .3s ease; }
  .critter .tag{
    margin-top:4px;
    font-size:8.5px; letter-spacing:.03em;
    color:#2c3320; background:rgba(255,255,255,0.55);
    padding:1px 4px; border-radius:3px;
    white-space:nowrap;
  }
  .critter.wilt .icon{ filter:saturate(.25) brightness(.7); transform:scale(.72) rotate(4deg); }
  .critter.wilt .tag{ background:rgba(60,20,15,0.45); color:#f2d9d0; }

  #citizen{ left:34%; }
  #pensioner{ left:52%; }
  #demagogy{ left:70%; }

  .sim-controls{
    display:flex; align-items:center; gap:14px;
    margin-top:14px;
    font-family:Arial, Helvetica, sans-serif;
    font-size:11px;
    color:#c9d4c9;
  }
  .sim-controls input[type=range]{
    flex:1;
    accent-color: var(--red);
    height:4px;
  }
  .sim-status{
    margin-top:10px;
    font-size:12px;
    color:var(--amber-bright);
    min-height:34px;
    line-height:1.5;
  }

  /* ============ TABS / CATALOG ============ */
  .tabs{
    position:relative; z-index:2;
    display:flex; gap:8px;
    margin:22px 24px 0;
    flex-wrap:wrap;
  }
  .tab{
    flex:1 1 130px;
    background:var(--teal-dark);
    color:#cfe6de;
    border:none;
    border-radius:7px 7px 0 0;
    padding:11px 8px;
    font-family:Arial, Helvetica, sans-serif;
    font-weight:800;
    font-size:11px;
    letter-spacing:.04em;
    cursor:pointer;
    text-align:center;
    opacity:.62;
    transition: all .2s ease;
    -webkit-tap-highlight-color:transparent;
  }
  .tab:hover{ opacity:.85; }
  .tab.active{
    background:var(--teal);
    opacity:1;
    box-shadow: 0 -2px 0 var(--cyan) inset, 0 0 14px rgba(57,221,201,.35);
    color:#fff;
    text-shadow:0 0 8px rgba(57,221,201,.6);
  }

  .cardwrap{
    position:relative; z-index:2;
    margin:0 24px 26px;
    background: linear-gradient(180deg, var(--teal) 0%, var(--teal-dark) 100%);
    border-radius:0 0 8px 8px;
    padding:20px 22px 24px;
    box-shadow: inset 0 0 0 1px rgba(0,0,0,.25), 0 10px 20px rgba(0,0,0,.35);
    min-height:170px;
  }
  .card{ display:none; }
  .card.show{ display:block; animation: fadein .35s ease; }
  @keyframes fadein{ from{opacity:0; transform:translateY(6px);} to{opacity:1; transform:translateY(0);} }
  .card-head{
    display:flex; align-items:center; gap:12px;
    margin-bottom:10px;
  }
  .card-icon{ flex:none; }
  .card-titles h3{
    margin:0; font-family:var(--font-display);
    font-size:clamp(17px, 4.4vw, 19px); font-weight:800;
    letter-spacing:.01em;
    color:var(--amber-bright);
    text-shadow:0 0 12px rgba(220,159,36,.4);
  }
  .card-titles .latin{
    font-style:italic; font-size:11.5px; color:#bcd6cc;
  }
  .card p{
    font-size:13.5px; line-height:1.65; margin:0 0 8px;
    color:#eef3ee;
  }
  .card .guideline{
    margin-top:10px;
    font-size:11.5px;
    color:var(--cyan);
    border-left:2px solid var(--cyan);
    padding-left:10px;
  }

  /* ============ BRIBABLE DOCTOR WIDGET ============ */
  .doctor-sim{
    margin-top:16px;
    background:var(--navy-2);
    border-radius:8px;
    padding:14px 16px 16px;
    box-shadow: inset 0 0 0 1px rgba(255,255,255,.06);
  }
  .doctor-sim-head{
    font-family:Arial, Helvetica, sans-serif;
    font-weight:800; font-size:10.5px; letter-spacing:.08em;
    color:var(--cyan); margin-bottom:10px;
  }
  .doctor-stage{
    display:flex; gap:14px; align-items:stretch;
    flex-wrap:wrap;
  }
  .doctor-figure{
    flex:0 0 auto;
    background: linear-gradient(180deg,#cfd9b3,#b9c592);
    border-radius:8px;
    padding:10px 14px 8px;
    display:flex; flex-direction:column; align-items:center;
    min-width:110px;
    box-shadow: inset 0 0 0 1px rgba(0,0,0,.25);
  }
  .doctor-figure svg{ transition: transform .18s ease; }
  .doctor-figure.jolt svg{ animation: jolt .38s ease; }
  @keyframes jolt{
    0%{transform:translate(0,0) rotate(0);}
    20%{transform:translate(-2px,-1px) rotate(-3deg);}
    40%{transform:translate(2px,1px) rotate(3deg);}
    60%{transform:translate(-2px,1px) rotate(-2deg);}
    80%{transform:translate(2px,-1px) rotate(2deg);}
    100%{transform:translate(0,0) rotate(0);}
  }
  .doctor-figure.bored svg{ opacity:.55; transform:rotate(-4deg); }
  .doc-speech{
    margin-top:6px;
    font-size:10.5px;
    font-family:Arial, Helvetica, sans-serif;
    text-align:center;
    color:#2c3320;
    min-height:26px;
  }
  .den{
    flex:1 1 200px;
    background: repeating-linear-gradient(180deg, #3a2c1e, #3a2c1e 26px, #33261a 26px, #33261a 52px);
    border-radius:8px;
    padding:10px 12px;
    box-shadow: inset 0 0 0 1px rgba(0,0,0,.3);
  }
  .den-label{
    font-family:Arial, Helvetica, sans-serif;
    font-size:10px; letter-spacing:.1em; font-weight:800;
    color:var(--amber-bright); margin-bottom:8px;
  }
  .den-goods{
    display:flex; flex-wrap:wrap; gap:6px;
    min-height:30px;
    align-items:center;
  }
  .den-goods span{
    font-size:17px;
    background:rgba(0,0,0,.25);
    border-radius:5px;
    padding:2px 5px;
    animation: pop .25s ease;
  }
  @keyframes pop{ from{transform:scale(0.3); opacity:0;} to{transform:scale(1); opacity:1;} }
  .den-empty-note{
    font-size:10.5px; color:#9c8f7a; font-family:Arial, Helvetica, sans-serif; font-style:italic;
  }
  .doctor-buttons{
    display:flex; gap:10px; margin-top:12px; flex-wrap:wrap;
  }
  .dbtn{
    font-family:Arial, Helvetica, sans-serif;
    font-weight:800; font-size:11px; letter-spacing:.03em;
    border:none; border-radius:6px;
    padding:9px 14px; cursor:pointer;
    transition: transform .12s ease, filter .12s ease;
  }
  .dbtn:hover{ filter:brightness(1.1); transform:translateY(-1px); }
  .dbtn-bribe{ background:var(--amber-bright); color:#1c1400; }
  .dbtn-empty{ background:#3a4a44; color:#dbe8e2; }
  .doctor-status{
    margin-top:10px; font-size:12px; color:var(--amber-bright); line-height:1.5; min-height:34px;
  }

  /* ---- Mitus (Bribe) light-exposure widget ---- */
  .mitus-stage{
    display:flex; align-items:center; gap:20px; flex-wrap:wrap;
    background: linear-gradient(180deg,#22201a,#33301f);
    border-radius:8px;
    padding:14px 18px;
    transition: background .35s ease;
  }
  .mitus-stage.sunlit{
    background: linear-gradient(180deg,#f4e2a0,#e0c568);
  }
  .mitus-plant svg{ transition: filter .35s ease, transform .35s ease; }
  .mitus-stage.sunlit .mitus-plant svg{
    filter: saturate(.35) brightness(1.5);
    transform: scale(.82) rotate(3deg);
  }
  .mitus-fruits{
    display:flex; gap:10px; font-size:26px;
    transition: opacity .35s ease;
  }
  .mitus-stage.sunlit .mitus-fruits{ opacity:.35; }

  /* ---- Street Encounter simulator ---- */
  .encounter-stage{
    display:flex; gap:16px; align-items:flex-start; flex-wrap:wrap;
  }
  .cop-figure{
    flex:0 0 auto;
    background: linear-gradient(180deg,#cfd9b3,#b9c592);
    border-radius:8px;
    padding:10px 14px 8px;
    display:flex; flex-direction:column; align-items:center;
    min-width:100px;
    box-shadow: inset 0 0 0 1px rgba(0,0,0,.25);
  }
  .cop-figure svg{ transition: transform .2s ease; }
  .cop-figure.react-avoid svg{ transform: rotate(-10deg) translateX(-4px) scale(.94); }
  .cop-figure.react-chase svg{ transform: scale(1.08) rotate(2deg); }
  .cop-figure.react-fine svg{ transform: scale(1.05) translateY(-2px); }
  .encounter-chips{
    flex:1 1 220px;
    display:flex; flex-wrap:wrap; gap:8px;
  }
  .chip{
    font-family:Arial, Helvetica, sans-serif;
    font-size:11px; font-weight:700;
    background:#3a4a44; color:#dbe8e2;
    border:none; border-radius:14px;
    padding:7px 12px; cursor:pointer;
    transition: all .15s ease;
  }
  .chip:hover{ background:#4c5f58; }
  .chip.picked[data-r="avoid"]{ background:#5a5a3a; color:#e8e6cf; }
  .chip.picked[data-r="chase"]{ background:var(--red); color:#fff; }
  .chip.picked[data-r="fine"]{ background:var(--amber-bright); color:#1c1400; }

  /* ---- Talk to the Cop simulator ---- */
  .talk-stage{
    background:var(--navy-2);
    border-radius:8px;
    padding:16px 18px;
    min-height:50px;
    display:flex; align-items:center;
  }
  .talk-line{
    font-size:13.5px; color:var(--amber-bright); line-height:1.5;
  }

  /* ---- Cordon formation simulator ---- */
  .cordon-stage{
    display:flex; gap:6px; align-items:flex-end;
    min-height:70px;
    background: linear-gradient(180deg,#cfd9b3,#b9c592);
    border-radius:8px;
    padding:12px 14px;
    flex-wrap:wrap;
  }
  .cordon-unit{
    transition: transform .25s ease;
  }
  .cordon-stage.charging .cordon-unit{
    animation: lunge .32s ease;
  }
  @keyframes lunge{
    0%{transform:translateX(0);}
    40%{transform:translateX(10px) rotate(4deg);}
    100%{transform:translateX(0);}
  }

  /* ---- Counter Encounter chat simulator ---- */
  .chat-stage{
    background:var(--navy-2);
    border-radius:8px;
    padding:12px 14px;
    max-height:230px;
    overflow-y:auto;
    display:flex; flex-direction:column; gap:7px;
  }
  .chat-placeholder{ font-size:12px; color:#7f8f88; font-style:italic; }
  .bubble{
    max-width:78%;
    padding:6px 11px;
    border-radius:12px;
    font-size:12.5px;
    line-height:1.4;
    animation: fadein .2s ease;
  }
  .bubble.citizen{
    align-self:flex-start;
    background:#3a4a44;
    color:#eef3ee;
    border-bottom-left-radius:3px;
  }
  .bubble.clerk{
    align-self:flex-end;
    background:var(--red);
    color:#fff;
    font-weight:700;
    border-bottom-right-radius:3px;
  }

  /* ---- Coefficient of Wildness ---- */
  .wild-controls{
    display:flex; flex-direction:column; gap:10px;
    font-family:Arial, Helvetica, sans-serif;
    font-size:11px; color:#c9d4c9;
    margin-bottom:12px;
  }
  .wild-controls label{ display:flex; flex-direction:column; gap:4px; }
  .wild-controls span{ color:var(--amber-bright); font-weight:700; }
  .wild-controls input[type=range]{ accent-color:var(--red); }
  .wild-readout{
    display:flex; align-items:baseline; gap:12px;
    background:var(--navy-2);
    border-radius:8px;
    padding:12px 16px;
  }
  .wild-number{
    font-family:"Arial Black",Arial,sans-serif;
    font-size:34px; color:var(--amber-bright);
  }
  .wild-label{
    font-family:Arial, Helvetica, sans-serif;
    font-weight:800; font-size:12px; letter-spacing:.08em;
    color:var(--red);
  }

  /* ---- Endless checklist ---- */
  .checklist{
    display:flex; flex-direction:column; gap:6px;
    background:var(--navy-2);
    border-radius:8px;
    padding:12px 14px;
    max-height:210px;
    overflow-y:auto;
  }
  .checklist label{
    display:flex; align-items:flex-start; gap:8px;
    font-size:12px; color:#eef3ee; line-height:1.4;
    animation: fadein .25s ease;
  }
  .checklist input[type=checkbox]{ margin-top:2px; accent-color:var(--amber-bright); }
  .checklist label.checked{ color:#7f8f88; text-decoration:line-through; }

  /* ---- Bill simulator ---- */
  .bill-stage{
    background:var(--navy-2);
    border-radius:8px;
    padding:12px 16px;
    display:flex; flex-direction:column; gap:8px;
  }
  .bill-row{
    display:flex; justify-content:space-between; align-items:center;
    font-size:13px; color:#eef3ee;
    font-family:Arial, Helvetica, sans-serif;
  }
  .bill-row b{ color:var(--amber-bright); font-size:15px; }
  #billFinal.inflated{ color:var(--red); }

  /* ---- Naked Singer squeal chips ---- */
  .squeal-chips{ display:flex; flex-wrap:wrap; gap:8px; }
  .squeal-chips .chip.picked{ background:var(--amber-bright); color:#1c1400; }

  /* ---- Compose the Squeal: two-column layout with video ---- */
  .squeal-layout{
    display:flex; gap:18px; flex-wrap:wrap;
  }
  .squeal-controls{ flex:1 1 260px; min-width:240px; }
  .squeal-video{ flex:0 0 260px; }
  .squeal-video-label{
    font-family:Arial, Helvetica, sans-serif;
    font-weight:800; font-size:10px; letter-spacing:.1em;
    color:var(--cyan); margin-bottom:6px;
  }
  .squeal-video-frame{
    position:relative; display:block; width:100%; padding-top:56.25%;
    background: linear-gradient(180deg,#2a2a2a,#141414);
    border-radius:6px; overflow:hidden;
  }
  .squeal-video-frame img{
    position:absolute; inset:0; width:100%; height:100%; object-fit:cover;
  }
  .squeal-play{
    position:absolute; top:50%; left:50%; transform:translate(-50%,-50%);
    width:46px; height:46px; border-radius:50%;
    background:rgba(0,0,0,.55);
    color:var(--amber-bright);
    display:flex; align-items:center; justify-content:center;
    font-size:16px; padding-left:3px;
    box-shadow:0 0 0 2px rgba(244,189,69,.5);
    border:none; cursor:pointer;
    transition: transform .15s ease, background .15s ease;
  }
  .squeal-play:hover{ transform:translate(-50%,-50%) scale(1.08); background:rgba(0,0,0,.7); }
  .squeal-video-frame iframe{
    position:absolute; inset:0; width:100%; height:100%; border:0;
  }
  @media (max-width:640px){
    .squeal-video{ flex-basis:100%; }
  }

  /* ---- Retro TV set frame around the video ---- */
  .tv-set{
    position:relative;
    display:flex; flex-direction:column; align-items:center;
    padding-top:26px;
  }
  .tv-antennas{
    position:absolute; top:-4px; left:50%; transform:translateX(-50%);
    width:100px; height:36px;
  }
  .tv-antenna{
    position:absolute; bottom:0; width:2px; height:34px;
    background: linear-gradient(180deg,#c9c2a8,#8c8368);
    transform-origin:bottom center;
    border-radius:2px;
  }
  .tv-antenna::after{
    content:""; position:absolute; top:-4px; left:-3px;
    width:8px; height:8px; border-radius:50%;
    background:#c9c2a8;
    box-shadow:0 0 4px rgba(255,255,255,.4);
  }
  .tv-antenna-left{ left:32px; transform:rotate(-26deg); }
  .tv-antenna-right{ left:60px; transform:rotate(26deg); }

  .tv-body{
    position:relative;
    display:flex; align-items:center; gap:8px;
    width:100%;
    background: radial-gradient(120% 140% at 20% 0%, #efe9d8 0%, var(--bezel) 45%, var(--bezel-dark) 100%);
    border-radius:14px;
    padding:10px;
    box-shadow: 0 8px 16px rgba(0,0,0,.45), inset 0 1px 0 rgba(255,255,255,.5), inset 0 0 0 1px var(--bezel-shadow);
  }
  .tv-screen-bezel{
    flex:1 1 auto;
    background:#0c0c0c;
    border-radius:8px;
    padding:7px;
    box-shadow: inset 0 0 0 2px #000, inset 0 0 10px rgba(0,0,0,.6);
  }
  .tv-controls{
    flex:0 0 auto;
    display:flex; flex-direction:column; align-items:center; gap:9px;
    padding-right:2px;
  }
  .tv-knob{
    width:15px; height:15px; border-radius:50%;
    background: radial-gradient(circle at 35% 32%, #f4e9d0, #8c8368 75%);
    box-shadow: inset 0 0 0 1px rgba(0,0,0,.35), 0 1px 1px rgba(255,255,255,.4);
  }
  .tv-knob.small{ width:10px; height:10px; }
  .tv-legs{
    display:flex; gap:70%; justify-content:center; width:100%;
    margin-top:4px;
  }
  .tv-legs span{
    width:7px; height:9px;
    background: linear-gradient(180deg,#a89f88,#8c8368);
    border-radius:0 0 3px 3px;
  }
  .dress-stage{
    display:flex; justify-content:center;
    background: linear-gradient(180deg,#22201a,#33301f);
    border-radius:8px;
    padding:10px 0 4px;
    margin-bottom:12px;
  }
  .dress-stage svg *{ transition: opacity .35s ease; }

  /* ---- Batinaši: loyalty compass ---- */
  .compass-stage{ display:flex; justify-content:center; margin-bottom:10px; }

  /* ---- Batinaši: invisibility ritual ---- */
  .witness-stage{
    display:flex; flex-wrap:wrap; gap:5px;
    min-height:34px;
    background:var(--navy-2);
    border-radius:8px;
    padding:10px 12px;
    margin-bottom:10px;
  }
  .witness-stage span{
    font-size:16px;
    animation: pop .2s ease;
  }
  .habitat-btn.active{ background:var(--amber-bright); color:#1c1400; }

  /* ---- Batinaši: pack hunting ---- */
  .pack-stage{
    display:flex; flex-wrap:wrap; gap:6px; align-items:flex-end;
    min-height:56px;
    background:var(--navy-2);
    border-radius:8px;
    padding:10px 12px;
    margin-bottom:10px;
  }
  .pack-unit{ animation: pop .25s ease; }

  /* ---- Collectivus stinko: approach distance ---- */
  .stink-stage{
    display:flex; justify-content:center;
    background: linear-gradient(180deg,#22201a,#33301f);
    border-radius:8px;
    padding:8px 0;
  }
  #stinkCloud{
    transition: opacity .3s ease, transform .3s ease;
    transform-box: fill-box;
    transform-origin: center;
  }
  #stinkPerson{ transition: filter .3s ease; }

  /* footer */
  .footer{
    position:relative; z-index:2;
    text-align:center;
    padding:6px 20px 24px;
    font-family:Arial, Helvetica, sans-serif;
  }
  .dontpanic{
    display:inline-block;
    font-weight:900;
    letter-spacing:.05em;
    font-size:15px;
    color:#1c1400;
    background: var(--amber-bright);
    padding:6px 16px;
    border-radius:4px;
    box-shadow:0 0 20px rgba(244,189,69,.45);
    border:none;
    cursor:pointer;
    font-family:Arial, Helvetica, sans-serif;
    transition: transform .12s ease, box-shadow .12s ease;
  }
  .dontpanic:hover{ transform:translateY(-1px); box-shadow:0 0 26px rgba(244,189,69,.65); }
  .dontpanic:active{ transform:translateY(0); }
  .dontpanic-msg{
    max-width:420px;
    margin:12px auto 0;
    font-size:12.5px;
    line-height:1.55;
    color:var(--amber-bright);
    min-height:0;
    opacity:0;
    transform:translateY(-4px);
    transition: opacity .3s ease, transform .3s ease;
  }
  .dontpanic-msg.show{ opacity:1; transform:translateY(0); }
  .footer .fine{
    display:block; margin-top:10px;
    font-size:10px; color:#5b6b64;
    letter-spacing:.05em;
  }

  /* ============ MOBILE OVERHAUL ============ */
  @media (max-width:700px){
    body{ padding:14px 6px 40px; }
    .device{ padding:12px 10px; border-radius:18px; }
    .hud-corner{ width:12px; height:12px; }
    .device-top{ font-size:9.5px; padding:2px 4px 10px; }

    .titleblock{ padding:18px 10px 8px; }
    .titleblock .sub{ font-size:13px; }

    .statusbar{ height:auto; flex-wrap:wrap; }
    .statusbar .seg-shade{ padding:8px 12px; flex-basis:100%; }
    .statusbar .seg-label{ min-width:auto; flex:1 1 auto; padding:6px 12px; font-size:10px; }
    .meter{ width:90px; }

    .entrytext{ margin:14px 8px 0; padding:16px 14px; font-size:15.5px; line-height:1.7; }
    .sim-wrap{ margin:16px 8px 0; padding:14px 12px 18px; }
    .sim-head .name{ font-size:13px; }
    .sim-controls{ flex-direction:column; align-items:stretch; gap:8px; }
    .sim-controls input[type=range]{ width:100%; height:22px; }
    .sim-status, .doctor-status{ font-size:13.5px !important; }

    /* Tabs become a horizontally-scrolling strip — far easier to hit on a phone
       than 18 tiny wrapped buttons */
    .tabs{
      margin:16px 8px 0;
      flex-wrap:nowrap;
      overflow-x:auto;
      -webkit-overflow-scrolling:touch;
      scrollbar-width:none;
      gap:6px;
      padding-bottom:2px;
    }
    .tabs::-webkit-scrollbar{ display:none; }
    .tab{
      flex:0 0 auto;
      font-size:12px;
      padding:12px 14px;
      white-space:nowrap;
      border-radius:8px 8px 0 0;
    }

    .cardwrap{ margin:0 8px 18px; padding:18px 14px 20px; }
    .card-head{ gap:10px; }
    .card-icon{ width:26px; height:34px; }
    .card-titles h3{ font-size:18px; }
    .card-titles .latin{ font-size:12.5px; }
    .card p{ font-size:15px; line-height:1.75; }
    .card .guideline{ font-size:13px; line-height:1.6; padding-left:12px; }

    /* Simulator internals: force everything into a single readable column */
    .doctor-sim{ padding:14px 12px !important; }
    .doctor-sim-head{ font-size:12.5px !important; }
    .wild-controls, .encounter-controls{ flex-direction:column !important; align-items:stretch !important; gap:10px !important; }
    .wild-controls label{ font-size:13px !important; }
    .wild-readout{ flex-direction:column !important; gap:2px !important; text-align:center; }
    .wild-number{ font-size:30px !important; }
    input[type=range]{ height:24px; }
    .chip, .habitat-btn, .dbtn{ font-size:12.5px !important; padding:9px 13px !important; }
    .encounter-chips, .witness-stage, .pack-stage{ gap:8px !important; }

    .tv-body{ flex-direction:column; }
    .tv-controls{ flex-direction:row; padding-right:0; }
    .squeal-video{ flex-basis:100% !important; }

    .footer{ padding:4px 12px 20px; }
    .dontpanic{ font-size:14px; padding:10px 18px; }
    .dontpanic-msg{ font-size:13px; max-width:100%; }
  }

  @media (max-width:420px){
    .titleblock h1{ font-size:26px; letter-spacing:.01em; }
    .titleblock .eyebrow{ font-size:9.5px; letter-spacing:.2em; }
    .card-titles h3 span{ display:block; margin-top:2px; }
  }

  button:focus-visible, input:focus-visible{
    outline:2px solid var(--cyan);
    outline-offset:2px;
  }
</style>
</head>
<body>

<div class="device">
  <span class="hud-corner tl"></span>
  <span class="hud-corner tr"></span>
  <span class="hud-corner bl"></span>
  <span class="hud-corner br"></span>
  <div class="device-top">
    <div class="brand"><span class="dot"></span> HITCHHIKER'S GUIDE — FIELD UNIT</div>
    <div>ED. 3 · REV.</div>
  </div>

  <div class="screen">
    <div class="scanlines"></div>
    <div class="glow-edge"></div>

    <div class="statusbar">
      <div class="seg seg-label">CIVILIZATION MINIMUM</div>
      <div class="seg seg-shade"><div class="meter"><i id="civMeter"></i></div> <b id="civPct">14%</b> OF NORMAL</div>
    </div>

    <div class="titleblock">
      <div class="eyebrow">NOW ENTERING</div>
      <h1>NATIONAL PARK SERBIA</h1>
      <div class="sub">An unsolicited addendum to the Guide, filed by a field researcher who really should have known better.</div>
      <div class="guidetag">DON'T PANIC — BUT DO WATCH THE SHADOW</div>
    </div>

    <div class="entrytext" id="entryText"></div>

    <div class="sim-wrap">
      <div class="sim-head">
        <div class="name">LIVE FIELD SIMULATOR — Corrupt Politician (Power Output)</div>
        <div class="readout" id="heightReadout">CURRENT HEIGHT: UNBELIEVABLY MODEST</div>
      </div>
      <div class="stage">
        <div class="ground-line"></div>
        <div class="shadow-cast" id="shadowCast"></div>

        <div class="politician" id="politician">
          <div class="head"></div>
          <div class="tower" id="towerBar" style="height:26px;"></div>
        </div>

        <div class="critter" id="citizen">
          <svg class="icon" width="26" height="34" viewBox="0 0 26 34" fill="none">
            <circle cx="13" cy="7" r="6" fill="#e9c08a"/>
            <path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#3a5a44"/>
          </svg>
          <div class="tag">Neglected Citizen</div>
        </div>

        <div class="critter" id="pensioner">
          <svg class="icon" width="26" height="34" viewBox="0 0 26 34" fill="none">
            <circle cx="13" cy="7" r="5.5" fill="#e6cfa9"/>
            <path d="M6 33c0-10 2-16 7-16s7 6 7 16" fill="#6a6455"/>
            <path d="M3 24c2-2 4-2 6-1" stroke="#4a4536" stroke-width="1.6" fill="none"/>
          </svg>
          <div class="tag">Skinny Pensioner</div>
        </div>

        <div class="critter" id="demagogy">
          <svg class="icon" width="22" height="34" viewBox="0 0 22 34" fill="none">
            <path d="M11 33V14" stroke="#3b5a2c" stroke-width="2.5"/>
            <ellipse cx="11" cy="12" rx="4" ry="7" fill="#7fae3d"/>
            <ellipse cx="5" cy="18" rx="3.4" ry="6" fill="#93c24a" transform="rotate(-25 5 18)"/>
            <ellipse cx="17" cy="18" rx="3.4" ry="6" fill="#93c24a" transform="rotate(25 17 18)"/>
          </svg>
          <div class="tag">Demagogy</div>
        </div>
      </div>

      <div class="sim-controls">
        <span>POWER</span>
        <input type="range" id="powerSlider" min="0" max="100" value="12">
        <span>UNBELIEVABLY ENORMOUS</span>
      </div>
      <div class="sim-status" id="simStatus"></div>
    </div>

    <div class="tabs" id="tabs">
      <button class="tab active" data-card="politician-card">CORRUPT POLITICIAN</button>
      <button class="tab" data-card="citizen-card">NEGLECTED CITIZEN</button>
      <button class="tab" data-card="pensioner-card">SKINNY PENSIONER</button>
      <button class="tab" data-card="demagogy-card">DEMAGOGY</button>
      <button class="tab" data-card="doctor-card">BRIBABLE DOCTOR</button>
      <button class="tab" data-card="unpaid-card">UNPAID DOCTOR</button>
      <button class="tab" data-card="paid-card">PAID DOCTOR</button>
      <button class="tab" data-card="mitus-card">THE BRIBE (MITUS)</button>
      <button class="tab" data-card="cop-card">BROWN STREET COP</button>
      <button class="tab" data-card="cordon-card">CORDON</button>
      <button class="tab" data-card="clerk-card">WILD COUNTER CLERK</button>
      <button class="tab" data-card="formulari-card">FORMULARI</button>
      <button class="tab" data-card="businessmen-card">8 SERBIAN BUSINESSMEN</button>
      <button class="tab" data-card="singer-card">NAKED SINGER</button>
      <button class="tab" data-card="batinasi-card">BATINAŠI</button>
      <button class="tab" data-card="stinko-card">COLLECTIVUS STINKO BIROCORRUPTICUS</button>
      <button class="tab" data-card="wretch-card">EDUCATIONAL WRETCH</button>
    </div>

    <div class="cardwrap">
      <div class="card show" id="politician-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <circle cx="13" cy="7" r="6" fill="var(--red)"/>
            <rect x="4" y="14" width="18" height="19" rx="2" fill="var(--red)"/>
          </svg>
          <div class="card-titles">
            <h3>Corrupt Politician</h3>
            <div class="latin">Potestas malversata</div>
          </div>
        </div>
        <p>When a Corrupt Politician is in Power — which is extremely high and wide, and can be unbelievably enormous — a large part of the National Park lies in its shadow, and very little manages to grow.</p>
        <div class="guideline">Guide note: height is rarely correlated with competence, and is best measured in hectares of shade cast, not centimetres.</div>
      </div>

      <div class="card" id="citizen-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <circle cx="13" cy="7" r="6" fill="#e9c08a"/>
            <path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#3a5a44"/>
          </svg>
          <div class="card-titles">
            <h3>Neglected Citizen</h3>
            <div class="latin">Civis ignoratus</div>
          </div>
        </div>
        <p>Hungry for Constitutional rights and freedoms — the Civilization Minimum — which, in the shadow of Power, cannot be found even as weeds.</p>
        <div class="guideline">Guide note: a surprisingly resilient species, known to keep germinating in the cracks of the pavement long after being told there is no light to spare.</div>
      </div>

      <div class="card" id="pensioner-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <circle cx="13" cy="7" r="5.5" fill="#e6cfa9"/>
            <path d="M6 33c0-10 2-16 7-16s7 6 7 16" fill="#6a6455"/>
          </svg>
          <div class="card-titles">
            <h3>Skinny Pensioner</h3>
            <div class="latin">Senex exilis</div>
          </div>
        </div>
        <p>Its diet consists only of a tiny Pension — locally called Myzeria — which withers further still in the shadow of the Corrupt Politician's Power.</p>
        <div class="guideline">Guide note: despite the name, the Pensioner is not fragile by nature. It is merely undernourished by design.</div>
      </div>

      <div class="card" id="demagogy-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 22 34" fill="none">
            <path d="M11 33V10" stroke="#3b5a2c" stroke-width="2.5"/>
            <ellipse cx="11" cy="8" rx="5" ry="8" fill="#7fae3d"/>
          </svg>
          <div class="card-titles">
            <h3>Demagogy</h3>
            <div class="latin">Uvlacus populis</div>
          </div>
        </div>
        <p>A fragrant plant that plays an important role in the process of climbing to Power. The only species that thrives well at the foot of every Power — the darker the shadow, the more fragrant it grows.</p>
        <div class="guideline">Guide note: often mistaken for a weed by the untrained eye, and for a virtue by the politician standing directly above it.</div>
      </div>

      <div class="card" id="doctor-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <circle cx="13" cy="7" r="6" fill="#e9c08a"/>
            <path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#f2f0e8"/>
            <rect x="11" y="14" width="4" height="12" fill="var(--red)"/>
            <rect x="7" y="18" width="12" height="4" fill="var(--red)"/>
          </svg>
          <div class="card-titles">
            <h3>Bribable Doctor <span style="font-size:11px;color:#bcd6cc;font-weight:400;">— 3rd subspecies of Doctor</span></h3>
            <div class="latin">Doctor (Primarius) — Primarius mitus</div>
          </div>
        </div>
        <p>In National Park Serbia there has long existed the species Doctor (<i>Primarius</i>), so named because he "receives" various things. Primarily, he receives sick representatives of other species and licks their wounds so they heal faster, in the absence of medicine. But he also receives other things — which is why the species is divided into three subspecies: the Unpaid (State) Doctor, the Paid (Private) Doctor, and the Bribable Doctor.</p>
        <p>Of the three, the Guide is primarily interested in the third — the Bribable Doctor — because it most vividly reflects the state of the Doctor species in the Park as a whole.</p>
        <p>The Bribable Doctor shows fantastic adaptability. An omnivore, he does not need to leave his den — like the Enriched Restaurateur and the Wild Clerk, the prey comes to him. Mostly old and sick specimens of other species: the easiest to catch.</p>
        <p>What sets him apart is his response to <b style="color:var(--amber-bright);">Bribe (Mitus)</b>, a plant known to cause increased saliva and adrenaline secretion, spontaneous dropping of the lower jaw, and spasms of all muscles. From that moment he becomes hyperactive and ultra-interested — but only in the one who gave the Bribe. Everything previously impossible suddenly becomes real and possible.</p>
        <p>Specimens without a Bribe hold no interest for him; he gets rid of them quickly by prescribing any kind of Therapy (<i>Terapia</i>) — a treatment in which he forces his victim to drink what they otherwise would never dream of drinking.</p>
        <p>His den, swollen with a steady intake of Bribe, comes to resemble a general store: piglets, lambs, chickens; cartons of eggs, cream, cheese, jam, honey, crates of fruit and vegetables; cartons of whiskey, bottles of wine, beer and homemade rakija; packages of coffee, boxes and master-boxes of cigarettes — and, of course, a growing pile of envelopes, without stamps on the outside, but plenty of "stamps" within.</p>

        <div class="doctor-sim">
          <div class="doctor-sim-head">FIELD TEST — approach the Bribable Doctor</div>
          <div class="doctor-stage">
            <div class="doctor-figure" id="docFigure">
              <svg width="54" height="70" viewBox="0 0 26 34" fill="none">
                <circle cx="13" cy="7" r="6" fill="#e9c08a"/>
                <path id="docJaw" d="M9 10 q4 3 8 0" stroke="#5a3a2a" stroke-width="1.2" fill="none"/>
                <path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#f2f0e8"/>
                <rect x="11" y="14" width="4" height="12" fill="var(--red)"/>
                <rect x="7" y="18" width="12" height="4" fill="var(--red)"/>
              </svg>
              <div class="doc-speech" id="docSpeech">Next patient, please.</div>
            </div>
            <div class="den" id="denShelf">
              <div class="den-label">THE DEN</div>
              <div class="den-goods" id="denGoods"></div>
            </div>
          </div>
          <div class="doctor-buttons">
            <button id="giveBribe" class="dbtn dbtn-bribe">Offer Bribe (Mitus)</button>
            <button id="noBribe" class="dbtn dbtn-empty">Arrive Empty-Handed</button>
          </div>
          <div class="doctor-status" id="doctorStatus">Awaiting the next specimen...</div>
        </div>

        <div class="guideline">Guide note: the Bribe is remarkably potent for a plant with no known nutritional value. Botanists remain divided on whether it is a plant at all.</div>
      </div>

      <div class="card" id="unpaid-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <circle cx="13" cy="7" r="6" fill="#c9c2a8"/>
            <path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#7d8a76"/>
            <rect x="11" y="14" width="4" height="12" fill="#c9c2a8" opacity=".6"/>
            <rect x="7" y="18" width="12" height="4" fill="#c9c2a8" opacity=".6"/>
          </svg>
          <div class="card-titles">
            <h3>Unpaid Doctor <span style="font-size:11px;color:#bcd6cc;font-weight:400;">— 1st subspecies</span></h3>
            <div class="latin">Primarius platus</div>
          </div>
        </div>
        <p>Also known as the State Doctor. This subspecies has fewer and fewer members each day, in a decline that mirrors the withering of the Pension Plant (<i>Penzijica — Myzeria</i>), whose delay drives the Skinny Pensioner toward extinction.</p>
        <p>Here, the culprit is the delay of the Salary Plant (<i>Platica — Smejuria</i>), itself extremely stunted. Its persistent lateness is blamed for the disappearance of other species across the Park — among them the Educational Wretch and the Neglected Citizen.</p>
        <div class="guideline">Guide note: once the Park's most common Doctor. Sightings are now considered noteworthy enough to report.</div>
      </div>

      <div class="card" id="paid-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <circle cx="13" cy="7" r="6" fill="#e9c08a"/>
            <path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#3f6f8a"/>
            <rect x="11" y="14" width="4" height="12" fill="#e9c08a"/>
            <rect x="7" y="18" width="12" height="4" fill="#e9c08a"/>
          </svg>
          <div class="card-titles">
            <h3>Paid Doctor <span style="font-size:11px;color:#bcd6cc;font-weight:400;">— 2nd subspecies</span></h3>
            <div class="latin">Primarius marcus</div>
          </div>
        </div>
        <p>Also known as the Private Doctor. This subspecies once existed, then disappeared, and has since returned — and is currently thriving.</p>
        <p>Two equally popular theories explain the name "Private." The first holds it describes his manner toward other species: he accepts and treats them regardless of Bribe fruit. The second holds it simply describes what he always has on hand — "pri-vati," the medical materials needed for daily interventions: cotton, gauze, gloves, syringes.</p>
        <div class="guideline">Guide note: field researchers note that both theories may be true simultaneously, which is rare for theories in the Park.</div>
      </div>

      <div class="card" id="mitus-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 22 34" fill="none">
            <path d="M11 33V16" stroke="#6b4a1a" stroke-width="2.5"/>
            <ellipse cx="11" cy="14" rx="4.5" ry="7.5" fill="#c9962b"/>
            <ellipse cx="5.5" cy="20" rx="3" ry="5.4" fill="#d9a83a" transform="rotate(-25 5.5 20)"/>
            <ellipse cx="16.5" cy="20" rx="3" ry="5.4" fill="#d9a83a" transform="rotate(25 16.5 20)"/>
          </svg>
          <div class="card-titles">
            <h3>The Bribe</h3>
            <div class="latin">Mitus — family Corruption (Coruptia)</div>
          </div>
        </div>
        <p>A plant of the family Corruption (<i>Coruptia</i>), blooming in every part of National Park Serbia. Its fruits grow and ripen in the bags, crates, bottles, pockets, and envelopes of the victims who come to the Bribable Doctor's den — where they are diligently collected and stored.</p>
        <p>The fruit is unusual and varied in form. Two are by far the most common:</p>
        <p><b style="color:var(--amber-bright);">Covert Bribe (Mitus covertus)</b> — carried in envelopes.<br>
        <b style="color:var(--amber-bright);">Bottled Bribe (Mitus becrius)</b> — carried in bottles.</p>

        <div class="doctor-sim">
          <div class="doctor-sim-head">FIELD TEST — light exposure</div>
          <div class="mitus-stage" id="mitusStage">
            <div class="mitus-plant" id="mitusPlant">
              <svg width="70" height="90" viewBox="0 0 22 34" fill="none">
                <path d="M11 33V16" stroke="#6b4a1a" stroke-width="2.5"/>
                <ellipse cx="11" cy="14" rx="4.5" ry="7.5" fill="#c9962b"/>
                <ellipse cx="5.5" cy="20" rx="3" ry="5.4" fill="#d9a83a" transform="rotate(-25 5.5 20)"/>
                <ellipse cx="16.5" cy="20" rx="3" ry="5.4" fill="#d9a83a" transform="rotate(25 16.5 20)"/>
              </svg>
            </div>
            <div class="mitus-fruits" id="mitusFruits">
              <span title="Covert Bribe">✉️</span>
              <span title="Bottled Bribe">🍾</span>
            </div>
          </div>
          <div class="doctor-buttons">
            <button id="shadeBtn" class="dbtn dbtn-empty">Keep in the Shade</button>
            <button id="sunBtn" class="dbtn dbtn-bribe">Expose to Sunlight</button>
          </div>
          <div class="doctor-status" id="mitusStatus">Resting quietly in a dark corner of the Park.</div>
        </div>

        <div class="guideline">Guide note: one of the rare plants actually harmed by sunlight — though recently it has begun appearing openly, in broad daylight, seemingly unbothered.</div>
      </div>

      <div class="card" id="cop-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <path d="M4 8 h18 v3 h-18 z" fill="#4a3a24"/>
            <circle cx="13" cy="10" r="6" fill="#c99a6b"/>
            <path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#6b5433"/>
          </svg>
          <div class="card-titles">
            <h3>Brown Street Cop</h3>
            <div class="latin">Mupus murius</div>
          </div>
        </div>
        <p>Easy to recognize: he's a cop, he looks grim, and he's on the street. While most inhabitants of the Park try to go out only when they must, and even then briefly, the Brown Street Cop is always on the street, moving about like a fish in water. That's where he finds himself (and everyone else) — where he lives, hunts, and, if necessary, multiplies into a Cordon.</p>
        <p>He has no subspecies and never mutates into anything else, not even when retired. For him the saying applies: <i>Once Murius — always Murius.</i></p>
        <p>He is an omnivore, though a cautious one. He rarely dares hunt the larger Heavy Mafioso (<i>Crimos mafiosus</i>) — too big a bite — and avoids the smaller Bald Commoner (<i>Glavus obrianus</i>) altogether. Occasionally he jumps on a Cigarette Smuggler (<i>Torbacus tobacus</i>), or, more rarely, a Striking Street Dealer (<i>Devizus devizus devizus</i>) — a distant relative, by street lineage. Since such prey doesn't even feed his vanity, it only makes him grimmer.</p>
        <p>He is easily trained: delivering smuggled goods, hiding in bushes to jump out with radar switched on, spotting the tiniest infractions while ignoring the biggest ones. His close relative is the Lying Street Cop (<i>Mupus carterlupus</i>).</p>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Street Encounter</div>
          <div class="encounter-stage">
            <div class="cop-figure" id="copFigure">
              <svg width="52" height="66" viewBox="0 0 26 34" fill="none">
                <path d="M4 8 h18 v3 h-18 z" fill="#4a3a24"/>
                <circle cx="13" cy="10" r="6" fill="#c99a6b"/>
                <path id="copBody" d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#6b5433"/>
              </svg>
              <div class="doc-speech" id="copSpeech" style="color:#eef3ee;">Patrolling.</div>
            </div>
            <div class="encounter-chips" id="encounterChips">
              <button class="chip" data-r="avoid" data-t="Heavy Mafioso — too big a bite. He suddenly finds something else to look at.">Heavy Mafioso</button>
              <button class="chip" data-r="avoid" data-t="Bald Commoner — not worth the trouble. Avoided on principle.">Bald Commoner</button>
              <button class="chip" data-r="chase" data-t="Cigarette Smuggler — a rare bite. Grim satisfaction, quickly souring.">Cigarette Smuggler</button>
              <button class="chip" data-r="chase" data-t="Striking Street Dealer — a distant relative, by street lineage. Chased anyway.">Street Dealer</button>
              <button class="chip" data-r="fine" data-t="Changeable Student — out looking for change. The Baton is produced.">Changeable Student</button>
              <button class="chip" data-r="fine" data-t="Neglected Citizen — gathered in the street hungry for Constitutional Rights. Fined for loitering.">Neglected Citizen</button>
              <button class="chip" data-r="fine" data-t="Bare-Boned Pensioner — fined with delight for crossing outside the pedestrian line.">Bare-Boned Pensioner</button>
            </div>
          </div>
          <div class="doctor-status" id="encounterStatus">Select a passer-by to see how the Brown Street Cop reacts.</div>
        </div>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Talk to the Cop (ten sentences)</div>
          <div class="talk-stage">
            <div class="talk-line" id="talkLine">Press the button. He'll do the talking.</div>
          </div>
          <div class="doctor-buttons">
            <button id="talkBtn" class="dbtn dbtn-bribe">Talk to the Cop →</button>
          </div>
          <div class="doctor-status" id="talkCounter">Line 0 / 10</div>
        </div>

        <p style="margin-top:16px;"><b style="color:var(--amber-bright);">The Baton (?)</b> — of hard origin. Insufficiently studied. Whoever came close enough to examine it later had a headache and couldn't remember anything.</p>
        <div class="guideline">Guide note: he uses only ten sentences. Learn them, and you will never misunderstand him.</div>
      </div>

      <div class="card" id="cordon-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <path d="M2 8 h7 v3 h-7 z M10 8 h7 v3 h-7 z M18 8 h7 v3 h-7 z" fill="#4a3a24"/>
            <circle cx="5.5" cy="10" r="3" fill="#c99a6b"/><circle cx="13.5" cy="10" r="3" fill="#c99a6b"/><circle cx="21.5" cy="10" r="3" fill="#c99a6b"/>
            <path d="M0 33c0-7 2-11 5.5-11s5.5 4 5.5 11z M8 33c0-7 2-11 5.5-11s5.5 4 5.5 11z M16 33c0-7 2-11 5.5-11s5.5 4 5.5 11z" fill="#6b5433"/>
          </svg>
          <div class="card-titles">
            <h3>Cordon</h3>
            <div class="latin">Cordonum batinarium</div>
          </div>
        </div>
        <p>A completely separate organism, made up of several Brown Street Cops linked together. It reacts to stimuli completely differently than a single cop. Although one might expect it to be more advanced than the individual, the opposite is true: the Cordon is at a lower stage of development, incapable of reasoning or self-organization. It is entirely dependent on the Commander — a Brown Street Cop with pork cracklings.</p>
        <p>Its function is simple, consisting of only two elements: standing and charging. Standing includes blocking. Charging implies beating. Simple as beans. That's why it works.</p>
        <p>It hunts in murky waters. It lies on money. It eats in taverns. It drinks in cafés. It's everywhere. Always "in an unbelievable crowd."</p>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Form the Cordon</div>
          <div class="cordon-stage" id="cordonStage"></div>
          <div class="sim-controls" style="margin-top:12px;">
            <span>1 OFFICER</span>
            <input type="range" id="cordonSlider" min="1" max="8" value="1">
            <span>8 OFFICERS</span>
          </div>
          <div class="doctor-buttons">
            <button id="standBtn" class="dbtn dbtn-empty" disabled>Stand (Block)</button>
            <button id="chargeBtn" class="dbtn dbtn-bribe" disabled>Charge (Baton)</button>
          </div>
          <div class="doctor-status" id="cordonStatus">A single Brown Street Cop. Capable of independent thought, more or less.</div>
        </div>

        <div class="guideline">Guide note: no individual Cordon officer has ever been observed reasoning independently while still part of the formation.</div>
      </div>

      <div class="card" id="clerk-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <circle cx="13" cy="7" r="6" fill="#e0a06b"/>
            <path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="var(--red)"/>
          </svg>
          <div class="card-titles">
            <h3>Wild Counter Clerk</h3>
            <div class="latin">Nervozus shicanorum pauza</div>
          </div>
        </div>
        <p>A long line of members of various species stands obediently, quietly, like at a watering hole, in front of a transparent barrier with a small, very small hole. On the other side of that hole lives one of the most aggressive sitting beings in the Park — a creature other inhabitants avoid whenever they can.</p>
        <p>He is characterized above all by what he eats: the livers and nerves of everyone caught on the other side of the hole, gladly seasoned with their helplessness. None of this can be swallowed or digested, however, without a large amount of paper plants from the family <i>Formulari (Papyrologia)</i> — especially if filled out sloppily, unsigned, and unstamped.</p>
        <p>There is also the <b style="color:var(--amber-bright);">Tame Counter Clerk</b> — far rarer, and his complete opposite: kind, helpful, smiling, willing to assist even the Neglected Citizen lost among the Forms. But on the rare days when the Pension Plant (<i>Myzeria</i>) bears fruit and Bare-Boned Pensioners gather in enormous numbers at the counter, even the tamest Tame Counter Clerk can turn Wild. The reverse process has never been recorded.</p>
        <p>He distinguishes two kinds of working time: <b style="color:var(--amber-bright);">Break (Pauza)</b>, the peak of counter satisfaction, prolonged by techniques such as the Extended Breakfast, the Blocked Terminal, the Noon Shift, the One-Counter-Only, and Sheer Insolence (often combined) — and <b style="color:var(--amber-bright);">Work With Clients (Antipauza)</b>, the blink between two Breaks. Sometimes he even hunts by imitating a Tame Counter Clerk, luring the victim into relaxing before — hop! — they're caught.</p>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Counter Encounter</div>
          <div class="chat-stage" id="chatStage">
            <div class="chat-placeholder" id="chatPlaceholder">Press "Approach the Counter" to begin.</div>
          </div>
          <div class="doctor-buttons">
            <button id="chatBtn" class="dbtn dbtn-bribe">Approach the Counter →</button>
            <button id="chatReset" class="dbtn dbtn-empty">Reset</button>
          </div>
          <div class="doctor-status" id="chatCounter">Line 0 / 23</div>
        </div>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Coefficient of Wildness</div>
          <p style="font-size:12px;color:#eef3ee;margin-top:0;">Breaks ÷ Clients Served, multiplied by the time distance from the nearest weekend, holiday, annual leave, or payday.</p>
          <div class="wild-controls">
            <label>Breaks taken today <span id="brkVal">6</span><input type="range" id="brkSlider" min="1" max="12" value="6"></label>
            <label>Clients served <span id="cliVal">3</span><input type="range" id="cliSlider" min="1" max="12" value="3"></label>
            <label>Days from payday/weekend <span id="dayVal">2</span><input type="range" id="daySlider" min="0" max="14" value="2"></label>
          </div>
          <div class="wild-readout">
            <div class="wild-number" id="wildNumber">4.0</div>
            <div class="wild-label" id="wildLabel">IRRITABLE</div>
          </div>
          <div class="doctor-status" id="wildStatus">Adjust the sliders to calculate today's Coefficient of Wildness.</div>
        </div>

        <div class="guideline">Guide note: the Coefficient has never once been observed to fall to zero, even on vacation.</div>
      </div>

      <div class="card" id="formulari-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <rect x="4" y="4" width="18" height="26" rx="1.5" fill="var(--paper)"/>
            <rect x="7" y="9" width="12" height="1.6" fill="#7f8a58"/>
            <rect x="7" y="14" width="12" height="1.6" fill="#7f8a58"/>
            <rect x="7" y="19" width="8" height="1.6" fill="#7f8a58"/>
          </svg>
          <div class="card-titles">
            <h3>Formulari</h3>
            <div class="latin">family Papyrologia</div>
          </div>
        </div>
        <p>Full name: Forms With Required Documentation. These paper plants play an important role in the Wild Counter Clerk's digestion — they help soak the victim, whose liver is already eaten and nerves already frayed, in even more anger, making the blood boil and the victim juicier and easier to digest.</p>
        <p>Formulari multiply constantly and quickly. By the simplest classification they divide into personal documents, certificates, decisions, requests, confirmations, extracts, submissions, payment slips, petitions, and appeals. But that is never the end — just when the victim believes they have brought everything, the Wild Counter Clerk needs something else, usually whatever the victim does not have.</p>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — The Endless Checklist (vehicle registration)</div>
          <p style="font-size:11.5px;color:#9fb0a8;margin-top:0;">Try to check off every required document. Good luck.</p>
          <div class="checklist" id="checklist"></div>
          <div class="doctor-status" id="checklistStatus">Documents required so far: <b id="reqCount">5</b></div>
        </div>

        <div class="guideline">Guide note: to survive the first attack, carry at minimum one certified confirmation of proof of payment of tax on the original photocopy of the decision on the request. It will not be enough.</div>
      </div>

      <div class="card" id="businessmen-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <rect x="3" y="18" width="20" height="10" rx="1" fill="#5c4a30"/>
            <circle cx="8" cy="12" r="4" fill="#e0a06b"/><circle cx="18" cy="12" r="4" fill="#e0a06b"/>
            <rect x="5" y="16" width="6" height="4" fill="#4a3a24"/><rect x="15" y="16" width="6" height="4" fill="#4a3a24"/>
          </svg>
          <div class="card-titles">
            <h3>Eight Serbian Businessmen</h3>
            <div class="latin">Camionus avionus</div>
          </div>
        </div>
        <p>A raised hand and a blurred gaze at the noisiest table, in the never sufficiently separated part of the tavern. Eight Serbian Businessmen at a business lunch. It radiated Cyrillic.</p>
        <p>The waiter knew the order by heart: 8 veal soups; 8 appetizers (kajmak, cheese, prosciutto, eggs) on two platters; 8 "Serbian with cheese" on two platters; 8 portions of mixed meat on two platters; 12 flatbreads. To drink: six viljamovka brandies and two homemade, plus nine kilos of table white wine and twice as much soda water.</p>
        <p>He confirmed the raised hand with a smile and walked over, pen and a crumpled paper already in hand — the bill, written in his own hand. <i>"They've played themselves silly. I'll inflate their bill at least three hundred percent,"</i> he decided on the way.</p>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Present the Bill</div>
          <div class="bill-stage">
            <div class="bill-row"><span>True total (kitchen price)</span><b id="billTrue">41,300 din</b></div>
            <div class="bill-row"><span>Presented total</span><b id="billFinal">— din</b></div>
          </div>
          <div class="doctor-buttons">
            <button id="billBtn" class="dbtn dbtn-bribe">Present the Bill</button>
          </div>
          <div class="doctor-status" id="billStatus">The table hasn't noticed a thing yet.</div>
        </div>

        <div class="guideline">Guide note: no Eight Serbian Businessmen have ever been observed counting the flatbreads.</div>
      </div>

      <div class="card" id="singer-card">
        <div class="card-head">
          <svg class="card-icon" width="32" height="40" viewBox="0 0 30 34" fill="none">
            <path d="M15 4 L6 16 L11 15 L8 24 L15 17 L22 24 L19 15 L24 16 Z" fill="#c9962b" opacity=".55"/>
            <circle cx="15" cy="9" r="5" fill="#e0a06b"/>
            <path d="M8 30c0-8 3-13 7-13s7 5 7 13z" fill="var(--red)"/>
            <circle cx="10" cy="24" r="1.4" fill="#f4bd45"/><circle cx="14" cy="27" r="1.4" fill="#f4bd45"/><circle cx="19" cy="24" r="1.4" fill="#f4bd45"/>
          </svg>
          <div class="card-titles">
            <h3>Naked Singer</h3>
            <div class="latin">Gologuza Pevaljka</div>
          </div>
        </div>
        <p>A relatively young species, born of a crossing between the Pretentious Artist (<i>Mrsus mudus</i>) and the Gossip Granny (<i>Baca-caca</i>). From the Pretentious Artist she inherited an affinity for Art and for Pretentiousness; from the Gossip Granny, an affinity for the worst nonsense.</p>
        <p>She strongly resembles several birds at once: dresses like a parrot, struts like a peacock, has nails like an eagle, and possesses a chicken brain. Compared to all of them — and to most other species in the Park — she simply has more expensive feathers.</p>
        <p>Two basic (sub)species are recognized: the <b style="color:var(--amber-bright);">Fake Folk Singer</b> (<i>Pseudomelos turbofolcus</i>) and the <b style="color:var(--amber-bright);">Fake Pop Singer</b> (<i>Pseudopopus technodensus</i>). She is a good flyer, but flies only on weekends and only abroad, greedy for money in huge amounts — which is also why National Park Serbia falls unnaturally quiet on weekends: not a single Naked Singer capable of producing a sound remains behind.</p>
        <p>A species without males (the term "Naked Male Singer" describes a property status, not a separate species), she mates alone, without complexes. Her greatest enemy is never a predator, nor the Neglected Citizen who cannot stand her — it is always another Naked Singer, though this never stops the two from flying together, in the same plane, to richer lands.</p>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Compose the Squeal</div>
          <div class="squeal-layout">
            <div class="squeal-controls">
              <p style="font-size:11.5px;color:#9fb0a8;margin-top:0;">Toggle the sounds. In the world of Naked Singers, all of this is called singing.</p>
              <div class="squeal-chips" id="squealChips">
                <button class="chip" data-s="Yelling">Yelling</button>
                <button class="chip" data-s="Wailing">Wailing</button>
                <button class="chip" data-s="Howling">Howling</button>
                <button class="chip" data-s="Screeching">Screeching</button>
                <button class="chip" data-s="Shrieking">Shrieking</button>
              </div>
              <div class="wild-readout" style="margin-top:12px;">
                <div class="wild-number" id="payoutNumber">0</div>
                <div class="wild-label" id="payoutLabel">SILENCE</div>
              </div>
              <div class="doctor-buttons" style="margin-top:12px;">
                <button id="performBtn" class="dbtn dbtn-bribe">▶ Start Performance</button>
                <button id="stopBtn" class="dbtn dbtn-empty" disabled>■ Stop</button>
              </div>
              <div class="doctor-status" id="squealStatus">Select at least one sound to begin the performance.</div>
            </div>
            <div class="squeal-video">
              <div class="squeal-video-label">REFERENCE FOOTAGE</div>
              <div class="tv-set">
                <div class="tv-antennas">
                  <span class="tv-antenna tv-antenna-left"></span>
                  <span class="tv-antenna tv-antenna-right"></span>
                </div>
                <div class="tv-body">
                  <div class="tv-screen-bezel">
                    <div class="squeal-video-frame" id="squealVideoFrame">
                      <img src="https://i.ytimg.com/vi/YrKlShcQqqw/hqdefault.jpg" alt="Reference footage thumbnail" onerror="this.style.display='none'">
                      <button class="squeal-play" id="squealPlayBtn" type="button" aria-label="Play video">▶</button>
                    </div>
                  </div>
                  <div class="tv-controls">
                    <span class="tv-knob"></span>
                    <span class="tv-knob small"></span>
                  </div>
                </div>
                <div class="tv-legs"><span></span><span></span></div>
              </div>
            </div>
          </div>
        </div>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Press Record: Give a Statement</div>
          <div class="talk-stage"><div class="talk-line" id="quoteLine">Press the button for her thoughts on the new project.</div></div>
          <div class="doctor-buttons">
            <button id="quoteBtn" class="dbtn dbtn-bribe">Give a Statement →</button>
          </div>
        </div>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Park Noise Level</div>
          <div class="doctor-buttons" style="margin-top:0;">
            <button id="weekdayBtn" class="dbtn dbtn-empty">Weekday</button>
            <button id="weekendBtn" class="dbtn dbtn-bribe">Weekend</button>
          </div>
          <div class="meter" style="width:100%;height:12px;margin-top:12px;"><i id="noiseMeter" style="width:85%;"></i></div>
          <div class="doctor-status" id="noiseStatus">Weekday: the Park hums with squealing as usual.</div>
        </div>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Dress the Naked Singer</div>
          <p style="font-size:11.5px;color:#9fb0a8;margin-top:0;">Click each item of standard equipment to apply it — and watch her change.</p>

          <div class="dress-stage">
            <svg viewBox="0 0 200 260" width="190" height="247">
              <circle id="fameGlow" cx="100" cy="130" r="85" fill="var(--amber-bright)" opacity="0" style="filter:blur(16px);"/>

              <rect x="82" y="190" width="14" height="55" rx="6" fill="#e0a06b"/>
              <rect x="104" y="190" width="14" height="55" rx="6" fill="#e0a06b"/>
              <g id="legHatch" stroke="#8a5a30" stroke-width="1.4">
                <line x1="85" y1="200" x2="91" y2="196"/>
                <line x1="85" y1="212" x2="91" y2="208"/>
                <line x1="85" y1="224" x2="91" y2="220"/>
                <line x1="107" y1="200" x2="113" y2="196"/>
                <line x1="107" y1="212" x2="113" y2="208"/>
                <line x1="107" y1="224" x2="113" y2="220"/>
              </g>

              <ellipse id="rearPad" cx="100" cy="186" rx="36" ry="16" fill="#c9962b" opacity="0"/>

              <path d="M70 130 Q100 115 130 130 L138 195 Q100 210 62 195 Z" fill="var(--red)"/>
              <circle cx="82" cy="150" r="2" fill="#f4bd45"/><circle cx="100" cy="160" r="2" fill="#f4bd45"/><circle cx="118" cy="150" r="2" fill="#f4bd45"/>
              <circle cx="90" cy="175" r="2" fill="#f4bd45"/><circle cx="110" cy="178" r="2" fill="#f4bd45"/>

              <ellipse id="chestPad" cx="100" cy="127" rx="27" ry="12" fill="#c9962b" opacity="0"/>

              <rect x="55" y="135" width="12" height="45" rx="6" fill="#e0a06b"/>
              <rect x="133" y="135" width="12" height="45" rx="6" fill="#e0a06b"/>
              <g id="armHatch" stroke="#8a5a30" stroke-width="1.2">
                <line x1="58" y1="145" x2="64" y2="143"/>
                <line x1="58" y1="155" x2="64" y2="153"/>
                <line x1="136" y1="145" x2="142" y2="143"/>
                <line x1="136" y1="155" x2="142" y2="153"/>
              </g>

              <rect x="94" y="95" width="12" height="18" fill="#e0a06b"/>
              <circle cx="100" cy="75" r="24" fill="#e0a06b"/>

              <g id="wig" opacity="0">
                <path d="M76 60 Q100 28 124 60 Q129 44 124 33 Q100 16 76 33 Q71 44 76 60Z" fill="#c9962b"/>
                <path d="M74 61 Q69 80 78 97" stroke="#c9962b" stroke-width="8" fill="none" stroke-linecap="round"/>
                <path d="M126 61 Q131 80 122 97" stroke="#c9962b" stroke-width="8" fill="none" stroke-linecap="round"/>
              </g>

              <circle cx="91" cy="74" r="3.4" fill="#2c1e12"/>
              <circle cx="109" cy="74" r="3.4" fill="#2c1e12"/>
              <g id="lashes" stroke="#2c1e12" stroke-width="1.4" opacity="0">
                <line x1="87" y1="70" x2="84" y2="65"/><line x1="91" y1="69" x2="90" y2="63"/><line x1="95" y1="70" x2="97" y2="65"/>
                <line x1="105" y1="70" x2="103" y2="65"/><line x1="109" y1="69" x2="110" y2="63"/><line x1="113" y1="70" x2="116" y2="65"/>
              </g>

              <path id="mouthDefault" d="M92 86 Q100 88 108 86" stroke="#7a4a34" stroke-width="1.6" fill="none"/>
              <g id="mouthEquipped" opacity="0">
                <path d="M88 85 Q100 97 112 85 Q100 91 88 85Z" fill="#c0405a"/>
                <path d="M91 87 h18 v3 h-18 z" fill="#fff"/>
              </g>

              <g id="mic" opacity="0">
                <rect x="140" y="150" width="7" height="18" rx="3.5" fill="#333"/>
                <line x1="143.5" y1="168" x2="143.5" y2="182" stroke="#333" stroke-width="2"/>
              </g>

              <g id="shine" opacity="0" fill="#fff">
                <circle cx="82" cy="65" r="2"/><circle cx="118" cy="68" r="1.6"/><circle cx="100" cy="132" r="2"/>
              </g>

              <g id="pillIcon" opacity="0" transform="translate(28,38)">
                <rect x="0" y="6" width="12" height="16" rx="2" fill="#e9e3cf"/>
                <rect x="0" y="0" width="12" height="7" rx="2" fill="var(--cyan)"/>
              </g>

              <g id="syringeIcon" opacity="0" transform="translate(160,40) rotate(35)">
                <rect x="0" y="0" width="4" height="20" fill="#cfd9b3"/>
                <rect x="-2" y="18" width="8" height="4" fill="#cfd9b3"/>
                <line x1="2" y1="0" x2="2" y2="-6" stroke="#cfd9b3" stroke-width="2"/>
              </g>
            </svg>
          </div>

          <div class="squeal-chips" id="dressChips">
            <button class="chip" data-key="pills" data-t="Pills for sleeping, for arousal, for calming…">Pills — sleeping / lifting / calming</button>
            <button class="chip" data-key="hormones" data-t="Hormone injections, and anti-hormone injections, as needed.">Hormone injections (and anti-hormone injections)</button>
            <button class="chip" data-key="wig" data-t="Wig, extensions, and inserts, freshly attached.">Wig, extensions & inserts</button>
            <button class="chip" data-key="lashes" data-t="False eyelashes and lenses, blinking convincingly.">False eyelashes & lenses</button>
            <button class="chip" data-key="voice" data-t="Equipment for borrowing a voice. Hers is elsewhere.">Voice-borrowing equipment</button>
            <button class="chip" data-key="teeth" data-t="False teeth, for the widest possible smile.">False teeth</button>
            <button class="chip" data-key="lips" data-t="Silicone for sensual lips, freshly injected.">Silicone — sensual lips</button>
            <button class="chip" data-key="chest" data-t="Silicone for the chest, inflated to spec.">Silicone — chest</button>
            <button class="chip" data-key="rear" data-t="Silicone for the rear, inflated to spec.">Silicone — rear</button>
            <button class="chip" data-key="wax" data-t="Wax, for fine finishing touches.">Wax — fine grooming</button>
            <button class="chip" data-key="trim" data-t="Tools for trimming hair from beard, mustache, legs, arms, shoulders…">Hair-trimming kit (beard, arms, legs…)</button>
          </div>
          <div class="wild-readout" style="margin-top:12px;">
            <div class="wild-number" id="dressNumber">0/11</div>
            <div class="wild-label" id="dressLabel">NATURAL (RARE SIGHTING)</div>
          </div>
          <div class="doctor-status" id="dressStatus">Click an item to begin assembly.</div>
        </div>

        <p style="margin-top:16px; font-size:12.5px; color:#c9d4c9; font-style:italic; border-left:2px solid var(--amber); padding-left:12px;">
          Field diary excerpt — a fan returns home: an orange Lada revved ten times before the engine cut. Slippers, a green spit on the sidewalk, a piglet under one arm and a fuel can under the other. Nine floors up, past chickens pecking the hallway, into an apartment already shaking with folk music loud enough for the whole building to know: he was home, the singing had already begun, and so had the squealing.
        </p>

        <div class="guideline">Guide note: it is never entirely clear when yelling ends and wailing begins. This, apparently, is the charm of it.</div>
      </div>

      <div class="card" id="batinasi-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <path d="M6 20 Q13 4 20 20 L20 14 Q13 2 6 14 Z" fill="#161616"/>
            <ellipse cx="13" cy="15" rx="7" ry="8" fill="#1c1c1c"/>
            <rect x="9" y="18" width="8" height="4" rx="2" fill="#3a3a3a"/>
            <path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#2a2a2a"/>
          </svg>
          <div class="card-titles">
            <h3>Batinaši</h3>
            <div class="latin">Homines brutus hoodicus · Homines fractus costarum</div>
          </div>
        </div>
        <p>A subspecies evolved from the Brown Street Cop (<i>Mupus murius</i>), bred not in academies but in the murky backrooms of shady politics and business. They are the premium, off-the-books "human resources department" of modern corruption.</p>
        <p><b style="color:var(--amber-bright);">Species Plumage:</b> the Obsidian Hood (<i>Hoodicus anonymus</i>), concealing facial features from the gaze of the Neglected Citizen; the Respiratory Veil (<i>Maskus justificatus</i>), ostensibly for health, really for protecting the fragile ecosystem of a criminal record; and the Phantom Satchel (<i>Bagus mysterium</i>), a pouch of indeterminate contents — sometimes nourishment, sometimes weaponry, always uncertainty.</p>
        <p><b style="color:var(--amber-bright);">Habitat & behavior:</b> migratory, rarely seen in daylight unless summoned by signal from a local Tycoon or Political Patron. Known habitats include Polling Stations (conducting "voter satisfaction surveys" by blocking Citizens), the space Behind Pandur Lines (where cousins look away and Batinaši swing freely), and Construction Sites (offering complimentary dental adjustments to protesting Citizens).</p>
        <p><b style="color:var(--amber-bright);">Diet:</b> They feed on the fear, silence, and helplessness of the Neglected Citizen and the Changeable Student, and thrive on the satisfaction of patrons who need "conflict resolution." Their feeding rituals are symbiotic with the survival of dominant species. By consuming fear and silence, they fertilize the soil of authoritarian control, ensuring that corruption continues to flourish as a stable ecological niche.</p>
        <p><b style="color:var(--amber-bright);">Societal role:</b> classified by most Park species as criminal fauna, though the Batinaši insist on their identity as humble service organisms. Ideologically neutral — aligned with neither the Student, the Pandur, nor the Citizen — their loyalty is determined solely by the successful transfer of the Envelope Plant (<i>Envelopia corruptia</i>), whose fruits sustain their existence. Mercenary pollinators of violence, and the ultimate freelancers of the Park: migratory, opportunistic, and indispensable to the survival of corruption as a thriving ecological niche.</p>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Loyalty Compass</div>
          <p style="font-size:11.5px;color:#9fb0a8;margin-top:0;">Loyalty is not a belief. It is a delivery confirmation.</p>
          <div class="compass-stage">
            <svg viewBox="0 0 160 100" width="160" height="100">
              <path d="M20 90 A70 70 0 0 1 140 90" fill="none" stroke="#3a4a44" stroke-width="10"/>
              <text x="14" y="70" fill="#eef3ee" font-size="9" font-family="Arial">STUDENT</text>
              <text x="70" y="16" fill="#eef3ee" font-size="9" font-family="Arial">NOBODY</text>
              <text x="112" y="70" fill="#eef3ee" font-size="9" font-family="Arial">CITIZEN</text>
              <line id="needle" x1="80" y1="90" x2="80" y2="26" stroke="var(--amber-bright)" stroke-width="4" stroke-linecap="round" style="transform-origin:80px 90px; transition:transform .4s ease;"/>
              <circle cx="80" cy="90" r="5" fill="var(--amber-bright)"/>
            </svg>
          </div>
          <div class="doctor-buttons">
            <button id="tycoonBtn" class="dbtn dbtn-bribe">Deliver to Tycoon</button>
            <button id="patronBtn" class="dbtn dbtn-bribe">Deliver to Political Patron</button>
            <button id="noEnvBtn" class="dbtn dbtn-empty">Withhold Envelope</button>
          </div>
          <div class="doctor-status" id="compassStatus">No Envelope delivered. No loyalty exists yet.</div>
        </div>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — The Invisibility Ritual</div>
          <div class="witness-stage" id="witnessStage"></div>
          <div class="doctor-buttons">
            <button id="witnessBtn" class="dbtn dbtn-empty">Add a Witness</button>
            <button id="reportBtn" class="dbtn dbtn-bribe">File Official Report</button>
          </div>
          <div class="doctor-status" id="witnessStatus">Witnesses present: 0</div>
        </div>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Habitat Selector</div>
          <div class="doctor-buttons" style="margin-top:0;">
            <button class="dbtn dbtn-empty habitat-btn" data-h="polling">Polling Station</button>
            <button class="dbtn dbtn-empty habitat-btn" data-h="pandur">Behind Pandur Lines</button>
            <button class="dbtn dbtn-empty habitat-btn" data-h="construction">Construction Site</button>
          </div>
          <div class="doctor-status" id="habitatStatus" style="margin-top:12px;">Select a habitat to observe typical behavior.</div>
        </div>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Pack Hunting</div>
          <p style="font-size:11.5px;color:#9fb0a8;margin-top:0;">They rarely hunt alone. Sound the signal and watch the pack form.</p>
          <div class="pack-stage" id="packStage"></div>
          <div class="doctor-buttons">
            <button id="packBtn" class="dbtn dbtn-bribe">Sound the Signal</button>
            <button id="disperseBtn" class="dbtn dbtn-empty">Disperse (Camouflage)</button>
          </div>
          <div class="doctor-status" id="packStatus">No signal given. The street looks empty.</div>
        </div>

        <div class="guideline">Guide note: the Batinaši do not consider themselves violent. They consider themselves reliable.</div>
      </div>

      <div class="card" id="stinko-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <path d="M9 20c-3-3-3-7 0-10 1 3 2 4 4 3-1 4 0 6 3 7-2 1-5 2-7 0z" fill="#7fae3d" opacity=".55"/>
            <path d="M15 22c2-3 1-6-1-8 0 2-1 3-3 3 1 3 0 5-2 6 2 1 4 1 6-1z" fill="#7fae3d" opacity=".4"/>
            <path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#6b6b52"/>
          </svg>
          <div class="card-titles">
            <h3>Collectivus Stinko Birocorrupticus</h3>
            <div class="latin">order — galactic classification pending</div>
          </div>
        </div>
        <p>Extremely unpleasant to see or smell. Their odor is inseparable from their bureaucratic ecology — the smell of forms, triplicate signatures, and recycled peat firelighters.</p>
        <p>Most species belonging to this order are not described in detail here, because they could not be adequately studied. To put it mildly: they do not smell pleasant, so close approach is not advisable. More bluntly — we are dealing with a very specific stench, one that no washing can remove.</p>
        <p>This odor is the consequence of severe self-neglect in matters of moral, professional, and mental hygiene, precisely by those who bear greater responsibility than others for the appearance and fate of the Park. We mention some of these species below, but keep our distance — for hygienic reasons.</p>

        <p style="margin-top:14px;"><b style="color:var(--amber-bright);">Galactic order of foul-smelling subspecies:</b></p>
        <ul style="margin:0 0 6px; padding-left:18px; font-size:13.5px; line-height:1.75; color:#eef3ee;">
          <li>Abusive Intellectual (<i>Intellectus abusivus</i>)</li>
          <li>Pseudo-Priest (<i>Sacerdotus falsus</i>)</li>
          <li>Bribed Artist (<i>Creativus corruptus stinko corapticus</i>)</li>
          <li>Obedient Judge (<i>Judex servilis</i>) — Attack Method: issues verdicts that crush Citizens while protecting predators. Societal Role: a keystone species in the ecosystem of injustice, ensuring corruption remains legally fragrant.</li>
          <li>Biased Journalist (<i>Scriptor partialis</i>)</li>
          <li>Self-Serving Humanist (<i>Humanista egocentricus</i>)</li>
          <li>Unqualified Expert (<i>Expertus ineptus</i>)</li>
        </ul>
        <p>There are more of them, but it is very difficult to be around them.</p>
        <p>Of all the listed Collectivus stinko birocorrupticus, the only one that could be studied in detail on previous pages — and therefore does not appear on this list — is the Corrupt Politician (<i>Potestas malversata</i>). This was possible thanks to the intense, sickly-sweet, camouflaging odor of Demagogy, which follows him everywhere and can temporarily suppress his strong authentic stench. Hence the (completely false) saying that "he neither stinks nor smells."</p>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Odor Assessment</div>
          <p style="font-size:11.5px;color:#9fb0a8;margin-top:0;">Select subjects for study. Proceed at your own olfactory risk.</p>
          <div class="squeal-chips" id="odorChips">
            <button class="chip" data-t="Reeks of certainty and unread footnotes.">Abusive Intellectual</button>
            <button class="chip" data-t="A holy smell, entirely synthetic.">Pseudo-Priest</button>
            <button class="chip" data-t="Notes of turpentine, flattery, and an invoice.">Bribed Artist</button>
            <button class="chip" data-t="Smells faintly of a verdict already decided.">Obedient Judge</button>
            <button class="chip" data-t="A press-release odor, sprayed over the facts.">Biased Journalist</button>
            <button class="chip" data-t="Smells of good intentions, left out too long.">Self-Serving Humanist</button>
            <button class="chip" data-t="An odor of confidence, unsupported by anything.">Unqualified Expert</button>
          </div>
          <div class="wild-readout" style="margin-top:12px;">
            <div class="wild-number" id="odorNumber">0%</div>
            <div class="wild-label" id="odorLabel">NO SAMPLES TAKEN</div>
          </div>
          <div class="doctor-status" id="odorStatus">Select at least one subject to begin the study.</div>
        </div>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Approach Distance</div>
          <div class="stink-stage">
            <svg viewBox="0 0 200 90" width="200" height="90">
              <circle cx="40" cy="55" r="16" fill="#6b6b52"/>
              <g id="stinkCloud" opacity="0.3">
                <circle cx="62" cy="40" r="10" fill="#7fae3d"/>
                <circle cx="74" cy="48" r="13" fill="#7fae3d"/>
                <circle cx="66" cy="55" r="9" fill="#7fae3d"/>
              </g>
              <circle id="stinkPerson" cx="170" cy="55" r="12" fill="#e0a06b"/>
            </svg>
          </div>
          <div class="sim-controls" style="margin-top:10px;">
            <span>SAFE DISTANCE</span>
            <input type="range" id="stinkSlider" min="0" max="100" value="5">
            <span>POINT-BLANK</span>
          </div>
          <div class="doctor-status" id="stinkStatus">Holding at a respectful, hygienic distance.</div>
        </div>

        <div class="guideline">Guide note: the proper olfactory conditions for a thorough study have not yet been established. Given their current contribution to the "improvement" of the Park, Collectivus stinko birocorrupticus remain where they are — at the very end.</div>
      </div>

      <div class="card" id="wretch-card">
        <div class="card-head">
          <svg class="card-icon" width="30" height="40" viewBox="0 0 26 34" fill="none">
            <circle cx="13" cy="7" r="6" fill="#c9b48a"/>
            <path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#6a6455"/>
            <rect x="8" y="19" width="10" height="7" rx="1" fill="#e6cfa9"/>
            <line x1="9" y1="22" x2="17" y2="22" stroke="#6a6455" stroke-width="1"/>
          </svg>
          <div class="card-titles">
            <h3>Educational Wretch <span style="font-size:11px;color:#bcd6cc;font-weight:400;">— mutated from the Educational Worker</span></h3>
            <div class="latin">Profus yadibedus</div>
          </div>
        </div>
        <p>The Educational Wretch arose through mutation from the once-widespread Educational Worker (<i>Profus autoritetus</i>), a change forced on the species by severe socio-climatic decline across National Park Serbia. The Worker is now all but extinct; the Wretch, unfortunately, adapts to almost nothing.</p>
        <p>The mutation reached far past the name. Every fixture of the Worker's old life curdled along with it:</p>
        <p style="margin:6px 0 6px 4px;">
          the working day → the <i>wretched</i> day<br>
          the working Saturday → the <i>wretched</i> Saturday<br>
          the working lifetime → the <i>wretched</i> lifetime<br>
          years of service → years of misery<br>
          working days counted → miserable days counted
        </p>
        <p>Its defining symptom is a chronic condition called <b style="color:var(--amber-bright);">Wretchedness</b> (known to some field scholars as Wretcheditis, or Miserosity), quantified by the <b style="color:var(--amber-bright);">Wretchedness Factor (Wf)</b> — a scale that runs from zero to infinity and has, in National Park Serbia, never once been observed to return to zero.</p>
        <p>Like the Unpaid (State) Doctor and the Neglected Citizen, the Wretch cannot maintain a stable population thanks to <b style="color:var(--amber-bright);">Delayed Paycheck Syndrome (Smejuria)</b> — the same stunted Salary Plant whose lateness starves several other Park species. Because its entire life cycle revolves around a monthly paycheck that arrives later with each passing season, the Wretch has evolved a small set of parallel survival techniques simply to keep breathing:</p>
        <p style="margin:6px 0 6px 4px; font-size:13.5px; line-height:1.7;">
          <b style="color:var(--amber-bright);">Stubborn Indifference</b> — "You keep acting up, I'll keep teaching. Let's see who gives up first."<br>
          <b style="color:var(--amber-bright);">Afternoon Side-Hustle</b> — the Multi-Level Survival Strategy: "The regular one's fine... but it'd be even better if you bought my Super-Slicer."<br>
          <b style="color:var(--amber-bright);">Parents' Wallet Exploitation</b> — conducted by cross-examination: "So, what do your mom and dad do for a living? Surely they could donate some test tubes to the school..."<br>
          <b style="color:var(--amber-bright);">Field Trip Exploitation</b> — securing a free excursion for its own offspring via a mutually beneficial arrangement with the travel agency.<br>
          <b style="color:var(--amber-bright);">Hopelessly-in-Love-with-the-Job</b> — a technique that keeps the Wretch alive in the short term, and considerably more wretched in the long term.
        </p>
        <p><b style="color:var(--amber-bright);">On the Wf itself:</b> the Wretchedness Factor is less a measurement than a confession of worthlessness — the higher it climbs, the less the species can adapt, and the harder it fights simply to remain on the payroll. Its true ceiling has never been recorded, though National Park Serbia is widely believed to hold the world title in educational misery, contested only by a handful of national parks in Africa or Asia.</p>

        <div class="guideline" style="border-left-color:#8a9a86; color:#c7d6c2;">Archival record — the Educational Worker (<i>Profus autoritetus</i>): legend holds that this near-mythical ancestor once entered and left a classroom unmolested by flying chalk or the classroom sponge, and could apparently teach other people's offspring something by the simple act of lecturing. Some witnesses go further, insisting it commanded actual authority over those offspring. Modern scholars file this under folklore.</div>

        <div class="doctor-sim">
          <div class="doctor-sim-head">LIVE SIMULATOR — Wretchedness Factor (Wf) Reading</div>
          <p style="font-size:11.5px;color:#9fb0a8;margin-top:0;">Adjust the paycheck delay. Deploy survival techniques if you'd like to feel better about the number.</p>
          <div class="wild-controls">
            <label>Days the paycheck is late <span id="wfDaysVal">0</span><input type="range" id="wfSlider" min="0" max="45" value="0"></label>
          </div>
          <div class="encounter-chips" id="wfChips" style="margin-bottom:12px;">
            <button class="chip" data-tech="indifference">Stubborn Indifference</button>
            <button class="chip" data-tech="sidehustle">Afternoon Side-Hustle</button>
            <button class="chip" data-tech="wallet">Parents' Wallet Exploitation</button>
            <button class="chip" data-tech="fieldtrip">Field Trip Exploitation</button>
            <button class="chip" data-tech="love">Hopelessly-in-Love</button>
          </div>
          <div class="wild-readout">
            <div class="wild-number" id="wfNumber">0.0</div>
            <div class="wild-label" id="wfLabel">MANAGEABLE</div>
          </div>
          <div class="doctor-status" id="wfStatus">Paycheck currently on time. Enjoy it — it won't last.</div>
        </div>

        <div class="guideline">Guide note: the Wf has a lower bound of zero and, functionally, no upper one. Deploying all five survival techniques at once has been observed to slow its climb — never reverse it.</div>
      </div>
    </div>

    <div class="footer">
      <button class="dontpanic" id="dontPanicBtn" type="button">DON'T PANIC</button>
      <div class="dontpanic-msg" id="dontPanicMsg"></div>
      <span class="fine">FIELD ENTRY LOGGED · NATIONAL PARK SERBIA · SHADOW LEVELS SUBJECT TO CHANGE WITHOUT NOTICE</span>
    </div>
  </div>
</div>

<script>
  // ---- typewriter intro ----
  const introFull = "When a Corrupt Politician is in Power — which is extremely high and wide, and can be unbelievably enormous — then a large part of National Park SERBIA lies in its shadow, and very little manages to grow. The ones who suffer most are the already weak and fragile species.";
  const entryEl = document.getElementById('entryText');
  let i = 0;
  function typeIntro(){
    if(i <= introFull.length){
      entryEl.innerHTML = '<span class="cap">GUIDE ENTRY:</span> ' + introFull.slice(0,i) + '<span class="typecursor"></span>';
      i += 2;
      requestAnimationFrame(()=> setTimeout(typeIntro, 14));
    } else {
      entryEl.innerHTML = '<span class="cap">GUIDE ENTRY:</span> ' + introFull;
    }
  }
  typeIntro();

  // ---- tabs ----
  document.querySelectorAll('.tab').forEach(btn=>{
    btn.addEventListener('click', ()=>{
      document.querySelectorAll('.tab').forEach(b=>b.classList.remove('active'));
      document.querySelectorAll('.card').forEach(c=>c.classList.remove('show'));
      btn.classList.add('active');
      document.getElementById(btn.dataset.card).classList.add('show');
      if(window.speechSynthesis) window.speechSynthesis.cancel();
      if(typeof resetReadAloudBtn === 'function') resetReadAloudBtn();
    });
  });

  // ---- power / shadow simulator ----
  const slider = document.getElementById('powerSlider');
  const tower = document.getElementById('towerBar');
  const politician = document.getElementById('politician');
  const shadow = document.getElementById('shadowCast');
  const civMeter = document.getElementById('civMeter');
  const civPct = document.getElementById('civPct');
  const heightReadout = document.getElementById('heightReadout');
  const simStatus = document.getElementById('simStatus');

  const citizen = document.getElementById('citizen');
  const pensioner = document.getElementById('pensioner');
  const demagogy = document.getElementById('demagogy');

  function heightLabel(v){
    if(v < 15) return "UNBELIEVABLY MODEST";
    if(v < 35) return "NOTICEABLY TALL";
    if(v < 60) return "EXTREMELY HIGH AND WIDE";
    if(v < 85) return "OMINOUSLY VAST";
    return "UNBELIEVABLY ENORMOUS";
  }

  function statusLine(v){
    if(v < 15) return "A modest amount of light still reaches the ground. The Guide rates this an unusually good day for a National Park.";
    if(v < 35) return "The shadow lengthens. The Neglected Citizen begins to squint at the word 'rights' printed on a sun-bleached sign.";
    if(v < 60) return "Very little manages to grow. The Skinny Pensioner's Myzeria has visibly shrunk. Demagogy, however, is doing rather well.";
    if(v < 85) return "The park lies almost entirely in shadow. Weeds have given up. Demagogy is now the tallest thing left standing, besides the Politician.";
    return "Total eclipse. Nothing grows here except Demagogy, which — as the Guide notes — is the only one that thrives well at the foot of every Power.";
  }

  function update(v){
    const towerH = 26 + v*1.7;
    tower.style.height = towerH + 'px';
    tower.style.width = (22 + v*0.12) + 'px';
    politician.style.transform = `scale(${1 + v*0.006})`;

    const shadowW = 20 + v*4.3;
    shadow.style.width = shadowW + 'px';
    shadow.style.height = (2 + v*0.12) + 'px';
    shadow.style.opacity = 0.5 + (v/100)*0.4;

    heightReadout.textContent = 'CURRENT HEIGHT: ' + heightLabel(v);

    const civ = Math.max(2, 30 - v*0.28);
    civMeter.style.width = civ + '%';
    civPct.textContent = Math.round(civ) + '%';

    // wilt thresholds
    citizen.classList.toggle('wilt', v > 25);
    pensioner.classList.toggle('wilt', v > 40);
    // demagogy thrives instead — grows with shadow
    const dScale = 1 + Math.min(v,100)*0.006;
    demagogy.style.transform = `scale(${dScale})`;
    demagogy.querySelector('.icon').style.filter = v > 40 ? 'saturate(1.3) brightness(1.08)' : 'none';

    simStatus.textContent = statusLine(v);
  }

  slider.addEventListener('input', e => update(Number(e.target.value)));
  update(Number(slider.value));

  // ---- Bribable Doctor live simulator ----
  const docFigure = document.getElementById('docFigure');
  const docSpeech = document.getElementById('docSpeech');
  const denGoods = document.getElementById('denGoods');
  const doctorStatus = document.getElementById('doctorStatus');
  const jawPath = document.getElementById('docJaw');

  const bribeGoods = ['🐷','🐑','🐔','🥚','🧀','🍯','🍇','🍷','🥃','☕','🚬','✉️'];
  let bribeCount = 0;

  const bribeLines = [
    "Jaw drops. Adrenaline spikes. \"Ah — come in, come in, sit down!\"",
    "Suddenly hyperactive. Everything previously impossible is now possible.",
    "Muscles spasm briefly with enthusiasm. A full examination is offered, unprompted.",
    "The Doctor beams. Another item finds its way into the den."
  ];
  const emptyLines = [
    "\"Hm. Yes. Take two of these and don't come back.\"",
    "A generic Therapy is prescribed within four seconds flat.",
    "The Doctor has already stopped listening.",
    "No Bribe, no interest. Next."
  ];

  function randomOf(arr){ return arr[Math.floor(Math.random()*arr.length)]; }

  document.getElementById('giveBribe').addEventListener('click', ()=>{
    docFigure.classList.remove('bored');
    docFigure.classList.remove('jolt'); void docFigure.offsetWidth; docFigure.classList.add('jolt');
    jawPath.setAttribute('d','M9 10 q4 8 8 0');
    docSpeech.textContent = "Ultra-interested!";

    if(bribeCount < bribeGoods.length){
      const item = document.createElement('span');
      item.textContent = bribeGoods[bribeCount];
      denGoods.appendChild(item);
      bribeCount++;
    } else {
      // den is full — pulse an extra envelope to show it keeps growing
      const item = document.createElement('span');
      item.textContent = '✉️';
      denGoods.appendChild(item);
    }
    doctorStatus.textContent = randomOf(bribeLines) + (bribeCount >= bribeGoods.length ? " The den now resembles a fully stocked general store." : "");
  });

  document.getElementById('noBribe').addEventListener('click', ()=>{
    docFigure.classList.add('bored');
    docFigure.classList.remove('jolt');
    jawPath.setAttribute('d','M9 10 q4 1 8 0');
    docSpeech.textContent = "Next patient, please.";
    doctorStatus.textContent = randomOf(emptyLines);
  });

  // ---- The Bribe (Mitus) — light exposure widget ----
  const mitusStage = document.getElementById('mitusStage');
  const mitusStatus = document.getElementById('mitusStatus');
  if(mitusStage){
    document.getElementById('shadeBtn').addEventListener('click', ()=>{
      mitusStage.classList.remove('sunlit');
      mitusStatus.textContent = "Resting quietly in a dark corner of the Park. Fruit ripens undisturbed.";
    });
    document.getElementById('sunBtn').addEventListener('click', ()=>{
      mitusStage.classList.add('sunlit');
      mitusStatus.textContent = "By all accounts it should be wilting. Instead, it has recently taken to growing in broad daylight, seemingly unbothered.";
    });
  }

  // ---- Street Encounter simulator ----
  const copFigure = document.getElementById('copFigure');
  const copSpeech = document.getElementById('copSpeech');
  const encounterStatus = document.getElementById('encounterStatus');
  const encounterChips = document.getElementById('encounterChips');
  if(encounterChips){
    encounterChips.querySelectorAll('.chip').forEach(chip=>{
      chip.addEventListener('click', ()=>{
        encounterChips.querySelectorAll('.chip').forEach(c=>c.classList.remove('picked'));
        chip.classList.add('picked');
        const r = chip.dataset.r;
        copFigure.classList.remove('react-avoid','react-chase','react-fine');
        copFigure.classList.add('react-' + r);
        encounterStatus.textContent = chip.dataset.t;
        copSpeech.textContent = r === 'avoid' ? "Didn't see a thing." : r === 'chase' ? "Grim pursuit." : "Writing it up.";
      });
    });
  }

  // ---- Talk to the Cop simulator ----
  const copLines = [
    "Good evening, license and registration.",
    "Have you been drinking?",
    "Blow into this…",
    "Do you have any weapons?",
    "Open the trunk!",
    "Do you know what violation you committed?",
    "Do you want to pay or should I write a ticket?",
    "Is 20 dinars too much?",
    "Which way are you headed?",
    "Could I ride with you part of the way?"
  ];
  const talkLine = document.getElementById('talkLine');
  const talkCounter = document.getElementById('talkCounter');
  const talkBtn = document.getElementById('talkBtn');
  if(talkBtn){
    let talkIndex = 0;
    talkBtn.addEventListener('click', ()=>{
      talkLine.textContent = '"' + copLines[talkIndex] + '"';
      talkCounter.textContent = 'Line ' + (talkIndex+1) + ' / 10';
      talkIndex = (talkIndex + 1) % copLines.length;
      talkBtn.textContent = talkIndex === 0 ? "Start Over →" : "Next Line →";
    });
  }

  // ---- Cordon formation simulator ----
  const cordonStage = document.getElementById('cordonStage');
  const cordonSlider = document.getElementById('cordonSlider');
  const cordonStatus = document.getElementById('cordonStatus');
  const standBtn = document.getElementById('standBtn');
  const chargeBtn = document.getElementById('chargeBtn');
  const CORDON_THRESHOLD = 3;

  function copSVG(){
    return '<svg width="30" height="42" viewBox="0 0 26 34" fill="none">'
      + '<path d="M4 8 h18 v3 h-18 z" fill="#4a3a24"/>'
      + '<circle cx="13" cy="10" r="6" fill="#c99a6b"/>'
      + '<path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#6b5433"/>'
      + '</svg>';
  }

  function renderCordon(n){
    cordonStage.innerHTML = '';
    for(let i=0;i<n;i++){
      const d = document.createElement('div');
      d.className = 'cordon-unit';
      d.innerHTML = copSVG();
      cordonStage.appendChild(d);
    }
    const merged = n >= CORDON_THRESHOLD;
    standBtn.disabled = !merged;
    chargeBtn.disabled = !merged;
    cordonStage.classList.remove('charging');
    if(!merged){
      cordonStatus.textContent = n === 1
        ? "A single Brown Street Cop. Capable of independent thought, more or less."
        : (n) + " cops, still acting individually. Not yet enough to merge into a Cordon.";
    } else {
      cordonStatus.textContent = "CORDON FORMED (" + n + " officers). Independent reasoning: disabled. Awaiting Commander's order.";
    }
  }

  if(cordonStage){
    cordonSlider.addEventListener('input', e => renderCordon(Number(e.target.value)));
    standBtn.addEventListener('click', ()=>{
      cordonStage.classList.remove('charging');
      cordonStatus.textContent = "STANDING. The Cordon blocks the street entirely. Nothing reasoned about it — it simply stands.";
    });
    chargeBtn.addEventListener('click', ()=>{
      cordonStage.classList.remove('charging'); void cordonStage.offsetWidth; cordonStage.classList.add('charging');
      cordonStatus.textContent = "CHARGING. Batons out. Simple as beans — that's why it works.";
    });
    renderCordon(1);
  }

  // ---- Counter Encounter chat simulator ----
  const chatData = [
    ['citizen','Good da…'],
    ['clerk','SAY IT!'],
    ['citizen','Excuse me, I wanted to certify…'],
    ['clerk','Counter 4!'],
    ['citizen','Sorry?'],
    ['clerk','COUNTER 4, ARE YOU DEAF?'],
    ['citizen','But they just sent me from counter 4 to you, because first I need…'],
    ['clerk',"Don't you explain to me what's needed!"],
    ['citizen','I apologize…'],
    ['clerk','Wait!'],
    ['citizen','Sorry?'],
    ['clerk','Give that here!'],
    ['citizen','Here you go…'],
    ['clerk','…Well, yes! You don\'t have proof of paid tax!'],
    ['citizen','But…'],
    ['clerk','Take it! When you bring proof…'],
    ['citizen','But my wife read yesterday that it\'s not required…'],
    ['clerk','Then let your wife certify it!!!'],
    ['citizen',"Please don't be like that…"],
    ['clerk',"Listen, I don't have time to mess around with you!!"],
    ['citizen','But wait, you\'re here for me, not BREAK!!! How come break, you were just eating burek?'],
    ['clerk',"Now I'll drink yogurt!!! Do you have a problem with that?!?"],
    ['citizen',"Sorry, I'll wait…"]
  ];
  const chatStage = document.getElementById('chatStage');
  const chatBtn = document.getElementById('chatBtn');
  const chatReset = document.getElementById('chatReset');
  const chatCounter = document.getElementById('chatCounter');
  if(chatStage){
    let chatIdx = 0;
    function chatStep(){
      if(chatIdx === 0){ chatStage.innerHTML = ''; }
      if(chatIdx < chatData.length){
        const [who, text] = chatData[chatIdx];
        const b = document.createElement('div');
        b.className = 'bubble ' + who;
        b.textContent = text;
        chatStage.appendChild(b);
        chatStage.scrollTop = chatStage.scrollHeight;
        chatIdx++;
        chatCounter.textContent = 'Line ' + chatIdx + ' / ' + chatData.length;
        chatBtn.textContent = chatIdx >= chatData.length ? 'Encounter Complete' : 'Next Line →';
        if(chatIdx >= chatData.length) chatBtn.disabled = true;
      }
    }
    chatBtn.addEventListener('click', chatStep);
    chatReset.addEventListener('click', ()=>{
      chatIdx = 0;
      chatStage.innerHTML = '<div class="chat-placeholder" id="chatPlaceholder">Press "Approach the Counter" to begin.</div>';
      chatCounter.textContent = 'Line 0 / ' + chatData.length;
      chatBtn.textContent = 'Approach the Counter →';
      chatBtn.disabled = false;
    });
  }

  // ---- Coefficient of Wildness calculator ----
  const brkSlider = document.getElementById('brkSlider');
  const cliSlider = document.getElementById('cliSlider');
  const daySlider = document.getElementById('daySlider');
  const brkVal = document.getElementById('brkVal');
  const cliVal = document.getElementById('cliVal');
  const dayVal = document.getElementById('dayVal');
  const wildNumber = document.getElementById('wildNumber');
  const wildLabel = document.getElementById('wildLabel');
  const wildStatus = document.getElementById('wildStatus');

  function wildDescriptor(v){
    if(v < 1.5) return ['CALM (rare)', 'A once-in-a-fiscal-year event. Possibly a Tame Counter Clerk in disguise.'];
    if(v < 4) return ['IRRITABLE', 'Standard operating mood. Approach with paperwork already stamped.'];
    if(v < 8) return ['FERAL', 'The hole has narrowed. Sudden movements are not advised.'];
    return ['APEX PREDATOR', 'Do not approach. Return tomorrow, or better, never.'];
  }

  function updateWild(){
    const b = Number(brkSlider.value), c = Number(cliSlider.value), d = Number(daySlider.value);
    brkVal.textContent = b; cliVal.textContent = c; dayVal.textContent = d;
    const coeff = (b / c) * Math.max(d, 0.5);
    wildNumber.textContent = coeff.toFixed(1);
    const [label, note] = wildDescriptor(coeff);
    wildLabel.textContent = label;
    wildStatus.textContent = note;
  }
  if(brkSlider){
    [brkSlider, cliSlider, daySlider].forEach(s => s.addEventListener('input', updateWild));
    updateWild();
  }

  // ---- Endless checklist ----
  const checklist = document.getElementById('checklist');
  const reqCount = document.getElementById('reqCount');
  const coreDocs = [
    'Original contract of sale of the vehicle',
    'Certified photocopy of the contract',
    'Certified proof of certification of the photocopy',
    'Proof of contribution payment',
    'Proof of paid tax'
  ];
  const extraDocs = [
    "Certified proof of father's paid tax (for those born before 1965)",
    'Proof of establishing paternity, or original death certificate if deceased after 1997',
    'Special service turnover tax',
    'Special federal service turnover tax, in lump sum',
    'Proof of residence',
    'Citizenship certificate, not older than six months',
    'Birth certificate, not younger than two years',
    'Certificate of non-conviction',
    'Tax for company signage',
    'Certified confirmation of not having a company'
  ];
  const bonusDocs = [
    'Certified proof that you do not need further certification',
    'Notarized photocopy of this very checklist',
    'Confirmation that the confirmation was received',
    'Proof of proof of paid tax',
    'A second, unrelated original of the first original'
  ];
  if(checklist){
    let shown = 0, bonusIdx = 0;
    function addItem(text){
      const label = document.createElement('label');
      const cb = document.createElement('input');
      cb.type = 'checkbox';
      const span = document.createElement('span');
      span.textContent = text;
      label.appendChild(cb); label.appendChild(span);
      checklist.appendChild(label);
      cb.addEventListener('change', ()=>{
        label.classList.toggle('checked', cb.checked);
        if([...checklist.querySelectorAll('input[type=checkbox]')].every(x=>x.checked)){
          setTimeout(()=>{
            if(shown < coreDocs.length + extraDocs.length){
              addItem(extraDocs[shown - coreDocs.length]);
            } else {
              addItem(bonusDocs[bonusIdx % bonusDocs.length]);
              bonusIdx++;
            }
            shown++;
            reqCount.textContent = shown;
          }, 220);
        }
      });
      shown++;
      reqCount.textContent = shown;
    }
    coreDocs.forEach(addItem);
  }

  // ---- Bill inflation simulator ----
  const billBtn = document.getElementById('billBtn');
  const billFinal = document.getElementById('billFinal');
  const billStatus = document.getElementById('billStatus');
  if(billBtn){
    const trueTotal = 41300;
    billBtn.addEventListener('click', ()=>{
      billBtn.disabled = true;
      const factor = 3 + Math.random(); // 300%–400%
      const target = Math.round(trueTotal * factor / 100) * 100;
      let current = trueTotal;
      const step = Math.max(1, Math.round((target - trueTotal) / 30));
      const timer = setInterval(()=>{
        current += step;
        if(current >= target){ current = target; clearInterval(timer);
          billFinal.textContent = current.toLocaleString() + ' din';
          billFinal.classList.add('inflated');
          billStatus.textContent = 'Presented with a smile. Nobody at the table counted the flatbreads. (+' + Math.round((factor-1)*100) + '%)';
          billBtn.disabled = false;
          billBtn.textContent = 'Present the Bill Again';
          return;
        }
        billFinal.textContent = current.toLocaleString() + ' din';
      }, 25);
    });
  }

  // ---- Compose the Squeal (with live audio synthesis) ----
  const squealChips = document.getElementById('squealChips');
  const payoutNumber = document.getElementById('payoutNumber');
  const payoutLabel = document.getElementById('payoutLabel');
  const squealStatus = document.getElementById('squealStatus');
  const performBtn = document.getElementById('performBtn');
  const stopBtn = document.getElementById('stopBtn');

  if(squealChips){
    const active = new Set();
    const labels = {
      0:'SILENCE', 1:'FAINT INTEREST', 2:'SOME EUROS APPEAR', 3:'FANS ARE STUFFING BILLS',
      4:'MONEY RAINING DOWN', 5:'PERFECT NAKED SINGING'
    };

    // --- sound recipes: distorted, formant-filtered, noise-blended "human" voice patches ---
    const soundRecipes = {
      Yelling:    { type:'sawtooth', freq:190,  lfo1Rate:5,    lfo1Depth:18,  lfo2Rate:12.7, lfo2Depth:10,  formantFreq:900,  formantQ:3.2, distortion:55, gain:0.17, noiseMix:0.30, tremoloRate:3.3, tremoloDepth:0.6 },
      Wailing:    { type:'sawtooth', freq:320,  lfo1Rate:0.45, lfo1Depth:170, lfo2Rate:5.4,  lfo2Depth:18,  formantFreq:550,  formantQ:2.2, distortion:25, gain:0.15, noiseMix:0.10, tremoloRate:1.1, tremoloDepth:0.3 },
      Howling:    { type:'triangle', freq:210,  lfo1Rate:0.3,  lfo1Depth:130, lfo2Rate:3.1,  lfo2Depth:14,  formantFreq:420,  formantQ:2.0, distortion:30, gain:0.15, noiseMix:0.12, tremoloRate:2.1, tremoloDepth:0.4 },
      Screeching: { type:'sawtooth', freq:1150, lfo1Rate:10.5, lfo1Depth:140, lfo2Rate:17,   lfo2Depth:55,  formantFreq:2600, formantQ:6.0, distortion:70, gain:0.08, noiseMix:0.40, tremoloRate:6,   tremoloDepth:0.4 },
      Shrieking:  { type:'square',   freq:1650, lfo1Rate:19,   lfo1Depth:260, lfo2Rate:27,   lfo2Depth:70,  formantFreq:3400, formantQ:7.0, distortion:85, gain:0.06, noiseMix:0.45, tremoloRate:8,   tremoloDepth:0.5 }
    };

    let audioCtx = null;
    let masterGain = null;
    let noiseBuffer = null;
    let voices = {}; // name -> nodes
    let performing = false;

    function makeDistortionCurve(amount){
      const k = amount, n = 44100, curve = new Float32Array(n);
      for(let i=0;i<n;i++){
        const x = i*2/n - 1;
        curve[i] = (3+k) * x * 20 * (Math.PI/180) / (Math.PI + k*Math.abs(x));
      }
      return curve;
    }

    function ensureAudio(){
      if(!audioCtx){
        audioCtx = new (window.AudioContext || window.webkitAudioContext)();
        masterGain = audioCtx.createGain();
        masterGain.gain.value = 0.55;
        const comp = audioCtx.createDynamicsCompressor();
        masterGain.connect(comp);
        comp.connect(audioCtx.destination);

        // shared noise buffer for breath/rasp texture
        const len = audioCtx.sampleRate * 2;
        noiseBuffer = audioCtx.createBuffer(1, len, audioCtx.sampleRate);
        const data = noiseBuffer.getChannelData(0);
        for(let i=0;i<len;i++) data[i] = Math.random()*2 - 1;
      }
      if(audioCtx.state === 'suspended') audioCtx.resume();
    }

    function startVoice(name){
      if(voices[name] || !performing) return;
      const r = soundRecipes[name];
      const t0 = audioCtx.currentTime;

      // main tone source
      const osc = audioCtx.createOscillator();
      osc.type = r.type;
      osc.frequency.value = r.freq;

      // two independent LFOs summed into pitch — avoids a clean, single-rate "UFO" vibrato
      const lfo1 = audioCtx.createOscillator();
      lfo1.frequency.value = r.lfo1Rate;
      const lfo1Gain = audioCtx.createGain();
      lfo1Gain.gain.value = r.lfo1Depth;
      lfo1.connect(lfo1Gain); lfo1Gain.connect(osc.frequency);

      const lfo2 = audioCtx.createOscillator();
      lfo2.frequency.value = r.lfo2Rate;
      const lfo2Gain = audioCtx.createGain();
      lfo2Gain.gain.value = r.lfo2Depth;
      lfo2.connect(lfo2Gain); lfo2Gain.connect(osc.frequency);

      // vocal-tract-ish formant filter
      const formant = audioCtx.createBiquadFilter();
      formant.type = 'bandpass';
      formant.frequency.value = r.formantFreq;
      formant.Q.value = r.formantQ;

      // distortion for grit/rasp instead of a pure tone
      const shaper = audioCtx.createWaveShaper();
      shaper.curve = makeDistortionCurve(r.distortion);
      shaper.oversample = '4x';

      const toneGain = audioCtx.createGain();
      toneGain.gain.value = 0;

      osc.connect(formant); formant.connect(shaper); shaper.connect(toneGain);
      toneGain.connect(masterGain);

      // breath/rasp noise layer, filtered into the same formant range
      let noiseSrc = null, noiseFilter = null, noiseGain = null;
      if(r.noiseMix > 0){
        noiseSrc = audioCtx.createBufferSource();
        noiseSrc.buffer = noiseBuffer;
        noiseSrc.loop = true;
        noiseFilter = audioCtx.createBiquadFilter();
        noiseFilter.type = 'bandpass';
        noiseFilter.frequency.value = r.formantFreq;
        noiseFilter.Q.value = r.formantQ * 0.6;
        noiseGain = audioCtx.createGain();
        noiseGain.gain.value = 0;
        noiseSrc.connect(noiseFilter); noiseFilter.connect(noiseGain); noiseGain.connect(masterGain);
        noiseSrc.start();
      }

      // tremolo — irregular amplitude pulsing, more shout-like than a steady tone
      let tremOsc = null;
      if(r.tremoloRate){
        tremOsc = audioCtx.createOscillator();
        tremOsc.type = 'sine';
        tremOsc.frequency.value = r.tremoloRate;
        const tremGain = audioCtx.createGain();
        tremGain.gain.value = r.gain * r.tremoloDepth;
        tremOsc.connect(tremGain);
        tremGain.connect(toneGain.gain);
        if(noiseGain){
          const tremGain2 = audioCtx.createGain();
          tremGain2.gain.value = r.gain * r.noiseMix * r.tremoloDepth;
          tremOsc.connect(tremGain2);
          tremGain2.connect(noiseGain.gain);
        }
        tremOsc.start();
      }

      osc.start(); lfo1.start(); lfo2.start();
      toneGain.gain.linearRampToValueAtTime(r.gain, t0 + 0.2);
      if(noiseGain) noiseGain.gain.linearRampToValueAtTime(r.gain * r.noiseMix, t0 + 0.2);

      voices[name] = { osc, lfo1, lfo2, tremOsc, toneGain, noiseSrc, noiseGain };
    }

    function stopVoice(name){
      const v = voices[name];
      if(!v) return;
      const t = audioCtx.currentTime;
      [v.toneGain, v.noiseGain].forEach(g=>{
        if(!g) return;
        g.gain.cancelScheduledValues(t);
        g.gain.setValueAtTime(g.gain.value, t);
        g.gain.linearRampToValueAtTime(0, t + 0.18);
      });
      [v.osc, v.lfo1, v.lfo2, v.tremOsc, v.noiseSrc].forEach(n=>{ if(n) n.stop(t + 0.22); });
      delete voices[name];
    }

    function stopAllVoices(){
      Object.keys(voices).forEach(stopVoice);
    }

    function refreshUI(){
      const n = active.size;
      payoutNumber.textContent = (n*n*137).toLocaleString() + ' din';
      payoutLabel.textContent = labels[n];
      squealStatus.textContent = n === 0
        ? 'Select at least one sound to begin the performance.'
        : (performing ? 'Now performing: ' : 'Composed (press Start to hear it): ') + [...active].join(', ') + '. ' + (n>=5 ? 'The ideal has been achieved. It is not clear where one sound ends and the next begins — as intended.' : '');
    }

    squealChips.querySelectorAll('.chip').forEach(chip=>{
      chip.addEventListener('click', ()=>{
        const s = chip.dataset.s;
        if(active.has(s)){
          active.delete(s); chip.classList.remove('picked');
          if(performing) stopVoice(s);
        } else {
          active.add(s); chip.classList.add('picked');
          if(performing) startVoice(s);
        }
        refreshUI();
      });
    });

    performBtn.addEventListener('click', ()=>{
      ensureAudio();
      performing = true;
      active.forEach(startVoice);
      performBtn.disabled = true;
      stopBtn.disabled = false;
      refreshUI();
    });

    stopBtn.addEventListener('click', ()=>{
      performing = false;
      stopAllVoices();
      performBtn.disabled = false;
      stopBtn.disabled = true;
      refreshUI();
    });
  }

  // ---- Project/Material quote generator ----
  const quoteBtn = document.getElementById('quoteBtn');
  const quoteLine = document.getElementById('quoteLine');
  if(quoteBtn){
    const openers = [
      "I'm so excited to finally share this new project with you all,",
      "This has been such important material for me,",
      "Working with my esteemed colleagues on this project,",
      "I always gladly come to your town, village, tavern, or show, and",
      "From the heart, I love you all very, very much, and",
      "It took years to collect this material, and"
    ];
    const closers = [
      "this material for the new project means everything to me.",
      "I can finally announce the material project you've all been waiting for.",
      "the project of new material is dedicated to my audience.",
      "thank you, truly, this whole project came from real material.",
      "the material behind this project speaks for itself."
    ];
    quoteBtn.addEventListener('click', ()=>{
      const o = openers[Math.floor(Math.random()*openers.length)];
      const c = closers[Math.floor(Math.random()*closers.length)];
      quoteLine.textContent = '"' + o + ' ' + c + '"';
    });
  }

  // ---- Park Noise Level toggle ----
  const weekdayBtn = document.getElementById('weekdayBtn');
  const weekendBtn = document.getElementById('weekendBtn');
  const noiseMeter = document.getElementById('noiseMeter');
  const noiseStatus = document.getElementById('noiseStatus');
  if(weekdayBtn){
    weekdayBtn.addEventListener('click', ()=>{
      noiseMeter.style.width = '85%';
      noiseStatus.textContent = 'Weekday: the Park hums with squealing as usual.';
    });
    weekendBtn.addEventListener('click', ()=>{
      noiseMeter.style.width = '4%';
      noiseStatus.textContent = 'Weekend: unnaturally quiet. Every Naked Singer capable of producing a sound has already left, in the same plane, for richer lands.';
    });
  }

  // ---- Dress the Naked Singer ----
  const dressChips = document.getElementById('dressChips');
  const dressNumber = document.getElementById('dressNumber');
  const dressLabel = document.getElementById('dressLabel');
  const dressStatus = document.getElementById('dressStatus');
  if(dressChips){
    const total = dressChips.querySelectorAll('.chip').length;
    const equipped = new Set();
    const stageLabel = (n)=>{
      if(n===0) return 'NATURAL (RARE SIGHTING)';
      if(n < total*0.3) return 'LIGHTLY RETOUCHED';
      if(n < total*0.6) return 'STAGE-READY';
      if(n < total) return 'MOSTLY MANUFACTURED';
      return 'FULLY MANUFACTURED — READY FOR THE STAGE';
    };

    // simple key -> svg element id, shown (opacity 1) once equipped
    const showOnEquip = {
      pills: 'pillIcon', hormones: 'syringeIcon', wig: 'wig',
      lashes: 'lashes', voice: 'mic', wax: 'shine'
    };
    const el = id => document.getElementById(id);

    function updateMouth(){
      const dressed = equipped.has('teeth') || equipped.has('lips');
      el('mouthEquipped').style.opacity = dressed ? '1' : '0';
      el('mouthDefault').style.opacity = dressed ? '0' : '1';
    }
    function updatePads(){
      el('chestPad').style.opacity = equipped.has('chest') ? '0.95' : '0';
      el('rearPad').style.opacity = equipped.has('rear') ? '0.95' : '0';
    }
    function updateHatch(){
      const smooth = equipped.has('trim');
      el('armHatch').style.opacity = smooth ? '0' : '1';
      el('legHatch').style.opacity = smooth ? '0' : '1';
    }
    function updateGlow(){
      el('fameGlow').style.opacity = String(Math.min(equipped.size / total, 1) * 0.4);
    }

    dressChips.querySelectorAll('.chip').forEach(chip=>{
      chip.addEventListener('click', ()=>{
        const key = chip.dataset.key;
        const isOn = !equipped.has(key);
        if(isOn) equipped.add(key); else equipped.delete(key);
        chip.classList.toggle('picked', isOn);

        if(showOnEquip[key]) el(showOnEquip[key]).style.opacity = isOn ? '1' : '0';
        if(key === 'teeth' || key === 'lips') updateMouth();
        if(key === 'chest' || key === 'rear') updatePads();
        if(key === 'trim') updateHatch();
        updateGlow();

        dressNumber.textContent = equipped.size + '/' + total;
        dressLabel.textContent = stageLabel(equipped.size);
        dressStatus.textContent = isOn ? chip.dataset.t : 'Item removed. Nature briefly reasserts itself.';
      });
    });
  }

  // ---- Batinaši: Loyalty Compass ----
  const needle = document.getElementById('needle');
  const compassStatus = document.getElementById('compassStatus');
  if(needle){
    function setNeedle(angle, text){
      needle.style.transform = 'rotate(' + angle + 'deg)';
      compassStatus.textContent = text;
    }
    document.getElementById('tycoonBtn').addEventListener('click', ()=>{
      setNeedle(58, 'Envelope delivered to the Tycoon. Loyalty confirmed, effective immediately, until the next envelope.');
    });
    document.getElementById('patronBtn').addEventListener('click', ()=>{
      setNeedle(-58, 'Envelope delivered to the Political Patron. Loyalty confirmed, effective immediately, until the next envelope.');
    });
    document.getElementById('noEnvBtn').addEventListener('click', ()=>{
      setNeedle(0, 'No Envelope delivered. No loyalty exists yet. The needle has no reason to move.');
    });
  }

  // ---- Batinaši: The Invisibility Ritual ----
  const witnessStage = document.getElementById('witnessStage');
  const witnessBtn = document.getElementById('witnessBtn');
  const reportBtn = document.getElementById('reportBtn');
  const witnessStatus = document.getElementById('witnessStatus');
  if(witnessBtn){
    let count = 0;
    witnessBtn.addEventListener('click', ()=>{
      if(count >= 50) return;
      count++;
      const s = document.createElement('span');
      s.textContent = '👁️';
      witnessStage.appendChild(s);
      witnessStatus.textContent = 'Witnesses present: ' + count + (count >= 50 ? ' (capacity reached — a crowd, by any definition)' : '');
    });
    reportBtn.addEventListener('click', ()=>{
      const seen = count;
      count = 0;
      witnessStage.innerHTML = '';
      witnessStatus.textContent = seen > 0
        ? 'OFFICIAL REPORT FILED: "No incident occurred." (' + seen + ' witnesses present; 0 witnesses recorded.)'
        : 'OFFICIAL REPORT FILED: "No incident occurred." (Nothing to file, technically true.)';
    });
  }

  // ---- Batinaši: Habitat Selector ----
  const habitatBtns = document.querySelectorAll('.habitat-btn');
  const habitatStatus = document.getElementById('habitatStatus');
  const habitatText = {
    polling: 'Polling Station: a loose cluster forms near the entrance. Citizens are "surveyed" on their satisfaction with queuing. Few complete the survey; fewer still complete the vote.',
    pandur: 'Behind Pandur Lines: a silent understanding passes between cousins. The Pandur looks at the sky, the horizon, his shoes — anywhere but forward. The Batinaši swing freely.',
    construction: 'Construction Site: protesting Citizens are offered complimentary dental adjustments. No paperwork is generated. No dentist is present.'
  };
  if(habitatBtns.length){
    habitatBtns.forEach(btn=>{
      btn.addEventListener('click', ()=>{
        habitatBtns.forEach(b=>b.classList.remove('active'));
        btn.classList.add('active');
        habitatStatus.textContent = habitatText[btn.dataset.h];
      });
    });
  }

  // ---- Batinaši: Pack Hunting ----
  const packStage = document.getElementById('packStage');
  const packBtn = document.getElementById('packBtn');
  const disperseBtn = document.getElementById('disperseBtn');
  const packStatus = document.getElementById('packStatus');
  if(packBtn){
    const MAX_PACK = 12;
    let packSize = 0;
    function hoodSVG(){
      return '<svg width="26" height="34" viewBox="0 0 26 34" fill="none">'
        + '<path d="M6 20 Q13 4 20 20 L20 14 Q13 2 6 14 Z" fill="#161616"/>'
        + '<ellipse cx="13" cy="15" rx="7" ry="8" fill="#1c1c1c"/>'
        + '<rect x="9" y="18" width="8" height="4" rx="2" fill="#3a3a3a"/>'
        + '<path d="M4 33c0-9 4-15 9-15s9 6 9 15" fill="#2a2a2a"/>'
        + '</svg>';
    }
    function packLine(n){
      if(n === 0) return 'No signal given. The street looks empty.';
      if(n < 3) return n + ' figure' + (n>1?'s':'') + ' gathering. Not yet a pack — still just loitering, technically.';
      if(n < 7) return 'Pack forming (' + n + '). Numbers are starting to matter more than any individual.';
      if(n < MAX_PACK) return 'Full pack (' + n + '). Sheer numbers now do the negotiating.';
      return 'Maximum pack size reached (' + n + '). Overwhelming, by design.';
    }
    packBtn.addEventListener('click', ()=>{
      if(packSize >= MAX_PACK) return;
      packSize++;
      const d = document.createElement('div');
      d.className = 'pack-unit';
      d.innerHTML = hoodSVG();
      packStage.appendChild(d);
      packStatus.textContent = packLine(packSize);
    });
    disperseBtn.addEventListener('click', ()=>{
      packSize = 0;
      packStage.innerHTML = '';
      packStatus.textContent = 'Camouflage engaged — blended back into the crowd, the tavern, the alley. No pack was ever here.';
    });
  }

  // ---- Compose the Squeal: inline reference video ----
  const squealPlayBtn = document.getElementById('squealPlayBtn');
  const squealVideoFrame = document.getElementById('squealVideoFrame');
  if(squealPlayBtn){
    squealPlayBtn.addEventListener('click', ()=>{
      squealVideoFrame.innerHTML =
        '<iframe src="https://www.youtube.com/embed/YrKlShcQqqw?autoplay=1" '
        + 'title="Reference footage" frameborder="0" '
        + 'allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" '
        + 'allowfullscreen></iframe>';
    });
  }

  // ---- Don't Panic teaser ----
  const dontPanicBtn = document.getElementById('dontPanicBtn');
  const dontPanicMsg = document.getElementById('dontPanicMsg');
  if(dontPanicBtn){
    dontPanicBtn.addEventListener('click', ()=>{
      dontPanicMsg.textContent = "50 Shades of Shadows is dropping soon for the entire female species. If your life wasn't already beautifully complicated.";
      dontPanicMsg.classList.add('show');
    });
  }

  // ---- Collectivus stinko: Odor Assessment ----
  const odorChips = document.getElementById('odorChips');
  const odorNumber = document.getElementById('odorNumber');
  const odorLabel = document.getElementById('odorLabel');
  const odorStatus = document.getElementById('odorStatus');
  if(odorChips){
    const total = odorChips.querySelectorAll('.chip').length;
    const active = new Set();
    const odorTier = (n)=>{
      if(n===0) return 'NO SAMPLES TAKEN';
      if(n < total*0.3) return 'FAINTLY OFFICIAL';
      if(n < total*0.6) return 'NOTICEABLY RANCID';
      if(n < total) return 'HAZARDOUS TO STUDY';
      return 'STUDY ABANDONED — EVACUATE';
    };
    odorChips.querySelectorAll('.chip').forEach(chip=>{
      chip.addEventListener('click', ()=>{
        const key = chip.textContent;
        if(active.has(key)){ active.delete(key); chip.classList.remove('picked'); }
        else { active.add(key); chip.classList.add('picked'); }
        const pct = Math.round((active.size/total)*100);
        odorNumber.textContent = pct + '%';
        odorLabel.textContent = odorTier(active.size);
        odorStatus.textContent = active.size === 0
          ? 'Select at least one subject to begin the study.'
          : (active.has(key) ? chip.dataset.t : 'Subject withdrawn from study. The air clears, slightly.');
      });
    });
  }

  // ---- Collectivus stinko: Approach Distance ----
  const stinkSlider = document.getElementById('stinkSlider');
  const stinkCloud = document.getElementById('stinkCloud');
  const stinkPerson = document.getElementById('stinkPerson');
  const stinkStatus = document.getElementById('stinkStatus');
  if(stinkSlider){
    function stinkLine(v){
      if(v < 15) return 'Holding at a respectful, hygienic distance.';
      if(v < 40) return 'A faint bureaucratic musk is detectable. Notebooks out.';
      if(v < 65) return 'Getting closer. The smell of forms and firelighters is now unmistakable.';
      if(v < 90) return 'Too close. Eyes watering. Field notes becoming illegible.';
      return 'STUDY ABORTED. No washing can remove this. Please step back.';
    }
    function updateStink(v){
      stinkCloud.style.opacity = String(0.25 + v/130);
      stinkCloud.style.transform = 'scale(' + (1 + v/70) + ')';
      stinkPerson.style.filter = v > 60 ? 'saturate(.4) brightness(.85)' : 'none';
      stinkStatus.textContent = stinkLine(v);
    }
    stinkSlider.addEventListener('input', e => updateStink(Number(e.target.value)));
    updateStink(Number(stinkSlider.value));
  }

  // ---- Educational Wretch: Wretchedness Factor (Wf) simulator ----
  const wfSlider = document.getElementById('wfSlider');
  const wfDaysVal = document.getElementById('wfDaysVal');
  const wfNumber = document.getElementById('wfNumber');
  const wfLabel = document.getElementById('wfLabel');
  const wfStatus = document.getElementById('wfStatus');
  const wfChips = document.getElementById('wfChips');
  if(wfSlider && wfChips){
    const techNames = {
      indifference: 'Stubborn Indifference',
      sidehustle: 'Afternoon Side-Hustle',
      wallet: "Parents' Wallet Exploitation",
      fieldtrip: 'Field Trip Exploitation',
      love: 'Hopelessly-in-Love'
    };
    function activeTechs(){
      return Array.from(wfChips.querySelectorAll('.chip.picked')).map(c => c.dataset.tech);
    }
    function wfLabelFor(v){
      if(v < 2) return 'MANAGEABLE';
      if(v < 6) return 'STRAINED';
      if(v < 14) return 'WRETCHED';
      if(v < 28) return 'CRITICALLY WRETCHED';
      return 'OFF THE SCALE';
    }
    function updateWf(){
      const days = Number(wfSlider.value);
      wfDaysVal.textContent = String(days);
      const active = activeTechs();
      const baseWf = (days * days) / 55;
      const buffer = active.length * 0.6;
      const shownWf = Math.max(0, baseWf - buffer);
      const displayStr = days >= 45 ? '∞' : shownWf.toFixed(1);
      wfNumber.textContent = displayStr;
      wfLabel.textContent = days >= 45 ? 'UNDEFINED' : wfLabelFor(shownWf);

      let msg;
      if(days === 0){
        msg = 'Paycheck currently on time. Enjoy it — it won\'t last.';
      } else if(days >= 45){
        msg = 'The paycheck has become theoretical. Wretchedness can no longer be measured, only witnessed.';
      } else {
        msg = 'Paycheck is ' + days + ' day' + (days===1?'':'s') + ' late.';
        if(active.length){
          const names = active.map(t => techNames[t]);
          msg += ' Deploying: ' + names.join(', ') + '.';
          msg += active.length >= 4
            ? ' Nearly the full survival kit — the Wretch is coping, technically.'
            : ' Wretchedness holds, for now, at survivable levels.';
        } else {
          msg += ' No survival techniques deployed. Wretchedness is climbing unopposed.';
        }
      }
      wfStatus.textContent = msg;
    }
    wfSlider.addEventListener('input', updateWf);
    wfChips.querySelectorAll('.chip').forEach(chip => {
      chip.addEventListener('click', () => {
        chip.classList.toggle('picked');
        chip.style.background = chip.classList.contains('picked') ? 'var(--amber-bright)' : '';
        chip.style.color = chip.classList.contains('picked') ? '#1c1400' : '';
        updateWf();
      });
    });
    updateWf();
  }
</script>

</body>
</html>

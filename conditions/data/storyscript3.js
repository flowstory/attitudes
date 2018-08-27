//TODO: remove 3 from storyScript3 for Qualtrics
var qSwitch = (window.location.hostname === "cityunilondon.eu.qualtrics.com");
var storyScript3 = {
  "cecile": {
    displayName: "Cecile",
    selectIcon: {
      w: 60,
      h: 60
    },
    focusMask: {
      rx: 150,
      ry: 100,
      tx: 245,
      ty: 290,
      r: 80
    },
    storyText: {
      top: 250,
      left: 380
    },
    path: [[272, 367],[242, 340],[235, 285],[240, 240]],
    marker: {
      "start-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_e9gFvWUoNT81H4F" : "data/icons/stories/cecile/graduation_cecile.svg",
        height: 50,
        width: 30,
        posIdx: 0,
      },
      "offer-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_etbeGqycH7TOcUB" : "data/icons/stories/cecile/offer_cecile.svg",
        height: 40,
        width: 50,
        posIdx: 3,
      },
      "move-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_0uriO0PD7t0Vu9D" : "data/icons/stories/cecile/move_cecile.svg",
        height: 50,
        width: 30,
        posIdx: 0,
      },
      "work-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_9HTHZrKQkg1fpYx" : "data/icons/stories/cecile/work_cecile.svg",
        height: 50,
        width: 60,
        posIdx: 3,
      },
    },
    events: [
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 1, delay: 0, duration: 200}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,40%,70%)", delay: 0, duration: 200}
      },
      {
        func: "createJourneyPath",
        args: {}
      },
      {
        func: "createMarker",
        args: {id: "start-icon"}
      },
      {
        func: "createMarker",
        args: {id: "offer-icon"}
      },
      {
        func: "createMarker",
        args: {id: "move-icon"}
      },
      {
        func: "createMarker",
        args: {id: "work-icon"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-cecile", opacity: 1, delay: 300, duration: 2000}
      },
      {
        func: "updateStoryTextFadeIn",
        args: {delay: 350, duration: 1000, storyText: "<b>Cecile</b>: &laquo;Back in 2003, I graduated with a Master's of Art History from Sorbonne University. I soon started to work for a small auction house in Paris.&raquo;"}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 12000, duration: 1000, storyText: "<b>Cecile</b>: &laquo;But since I can remember, I was dreaming of working for Christie’s Auction House in London. So I applied ...&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#offer-icon-cecile", opacity: 1, delay: 15000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 20000, duration: 1000, storyText: "<b>Cecile</b>: &laquo;... and my dream came true - I received a job offer. I moved to London in the fall of 2003.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-cecile", opacity: 0, delay: 22000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-icon-cecile", opacity: 1, delay: 22000, duration: 2000}
      },
      {
        func: "moveMarkerAlongPath",
        args: {marker: "move-icon", pathSelector: "#journey-path-cecile", delay: 27000, duration: 6000}
      },
      {
        func: "animateJourneyPath",
        args: {delay: 27500, duration: 5500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#offer-icon-cecile", opacity: 0, delay: 28000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-icon-cecile", opacity: 0, delay: 34000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#work-icon-cecile", opacity: 1, delay: 34000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 34000, duration: 1000, storyText: "<b>Cecile</b>: &laquo;Since then I examined thousands of beautiful art pieces from all over the world. I love London, and I am happy that I moved here.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyText", opacity: 0, delay: 44000, duration: 1000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 0, delay: 44000, duration: 1000}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,90%,25%)", delay: 45000, duration: 1000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#work-icon-cecile", opacity: 0, delay: 46000, duration: 4000}
      },
    ],
  },
  "klaus": {
    displayName: "Klaus &amp; Susanne",
    selectIcon: {
      w: 85,
      h: 60
    },
    focusMask : {
      rx: 150,
      ry: 100,
      tx: 300,
      ty: 250,
      r: 25
    },
    storyText: {
      top: 400,
      left: 120
    },
    path: [[367, 301],[322, 276],[276, 252],[240, 240]],
    pathReverse: [[245, 240],[276, 252],[322, 276],[367, 301]],
    marker: {
      "start-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_80ShFVwAnyfcBVP" : "data/icons/stories/klaus/start_klaus.svg",
        height: 50,
        width: 40,
        posIdx: 0,
      },
      "offer-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_7WiqWmY4U2gmzNH" : "data/icons/stories/klaus/offer_klaus.svg",
        height: 40,
        width: 60,
        posIdx: 3,
      },
      "joining-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_bmzYHEGhpUc0dsF" : "data/icons/stories/klaus/joining_klaus.svg",
        height: 50,
        width: 50,
        posIdx: 0,
      },
      "move-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_1Hx8Wo2Qu7GtjZX" : "data/icons/stories/klaus/move_klaus.svg",
        height: 50,
        width: 60,
        posIdx: 0,
      },
      "work-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_bQ5TLtm2JOlClpz" : "data/icons/stories/klaus/work_klaus.svg",
        height: 50,
        width: 60,
        posIdx: 3,
        dx: -25,
      },
      "school-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_6QNy9MIVo19vPwx" : "data/icons/stories/klaus/school_susanne.svg",
        height: 40,
        width: 40,
        posIdx: 3,
        dx: 25,
      },
      "move-back-susi-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_5zFUzLGDGYeCgWF" : "data/icons/stories/klaus/move_back_susanne.svg",
        height: 35,
        width: 20,
        posIdx: 3,
        dx: 5
      },
      "move-back-klaus-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_0oJn4C9W93Wq6sl" : "data/icons/stories/klaus/move_back_klaus.svg",
        height: 50,
        width: 50,
        posIdx: 3,
        dx: 5
      },
    },
    events: [
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 1, delay: 0, duration: 200}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,40%,70%)", delay: 0, duration: 200}
      },
      {
        func: "createJourneyPath",
        args: {}
      },
      {
        func: "createJourneyPathReverse",
        args: {}
      },
      {
        func: "createMarker",
        args: {id: "start-icon"}
      },
      {
        func: "createMarker",
        args: {id: "offer-icon"}
      },
      {
        func: "createMarker",
        args: {id: "joining-icon"}
      },
      {
        func: "createMarker",
        args: {id: "move-icon"}
      },
      {
        func: "createMarker",
        args: {id: "work-icon"}
      },
      {
        func: "createMarker",
        args: {id: "school-icon"}
      },
      {
        func: "createMarker",
        args: {id: "move-back-susi-icon"}
      },
      {
        func: "createMarker",
        args: {id: "move-back-klaus-icon"}
      },
      {
        func: "updateStoryTextFadeIn",
        args: {delay: 350, duration: 1000, storyText: "<b>Klaus</b>: &laquo;I am working for a large German car company, in a Senior Management position. In 2005 the company offered me to build up our UK branch.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-klaus", opacity: 1, delay: 300, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#offer-icon-klaus", opacity: 1, delay: 5000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-klaus", opacity: 0, delay: 10000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#joining-icon-klaus", opacity: 1, delay: 10000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 10000, duration: 1000, storyText: "<b>Susanne</b>: &laquo;As soon as I heard dad would go to London, I wanted to join him ...&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#joining-icon-klaus", opacity: 0, delay: 18000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-icon-klaus", opacity: 1, delay: 18000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#offer-icon-klaus", opacity: 0, delay: 18000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 18000, duration: 1000, storyText: "<b>Klaus</b>: &laquo;So my daughter and I moved to London, it was an exciting time.&raquo;"}
      },
      {
        func: "moveMarkerAlongPath",
        args: {marker: "move-icon", pathSelector: "#journey-path-klaus", delay: 20000, duration: 6000}
      },
      {
        func: "animateJourneyPath",
        args: {delay: 21000, duration: 5000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-icon-klaus", opacity: 0, delay: 26000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#work-icon-klaus", opacity: 1, delay: 26000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#school-icon-klaus", opacity: 1, delay: 26000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 25000, duration: 1000, storyText: "<b>Susanne</b>: &laquo;While dad was working crazy hours, I attended School for one year improving my English.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#school-icon-klaus", opacity: 0, delay: 32000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-back-susi-icon-klaus", opacity: 1, delay: 32000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 32000, duration: 1000, storyText: "<b>Susanne</b>: &laquo;After this lifechanging year I returned to Germany – finishing Abitur, which is similar to A-levels.&raquo;"}
      },
      {
        func: "moveMarkerAlongPath",
        args: {marker: "move-back-susi-icon", pathSelector: "#journey-path-reverse-klaus", delay: 34000, duration: 6000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-back-susi-icon-klaus", opacity: 0, delay: 40000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 40000, duration: 1000, storyText: "<b>Klaus</b>: &laquo;After Susi went back, I stayed for two more years. Once the UK branch was up and running, I returned home in 2009.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#work-icon-klaus", opacity: 0, delay: 43000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-back-klaus-icon-klaus", opacity: 1, delay: 43000, duration: 2000}
      },
      {
        func: "moveMarkerAlongPath",
        args: {marker: "move-back-klaus-icon", pathSelector: "#journey-path-reverse-klaus", delay: 45000, duration: 6000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyText", opacity: 0, delay: 50000, duration: 1000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 0, delay: 50000, duration: 1000}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,90%,25%)", delay: 51000, duration: 1000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-back-klaus-icon-klaus", opacity: 0, delay: 52000, duration: 4000}
      },
    ],
  },
  "jakub": {
    displayName: "Jakub",
    selectIcon: {
      w: 60,
      h: 60
    },
    focusMask: {
      rx: 180,
      ry: 100,
      tx: 360,
      ty: 240,
      r: 10
    },
    storyText: {
      top: 370,
      left: 180
    },
    path: [[470, 260],[374, 209],[263, 192],[230, 220]],
    marker: {
      "start-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_6rIPE1YYY2YswmN" : "data/icons/stories/jakub/start_jakub.svg",
        height: 40,
        width: 30,
        posIdx: 0,
      },
      "move-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_38cSkPq55VtY549" : "data/icons/stories/jakub/move_jakub.svg",
        height: 50,
        width: 30,
        posIdx: 0,
      },
      "looking-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_1zTnJQ3rTFbfyUR" : "data/icons/stories/jakub/looking_jakub.svg",
        height: 50,
        width: 50,
        posIdx: 3,
      },
      "end-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_doIKB1S5nPbmKFv" : "data/icons/stories/jakub/end_jakub.svg",
        height: 50,
        width: 50,
        posIdx: 3,
      },
    },
    events: [
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 1, delay: 0, duration: 200}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,40%,70%)", delay: 0, duration: 200}
      },
      {
        func: "createJourneyPath",
        args: {}
      },
      {
        func: "createMarker",
        args: {id: "start-icon"}
      },
      {
        func: "createMarker",
        args: {id: "move-icon"}
      },
      {
        func: "createMarker",
        args: {id: "looking-icon"}
      },
      {
        func: "createMarker",
        args: {id: "end-icon"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-jakub", opacity: 1, delay: 300, duration: 2000}
      },
      {
        func: "updateStoryTextFadeIn",
        args: {delay: 350, duration: 1000, storyText: "<b>Jakub</b>: &laquo;In 2006, I finished an apprenticeship as a carpenter in my hometown of Krakow, but jobs are rare and not well paid in Poland.&raquo;"}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 8000, duration: 1000, storyText: "<b>Jakub</b>: &laquo;I knew of a few people in my community who went to London and make a decent living. In 2007, I decided to go and try my luck.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-jakub", opacity: 0, delay: 14000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-icon-jakub", opacity: 1, delay: 14000, duration: 2000}
      },
      {
        func: "moveMarkerAlongPath",
        args: {marker: "move-icon", pathSelector: "#journey-path-jakub", delay: 17000, duration: 10000}
      },
      {
        func: "animateJourneyPath",
        args: {delay: 17500, duration: 9000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 25000, duration: 1000, storyText: "<b>Jakub</b>: &laquo;I was looking for a job as a carpenter, but I had to start as a labourer on a large construction site.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-icon-jakub", opacity: 0, delay: 27000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#looking-icon-jakub", opacity: 1, delay: 27000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 33000, duration: 1000, storyText: "<b>Jakub</b>: &laquo;Two years later I found a job as a carpenter with a smaller contractor company. Today I can make a decent living, and I want to apply for the UK citizenship.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#looking-icon-jakub", opacity: 0, delay: 33000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#end-icon-jakub", opacity: 1, delay: 33000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyText", opacity: 0, delay: 42000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 0, delay: 42000, duration: 1000}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,90%,25%)", delay: 43000, duration: 1000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#end-icon-jakub", opacity: 0, delay: 44000, duration: 4000}
      },
    ]
  },
  "alejandro": {
    displayName: "Alejandro",
    selectIcon: {
      w: 60,
      h: 60
    },
    focusMask: {
      rx: 200,
      ry: 100,
      tx: 180,
      ty: 345,
      r: 110
    },
    storyText: {
      top: 320,
      left: 310
    },
    path: [[147, 461],[113, 362],[169, 274],[240, 240]],
    marker: {
      "start-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_b2YOtOF0xae1QZT" : "data/icons/stories/alejandro/start_alejandro.svg",
        height: 60,
        width: 40,
        posIdx: 0,
      },
      "goal-esp-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_3sH880KNqDOPNGd" : "data/icons/stories/alejandro/goal_esp_alejandro.svg",
        height: 40,
        width: 50,
        posIdx: 0,
      },
      "goal-uk-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_5hjoOb2l7DriUSN" : "data/icons/stories/alejandro/goal_uk_alejandro.svg",
        height: 40,
        width: 50,
        posIdx: 3,
      },
      "move-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_cTIl0xlxN5fHyqp" : "data/icons/stories/alejandro/move_alejandro.svg",
        height: 50,
        width: 30,
        posIdx: 0,
      },
      "end-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_cBWSWZK4rWz3rUh" : "data/icons/stories/alejandro/end_alejandro.svg",
        height: 50,
        width: 60,
        posIdx: 3,
      },
    },
    events: [
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 1, delay: 0, duration: 200}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,40%,70%)", delay: 0, duration: 200}
      },
      {
        func: "createJourneyPath",
        args: {}
      },
      {
        func: "createMarker",
        args: {id: "start-icon"}
      },
      {
        func: "createMarker",
        args: {id: "goal-esp-icon"}
      },
      {
        func: "createMarker",
        args: {id: "goal-uk-icon"}
      },
      {
        func: "createMarker",
        args: {id: "move-icon"}
      },
      {
        func: "createMarker",
        args: {id: "end-icon"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-alejandro", opacity: 1, delay: 300, duration: 2000}
      },
      {
        func: "updateStoryTextFadeIn",
        args: {delay: 350, duration: 1000, storyText: "<b>Alejandro</b>: &laquo;2009 when I worked as a barkeeper in Valencia, I met Emily, a British girl who spent their vacation in Spain. I can tell you - It was love at first sight.&raquo;"}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 12000, duration: 1000, storyText: "<b>Alejandro</b>: &laquo;The two weeks we had were perfect, but Emily had to go back. For over a year we had a long-distance relationship.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-alejandro", opacity: 0, delay: 15000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#goal-esp-icon-alejandro", opacity: 1, delay: 15000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#goal-uk-icon-alejandro", opacity: 1, delay: 15000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 20000, duration: 1000, storyText: "<b>Alejandro</b>: &laquo;It was late in 2010 when I packed my bags and took a flight to Manchester to finally move together with my girlfriend.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#goal-esp-icon-alejandro", opacity: 0, delay: 22000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-icon-alejandro", opacity: 1, delay: 22000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#goal-uk-icon-alejandro", opacity: 0, delay: 27000, duration: 2000}
      },
      {
        func: "moveMarkerAlongPath",
        args: {marker: "move-icon", pathSelector: "#journey-path-alejandro", delay: 26000, duration: 8000}
      },
      {
        func: "animateJourneyPath",
        args: {delay: 27000, duration: 6000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-icon-alejandro", opacity: 0, delay: 35000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#end-icon-alejandro", opacity: 1, delay: 35000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 36000, duration: 1000, storyText: "<b>Alejandro</b>: &laquo;Should I let out a secret? Next month, Emily and I will get married. I am the luckiest guy on earth!&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyText", opacity: 0, delay: 44000, duration: 1000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 0, delay: 44000, duration: 1000}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,90%,25%)", delay: 45000, duration: 1000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#end-icon-alejandro", opacity: 0, delay: 46000, duration: 4000}
      },
    ],
  },
  "francesca": {
    displayName: "Francesca",
    selectIcon: {
      w: 60,
      h: 60
    },
    focusMask : {
      rx: 210,
      ry: 100,
      tx: 300,
      ty: 340,
      r: 50
    },
    storyText: {
      top: 250,
      left: 500
    },
    path: [[405, 461],[255, 425],[203, 284],[240, 240]],
    pathReverse: [[240, 240], [203, 284], [255, 425], [405, 461]],
    marker: {
      "start-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_eXndSrrBPYTtSex" : "data/icons/stories/francesca/start_francesca.svg",
        height: 50,
        width: 40,
        posIdx: 0,
      },
      "move-uk-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_8A1RyszxViQkttb" : "data/icons/stories/francesca/moving_uk_francesca.svg",
        height: 60,
        width: 50,
        posIdx: 0,
      },
      "move-it-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_1zwXkk8cnXQcHYN" : "data/icons/stories/francesca/moving_it_francesca.svg",
        height: 60,
        width: 50,
        posIdx: 3,
      },
      "study-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_0D7XAJgSvIWzoXP" : "data/icons/stories/francesca/study_francesca.svg",
        height: 60,
        width: 60,
        posIdx: 3,
      },
      "party-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_0OCUUjExZkybMod" : "data/icons/stories/francesca/party_francesca.svg",
        height: 60,
        width: 40,
        posIdx: 3,
      },
      "graduate-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_6rrrNANZ3IMvhvn" : "data/icons/stories/francesca/graduate_francesca.svg",
        height: 50,
        width: 40,
        posIdx: 3,
      },
      "end-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_d0fM2jUUeAPFBFX" : "data/icons/stories/francesca/end_milano_francesca.svg",
        height: 50,
        width: 60,
        posIdx: 0,
      },
    },
    events: [
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 1, delay: 0, duration: 200}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,40%,70%)", delay: 0, duration: 200}
      },
      {
        func: "createJourneyPath",
        args: {}
      },
      {
        func: "createJourneyPathReverse",
        args: {}
      },
      {
        func: "createMarker",
        args: {id: "start-icon"}
      },
      {
        func: "createMarker",
        args: {id: "move-uk-icon"}
      },
      {
        func: "createMarker",
        args: {id: "study-icon"}
      },
      {
        func: "createMarker",
        args: {id: "party-icon"}
      },
      {
        func: "createMarker",
        args: {id: "graduate-icon"}
      },
      {
        func: "createMarker",
        args: {id: "move-it-icon"}
      },
      {
        func: "createMarker",
        args: {id: "end-icon"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-francesca", opacity: 1, delay: 300, duration: 2000}
      },
      {
        func: "updateStoryTextFadeIn",
        args: {delay: 350, duration: 1000, storyText: "<b>Francesca</b>: &laquo;I graduated from High School in Torino, and for one year I applied to a few reputable Universities to study Fashion Design. 2014 I luckily got accepted into Westminster University London.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-francesca", opacity: 0, delay: 12000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-uk-icon-francesca", opacity: 1, delay: 12000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 14000, duration: 1000, storyText: "<b>Francesca</b>: &laquo;I moved to London with just one large suitcase and a one-way flight ticket. I found a shared flat with other international students.&raquo;"}
      },
      {
        func: "moveMarkerAlongPath",
        args: {marker: "move-uk-icon", pathSelector: "#journey-path-francesca", delay: 14000, duration: 8000}
      },
      {
        func: "animateJourneyPath",
        args: {delay: 14500, duration: 7000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-uk-icon-francesca", opacity: 0, delay: 24000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#study-icon-francesca", opacity: 1, delay: 24000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 26000, duration: 1000, storyText: "<b>Francesca</b>: &laquo;Besides studying hard, I enjoy the rich cultural life and the vibrant international lifestyle in London.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#study-icon-francesca", opacity: 0, delay: 30000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#party-icon-francesca", opacity: 1, delay: 30000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#study-icon-francesca", opacity: 1, delay: 32000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#party-icon-francesca", opacity: 0, delay: 32000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#study-icon-francesca", opacity: 0, delay: 34000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#party-icon-francesca", opacity: 1, delay: 34000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#study-icon-francesca", opacity: 1, delay: 36000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#party-icon-francesca", opacity: 0, delay: 36000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#study-icon-francesca", opacity: 0, delay: 38000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#party-icon-francesca", opacity: 1, delay: 38000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#study-icon-francesca", opacity: 1, delay: 40000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#party-icon-francesca", opacity: 0, delay: 40000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#study-icon-francesca", opacity: 1, delay: 40000, duration: 500}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#study-icon-francesca", opacity: 0, delay: 42000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#graduate-icon-francesca", opacity: 1, delay: 42000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 42000, duration: 1000, storyText: "<b>Francesca</b>: &laquo;Now, two years later I graduated with distinction. Soon I will go back to Italy where I want to find a job with a famous fashion designer in Milano.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#graduate-icon-francesca", opacity: 0, delay: 46000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-it-icon-francesca", opacity: 1, delay: 46000, duration: 2000}
      },
      {
        func: "moveMarkerAlongPath",
        args: {marker: "move-it-icon", pathSelector: "#journey-path-reverse-francesca", delay: 50000, duration: 8000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-it-icon-francesca", opacity: 0, delay: 58000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#end-icon-francesca", opacity: 1, delay: 58000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyText", opacity: 0, delay: 60000, duration: 1000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 0, delay: 60000, duration: 1000}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,90%,25%)", delay: 61000, duration: 1000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#end-icon-francesca", opacity: 0, delay: 62000, duration: 4000}
      },
    ],
  },
  "ileana": {
    displayName: "Ileana",
    selectIcon: {
      w: 60,
      h: 60
    },
    focusMask: {
      rx: 250,
      ry: 100,
      tx: 400,
      ty: 300,
      r: 20
    },
    storyText: {
      top: 450,
      left: 200
    },
    path: [[553, 371],[399, 240],[270, 218],[230, 220]],
    marker: {
      "start-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_ai73Co7VxCrAA29" : "data/icons/stories/ileana/start_ileana.svg",
        height: 50,
        width: 40,
        posIdx: 0,
      },
      "dream-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_ex44GfKvw9CYRgh" : "data/icons/stories/ileana/dream_ileana.svg",
        height: 50,
        width: 50,
        posIdx: 3,
      },
      "move-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_bq4e8P2OvsLxDEN" : "data/icons/stories/ileana/move_ileana.svg",
        height: 60,
        width: 40,
        posIdx: 0,
      },
      "end-icon": {
        src: qSwitch ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_blWDMgjHIKWvQyN" : "data/icons/stories/ileana/work_ileana.svg",
        height: 50,
        width: 60,
        posIdx: 3,
      },
    },
    events: [
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 1, delay: 0, duration: 200}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,40%,70%)", delay: 0, duration: 200}
      },
      {
        func: "createJourneyPath",
        args: {}
      },
      {
        func: "createMarker",
        args: {id: "start-icon"}
      },
      {
        func: "createMarker",
        args: {id: "dream-icon"}
      },
      {
        func: "createMarker",
        args: {id: "move-icon"}
      },
      {
        func: "createMarker",
        args: {id: "end-icon"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-ileana", opacity: 1, delay: 300, duration: 2000}
      },
      {
        func: "updateStoryTextFadeIn",
        args: {delay: 350, duration: 1000, storyText: "<b>Ileana</b>: &laquo;I recently graduated as Civil Engineer from Bucuresti University.&raquo;"}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 7000, duration: 1000, storyText: "<b>Ileana</b>: &laquo;My goal is to work in an international engineering firm. Compared to Romania there are many options in the UK, so I decided to move to London.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#dream-icon-ileana", opacity: 1, delay: 10000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#start-icon-ileana", opacity: 0, delay: 15000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-icon-ileana", opacity: 1, delay: 15000, duration: 2000}
      },
      {
        func: "moveMarkerAlongPath",
        args: {marker: "move-icon", pathSelector: "#journey-path-ileana", delay: 18000, duration: 12000}
      },
      {
        func: "animateJourneyPath",
        args: {delay: 19500, duration: 10000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#dream-icon-ileana", opacity: 0, delay: 18000, duration: 2000}
      },
      {
        func: "updateStoryTextCrossFade",
        args: {delay: 28000, duration: 1000, storyText: "<b>Ileana</b>: &laquo;It was not that easy as I imagined. While looking for a job in my profession, I am working as a waitress in a Café. I hope to establish my life here in the UK and secure a good job, despite Brexit fears.&raquo;"}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#move-icon-ileana", opacity: 0, delay: 31000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#end-icon-ileana", opacity: 1, delay: 31000, duration: 2000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyText", opacity: 0, delay: 41000, duration: 1000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#storyFocusMask", opacity: 0, delay: 41000, duration: 1000}
      },
      {
        func: "setJourneyPathsColor",
        args: {color: "hsl(300,90%,25%)", delay: 42000, duration: 1000}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: "#end-icon-ileana", opacity: 0, delay: 43000, duration: 4000}
      },
    ],
  },
};
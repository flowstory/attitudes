//TODO: remove 2 from storyScript2 for Qualtrics
var storyScript2 = {
  texts: {
    "text-start": "<div style='padding-top: 30px; font-style: normal;'>Millions of EU citizens immigrated to or emigrated from the United Kingdom between 2000 and 2016. There are many reasons why people migrate. The main reasons are work (people either move for a particular job or look for a job when they arrive), study and join or accompany another person.</br></br>Over time, the number of EU citizens migrating to and from the United Kingdom and the distribution of these key reasons have changed.</div>",
  
    "text-poland-question": "<span style='font-weight:bold; line-height:1.5;'>The EU Grows</span><br/>"
                            + "With the enlargement of the EU in 2004, migration flows from eastern countries increased. "
                            + "Poland is an outstanding example. The flow from from Poland to Great Britain tripled with its entry into the EU and tripled again in 2005.<br/>"
                            + "<div style='margin: 10px 0;' id='yearSelectorPoland'></div>"
                            + "Use the buttons to explore the Polish migration figures between 2004 and 2010, what can you observe?"
                            + "<div class='qStory'><hr>Before you continue, fill in the correct years: <br/><br/>"
                            + "<select id='yearInflow'><option disabled selected value> -- year -- </option><option value='2004'>2004</option><option value='2005'>2005</option><option value='2006'>2006</option><option value='2007'>2007</option><option value='2008'>2008</option><option value='2009'>2009</option><option value='2010'>2010</option><select>"
                            + " was the year with the highest <span style='color:red;font-weight:bold;'>inflow</span> of Polish citizens to the UK.</br><br/>"
                            + "<select id='yearOutflow'><option disabled selected value> -- year -- </option><option value='2004'>2004</option><option value='2005'>2005</option><option value='2006'>2006</option><option value='2007'>2007</option><option value='2008'>2008</option><option value='2009'>2009</option><option value='2010'>2010</option><select>"
                            + " was the year with the highest <span style='color:blue;font-weight:bold;'>outflow</span> of Polish citizens from the UK.</div>",
    "text-poland-answer": "<span style='font-style:italic; line-height:1.5;'>Your answer: <span id='aPoland'></span></span><br/>"
                            + "The immigration figures from Poland to the UK peaked in <b>2007</b>. The highest outflow was one year later in <b>2008</b>."
                            + "<div style='margin: 10px 0;' id='yearSelectorPoland'></div>"
                            + "<hr>"
                            + "With the date of joining the EU, there is often a shift in the distribution of migration reasons for new member states. "
                            + "Often we can see a significant shift in the number of people coming to the UK to look for a job and people moving due to a particular job offer. "
                            + "Also the number of people coming to study increases.",


    "text-romania-bulgaria-question": "<span style='font-weight:bold; line-height:1.5;'>Romania or Bulgaria?</span><br/>"
                            + "In 2007 two states, Romania and Bulgaria joined the EU. In recent years, one of the two countries became the country with the highest migration figures."
                            + "<div class='qStory'><hr>From which of the two countries do you think more people have emigrated to Britan since they joined the EU?<br/>"
                            + "<input type='radio' name='roubgr' value='Bulgaria' id='oBulgaria'><label for='oBulgaria'>Bulgaria</label></br>"
                            + "<input type='radio' name='roubgr' value='Romania' id='oRomania'><label for='oRomania'>Romania</label></div>",
    "text-romania-bulgaria-answer": "<span style='font-style:italic; line-height:1.5;'>Your answer: <span id='aRouBgr'></span></span><br/>"
                                + "It's Romania. By 2014, Romania has replaced Poland regarding absolute migration figures."
                                + "<hr>"
                                + "Between 2007 and 2016, many more citizens emigrated from Romania than from Bulgaria to the UK. "
                                + "But the main reason for both countries was the same during this period. Around 75% of Romanians and Bulgarians came to work here.",

    "text-oldeu-question": "<span style='font-weight:bold; line-height:1.5;'>Stable and Longterm</span><br/>"
                            + "Countries such as France, Germany and Spain founded or joined the EU long before 2000. "
                            + "Their migration flows to and from the UK are more or less stable over the whole period (2000-2016)."
                            + "<div class='qStory'><hr>Which of these countries has the largest absolute migration flow (<span style='color:red;'>inflow</span> + <span style='color:blue;'>outflow</span>)?<br/>"
                            + "<input type='radio' name='oldeu' value='Spain' id='oSpain' ><label for='oSpain'>Spain</label></br>"
                            + "<input type='radio' name='oldeu' value='Germany' id='oGermany' ><label for='oGermany'>Germany</label></br>"
                            + "<input type='radio' name='oldeu' value='France' id='oFrance' ><label for='oFrance'>France</label></div>",
    "text-oldeu-answer": "<span style='font-style:italic; line-height:1.5;'>Your answer: <span id='aOldEu'></span></span><br/>"
                            + "It's France. Out of these countries, France has the largest absolute migration figures."
                            + "<hr>"
                            + "Throughout the whole period, the main reason for migration was a specific job (around 50%) in all three countries. "
                            + "But especially in the early noughties, often more people came to Britain to study.",

    "text-netflows-question": "<span style='font-weight:bold; line-height:1.5;'>Inflow vs. Outflow</span><br/>"
                            + "So far you have seen migratory inflows and outflows to and from the UK of six EU member states.</br></br>"
                            + "On this map, you can see the respective net flows (inflows minus outflows) to the UK for the entire period (2000-2016). "
                            + "The six countries have a positive net migration to the UK in common. That means <span style='color:red;'>more citizens entered</span> than left the UK."
                            + "<div class='qStory'><hr>From which of the following countries do you think <span style='color:blue;'>more citizens left</span> than entered the UK between 2000 and 2016?<br/>"
                            + "<input type='radio' name='netflows' value='Portugal' id='oPortugal' ><label for='oPortugal'>Portugal</label></br>"
                            + "<input type='radio' name='netflows' value='Denmark' id='oDenmark' ><label for='oDenmark'>Denmark</label></br>"
                            + "<input type='radio' name='netflows' value='Slovakia' id='oSlovakia' ><label for='oSlovakia'>Slovakia</label></div>",
    "text-netflows-answer": "<span style='font-style:italic; line-height:1.5;'>Your answer: <span id='aNetFlows'></span></span><br/>"
                            + "It is Denmark. Between 2000 and 2016, 75% of Danish citizens left the UK to study."
                            + "<hr>"
                            + "Take a look at the map and consider which other EU countries may have a positive or a negative net migration flow to the UK. Click next to compare." 
                            ,

    "text-final": "<b>The Big Picture</b><br/>"
                  + "In fact, many other citizens from other EU countries entered or left the UK between 2000 and 2016. Most countries have a positive net migration flow to the UK in this 17 years.</br></br>"
                  + "How do you think migration between the UK and the EU will develop after Brexit?</br></br>"
                  + "Use the remaining time to revisit the different parts of the story and take a look at the maps to see if you can find interesting patterns. The visualisation continues after the remaining time has elapsed.",

  },
  chapters: [
    //CHAPTER-START
    [
      {
        func: "updateStoryTextAndStyleCrossFadeC2",
        args: {delay: 0, duration: 800, storyText: "text-start", selector: "#storyTextC2Text", style: {top: "10px", left: "10px", width: "600px"}}
      },
      {
        func: "removeElement",
        args : {selector: ".chapter_group"}
      },
      {
        func: "highlightCountries",
        args: {selector: "#C_POL", flag: false}
      },
      {
        func: "fadeElementToOpacity",
        args: {selector: ".hint2b", opacity: 1, delay: 0, duration: 800}
      },
    ],
    
    //CHAPTER-POLAND
    //QUESTION
    [
      {
        func: "fadeElementToOpacity",
        args: {selector: ".hint2b", opacity: 0, delay: 0, duration: 800}
      },
      {
        func: "highlightCountries",
        args: {selector: "#C_POL", flag: true}
      },
      {
        func: "drawOrUpdateInOutFlowForSelectionByYears",
        args: {selector: ["POL"], id:"inOutFlowPoland", delay: 0, duration: 1000, opacity: 1, fromYearIdx: 5, toYearIdx: 5}
      },
      {
        func: "updateStoryTextAndStyleCrossFadeC2",
        args: {delay: 0, duration: 800, storyText: "text-poland-question", selector: "#storyTextC2Text", style:{top: "50px", left: "615px", width: "350px"}}
      },
    ],
    //ANSWER
    [
      {
        func: "highlightCountries",
        args: {selector: "#C_ROU, #C_BGR", flag: false}
      },
      {
        func: "highlightCountries",
        args: {selector: "#C_POL", flag: true}
      },
      {
        func: "drawOrUpdateInOutFlowForSelectionByYears",
        args: {selector: ["POL"], id:"inOutFlowPoland", delay: 0, duration: 1000, opacity: 1, fromYearIdx: 7, toYearIdx: 7}
      },
      {
        func: "updateStoryTextAndStyleCrossFadeC2",
        args: {delay: 0, duration: 800, storyText: "text-poland-answer", selector: "#storyTextC2Text", style:{top: "50px", left: "615px", width: "350px"}}
      },
      {
        func: "addYearButtonsToStoryText",
        args: {delay: 810, fromYearIdx: 7, toYearIdx: 8, cc: "POL", id:"inOutFlowPoland", startIdx: 7}
      },
    ],

    //CHAPTER-ROMANIA-BULGARIA
    //QUESTION
    [
      {
        func: "highlightCountries",
        args: {selector: "#C_POL", flag: false}
      },
      {
        func: "removeElement",
        args : {selector: "#inOutFlowPoland, #inOutFlowsRomaniaBulgaria"}
      },
      {
        func: "highlightCountries",
        args: {selector: "#C_ROU, #C_BGR", flag: true}
      },
      {
        func: "updateStoryTextAndStyleCrossFadeC2",
        args: {delay: 0, duration: 800, storyText: "text-romania-bulgaria-question", selector: "#storyTextC2Text", style:{top: "50px", left: "615px", width: "350px"}}
      },
    ],
    //ANSWER
    [
      {
        func: "removeElement",
        args : {selector: "#inOutFlowsOldEU"}
      },
      {
        func: "highlightCountries",
        args: {selector: "#C_FRA, #C_ESP, #C_DEU", flag: false}
      },
      {
        func: "highlightCountries",
        args: {selector: "#C_ROU, #C_BGR", flag: true}
      },
      {
        func: "drawInOutFlowForSelectionByYears",
        args: {selector: ["ROU", "BGR"], id:"inOutFlowsRomaniaBulgaria", delay: 0, duration: 1000, opacity: 1, fromYearIdx: 7, toYearIdx: 16, scaleMode: "aggregate"}
      },
      {
        func: "updateStoryTextAndStyleCrossFadeC2",
        args: {delay: 0, duration: 800, storyText: "text-romania-bulgaria-answer", selector: "#storyTextC2Text", style:{top: "50px", left: "615px", width: "350px"}}
      },
    ],
    
    //CHAPTER-OLD-EU
    //QUESTION
    [
      {
        func: "highlightCountries",
        args: {selector: "#C_ROU, #C_BGR", flag: false}
      },
      {
        func: "highlightCountries",
        args: {selector: "#C_FRA, #C_DEU, #C_ESP", flag: true}
      },
      {
        func: "removeElement",
        args : {selector: "#inOutFlowsRomaniaBulgaria"}
      },
      {
        func: "updateStoryTextAndStyleCrossFadeC2",
        args: {delay: 0, duration: 800, storyText: "text-oldeu-question", selector: "#storyTextC2Text", style:{top: "50px", left: "615px", width: "350px"}}
      },
      {
        func: "drawOrUpdateInOutFlowForSelectionByYears",
        args: {selector: ["DEU", "FRA", "ESP"], id:"inOutFlowsOldEU", delay: 0, duration: 1000, opacity: 1, fromYearIdx: 0, toYearIdx: 16, scaleMode: "aggregate"}
      },
    ],
    //ANSWER
    [
      {
        func: "removeElement",
        args : {selector: "#inOutFlowsRomaniaBulgaria, #netFlowsSelected"}
      },
      {
        func: "highlightCountries",
        args: {selector: "#C_ROU, #C_BGR, #C_POL", flag: false}
      },
      {
        func: "updateStoryTextAndStyleCrossFadeC2",
        args: {delay: 0, duration: 800, storyText: "text-oldeu-answer", selector: "#storyTextC2Text", style:{top: "50px", left: "615px", width: "350px"}}
      },
      {
        func: "moveTitleTo",
        args: {delay: 0, duration: 1500, top: "20px", left: "20px"}
      },
      {
        func: "drawOrUpdateInOutFlowForSelectionByYears",
        args: {selector: ["DEU", "FRA", "ESP"], id:"inOutFlowsOldEU", delay: 0, duration: 1000, opacity: 1, fromYearIdx: 0, toYearIdx: 16, scaleMode: "aggregate"}
      },
    ],

    //NET-FLOWS-DISCUSSED
    //QUESTION
    [
      {
        func: "removeElement",
        args : {selector: "#inOutFlowsOldEU, #netFlowDenmark"}
      },
      {
        func: "highlightCountries",
        args: {selector: "#C_DNK", flag: false}
      },
      {
        func: "highlightCountries",
        args: {selector: "#C_ROU, #C_BGR, #C_FRA, #C_POL, #C_ESP, #C_DEU", flag: true}
      },
      {
        func: "updateStoryTextAndStyleCrossFadeC2",
        args: {delay: 0, duration: 800, storyText: "text-netflows-question", selector: "#storyTextC2Text", style:{top: "50px", left: "615px", width: "350px"}}
      },
      {
        func: "drawNetFlowsforSelectionByYears",
        args: {selector: "#F_POL, #F_ROU, #F_ESP, #F_FRA, #F_DEU, #F_BGR", id:"netFlowsSelected", delay: 0, duration: 1000, opacity: 1, fromYearIdx: 0, toYearIdx: 16, scaleMode: "aggregate", drawAnnotation: false}
      }
    ],
    //ANSWER
    [
      {
        func: "removeElement",
        args : {selector: "#netFlowsAll"}
      },
      {
        func: "highlightCountries",
        args: {selector: "#C_DNK, #C_ROU, #C_BGR, #C_FRA, #C_POL, #C_ESP, #C_DEU", flag: true}
      },
      {
        func: "updateStoryTextAndStyleCrossFadeC2",
        args: {delay: 0, duration: 800, storyText: "text-netflows-answer", selector: "#storyTextC2Text", style:{top: "50px", left: "615px", width: "350px"}}
      },
      {
        func: "drawNetFlowsforSelectionByYears",
        args: {selector: "#F_DNK", id:"netFlowDenmark", delay: 0, duration: 1000, opacity: 1, fromYearIdx: 0, toYearIdx: 16, scaleMode: "aggregate", drawAnnotation: false}
      },
      {
        func: "drawNetFlowsforSelectionByYears",
        args: {selector: "#F_POL, #F_ROU, #F_ESP, #F_FRA, #F_DEU, #F_BGR", id:"netFlowsSelected", delay: 0, duration: 1000, opacity: 1, fromYearIdx: 0, toYearIdx: 16, scaleMode: "aggregate", drawAnnotation: false}
      }
    ],

    //END ALL EU
    [
      {
        func: "removeElement",
        args : {selector: "#netFlowsSelected, #netFlowDenmark"}
      },
      {
        func: "highlightCountries",
        args: {selector: ".eu", flag: false}
      },
      {
        func: "updateStoryTextAndStyleCrossFadeC2",
        args: {delay: 0, duration: 800, storyText: "text-final", selector: "#storyTextC2Text", style:{top: "50px", left: "615px", width: "350px"}}
      },
      {
        func: "drawNetFlowsforSelectionByYears",
        args: {selector: ".flow", id:"netFlowsAll", delay: 0, duration: 1000, opacity: 1, fromYearIdx: 0, toYearIdx: 16, scaleMode: "aggregate", drawAnnotation: false}
      
      },
    ],

  ],
 
};
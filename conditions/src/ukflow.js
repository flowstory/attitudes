var Flowstory = (function() {
  "use strict";

/*** =========================================================================================== ***/
/*** GLOBAL VARIABLES ***/
/*** =========================================================================================== ***/
  var condition,
    qualtricsContext,
    qualtricsSurveyEngine,
    vis,
    slider,
    tooltip,
    flowGroup,
    timeBar,
    numericTimer,
    progressBar,
    storyText,
    storyTextC2,
    logger = {},
    qVals={},

    //scrolling (condition 2)
    scrollPos = 0,
    minScroll = 0,
    maxScroll = 7,
    minChapter = 0,
    maxChapter,
    currentChapter = 0,


    //timer for all conditions
    //TODO: different advance times for different conditions?
    timer,
    //advanceTime = 10000,//300000,
    maxTime = [[480000], [300000, 180000], [270000, 180000]],//480000,270000, 300000
    phase = 0,

    format2SI = d3.format(".2s"),
    format1SI = d3.format(".1s"),
    pi = Math.PI,

    //data and selected time periode
    year = 0,
    maxYearIdx = 16,
    minYear = 2000,
    currentYear = 2000,
    maxYear = 2016,

    //line width and scaling
    minWidth = 2,
    maxWidth = 30,
    scaleGlobal = true,

    //modes statesF
    aggregateMode = true,
    detailMode = false,

    //countries
    detailCountry,
    euCountries = [],
    euSince = {'AUT': 2000, 'BEL': 2000, 'DNK': 2000, 'FIN': 2000, 'FRA': 2000, 'DEU': 2000, 'GRC': 2000, 'ITA': 2000, 'LUX': 2000, 'NLD': 2000, 'PRT': 2000, 'IRL': 2000, 'ESP': 2000, 'SWE': 2000, 'CYP': 2004, 'CZE': 2004, 'EST': 2004, 'HUN': 2004, 'LVA': 2004, 'LTU': 2004, 'MLT': 2004, 'POL': 2004, 'SVK': 2004, 'SVN': 2004, 'BGR': 2007, 'ROU': 2007, 'HRV': 2013},

    //reasons
    mrom = "all",
    mroms = ['job', 'looking', 'study', 'join'],
    keys = ["in", "out"],
    colours = {
      "job": {"in": "#bebada", "out": "#fb9a99"},
      "looking": {"in": "#d1cbd6", "out": "#fdbf6f"},
      "study": {"in": "#b3de69", "out": "#b2df8a"},
      "join": {"in": "#8dd3c7", "out": "#a6cee3"}
    },
    /*
    reasons = {all: 'All reasons', work: 'Work related reasons', job: 'Definite job',
       'Looking for work': 'looking', 'Accompany or Join': 'join', 'Formal study': 'study',
       'Going home to live': 'home', 'Other reasons': 'ohter', 'No reason stated': 'no'},
    */

    //chart
    chart,
    chartWidth,
    chartHeight,
    visSpacing,
    baseR,
    chartRMax,
    legendInArc,
    legendOutArc,
    arrowOutArc,
    arrowInArc,
    pieIn,
    pieOut,
    arcIn,
    arcOut,

    // flow data min max
    max = 0,
    min = 0,
    globalNetMax = 0,
    globalNetMin = 999999,
    globalMax = 0,
    globalMin = 999999,
    aggregatedNetMax = 0,
    aggregatedNetMin = 999999,
    aggregatedMax = 0,
    aggregatedMin = 999999,
    localNetMax = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    localNetMin = [999999,999999,999999,999999,999999,999999,999999,999999,999999,999999,999999,999999,999999,999999,999999,999999,999999],

    // map
    svgMap,
    geoPath = d3.geoPath(),
    layerName = "ne_50m_admin_0_clip2",
    
    geoUrl = (window.location.hostname === "cityunilondon.eu.qualtrics.com") ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_4V0IleE4gtYT68R" : "data/" + layerName + ".json",
    //geoUrl = "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_4V0IleE4gtYT68R",

    //map projection
    conicEquidistant = d3.geoConicEquidistant()
      .parallels([41, 65])
      .center([0, 53])
      .precision(.1)
      .rotate([-14, 0])
      .scale(1100)
      .translate([410,250]),

    //flow lines
    lineGenerator = d3.line().curve(d3.curveBasis),

    //story playback
    isPlaying = false,
    readyToPlay = true,
    inTransition = false,
    storyStart,
    storyDuration,
    elapsedTime = 0,
    endOfPlaybackTimeOut = [],
    currentStory = null,
    playedAtLeastOnce = [],
    darrays = {
      "cecile": 95, 
      "klaus": 100,
      "jakub": 220,
      "alejandro": 190,
      "francesca": 285, 
      "ileana": 330
    },
    storyTextTimer = [],

    hintsCondition1,
    hintsCondition2,
    hintsCondition3,
    isHintsCondition1Active = false,
    hintsCondition1Timeout,

    curvedArrowUrl = (window.location.hostname === "cityunilondon.eu.qualtrics.com") ? "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_4MKj6D6mLdcc5RX" : "data/icons/hints/arrow_curved.svg",
    //curvedArrowUrl = "Qualtrics",

    selectionIconUrls = (window.location.hostname === "cityunilondon.eu.qualtrics.com")? 
    {
      "cecile": "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_204D8mBuBZlCSJD",
      "klaus": "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_eyTqtsCOCUeXvHT",
      "jakub": "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_eXKv0Wbikcekv1H",
      "alejandro": "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_5j3udMctHIa3Jf7",
      "francesca": "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_9AET5SAsFx13gq1",
      "ileana": "https://cityunilondon.eu.qualtrics.com/ControlPanel/File.php?F=F_6mwB7i22IbQWEAZ"
    }:{
      "cecile": "data/icons/selection/cecile.svg",
      "klaus": "data/icons/selection/klaus.svg",
      "jakub": "data/icons/selection/jakub.svg",
      "alejandro": "data/icons/selection/alejandro.svg",
      "francesca": "data/icons/selection/francesca.svg",
      "ileana": "data/icons/selection/ileana.svg"
    },

    //public object

    my = {};

/*** =========================================================================================== ***/
/*** SETUP FLOW DATA ***/
/*** =========================================================================================== ***/
  function logAction(value) {
    var idx = Math.floor(d3.now());
    if (idx in logger) {
      idx++;
    }
    logger[idx] = value;
    //console.log(JSON.stringify(logger));
  }
  /***  Calculate Min and Max***/
  function setupFlowDataMinMax() {
    flowData.forEach(function(country){
      //var result1 = country['in']['all'].reduce((accumulator, currentValue) => accumulator + currentValue);
      //var result = country['in']['all'].reduce(function(a, b) {return Math.max(a, b);});
      var sum_in = 0, sum_out = 0;
      for (var i=0; i <= maxYearIdx; i++) {
        globalMin = Math.min(globalMin, country['in']['all'][i], country['out']['all'][i]);
        globalMax = Math.max(globalMax, country['in']['all'][i], country['out']['all'][i]);
        var delta = Math.abs(country['in']['all'][i] - country['out']['all'][i]) 
        if (delta > globalNetMax) globalNetMax = delta;
        if (delta > 0 && delta < globalNetMin) globalNetMin = delta;
        if (delta > localNetMax[i]) localNetMax[i] = delta;
        if (delta > 0 && delta < localNetMin[i]) localNetMin[i] = delta;
        sum_in += country['in']['all'][i];
        sum_out += country['out']['all'][i];
      }
      country['sum_all_in'] = sum_in;
      country['sum_all_out'] = sum_out;
      aggregatedMin = Math.min(aggregatedMin, sum_in, sum_out);
      aggregatedMax = Math.max(aggregatedMax, sum_in, sum_out);
      var countryBalance = Math.abs(sum_in - sum_out);
      if (countryBalance > aggregatedNetMax) aggregatedNetMax = countryBalance;
      if (countryBalance > 0 && countryBalance < aggregatedNetMin) aggregatedNetMin = countryBalance;
      //country['in']['geom'] = [result];
      //console.log(country.cc, result1);
      euCountries.push(country['cc']);
    });

    min = aggregatedNetMin;
    max = aggregatedNetMax;

    /*
    console.log("localNetMin", localNetMin);
    console.log("localNetMax", localNetMax);
    console.log("globalNetMin", globalNetMin);
    console.log("globalNetMax", globalNetMax);
    console.log("aggregatedNetMin", aggregatedNetMin);
    console.log("aggregatedNetMax", aggregatedNetMax);

    console.log("globalMin", globalMin);
    console.log("globalMax", globalMax);
    console.log("aggregatedMin", aggregatedMin);
    console.log("aggregatedMax", aggregatedMax);
    */

  } // END setupFlowDataMinMax

  /*** Calculate Flow Line Coordinates ***/
  function setupFlowLines() {
    flowData.forEach(function(country){
      //country.ep.lon = -1.701037598;
      //country.ep.lat = 53.46900635

      var xySp = conicEquidistant([country.sp.lon, country.sp.lat]);
      var xyEp = conicEquidistant([country.ep.lon, country.ep.lat]);
      country.sp.x = xySp[0];
      country.sp.y = xySp[1];
      country.ep.x = xyEp[0];
      country.ep.y = xyEp[1];

      var v = [xyEp[0] - xySp[0], xyEp[1] - xySp[1]];
      var vLen = Math.sqrt(v[0]*v[0] + v[1]*v[1]);
      var vn = [v[0]/vLen, v[1]/vLen];
      var segLen = vLen/country.cp.p;
      
      var cp = [xySp[0] + (vn[0] * segLen * (country.cp.p-1)), xySp[1] + (vn[1] * segLen * (country.cp.p-1))];

      var phi = Math.PI - Math.atan2(xySp[0] - xyEp[0], xySp[1] - xyEp[1])
      var cpMoved = [cp[0] - country.cp.d * Math.cos(phi), cp[1] - country.cp.d * Math.sin(phi)]

      country.cp_moved = cpMoved

      country.line = lineGenerator([xySp, cpMoved, xyEp]);
      //console.log(country.line);
      //country.line = ['M', xySp, 'Q', [country.cp.x, country.cp.y], xyEp].join(' ')
    });
  } // END setupFlowLines

  function setupFlows(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;

    flowGroup = svgMap.append("g").attr("class","flow_group").style("opacity", opacity).style("visibility", visibility);
    var flowGroupSelection = svgMap.append("g").attr("class","flow_group_selection").style("opacity", opacity).style("visibility", visibility);

    var fG = flowGroup.selectAll("path").data(flowData);
    var fGSel = flowGroupSelection.selectAll("path").data(flowData);

    fG.enter()
      .append("path")
      .attr("id", function(d) {return "F_" + d.cc;})
      .attr("class", "flow")
      .attr("d", function(d){return d.line})
    
    fGSel.enter()
      .append("path")
      .attr("id", function(d) {return "FSel_" + d.cc;})
      .attr("class", "flowSel")
      .attr("d", function(d){return d.line})
      .style("opacity", 0)
      .attr("fill", "none")
      .attr("stroke", "black")
      .attr("stroke-width", 2);

    updateFlows(true);
  } //END setupFlows

  function setupInOutFlow(f) {
    detailCountry = f;
    var flowVals = getFlowValues(f);
    // /console.log(flowVals);
    var sw_in = calculateStrokeWidthByDirection(flowVals, 'in');
    var sw_out = calculateStrokeWidthByDirection(flowVals, 'out');
    var offset_in = sw_in/2;
    var offset_out = -sw_out/2;
    //console.log(sw_in, sw_out);

    var inLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], offset_in + 2));
    var outLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], offset_out - 2));

    var inOutGrp = svgMap.append("g").attr("class","flow_inout");

    var inPath = inOutGrp
      .append("path")
      .attr("class", "inPath")
      .attr("d", inLine)
      .attr("fill", "none")
      .attr("stroke", "hsl(355, 80%, 50%)")
      .attr("stroke-linecap", "butt")
      .attr("stroke-width", sw_in)
      .on("mouseover", function(d){updateTooltip(f,true)})
      .on("mousemove", mousemoveFlowOrCountry)
      .on("mouseout", function(){tooltip.style("display", "none");});

    var lengthInPath = inPath.node().getTotalLength();

    var outPath = inOutGrp
      .append("path")
      .attr("class", "outPath")
      .attr("d", outLine)
      .attr("fill", "none")
      .attr("stroke", "hsl(215, 80%, 50%)")
      .attr("stroke-linecap", "butt")
      .attr("stroke-width", sw_out)
      .on("mouseover", function(d){updateTooltip(f,true)})
      .on("mousemove", mousemoveFlowOrCountry)
      .on("mouseout", function(){tooltip.style("display", "none");});

    var lengthOutPath = outPath.node().getTotalLength();

    //console.log("draw", lengthInPath + lengthOutPath);

    var duration = 1000;//5 * (lengthInPath + lengthOutPath);

    inPath 
        .attr("stroke-dasharray", lengthInPath + " " + lengthInPath)
        .attr("stroke-dashoffset", lengthInPath)
        .transition()
          .duration(duration)
          .ease(d3.easeSin)
          .attr("stroke-dashoffset", 0);

    outPath 
        .attr("stroke-dasharray", lengthOutPath + " " + lengthOutPath)
        .attr("stroke-dashoffset", -lengthOutPath)
        .transition()
          .duration(duration)
          .ease(d3.easeSin)
          .attr("stroke-dashoffset", 0);

  }//END setupInOutFlow

/*** =========================================================================================== ***/
/*** UPDATE FLOW DATA ***/
/*** =========================================================================================== ***/

  function updateFlows(isInit, fromYearIdx, toYearIdx) {
    if (isInit === undefined) {
      isInit = false;
    }
    var padding = 2; //for selection
    flowGroup.selectAll('path.flow').each(function(d,i,n){
      var isIn = false, isOut = false, isEqual = false, isZero = false;

      var values, sw;
      if (fromYearIdx != undefined && toYearIdx != undefined){
        values = getFlowValuesFromToYears(d, fromYearIdx, toYearIdx);
        sw = calculateStrokeWidthScaleGlobal(values)
        //console.log(d3.select(this).attr("id"), values, sw, values.in+values.out)
        
      } else {
        values = getFlowValues(d);
        sw = calculateStrokeWidth(values);
      } 
      
      if (values['balance'] == 0) {
        if (values['in'] == 0 && values['out'] == 0) {
          isZero = true;
        } else {
          isEqual = true;
        }
      } else if (values['balance'] < 0) {
        isOut = true;      
      } else if (values['balance'] > 0) {
        isIn = true;
      }

      var idForSelection = "#FSel_" + d3.select(this).attr("id").slice(-3);

      if (isInit) {
        d3.select(this)
          .attr('stroke-width', sw)
          .classed('in', isIn)
          .classed('out', isOut)
          .classed('equal', isEqual);
          //.classed('zero', isZero);
        d3.select(idForSelection)
          .attr('stroke-width', sw + (2*padding));
      } else if (!isZero){
        d3.select(this)
          .classed('in', isIn)
          .classed('out', isOut)
          .classed('equal', isEqual)
          //.classed('zero', isZero)
          .transition()
            .duration(200)
            .style('opacity', 1)
            .style('visibility', 'visible')
            .attr('stroke-width', sw);

        d3.select(idForSelection)
          .transition()
            .duration(200)
            .style('visibility', 'visible')
            .attr('stroke-width', sw + (2*padding));

      } else {
        d3.select(this)
          .transition()
            .duration(200)
            .style('opacity', 0)
          .transition()
            .delay(200)
            .style('visibility', 'hidden')
            .attr('stroke-width', sw);
          //.classed('zero', isZero);

        d3.select(idForSelection)
          .transition()
            .delay(200)
            .style('visibility', 'hidden')
            .attr('stroke-width', sw + (2*padding));
      }
    });

  }//END updateFlows

  function updateInOutFlow() {
    var f = detailCountry;
    var flowVals = getFlowValues(f);
    // /console.log(flowVals);
    var sw_in = calculateStrokeWidthByDirection(flowVals, 'in');
    var sw_out = calculateStrokeWidthByDirection(flowVals, 'out');
    var offset_in = sw_in/2;
    var offset_out = -sw_out/2;

    var inLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], (sw_in/2) + 2));
    var outLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], (-sw_out/2) - 2));

    d3.select(".inPath")
      .attr("stroke-dasharray", "") //lengthInPath + " " + lengthInPath)
      .transition()
        .duration(200)
        .attr("d", inLine)
        .attr("stroke-width", sw_in);

    d3.select(".outPath")
      .attr("stroke-dasharray", "")
      .transition()
        .duration(200)
        .attr("d", outLine)
        .attr("stroke-width", sw_out);
  }//END updateInOutFlow

/*** =========================================================================================== ***/
/*** ACCESS FLOW DATA ***/
/*** =========================================================================================== ***/
  function getFlowValuesFromToYears(d, fromYearIdx, toYearIdx) {
    var sum_in = 0, sum_out = 0;
    for (var i = fromYearIdx; i <= toYearIdx; i++ ) {
        sum_in += d["in"][mrom][i];
        sum_out += d["out"][mrom][i];
      }
    return {"in": sum_in, "out": sum_out, "balance": sum_in - sum_out};
  }
  
  function getFlowValues(d) {
    if (aggregateMode) {
      var sum_in = 0, sum_out = 0;
      for (var i = 0; i <= maxYearIdx; i++ ) {
        sum_in += d["in"][mrom][i];
        sum_out += d["out"][mrom][i];
      }
      return {"in": sum_in, "out": sum_out, "balance": sum_in - sum_out};
    } else {
      return {"in": d["in"][mrom][year], "out": d["out"][mrom][year], "balance": d["in"][mrom][year] - d["out"][mrom][year]};
    }
  }//END getFlowValues

  //mroms as sum of all countries for entire time
  function getMrom(countries, y1, y2) {
    var d = {};
    d['in'] = {'job': 0, 'looking': 0, 'study': 0, 'join': 0, 'home': 0, 'other': 0};
    d['out'] = {'job': 0, 'looking': 0, 'study': 0, 'join': 0, 'home': 0, 'other': 0};
    countries.forEach(function(country){
      for(var r = 0; r < mroms.length; r++){
        for(var y = y1; y <= y2; y++){
          d['in'][mroms[r]] += country['in'][mroms[r]][y];
          d['out'][mroms[r]] += country['out'][mroms[r]][y];
          if (mroms[r] === 'other') {
            d['in'][mroms[r]] += country['in']['no'][y];
            d['out'][mroms[r]] += country['out']['no'][y];
          }
        }
      }
    });
    //console.log(d);
    var dReturn = [];
    for(var r = 0; r < mroms.length; r++){
      var dr = {}
      dr['mrom'] = mroms[r];
      dr['in'] = d['in'][mroms[r]];
      dr['out'] = d['out'][mroms[r]];
      dReturn.push(dr);
    }
    //console.log(dReturn);
    return dReturn;
  }//END getMrom

  function getMromAll(countries, y1, y2) {
    var d = {};
    d['mrom'] = 'all';
    d['in'] = 0; //{'all': 0};
    d['out'] = 0; //{'all': 0};
    countries.forEach(function(country){
        for(var y = y1; y <= y2; y++){
          d['in'] += country['in']['all'][y];
          d['out'] += country['out']['all'][y];
        }
    });
    return d;
  }//END getMromAll

/*** =========================================================================================== ***/
/*** SETUP COUNTRY DATA ***/
/*** =========================================================================================== ***/

  function setupBackgroundMap() {
    d3.json(geoUrl, function(error, topology) {
      if (error) throw error;

      var geojson = topojson.feature(topology, topology.objects[layerName]);

      geoPath.projection(conicEquidistant);

      svgMap.append("g")
        .attr("class", "europe")
        .selectAll("path")
        .data(geojson.features)
        .enter().append("path")
        .attr("id", function(d) {
                return "C_" + d.properties.ADM0_A3;
              })
        .attr("class", function(d){
                          if (d.properties.ADM0_A3 === "GBR") {
                            return "uk";
                          } else if (euCountries.includes(d.properties.ADM0_A3)) {
                            return "eu eu-attime";
                          } else {
                            return "non-eu";
                          } 
                      })
        .attr("d", geoPath);

      svgMap.append("path")
          .attr("class", "europe-borders")
          .attr("d", geoPath(topojson.mesh(topology, topology.objects[layerName], function(a, b) { return a !== b; })));

      var graticule = d3.geoGraticule().extent([[-40,81],[80,20]]);
      svgMap.append("path")
        .attr("class", "graticule")
        .attr("d", geoPath(graticule()));

      
      if (condition === 2) {
        // Initialise Condition 2
        setupCondition2();
      } else if (condition === 3) {
        //Initialise Condtion 3
        setupCondition3();
      } else {
        //Initialise Condition 1
        setupCondition1();
      }

    }); //load geographies, json
  } // END setupBackgroundMap

/*** =========================================================================================== ***/
/*** UPDATE COUNTRY DATA ***/
/*** =========================================================================================== ***/

  function updateBackgroundMap() {
    if (aggregateMode) {
      d3.selectAll('path.eu')
        .classed('eu-attime', true)
        .classed('eu-notyet', false);
    } else {
      d3.selectAll('path.eu').each(function(d,i,n){
        var isEuAtTime = false, isEuNotYet = false;
        if (currentYear >= euSince[d.properties.ADM0_A3]) {
          isEuAtTime = true;
        } else {
          isEuNotYet = true;
        }
        d3.select(this)
          .classed('eu-attime', isEuAtTime)
          .classed('eu-notyet', isEuNotYet);
      });
    }
  }

/*** =========================================================================================== ***/
/*** CREATE DOM ELEMENTS ***/
/*** =========================================================================================== ***/

  function createElementsCondition1() {
    createElementConditions();
    createToggleModeButton();
    createHintsCondition1("visible", 20000);
    createHowToButton();
    createSlider();
    createChart();
    createLegend();
    createTooltip();
  }//END createElementsCondition1

  function createElementsCondition2() {
    createElementConditions();
    
    createToggleModeButton("hidden");
    createHintsCondition2();
    createHintsCondition1("hidden");
    createHowToButton("hidden");
    createSlider("hidden");
    createChart("hidden");
    createLegend("hidden");
    createTooltip();

    createStoryText("hidden");

    createStoryTextC2("hidden");
    createStoryNavigation();
    
    createInfoModal("hidden");

  }//END createElementsCondition2

  function createElementsCondition3() {
    createElementConditions();
    createToggleModeButton("hidden");
    createHintsCondition3();
    createHintsCondition1("hidden");
    createHowToButton("hidden");
    createSlider("hidden");
    createChart("hidden");
    createLegend("hidden");
    createTooltip();

    createStoryFocusMask();
    createStoryText("hidden");
    createJourneySelection();

    createInfoModal("hidden");

  }//END createElementsCondition3

  function createElementConditions() {
    //createTimeBar();
    createNumericTimer();
    createTitle();
  }//END createElementCondtions

  /*** IN ALPHABETICAL ORDER ***/

  function createChart(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;

    var c = vis.append("div")
      .attr("id", "chart")
      .style("opacity", opacity)
      .style("visibility", visibility);
    c.append("span")
      .html("Main Reasons of Migration");

    var margin = 18,
      chartRect = c.node().getBoundingClientRect(),
      startAngleIn = -90 * (pi/180),
      endAngleIn = 90 * (pi/180),
      startAngleOut = 90 * (pi/180),
      endAngleOut = 270 * (pi/180),
      cornerRadius = 3,
      padAngle = 0.02;

    chartWidth = chartRect.width;
    chartHeight = chartRect.height - margin;
    visSpacing = 28;
    baseR = 70;
    chartRMax = Math.min((chartWidth / 2) - (visSpacing / 2) - margin, (chartHeight / 2) - (visSpacing / 2) - margin);

    chart = c.append("svg")
      .attr("id", "svgGraph")
      .attr("width", chartWidth)
      .attr("height", chartHeight);

    legendInArc = d3.arc()
      .innerRadius(chartRMax+17)
      .outerRadius(chartRMax+38)
      .startAngle(-67 * (pi/180))
      .endAngle(-47 * (pi/180))
      .cornerRadius(cornerRadius)
      .padAngle(padAngle);
    legendOutArc = d3.arc()
      .innerRadius(chartRMax+17)
      .outerRadius(chartRMax+38)
      .startAngle(113 * (pi/180))
      .endAngle(133 * (pi/180))
      .cornerRadius(cornerRadius)
      .padAngle(padAngle);

    arrowOutArc = d3.arc()
      .innerRadius(chartRMax+5)
      .outerRadius(chartRMax+5)
      .startAngle(startAngleOut)
      .endAngle(endAngleOut)
      .cornerRadius(cornerRadius)
      .padAngle(padAngle);
    arrowInArc = d3.arc()
      .innerRadius(chartRMax+5)
      .outerRadius(chartRMax+5)
      .startAngle(startAngleIn)
      .endAngle(endAngleIn)
      .cornerRadius(cornerRadius)
      .padAngle(padAngle);

    //Pie In Generator
    pieIn = d3.pie()
      .value(function(d) { return d.in; })
      .sort(null)
      .startAngle(startAngleIn)
      .endAngle(endAngleIn);
    //Pie Out Generator
    pieOut = d3.pie()
      .value(function(d) { return d.out; })
      .sort(null)
      .startAngle(startAngleOut)
      .endAngle(endAngleOut);

    //Arc In Generator
    arcIn = d3.arc()
      .outerRadius(chartRMax)
      .innerRadius(baseR)
      .cornerRadius(cornerRadius)
      .padAngle(padAngle);
    //Arc Out Generator
    arcOut = d3.arc()
      .outerRadius(chartRMax)
      .innerRadius(baseR)
      .cornerRadius(cornerRadius)
      .padAngle(padAngle);

    chart.append("g").attr("class", "slicesIn");
    chart.append("g").attr("class", "slicesOut");

    var arrowIn = chart.append("g");
    arrowIn.append("path")
      .attr("d", arrowInArc)
      .attr("transform",'translate(' + ((chartWidth / 2)) + ',' + ((chartHeight / 2) - (visSpacing / 2)) + ')')
      .attr("stroke","hsl(355, 80%, 50%)")
      .attr("fill","none")
      .attr("stroke-width","2");
    
    arrowIn.append("path")
      .attr("d", d3.symbol().type(d3.symbolTriangle).size([24]))
      .attr("transform", "translate(" + ((chartWidth / 2) - arrowInArc.outerRadius()(arrowInArc) ) + ", " + ((chartHeight / 2) - (visSpacing / 2)) + ") rotate(183)" )
      .style("fill","hsl(355, 80%, 50%)");
    
    // arrow out
    var arrowOut = chart.append("g");
    arrowOut.append("path")
      .attr("d", arrowOutArc)
      .attr("transform",'translate(' + ((chartWidth / 2)) + ',' + ((chartHeight / 2) + (visSpacing / 2)) + ')')
      .attr("stroke","hsl(215, 80%, 50%)")
      .attr("fill","none")
      .attr("stroke-width","2");
    
    arrowOut.append("path")
      .attr("d", d3.symbol().type(d3.symbolTriangle).size([24]))
      .attr("transform", "translate(" + ((chartWidth / 2) + arrowOutArc.outerRadius()(arrowOutArc)) + ", " + ((chartHeight / 2) + (visSpacing / 2)) + ") rotate(3)" )
      .style("fill","hsl(215, 80%, 50%)");

    var chartLegend = chart.append("g");
    var widthArrowIn = chartLegend.append("g").attr("class", "widthArrowIn");
    widthArrowIn.append("path")
      .attr("d", d3.line()([[(chartWidth/2) - arrowOutArc.outerRadius()(arrowOutArc) - 15, (chartHeight/2)-(visSpacing / 2)],[(chartWidth/2)-arrowOutArc.outerRadius()(arrowOutArc) - 30,(chartHeight/2)-(visSpacing / 2)]]))
      //.attr("transform", "translate(" + ((chartWidth / 2)) + "," + ((chartHeight / 2)) + ")")  
      .attr("stroke","hsl(0, 0%, 75%)")
      .attr("fill","none")
      .attr("stroke-width","1");

    widthArrowIn.append("path")
      .attr("d", d3.symbol().type(d3.symbolTriangle).size([16]))
      .attr("transform", "translate(" + ((chartWidth / 2) - arrowOutArc.outerRadius()(arrowOutArc) - 30) + ", " + ((chartHeight / 2)-(visSpacing / 2)) + ") rotate(-90)" )
      .attr("fill","hsl(0, 0%, 75%)");

    widthArrowIn.append("path")
      .attr("d", d3.symbol().type(d3.symbolTriangle).size([16]))
      .attr("transform", "translate(" + ((chartWidth / 2) - arrowOutArc.outerRadius()(arrowOutArc) - 15) + ", " + ((chartHeight / 2)-(visSpacing / 2)) + ") rotate(90)" )
      .attr("fill","hsl(0, 0%, 75%)");

    widthArrowIn.attr("transform", "rotate(45,"+(chartWidth / 2)+","+((chartHeight / 2)-(visSpacing / 2))+")")

    var legendValueIn = chartLegend.append("g").append("text")
      .attr("id", "chartLegendTextIn")
      .attr("transform", "translate(" + ((chartWidth/2) - baseR-26) + "," + ((chartHeight / 2)-arrowOutArc.outerRadius()(arrowOutArc)+2) + ") rotate(-35)")
      .attr("text-anchor", "start")
      .attr("alignment-baseline", "middle")
      .attr("fill","hsl(0, 0%, 60%)")
      .text("");

    var legendIn = chartLegend.append("g");
    legendIn.append("path")
      .attr("d", legendInArc)
      .attr("transform",'translate(' + ((chartWidth / 2)) + ',' + ((chartHeight / 2)-(visSpacing / 2)) + ')')
      .attr("stroke","none")
      .attr("fill","hsl(0, 0%, 75%)");

    var widthArrowOut = chartLegend.append("g").attr("class", "widthArrowOut");    

    widthArrowOut.append("path")
      .attr("d", d3.line()([[(chartWidth/2) + arrowOutArc.outerRadius()(arrowOutArc) + 15, (chartHeight/2)+(visSpacing / 2)],[(chartWidth/2)+arrowOutArc.outerRadius()(arrowOutArc) + 30,(chartHeight/2)+(visSpacing / 2)]]))
      //.attr("transform", "translate(" + ((chartWidth / 2)) + "," + ((chartHeight / 2)) + ")")  
      .attr("stroke","hsl(0, 0%, 75%)")
      .attr("fill","none")
      .attr("stroke-width","1");

    widthArrowOut.append("path")
     .attr("d", d3.symbol().type(d3.symbolTriangle).size([16]))
     .attr("transform", "translate(" + ((chartWidth / 2) + arrowOutArc.outerRadius()(arrowOutArc) + 30) + ", " + ((chartHeight / 2)+(visSpacing / 2)) + ") rotate(90)" )
     .attr("fill","hsl(0, 0%, 75%)");

    widthArrowOut.append("path")
     .attr("d", d3.symbol().type(d3.symbolTriangle).size([16]))
     .attr("transform", "translate(" + ((chartWidth / 2) + arrowOutArc.outerRadius()(arrowOutArc) + 15) + ", " + ((chartHeight / 2)+(visSpacing / 2)) + ") rotate(-90)" )
     .attr("fill","hsl(0, 0%, 75%)");

    widthArrowOut.attr("transform", "rotate(45,"+(chartWidth / 2)+","+((chartHeight / 2)+(visSpacing / 2))+")")

    var legendValueOut = chartLegend.append("g").append("text")
      .attr("id", "chartLegendTextOut")
      .attr("transform", "translate(" + ((chartWidth/2) + baseR+27) + "," + ((chartHeight / 2)+arrowOutArc.outerRadius()(arrowOutArc)) + ") rotate(-35)")
      .attr("text-anchor", "end")
      .attr("alignment-baseline", "middle")
      .attr("fill","hsl(0, 0%, 60%)")
      .text("");

    var legendOut = chartLegend.append("g");
    legendOut.append("path")
      .attr("d", legendOutArc)
      .attr("transform",'translate(' + ((chartWidth / 2)) + ',' + ((chartHeight / 2)+(visSpacing / 2)) + ')')
      .attr("stroke","none")
      .attr("fill","hsl(0, 0%, 75%)");

    var guideLines = chart.append("g").attr("class", "guideLines");

    var tickPositions = [0, -45, -90, -135, -180];
    for (var t=0; t<tickPositions.length; t++) {
        guideLines.append("path")
          .attr("d", d3.line()([[(chartWidth/2)+baseR-8, (chartHeight/2)-(visSpacing / 2)],[(chartWidth/2)+baseR-2,(chartHeight/2)-(visSpacing / 2)]]))
          .attr("transform", "rotate(" + tickPositions[t]+ ","+(chartWidth / 2)+","+((chartHeight / 2)-(visSpacing / 2))+")")
          .attr("stroke","hsl(0, 0%, 60%)")
          .attr("fill","none")
          .attr("stroke-width","0.5");
    }

    var tickPositions = [0, 45, 90, 135, 180];
    for (var t=0; t<tickPositions.length; t++) {
        guideLines.append("path")
          .attr("d", d3.line()([[(chartWidth/2)+baseR-8, (chartHeight/2)+(visSpacing / 2)],[(chartWidth/2)+baseR-2,(chartHeight/2)+(visSpacing / 2)]]))
          .attr("transform", "rotate(" + tickPositions[t]+ ","+(chartWidth / 2)+","+((chartHeight / 2)+(visSpacing / 2))+")")
          .attr("stroke","hsl(0, 0%, 60%)")
          .attr("fill","none")
          .attr("stroke-width","0.5");
    }

    chart.append("text")
      .attr("transform", "translate(" + ((chartWidth / 2) - chartRMax) + "," + ((chartHeight / 2)) + ")")        
      .attr("text-anchor", "middle")
      .attr("alignment-baseline", "middle")
      .text("United Kingdom");

    chart.append("text")
      .attr("id", "countryOriginLabel")
      .attr("transform", "translate(" + ((chartWidth / 2) + chartRMax) + "," + ((chartHeight / 2)) + ")")        
      .attr("text-anchor", "middle")
      .attr("alignment-baseline", "middle")
      .text("EU 27");

    chart.append("text")
      .attr("id", "chartYearLabel")
      .attr("transform", "translate(" + ((chartWidth / 2)) + "," + ((chartHeight / 2)) + ")")        
      .attr("text-anchor", "middle")
      .attr("alignment-baseline", "middle")
      .text("2000 - 2016");

    var txt = chart.append("text")
      .attr("transform", "translate(" + ((chartWidth / 2)) + "," + ((chartHeight / 2) - 45) + ")")        
      .attr("text-anchor", "middle")
      .attr("alignment-baseline", "middle")
      .attr("id", "txtLegendJob")
      .style("font-weight", "normal")
      .text("definite job");
    highlightSvgTextReason(chart, txt.node(), "reasonsLegend", colours['job']['in']);
    chart.append("use")
      .attr("xlink:href", "#txtLegendJob")

    txt = chart.append("text")
      .attr("transform", "translate(" + ((chartWidth / 2)) + "," + ((chartHeight / 2) - 25) + ")")        
      .attr("text-anchor", "middle")
      .attr("alignment-baseline", "middle")
      .attr("id", "txtLegendLooking")
      .style("font-weight", "normal")
      .text("looking for work");
    highlightSvgTextReason(chart, txt.node(), "reasonsLegend", colours['looking']['in']);
    chart.append("use")
      .attr("xlink:href", "#txtLegendLooking")

    txt = chart.append("text")
      .attr("transform", "translate(" + ((chartWidth / 2)) + "," + ((chartHeight / 2) + 25) + ")")        
      .attr("text-anchor", "middle")
      .attr("alignment-baseline", "middle")
      .attr("id", "txtLegendStudy")
      .style("font-weight", "normal")
      .text("studying");
    highlightSvgTextReason(chart, txt.node(), "reasonsLegend", colours['study']['in']);
    chart.append("use")
      .attr("xlink:href", "#txtLegendStudy");

    txt = chart.append("text")
      .attr("transform", "translate(" + ((chartWidth / 2)) + "," + ((chartHeight / 2) + 45) + ")")        
      .attr("text-anchor", "middle")
      .attr("alignment-baseline", "middle")
      .attr("id", "txtLegendJoin")
      .style("font-weight", "normal")
      .text("joining someone");
    highlightSvgTextReason(chart, txt.node(), "reasonsLegend", colours['join']['in']);
    chart.append("use")
      .attr("xlink:href", "#txtLegendJoin");

  }//END createChart

  function createHowToButton(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;
    vis.append("button")
      .attr("id", "toggleHowTo")
      .html("Hide hints")
      .style("opacity", opacity)
      .style("visibility", visibility)
      .on("click", toggleHowToEvent);
  }//END setupHowToButton

  function createHintsCondition1(visibility, timeFadeOut) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;
    isHintsCondition1Active = (visibility === "visible") ? true : false;
    hintsCondition1 = vis.append("svg")
      .attr("id", "hintsCondition1")
      .attr("x", 0)
      .attr("y", 0)
      .attr("width", "100%")
      .attr("height", "100%")
      .style("opacity", opacity)
      .style("visibility", visibility);

    hintsCondition1.append("image")
      .attr("xlink:href", curvedArrowUrl)
      .attr("width", 20)
      .attr("height", 20)
      .attr("transform", "translate(25 100) rotate(-70)");
    var txt = hintsCondition1.append("text")
      .attr("transform", "translate(55 110) rotate(-2)")
      .text("click to show or hide hints")
    highlightSvgTextNoFadeOut(hintsCondition1, txt.node(), "hint1", "yellow")

    hintsCondition1.append("image")
      .attr("xlink:href", curvedArrowUrl)
      .attr("width", 20)
      .attr("height", 20)
      .attr("transform", "scale(-1 1) translate(-15 585) rotate(120)");
    txt = hintsCondition1.append("text")
      .attr("id", "hintToggleMode")
      .attr("transform", "translate(40 580) rotate(-2)")
      .text("click to investigate by years or combine all years")
    highlightSvgTextNoFadeOut(hintsCondition1, txt.node(), "hint1", "yellow")

    hintsCondition1.append("image")
      .attr("xlink:href", curvedArrowUrl)
      .attr("width", 20)
      .attr("height", 20)
      .attr("transform", "scale(-1 1) translate(-140 215) rotate(180)");
    txt = hintsCondition1.append("text")
      .attr("id", "hintToggleMode")
      .attr("transform", "translate(10 185) rotate(-2)")
      .text("mouseover countries or flow lines");
    highlightSvgTextNoFadeOut(hintsCondition1, txt.node(), "hint1", "yellow")

    hintsCondition1.append("image")
      .attr("xlink:href", curvedArrowUrl)
      .attr("width", 20)
      .attr("height", 20)
      .attr("transform", "scale(-1 1) translate(-575 375) rotate(-20)");
    txt = hintsCondition1.append("text")
      .attr("id", "hintToggleMode")
      .attr("transform", "translate(520 420) rotate(-2)")
      .text("click on countries or flow lines");
    highlightSvgTextNoFadeOut(hintsCondition1, txt.node(), "hint1", "yellow")

    hintsCondition1.append("image")
      .attr("xlink:href", curvedArrowUrl)
      .attr("width", 20)
      .attr("height", 20)
      .attr("transform", "scale(-1 1) translate(-855 605) rotate(90)");
    txt = hintsCondition1.append("text")
      .attr("transform", "translate(885 610) rotate(-2)")
      .text("time remaining")
    highlightSvgTextNoFadeOut(hintsCondition1, txt.node(), "hint1", "yellow")

    if(!(timeFadeOut === undefined) && (!isNaN(timeFadeOut))) {
      //fade out after time
      //fadeElementToOpacity({selector: "#hintsCondition1", delay: time, duration: 500, opacity: 0})
      hintsCondition1
        .transition()
        .delay(timeFadeOut)
        .duration(500)
        .style("opacity", 0)
        .on("end", function(e){
          hintsCondition1.style("visibility", "hidden");
          isHintsCondition1Active = false;
          d3.select("#toggleHowTo").html("Show hints");
        });
    }
  }

  function createHintsCondition2(){
    hintsCondition2 = vis.append("svg")
      .attr("id", "hintsCondition2")
      .attr("x", 0)
      .attr("y", 0)
      .attr("width", "100%")
      .attr("height", "100%");

    hintsCondition2.append("image")
      .attr("xlink:href", curvedArrowUrl)
      .attr("class", "hint2")
      .attr("width", 20)
      .attr("height", 20)
      .attr("transform", "scale(-1 1) translate(-855 605) rotate(90)");
    var txt = hintsCondition2.append("text")
      .attr("transform", "translate(885 610) rotate(-2)")
      .attr("class", "hint2")
      .text("time remaining")
    highlightSvgTextNoFadeOut(hintsCondition2, txt.node(), "hint2", "purple")
    fadeElementToOpacity({selector: ".hint2", delay: 20000, duration: 500, opacity: 0});

    hintsCondition2.append("image")
      .attr("xlink:href", curvedArrowUrl)
      .attr("class", "hint2b")
      .attr("width", 20)
      .attr("height", 20)
      .attr("transform", "translate(600 290) rotate(-95)");
    txt = hintsCondition2.append("text")
      .attr("transform", "translate(630 290) rotate(-2)")
      .attr("class", "hint2b")
      .text("Use the arrow buttons to explore more.")
    highlightSvgTextNoFadeOut(hintsCondition2, txt.node(), "hint2b", "purple");
    
    txt = hintsCondition2.append("text")
      .attr("transform", "translate(635 320) rotate(-2)")
      .attr("class", "hint2b")
      .text("Read the texts and answer the questions.")
    highlightSvgTextNoFadeOut(hintsCondition2, txt.node(), "hint2b", "purple");

    txt = hintsCondition2.append("text")
      .attr("transform", "translate(640 350) rotate(-2)")
      .attr("class", "hint2b")
      .text("A progress bar will show you how far you are.")
    highlightSvgTextNoFadeOut(hintsCondition2, txt.node(), "hint2b", "purple");
    
  }

  function createHintsCondition3() {
    
    hintsCondition3 = vis.append("svg")
      .attr("id", "hintsCondition3")
      .attr("x", 0)
      .attr("y", 0)
      .attr("width", "100%")
      .attr("height", "100%");

    hintsCondition3.append("image")
      .attr("xlink:href", curvedArrowUrl)
      .attr("class", "hint3")
      .attr("width", 20)
      .attr("height", 20)
      .attr("transform", "scale(-1 1) translate(-855 605) rotate(90)");
    var txt = hintsCondition3.append("text")
      .attr("transform", "translate(885 610) rotate(-2)")
      .attr("class", "hint3")
      .text("time remaining")
    highlightSvgTextNoFadeOut(hintsCondition3, txt.node(), "hint3", "purple")
    fadeElementToOpacity({selector: ".hint3", delay: 40000, duration: 500, opacity: 0});


    hintsCondition3.append("image")
      .attr("xlink:href", curvedArrowUrl)
      .attr("class", "hint3b")
      .attr("width", 20)
      .attr("height", 20)
      .attr("transform", "scale(-1 1) translate(-735 190) rotate(-85)");
    txt = hintsCondition3.append("text")
      .attr("transform", "translate(525 200) rotate(-2)")
      .attr("class", "hint3b")
      .text("Select one story at a time")
    highlightSvgTextNoFadeOut(hintsCondition3, txt.node(), "hint3b", "purple");
    txt = hintsCondition3.append("text")
      .attr("transform", "translate(570 230) rotate(-2)")
      .attr("class", "hint3b")
      .text("and see what each of us has to tell you.")
    highlightSvgTextNoFadeOut(hintsCondition3, txt.node(), "hint3b", "purple");    
    txt = hintsCondition3.append("text")
      .attr("transform", "translate(620 260) rotate(-2)")
      .attr("class", "hint3b")
      .text("Read the texts and follow the animation carefully.")
    highlightSvgTextNoFadeOut(hintsCondition3, txt.node(), "hint3b", "purple");    

  }

  function createJourneySelection() {
    var jS = vis.append("div")
      .attr("id", "journeySelection");

    var storyOrder = ["cecile", "klaus", "jakub", "alejandro", "francesca", "ileana"]
    for(let s = 0; s < storyOrder.length; s++) {
      var j = jS.append("div")
        .data([storyOrder[s]])
        .attr("class", "storyButton")
        .attr("id", "storyButton-"+storyOrder[s])
        .on("click", function(d){storyButtonClickEvent(d);})
        .on("mousemove", function(d){storyButtonMousemoveEvent(d);})
        .on("mouseout", function(d){storyButtonMouseoutEvent(d);});
      
      j.append("svg")
        .attr("width", storyScript[storyOrder[s]].selectIcon.w)
        .attr("height", storyScript[storyOrder[s]].selectIcon.h)
        .attr("viewBox", "0 0 " + storyScript[storyOrder[s]].selectIcon.w + " " + storyScript[storyOrder[s]].selectIcon.h)
        .append("image")
          .attr("id", "select-image-"+storyOrder[s])
          //.attr("viewBox", "0 0 10 10")
          //.attr("xlink:href", selectionIconUrls[storyOrder[s]])
          .attr("href", selectionIconUrls[storyOrder[s]])
          .attr("xlink:href", selectionIconUrls[storyOrder[s]])
          .attr("height", storyScript[storyOrder[s]].selectIcon.h)
          .attr("width", storyScript[storyOrder[s]].selectIcon.w);

      j.append("p").html(storyScript[storyOrder[s]].displayName);

    }

  }//END createJourneySelection

  function createLegend(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;
    var l = vis.append("div")
      .attr("id", "legend")
      .style("opacity", opacity)
      .style("visibility", visibility);

    l.append("span")
      .attr("id", "flowTypeLegend")
      .attr("class", "legendHeader")
      .html("Net UK Migration Flows");
    
    l.append("svg")
      .attr("id", "svgLegend")
      .attr("width", "100%");

    l.append("span")
      .attr("id", "flowTypeLegend")
      .attr("class", "legendHeader")
      .html("EU Membership");

    var l1 = l.append("div")
      .attr("class", "legend1")

    l1.append("div")
      .attr("class", "legend1")
        .append("p")
          .attr("class", "country-name")
          .html("<span class='key-dot member'></span>Member");

    l1.append("div")
      .attr("class", "legend1")
        .append("p")
          .attr("class", "country-name")
          .html("<span class='key-dot candidate'></span>Candidate");

    l1.append("div")
      .attr("class", "legend1")
        .append("p")
          .attr("class", "country-name")
          .html("<span class='key-dot noneu'></span>Non EU");
  }//END createLegend

  function createProgressBar() {
    progressBar = vis.append("div")
      .attr("id", "progressBar");
  }//END createProgressBar

  function createSlider(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;

    vis.append("div")
      .attr("id", "slider")
      .style("opacity", opacity)
      .style("visibility", visibility);
    
    slider = document.getElementById("slider");

    noUiSlider.create(slider, {
      start: minYear,
      step: 1,
      tooltips: true,
      format: {
        to: function ( value ) {
          return value;
        },
        from: function ( value ) {
          return value;
        }
      },
      range: {
        'min': minYear,
        'max': maxYear
      }
    }); //END noUiSlider.create

    slider.style.opacity = "0.3";
    slider.setAttribute('disabled', true);
  }//END setupSlider

  function createStoryNavigation(){
    var sN = storyTextC2.append("div")
      .attr("id", "storyNavigation");

    sN.append("div")
      .attr("id", "navigateUp")
      .attr("class", "navButton")
      .html("<div>&#9668;</div>");



    //var html = "<div>&#9673;</div>";
    //for(var chapterCount=0; chapterCount <= maxChapter; chapterCount++){
    sN.append("div")
      .attr("id", "chapterProgress")

        //.html(html);
      //html= "<div>&#9679;</div>";
    //}

    sN.append("div")
      .attr("id", "navigateDown")
      .attr("class", "navButton")
      .html("<div>&#9658;</div>");
/*
    sN.append("div")
      .attr("id", "chapter-1")
      .attr("class", "chapter")
      .html("<div>&#9679;</div>");

    sN.append("div")
      .attr("id", "chapter-2")
      .attr("class", "chapter")
      .html("<div>&#9679;</div>");

    sN.append("div")
      .attr("id", "chapter-3")
      .attr("class", "chapter")
      .html("<div>&#9679;</div>");

    sN.append("div")
      .attr("id", "chapter-4")
      .attr("class", "chapter")
      .html("<div>&#9679;</div>");

    sN.append("div")
      .attr("id", "chapter-5")
      .attr("class", "chapter")
      .html("<div>&#9679;</div>");*/

  }//END createStoryNavigation

  function createStoryFocusMask() {
    var svgMask = vis.append("div")
      .attr("id", "storyFocusMask")
      .style("visibility", "hidden")
      .append("svg");

    var mask = svgMask
      .append("defs")
      .append("mask")
      .attr("id", "svgStoryFocusMask");

    mask.append("rect")
      .attr("x", 0)
      .attr("y", 0)
      .attr("width", "100%")
      .attr("height", "100%")
      .style("fill", "white");

    mask.append("ellipse")
      .attr("rx", 100)
      .attr("ry", 100)

    var svgRoot = svgMask
      .attr("class", "storyFocus")
      .attr("width", "100%")
      .attr("height", "100%")
      .append("g")
      .attr("transform", "translate(0,0)");

    var rect = svgRoot
      .append("rect")
      .attr("x", 0)
      .attr("y", 0)
      .attr("width", "100%")
      .attr("height", "100%")
      .attr("mask", "url(#svgStoryFocusMask)")
      .style("fill", "gray")
      .style("opacity", 0.7);
  }//END createStoryFocusMask

  function createInfoModal(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;
    var modal = vis.append("div")
      .attr("class", "infoModal")
      .style("opacity", opacity)
      .style("visibility", visibility)

    var modalContent = modal.append("div")
        .attr("class", "infoModalContent")

    modalContent.append("div")
      .attr("class", "infoModalText")
      .html("Well done!<br><br>Do not worry if you did not see everything. You have <b>3 minutes</b> now to investigate the data for all EU member states.<br><br>Click OK when you are ready to continue.");
    modalContent.append("div")
      .attr("class", "okButtonDiv")
      .append("button")
        .attr("class", "okButton")
        .html("OK")
        .on("click", function(){
          //restart timer
          logAction("V");
          timer.restart(function(elapsed){timerEvent(elapsed);});
          modal.transition().duration(800).style("opacity", 0).style("visibility", "hidden").remove();
          fadeElementToOpacity({selector: '#hintsCondition1', delay: 20000, duration: 500, opacity: 0});
          hintsCondition1Timeout = d3.timeout(function() {
            d3.select("#toggleHowTo").html("Show hints");
            isHintsCondition1Active = false;
          }, 20000);
        });
  }

  function createStoryText(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;
    storyText = vis.append("div")
      .attr("id", "storyText")
      .style("opacity", opacity)
      .style("visibility", visibility);
  }

  function createStoryTextC2(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;
    storyTextC2 = vis.append("div")
      .attr("id", "storyTextC2")
      .style("opacity", opacity)
      .style("visibility", visibility);

    storyTextC2.append("div")
        .attr("id", "storyTextC2Text");
  }

  function createTimeBar(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;
    timeBar = vis.append("div")
      .attr("id", "timeBar")
      .style("opacity", opacity)
      .style("visibility", visibility);
  }//END createTimeBar

  function createNumericTimer(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;
    numericTimer = vis.append("span")
      .attr("id", "numericTimer")
      .attr("class", "green")
      .style("opacity", opacity)
      .style("visibility", visibility)
      .text("about 5 minutes left");
  }

  function createTitle(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;
    vis.append("div")
      .attr("id", "title")
      .style("opacity", opacity)
      .style("visibility", visibility)
      .html("Migration of EU Citizens from and to the UK <span id='yearTitle'>2000 - 2016</span>");
  }//END setupTitle

  function createToggleModeButton(visibility) {
    visibility = checkFunctionParameter(visibility, ["visible", "hidden"]);
    var opacity = (visibility === "visible") ? 1 : 0;
    vis.append("button")
      .attr("id", "toggleMode")
      .html("Show by years")
      .style("opacity", opacity)
      .style("visibility", visibility)
      .on("click", toggleModeEvent);
  }//END setupToggleModeButton

  function createTooltip() {
    tooltip = vis.append("div")
      .attr("class", "tooltip")
      .style("display", "none");
  }//END createTooltip

/*** =========================================================================================== ***/
/*** SETUP ELEMENTS ***/
/*** =========================================================================================== ***/
  function setupCondition1() {
    setupFlows();
    setupSlider();
    updateChart(flowData, 0, maxYearIdx, false);
    setupLegend();
    enableMouseDownEvent(true);
    enableMapEvents(true);
  }

  function setupCondition2() {
    setupFlows("hidden");
    setupSlider();
    updateChart(flowData, 0, maxYearIdx, false);
    setupLegend();
    enableUpDownEvents(true);

    storyScript.chapters[0].forEach(function(event) {
        d3.select(event.args.selector).transition();
        window.Flowstory[event.func](event.args);
      });
  }

  function setupCondition3() {
    setupFlows("hidden");
    setupSlider();
    updateChart(flowData, 0, maxYearIdx, false);
    setupLegend();
  }

  function setupLegend(){
    var svgLegend = d3.select('#svgLegend');
    var overallLegend = svgLegend.append("g").attr("id", "legendOverallMode");
    var detailLegend = svgLegend.append("g").attr("id", "legendDetailMode").style("visibility", "hidden");

    //DETAIL MODE LEGEND

    detailLegend.append("text") 
      .attr("transform", "translate(0, 16)")       
      .attr("text-anchor", "start")
      .style("font-size", "small")
      .attr("alignment-baseline", "middle")
      .style("fill", "hsl(355, 80%, 50%)")
      .text("citizens entering the UK");

    detailLegend.append("text")
      .attr("transform", "translate(0, 133)")       
      .attr("text-anchor", "start")
      .style("font-size", "small")
      .attr("alignment-baseline", "middle")
      .style("fill", "hsl(215, 80%, 50%)")
      .text("citizens leaving the UK");
    
    detailLegend.append("text")
      .attr("id", "maxLegendDetailTxt")
      .attr("transform", "translate(100, 53)")       
      .attr("text-anchor", "start")
      .style("font-size", "small")
      .attr("alignment-baseline", "middle")
      .text(format1SI(aggregatedMax)+" or more");

    detailLegend.append("text")
      .attr("id", "midLegendDetailTxt")
      .attr("transform", "translate(100, 95)")       
      .attr("text-anchor", "start")
      .style("font-size", "small")
      .attr("alignment-baseline", "middle")
      .text(format2SI(Math.abs(aggregatedMax - aggregatedMin)/2));

    detailLegend.append("text")
      .attr("id", "minLegendDetailTxt")
      .attr("transform", "translate(100, 116)")       
      .attr("text-anchor", "start")
      .style("font-size", "small")
      .attr("alignment-baseline", "middle")
      .text(format1SI(aggregatedMin)+" or less");

    var y = 30;
    var h = (((maxWidth - minWidth) * (Math.abs(aggregatedMax) - min)) / (max - min)) + minWidth;
    detailLegend.append("rect")
      .attr("id", "detailLegendMaxRectIn")
      .attr("x", 0)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill", "hsl(355, 80%, 50%)");
    detailLegend.append("rect")
      .attr("id", "detailLegendMaxRectOut")
      .attr("x", 45)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill", "hsl(215, 80%, 50%)");

    y += h + 10;
    h = (((maxWidth - minWidth) * ((Math.abs(aggregatedMax - aggregatedMin)/2) - min)) / (max - min)) + minWidth;
    detailLegend.append("rect")
      .attr("id", "detailLegendMidRectIn")
      .attr("x", 0)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill", "hsl(355, 80%, 50%)");
    detailLegend.append("rect")
      .attr("id", "detailLegendMidRectOut")
      .attr("x", 45)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill", "hsl(215, 80%, 50%)");

    y += h + 10;
    h = (((maxWidth - minWidth) * (Math.abs(aggregatedMin) - min)) / (max - min)) + minWidth;

    detailLegend.append("rect")
      .attr("id", "detailLegendMinRectIn")
      .attr("x", 0)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill", "hsl(355, 80%, 50%)"); //215 blue
    detailLegend.append("rect")
      .attr("id", "detailLegendMinRectOut")
      .attr("x", 45)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill", "hsl(215, 80%, 50%)");

    //OVERALL MODE LEGEND
    overallLegend.append("text")
      .attr("transform", "translate(0, 16)")    
      //.attr("transform", "translate(20, 70) rotate(-45)")       
      .attr("text-anchor", "start")
      .style("font-size", "small")
      .style("fill", "hsl(355, 80%, 50%)")
      .attr("alignment-baseline", "middle")
      .text("more citizens entering than leaving")
      //.text("inflow > outflow");

    overallLegend.append("text")
      .attr("transform", "translate(0, 115)")  
      //.attr("transform", "translate(65, 70) rotate(-45)")       
      .attr("text-anchor", "start")
      .style("font-size", "small")
      .style("fill", "hsl(215, 80%, 50%)")
      .attr("alignment-baseline", "middle")
      .text("more citizens leaving than entering")
      //.text("inflow < outflow");

    overallLegend.append("text")
      .attr("id", "maxLegendOverallTxt")
      .attr("transform", "translate(100, 47)")       
      .attr("text-anchor", "start")
      .style("font-size", "small")
      .attr("alignment-baseline", "middle")
      .text(format1SI(max)+" or more");

    overallLegend.append("text")
      .attr("id", "midLegendOverallTxt")
      .attr("transform", "translate(100, 79)")       
      .attr("text-anchor", "start")
      .style("font-size", "small")
      .attr("alignment-baseline", "middle")
      .text(format2SI((max-min)/2));

    overallLegend.append("text")
      .attr("id", "minLegendOverallTxt")
      .attr("transform", "translate(100, 96)")       
      .attr("text-anchor", "start")
      .style("font-size", "small")
      .attr("alignment-baseline", "middle")
      .text(format1SI(min)+" or less");

    overallLegend.append("text")
      .attr("transform", "translate(100, 137)")       
      .attr("text-anchor", "start")
      .style("font-size", "small")
      .attr("alignment-baseline", "middle")
      .text("inflow = outflow");

    var y = 30;
    var h = maxWidth;
    overallLegend.append("rect")
      .attr("x", 0)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill-opacity", 0.6)
      .style("fill", "hsl(355, 80%, 50%)");
    overallLegend.append("rect")
      .attr("x", 45)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill-opacity", 0.6)
      .style("fill", "hsl(215, 80%, 50%)");

    y += h + 10;
    h = (maxWidth-minWidth)/2;
    overallLegend.append("rect")
      .attr("x", 0)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill-opacity", 0.6)
      .style("fill", "hsl(355, 80%, 50%)");
    overallLegend.append("rect")
      .attr("x", 45)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill-opacity", 0.6)
      .style("fill", "hsl(215, 80%, 50%)");

    y += h + 10;
    h = minWidth;
    overallLegend.append("rect")
      .attr("x", 0)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill-opacity", 0.6)
      .style("fill", "hsl(355, 80%, 50%)");
    overallLegend.append("rect")
      .attr("x", 45)
      .attr("y", y)
      .attr("width", 45)
      .attr("height", h)
      .style("fill-opacity", 0.6)
      .style("fill", "hsl(215, 80%, 50%)");

    overallLegend.append("rect")
      .attr("x", 0)
      .attr("y", 136)
      .attr("width", 90)
      .attr("height", minWidth)
      .style("fill-opacity", 0.6)
      .style("fill", "hsl(55, 90%, 45%)");
  }//END setupLegend

  function setupSlider() {
    slider.noUiSlider.on('update', function( values, handle ) { updateSlider(values, handle); }); //slider Update
  }//END setupSlider

/*** =========================================================================================== ***/
/*** UPDATE DOM ELEMENTS (DATA, VISUAL APPEARANCE) ***/
/*** =========================================================================================== ***/

  function updateChart(countries, y1, y2, animateSlices) {
    var data = getMrom(countries, y1, y2);

    var mromAll = getMromAll(countries, y1, y2);
    //console.log(mromAll);
    var mx = Math.max(mromAll.in, mromAll.out)
    //var mn = Math.min(mromAll.in, mromAll.out)
    //console.log(mx, mn)

    //update arc radii
    var rIn = (((chartRMax - baseR) * (mromAll.in)) / (mx)) + baseR;
    var rOut = (((chartRMax - baseR) * (mromAll.out)) / (mx)) + baseR;
    arcIn.outerRadius(rIn);
    arcOut.outerRadius(rOut);

    var sliceIn = chart.select(".slicesIn").selectAll("path.slice")
        .data(pieIn(data), function(d){ return d.data.mrom })
        .attr("transform", "translate(" + (chartWidth/2) + "," + ((chartHeight / 2) - (visSpacing / 2)) + ")");

    sliceIn.enter()
        .insert("path")
        .style("fill", function(d) { return colours[d.data.mrom]["in"]; })
        .attr("class", "slice")
        .attr("transform", "translate(" + (chartWidth/2) + "," + ((chartHeight / 2) - (visSpacing / 2)) + ")")
        .attr("d", arcIn);

    if (animateSlices) {
      sliceIn
          .transition().duration(200)
          .attrTween("d", function(d) {
              this._current = this._current || d;
              var interpolate = d3.interpolate(this._current, d);
              this._current = interpolate(0);
              return function(t) {
                  return arcIn(interpolate(t));
              };
          })
    } else {
      sliceIn.attr("d", arcIn);
    }

    sliceIn.exit().remove();

      var sliceOut = chart.select(".slicesOut").selectAll("path.slice")
        .data(pieOut(data), function(d){ return d.data.mrom })
        .attr("transform", "translate(" + (chartWidth/2) + "," + ((chartHeight / 2) + (visSpacing / 2)) + ")");

    sliceOut.enter()
        .insert("path")
        .style("fill", function(d) { return colours[d.data.mrom]["in"]; })
        .attr("class", "slice")
        .attr("transform", "translate(" + (chartWidth/2) + "," + ((chartHeight / 2) + (visSpacing / 2)) + ")")
        .attr("d", arcOut);

    if (animateSlices) {
      sliceOut
          .transition().duration(200)
          .attrTween("d", function(d) {
              this._current = this._current || d;
              var interpolate = d3.interpolate(this._current, d);
              this._current = interpolate(0);
              return function(t) {
                  return arcOut(interpolate(t));
              };
          })
    } else {
      sliceOut.attr("d", arcOut);
    }

    sliceOut.exit().remove();


    //var txt = undefined;
    var txtCountryOrigin = chart.select("#countryOriginLabel");
    var txtOld = undefined;

    if (txtCountryOrigin.node()) {
      txtOld = txtCountryOrigin.text();
    }

    if (countries.length > 1) {
      txtCountryOrigin.text("EU 27");
    } else {
      txtCountryOrigin.text(countries[0].c);
    }


    if (txtCountryOrigin.node() && (txtOld != txtCountryOrigin.text())) {
      //console.log(txtOld, txtCountryOrigin.text());
      highlightSvgText(chart, txtCountryOrigin.node(), "txtCountryOrigin");
    }

    var txtYear = chart.select("#chartYearLabel");
    var txtYearOld = undefined;

    if (txtYear.node()) {
      txtYearOld = txtYear.text();
    }

    if (y1 == y2) {
      txtYear.text(currentYear);
    } else {
      txtYear.text(minYear + " - " + maxYear);
    }

    if (txtYear.node() && (txtYearOld != txtYear.text())) {
      //console.log(txtYearOld, txtYear.text());
      highlightSvgText(chart, txtYear.node(), "txtYear");
    }

    var txtLegendValIn = d3.select("#chartLegendTextIn");
    var txtLegendValInOld = undefined;

    if (txtLegendValIn.node()){
      txtLegendValInOld = txtLegendValIn.text();
      txtLegendValIn.text(format2SI(mromAll.in));
      if (txtLegendValInOld != txtLegendValIn.text()) {
        highlightSvgText(chart, txtLegendValIn.node(), "txtLegendValIn");
      }
      
    }

    var txtLegendValOut = d3.select("#chartLegendTextOut");
    var txtLegendValOutOld = undefined;

    if (txtLegendValOut.node()){
      txtLegendValOutOld = txtLegendValOut.text();
      txtLegendValOut.text(format2SI(mromAll.out));
      if (txtLegendValOutOld != txtLegendValOut.text()) {
        highlightSvgText(chart, txtLegendValOut.node(), "txtLegendValOut");
      }
    }

  }//END updateChart

  function updateLegend() {
    var cxtOM = d3.select("#legendOverallMode");
    var cxtDM = d3.select("#legendDetailMode");
    if (detailMode) {
      cxtOM.style("visibility", "hidden");
      cxtDM.style("visibility", "visible");
      d3.select("#flowTypeLegend").text("IN and OUT Flows " + (aggregateMode ? minYear + " - " + maxYear : currentYear));

      var maxLT = d3.select("#maxLegendDetailTxt");
      var maxLTOld = maxLT.text();
      maxLT.text(format1SI((aggregateMode ? aggregatedMax : globalMax))+" or more");

      var midLT = d3.select("#midLegendDetailTxt");
      var midLTOld = midLT.text();
      midLT.text(format2SI((aggregateMode ? (aggregatedMax - aggregatedMin)/2 : (globalMax - globalMin)/2 )));

      var minLT = d3.select("#minLegendDetailTxt");
      var minLTOld = minLT.text();
      minLT.text(format1SI((aggregateMode ? aggregatedMin : globalMin))+" or less");

      if (maxLTOld != maxLT.text()){
        highlightSvgText(cxtDM, maxLT.node(), "maxLT");
      }
      if (midLTOld != midLT.text()){
        highlightSvgText(cxtDM, midLT.node(), "midLT");
      }
      if (minLTOld != minLT.text()){
        highlightSvgText(cxtDM, minLT.node(), "minLT");
      }

      var y = (aggregateMode ? 30 : 33);
      var h = (((maxWidth - minWidth) * (Math.abs((aggregateMode ? aggregatedMax : globalMax)) - min)) / (max - min)) + minWidth;
      d3.selectAll("#detailLegendMaxRectIn, #detailLegendMaxRectOut")
        .attr("y", y)
        .attr("height", h);

      y += h + (aggregateMode ? 10 : 16);
      h = (((maxWidth - minWidth) * (Math.abs((aggregateMode ? (aggregatedMax - aggregatedMin)/2 : (globalMax - globalMin)/2 )) - min)) / (max - min)) + minWidth;
      d3.selectAll("#detailLegendMidRectIn, #detailLegendMidRectOut")
        .attr("y", y)
        .attr("height", h);

      y += h + (aggregateMode ? 10 : 13);
      h = (((maxWidth - minWidth) * (Math.abs((aggregateMode ? aggregatedMin : globalMin)) - min)) / (max - min)) + minWidth;
      d3.selectAll("#detailLegendMinRectIn, #detailLegendMinRectOut")
        .attr("y", y)
        .attr("height", h);

    } else {
      cxtDM.style("visibility", "hidden");
      cxtOM.style("visibility", "visible");
      d3.select("#flowTypeLegend").html("Net UK Migration Flows");

      var maxLT = d3.select("#maxLegendOverallTxt");
      var maxLTOld = maxLT.text();
      maxLT.text(format1SI(max)+" or more");

      var midLT = d3.select("#midLegendOverallTxt");
      var midLTOld = midLT.text();
      midLT.text(format2SI((max-min)/2));

      var minLT = d3.select("#minLegendOverallTxt");
      var minLTOld = minLT.text();
      minLT.text(format1SI(min)+" or less");

      if (maxLTOld != maxLT.text()){
        highlightSvgText(cxtOM, maxLT.node(), "maxLT");
      }
      if (midLTOld != midLT.text()){
        highlightSvgText(cxtOM, midLT.node(), "midLT");
      }
      if (minLTOld != minLT.text()){
        highlightSvgText(cxtOM, minLT.node(), "minLT");
      }
      
    }
  }//END updateLegend

  function updateProgressBar() {
    var h = 650 * scrollPos / maxScroll;
    progressBar.style("height", h+"px");
  }//END updateProgressBar

  function updateSlider(values, handle) {
    year = Number(String(values[0]).substr(2));
    currentYear = Number(values[0]);
    logAction("D"+year);
    updateTitle();
    updateBackgroundMap();
    updateFlows();

    if (detailMode) {
      updateInOutFlow();
      updateChart([detailCountry], year, year, true);
      updateLegend();
    } else {
      updateChart(flowData, year, year, true);
    }
  }//END updateSlider

  function updateStoryFocusMask(focusMask) {
    var ell = d3.select("#svgStoryFocusMask>ellipse");
    ell
      .attr("rx", focusMask.rx)
      .attr("ry", focusMask.ry)
      .attr("transform", "translate(" + focusMask.tx + "," + focusMask.ty + ") rotate(" + focusMask.r + ")");
  }// END updateStoryFocusMask

  function updateStoryText(args) {
    //possibly fade effects!
    window.setTimeout(function(){
      storyText.html(args.storyText);
    }, args.delay);
  }//END updateStoryText

  function updateStoryTextCrossFade(args) {
    var duration = args.duration/2;
    storyText
      .transition()
        .delay(args.delay)
        .duration(duration)
        .style("visibility", "visible")
        .style("opacity", 0)
        .on("end", function(){
          storyText.html(("texts" in storyScript && args.storyText in storyScript.texts) ? storyScript.texts[args.storyText] : args.storyText)
        })
      .transition()
        .duration(duration)
        .style("visibility", "visible")
        .style("opacity", 1);
  }//END updateStoryTextCrossFade

  function updateStoryTextFadeIn(args) {
    storyText
      .style("opacity", 0)
      .html(("texts" in storyScript && args.storyText in storyScript.texts) ? storyScript.texts[args.storyText] : args.storyText)
      .transition()
        .delay(args.delay)
        .duration(args.duration)
        .style("visibility", "visible")
        .style("opacity", 1);
  }//END updateStoryTextFadeIn

  function updateStoryTextAndStyleFadeIn(args) {
    storyText
      .style("opacity", 0)
      .style("top", (args.style.top != undefined) ? args.style.top : storyText.style("top"))
      .style("left", (args.style.left != undefined) ? args.style.left : storyText.style("left"))
      .style("width", (args.style.width != undefined) ? args.style.width : storyText.style("width"))
      .style("border", (args.style.border != undefined) ? args.style.border : storyText.style("border"))
      .html(("texts" in storyScript && args.storyText in storyScript.texts) ? storyScript.texts[args.storyText] : args.storyText)
      .transition()
        .delay(args.delay)
        .duration(args.duration)
        .style("visibility", "visible")
        .style("opacity", 1);
  }//END updateStoryTextFadeIn

  function updateStoryTextAndStyleCrossFade(args) {
    var duration = args.duration/2;
    storyText
      .transition()
        .delay(args.delay)
        .duration(duration)
        .style("visibility", "visible")
        .style("opacity", 0)
        .on("end", function(){
          storyText
            .style("top", (args.style.top != undefined) ? args.style.top : storyText.style("top"))
            .style("left", (args.style.left != undefined) ? args.style.left : storyText.style("left"))
            .style("width", (args.style.width != undefined) ? args.style.width : storyText.style("width"))
            .style("border", (args.style.border != undefined) ? args.style.border : storyText.style("border"))
            .html(("texts" in storyScript && args.storyText in storyScript.texts) ? storyScript.texts[args.storyText] : args.storyText)
        })
      .transition()
        .duration(duration)
        .style("visibility", "visible")
        .style("opacity", 1);
  }

  function addYearButtonsToStoryText(args){

      var btnDiv = storyTextC2.select(args.selector);

      for (var i = args.fromYearIdx; i <= args.toYearIdx; i++ ) {
        btnDiv.append("button")
          .attr("class", "yearButton")
          .html(2000+i)
          .data([i])
          .style("background-color", (i == args.startIdx) ? "#999": "#eee")
          .on("click", function(d){
            //console.log(d);
            btnDiv.selectAll("button").style("background-color", "#eee");
            d3.select(this).style("background-color", "#999");
            my.updateInOutFlowForSelectionByYears({selector: [args.cc], id:args.id, delay: 0, duration: 1000, opacity: 1, fromYearIdx: d, toYearIdx: d})
            logAction("K"+d);
          })
      } 
    
    
  }

  function updateStoryTextAndStyleCrossFadeC2(args) {
    var duration = args.duration/2;
    storyTextC2
    .style("visibility", "visible")
        .style("opacity", 1);

    d3.select("#storyTextC2Text")
      .transition()
        .delay(args.delay)
        .duration(duration)
        .style("visibility", "visible")
        .style("opacity", 0)
        .on("end", function(){
          storyTextC2
            .style("top", (args.style.top != undefined) ? args.style.top : storyTextC2.style("top"))
            .style("left", (args.style.left != undefined) ? args.style.left : storyTextC2.style("left"))
            .style("width", (args.style.width != undefined) ? args.style.width : storyTextC2.style("width"))
            //.style("border", (args.style.border != undefined) ? args.style.border : storyTextC2.style("border"))
            
            .select("#storyTextC2Text").html(("texts" in storyScript && args.storyText in storyScript.texts) ? storyScript.texts[args.storyText] : args.storyText)

          if(currentChapter === 1) {
            document.getElementById('yearInflow').value = (qVals['yearInflow'] != undefined) ? qVals['yearInflow'] : document.getElementById('yearInflow').value;
            document.getElementById('yearOutflow').value = (qVals['yearOutflow'] != undefined) ? qVals['yearOutflow'] : document.getElementById('yearOutflow').value;
            //DRAW BUTTONS!
            addYearButtonsToStoryText({fromYearIdx: 4, toYearIdx: 10, cc: "POL", id:"inOutFlowPoland", startIdx: 5, selector: "#yearSelectorPoland"})

            //document.getElementById("_1234").checked = true;
          } else if(currentChapter === 3) {
            if (qVals['roubgr'] != undefined){
              d3.select('input[value="'+ qVals['roubgr'] +'"]').node().checked = true;
            } 
          } else if(currentChapter === 5) {
            if (qVals['oldeu'] != undefined){
              d3.select('input[value="'+ qVals['oldeu'] +'"]').node().checked = true;
            } 
          } else if(currentChapter === 7) {
            if (qVals['netflows'] != undefined){
              d3.select('input[value="'+ qVals['netflows'] +'"]').node().checked = true;
            } 
          } else if(currentChapter === 2)  {
            d3.select('#aPoland').html(qVals['yearInflow'] + " and " + qVals['yearOutflow'])
            //DRAW BUTTONS!
            addYearButtonsToStoryText({fromYearIdx: 7, toYearIdx: 8, cc: "POL", id:"inOutFlowPoland", startIdx: 7, selector: "#yearSelectorPoland"})
          } else if(currentChapter === 4)  {
            d3.select('#aRouBgr').html(qVals['roubgr'])
          } else if(currentChapter === 6)  {
            d3.select('#aOldEu').html(qVals['oldeu'])
          } else if(currentChapter === 8)  {
            d3.select('#aNetFlows').html(qVals['netflows'])
          }

          
          placeChapterProgress();
          updateChapterProgress();
        })
      .transition()
        .duration(duration)
        .style("visibility", "visible")
        .style("opacity", 1);
  }

  function placeChapterProgress() {
    if(currentChapter === minChapter) {
      d3.selectAll("#navigateDown")
        .style("opacity", 1)
        .style("visibility", "visible");

      d3.selectAll("#navigateUp, #chapterProgress")
        .style("opacity", 0)
        .style("visibility", "hidden");
    } else if (currentChapter === maxChapter) {
       d3.selectAll("#navigateUp, #chapterProgress")
        .style("opacity", 1)
        .style("visibility", "visible");

      d3.selectAll("#navigateDown")
        .style("opacity", 0)
        .style("visibility", "hidden");
    } else {
      d3.selectAll("#navigateDown, #navigateUp, #chapterProgress")
        .style("opacity", 1)
        .style("visibility", "visible");
    }

    
    
  }

  function updateStoryTextPosition(args){
    for (var key in args) {
      storyText.style(String(key), args[key]+"px");
    }
  }//END updateStoryTextPosition

  function updateStoryTextStyle(args){
    for (var key in args) {
      storyText.style(String(key), args[key]);
    }
  }//END updateStoryTextStyle

  function updateTimeBar(elapsed) {
    var h = 650 * elapsed / maxTime[condition-1][phase];
    timeBar.style("height", h+"px");
  }//END updateTimeBar

  function updateNumericTimer(timeLeft) {
    var secs = Math.ceil(timeLeft/1000);
    var mins = Math.ceil(secs/60);
    var oldTxt = numericTimer.text();
    var newTxt;
    if (secs <= 30) {
      if (secs == 1){
        newTxt = secs + " second left";
      } else {
        newTxt = secs + " seconds left";
      }
      if (oldTxt != newTxt){
        numericTimer.attr("class", "red").text(newTxt);
      }
    } else {
      if (mins <= 1) {
        newTxt = "about " + mins + " minute left";
        if (oldTxt != newTxt){
          numericTimer.attr("class", "orange").text(newTxt)
            .style("background-color", "rgba(255, 255, 0, 0.5)")
            .transition()
              .duration(750)
              .ease(d3.easeExp)
              .style("background-color", "rgba(255, 255, 0, 0)");
        }
      } else {
        newTxt = "about " + mins + " minutes left";
        if (oldTxt != newTxt){
          numericTimer.attr("class", "green").text(newTxt)
            .style("background-color", "rgba(255, 255, 0, 0.5)")
            .transition()
              .duration(750)
              .ease(d3.easeExp)
              .style("background-color", "rgba(255, 255, 0, 0)");
        }
      }
      
    }

   /* d3.timeMinute(date) < date ? formatSecond
      : d3.timeHour(date) < date ? formatMinute*/
  }

  function updateTitle() {
    d3.select("#yearTitle")
      .text((aggregateMode) ? minYear + " - " + maxYear : currentYear)
      .style("background-color", "rgba(255, 255, 0, 0.5)")
      .transition()
        .duration(750)
        .ease(d3.easeExp)
        .style("background-color", "rgba(255, 255, 0, 0)");
  }//END updateTitle

  function updateTooltip(flow, isSelected) {
    //var a = (aggregateMode) ? minYear + " - " + maxYear : currentYear;
    if (isSelected === undefined) {
      isSelected = false;
    }
    var inVal = (aggregateMode) ? flow['sum_all_in'] : flow['in'][mrom][year];
    var outVal = (aggregateMode) ? flow['sum_all_out'] : flow['out'][mrom][year];

    var netVal = inVal - outVal
    var txtClass = "txtEqual";
    if (netVal > 0) {
      txtClass = "txtIn";
    } else if (netVal < 0) {
      txtClass = "txtOut";
    }

    tooltip
      .style("display", "inline")
      .html(((!detailMode) ? "<b>" + flow['c'] + "</b> &rarr; UK: <b>" + format2SI(inVal) + "</b><br />UK &rarr; <b>" + flow['c'] + "</b>: <b>" + format2SI(outVal) + "</b><hr /><b class='" + txtClass+ "'>Net Flow: " + format2SI(Math.abs(inVal - outVal)) + "</b>" : ((isSelected) ? "<span class='txtIn'><b>" + flow['c'] + "</b> &rarr; UK: <b>" + format2SI(inVal) + "</b></span><br /><span class='txtOut'>UK &rarr; <b>" + flow['c'] + "</b>: <b>" + format2SI(outVal) + "</b></span><hr /><span class='" + txtClass+ "'>Net Flow: " + format2SI(Math.abs(inVal - outVal)) + "</span>" : "Click to see the in and out flow for <b>" + flow['c'] + "</b>")));

  }//END updateTooltip

/*** =========================================================================================== ***/
/*** SETUP EVENTS ***/
/*** =========================================================================================== ***/
  
    function enableMapEvents(flag) {
      d3.selectAll('.flowSel')
        .on("click", !flag ? null : function(d) {clickFlow(d);})
        .on("mouseover", !flag ? null : function(d){mouseoverFlow(d);})
        .on("mousemove", !flag ? null : function(d) {mousemoveFlowOrCountry();})
        .on("mouseout", !flag ? null : function(d){mouseoutFlow(d);});

      d3.selectAll('path.eu')
        .on("click", !flag ? null : function(d){clickCountry(d);})
        .on("mouseover", !flag ? null : function(d) {mouseoverCountry(d);})
        .on("mousemove", !flag ? null : function(d) {mousemoveFlowOrCountry();})
        .on("mouseout", !flag ? null : function(d) {mouseoutCountry(d);});
    }
  /***
  RETURN from detailMode
  ***/
  function equalToEventTarget() {
      return this == d3.event.target;
  }//END equalToEventTarget

  function enableMouseDownEvent(flag) {
    d3.select("body").on("mousedown", !flag ? null : function(){
      var outside = d3.selectAll(".eu, .flowSel, .inPath, .outPath, #toggleMode, #toggleHowTo, .noUi-base, .noUi-handle, .noUi-tooltip").filter(equalToEventTarget).empty();
      //console.log(outside);
      if (outside) {
        mouseDownEvent();
      }
    });
  }//END setupMouseDownEvent


  function evaluateCurrentChapter() {
    if (currentChapter === 1) {
      if(d3.select('#yearInflow').node().value==="" || d3.select('#yearOutflow').node().value===""){
        return false;
      } else {
        qVals["yearInflow"] = d3.select('#yearInflow').node().value;
        qVals["yearOutflow"] = d3.select('#yearOutflow').node().value;
        logAction("L"+qVals["yearInflow"]+qVals["yearOutflow"] );
      }
    } else if (currentChapter === 3) {
      if(d3.select('input[name="roubgr"]:checked').empty()){
        return false;
      } else {
        qVals["roubgr"] = d3.select('input[name="roubgr"]:checked').node().value;
        logAction("L"+qVals["roubgr"].charAt(0).toUpperCase());
      }
    } else if (currentChapter === 5){
      if(d3.select('input[name="oldeu"]:checked').empty()){
        return false;
      } else {
        qVals["oldeu"] = d3.select('input[name="oldeu"]:checked').node().value;
        logAction("L"+qVals["oldeu"].charAt(0).toUpperCase());
      }
    } else if (currentChapter === 7){
      if(d3.select('input[name="netflows"]:checked').empty()){
        return false;
      } else {
        qVals["netflows"] = d3.select('input[name="netflows"]:checked').node().value;
        logAction("L"+qVals["netflows"].charAt(0).toUpperCase());
      }
    }

    return true;
  }

  function enableUpDownEvents(flag) {
    d3.select("#navigateDown")
      .on("click", !flag ? null : function(){
        if (evaluateCurrentChapter()){
          upDownEvent(1);
        } else {
          //info please answer the question
          d3.select('.qStory').interrupt().transition();
      d3.select('.qStory')
      .style("background-color", "rgba(128, 0, 128, 0.4)")
      .transition()
        .duration(3000)
        .ease(d3.easeExp)
        .style("background-color", "rgba(128, 0, 128, 0)");
        }
      });

    d3.select("#navigateUp")
      .on("click", !flag ? null : function(){
        upDownEvent(-1);
      });

    /*d3.select("body")
      .on("wheel", !flag ? null : function() {
        upDownEvent();    
      })
      .on("keydown", !flag ? null : function(){
        if(d3.event.keyCode === 40) {
          //down
          upDownEvent(1);
        } else if (d3.event.keyCode === 38) {
          //up
          upDownEvent(-1);
        }
      });*/

  }//END setupUpDownEvents

/*** =========================================================================================== ***/
/*** EVENT FUNCTIONS (NOT SETUP OF EVENTS) ***/
/*** =========================================================================================== ***/
  function mouseDownEvent() {
    logAction("G");
    flowGroup.selectAll(".flow").classed("unfocus", false).classed("selected", false).classed("mouseover", false);
    d3.selectAll(".eu").classed("selected", false).classed("mouseover", false);
    tooltip.style("display", "none");
    d3.selectAll("g.flow_inout").transition().duration(500).style("opacity", 0).remove();
    detailMode = false;
    detailCountry = undefined;
    updateChart(flowData, (aggregateMode) ? 0 : year, (aggregateMode) ? maxYearIdx : year, false)
    updateLegend();
  }
  /***
  select country of origin by clikcing country shape or net flow => detail mode
  ***/
  function clickCountry(d) {
    logAction("FC"+d.properties.ADM0_A3);
    clickFlowOrCountry(flowGroup.select("#F_"+d.properties.ADM0_A3).data()[0], d.properties.ADM0_A3);
  }//END clickCountry

  function clickFlow(d) {
    logAction("FF"+d.cc);
    clickFlowOrCountry(d, d.cc);
  }//END clickFlow

  function clickFlowOrCountry(flow, country_code) {
    flowGroup.selectAll(".flow").classed("unfocus", false);
    d3.selectAll(".eu").classed("selected", false);
    d3.selectAll("g.flow_inout").remove();

    d3.select("#C_"+country_code).classed("selected", true);
    flowGroup.select("#F_"+country_code).classed("selected", true);
    flowGroup.selectAll(".flow").classed("unfocus", true);
    setupInOutFlow(flow);

    detailMode = true;
    updateChart([flow], (aggregateMode) ? 0 : year, (aggregateMode) ? maxYearIdx : year, false);

    updateTooltip(flow, true);

    updateLegend();
  }//END clickFlowOrCountry

  function mousemoveFlowOrCountry() {
    var bb = vis.node().getBoundingClientRect();
    tooltip
        .style("left", (d3.event.pageX - (bb.left + window.scrollX) + 8) + "px")
        .style("top", (d3.event.pageY - (bb.top + window.scrollY) + 8) + "px");  
  }//END mousemoveFlowOrCountry

  function mouseoutCountry(d) {
    mouseoutFlowOrCountry(d.properties.ADM0_A3);
  }//END mouseoutCountry

  function mouseoutFlow(d) {
    mouseoutFlowOrCountry(d.cc);
  }//END mouseoutFlow

  function mouseoutFlowOrCountry(country_code) {
    if (detailMode) {
      flowGroup.select("#F_"+country_code).classed("unfocus", true);
    }
    d3.select("#C_"+country_code).classed("mouseover", false);
    flowGroup.select("#F_"+country_code).classed("mouseover", false);

    tooltip.style("display", "none");
    if (!detailMode) {
      updateChart(flowData, (aggregateMode) ? 0 : year, (aggregateMode) ? maxYearIdx : year, false);
    }
  }//END mouseoutFlowOrCountry

  function mouseoverCountry(d) {
    logAction("EC"+d.properties.ADM0_A3);
    mouseoverFlowOrCountry(flowGroup.select("#F_"+d.properties.ADM0_A3).data()[0], d.properties.ADM0_A3);
  }//END mouseoverCountry
  
  function mouseoverFlow(d) {
    logAction("EF"+d.cc);
    mouseoverFlowOrCountry(d, d.cc);
  }//END mouseoverFlow

  function mouseoverFlowOrCountry(flow, country_code) {
    //console.log(d3.select("#C_"+country_code).classed("selected"), flowGroup.select("#F_"+country_code).classed("selected"));
    var isSelected = d3.select("#C_"+country_code).classed("selected");
    d3.select("#C_"+country_code).classed("mouseover", true);
    if (detailMode) {
      if (!isSelected) {
        flowGroup.select("#F_"+country_code).classed("unfocus", false);
      }
      
    } else {
      flowGroup.select("#F_"+country_code).classed("mouseover", true);
    }
    updateTooltip(flow, isSelected);
    if (!detailMode) {
      updateChart([flow], (aggregateMode) ? 0 : year, (aggregateMode) ? maxYearIdx : year, false);
    }
  }//END mouseoverFlowOrCountry

  function transitionC32C1(){
    logAction("Z");
    //console.log("transition from c3 to c1");
    var d = 0;
    fadeElementToOpacity({selector: '#hintsCondition3', delay: d, duration: 500, opacity: 0});
    d3.selectAll(".storyButton")
      .classed("transition", true)
      .on("click", null)
      .on("mousemove", null)
      .on("mouseout", null);
    d += 1000
    updateStoryTextPosition({top: 250, left: 600});
    updateStoryTextStyle({border: "1px solid #333"});
    
    //storyText.interrupt().transition();

    updateStoryTextFadeIn({delay: d, duration: 500, storyText: "Between 2000 and 2016 Cecile, Klaus, Susanne, Jakub, Alejandro, Francesca and Ileana migrated to or from the UK for various reasons."})

    //updateStoryText({delay: d, storyText: "Between 2000 and 2016 Cecile, Klaus, Susanne, Jakub, Alejandro, Francesca and Ileana entered or left to the UK for various reasons."})
    
    //fadeElementToOpacity({selector: '#storyText', delay: d+10, duration: 500, opacity: 1});
    //console.log(storyText);
    //updateStoryTextFadeIn({delay: d, duration: 1000, storyText: "Between 2000 and 2016 Cecile, Klaus, Susanne, Jakub, Alejandro, Francesca and Ileana entered or left to the UK for various reasons."});   
    
    drawAllStoryFlows(d+20);
    shrinkAndMoveIcons(d+30);

    d += 9000;
    
    updateStoryTextCrossFade({delay: d, duration: 1000, storyText: "Not only them, but also many other French, German, Spanish, Italian, Polish, Polish and Romanian citizens moved to or from the UK during this period."});   

    d += 2000;
    var s = [
      {name: "cecile", cc: "FRA", da: 200},
      {name: "klaus", cc: "DEU", da: 200},
      {name: "jakub", cc: "POL", da: 200},
      {name: "alejandro", cc: "ESP", da: 200},
      {name: "francesca", cc: "ITA", da: 200},
      {name: "ileana", cc: "ROU", da: 200}
    ];

    for (var i=0; i < s.length; i++) {
      var fd = d3.select("#F_"+s[i].cc).data()[0];
      var len = d3.select("#F_"+s[i].cc).node().getTotalLength();
      var vals = {
        'balance': fd.sum_all_in - fd.sum_all_out,
        'in': fd.sum_all_in,
        'out': fd.sum_all_out
      };

      d3.select("#journey-path-final-"+s[i].name)
        .transition()
          .delay(d)
          .duration(2000)
            .attr("d", fd.line)
            .attr("stroke-width", calculateStrokeWidth(vals))
            .attr("stroke", "hsl(355, 80%, 50%)")
            .style("stroke-opacity", 0.6)
            .attr("stroke-dasharray", len)
            .attr("stroke-dashoffset", 0);
    }

    d += 8000;
    updateStoryTextCrossFade({delay: d, duration: 1000, storyText: "In fact, many citizens of other countries of the European Union came or left between 2000 and 2016."});   
    d += 2000;
    fadeElementToOpacity({selector: '.flow_group', delay: d, duration: 2000, opacity: 1});
    //d3.select(".flow_group").transition().delay(d).duration(2000).style("opacity", 1).style("visibility", "visible");
    d +=500;
    fadeElementToOpacity({selector: '#stories-final', delay: d, duration: 1000, opacity: 0});
    
    d += 5000;
    fadeElementToOpacity({selector: '#storyText', delay: d, duration: 2000, opacity: 0});
    d += 1000;
    fadeElementToOpacity({selector: '.infoModal', delay:d, duration: 800, opacity: 1});
    fadeElementToOpacity({selector: '#slider', delay: d, duration: 2000, opacity: 0.3});
    fadeElementToOpacity({selector: '#chart', delay: d, duration: 2000, opacity: 1});
    fadeElementToOpacity({selector: '#legend', delay: d, duration: 2000, opacity: 1});
    fadeElementToOpacity({selector: '#toggleMode', delay: d, duration: 2000, opacity: 1});
    fadeElementToOpacity({selector: '#toggleHowTo', delay: d, duration: 2000, opacity: 1});

    fadeElementToOpacity({selector: '#hintsCondition1', delay: d+3000, duration: 500, opacity: 1});
    isHintsCondition1Active = true;
    
    /*fadeElementToOpacity({selector: '#hintsCondition1', delay: d+3000+20000, duration: 500, opacity: 0});
    d3.timeout(function() {
      d3.select("#toggleHowTo").html("Show hints");
      isHintsCondition1Active = false;
    }, d+3000+20000);*/
        
    d3.timeout(function() {
      enableMouseDownEvent(true);
      enableMapEvents(true);
    }, d);

    //d += 2000;
    //timer.restart(function(elapsed){timerEvent(elapsed);}, d);
    inTransition = false;
  }//END transitionC32C1

  function drawAllStoryFlows(delay) {

    var story = svgMap.append("g")
      .attr("id","stories-final");

    var s = ["cecile", "klaus", "jakub", "alejandro", "francesca", "ileana"];
    var duration = 4000;

    for(var i=0; i < s.length; i++) {
      var name = s[i];
      story.append("path")
        .data([storyScript[name].path])
        .attr("id", "journey-path-final-"+name)
        .attr("fill","none")
        .attr("stroke","hsl(300,90%,25%)")
        .attr("stroke-width", 6)
        .attr("d", d3.line().curve(d3.curveBasis))
        .attr("stroke-dasharray", darrays[name])
        .attr("stroke-dashoffset", 0)
        .style("opacity", 0)
        .transition()
          .duration(delay)
          .duration(duration)
          .style("opacity", 1);
    }

    svgMap.selectAll(".storygroup")
      .transition()
        .delay(delay+duration)
        .style("opacity", 0)
        .remove();

  }//END drawAllStoryFlows

  function shrinkAndMoveIcons(delay) {
    var s = [
      {name: "cecile", x: 235, y:305},
      {name: "klaus", x: 290, y:240},
      {name: "jakub", x: 350, y:180},
      {name: "alejandro", x: 120, y:350},
      {name: "francesca", x: 270, y:380},
      {name: "ileana", x: 390, y:280}
    ];

    var iconGroup = svgMap.append("g").attr("id", "final-icons").style("opacity", 0);
    var mapRect = svgMap.node().getBoundingClientRect();
    for(var i=0; i < s.length; i++) {

      var rect = d3.select("#select-image-" + s[i].name).node().getBoundingClientRect();

      iconGroup.append("image")
          .attr("id", "final-icon-" + s[i].name)
          .data([s[i]])
          //.attr("xlink:href", selectionIconUrls[s[i].name])
          .attr("href", selectionIconUrls[s[i].name])
          .attr("xlink:href", selectionIconUrls[s[i].name])
          .attr("height", rect.height)
          .attr("width", rect.width)
          .attr("x", rect.x - mapRect.x)
          .attr("y", rect.y - mapRect.y);
          //.attr("y", rect.y);
          //.attr("y", rect.y);
          //.attr("x", rect.x)
          //.attr("y", rect.y);
          //.attr("x", rect.x + window.scrollX - 9)
          //.attr("y", rect.y + window.scrollY - 9);
    }
    
    fadeElementToOpacity({selector: "#final-icons", opacity: 1, delay: delay, duration: 100});
    fadeElementToOpacity({selector: "#journeySelection", opacity: 0, delay: delay+100, duration: 2000});
    
    
    iconGroup.selectAll("image")
      .transition()
        .delay(delay+2000)
        .duration(6000)
        .attr("height", 30)
        .attr("x", function(d){ return d.x; })
        .attr("y", function(d){ return d.y; })
        .on("end", function(){
          fadeElementToOpacity({selector: "#final-icons", opacity: 0, delay: 0, duration: 3000});
        });
  }

  function transitionC2C1() {
    logAction("Z");
    enableUpDownEvents(false);

    fadeElementToOpacity({selector: "#storyTextC2", opacity: 0, delay: 0, duration: 1000});
    //fadeElementToOpacity({selector: ".chapter_group", opacity: 0, delay: 0, duration: 1000});
    //fadeElementToOpacity({selector: "#netFlowsAll", opacity: 0, delay: 0, duration: 1000});
    //fadeElementToOpacity({selector: "#netFlowsSelected", opacity: 0, delay: 0, duration: 1000});

    d3.selectAll("#netFlowsAll, #netFlowsSelected, .chapter_group").transition().duration(1000).style("opacity", 0).remove();


    fadeElementToOpacity({selector: "#hintsCondition2", opacity: 0, delay: 0, duration: 1000});
    my.highlightCountries({selector: ".eu", flag: false});

    var d = 1000;
    fadeElementToOpacity({selector: '.flow_group', delay: d, duration: 2000, opacity: 1});
    //d3.select(".flow_group").transition().delay(d).duration(2000).style("opacity", 1).style("visibility", "visible");
    fadeElementToOpacity({selector: '.infoModal', delay:d, duration: 800, opacity: 1});

    d += 1000;
    fadeElementToOpacity({selector: '#slider', delay: d, duration: 2000, opacity: 0.3});
    fadeElementToOpacity({selector: '#chart', delay: d, duration: 2000, opacity: 1});
    fadeElementToOpacity({selector: '#legend', delay: d, duration: 2000, opacity: 1});
    fadeElementToOpacity({selector: '#toggleMode', delay: d, duration: 2000, opacity: 1});
    fadeElementToOpacity({selector: '#toggleHowTo', delay: d, duration: 2000, opacity: 1});

    fadeElementToOpacity({selector: '#hintsCondition1', delay: d+3000, duration: 500, opacity: 1});
    isHintsCondition1Active = true;
    
    /*
    fadeElementToOpacity({selector: '#hintsCondition1', delay: d+3000+20000, duration: 500, opacity: 0});
    d3.timeout(function() {
      d3.select("#toggleHowTo").html("Show hints");
      isHintsCondition1Active = false;
    }, d+3000+20000);*/
        
    d3.timeout(function() {
      enableMouseDownEvent(true);
      enableMapEvents(true);
    }, d);

    //d += 2000;
    //timer.restart(function(elapsed){timerEvent(elapsed);}, d);
    /*
    var refreshIntervalId = setInterval(function(){
      upDownEvent(1);
      if (currentChapter == maxChapter) {
        fadeElementToOpacity({selector: "#storyNavigation", opacity: 0, delay: 0, duration: 1000});
        clearInterval(refreshIntervalId);
        timer.restart(function(elapsed){timerEvent(elapsed);}, 1000);
      }
    }, 500);*/
  }

  function timerEvent(elapsed) {
    //var elapsedTrue = elapsed + elapsedTime;

    //Phase 1
    if (phase <= maxTime[condition-1].length-1) {
      if (elapsed <= maxTime[condition-1][phase]) {
        //updateTimeBar(elapsed);
        updateNumericTimer(maxTime[condition-1][phase] - elapsed);
      } else {
        if (phase != maxTime[condition-1].length-1) {
          //console.log("transfer");
          if (condition === 2) {
            timer.stop();
            numericTimer.text("");
            transitionC2C1();
            //timer.restart(function(elapsed){timerEvent(elapsed);});
          } else if (condition === 3) {
            timer.stop();
            numericTimer.text("");
            inTransition = true;
            if (isPlaying) {
              // Wait until playback is over!
              //needed if has natural end and in transition
              var remainingTime = storyDuration - (d3.now() - storyStart);
              d3.timeout(function(){
                fadeElementToOpacity({selector: '#hintsCondition3', delay: 0, duration: 500, opacity: 0});
                d3.selectAll(".storyButton")
                  .classed("transition", true)
                  .on("click", null)
                  .on("mousemove", null)
                  .on("mouseout", null);
              }, remainingTime - 5000);

            } else {
              //Advance now
              transitionC32C1();
            }
          }
        }
        phase++;
      }
    } else {
      timer.stop();
      enableMouseDownEvent(false);
      logAction("H");
      qualtricsSurveyEngine.setEmbeddedData('log', JSON.stringify(logger));
      qualtricsContext.clickNextButton();
    }
  } //END timerEvent

  //TODO: Implement!
  function toggleHowToEvent() {
    if (isHintsCondition1Active) {
      //hide
      logAction("B"+0);
      hintsCondition1.interrupt().transition();
      if(hintsCondition1Timeout != undefined) {
        hintsCondition1Timeout.stop();
        hintsCondition1Timeout = undefined;
      }
      fadeElementToOpacity({selector: "#hintsCondition1", delay: 0, duration: 0, opacity: 0});
      isHintsCondition1Active = false;
      d3.select("#toggleHowTo").html("Show hints");
    } else {
      //show
      logAction("B"+1);
      fadeElementToOpacity({selector: "#hintsCondition1", delay: 0, duration: 0, opacity: 1});
      isHintsCondition1Active = true;
      d3.select("#toggleHowTo").html("Hide hints");
    }
   
  }//END toggleHowToEvent

  function toggleModeEvent(){
    if (aggregateMode) {
      logAction("C"+1);
      // switch to yera-by-year mode
      if (scaleGlobal) {
        min = globalNetMin;
        max = globalNetMax;
      } else {
        min = localNetMin;
        max = localNetMax;
      }

      d3.select("#toggleMode").html("Combine all years").classed("active", true);
      slider.removeAttribute('disabled');
      slider.style.opacity = "1.0";
      aggregateMode = false;
      if (detailMode) {
        updateChart([detailCountry], year, year, true);
      } else {
        updateChart(flowData, year, year, true);
      }

    } else {
      logAction("C"+0);
      // switch to aggregate mode
      min = aggregatedNetMin;
      max = aggregatedNetMax;
      slider.setAttribute('disabled', true);
      slider.style.opacity = "0.3";
      d3.select("#toggleMode").html("Show by years").classed("active", false);
      aggregateMode = true;
      if (detailMode) {
        updateChart([detailCountry], 0, maxYearIdx, true);
      } else {
        updateChart(flowData, 0, maxYearIdx, true);
      }
    }
    updateTitle();
    updateBackgroundMap();
    updateFlows();
    updateLegend();
    if (detailMode) {
      updateInOutFlow();
    }
  }//END toggleModeEvent

  function updateChapterProgress(){
    var pos = (100*currentChapter)/maxChapter;
    d3.select("#chapterProgress")
      .style("background", "linear-gradient(left, rgba(128, 0, 128, 0.5) " + pos + "%, transparent " + pos + "%)")
      .style("background", "-webkit-linear-gradient(left, rgba(128, 0, 128, 0.5) " + pos + "%, transparent " + pos + "%)")
      .style("background", "-moz-linear-gradient(left, rgba(128, 0, 128, 0.5) " + pos + "%, transparent " + pos + "%)")
      .style("background", "-ms-linear-gradient(left, rgba(128, 0, 128, 0.5) " + pos + "%, transparent " + pos + "%)");
  }

  function upDownEvent(delta) {
    var oldChapter = currentChapter;
    if (delta < 0) {
      //up
      currentChapter--;
      currentChapter = Math.max(minChapter, currentChapter);
      logAction("I"+currentChapter)
    } else {
      //down
      currentChapter++;
      currentChapter = Math.min(maxChapter, currentChapter);
      logAction("J"+currentChapter);
    }


    //updateChapterProgress();
    //d3.selectAll(".chapter").html("<div>&#9679;</div>")
    //d3.select("#chapter-"+currentChapter).html("<div>&#9673;</div>")


    if (oldChapter != currentChapter){
      storyScript.chapters[currentChapter].forEach(function(event) {
        d3.select(event.args.selector).interrupt().transition();
          window.Flowstory[event.func](event.args);
        });
    } //else {
      //
      //if (currentChapter === minChapter){

      //} else {
       // console.log("Take the remaining time to revisit the story.");
      //}
      
    //}
    //var deltaY;
      /*if (d === undefined) {
        deltaY = d3.event.deltaY;
      } else {
        deltaY = d;
      }
      var direction = "forward";
      var oldScrollPos = scrollPos;
      if (deltaY < 0) {
        //wheel up
        scrollPos--;
        scrollPos = Math.max(minScroll, scrollPos);
        direction = "backward";
      } else {
        //wheel down
        scrollPos++;
        scrollPos = Math.min(maxScroll, scrollPos);
        direction = "forward";
      }

      if (oldScrollPos != scrollPos){

        d3.selectAll(".chapter").html("<div>&#9679;</div>")
        d3.select("#chapter-"+scrollPos).html("<div>&#9673;</div>")

        //console.log(oldScrollPos, "=>", scrollPos);
        //updateProgressBar();
        var offset = 0
        if (direction == "backward") {
          offset = 1;
        }
        if (scrollPos+offset in storyScript) {
          //console.log("Story has event at " + scrollPos)
          storyScript[scrollPos+offset][direction].forEach(function(event) {
              d3.select(event.args.selector).transition();
              //d3.select("*").transition();
              window.Flowstory[event.func](event.args);
          });
        }
      }*/
  }//END upDownEvent

/*** =========================================================================================== ***/
/*** PLAYBACK CONDITION 3 ***/
/*** =========================================================================================== ***/
  function storyButtonClickEvent(d) {
    if (isPlaying && !readyToPlay){
      logAction("Y"+d.charAt(0).toUpperCase());
      svgMap.select("#journey-path-"+d).interrupt().transition();
      stopStory(d);
    } else {
      logAction("W"+d.charAt(0).toUpperCase());
      playStory(d);
    }
  }

  function storyButtonMousemoveEvent(d) {
    svgMap.select("#journey-path-"+d)
      .attr("stroke", "hsl(300,40%,70%)");
  }

  function storyButtonMouseoutEvent(d) {
    svgMap.select("#journey-path-"+d)
      .attr("stroke", "hsl(300,90%,25%)");
  }

  function enableStorySelection(){
    d3.selectAll(".storyButton")
      .classed("deactivate", false)
      .on("click", function(d){storyButtonClickEvent(d);})
      .on("mousemove", function(d){storyButtonMousemoveEvent(d);})
      .on("mouseout", function(d){storyButtonMouseoutEvent(d);});

    d3.select("#journeySelection").style("background-color", "rgba(245,245,245,0.8)");
  }

  function disableStorySelection(name){
    d3.selectAll(".storyButton:not(#storyButton-"+name+")")
      .classed("deactivate", true)
      .on("click", null);

    d3.selectAll(".storyButton")
      .on("mousemove", null)
      .on("mouseout", null);

    d3.select("#journeySelection").style("background-color", "rgba(245,245,245,0.2)");
  }

  function stopStory(name) {
    //stopStory
    endOfPlaybackTimeOut.forEach(function(tO) {
      clearTimeout(tO);
    });
    endOfPlaybackTimeOut = [];

    isPlaying = false;
    currentStory = null;
    storyDuration = null;

    var story = svgMap.select("g#story-" + name);
    if (playedAtLeastOnce.includes(name)) {
      // draw line

      story.selectAll("*:not(.journey-path)").remove();
      story.select(".journey-path")
        .transition();
      story.select(".journey-path")
        .transition()
        .delay(1)
        .duration(0)
        .attr("stroke-dashoffset", 0)
        .attr("stroke-dasharray", darrays[name]);

    } else {
      story.remove();
    }

    d3.selectAll(".journey-path")
      .attr("stroke", "hsl(300,90%,25%)");

    //if(!inTransition){
    storyText.interrupt().transition();
    storyText
      .style("opacity", 0)
      .style("visibility", "hidden");
    //}

    fadeElementToOpacity({selector: "#storyFocusMask", opacity: 0, delay: 0, duration: 0});
    
    enableStorySelection();
    readyToPlay = true;

    if (inTransition) {
      transitionC32C1();
    }
  }
  
  function playStory(name) {
    currentStory = name;
    disableStorySelection(name);

    // SET different Elements
    endOfPlaybackTimeOut.forEach(function(tO){
      clearTimeout(tO);
    });
    endOfPlaybackTimeOut = [];
    //group in svgMap for story
    var story = svgMap.select("g#story-" + name);
    if (story.empty()) {
      story = svgMap.append("g")
        .attr("id","story-" + name)
        .attr("class", "storygroup");
    } else {
      //Delete everything inside group for starting over!
      story.selectAll("*").remove();
    }
    //update focus mask postition
    updateStoryFocusMask(storyScript[name].focusMask)
    //update story text position
    updateStoryTextPosition(storyScript[name].storyText)

    //LOAD Events
    isPlaying = true;
    readyToPlay = false;
    var eventNumber = storyScript[name].events.length;
    storyStart = d3.now();
    storyScript[name].events.forEach(function(event, idx){
      event.args.name = name;
      window.Flowstory[event.func](event.args);
      if (idx === eventNumber-3) {
        var tO = setTimeout(function(){
          /*if (!playedAtLeastOnce.includes(name)) {
            playedAtLeastOnce.push(name);
          }*/
          enableStorySelection();
          readyToPlay = true;
        }, event.args.delay);
        endOfPlaybackTimeOut.push(tO);
      }
      if (idx === eventNumber-1){
        storyDuration = event.args.delay + event.args.duration;      
        var tO = setTimeout(function(){
          logAction("X"+name.charAt(0).toUpperCase());
          stopStory(name);
        }, storyDuration);
        endOfPlaybackTimeOut.push(tO);
      }
    });


  }//END playStory

  function createMarker(args) {
    //marker, pos
    var marker = storyScript[args.name].marker[args.id];
    var pos = storyScript[args.name].path[marker.posIdx];
    svgMap.select("g#story-" + args.name).append("image")
      .attr("id", args.id + "-" + args.name)
      .attr("class", "marker")
      .attr("xlink:href", marker.src)
      .attr("width", marker.width)
      .attr("height", marker.height)
      .attr("transform", "translate(" + (pos[0] + ("dx" in marker ? marker.dx : 0) - (marker.width/2)) + "," + (pos[1] + ("dy" in marker ? marker.dx : 0) - (marker.height/2)) + ")")
      .style("visibility", "hidden")
      .style("opacity", 0);
  }//END createMarker

  function createJourneyPath(args) {
    var journeyPath = svgMap.select("g#story-" + args.name).append("path")
      .data([storyScript[args.name].path])
      .attr("id", "journey-path-"+args.name)
      .attr("class", "journey-path")
      .attr("fill","none")
      .attr("stroke", "hsl(300,90%,25%)")
      .attr("stroke-width", 6)
      .attr("d", d3.line().curve(d3.curveBasis));

    var lengthJourneyPath = journeyPath.node().getTotalLength();
    journeyPath
      .attr("stroke-dasharray", lengthJourneyPath + " " + lengthJourneyPath)
      .attr("stroke-dashoffset", lengthJourneyPath)
  }//END createJourneyPath

  function createJourneyPathReverse(args) {
    var journeyPath = svgMap.select("g#story-" + args.name).append("path")
      .data([storyScript[args.name].pathReverse])
      .attr("id", "journey-path-reverse-"+args.name)
      .attr("fill","none")
      .attr("stroke", "none")
      /*.attr("stroke","#333333")
      .attr("stroke-width", 6)*/
      .attr("d", d3.line().curve(d3.curveBasis));

   /* var lengthJourneyPath = journeyPath.node().getTotalLength();
    journeyPath
      .attr("stroke-dasharray", lengthJourneyPath + " " + lengthJourneyPath)
      .attr("stroke-dashoffset", lengthJourneyPath) */
  }//END createJourneyPathReverse

  function setJourneyPathsColor(args) {
    d3.selectAll(".journey-path:not(#journey-path-" + args.name + ")").transition().delay(args.delay).duration(args.duration).attr("stroke", args.color); 
  }//END setJourneyPathsColor

  function animateJourneyPath(args) {
    svgMap.select("#journey-path-"+args.name)
      /*.data({darray: args.darray})*/
      .transition()
        .delay(args.delay) //9500
        .duration(args.duration) //9000
        .ease(d3.easeSin)
        .attr("stroke-dashoffset", 0)
        .attr("stroke-dasharray", darrays[args.name]) //220
        .on("end", function(){
          if (!playedAtLeastOnce.includes(args.name)) {
            playedAtLeastOnce.push(args.name);
          }
        });
  }//END animateJourneyPath

  function moveMarkerAlongPath(args) {
    svgMap.select("#" + args.marker + "-" + args.name)
      .transition()
        .delay(args.delay)
        .duration(args.duration)
        .ease(d3.easeSin)
        .attrTween("transform", translateAlong(svgMap.select(args.pathSelector).node(), storyScript[args.name].marker[args.marker].height, storyScript[args.name].marker[args.marker].width));
  }//END moveMarkerAlongPath

  function translateAlong(path, h, w) {
    var l = path.getTotalLength();
    return function(i) {
      return function(t) {
        var p = path.getPointAtLength(t * l);
        return "translate(" + (p.x - (w/2)) + "," + (p.y - (h/2)) + ")";//Move marker
      }
    }
  }//END translateAlong

  function moveTitleTo(args) {
    d3.select("#title")
      .transition()
        .delay(args.delay)
        .duration(args.duration)
        .style("top", args.top)
        .style("left", args.left);
  }//END moveTitleTo

/*** =========================================================================================== ***/
/*** UTILS FUNCTION ***/
/*** =========================================================================================== ***/
  function calculateStrokeWidthScaleGlobal(values){
    var sw = 0;
    if (values['balance'] == 0 && values['in'] != 0 && values['out'] != 0) {
      sw = minWidth;
    } else {
      sw = (((maxWidth - minWidth) * (Math.abs(values['balance']) - globalNetMin)) / (globalNetMax - globalNetMin)) + minWidth;
    }
    return sw;
  }

  function calculateStrokeWidth(values) {
    var sw = 0;
    if (values['balance'] == 0 && values['in'] != 0 && values['out'] != 0) {
      sw = minWidth;
    } else {
      if (aggregateMode || scaleGlobal) {
        sw = (((maxWidth - minWidth) * (Math.abs(values['balance']) - min)) / (max - min)) + minWidth;
      } else {
        sw = (((maxWidth - minWidth) * (Math.abs(values['balance']) - min[year])) / (max[year] - min[year])) + minWidth;
      } 
    }
    return sw;
  }//END calculateStrokeWidth

  function calculateStrokeWidthByDirection(values, direction) {
    var sw = 0;
    if (values[direction] != 0) {
      if (aggregateMode || scaleGlobal) {
        //sw = (((maxWidth - minWidth) * (Math.abs(values[direction]) - (aggregateMode ? aggregatedMin : globalMin))) / ((aggregateMode ? aggregatedMax : globalMax) - (aggregateMode ? aggregatedMin : globalMin))) + minWidth;
        sw = (((maxWidth - minWidth) * (Math.abs(values[direction]) - min)) / (max - min)) + minWidth;
      } else {
        sw = (((maxWidth - minWidth) * (Math.abs(values[direction]) - min[year])) / (max[year] - min[year])) + minWidth;
      } 
    }
    return sw;
  }//END calculateStrokeWidthByDirection

  function calculateStrokeWidthByDirectionScaleGlobal(values, direction) {
    var sw = 0;
    if (values[direction] != 0) {
      //sw = (((maxWidth - minWidth) * (Math.abs(values[direction]) - (aggregateMode ? aggregatedMin : globalMin))) / ((aggregateMode ? aggregatedMax : globalMax) - (aggregateMode ? aggregatedMin : globalMin))) + minWidth;
      sw = (((maxWidth - minWidth) * (Math.abs(values[direction]) - globalNetMin)) / (globalNetMax - globalNetMin)) + minWidth;
    }
    return sw;
  }//END calculateStrokeWidthByDirection

  function calculateStrokeWidthByDirectionScaleAggregate(values, direction) {
    var sw = 0;
    if (values[direction] != 0) {
      //sw = (((maxWidth - minWidth) * (Math.abs(values[direction]) - (aggregateMode ? aggregatedMin : globalMin))) / ((aggregateMode ? aggregatedMax : globalMax) - (aggregateMode ? aggregatedMin : globalMin))) + minWidth;
      sw = (((maxWidth - minWidth) * (Math.abs(values[direction]) - aggregatedNetMin)) / (aggregatedNetMax - aggregatedNetMin)) + minWidth;
    }
    return sw;
  }//END calculateStrokeWidthByDirection

  function calculateStrokeWidthByDirectionScaleLocal(values, direction, locNetMin, locNetMax) {
    var sw = 0;
    if (values[direction] != 0) {
      //sw = (((maxWidth - minWidth) * (Math.abs(values[direction]) - (aggregateMode ? aggregatedMin : globalMin))) / ((aggregateMode ? aggregatedMax : globalMax) - (aggregateMode ? aggregatedMin : globalMin))) + minWidth;
      sw = (((maxWidth - minWidth) * (Math.abs(values[direction]) - locNetMin)) / (locNetMax - locNetMin)) + minWidth;
    }
    return sw;
  }//END calculateStrokeWidthByDirection

  function checkFunctionParameter(parameter, domain) {
    return (parameter === undefined || !domain.includes(parameter)) ? domain[0] : parameter;
  } //END checkFunctionParameter

  function fadeElementToOpacity(args) {
    var element = d3.selectAll(args.selector);
    element.transition().delay(args.delay).duration(args.duration).style("visibility", "visible").style("opacity", args.opacity);
    if (args.opacity == 0) {
      element.transition().delay(args.delay+args.duration).duration(0).style("visibility", "hidden");
    } //END fadeElementToOpacity
  }

  function highlightSvgText(cxt, node, selector) {
    var bbox = node.getBBox();
    var ctm = node.getCTM();
    var padding = 2;
    d3.selectAll("."+selector).style("opacity", 0).remove();
    var rect = cxt.append("rect", "text")
      .attr("class", selector)
      .attr("x", bbox.x - padding)
      .attr("y", bbox.y - padding)
      .attr("width", bbox.width + (padding*2))
      .attr("height", bbox.height + (padding*2))
      .style("fill", "yellow")
      .style("opacity", 0.3);

   rect.node().transform.baseVal.initialize(rect.node().ownerSVGElement.createSVGTransformFromMatrix(ctm));
   rect.transition().duration(800).ease(d3.easeExp).style("opacity", 0).remove();
  }//END highlightSvgText

  function highlightSvgTextNoFadeOut(cxt, node, selector, color) {
    var bbox = node.getBBox();
    var ctm = node.getCTM();
    var padding = 4;
    var rect = cxt.append("rect", "text")
      .attr("class", selector)
      .attr("x", bbox.x - padding)
      .attr("y", bbox.y - padding)
      .attr("width", bbox.width + (padding*2))
      .attr("height", bbox.height + (padding*2))
      .attr("fill", color)
      .attr("rx", 4)
      .attr("ry", 4)
      .attr("stroke", color)
      .attr("stroke-width", 2)
      .style("fill-opacity", 0.3)
      .style("stroke-opacity", 0.8);

   rect.node().transform.baseVal.initialize(rect.node().ownerSVGElement.createSVGTransformFromMatrix(ctm));
  }//END highlightSvgText

  function highlightSvgTextReason(cxt, node, selector, color) {
    var bbox = node.getBBox();
    var ctm = node.getCTM();
    var padding = 2;
    var rect = cxt.append("rect", "text")
      .attr("class", selector)
      .attr("x", bbox.x - padding)
      .attr("y", bbox.y - padding)
      .attr("width", bbox.width + (padding*2))
      .attr("height", bbox.height + (padding*2))
      .attr("fill", color)
      .attr("rx", 2)
      .attr("ry", 2);

   rect.node().transform.baseVal.initialize(rect.node().ownerSVGElement.createSVGTransformFromMatrix(ctm));    
  }

  function moveLine(sp, cp, ep, offset) {
    var phiSp = Math.PI - Math.atan2(sp[0] - cp[0], sp[1] - cp[1])
    var spMoved = [sp[0] - offset * Math.cos(phiSp), sp[1] - offset * Math.sin(phiSp)]

    var phiCp = Math.PI - Math.atan2(sp[0] - ep[0], sp[1] - ep[1])
    var cpMoved = [cp[0] - offset * Math.cos(phiCp), cp[1] - offset * Math.sin(phiCp)]

    var phiEp = Math.PI - Math.atan2(cp[0] - ep[0], cp[1] - ep[1])
    var epMoved = [ep[0] - offset * Math.cos(phiEp), ep[1] - offset * Math.sin(phiEp)]

    return [spMoved, cpMoved, epMoved];
  }//END moveLine

/*** =========================================================================================== ***/
/*** INIT APPLICATION PUBLIC ***/
/*** =========================================================================================== ***/
  my.initFlowstory = function(c, wrapperId, qC, qSE) {
    logAction("A"+c);

    condition = c;
    if (condition === 2){
      maxChapter = (storyScript != undefined && storyScript.chapters != undefined) ? storyScript.chapters.length-1 : undefined;
    }
    qualtricsContext = qC;
    qualtricsSurveyEngine= qSE;
    // COMMONS FOR ALL CONDITIONS
    // vis wrapper
    vis = d3.select("#" + wrapperId).html(null);
    // svg map
    svgMap = vis.append("svg").attr("id", "svgMap");
    // calculate flow data min and max values
    setupFlowDataMinMax();
    //calculate coordinates for flow lines
    setupFlowLines();
    //create required dom elements
    if (condition === 2) {
      createElementsCondition2();
    } else if (condition === 3) {
      createElementsCondition3();
    } else {
      createElementsCondition1();
    }
    //timer
    timer = d3.timer(function(elapsed){timerEvent(elapsed);});
    //load background map and continue from there!
    setupBackgroundMap();
  };//END my.initFlowstory

  my.fadeElementToOpacity = function(args){
    fadeElementToOpacity(args);
  };
  my.setJourneyPathsColor = function(args){
    setJourneyPathsColor(args);
  };
  my.createJourneyPath = function(args){
    createJourneyPath(args);
  };
  my.createJourneyPathReverse = function(args){
    createJourneyPathReverse(args);
  };
  my.createMarker = function(args){
    createMarker(args);
  };
  my.updateStoryTextFadeIn = function(args){
    updateStoryTextFadeIn(args);
  };

  my.updateStoryTextAndStyleFadeIn = function(args){
    updateStoryTextAndStyleFadeIn(args);
  };
  my.updateStoryTextAndStyleCrossFade = function(args){
    updateStoryTextAndStyleCrossFade(args);
  };
  my.updateStoryTextAndStyleCrossFadeC2 = function(args){
    updateStoryTextAndStyleCrossFadeC2(args);
  };
  my.updateStoryTextCrossFade = function(args){
    updateStoryTextCrossFade(args);
  };
  my.moveMarkerAlongPath = function(args){
    moveMarkerAlongPath(args);
  };
  my.animateJourneyPath = function(args){
    animateJourneyPath(args);
  };
  my.updateStoryTextPosition = function(args){
    updateStoryTextPosition(args);
  };
  my.updateStoryTextStyle = function(args){
    updateStoryTextStyle(args);
  };
  my.moveTitleTo = function(args){
    moveTitleTo(args);
  };
  my.enableMapEvents = function(args){
    d3.timeout(function() {
      enableMapEvents(args.flag);
    }, args.delay);
  };
  my.enableMouseDownEvent = function(args){
    d3.timeout(function() {
      mouseDownEvent();
      enableMouseDownEvent(args.flag);
    }, args.delay);
  };

  my.toggleModeIfByYear = function(args){
    if(!aggregateMode) {
      toggleModeEvent();
    }
  };

  my.toggleMode = function(args){
    toggleModeEvent();
  };

  my.inOutFlow = function(args){
    clickFlowOrCountry(flowGroup.select("#F_"+args.cc).data()[0], args.cc);
    tooltip.style("display", "none");
  };

  my.removeInOutFlow = function(args){
    mouseDownEvent();
    //d3.select('body').dispatch("mousedown");
    //d3.selectAll("g.flow_inout").transition().duration(args.duration).style("opacity", 0).remove();
  };

  my.showHints = function(args){
    return;
    var hint = svgMap.append('g').attr("id", "hints").style("opacity", 0);
    hint.append('text')
      .attr("text-anchor", "end")
      .attr("alignment-baseline", "middle")
      .attr("transform", "translate(920,20) rotate(-1)")
      .attr("font-size", "smaller")
      .text("Indicates Progress");      

    hint.append('text')
      .attr("text-anchor", "end")
      .attr("alignment-baseline", "middle")
      .attr("transform", "translate(920,50) rotate(1)")
      .attr("font-size", "smaller")
      .text("Indicates Time");

    hint
      .attr("x", 200)
      .attr("y", 200)
      .transition()
        .delay(args.delay)
        .duration(args.duration)
        .style("opacity", 1)
  };

  my.removeHints = function(args){
    d3.select('g#hints')
      .transition()
        .delay(args.delay)
        .duration(args.duration)
        .style("opacity", 0)
        .remove();
  };

  my.hideHintsC1IfVisible = function(args){
    if(isHintsCondition1Active){
      toggleHowToEvent();
    }
  };

  my.showHintsC1 = function(args){
    d3.timeout(function(){
      toggleHowToEvent();
    }, 1000)
    
  }

  my.updateFlows = function(args){
    updateFlows(false);
  };
  my.updateFlowsUsingYears = function(args){
    d3.timeout(function() {
      updateFlows(false, args.fromYearIdx, args.toYearIdx);
      //fadeElementToOpacity()
    }, args.delay);
  };

  function getFlowDataForCC(cc){
    var res;
    flowData.forEach(function(item) {
      if(item.cc == cc)
        res = item;
    });
    return res;
  }

  function clone(selector, id) {
    var nodes = d3.selectAll(selector).nodes();
    var clonedNodes = [];
    nodes.forEach(function(node){
      var s = d3.select(node);
      var clone = d3.select(node.cloneNode(true))
        .data(s.data())
        .attr("id", s.attr("id")+"_"+id)
        .attr("class", s.attr("class"))
        .attr("d", s.attr("d"));

      clonedNodes.push(clone);
    })
    return clonedNodes;
    //return d3.select(node.parentNode.insertBefore(node.cloneNode(true), node.nextSibling));
    //return d3.select(node.cloneNode(true));
  }

  my.drawNetFlowsforSelectionByYears = function(args){
    if(!svgMap.select("#"+args.id).empty()){
      return;
    }
    //console.log("copyFlows for: ", args.selector);
    //console.log(flowGroup.selectAll(args.selector));

    var clonedNodes = clone(args.selector, args.id);
    //console.log(clonedNodes);

    var chapterFlowGroup = svgMap.append("g")
      .attr("class", "chapter_flow_group chapter_group")
      .attr("id", args.id)
    
    clonedNodes.forEach(function(clonedNode){
      chapterFlowGroup.node().append(clonedNode.node());
    })

    chapterFlowGroup.selectAll('path.flow').each(function(d,i,n){
      var isIn = false, isOut = false, isEqual = false, isZero = false;
      var values = getFlowValuesFromToYears(d, args.fromYearIdx, args.toYearIdx);
      var sw = calculateStrokeWidth(values);
      //console.log(d3.select(this).attr("id"), values, sw, values.in+values.out)
    
      if (values['balance'] == 0) {
        if (values['in'] == 0 && values['out'] == 0) {
          isZero = true;
        } else {
          isEqual = true;
        }
      } else if (values['balance'] < 0) {
        isOut = true;      
      } else if (values['balance'] > 0) {
        isIn = true;
      }

      if (!isZero){
        d3.select(this)
          .classed('in', isIn)
          .classed('out', isOut)
          .classed('equal', isEqual)
          .transition()
            .duration(200)
            .style('opacity', 1)
            .style('visibility', 'visible')
            .attr('stroke-width', sw);

      } else {
        d3.select(this)
          .transition()
            .duration(200)
            .style('opacity', 0)
          .transition()
            .delay(200)
            .style('visibility', 'hidden')
            .attr('stroke-width', sw);
      }
    });
    

  };
 /*
  my.getFlowValuesFromToYearsByReasons = function(cc, fromYearIdx, toYearIdx){
    //var d=getFlowDataForCC(cc);
    var d = getFlowDataForCC(cc);
    ["job", "looking", "study", "join", "all"].forEach(function(mr){
      var sum_in = 0, sum_out = 0;
      for (var i = fromYearIdx; i <= toYearIdx; i++ ) {
        sum_in += d["in"][mr][i];
        sum_out += d["out"][mr][i];
      }
      console.log(mr, {"in": sum_in, "out": sum_out, "balance": sum_in - sum_out, "sum": sum_in + sum_out});
    });
    
  };*/

  my.drawOrUpdateInOutFlowForSelectionByYears = function(args){
    var inOutGrp = svgMap.select("g#"+args.id);
    //var draw = false; //means update!
    if (inOutGrp.empty()){
      inOutGrp = svgMap.append("g").attr("class","chapter_flow_inout chapter_group").attr("id", args.id);
      args.selector.forEach(function(cc){
        var f = getFlowDataForCC(cc);
        var flowVals = getFlowValuesFromToYears(f, args.fromYearIdx, args.toYearIdx);
        // /console.log(flowVals);
        if(args.scaleMode && args.scaleMode === "aggregate") {
          var sw_in = calculateStrokeWidthByDirectionScaleAggregate(flowVals, 'in');
          var sw_out = calculateStrokeWidthByDirectionScaleAggregate(flowVals, 'out');

        } else if (args.scaleMode && args.scaleMode === "local"){
          var lNMin = Math.min(...localNetMin.slice(args.fromYearIdx, args.toYearIdx+1));
          var lNMax = Math.max(...localNetMax.slice(args.fromYearIdx, args.toYearIdx+1));

          //console.log(lNMin, lNMax);

          var sw_in = calculateStrokeWidthByDirectionScaleLocal(flowVals, 'in', lNMin, lNMax);
          var sw_out = calculateStrokeWidthByDirectionScaleLocal(flowVals, 'out', lNMin, lNMax);
        }else {
          var sw_in = calculateStrokeWidthByDirectionScaleGlobal(flowVals, 'in');
          var sw_out = calculateStrokeWidthByDirectionScaleGlobal(flowVals, 'out');
        }
        
        var offset_in = sw_in/2;
        var offset_out = -sw_out/2;
        //console.log(sw_in, sw_out);
        var inLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], offset_in + 2));
        var outLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], offset_out - 2));
        //console.log("INOUT", f, flowVals);
      
      var inPath = inOutGrp
        .append("path")
        .attr("class", "inPath")
        .attr("id", "inPath"+cc)
        .attr("d", inLine)
        .attr("fill", "none")
        .attr("stroke", "hsl(355, 80%, 50%)")
        .attr("stroke-linecap", "butt")
        .attr("stroke-width", sw_in)

      var lengthInPath = inPath.node().getTotalLength();
      var textInPos = inPath.node().getPointAtLength(lengthInPath);


      var outPath = inOutGrp
        .append("path")
        .attr("class", "outPath")
        .attr("id", "outPath"+cc)
        .attr("d", outLine)
        .attr("fill", "none")
        .attr("stroke", "hsl(215, 80%, 50%)")
        .attr("stroke-linecap", "butt")
        .attr("stroke-width", sw_out)

      var lengthOutPath = outPath.node().getTotalLength();
      var textOutPos = outPath.node().getPointAtLength(0);

      //console.log("draw", lengthInPath + lengthOutPath);

      var duration = 1000;//5 * (lengthInPath + lengthOutPath);
      inPath 
          .attr("stroke-dasharray", lengthInPath + " " + lengthInPath)
          .attr("stroke-dashoffset", lengthInPath)
          .transition()
            .duration(duration)
            .ease(d3.easeSin)
            .attr("stroke-dashoffset", 0)
            .on("end", (args.drawAnnotation != undefined && args.drawAnnotation == false) ? null : function(){
              var txt = inOutGrp.append("text")
                .attr("id", "annotationIn"+cc)
                .attr("transform", "translate(" + textInPos.x + " " +  textInPos.y + ")")
                .attr("text-anchor", "middle")
                .attr("alignment-baseline", "middle")
                .style("font-weight", "bolder")
                .text(format2SI(flowVals['in']))
              if(txt.node()){
                highlightSvgTextNoFadeOut(inOutGrp, txt.node(), "volumeAnnotation", "red")
              }
            });

      outPath 
          .attr("stroke-dasharray", lengthOutPath + " " + lengthOutPath)
          .attr("stroke-dashoffset", -lengthOutPath)
          .transition()
            .duration(duration)
            .ease(d3.easeSin)
            .attr("stroke-dashoffset", 0)
            .on("end", (args.drawAnnotation != undefined && args.drawAnnotation == false) ? null : function(){
              var txt = inOutGrp.append("text")
                .attr("id", "annotationOut"+cc)
                .attr("transform", "translate(" + textOutPos.x + " " +  textOutPos.y + ")")
                .attr("text-anchor", "middle")
                .attr("alignment-baseline", "middle")
                .style("font-weight", "bolder")
                .text(format2SI(flowVals['out']))
              if(txt.node()){
                highlightSvgTextNoFadeOut(inOutGrp, txt.node(), "volumeAnnotation", "blue")
              }
              
            });


      });
    } else {
      inOutGrp.selectAll("rect").remove();
      args.selector.forEach(function(cc){
        var f = getFlowDataForCC(cc);
        var flowVals = getFlowValuesFromToYears(f, args.fromYearIdx, args.toYearIdx);
        // /console.log(flowVals);
        if(args.scaleMode && args.scaleMode === "aggregate") {
          var sw_in = calculateStrokeWidthByDirectionScaleAggregate(flowVals, 'in');
          var sw_out = calculateStrokeWidthByDirectionScaleAggregate(flowVals, 'out');

        } else if (args.scaleMode && args.scaleMode === "local"){
          var lNMin = Math.min(...localNetMin.slice(args.fromYearIdx, args.toYearIdx+1));
          var lNMax = Math.max(...localNetMax.slice(args.fromYearIdx, args.toYearIdx+1));

          //console.log(lNMin, lNMax);

          var sw_in = calculateStrokeWidthByDirectionScaleLocal(flowVals, 'in', lNMin, lNMax);
          var sw_out = calculateStrokeWidthByDirectionScaleLocal(flowVals, 'out', lNMin, lNMax);
        }else {
          var sw_in = calculateStrokeWidthByDirectionScaleGlobal(flowVals, 'in');
          var sw_out = calculateStrokeWidthByDirectionScaleGlobal(flowVals, 'out');
        }

        var offset_in = sw_in/2;
        var offset_out = -sw_out/2;

        var inLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], (sw_in/2) + 2));
        var outLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], (-sw_out/2) - 2));

        var inPath = d3.select("#inPath"+cc)
          .attr("stroke-dasharray", "") //lengthInPath + " " + lengthInPath)
          .transition()
            .duration(200)
            .attr("d", inLine)
            .attr("stroke-width", sw_in)
            .on("end", function(){
              var lengthInPath = inPath.node().getTotalLength();
              var textInPos = inPath.node().getPointAtLength(lengthInPath);
              var txt = d3.select("#annotationIn"+cc)
                .attr("transform", "translate(" + textInPos.x + " " +  textInPos.y + ")")
                .text((format2SI(flowVals['in'])))
              if(txt.node()){
                highlightSvgTextNoFadeOut(inOutGrp, txt.node(), "volumeAnnotation", "red")
              }
            });

        

        var outPath = d3.select("#outPath"+cc)
          .attr("stroke-dasharray", "")
          .transition()
            .duration(200)
            .attr("d", outLine)
            .attr("stroke-width", sw_out)
            .on("end", function(){
              var textOutPos = outPath.node().getPointAtLength(0);
              var txt = d3.select("#annotationOut"+cc)
                .attr("transform", "translate(" + textOutPos.x + " " +  textOutPos.y + ")")
                .text((format2SI(flowVals['out'])))
              if(txt.node()){
                highlightSvgTextNoFadeOut(inOutGrp, txt.node(), "volumeAnnotation", "blue")
              }
            });
      });

    }


  
  }

  my.drawInOutFlowForSelectionByYears = function(args){
    var inOutGrp = svgMap.append("g").attr("class","chapter_flow_inout chapter_group").attr("id", args.id);
    args.selector.forEach(function(cc){
      var f = getFlowDataForCC(cc);
      var flowVals = getFlowValuesFromToYears(f, args.fromYearIdx, args.toYearIdx);
      // /console.log(flowVals);
      if(args.scaleMode && args.scaleMode === "aggregate") {
        var sw_in = calculateStrokeWidthByDirectionScaleAggregate(flowVals, 'in');
        var sw_out = calculateStrokeWidthByDirectionScaleAggregate(flowVals, 'out');

      } else if (args.scaleMode && args.scaleMode === "local"){
        var lNMin = Math.min(...localNetMin.slice(args.fromYearIdx, args.toYearIdx+1));
        var lNMax = Math.max(...localNetMax.slice(args.fromYearIdx, args.toYearIdx+1));

        //console.log(lNMin, lNMax);

        var sw_in = calculateStrokeWidthByDirectionScaleLocal(flowVals, 'in', lNMin, lNMax);
        var sw_out = calculateStrokeWidthByDirectionScaleLocal(flowVals, 'out', lNMin, lNMax);
      }else {
        var sw_in = calculateStrokeWidthByDirectionScaleGlobal(flowVals, 'in');
        var sw_out = calculateStrokeWidthByDirectionScaleGlobal(flowVals, 'out');
      }
      
      var offset_in = sw_in/2;
      var offset_out = -sw_out/2;
      //console.log(sw_in, sw_out);
      var inLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], offset_in + 2));
      var outLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], offset_out - 2));
      //console.log("INOUT", f, flowVals);
    
    var inPath = inOutGrp
      .append("path")
      .attr("class", "inPath")
      .attr("id", "inPath"+cc)
      .attr("d", inLine)
      .attr("fill", "none")
      .attr("stroke", "hsl(355, 80%, 50%)")
      .attr("stroke-linecap", "butt")
      .attr("stroke-width", sw_in)

    var lengthInPath = inPath.node().getTotalLength();
    var textInPos = inPath.node().getPointAtLength(lengthInPath);


    var outPath = inOutGrp
      .append("path")
      .attr("class", "outPath")
      .attr("id", "outPath"+cc)
      .attr("d", outLine)
      .attr("fill", "none")
      .attr("stroke", "hsl(215, 80%, 50%)")
      .attr("stroke-linecap", "butt")
      .attr("stroke-width", sw_out)

    var lengthOutPath = outPath.node().getTotalLength();
    var textOutPos = outPath.node().getPointAtLength(0);

    //console.log("draw", lengthInPath + lengthOutPath);

    var duration = 1000;//5 * (lengthInPath + lengthOutPath);
    inPath 
        .attr("stroke-dasharray", lengthInPath + " " + lengthInPath)
        .attr("stroke-dashoffset", lengthInPath)
        .transition()
          .duration(duration)
          .ease(d3.easeSin)
          .attr("stroke-dashoffset", 0)
          .on("end", (args.drawAnnotation != undefined && args.drawAnnotation == false) ? null : function(){
            var txt = inOutGrp.append("text")
              .attr("id", "annotationIn"+cc)
              .attr("transform", "translate(" + textInPos.x + " " +  textInPos.y + ")")
              .attr("text-anchor", "middle")
              .attr("alignment-baseline", "middle")
              .style("font-weight", "bolder")
              .text(format2SI(flowVals['in']))
            if(txt.node()){
              highlightSvgTextNoFadeOut(inOutGrp, txt.node(), "volumeAnnotation", "red")
            }
          });

    outPath 
        .attr("stroke-dasharray", lengthOutPath + " " + lengthOutPath)
        .attr("stroke-dashoffset", -lengthOutPath)
        .transition()
          .duration(duration)
          .ease(d3.easeSin)
          .attr("stroke-dashoffset", 0)
          .on("end", (args.drawAnnotation != undefined && args.drawAnnotation == false) ? null : function(){
            var txt = inOutGrp.append("text")
              .attr("id", "annotationOut"+cc)
              .attr("transform", "translate(" + textOutPos.x + " " +  textOutPos.y + ")")
              .attr("text-anchor", "middle")
              .attr("alignment-baseline", "middle")
              .style("font-weight", "bolder")
              .text(format2SI(flowVals['out']))
            if(txt.node()){
              highlightSvgTextNoFadeOut(inOutGrp, txt.node(), "volumeAnnotation", "blue")
            }
            
          });


    });



    
  };


  my.updateInOutFlowForSelectionByYears = function(args) {
    var inOutGrp = d3.select("#"+args.id)
    inOutGrp.selectAll("rect").remove();
    args.selector.forEach(function(cc){
      var f = getFlowDataForCC(cc);
      var flowVals = getFlowValuesFromToYears(f, args.fromYearIdx, args.toYearIdx);
      // /console.log(flowVals);
      var sw_in = calculateStrokeWidthByDirectionScaleGlobal(flowVals, 'in');
      var sw_out = calculateStrokeWidthByDirectionScaleGlobal(flowVals, 'out');
      var offset_in = sw_in/2;
      var offset_out = -sw_out/2;

      var inLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], (sw_in/2) + 2));
      var outLine = lineGenerator(moveLine([f.sp.x, f.sp.y], f.cp_moved, [f.ep.x, f.ep.y], (-sw_out/2) - 2));

      var inPath = d3.select("#inPath"+cc)
        .attr("stroke-dasharray", "") //lengthInPath + " " + lengthInPath)
        .transition()
          .duration(200)
          .attr("d", inLine)
          .attr("stroke-width", sw_in)
          .on("end", function(){
            var lengthInPath = inPath.node().getTotalLength();
            var textInPos = inPath.node().getPointAtLength(lengthInPath);
            var txt = d3.select("#annotationIn"+cc)
              .attr("transform", "translate(" + textInPos.x + " " +  textInPos.y + ")")
              .text((format2SI(flowVals['in'])))
            if(txt.node()){
              highlightSvgTextNoFadeOut(inOutGrp, txt.node(), "volumeAnnotation", "red")
            }
          });

      
      var outPath = d3.select("#outPath"+cc)
        .attr("stroke-dasharray", "")
        .transition()
          .duration(200)
          .attr("d", outLine)
          .attr("stroke-width", sw_out)
          .on("end", function(){
            var textOutPos = outPath.node().getPointAtLength(0);
            var txt = d3.select("#annotationOut"+cc)
              .attr("transform", "translate(" + textOutPos.x + " " +  textOutPos.y + ")")
              .text((format2SI(flowVals['out'])))
            if(txt.node()){
              highlightSvgTextNoFadeOut(inOutGrp, txt.node(), "volumeAnnotation", "blue")
            }
          });
    });
  };



  my.removeInOutFlowGroup = function(args){
    d3.select(args.selector).remove();
  };

  my.addYearButtonsToStoryText = function(args){
    d3.timeout(function(){
      var btnDiv = storyText.append("div");
      for (var i = args.fromYearIdx; i <= args.toYearIdx; i++ ) {
        btnDiv.append("button")
          .html(2000+i)
          .data([i])
          .style("background-color", (i == args.startIdx) ? "#999": "#eee")
          .on("click", function(d){
            //console.log(d);
            btnDiv.selectAll("button").style("background-color", "#eee");
            d3.select(this).style("background-color", "#999");
            my.updateInOutFlowForSelectionByYears({selector: [args.cc], id:args.id, delay: 0, duration: 1000, opacity: 1, fromYearIdx: d, toYearIdx: d})
          })
      } 
    }, args.delay);
    
  };



  my.shrinkAndMoveIcons = function() {
    shrinkAndMoveIcons(0);
  }

  my.highlightCountries = function(args) {
    svgMap.selectAll(args.selector).classed("selected", args.flag)
  };

  my.removeElement = function(args) {
    d3.selectAll(args.selector).remove(); //interrupt().transition().remove();
  }

  return my;

}());
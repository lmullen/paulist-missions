var map_width = $("#map").width();
var map_height = 500;
var chart_width = $("#chart-1").width();
var chart_height = 200;

var projection = d3.geo.albersUsa()
.scale(1000)
.translate([map_width / 2, map_height / 2]);

var path = d3.geo.path().projection(projection);

// Create the SVGs
var map_svg = d3.select("#map")
.append("svg")
.attr("width", map_width)
.attr("height", map_height);

var chart_1 = d3.select("#chart-1")
.append("svg")
.attr("width", chart_width)
.attr("height", chart_height);

var chart_2 = d3.select("#chart-2")
.append("svg")
.attr("width", chart_width)
.attr("height", chart_height);

var chart_3 = d3.select("#chart-3")
.append("svg")
.attr("width", chart_width)
.attr("height", chart_height);

queue()
.defer(d3.json, "state_1870.json")
.defer(d3.csv, "demographics-religion/data/paulist-chronicles/paulist-missions.aggregated.csv")
.defer(d3.csv, "demographics-religion/data/paulist-chronicles/paulist-summary.csv")
.await(ready);

function ready(error, state_1870, missions, summary) {
  map_svg.selectAll(".states")
  .data(topojson.feature(state_1870, state_1870.objects.states).features)
  .enter().append("path")
  .attr("class", function(d) { return "state " + d.id; })
  .attr("d", path);

  map_svg.append("path")
  .datum(topojson.mesh(state_1870, state_1870.objects.states))
  .attr("d", path)
  .attr("class", "border");

  map_svg.selectAll("circles.points")
  .data(missions)
  .enter()
  .append("circle")
  // .attr("r", function(d) {return 2 * Math.sqrt(d.converts)})
  .attr("r", 3)
  .attr("class","mission")
  .attr("transform", function(d) {return "translate(" + projection([d.long,d.lat]) + ")";});

  // Scales for charts
  var scale_1 = d3.scale.linear()
  .domain([0, d3.max(summary, function(d) {return +d.missions_total})])
  .range([0, chart_height]);

  var scale_2 = d3.scale.linear()
  .domain([0, d3.max(summary, function(d) {return +d.confessions})])
  .range([0, chart_height]);

  var scale_3 = d3.scale.linear()
  .domain([0, d3.max(summary, function(d) {return +d.converts})])
  .range([0, chart_height]);

  var bar_width = chart_width / summary.length;

  // Draw the charts
  chart_1.selectAll("rect")
  .data(summary)
  .enter()
  .append("rect")
  .attr("x", function(d, i) { return i * bar_width; })
  .attr("y", function(d, i) { return chart_height - scale_1(+d.missions_total); })
  .attr("width", bar_width)
  .attr("height", function(d, i) { return scale_1(+d.missions_total); })

  chart_2.selectAll("rect")
  .data(summary)
  .enter()
  .append("rect")
  .attr("x", function(d, i) { return i * bar_width; })
  .attr("y", function(d, i) { return chart_height - scale_2(+d.confessions); })
  .attr("width", bar_width)
  .attr("height", function(d, i) { return scale_2(+d.confessions); })

  chart_3.selectAll("rect")
  .data(summary)
  .enter()
  .append("rect")
  .attr("x", function(d, i) { return i * bar_width; })
  .attr("y", function(d, i) { return chart_height - scale_3(+d.converts); })
  .attr("width", bar_width)
  .attr("height", function(d, i) { return scale_3(+d.converts); })

  // Setup the slider to select the year
  $("#year-selector").slider({
    min: 1851,
    max: 1907,
    step: 1,
    slide: function ( event, ui ) {
      $("#current-year").text(ui.value);
      $("#all-checkbox").attr("checked", false);

      map_svg.selectAll(".mission")
      .data(missions)
      .classed("hidden", true)
      .filter(function(d) {
        return +d.year === ui.value;
      })
      .classed("hidden", false);

    }
  });

  $("#all-checkbox").click( function() {
    if ($("#all-checkbox").prop('checked')) {
      $("#current-year").text("1851-1907");
      map_svg.selectAll(".mission")
      .data(missions)
      .classed("hidden", false);
    } else {
      var current_year = $('#year-selector').slider("option", "value");
      $("#current-year").text(current_year);
      map_svg.selectAll(".mission")
      .data(missions)
      .classed("hidden", true)
      .filter(function(d) {
        return +d.year === current_year;
      })
      .classed("hidden", false);
    }
  });

}


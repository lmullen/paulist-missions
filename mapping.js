var width = $("#map").width();
var height = 500;
console.log(width);
console.log(height);

var projection = d3.geo.albersUsa()
.scale(1000)
.translate([width / 2, height / 2]);

var path = d3.geo.path().projection(projection);

var svg = d3.select("#map").append("svg")
.attr("width", width)
.attr("height", height);

queue()
.defer(d3.json, "state_1870.json")
.defer(d3.csv, "missions.csv")
.await(ready);

function ready(error, state_1870, missions) {
  svg.selectAll(".states")
  .data(topojson.feature(state_1870, state_1870.objects.states).features)
  .enter().append("path")
  .attr("class", function(d) { return "state " + d.id; })
  .attr("d", path);

  svg.append("path")
  .datum(topojson.mesh(state_1870, state_1870.objects.states))
  .attr("d", path)
  .attr("class", "border");

  svg.selectAll("circles.points")
  .data(missions)
  .enter()
  .append("circle")
  // .attr("r", function(d) {return 2 * Math.sqrt(d.converts)})
  .attr("r", 3)
  .attr("class","mission")
  .attr("transform", function(d) {return "translate(" + projection([d.lon,d.lat]) + ")";});

  // Setup the slider to select the year
  $("#year-selector").slider({
    min: 1851,
    max: 1907,
    step: 1,
    slide: function ( event, ui ) {
      $("#current-year").text(ui.value);
      $("#all-checkbox").attr("checked", false);

      svg.selectAll(".mission")
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
      svg.selectAll(".mission")
      .data(missions)
      .classed("hidden", false);
    } else {
      var current_year = $('#year-selector').slider("option", "value");
      $("#current-year").text(current_year);
      svg.selectAll(".mission")
      .data(missions)
      .classed("hidden", true)
      .filter(function(d) {
        return +d.year === current_year;
      })
      .classed("hidden", false);
    }
  });

}


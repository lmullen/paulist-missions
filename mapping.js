var width = window.innerWidth - 100;
var height = window.innerHeight - 100;

var projection = d3.geo.albersUsa()
.scale(1200)
.translate([width / 2, height / 2]);

var path = d3.geo.path().projection(projection);

var svg = d3.select("body").append("svg")
.attr("width", width)
.attr("height", height);


d3.json("state_1870.json", function(error, state_1870) {

  svg.selectAll(".states")
  .data(topojson.feature(state_1870, state_1870.objects.states).features)
  .enter().append("path")
  .attr("class", function(d) { return "state " + d.id; })
  .attr("d", path);

  svg.append("path")
  .datum(topojson.mesh(state_1870, state_1870.objects.states))
  .attr("d", path)
  .attr("class", "border");

  d3.csv("missions.csv", function(error, missions) {
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

        svg.selectAll(".mission")
        .data(missions)
        .classed("hidden", true)
        .filter(function(d) {
          return +d.year === ui.value;
        })
        .classed("hidden", false);
      }
    });

    // Set the initial value of the current year
    // $( "#current-year" ).text($( "#year-selector" ).slider("value"));



  });

});


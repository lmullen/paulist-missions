var width = window.innerWidth,
    height = 560;

var svg = d3.select("body").append("svg")
  .attr("width", width)
  .attr("height", height);


d3.json("state_1870.json", function(error, state_1870) {

  var subunits = topojson.feature(state_1870, state_1870.objects.states);

  var projection = d3.geo.albersUsa();

  var path = d3.geo.path().projection(projection);

  svg.append("path").datum(subunits).attr("d", path);

});


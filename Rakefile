task :shapefiles do
  sh "ogr2ogr -f GeoJSON geo.json \
  ~/research-data/nhgis-shapefiles/state_1870/US_state_1870.shp \
  -t_srs EPSG:4326"
  sh "topojson -o state_1870.json  \
  -- states=geo.json"
  sh "rm geo.json"
end


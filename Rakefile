task :shapefiles do
  sh "ogr2ogr -f GeoJSON geo.json \
  ~/research-data/nhgis-shapefiles/state_1870/US_state_1870.shp \
  -t_srs EPSG:4326"
  sh "topojson -o state_1870.json  \
  --id-property GISJOIN \
  -p name=STATENAM,gis=GISJOIN \
  -q 5e3 \
  --simplify-proportion 0.30 \
  -- states=geo.json"
  sh "rm geo.json"
end

desc "Run the development server"
task :server do
  sh "ruby -run -e httpd . -p 5000"
end 

desc "Push the project to lincolnmullen.com"
task :push do

  ssh_port       = "22"
  ssh_user       = "reclaim"
  rsync_delete   = true
  rsync_options  = "--progress --stats -avze"
  public_dir     = "." 
  document_root  = "~/public_html/lincolnmullen.com/projects/paulists-map"
  
  exclude = ""
  if File.exists?('./rsync-exclude')
    exclude = "--exclude-from '#{File.expand_path('./rsync-exclude')}'"
  end

  system("rsync #{rsync_options} 'ssh -p #{ssh_port}' #{exclude} #{"--delete" unless rsync_delete == false} #{public_dir}/ #{ssh_user}:#{document_root}")

end

# every 10.minutes do
#     command "cd /home/philnoug/RailsProjects/Disturbances/;rails scraper:go"
# end
  
every '*/10 5-23,0 * * *' do
    command "cd /home/philnoug/RailsProjects/Disturbances/;rails scraper:go"
end